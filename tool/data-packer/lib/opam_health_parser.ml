(* Codec for data/opam_health.yml: build results of opam packages from
   check.ci.ocaml.org (opam-health-check).

   The packer decodes the file into the blob; the scraper in tool/data-scrape
   encodes it, and decodes the previous version to skip unchanged runs and to
   report what changed. Keeping both directions here guarantees they agree.

   One line per package-version keeps weekly diffs small (about 90 lines for a
   typical run). Every scalar is double-quoted so that YAML never coerces a
   status string such as "N" or a key such as "1.0" into a boolean or float. *)

open Data_intf.Opam_health

let filename = "opam_health.yml"
let ( let* ) = Result.bind

let status_to_char = function
  | Good -> 'G'
  | Partial -> 'P'
  | Bad -> 'B'
  | Not_available -> 'N'
  | Internal_failure -> 'I'

let status_of_char = function
  | 'G' -> Some Good
  | 'P' -> Some Partial
  | 'B' -> Some Bad
  | 'N' -> Some Not_available
  | 'I' -> Some Internal_failure
  | _ -> None

let is_digit = function '0' .. '9' -> true | _ -> false
let is_hex = function '0' .. '9' | 'a' .. 'f' -> true | _ -> false

(* A run id is "<unix timestamp>-<40-hex opam-repository commit>". *)
let run_of_id ~compilers id =
  let error () =
    Error
      (Printf.sprintf
         "run id %S: expected <unix timestamp>-<40-hex opam-repository commit>"
         id)
  in
  match String.index_opt id '-' with
  | None -> error ()
  | Some i ->
      let ts = String.sub id 0 i in
      let commit = String.sub id (i + 1) (String.length id - i - 1) in
      if
        ts = ""
        || (not (String.for_all is_digit ts))
        || String.length commit <> 40
        || not (String.for_all is_hex commit)
      then error ()
      else Ok { id; timestamp = float_of_string ts; commit; compilers }

(* Characters opam allows in package names and versions. Anything else is
   rejected so that keys can be written inside double quotes verbatim. *)
let is_opam_char = function
  | 'a' .. 'z' | 'A' .. 'Z' | '0' .. '9' | '_' | '-' | '+' | '.' | '~' -> true
  | _ -> false

(* "name.version": opam package names never contain a dot. *)
let release_of_key key =
  match String.index_opt key '.' with
  | Some i
    when i > 0 && i < String.length key - 1 && String.for_all is_opam_char key
    ->
      Ok (String.sub key 0 i, String.sub key (i + 1) (String.length key - i - 1))
  | _ -> Error (Printf.sprintf "%S is not a valid <name>.<version>" key)

let key r = r.name ^ "." ^ r.version

let sort releases =
  List.sort (fun a b -> String.compare (key a) (key b)) releases

(* A released compiler: "5.4", not "5.5~alpha1" or "trunk". *)
let is_release_compiler c =
  c <> "" && String.for_all (fun c -> is_digit c || c = '.') c

let check_compilers compilers =
  let sorted = List.sort_uniq compare_compiler compilers in
  if compilers = [] then Error "compilers: empty list"
  else if sorted <> compilers then
    Error "compilers: must be distinct and in ascending order"
  else if not (List.for_all is_release_compiler compilers) then
    Error "compilers: expected versions such as \"5.4\""
  else Ok ()

let header =
  {|# Build results of opam packages from https://check.ci.ocaml.org
# (opam-health-check), latest run. Machine-managed: written by
# `make scrape_opam_health` (tool/data-scrape) and refreshed by the
# scrape-opam-health.yml workflow. Do not edit by hand.
#
# `packages` maps each "<name>.<version>" to one status letter per compiler,
# in the order of `compilers`:
#   G good: the package built successfully
#   P partial: one of its dependencies failed to build
#   B bad: the package failed to build
#   N not available: the package is not available with this compiler
#   I internal failure: the check itself failed
|}

let to_string t =
  let b = Buffer.create (64 * 1024) in
  Buffer.add_string b header;
  Printf.bprintf b "run: \"%s\"\n" t.run.id;
  Printf.bprintf b "compilers: [%s]\n"
    (String.concat ", " (List.map (Printf.sprintf "\"%s\"") t.run.compilers));
  Buffer.add_string b "packages:\n";
  List.iter
    (fun r ->
      Printf.bprintf b "  \"%s\": \"%s\"\n" (key r)
        (String.of_seq (List.to_seq (List.map status_to_char r.statuses))))
    (sort t.releases);
  Buffer.contents b

let string_field name = function
  | `String s -> Ok s
  | _ -> Error (Printf.sprintf "%s: expected a string" name)

let release_of_entry ~width (k, v) =
  let* name, version = release_of_key k in
  let* letters = string_field k v in
  if String.length letters <> width then
    Error
      (Printf.sprintf "%s: %S has %d statuses, expected one per compiler (%d)" k
         letters (String.length letters) width)
  else
    let* statuses =
      List.fold_right
        (fun c acc ->
          let* acc = acc in
          match status_of_char c with
          | Some s -> Ok (s :: acc)
          | None -> Error (Printf.sprintf "%s: unknown status letter %C" k c))
        (List.of_seq (String.to_seq letters))
        (Ok [])
    in
    Ok { name; version; statuses }

let rec check_unique = function
  | a :: (b :: _ as rest) ->
      if key a = key b then Error (Printf.sprintf "duplicate entry %S" (key a))
      else check_unique rest
  | _ -> Ok ()

let of_yaml = function
  | `O fields ->
      let field name =
        Option.to_result
          ~none:(Printf.sprintf "missing top-level key %S" name)
          (List.assoc_opt name fields)
      in
      let* id = Result.bind (field "run") (string_field "run") in
      let* compilers =
        match field "compilers" with
        | Ok (`A l) ->
            List.fold_right
              (fun v acc ->
                let* acc = acc in
                let* c = string_field "compilers" v in
                Ok (c :: acc))
              l (Ok [])
        | Ok _ -> Error "compilers: expected a list"
        | Error e -> Error e
      in
      let* () = check_compilers compilers in
      let* run = run_of_id ~compilers id in
      let* entries =
        match field "packages" with
        | Ok (`O entries) -> Ok entries
        | Ok _ -> Error "packages: expected a mapping"
        | Error e -> Error e
      in
      let width = List.length compilers in
      let* releases =
        List.fold_left
          (fun acc e ->
            let* acc = acc in
            let* r = release_of_entry ~width e in
            Ok (r :: acc))
          (Ok []) entries
      in
      let releases = sort releases in
      let* () = check_unique releases in
      Ok { run; releases }
  | _ -> Error "expected a mapping at the top level"

let of_string s =
  match Yaml.of_string s with
  | Error (`Msg m) -> Error m
  | Ok yaml -> of_yaml yaml

let all () =
  let contents =
    match Utils.read_file (Fpath.v filename) with
    | Some s -> s
    | None -> raise (Exn.Decode_error ("data/" ^ filename ^ ": read failed"))
  in
  match of_string contents with
  | Ok t -> t
  | Error msg -> raise (Exn.Decode_error ("data/" ^ filename ^ ": " ^ msg))
