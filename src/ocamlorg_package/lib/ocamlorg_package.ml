module Import = Import
open Import
include Package
module Info = Info
module Statistics = Packages_stats
module Publication_dates = Publication_dates
open Package

(* The latest version of a package, with the fields search matches on
   case-folded once, instead of on every query. *)
type search_entry = {
  package : t;
  folded_name : string;
  folded_synopsis : string;
  folded_description : string;
  folded_tags : string list;
  folded_authors : string list;
  rev_deps_count : int;
}

(* When this type changes, [Info.version] needs to be incremented to invalidate
   the cache *)
type state = {
  version : string;
  mutable opam_repository_commit : string option;
  mutable packages : Info.t Version.Map.t Name.Map.t;
  mutable stats : Statistics.t option;
  docs : Documentation.doc_cache;
  mutable search_index :
    (Info.t Version.Map.t Name.Map.t * search_entry list) option;
      (** Not persisted: built by [search] from the [packages] it is paired
          with, and rebuilt once [packages] is replaced. *)
}

(* Persisted projection of [state]: the [docs] runtime cache is excluded (it
   holds a function, a [Hashtbl] and a [Queue], and is rebuilt empty on load),
   so only the four durable fields are serialized, via [repr]. Kept in a
   submodule so its record labels don't shadow [state]'s. *)
module Snapshot = struct
  let packages_repr =
    Opam_repr.map ~empty:Name.Map.empty ~add:Name.Map.add
      ~bindings:Name.Map.bindings Opam_repr.name
      (Opam_repr.map ~empty:Version.Map.empty ~add:Version.Map.add
         ~bindings:Version.Map.bindings Opam_repr.version Info.t)

  type t = {
    version : string;
    opam_repository_commit : string option;
    packages : (Info.t Version.Map.t Name.Map.t[@repr packages_repr]);
    stats : Statistics.t option;
  }
  [@@deriving repr]
end

let mockup_state (pkgs : t list) =
  let map = Name.Map.empty in
  let add_version (pkg : t) map =
    let new_map =
      match Name.Map.find_opt pkg.name map with
      | None -> Version.Map.(add pkg.version pkg.info empty)
      | Some version_map -> Version.Map.add pkg.version pkg.info version_map
    in
    Name.Map.add pkg.name new_map map
  in
  let packages = List.fold_left (fun map v -> add_version v map) map pkgs in
  {
    version = Info.version;
    packages;
    opam_repository_commit = None;
    stats = None;
    docs = Documentation.doc_cache_create ();
    search_index = None;
  }

let read_versions package_name versions =
  List.fold_left
    (fun acc package_version ->
      match OpamPackage.of_string_opt package_version with
      | Some pkg -> (
          match Opam_repository.opam_file package_name package_version with
          | Ok opam -> Version.Map.add pkg.version opam acc
          | Error reason ->
              Logs.err (fun m ->
                  m "Failed to read opam file for %S %s: %s" package_name
                    package_version reason);
              acc)
      | None ->
          Logs.err (fun m ->
              m "Invalid package version %S for %S" package_version package_name);
          acc)
    Version.Map.empty versions

let read_packages () =
  let open Lwt.Syntax in
  let t0 = Unix.gettimeofday () in
  let packages_and_versions = Opam_repository.list_packages_and_versions () in
  let t1 = Unix.gettimeofday () in
  Logs.info (fun log -> log "List packages: %.2fs" (t1 -. t0));
  let+ result =
    Lwt_list.fold_left_s
      (fun acc (package_name, versions) ->
        match Name.of_string package_name with
        | exception ex ->
            Logs.err (fun m ->
                m "Invalid package name %S: %s" package_name
                  (Printexc.to_string ex));
            Lwt.return acc
        | name ->
            (* Reading is synchronous, so yield between packages. *)
            let+ () = Lwt.pause () in
            let versions = read_versions package_name versions in
            (* A name with no readable version would have no entry in the
               package index, and no latest version for the statistics. *)
            if Version.Map.is_empty versions then (
              Logs.err (fun m ->
                  m "No readable version of %S: skipping it" package_name);
              acc)
            else Name.Map.add name versions acc)
      Name.Map.empty packages_and_versions
  in
  let t2 = Unix.gettimeofday () in
  Logs.info (fun log -> log "Read opam files: %.2fs" (t2 -. t1));
  result

