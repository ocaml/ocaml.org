open Import
module Name = OpamPackage.Name
module Name_map = Map.Make (Name)
module Version = OpamPackage.Version
module Version_map = Map.Make (Version)
module Info = Info
module Packages_stats = Packages_stats

type t = { name : Name.t; version : Version.t; info : Info.t }

let name t = t.name
let version t = t.version
let info t = t.info
let create ~name ~version info = { name; version; info }

type state = {
  version : string;
  mutable opam_repository_commit : string option;
  mutable packages : Info.t OpamPackage.Version.Map.t OpamPackage.Name.Map.t;
  mutable stats : Packages_stats.t option;
  mutable featured_packages : t list option;
}

let state_of_package_list (pkgs : t list) =
  let map = OpamPackage.Name.Map.empty in
  let add_version (pkg : t) map =
    let new_map =
      match OpamPackage.Name.Map.find_opt pkg.name map with
      | None -> OpamPackage.Version.Map.(add pkg.version pkg.info empty)
      | Some version_map ->
          OpamPackage.Version.Map.add pkg.version pkg.info version_map
    in
    OpamPackage.Name.Map.add pkg.name new_map map
  in
  let packages = List.fold_left (fun map v -> add_version v map) map pkgs in
  {
    version = Info.version;
    packages;
    opam_repository_commit = None;
    stats = None;
    featured_packages = None;
  }

let read_versions package_name versions =
  let open Lwt.Syntax in
  Lwt_list.fold_left_s
    (fun acc package_version ->
      match OpamPackage.of_string_opt package_version with
      | Some pkg ->
          let+ opam = Opam_repository.opam_file package_name package_version in
          OpamPackage.Version.Map.add pkg.version opam acc
      | None ->
          Logs.err (fun m -> m "Invalid pacakge version %S" package_name);
          Lwt.return acc)
    OpamPackage.Version.Map.empty versions

let read_packages () =
  let open Lwt.Syntax in
  Lwt_list.fold_left_s
    (fun acc (package_name, versions) ->
      match OpamPackage.Name.of_string package_name with
      | exception ex ->
          Logs.err (fun m ->
              m "Invalid package name %S: %s" package_name
                (Printexc.to_string ex));
          Lwt.return acc
      | _name ->
          let+ versions = read_versions package_name versions in
          OpamPackage.Name.Map.add (Name.of_string package_name) versions acc)
    OpamPackage.Name.Map.empty
    (Opam_repository.list_packages_and_versions ())

let try_load_state () =
  let exception Invalid_version in
  let state_path = Config.package_state_path in
  try
    let channel = open_in (Fpath.to_string state_path) in
    Fun.protect
      (fun () ->
        let v = Marshal.from_channel channel in
        if Info.version <> v.version then raise Invalid_version;
        Logs.info (fun f ->
            f "Package state loaded (%d packages, opam commit %s)"
              (OpamPackage.Name.Map.cardinal v.packages)
              (Option.value ~default:"" v.opam_repository_commit));
        v)
      ~finally:(fun () -> close_in channel)
  with Failure _ | Sys_error _ | Invalid_version | End_of_file ->
    Logs.info (fun f -> f "Package state starting from scratch");
    {
      opam_repository_commit = None;
      version = Info.version;
      packages = OpamPackage.Name.Map.empty;
      stats = None;
      featured_packages = None;
    }

let save_state t =
  Logs.info (fun f -> f "Package state saved");
  let state_path = Config.package_state_path in
  let channel = open_out_bin (Fpath.to_string state_path) in
  Fun.protect
    (fun () -> Marshal.to_channel channel t [])
    ~finally:(fun () -> close_out channel)

