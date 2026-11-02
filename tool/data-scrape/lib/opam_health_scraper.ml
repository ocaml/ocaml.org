(* Scrape build results of opam packages from check.ci.ocaml.org
   (ocurrent/opam-health-check) into data/opam_health.yml (issue #3847).

   check.ci runs about once a week. The JSON API has every status of the latest
   run but no run id, which carries the opam-repository commit, the date and the
   key of every log URL. A small filtered HTML page carries the run id, so:

   1. read the run id from the filtered page; stop if it is already committed;
   2. download the JSON; 3. read the run id again and retry if a new run landed
   in between, so that one run's statuses are never committed under another
   run's id.

   Once ocurrent/opam-health-check#115 adds a JSON route with run provenance,
   step 1 can be dropped. *)

open Data_intf.Opam_health
module Codec = Data_packer.Opam_health_parser

let default_base_url = "https://check.ci.ocaml.org"
let default_file = "data/opam_health.yml"

(* A package that always has a row: a page with no rows has no run id. *)
let run_id_page base_url = base_url ^ "/?packages=dune&show-latest-only=true"
let api_url base_url = base_url ^ "/api/v1/latest/packages"

let run_id_re =
  Re.(
    compile
      (seq
         [
           str "/log/";
           group (seq [ rep1 digit; char '-'; repn xdigit 40 (Some 40) ]);
           char '/';
         ]))

let run_id_of_html html =
  Option.map (fun g -> Re.Group.get g 1) (Re.exec_opt run_id_re html)

(* JSON decoding, ported from Check.Json in ocaml/ocaml.org#977. The payload is
   [[{"name": "pkg.ver", "statuses": [{"compiler": "5.4", "status": "good"},
   ...]}, ...]]. *)
module Json = struct
  let ( let* ) = Result.bind

  let error kind json =
    Error
      (Printf.sprintf "unrecognized %s: %s" kind (Yojson.Safe.to_string json))

  let member name = function
    | `Assoc fields -> List.assoc_opt name fields
    | _ -> None

  let map_result f l =
    List.fold_right
      (fun x acc ->
        let* acc = acc in
        let* y = f x in
        Ok (y :: acc))
      l (Ok [])

  let to_build json =
    match (member "compiler" json, member "status" json) with
    | Some (`String compiler), Some (`String status) -> (
        match status_of_string status with
        | Some status -> Ok (compiler, status)
        | None -> Error (Printf.sprintf "unrecognized status: %S" status))
    | _ -> error "build" json

  let to_release json =
    match (member "name" json, member "statuses" json) with
    | Some (`String name), Some (`List builds) ->
        let* builds = map_result to_build builds in
        Ok (name, builds)
    | _ -> error "release" json

  let of_string s =
    match Yojson.Safe.from_string s with
    | `List releases -> map_result to_release releases
    | json -> error "payload" json
    | exception Yojson.Json_error msg -> Error ("invalid JSON: " ^ msg)
end

(* Turn the decoded JSON into the data type. The compilers are the union over
   all entries; an entry missing one of them is an error rather than a guess.
   Pre-release compilers ("5.6~alpha1", "trunk") are dropped: the newest
   compiler decides whether a package is up to date, and an alpha must not. Keys
   that are not a valid <name>.<version> are skipped with a warning. *)
let of_json ~run_id entries =
  let ( let* ) = Result.bind in
  let dropped =
    List.concat_map (fun (_, builds) -> List.map fst builds) entries
    |> List.filter (fun c -> not (Codec.is_release_compiler c))
    |> List.sort_uniq String.compare
  in
  if dropped <> [] then
    Printf.eprintf "[WARN] opam-health: ignoring pre-release compilers %s\n%!"
      (String.concat ", " dropped);
  let entries =
    List.map
      (fun (key, builds) ->
        (key, List.filter (fun (c, _) -> Codec.is_release_compiler c) builds))
      entries
  in
  let compilers =
    List.concat_map (fun (_, builds) -> List.map fst builds) entries
    |> List.sort_uniq compare_compiler
  in
  let* run = Codec.run_of_id ~compilers run_id in
  let* releases =
    Json.map_result
      (fun (key, builds) ->
        match Codec.release_of_key key with
        | Error msg ->
            Printf.eprintf "[WARN] opam-health: skipping %s\n%!" msg;
            Ok None
        | Ok (name, version) ->
            let* statuses =
              Json.map_result
                (fun c ->
                  match List.assoc_opt c builds with
                  | Some s -> Ok s
                  | None ->
                      Error
                        (Printf.sprintf "%s: no status for compiler %s" key c))
                compilers
            in
            Ok (Some { name; version; statuses }))
      entries
  in
  let releases = Codec.sort (List.filter_map Fun.id releases) in
  Ok { run; releases }

(* What changed between two snapshots, keyed by "name.version". *)
type diff = {
  compilers_changed : bool;
  added : string list;
  removed : string list;
  changed : (string * status list * status list) list;
}

let diff ~(old : t option) (t : t) =
  let table (t : t) =
    let h = Hashtbl.create 8192 in
    List.iter (fun r -> Hashtbl.replace h (Codec.key r) r.statuses) t.releases;
    h
  in
  match old with
  | None ->
      {
        compilers_changed = false;
        added = List.map Codec.key t.releases;
        removed = [];
        changed = [];
      }
  | Some old ->
      let o = table old and n = table t in
      let keys h = Hashtbl.fold (fun k _ acc -> k :: acc) h [] in
      let sorted l = List.sort String.compare l in
      {
        compilers_changed = old.run.compilers <> t.run.compilers;
        added = sorted (List.filter (fun k -> not (Hashtbl.mem o k)) (keys n));
        removed = sorted (List.filter (fun k -> not (Hashtbl.mem n k)) (keys o));
        changed =
          List.filter_map
            (fun r ->
              let k = Codec.key r in
              match Hashtbl.find_opt o k with
              | Some s
                when s <> r.statuses && old.run.compilers = t.run.compilers ->
                  Some (k, s, r.statuses)
              | _ -> None)
            t.releases;
      }

let date_of t =
  match Ptime.of_float_s t.run.timestamp with
  | Some p ->
      let y, m, d = Ptime.to_date p in
      Printf.sprintf "%04d-%02d-%02d" y m d
  | None -> "?"

let short_commit t = String.sub t.run.commit 0 7

let commit_message t =
  Printf.sprintf "[opam-health] check.ci run of %s (opam-repository %s)\n"
    (date_of t) (short_commit t)

let max_listed = 50

let report ~base_url ~(old : t option) t =
  let d = diff ~old t in
  let b = Buffer.create 4096 in
  let pr fmt = Printf.bprintf b fmt in
  pr
    "Build results from [check.ci.ocaml.org](%s/run/%s), run of %s against \
     opam-repository \
     [`%s`](https://github.com/ocaml/opam-repository/commit/%s).\n\n"
    base_url t.run.id (date_of t) (short_commit t) t.run.commit;
  pr "- %d package versions on compilers %s\n" (List.length t.releases)
    (String.concat ", " t.run.compilers);
  (match old with
  | Some old -> pr "- previous run: %s\n" old.run.id
  | None -> ());
  if d.compilers_changed then
    pr "- **the set of compilers changed**: every line of the file changed\n";
  pr "- %d added, %d removed, %d with a status change\n" (List.length d.added)
    (List.length d.removed) (List.length d.changed);
  let letters l =
    String.of_seq (List.to_seq (List.map Codec.status_to_char l))
  in
  if d.changed <> [] then (
    pr "\n### Status changes (%s)\n\n" (String.concat " " t.run.compilers);
    List.iteri
      (fun i (k, o, n) ->
        if i < max_listed then
          pr "- `%s`: `%s` → `%s`\n" k (letters o) (letters n))
      d.changed;
    if List.length d.changed > max_listed then
      pr "- … and %d more\n" (List.length d.changed - max_listed));
  let list title l =
    if l <> [] && old <> None then (
      pr "\n### %s\n\n" title;
      List.iteri (fun i k -> if i < max_listed then pr "- `%s`\n" k) l;
      if List.length l > max_listed then
        pr "- … and %d more\n" (List.length l - max_listed))
  in
  list "Added" d.added;
  list "Removed" d.removed;
  Buffer.contents b

let read_file path = In_channel.with_open_bin path In_channel.input_all

let write_file path contents =
  Out_channel.with_open_bin path (fun oc ->
      Out_channel.output_string oc contents)

let previous file =
  if not (Sys.file_exists file) then None
  else
    match Codec.of_string (read_file file) with
    | Ok t -> Some t
    | Error msg ->
        Printf.eprintf "[WARN] opam-health: ignoring unreadable %s: %s\n%!" file
          msg;
        None

let fetch_run_id base_url =
  let url = run_id_page base_url in
  match run_id_of_html (Http_client.get_sync (Uri.of_string url)) with
  | Some id -> id
  | None -> failwith ("no run id found in " ^ url)

type outcome = Unchanged of string | Updated of t

let fetch ?(attempts = 3) ~base_url ~(old : t option) () =
  let rec go n =
    let run_id = fetch_run_id base_url in
    if Some run_id = Option.map (fun t -> t.run.id) old then Unchanged run_id
    else
      let json = Http_client.get_sync (Uri.of_string (api_url base_url)) in
      let run_id' = fetch_run_id base_url in
      if run_id <> run_id' then
        if n > 1 then (
          Printf.eprintf
            "[WARN] opam-health: run changed during download, retrying\n%!";
          go (n - 1))
        else failwith "check.ci run id kept changing during download"
      else
        match Result.bind (Json.of_string json) (of_json ~run_id) with
        | Ok t -> Updated t
        | Error msg -> failwith ("decoding " ^ api_url base_url ^ ": " ^ msg)
  in
  go attempts

let scrape ?(base_url = default_base_url) ?(file = default_file) ?commit_file
    ?report_file () =
  let old = previous file in
  match fetch ~base_url ~old () with
  | Unchanged run_id ->
      Printf.printf "opam-health: run %s already committed, nothing to do\n"
        run_id;
      Option.iter
        (fun p -> write_file p "[opam-health] No new check.ci run\n")
        commit_file;
      Option.iter (fun p -> write_file p "No new check.ci run.\n") report_file
  | Updated t ->
      write_file file (Codec.to_string t);
      Printf.printf "opam-health: wrote %d package versions from run %s to %s\n"
        (List.length t.releases) t.run.id file;
      Option.iter (fun p -> write_file p (commit_message t)) commit_file;
      Option.iter (fun p -> write_file p (report ~base_url ~old t)) report_file