let to_snapshot t : Snapshot.t =
  {
    version = t.version;
    opam_repository_commit = t.opam_repository_commit;
    packages = t.packages;
    stats = t.stats;
  }

(* [docs] and [search_index] are not persisted; they are runtime caches, rebuilt
   empty here. *)
let of_snapshot (v : Snapshot.t) =
  {
    version = v.version;
    opam_repository_commit = v.opam_repository_commit;
    packages = v.packages;
    stats = v.stats;
    docs = Documentation.doc_cache_create ();
    search_index = None;
  }

let load_state_from state_path =
  let exception Invalid_version in
  Logs.info (fun m -> m "State cache file: %s" (Fpath.to_string state_path));
  try
    let channel = open_in_bin (Fpath.to_string state_path) in
    Fun.protect
      (fun () ->
        let s = really_input_string channel (in_channel_length channel) in
        let v =
          match Repr.(unstage (of_bin_string Snapshot.t)) s with
          | Ok v -> v
          | Error (`Msg _) -> raise Invalid_version
        in
        if Info.version <> v.Snapshot.version then raise Invalid_version;
        Logs.info (fun f ->
            f "Package state loaded (%d packages, opam commit %s)"
              (Name.Map.cardinal v.Snapshot.packages)
              (Option.value ~default:"" v.Snapshot.opam_repository_commit));
        of_snapshot v)
      ~finally:(fun () -> close_in channel)
  with Failure _ | Sys_error _ | Invalid_version | End_of_file ->
    Logs.info (fun f -> f "Package state starting from scratch");
    {
      opam_repository_commit = None;
      version = Info.version;
      packages = Name.Map.empty;
      stats = None;
      docs = Documentation.doc_cache_create ();
      search_index = None;
    }

let try_load_state () = load_state_from Config.package_state_path

(* Write in place, not to a temporary file renamed over [state_path]: in the
   Docker image, [state_path] is [/var/package.state], owned by the server's
   user in a directory it can't write to, and [init-cache] waits for the
   build-time state with [inotifywait -e close_write] on the file itself. An
   interrupted write leaves a truncated file, which [load_state_from] reads as
   an empty state. *)
let write_snapshot state_path (snapshot : Snapshot.t) =
  let content = Repr.(unstage (to_bin_string Snapshot.t)) snapshot in
  Out_channel.with_open_bin (Fpath.to_string state_path) (fun channel ->
      Out_channel.output_string channel content)

let save_state_to state_path t =
  write_snapshot state_path (to_snapshot t);
  Logs.info (fun f -> f "Package state saved")

(* Serializing the state takes about 0.12s, which would stall every request on
   the event loop. The snapshot is immutable, so it is taken here, then
   serialized and written in a system thread. Not in a domain: once a domain has
   been spawned, OCaml 5 refuses [Unix.fork] for the rest of the process, and
   every Git call goes through [Lwt_process], which forks. *)
let save_state_in_background_to state_path t =
  let open Lwt.Syntax in
  let snapshot = to_snapshot t in
  let+ () =
    Lwt_preemptive.detach (fun () -> write_snapshot state_path snapshot) ()
  in
  Logs.info (fun f -> f "Package state saved")

let save_state t = save_state_in_background_to Config.package_state_path t
let has_flag flag (info : Info.t) = List.exists (( = ) flag) info.flags

let is_discouraged info =
  has_flag OpamTypes.Pkgflag_AvoidVersion info
  || has_flag OpamTypes.Pkgflag_Deprecated info

let select_latest versions =
  let _, preferred = Version.Map.partition (fun _ -> is_discouraged) versions in
  match Version.Map.max_binding_opt preferred with
  | Some package -> Some package
  | None -> Version.Map.max_binding_opt versions

let get_latest' packages name =
  Option.bind (Name.Map.find_opt name packages) (fun versions ->
      select_latest versions
      |> Option.map (fun (version, info) -> { version; info; name }))

let time_it_lwt name f =
  let open Lwt.Syntax in
  let t0 = Unix.gettimeofday () in
  let+ result = f () in
  let t1 = Unix.gettimeofday () in
  Logs.info (fun log -> log "%s: %.2fs" name (t1 -. t0));
  result

let update ~commit t =
  let open Lwt.Syntax in
  Logs.info (fun m -> m "Opam repository is currently at %s" commit);
  Logs.info (fun m -> m "Updating opam package list");
  let* packages = time_it_lwt "Read packages" (fun () -> read_packages ()) in
  let* timestamps =
    time_it_lwt "Publication dates" (fun () ->
        Publication_dates.compute
          ~previous:(t.opam_repository_commit, t.packages)
          ~commit packages)
  in
  let* packages =
    time_it_lwt "Compute package info" (fun () ->
        Info.of_opamfiles ~timestamps packages)
  in
  let+ stats =
    time_it_lwt "Compute statistics" (fun () -> Statistics.compute packages)
  in
  (* Record [commit] only once its data is in place: [maybe_update] skips the
     rebuild when the commit is unchanged, so setting it before a rebuild that
     then raises would leave stale packages that are never retried. *)
  t.packages <- packages;
  t.stats <- Some stats;
  t.opam_repository_commit <- Some commit;
  Logs.info (fun m -> m "Loaded %d packages" (Name.Map.cardinal packages))

let maybe_update t commit =
  let open Lwt.Syntax in
  match t.opam_repository_commit with
  | Some v when v = commit -> Lwt.return ()
  | _ ->
      Logs.info (fun m -> m "Update server state");
      let* () = update ~commit t in
      save_state t

(* Bring the opam-repository clone up to date (cloning it if it is missing) and
   rebuild the package state if needed. Never raises: a failure is logged and
   the next poll retries, cloning again if the first clone failed. *)
let sync v =
  let open Lwt.Syntax in
  Lwt.catch
    (fun () ->
      let* commit =
        if Opam_repository.exists () then (
          Logs.info (fun m -> m "Opam repo: git pull");
          Opam_repository.pull ())
        else (
          Logs.info (fun m -> m "Opam repo: git clone");
          Opam_repository.clone ())
      in
      maybe_update v commit)
    (fun exn ->
      Logs.err (fun m ->
          m "Failed to update the opam package list: %s"
            (Printexc.to_string exn));
      Lwt.return ())

let rec poll_for_opam_packages ~polling v =
  let open Lwt.Syntax in
  let* () = Lwt_unix.sleep (float_of_int polling) in
  let* () = sync v in
  poll_for_opam_packages ~polling v

(* The first sync must not raise either: an exception escaping [Lwt.async]
   reaches [Lwt.async_exception_hook], which exits the process until Dream
   replaces it on the first request, and would in any case kill this task before
   polling starts. *)
let init ?(disable_polling = false) () =
  let open Lwt.Syntax in
  let state = try_load_state () in
  Lwt.async (fun () ->
      let* () = sync state in
      if disable_polling then Lwt.return_unit
      else poll_for_opam_packages ~polling:Config.opam_polling state);
  state

let all_latest t =
  t.packages |> Name.Map.bindings
  |> List.filter_map (fun (name, versions) ->
         select_latest versions
         |> Option.map (fun (version, info) -> { name; version; info }))

let stats t = t.stats

let get_by_name t name =
  t.packages |> Name.Map.find_opt name
  |> Option.map Version.Map.bindings
  |> Option.map (List.map (fun (version, info) -> { name; version; info }))

type version_status = Avoided | Deprecated

type version_summary = {
  version : Version.t;
  opam_repository_date : float;
  statuses : version_status list;
}

let version_statuses info =
  let status flag value statuses =
    if has_flag flag info then value :: statuses else statuses
  in
  []
  |> status OpamTypes.Pkgflag_Deprecated Deprecated
  |> status OpamTypes.Pkgflag_AvoidVersion Avoided

let get_versions t name =
  t.packages |> Name.Map.find_opt name
  |> Option.map (fun p ->
         p |> Version.Map.bindings
         |> List.map (fun (version, info) ->
                {
                  version;
                  opam_repository_date = info.Info.publication;
                  statuses = version_statuses info;
                }))
  |> Option.value ~default:[]
  |> List.sort (fun v1 v2 -> Version.compare v2.version v1.version)

let get_latest t name = get_latest' t.packages name

let get t name version =
  t.packages |> Name.Map.find_opt name |> fun x ->
  Option.bind x (Version.Map.find_opt version)
  |> Option.map (fun info -> { version; info; name })

module Package_info = Package_info

let doc_exists t name version =
  let package = get t name version in
  let open Lwt.Syntax in
  match package with
  | None -> Lwt.return None
  | Some package -> (
      let* doc_stat = Documentation.status ~kind:`Package t.docs package in
      match doc_stat with
      | Some { failed = false; _ } -> Lwt.return (Some version)
      | _ -> Lwt.return None)

let latest_documented_version t name =
  let rec aux fuel vlist =
    let open Lwt.Syntax in
    match vlist with
    | [] -> Lwt.return None
    | _ when fuel <= 0 ->
        (* Give up rather than probe every version: on a cold cache each step is
           one sequential status.json fetch against the docs backend. See
           ocaml/ocaml.org#3888. *)
        Lwt.return None
    | _ -> (
        let version = List.hd vlist in
        let* doc = doc_exists t name version in
        match doc with
        | Some version -> Lwt.return (Some version)
        | None -> aux (fuel - 1) (List.tl vlist))
  in
  match get_versions t name with
  | [] -> Lwt.return None
  | vlist ->
      aux Config.latest_documented_version_depth
        (vlist |> List.map (fun v -> v.version))

let is_latest_version t name version =
  match get_latest t name with
  | None -> false
  | Some pkg -> pkg.version = version

module Search : sig
  type search_request

  val to_request : string -> search_request

  val match_request :
    is_author_match:(string -> string -> bool) ->
    search_request ->
    search_entry ->
    bool

  val relevance : search_request -> search_entry -> float
  (** Higher is better. *)

  val relevance_by_popularity : search_request -> search_entry -> float
  (** [relevance], weighted by the number of reverse dependencies. *)
end = struct
  type search_constraint =
    | Tag of string
    | Name of string
    | Synopsis of string
    | Description of string
    | Author of string
    | Any of string

  type search_request = search_constraint list

  let re =
    let notnl_no_quote = Re.rep1 @@ Re.diff Re.notnl @@ Re.set "\"" in
    let unquoted = Re.group @@ Re.rep1 @@ Re.diff Re.notnl @@ Re.set " \"" in
    let quoted = Re.seq [ Re.str "\""; Re.group notnl_no_quote; Re.str "\"" ] in
    let option name =
      Re.seq [ Re.group @@ Re.str name; Re.alt [ quoted; unquoted ] ]
    in
    let tag = option "tag:"
    and author = option "author:"
    and synopsis = option "synopsis:"
    and description = option "description:"
    and name = option "name:"
    and plain = option "" in
    let atom = Re.alt [ name; author; tag; synopsis; description; plain ] in
    Re.compile atom

  let to_request str =
    let str = Ocamlorg.Import.String.fold str in
    let to_constraint = function
      | [ _; s ] -> Any s
      | [ _; "tag:"; s ] -> Tag s
      | [ _; "author:"; s ] -> Author s
      | [ _; "synopsis:"; s ] -> Synopsis s
      | [ _; "description:"; s ] -> Description s
      | [ _; "name:"; s ] -> Name s
      | _ -> Any str
    in
    let g = Re.all re str in
    List.map
      (fun g ->
        Re.Group.all g |> Array.to_list
        |> List.filter (fun a -> not (String.equal a ""))
        |> to_constraint)
      g

  (* The entry's fields are already case-folded, like the pattern. *)
  let match_tag ?(f = String.contains_s) pattern entry =
    List.exists (fun tag -> f tag pattern) entry.folded_tags

  let match_name ?(f = String.contains_s) pattern entry =
    f entry.folded_name pattern

  let match_synopsis ?(f = String.contains_s) pattern entry =
    f entry.folded_synopsis pattern

  let match_description ?(f = String.contains_s) pattern entry =
    f entry.folded_description pattern

  let match_author ?(f = String.contains_s) pattern entry =
    List.exists (fun author -> f author pattern) entry.folded_authors

  let match_constraint ~is_author_match (package : search_entry)
      (cst : search_constraint) =
    match cst with
    | Tag pattern -> match_tag pattern package
    | Name pattern -> match_name pattern package
    | Synopsis pattern -> match_synopsis pattern package
    | Description pattern -> match_description pattern package
    | Author pattern -> match_author ~f:is_author_match pattern package
    | Any pattern ->
        match_author ~f:is_author_match pattern package
        || match_description pattern package
        || match_name pattern package
        || match_synopsis pattern package
        || match_tag pattern package

  let match_request ~is_author_match c package =
    List.for_all (match_constraint ~is_author_match package) c

  type score = {
    name : int;
    exact_name : int;
    author : int;
    exact_author : int;
    tag : int;
    exact_tag : int;
    synopsis : int;
    description : int;
  }

  let score package query =
    let score_if f s = if f s package then 1 else 0 in
    let update_score score = function
      | Any s ->
          {
            tag = score.tag + score_if match_tag s;
            exact_tag = score.exact_tag + score_if (match_tag ~f:String.equal) s;
            name = score.name + score_if match_name s;
            exact_name =
              score.exact_name + score_if (match_name ~f:String.equal) s;
            author = score.author + score_if match_author s;
            exact_author =
              score.exact_author + score_if (match_author ~f:String.equal) s;
            synopsis = score.synopsis + score_if match_synopsis s;
            description = score.description + score_if match_description s;
          }
      | _ -> score
    in
    let null =
      {
        name = 0;
        exact_name = 0;
        author = 0;
        exact_author = 0;
        tag = 0;
        exact_tag = 0;
        synopsis = 0;
        description = 0;
      }
    in
    List.fold_left update_score null query

  let score_to_float score =
    Float.of_int
      ((4 * score.name) + (10 * score.exact_name) + (2 * score.author)
     + score.tag + (2 * score.exact_tag) + score.synopsis + score.description)

  let adjust_score_by_popularity query p =
    (score p query |> score_to_float)
    *. (1.0 +. Float.log (Float.of_int (p.rev_deps_count + 1)))

  let relevance query p = score p query |> score_to_float
  let relevance_by_popularity = adjust_score_by_popularity
end

(* The latest version of every package, in [all_latest] order, with its search
   fields case-folded. Built on the first search after [t.packages] is replaced,
   about 0.03 s, instead of folding every package's text again on every
   query. *)
let search_index t =
  match t.search_index with
  | Some (packages, index) when packages == t.packages -> index
  | _ ->
      let fold = Ocamlorg.Import.String.fold in
      let index =
        all_latest t
        |> List.map (fun (package : t) ->
               {
                 package;
                 folded_name = fold (Name.to_string package.name);
                 folded_synopsis = fold package.info.synopsis;
                 folded_description = fold package.info.description;
                 folded_tags = List.map fold package.info.tags;
                 folded_authors = List.map fold package.info.authors;
                 rev_deps_count = List.length package.info.rev_deps;
               })
      in
      t.search_index <- Some (t.packages, index);
      index

(* The module path a query names, if it is unmistakably written like one: a
   leading uppercase letter, identifier characters and dots, and at least one
   '_', '.' or uppercase letter after the first ("Lwt_io", "Yojson.Safe",
   "CCList", "LTerm"). For "Module.value" ("Uri.of_string") it is the module
   part. Other queries are left to the text search, including capitalized single
   words ("Trie", "Json", "Unix"): many common words are also module names
   somewhere, and phone keyboards capitalize the first letter, so the module
   rule would otherwise reorder topic searches. *)
let module_query query =
  let q = String.trim query in
  let is_path_char = function
    | 'a' .. 'z' | 'A' .. 'Z' | '0' .. '9' | '_' | '\'' | '.' -> true
    | _ -> false
  in
  let looks_like_a_module =
    String.length q > 1
    && String.exists
         (function '_' | '.' | 'A' .. 'Z' -> true | _ -> false)
         (String.sub q 1 (String.length q - 1))
  in
  match q with
  | "" -> None
  | _ when not (match q.[0] with 'A' .. 'Z' -> true | _ -> false) -> None
  | _ when not looks_like_a_module -> None
  | _ ->
      let path =
        match String.rindex_opt q '.' with
        | Some i
          when i + 1 < String.length q
               &&
               match q.[i + 1] with
               | 'a' .. 'z' | '_' | '(' -> true
               | _ -> false ->
            String.sub q 0 i
        | _ -> q
      in
      if String.for_all is_path_char path then Some path else None

let search ~is_author_match ?(sort_by_popularity = false) ?module_providers t
    query =
  let request = Search.to_request query in
  let score =
    Search.(if sort_by_popularity then relevance_by_popularity else relevance)
      request
  in
  (* Score each package once, not on every comparison. The sort is stable, so
     packages with equal scores keep their order. *)
  let results =
    search_index t
    |> List.filter (Search.match_request ~is_author_match request)
    |> List.map (fun e -> (score e, e))
    |> List.stable_sort (fun (s1, _) (s2, _) -> Float.compare s2 s1)
    |> List.map (fun (_, e) -> e.package)
  in
  (* Module lookup: the packages whose documentation defines the module the
     query names come first, most depended upon first; only a package named
     exactly like the query stays ahead of them. They are added even when their
     opam metadata does not mention the module, which is the point: "Lwt_io"
     finds lwt. *)
  match (module_providers, module_query query) with
  | Some providers, Some path -> (
      let by_popularity =
        providers path
        |> List.filter_map (fun n ->
               Option.bind (Name.of_string_opt n) (get_latest t))
        |> List.map (fun p -> (List.length p.info.rev_deps, p))
        |> List.stable_sort (fun (a, _) (b, _) -> Int.compare b a)
        |> List.map snd
      in
      match by_popularity with
      | [] -> results
      | hits ->
          let same a b = Name.compare a.name b.name = 0 in
          let q = String.lowercase_ascii (String.trim query) in
          let named, rest =
            List.partition
              (fun p -> String.lowercase_ascii (Name.to_string p.name) = q)
              results
          in
          let hits =
            List.filter (fun h -> not (List.exists (same h) named)) hits
          in
          named @ hits
          @ List.filter (fun p -> not (List.exists (same p) hits)) rest)
  | _ -> results

module Documentation = struct
  include Documentation

  let search_index_digest ~kind state pkg =
    search_index_digest ~kind state.docs pkg

  let status ~kind state pkg = status ~kind state.docs pkg
end
