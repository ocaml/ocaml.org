open Ocamlorg.Import
module Name = OpamPackage.Name
module Version = OpamPackage.Version
module Info = Info
module Statistics = Packages_stats

type t = { name : Name.t; version : Version.t; info : Info.t }

let name t = t.name
let version t = t.version
let info t = t.info
let create ~name ~version info = { name; version; info }

type state = {
  version : string;
  mutable opam_repository_commit : string option;
  mutable packages : Info.t Version.Map.t Name.Map.t;
  mutable stats : Statistics.t option;
  mutable featured : t list option;
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
    featured = None;
  }

let read_versions package_name versions =
  let open Lwt.Syntax in
  Lwt_list.fold_left_s
    (fun acc package_version ->
      match OpamPackage.of_string_opt package_version with
      | Some pkg ->
          let+ opam = Opam_repository.opam_file package_name package_version in
          Version.Map.add pkg.version opam acc
      | None ->
          Logs.err (fun m -> m "Invalid pacakge version %S" package_name);
          Lwt.return acc)
    Version.Map.empty versions

let read_packages () =
  let open Lwt.Syntax in
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
    Name.Map.empty
    (Opam_repository.list_packages_and_versions ())

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
      featured = None;
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

let update ~commit t =
  let open Lwt.Syntax in
  Logs.info (fun m -> m "Opam repository is currently at %s" commit);
  t.opam_repository_commit <- Some commit;
  Logs.info (fun m -> m "Updating opam package list");
  Logs.info (fun f -> f "Calculating packages.. .");
  let* packages = read_packages () in
  Logs.info (fun f -> f "Computing additional informations...");
  let* packages = Info.of_opamfiles packages in
  Logs.info (fun f -> f "Computing packages statistics...");
  let+ stats = Statistics.compute packages in
  let featured =
    Data.Packages.all.featured
    |> List.filter_map (fun p -> get_latest' packages (Name.of_string p))
  in
  t.packages <- packages;
  t.stats <- Some stats;
  t.featured <- Some featured;
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

let get_versions t name =
  t.packages |> Name.Map.find_opt name
  |> Option.map (fun p -> p |> Version.Map.bindings |> List.rev_map fst)

let get_latest t name = get_latest' t.packages name

let get t name version =
  t.packages |> Name.Map.find_opt name |> fun x ->
  Option.bind x (Version.Map.find_opt version)
  |> Option.map (fun info -> { version; info; name })

let featured t = t.featured

module Documentation = struct
  type toc = { title : string; href : string; children : toc list }

  type breadcrumb_kind =
    | Page
    | LeafPage
    | Module
    | ModuleType
    | Parameter of int
    | Class
    | ClassType
    | File

  let breadcrumb_kind_from_string s =
    match s with
    | "page" -> Page
    | "leaf-page" -> LeafPage
    | "module" -> Module
    | "module-type" -> ModuleType
    | "class" -> Class
    | "class-type" -> ClassType
    | "file" -> File
    | _ ->
        if String.starts_with ~prefix:"argument-" s then
          let i = List.hd (List.tl (String.split_on_char '-' s)) in
          Parameter (int_of_string i)
        else raise (Invalid_argument ("kind not recognized: " ^ s))

  type breadcrumb = { name : string; href : string; kind : breadcrumb_kind }

  type t = {
    uses_katex : bool;
    toc : toc list;
    breadcrumbs : breadcrumb list;
    content : string;
  }

  let rec toc_of_json = function
    | `Assoc
        [
          ("title", `String title);
          ("href", `String href);
          ("children", `List children);
        ] ->
        { title; href; children = List.map toc_of_json children }
    | _ -> raise (Invalid_argument "malformed toc field")

  let breadcrumb_from_json = function
    | `Assoc
        [
          ("name", `String name); ("href", `String href); ("kind", `String kind);
        ] ->
        { name; href; kind = breadcrumb_kind_from_string kind }
    | _ -> raise (Invalid_argument "malformed breadcrumb field")

  let doc_from_string s =
    match Yojson.Safe.from_string s with
    | `Assoc
        [
          ("uses_katex", `Bool uses_katex);
          ("breadcrumbs", `List json_breadcrumbs);
          ("toc", `List json_toc);
          ("preamble", `String preamble);
          ("content", `String content);
        ] ->
        let breadcrumbs =
          match List.map breadcrumb_from_json json_breadcrumbs with
          | _ :: _ :: _ :: _ :: breadcrumbs -> breadcrumbs
          | _ -> failwith "Not enough breadcrumbs"
        in
        {
          uses_katex;
          breadcrumbs;
          toc = List.map toc_of_json json_toc;
          content = preamble ^ content;
        }
    | _ -> raise (Invalid_argument "malformed .html.json file")
end

module Module_map = Module_map

let package_url ~kind name version =
  match kind with
  | `Package -> Config.documentation_url ^ "p/" ^ name ^ "/" ^ version ^ "/"
  | `Universe s ->
      Config.documentation_url ^ "u/" ^ s ^ "/" ^ name ^ "/" ^ version ^ "/"

