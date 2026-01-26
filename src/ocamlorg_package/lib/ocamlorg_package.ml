module Import = Import
open Import
include Package
module Info = Info
module Statistics = Packages_stats
open Package

(* When this type changes, [Info.version] needs to be incremented to invalidate
   the cache *)
type state = {
  version : string;
  mutable opam_repository_commit : string option;
  mutable packages : Info.t Version.Map.t Name.Map.t;
  mutable stats : Statistics.t option;
  docs : Documentation.doc_cache;
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
    docs = Documentation.doc_cache_empty;
  }

let read_versions package_name versions =
  let open Lwt.Syntax in
  Lwt_list.fold_left_s
    (fun acc package_version ->
      match OpamPackage.of_string_opt package_version with
      | Some pkg -> (
          let+ opam_opt =
            Opam_repository.opam_file package_name package_version
          in
          match opam_opt with
          | Some opam -> Version.Map.add pkg.version opam acc
          | None ->
              Logs.err (fun m ->
                  m "Failed to read opam file for %S %s" package_name
                    package_version);
              acc)
      | None ->
          Logs.err (fun m -> m "Invalid pacakge version %S" package_name);
          Lwt.return acc)
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
        | _name ->
            let+ versions = read_versions package_name versions in
            Name.Map.add (Name.of_string package_name) versions acc)
      Name.Map.empty packages_and_versions
  in
  let t2 = Unix.gettimeofday () in
  Logs.info (fun log -> log "Read opam files: %.2fs" (t2 -. t1));
  result

let try_load_state () =
  let exception Invalid_version in
  let state_path = Config.package_state_path in
  Logs.info (fun m -> m "State cache file: %s" (Fpath.to_string state_path));
  try
    let channel = open_in (Fpath.to_string state_path) in
    Fun.protect
      (fun () ->
        let v = (Marshal.from_channel channel : state) in
        if Info.version <> v.version then raise Invalid_version;
        Logs.info (fun f ->
            f "Package state loaded (%d packages, opam commit %s)"
              (Name.Map.cardinal v.packages)
              (Option.value ~default:"" v.opam_repository_commit));
        v)
      ~finally:(fun () -> close_in channel)
  with Failure _ | Sys_error _ | Invalid_version | End_of_file ->
    Logs.info (fun f -> f "Package state starting from scratch");
    {
      opam_repository_commit = None;
      version = Info.version;
      packages = Name.Map.empty;
      stats = None;
      docs = Documentation.doc_cache_empty;
    }

let save_state t =
  Logs.info (fun f -> f "Package state saved");
  let state_path = Config.package_state_path in
  let channel = open_out_bin (Fpath.to_string state_path) in
  Fun.protect
    (fun () -> Marshal.to_channel channel t [])
    ~finally:(fun () -> close_out channel)

let get_latest' packages name =
  Name.Map.find_opt name packages
  |> Option.map (fun versions ->
         let avoid_version _ (info : Info.t) =
           List.exists (( = ) OpamTypes.Pkgflag_AvoidVersion) info.flags
         in
         let avoided, packages = Version.Map.partition avoid_version versions in
         let version, info =
           match Version.Map.max_binding_opt packages with
           | None -> Version.Map.max_binding avoided
           | Some (version, info) -> (version, info)
         in
         { version; info; name })

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
  t.opam_repository_commit <- Some commit;
  Logs.info (fun m -> m "Updating opam package list");
  let* packages =
    time_it_lwt "Read packages" (fun () -> read_packages ())
  in
  let* packages =
    time_it_lwt "Compute package info" (fun () -> Info.of_opamfiles packages)
  in
  let+ stats =
    time_it_lwt "Compute statistics" (fun () -> Statistics.compute packages)
  in
  t.packages <- packages;
  t.stats <- Some stats;
  Logs.info (fun m -> m "Loaded %d packages" (Name.Map.cardinal packages))

let maybe_update t commit =
  let open Lwt.Syntax in
  match t.opam_repository_commit with
  | Some v when v = commit -> Lwt.return ()
  | _ ->
      Logs.info (fun m -> m "Update server state");
      let+ () = update ~commit t in
      save_state t

