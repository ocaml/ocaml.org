(* Repository input files consulted by the generator, beyond git itself: the
   blame-ignore list, the external-sources manifest, and per-document overrides.
   All are optional and start empty/minimal for the initial seed. *)

let read_file path =
  match Bos.OS.File.read (Fpath.v path) with Ok s -> Some s | Error _ -> None

let read_yaml path =
  match read_file path with
  | None -> None
  | Some s -> ( match Yaml.of_string s with Ok v -> Some v | Error _ -> None)

let yaml_strings = function
  | `A items ->
      List.filter_map (function `String s -> Some s | _ -> None) items
  | _ -> []

let yaml_find key = function
  | `O fields -> List.assoc_opt key fields
  | _ -> None

(* --- .git-blame-ignore-revs: full SHAs of mechanical mass-touch commits --- *)

type ignore_revs = (string, unit) Hashtbl.t

let load_ignore_revs ?(path = ".git-blame-ignore-revs") () : ignore_revs =
  let tbl = Hashtbl.create 64 in
  (match read_file path with
  | None -> ()
  | Some s ->
      String.split_on_char '\n' s
      |> List.iter (fun line ->
             let line = String.trim line in
             if line <> "" && not (String.length line > 0 && line.[0] = '#')
             then Hashtbl.replace tbl line ()));
  tbl

let is_ignored (tbl : ignore_revs) hash = Hashtbl.mem tbl hash

(* --- attribution/sources.yml: external source key -> authors --- *)

type sources = (string, string list) Hashtbl.t

let load_sources ?(path = "attribution/sources.yml") () : sources =
  let tbl = Hashtbl.create 16 in
  (match read_yaml path with
  | Some (`O entries) ->
      List.iter
        (fun (key, v) ->
          match yaml_find "authors" v with
          | Some authors -> Hashtbl.replace tbl key (yaml_strings authors)
          | None -> Hashtbl.replace tbl key [])
        entries
  | _ -> ());
  tbl

let source_authors (tbl : sources) key =
  Option.value ~default:[] (Hashtbl.find_opt tbl key)

(* --- attribution/imports.yml: recover authorship from an imported-from repo --

   ocaml.org v3 imported many tutorials from the earlier site (v2.ocaml.org) in
   2023, which dropped their pre-import git authorship. This manifest maps each
   such document to its path in a local clone of that repo, so the generator can
   mine the real history and fold those contributors in. Optionally a mapping
   carries `derived_from` for provenance older still than that repo's history
   (e.g. the ocaml-tutorial.org wiki it was itself copied from). *)

type imports = {
  repo : string; (* the source repo, a path relative to the v3 root *)
  map : (string, string * string list) Hashtbl.t;
      (* v3 path -> (path in the source repo, derived_from) *)
}

let load_imports ?(path = "attribution/imports.yml") () : imports option =
  match read_yaml path with
  | Some v -> (
      match (yaml_find "repo" v, yaml_find "mappings" v) with
      | Some (`String repo), Some (`A items) ->
          let map = Hashtbl.create 32 in
          List.iter
            (fun item ->
              match (yaml_find "v3" item, yaml_find "v2" item) with
              | Some (`String v3), Some (`String v2) ->
                  let df =
                    match yaml_find "derived_from" item with
                    | Some l -> yaml_strings l
                    | None -> []
                  in
                  Hashtbl.replace map v3 (v2, df)
              | _ -> ())
            items;
          Some { repo; map }
      | _ -> None)
  | None -> None

let import_of (imports : imports option) v3path =
  match imports with Some i -> Hashtbl.find_opt i.map v3path | None -> None

let repo_present (imports : imports option) =
  match imports with
  | Some i -> Sys.file_exists (Filename.concat i.repo ".git")
  | None -> false

(* --- attribution/overrides/<path>.yml: per-document manual corrections --- *)

type override = {
  add : string list; (* extra contributor names to credit *)
  exclude_commits : string list; (* hashes to drop before aggregation *)
  derived_from : string list;
      (* provenance the git history can't carry: "source:<key>" (external,
         resolved via the sources manifest) or "path@commit" (internal). For
         imports whose commits predate any Derived-from trailer convention. *)
  notes : string option;
}

let empty_override =
  { add = []; exclude_commits = []; derived_from = []; notes = None }

let load_override ~doc_path () : override =
  let path = "attribution/overrides/" ^ doc_path ^ ".yml" in
  match read_yaml path with
  | None -> empty_override
  | Some v ->
      let add =
        match yaml_find "add" v with
        | Some (`A items) ->
            List.filter_map
              (fun item ->
                match yaml_find "name" item with
                | Some (`String n) -> Some n
                | _ -> None)
              items
        | _ -> []
      in
      let exclude_commits =
        match yaml_find "exclude_commits" v with
        | Some l -> yaml_strings l
        | None -> []
      in
      let derived_from =
        match yaml_find "derived_from" v with
        | Some l -> yaml_strings l
        | None -> []
      in
      let notes =
        match yaml_find "notes" v with Some (`String n) -> Some n | _ -> None
      in
      { add; exclude_commits; derived_from; notes }
