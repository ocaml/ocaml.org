(* Codec for data/doc_modules.txt: the module paths of each package's
   documentation, scraped from the documentation backend by
   tool/doc-modules/scrape.sh.

   The file is not YAML: it holds tens of thousands of paths, and one line per
   package keeps it compact and its daily diffs readable. Each non-comment line
   is

   <name> <version> <Path> <Path> ...

   separated by single spaces, lines sorted by package name. The scraper writes
   it and the packer decodes it; [to_string] exists for the round-trip test and
   documents the format. Decoding is strict, so a malformed scrape fails the
   build rather than shipping. *)

open Data_intf.Doc_modules

let filename = "doc_modules.txt"
let ( let* ) = Result.bind

(* Characters opam allows in package names and versions. *)
let is_opam_char = function
  | 'a' .. 'z' | 'A' .. 'Z' | '0' .. '9' | '_' | '-' | '+' | '.' | '~' -> true
  | _ -> false

(* An OCaml module name: an uppercase letter, then letters, digits, '_' or
   '\''. *)
let is_module_name s =
  s <> ""
  && (match s.[0] with 'A' .. 'Z' -> true | _ -> false)
  && String.for_all
       (function
         | 'a' .. 'z' | 'A' .. 'Z' | '0' .. '9' | '_' | '\'' -> true
         | _ -> false)
       s

let is_module_path p = List.for_all is_module_name (String.split_on_char '.' p)

let header =
  {|# Module paths of each package's documentation, from the per-package
# sidebar.json of the documentation backend (ocaml-docs-ci). Package search
# uses them to answer "which package provides module X". Machine-managed:
# written by tool/doc-modules/scrape.sh and refreshed by the
# scrape-doc-modules.yml workflow. Do not edit by hand.
#
# One line per package: <name> <version> <module path>...
# Paths are capped per package (depth and count), shallowest first.
|}

let sort packages = List.sort (fun a b -> String.compare a.name b.name) packages

let to_string t =
  let b = Buffer.create (1024 * 1024) in
  Buffer.add_string b header;
  List.iter
    (fun p ->
      Buffer.add_string b (String.concat " " (p.name :: p.version :: p.modules));
      Buffer.add_char b '\n')
    (sort t);
  Buffer.contents b

let package_of_line ~lineno line =
  let error msg = Error (Printf.sprintf "line %d: %s" lineno msg) in
  match String.split_on_char ' ' line with
  | name :: version :: modules -> (
      if name = "" || not (String.for_all is_opam_char name) then
        error (Printf.sprintf "%S is not a package name" name)
      else if version = "" || not (String.for_all is_opam_char version) then
        error (Printf.sprintf "%S is not a version" version)
      else if modules = [] then error "no module paths"
      else
        match List.find_opt (fun m -> not (is_module_path m)) modules with
        | Some m -> error (Printf.sprintf "%S is not a module path" m)
        | None -> Ok { name; version; modules })
  | _ -> error "expected <name> <version> <module path>..."

let of_string s =
  let lines = String.split_on_char '\n' s in
  let* packages =
    List.fold_left
      (fun acc (lineno, line) ->
        let* acc = acc in
        if line = "" || line.[0] = '#' then Ok acc
        else
          let* p = package_of_line ~lineno line in
          Ok (p :: acc))
      (Ok [])
      (List.mapi (fun i l -> (i + 1, l)) lines)
  in
  let packages = List.rev packages in
  let rec check = function
    | a :: (b :: _ as rest) ->
        let c = String.compare a.name b.name in
        if c = 0 then Error (Printf.sprintf "duplicate package %S" a.name)
        else if c > 0 then
          Error
            (Printf.sprintf "%S after %S: lines must be sorted" b.name a.name)
        else check rest
    | _ -> Ok ()
  in
  let* () = check packages in
  Ok packages

let all () =
  let contents =
    match Utils.read_file (Fpath.v filename) with
    | Some s -> s
    | None -> raise (Exn.Decode_error ("data/" ^ filename ^ ": read failed"))
  in
  match of_string contents with
  | Ok t -> t
  | Error msg -> raise (Exn.Decode_error ("data/" ^ filename ^ ": " ^ msg))
