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

(* The durable fields are those of [Package_state.t]; [docs] and [search_index]
   are runtime caches, never persisted. *)
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

let to_snapshot t : Package_state.t =
  {
    version = t.version;
    opam_repository_commit = t.opam_repository_commit;
    packages = t.packages;
    stats = t.stats;
  }

(* [docs] and [search_index] are not persisted; they are runtime caches, rebuilt
   empty here. *)
let of_snapshot (v : Package_state.t) =
  {
    version = v.version;
    opam_repository_commit = v.opam_repository_commit;
    packages = v.packages;
    stats = v.stats;
    docs = Documentation.doc_cache_create ();
    search_index = None;
  }

let load_state_from state_path = of_snapshot (Package_state.load state_path)
let try_load_state () = load_state_from Paths.package_state

let save_state_to state_path t =
  Package_state.write state_path (to_snapshot t);
  Logs.info (fun f -> f "Package state saved")

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

(* The state file's identity: the builder renames each new version over it, so a
   new inode means a new version. *)
let file_id path =
  match Unix.stat (Fpath.to_string path) with
  | st -> Some (st.Unix.st_dev, st.Unix.st_ino)
  | exception Unix.Unix_error _ -> None

(* Swap in the version of the state the builder wrote. A version that can't be
   read is skipped, and the current state kept. Reading takes about 0.17s on the
   event loop. *)
let reload t path =
  let t0 = Unix.gettimeofday () in
  match Package_state.read path with
  | Ok v ->
      t.packages <- v.packages;
      t.stats <- v.stats;
      t.opam_repository_commit <- v.opam_repository_commit;
      Logs.info (fun m ->
          m "Reload package state: %.2fs" (Unix.gettimeofday () -. t0));
      Logs.info (fun m ->
          m "Package state reloaded (%d packages, opam commit %s)"
            (Name.Map.cardinal v.packages)
            (Option.value ~default:"" v.opam_repository_commit))
  | Error e -> Logs.err (fun m -> m "Package state reload failed: %s" e)

(* OCaml numbers signals its own way (negative numbers): name the likely
   ones. *)
let pp_signal f n =
  let names =
    [
      (Sys.sigkill, "SIGKILL");
      (Sys.sigterm, "SIGTERM");
      (Sys.sigsegv, "SIGSEGV");
      (Sys.sigabrt, "SIGABRT");
      (Sys.sigint, "SIGINT");
    ]
  in
  match List.assoc_opt n names with
  | Some name -> Fmt.string f name
  | None -> Fmt.pf f "signal %d" n

let pp_status f = function
  | Unix.WEXITED n -> Fmt.pf f "exited with status %d" n
  | Unix.WSIGNALED n when n = Sys.sigkill ->
      Fmt.pf f "was killed by SIGKILL (after %.0fs, or out of memory)"
        Config.package_builder_timeout
  | Unix.WSIGNALED n -> Fmt.pf f "was killed by %a" pp_signal n
  | Unix.WSTOPPED n -> Fmt.pf f "was stopped by %a" pp_signal n

(* Run the package-state builder, which pulls opam-repository, rebuilds the
   state and writes it, then load the new version if there is one. The server
   itself never touches the clone nor computes the state. A failed, crashed or
   timed-out builder leaves the current state in place, and the next poll tries
   again. Never raises.

   The builder is told the commit of the state the server holds, so that a poll
   that finds nothing new exits without reading the state. Each failure in a row
   is counted in the log, with the commit still served, so that a builder that
   keeps failing (for instance, killed for memory at every poll, see
   [OCAMLORG_PACKAGE_BUILDER_OOM_SCORE_ADJ]) shows as a stale state.

   [Lwt_process] forks: this relies on the server never spawning a domain, after
   which OCaml 5 refuses [Unix.fork]. *)
let refresh t ~loaded ~failures =
  let open Lwt.Syntax in
  let path = Paths.package_state in
  let builder = Config.package_builder in
  let commit =
    match t.opam_repository_commit with
    | Some c -> [ "--commit"; c ]
    | None -> []
  in
  let cmd =
    ( "",
      Array.of_list
        ([
           builder;
           "--nice";
           string_of_int Config.package_builder_nice;
           "--oom-score-adj";
           string_of_int Config.package_builder_oom_score_adj;
         ]
        @ commit
        @ [ Fpath.to_string path ]) )
  in
  let+ status =
    Lwt.catch
      (fun () ->
        Lwt.map Result.ok
          (Lwt_process.exec ~timeout:Config.package_builder_timeout
             ~stdin:`Close ~stdout:`Keep ~stderr:`Keep cmd))
      (fun e -> Lwt.return (Error e))
  in
  let failed pp =
    incr failures;
    Logs.err (fun m ->
        m
          "Package state builder %s %a (%d in a row): keeping the current \
           state, opam commit %s"
          builder pp () !failures
          (Option.value ~default:"none" t.opam_repository_commit))
  in
  match status with
  | Ok (Unix.WEXITED 0) ->
      failures := 0;
      let id = file_id path in
      if id <> None && id <> !loaded then (
        loaded := id;
        reload t path)
  | Ok status -> failed (fun f () -> pp_status f status)
  | Error e ->
      failed (fun f () -> Fmt.pf f "failed to run: %s" (Printexc.to_string e))

let rec poll t ~loaded ~failures =
  let open Lwt.Syntax in
  let* () = Lwt_unix.sleep (float_of_int Config.opam_polling) in
  let* () = refresh t ~loaded ~failures in
  poll t ~loaded ~failures

(* The first refresh must not raise either: an exception escaping [Lwt.async]
   reaches [Lwt.async_exception_hook], which exits the process until Dream
   replaces it on the first request, and would in any case kill this task before
   polling starts. *)
let init ?(disable_polling = false) () =
  let open Lwt.Syntax in
  let loaded = ref (file_id Paths.package_state) in
  let failures = ref 0 in
  let state = try_load_state () in
  Lwt.async (fun () ->
      let* () = refresh state ~loaded ~failures in
      if disable_polling then Lwt.return_unit else poll state ~loaded ~failures);
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

let search ~is_author_match ?(sort_by_popularity = false) t query =
  let request = Search.to_request query in
  let score =
    Search.(if sort_by_popularity then relevance_by_popularity else relevance)
      request
  in
  (* Score each package once, not on every comparison. The sort is stable, so
     packages with equal scores keep their order. *)
  search_index t
  |> List.filter (Search.match_request ~is_author_match request)
  |> List.map (fun e -> (score e, e))
  |> List.stable_sort (fun (s1, _) (s2, _) -> Float.compare s2 s1)
  |> List.map (fun (_, e) -> e.package)

module Documentation = struct
  include Documentation

  let search_index_digest ~kind state pkg =
    search_index_digest ~kind state.docs pkg

  let status ~kind state pkg = status ~kind state.docs pkg
end