let rec poll_for_opam_packages ~polling v =
  let open Lwt.Syntax in
  let* () = Lwt_unix.sleep (float_of_int polling) in
  let* () =
    Lwt.catch
      (fun () ->
        Logs.info (fun m -> m "Opam repo: git pull");
        let* commit = Opam_repository.pull () in
        maybe_update v commit)
      (fun exn ->
        Logs.err (fun m ->
            m "Failed to update the opam package list: %s"
              (Printexc.to_string exn));
        Lwt.return ())
  in
  poll_for_opam_packages ~polling v

let init ?(disable_polling = false) () =
  let open Lwt.Syntax in
  let state = try_load_state () in
  Lwt.async (fun () ->
      let* commit = Opam_repository.(if exists () then pull else clone) () in
      let* () = maybe_update state commit in
      if disable_polling then Lwt.return_unit
      else poll_for_opam_packages ~polling:Config.opam_polling state);
  state

let all_latest t =
  t.packages
  |> Name.Map.map Version.Map.max_binding
  |> Name.Map.bindings
  |> List.map (fun (name, (version, info)) -> { name; version; info })

let stats t = t.stats

let get_by_name t name =
  t.packages |> Name.Map.find_opt name
  |> Option.map Version.Map.bindings
  |> Option.map (List.map (fun (version, info) -> { name; version; info }))

type version_with_publication_date = {
  version : Version.t;
  publication : float;
}

let get_versions t name =
  t.packages |> Name.Map.find_opt name
  |> Option.map (fun p ->
         p |> Version.Map.bindings
         |> List.map (fun (version, info) ->
                { version; publication = info.Info.publication }))
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
  let rec aux vlist =
    let open Lwt.Syntax in
    match vlist with
    | [] -> Lwt.return None
    | _ -> (
        let version = List.hd vlist in
        let* doc = doc_exists t name version in
        match doc with
        | Some version -> Lwt.return (Some version)
        | None -> aux (List.tl vlist))
  in
  match get_versions t name with
  | [] -> Lwt.return None
  | vlist -> aux (vlist |> List.map (fun v -> v.version))

let is_latest_version t name version =
  match get_latest t name with
  | None -> false
  | Some pkg -> pkg.version = version

module Search : sig
  type search_request

  val to_request : string -> search_request

  val match_request :
    is_author_match:(string -> string -> bool) -> search_request -> t -> bool

  val compare : search_request -> t -> t -> int
  val compare_by_popularity : search_request -> t -> t -> int
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
    let str = String.lowercase_ascii str in
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

  let match_ f s pattern = f (String.lowercase_ascii @@ s) pattern

  let match_tag ?(f = String.contains_s) pattern package =
    List.exists (fun tag -> match_ f tag pattern) package.info.tags

  let match_name ?(f = String.contains_s) pattern package =
    match_ f (Name.to_string package.name) pattern

  let match_synopsis ?(f = String.contains_s) pattern package =
    match_ f package.info.synopsis pattern

  let match_description ?(f = String.contains_s) pattern package =
    match_ f package.info.description pattern

  let match_author ?(f = String.contains_s) pattern package =
    List.exists (fun tag -> match_ f tag pattern) package.info.authors

  let match_constraint ~is_author_match (package : t) (cst : search_constraint)
      =
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
    *. (1.0 +. Float.log (Float.of_int (List.length p.info.rev_deps + 1)))

  let compare query p1 p2 =
    let s1 = score p1 query |> score_to_float in
    let s2 = score p2 query |> score_to_float in
    Float.compare s2 s1

  let compare_by_popularity query p1 p2 =
    let s1 = adjust_score_by_popularity query p1 in
    let s2 = adjust_score_by_popularity query p2 in
    Float.compare s2 s1
end

let search ~is_author_match ?(sort_by_popularity = false) t query =
  let compare =
    Search.(if sort_by_popularity then compare_by_popularity else compare)
  in
  let request = Search.to_request query in
  all_latest t
  |> List.filter (Search.match_request ~is_author_match request)
  |> List.sort (compare request)

module Documentation = struct
  include Documentation

  let search_index_digest ~kind state pkg =
    search_index_digest ~kind state.docs pkg

  let status ~kind state pkg = status ~kind state.docs pkg
end