let http_get url =
  let open Lwt.Syntax in
  Logs.info (fun m -> m "GET %s" url);
  let headers =
    Cohttp.Header.of_list
      [
        ( "Accept",
          "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" );
      ]
  in
  let* response, body =
    Cohttp_lwt_unix.Client.get ~headers (Uri.of_string url)
  in
  match Cohttp.Code.(code_of_status response.status |> is_success) with
  | true ->
      let+ body = Cohttp_lwt.Body.to_string body in
      Ok body
  | false ->
      let+ () = Cohttp_lwt.Body.drain_body body in
      Error (`Msg "Failed to fetch the documentation page")

let module_map ~kind t =
  let package_url =
    package_url ~kind (Name.to_string t.name) (Version.to_string t.version)
  in
  let open Lwt.Syntax in
  let url = package_url ^ "package.json" in
  let+ content = http_get url in
  match content with
  | Ok v ->
      let json = Yojson.Safe.from_string v in
      Module_map.of_yojson json
  | Error _ ->
      Logs.info (fun m -> m "Failed to fetch module map at %s" url);
      { Module_map.libraries = String.Map.empty }

let odoc_page ~url =
  let open Lwt.Syntax in
  let* content = http_get url in
  match content with
  | Ok content ->
      let maybe_doc =
        try Some (Documentation.doc_from_string content)
        with Invalid_argument err ->
          Logs.err (fun m -> m "Invalid documentation page: %s" err);
          None
      in
      Logs.info (fun m -> m "Found documentation page for %s" url);
      Lwt.return maybe_doc
  | Error _ ->
      Logs.info (fun m -> m "Failed to fetch documentation page for %s" url);
      Lwt.return None

let documentation_page ~kind t path =
  let package_url =
    package_url ~kind (Name.to_string t.name) (Version.to_string t.version)
  in
  let url = package_url ^ "doc/" ^ path ^ ".json" in
  odoc_page ~url

let file ~kind t path =
  let package_url =
    package_url ~kind (Name.to_string t.name) (Version.to_string t.version)
  in
  let url = package_url ^ path ^ ".json" in
  odoc_page ~url

let search_index ~kind t =
  let package_url =
    package_url ~kind (Name.to_string t.name) (Version.to_string t.version)
  in
  let url = package_url ^ "index.js" in
  let open Lwt.Syntax in
  let* content = http_get url in
  match content with
  | Ok content -> Lwt.return (Some content)
  | Error _ ->
      Logs.info (fun m -> m "Failed to fetch search index at %s" url);
      Lwt.return None

let maybe_file ~kind t filename =
  let open Lwt.Syntax in
  let+ doc = file ~kind t filename in
  Option.map (fun Documentation.{ content; _ } -> content) doc

let maybe_files ~kind t names =
  let f filename =
    let open Lwt.Syntax in
    let+ doc = maybe_file ~kind t (filename ^ ".html") in
    Option.map (fun _ -> (filename, doc)) doc
  in
  Lwt_stream.find_map_s f (Lwt_stream.of_list names)

let readme_filename ~kind t =
  let open Lwt.Syntax in
  let+ file_opt = maybe_files ~kind t [ "README"; "README.md" ] in
  Option.map (fun (filename, _content) -> filename) file_opt

let license_filename ~kind t =
  let open Lwt.Syntax in
  let+ file_opt = maybe_files ~kind t [ "LICENSE"; "LICENSE.md" ] in
  Option.map (fun (filename, _content) -> filename) file_opt

let changes_filename ~kind t =
  let open Lwt.Syntax in
  let+ file_opt = maybe_files ~kind t [ "CHANGES.md"; "CHANGELOG.md" ] in
  Option.map (fun (filename, _content) -> filename) file_opt

type documentation_status = Success | Failure | Unknown

let documentation_status ~kind t : documentation_status Lwt.t =
  let open Lwt.Syntax in
  let package_url =
    package_url ~kind (Name.to_string t.name) (Version.to_string t.version)
  in
  let url = package_url ^ "status.json" in
  let* content = http_get url in
  let status =
    match content with
    | Ok "\"Built\"" -> Success
    | Ok "\"Failed\"" -> Failure
    | _ -> Unknown
  in
  Lwt.return status

let doc_exists t name version =
  let package = get t name version in
  let open Lwt.Syntax in
  match package with
  | None -> Lwt.return None
  | Some package -> (
      let* doc_stat = documentation_status ~kind:`Package package in
      match doc_stat with
      | Success -> Lwt.return (Some version)
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
  | None -> Lwt.return None
  | Some vlist -> aux vlist

let is_latest_version t name version =
  match get_latest t name with
  | None -> false
  | Some pkg -> pkg.version = version

module Search : sig
  type search_request

  val to_request : string -> search_request
  val match_request : search_request -> t -> bool
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
    let match_opt s =
      match s with Some s -> match_ f s pattern | None -> false
    in
    List.exists
      (fun (author : Data.Opam_user.t) ->
        match_opt (Some author.name)
        || match_opt author.email
        || match_opt author.github_username)
      package.info.authors

  let match_constraint (package : t) (cst : search_constraint) =
    match cst with
    | Tag pattern -> match_tag pattern package
    | Name pattern -> match_name pattern package
    | Synopsis pattern -> match_synopsis pattern package
    | Description pattern -> match_description pattern package
    | Author pattern -> match_author pattern package
    | Any pattern ->
        match_author pattern package
        || match_description pattern package
        || match_name pattern package
        || match_synopsis pattern package
        || match_tag pattern package

  let match_request c package = List.for_all (match_constraint package) c

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

let search ?(sort_by_popularity = false) t query =
  let compare =
    Search.(if sort_by_popularity then compare_by_popularity else compare)
  in
  let request = Search.to_request query in
  all_latest t
  |> List.filter (Search.match_request request)
  |> List.sort (compare request)