let get_package_latest' packages name =
  OpamPackage.Name.Map.find_opt name packages
  |> Option.map (fun versions ->
         let version, info = OpamPackage.Version.Map.max_binding versions in
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
  let+ stats = Packages_stats.compute packages in
  let featured_packages =
    Ood.Packages.all.featured_packages
    |> List.filter_map (fun p ->
           get_package_latest' packages (Name.of_string p))
  in
  t.packages <- packages;
  t.stats <- Some stats;
  t.featured_packages <- Some featured_packages;
  Logs.info (fun m ->
      m "Loaded %d packages" (OpamPackage.Name.Map.cardinal packages))

let maybe_update t =
  let open Lwt.Syntax in
  let* commit = Opam_repository.last_commit () in
  match t.opam_repository_commit with
  | Some v when v = commit -> Lwt.return ()
  | _ ->
      let+ () = update ~commit t in
      save_state t

let poll_for_opam_packages ~polling v =
  let open Lwt.Syntax in
  let* () = Opam_repository.clone () in
  let rec updater () =
    let* () =
      Lwt.catch
        (fun () ->
          let* () = Opam_repository.pull () in
          maybe_update v)
        (fun exn ->
          Logs.err (fun m ->
              m "Failed to update the opam package list: %s"
                (Printexc.to_string exn));
          Lwt.return ())
    in
    let* () = Lwt_unix.sleep (float_of_int polling) in
    updater ()
  in
  updater ()

let init ?(disable_polling = false) () =
  let state = try_load_state () in
  if Sys.file_exists (Fpath.to_string Config.opam_repository_path) then
    Lwt.async (fun () -> maybe_update state);
  if disable_polling then ()
  else
    Lwt.async (fun () ->
        poll_for_opam_packages ~polling:Config.opam_polling state);
  state

let all_packages_latest t =
  t.packages
  |> OpamPackage.Name.Map.map OpamPackage.Version.Map.max_binding
  |> OpamPackage.Name.Map.bindings
  |> List.map (fun (name, (version, info)) -> { name; version; info })

let packages_stats t = t.stats

let get_packages_with_name t name =
  t.packages
  |> OpamPackage.Name.Map.find_opt name
  |> Option.map OpamPackage.Version.Map.bindings
  |> Option.map (List.map (fun (version, info) -> { name; version; info }))

let get_package_versions t name =
  t.packages
  |> OpamPackage.Name.Map.find_opt name
  |> Option.map OpamPackage.Version.Map.bindings
  |> Option.map (List.map fst)

let get_package_latest t name = get_package_latest' t.packages name

let get_package t name version =
  t.packages |> OpamPackage.Name.Map.find_opt name |> fun x ->
  Option.bind x (OpamPackage.Version.Map.find_opt version)
  |> Option.map (fun info -> { version; info; name })

let featured_packages t = t.featured_packages

module Documentation = struct
  type toc = { title : string; href : string; children : toc list }

  type item =
    [ `Module of string
    | `ModuleType of string
    | `FunctorArgument of int * string
    | `Class of string
    | `ClassType of string ]

  type t = { toc : toc list; module_path : item list; content : string }

  let rec toc_of_json = function
    | `Assoc
        [
          ("title", `String title);
          ("href", `String href);
          ("children", `List children);
        ] ->
        { title; href; children = List.map toc_of_json children }
    | _ -> raise (Invalid_argument "malformed toc file")

  let toc_from_string s =
    match Yojson.Safe.from_string s with
    | `List xs -> List.map toc_of_json xs
    | _ -> raise (Invalid_argument "the toplevel json is not a list")

  let module_path_from_path s =
    let parse_item i =
      match String.split_on_char '-' i with
      | [ "index.html" ] | [ "" ] -> None
      | [ module_name ] -> Some (`Module module_name)
      | [ "module"; "type"; module_name ] -> Some (`ModuleType module_name)
      | [ "argument"; arg_number; arg_name ] -> (
          try Some (`FunctorArgument (int_of_string arg_number, arg_name))
          with Failure _ -> None)
      | [ "class"; class_name ] -> Some (`Class class_name)
      | [ "class"; "type"; class_name ] -> Some (`ClassType class_name)
      | _ -> None
    in
    String.split_on_char '/' s |> List.filter_map parse_item
end

module Module_map = Module_map

let package_path ~kind name version =
  match kind with
  | `Package -> Config.documentation_url ^ "p/" ^ name ^ "/" ^ version ^ "/"
  | `Universe s ->
      Config.documentation_url ^ "u/" ^ s ^ "/" ^ name ^ "/" ^ version ^ "/"

let documentation_path ~kind name version =
  match kind with
  | `Package ->
      Config.documentation_url ^ "p/" ^ name ^ "/" ^ version ^ "/doc" ^ "/"
  | `Universe s ->
      Config.documentation_url ^ "u/" ^ s ^ "/" ^ name ^ "/" ^ version ^ "/doc"
      ^ "/"

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

let documentation_page ~kind t path =
  let open Lwt.Syntax in
  let root =
    documentation_path ~kind (Name.to_string t.name)
      (Version.to_string t.version)
  in
  let module_path = Documentation.module_path_from_path path in
  let path = root ^ path in
  let* content = http_get path in
  match content with
  | Ok content ->
      let+ toc =
        let toc_path = Filename.remove_extension path ^ ".toc.json" in
        let+ toc_content = http_get toc_path in
        match toc_content with
        | Ok toc_content -> (
            try Documentation.toc_from_string toc_content
            with Invalid_argument err ->
              Logs.err (fun m -> m "Invalid toc: %s" err);
              [])
        | Error _ -> []
      in
      Logs.info (fun m -> m "Found documentation page for %s" path);
      Some Documentation.{ content; toc; module_path }
  | Error _ -> Lwt.return None

let maybe_file ~kind t filename =
  let open Lwt.Syntax in
  let+ doc = documentation_page ~kind t filename in
  match doc with None -> None | Some { content; _ } -> Some content

let maybe_files ~kind t names =
  let f filename =
    let open Lwt.Syntax in
    let+ doc = maybe_file ~kind t (filename ^ ".html") in
    Option.map (fun _ -> (filename, doc)) doc
  in
  Lwt_stream.find_map_s f (Lwt_stream.of_list names)

let readme_file ~kind t = maybe_file ~kind t "README.md.html"

let license_filename ~kind t =
  let open Lwt.Syntax in
  let+ file_opt = maybe_files ~kind t [ "LICENSE"; "LICENSE.md" ] in
  match file_opt with
  | None -> None
  | Some (filename, _content) -> Some filename

let changes_filename ~kind t =
  let open Lwt.Syntax in
  let+ file_opt = maybe_files ~kind t [ "CHANGES.md"; "CHANGELOG.md" ] in
  match file_opt with
  | None -> None
  | Some (filename, _content) -> Some filename

let documentation_status ~kind t =
  let open Lwt.Syntax in
  let root =
    package_path ~kind (Name.to_string t.name) (Version.to_string t.version)
  in
  let path = root ^ "status.json" in
  let+ content = http_get path in
  match content with
  | Ok "\"Built\"" -> `Success
  | Ok "\"Failed\"" -> `Failure
  | Error _ -> `Failure
  | _ -> `Unknown

let module_map ~kind t =
  let open Lwt.Syntax in
  let root =
    package_path ~kind (Name.to_string t.name) (Version.to_string t.version)
  in
  let path = root ^ "package.json" in
  let+ content = http_get path in
  match content with
  | Ok v ->
      let json = Yojson.Safe.from_string v in
      Module_map.of_yojson json
  | Error _ -> { Module_map.libraries = Module_map.String_map.empty }

let doc_exists t name version =
  let package = get_package t name version in
  let open Lwt.Syntax in
  match package with
  | None -> Lwt.return None
  | Some package -> (
      let* doc_stat = documentation_status ~kind:`Package package in
      match doc_stat with
      | `Success -> Lwt.return (Some version)
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
  match get_package_versions t name with
  | None -> Lwt.return None
  | Some vlist -> aux (List.rev vlist)

module Search : sig
  type search_request
  type score

  val to_request : string -> search_request
  val match_request : search_request -> t -> bool
  val score : t -> search_request -> score
  val compare_score : score -> score -> int
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
      (fun (author : Ood.Opam_user.t) ->
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

  let compare_score s1 s2 =
    if s1.exact_name != s2.exact_name then
      Int.compare s2.exact_name s1.exact_name
    else if s1.name != s2.name then Int.compare s2.name s1.name
    else if s1.exact_author != s2.exact_author then
      Int.compare s2.exact_author s1.exact_author
    else if s1.author != s2.author then Int.compare s2.author s1.author
    else if s1.exact_tag != s2.exact_tag then
      Int.compare s2.exact_tag s1.exact_tag
    else if s1.tag != s2.tag then Int.compare s2.tag s1.tag
    else if s1.synopsis != s2.synopsis then Int.compare s2.synopsis s1.synopsis
    else Int.compare s2.description s1.description
end

let search_package t pattern =
  let request = Search.to_request pattern in
  all_packages_latest t
  |> List.filter (Search.match_request request)
  |> List.sort (fun package1 package2 ->
         Search.compare_score
           (Search.score package1 request)
           (Search.score package2 request))
