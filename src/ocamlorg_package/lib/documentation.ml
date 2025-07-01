module Status = struct
  type redirection = { old_path : string; new_path : string }
  [@@deriving yojson]

  type t = {
    name : string;
    version : string;
    failed : bool;
    files : string list;
    redirections : redirection list;
  }
  [@@deriving yojson]

  let has_file (v : t) (options : string list) : string option =
    let children = v.files in
    try
      List.find_map
        (fun x ->
          let fname = Fpath.(v x |> rem_ext |> filename) in
          if List.mem fname options then Some fname else None)
        children
    with Not_found -> None

  let license_names = [ "LICENSE"; "LICENCE" ]
  let readme_names = [ "README"; "Readme"; "readme" ]

  let changelog_names =
    [ "CHANGELOG"; "Changelog"; "changelog"; "CHANGES"; "Changes"; "changes" ]

  let is_special =
    let names = license_names @ readme_names @ changelog_names in
    fun x -> List.mem x names

  let license (v : t) = has_file v license_names
  let readme (v : t) = has_file v readme_names
  let changelog (v : t) = has_file v changelog_names
end

module Sidebar = struct
  (** Odoc types for sidebar's global table of content *)

  type 'a node = { node : 'a; children : 'a node list }

  and sidebar_node = {
    url : string option;
    kind : string option;
    content : string;
  }

  and tree = sidebar_node node
  and t = tree list [@@deriving of_yojson]
end

type documentation_status_cache_entry = {
  documentation_status : Status.t option;
  time : float;
}

let http_get url =
  let open Lwt.Syntax in
  Logs.info (fun m -> m "GET %s" url);
  Lwt.catch
    (fun () ->
      let headers =
        Cohttp.Header.of_list
          [
            ( "Accept",
              "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
            );
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
          Error (`Msg ("Failed to fetch " ^ url)))
    (function
      | e ->
          Logs.err (fun m -> m "%s" (Printexc.to_string e));
          Lwt.return (Error (`Msg (Printexc.to_string e))))

open Package

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
  | Source

let breadcrumb_kind_from_string s =
  match s with
  | "page" -> Page
  | "leaf-page" -> LeafPage
  | "module" -> Module
  | "module-type" -> ModuleType
  | "class" -> Class
  | "class-type" -> ClassType
  | "file" -> File
  | "source" -> Source
  | _ ->
      if String.starts_with ~prefix:"argument-" s then
        let i = List.hd (List.tl (String.split_on_char '-' s)) in
        Parameter (int_of_string i)
      else raise (Invalid_argument ("kind not recognized: " ^ s))

type breadcrumb = {
  name : string;
  href : string option;
  kind : breadcrumb_kind;
}

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
      [ ("name", `String name); ("href", `String href); ("kind", `String kind) ]
    ->
      { name; href = Some href; kind = breadcrumb_kind_from_string kind }
  | `Assoc [ ("name", `String name); ("href", `Null); ("kind", `String kind) ]
    ->
      { name; href = None; kind = breadcrumb_kind_from_string kind }
  | _ -> raise (Invalid_argument "malformed breadcrumb field")

let doc_from_string s =
  match Yojson.Safe.from_string s with
  | `Assoc
      [
        ("header", `String header);
        ("type", `String _page_type);
        ("uses_katex", `Bool uses_katex);
        ("breadcrumbs", `List json_breadcrumbs);
        ("toc", `List json_toc);
        ("source_anchor", _);
        ("preamble", `String preamble);
        ("content", `String content);
      ] ->
      let breadcrumbs = List.map breadcrumb_from_json json_breadcrumbs in
      {
        uses_katex;
        breadcrumbs;
        toc = List.map toc_of_json json_toc;
        content = header ^ preamble ^ content;
      }
  | `Assoc
      [
        ("type", `String "source");
        ("breadcrumbs", `List json_breadcrumbs);
        ("global_toc", _);
        ("header", `String header);
        ("content", `String content);
      ] ->
      let breadcrumbs = List.map breadcrumb_from_json json_breadcrumbs in
      let content = header ^ content in
      { uses_katex = false; breadcrumbs; toc = []; content }
  | _ -> raise (Invalid_argument "malformed .html.json file")

module Sidebar_cache : sig
  val add :
    Name.t ->
    Version.t ->
    [ `Package | `Universe of string ] ->
    Sidebar.t ->
    unit

  val get :
    Name.t ->
    Version.t ->
    [ `Package | `Universe of string ] ->
    Sidebar.t option
end = struct
  let cache = Hashtbl.create 100

  let add name version kind sidebar =
    let name = Name.to_string name in
    let version = Version.to_string version in
    Hashtbl.add cache (name, version, kind) sidebar

  let get name version kind =
    let name = Name.to_string name in
    let version = Version.to_string version in
    Hashtbl.find_opt cache (name, version, kind)
end

let package_url ~kind name version =
  match kind with
  | `Package -> Config.documentation_url ^ "p/" ^ name ^ "/" ^ version ^ "/"
  | `Universe s ->
      Config.documentation_url ^ "u/" ^ s ^ "/" ^ name ^ "/" ^ version ^ "/"

let sidebar ~kind (t : Package.t) =
  let package_url =
    package_url ~kind (Name.to_string t.name) (Version.to_string t.version)
  in
  let open Lwt.Syntax in
  match Sidebar_cache.get t.name t.version kind with
  | Some sidebar -> Lwt.return sidebar
  | None -> (
      let url = package_url ^ "doc/sidebar.json" in
      let+ content = http_get url in
      match content with
      | Ok v -> (
          let json = Yojson.Safe.from_string v in
          match Sidebar.of_yojson json with
          | Ok x ->
              Sidebar_cache.add t.name t.version kind x;
              x
          | Error msg ->
              Logs.info (fun m -> m "Failed to parse sidebar at %s: %s" url msg);
              [])
      | Error _ ->
          Logs.info (fun m -> m "Failed to fetch sidebar at %s" url);
          [])

let odoc_page ~url =
  let open Lwt.Syntax in
  let* content = http_get url in
  match content with
  | Ok content ->
      let maybe_doc =
        try Some (doc_from_string content)
        with Invalid_argument err ->
          Logs.err (fun m -> m "Invalid documentation page: %s" err);
          None
      in
      Logs.info (fun m -> m "Found documentation page for %s" url);
      Lwt.return maybe_doc
  | Error _ ->
      Logs.info (fun m -> m "Failed to fetch documentation page for %s" url);
      Lwt.return None

let documentation_page ~kind (t : Package.t) path =
  let package_url =
    package_url ~kind (Name.to_string t.name) (Version.to_string t.version)
  in
  let url = package_url ^ "doc/" ^ path ^ ".json" in
  odoc_page ~url

let file ~kind (t : Package.t) path =
  let package_url =
    package_url ~kind (Name.to_string t.name) (Version.to_string t.version)
  in
  let url = package_url ^ path ^ ".json" in
  odoc_page ~url

let odoc_asset ~url =
  let open Lwt.Syntax in
  let+ content = http_get url in
  match content with
  | Ok content ->
      Logs.info (fun m -> m "Found documentation page for %s" url);
      Some content
  | Error _ ->
      Logs.info (fun m -> m "Failed to fetch asset for %s" url);
      None

let documentation_asset ~kind (t : Package.t) path =
  let package_url =
    package_url ~kind (Name.to_string t.name) (Version.to_string t.version)
  in
  let url = package_url ^ "doc/" ^ path in
  odoc_asset ~url

let search_index ~kind (t : Package.t) =
  let package_url =
    package_url ~kind (Name.to_string t.name) (Version.to_string t.version)
  in
  let url = package_url ^ "doc/index.js" in

  let open Lwt.Syntax in
  let* content = http_get url in
  match content with
  | Ok content -> Lwt.return (Some content)
  | Error _ ->
      Logs.info (fun m -> m "Failed to fetch search index at %s" url);
      Lwt.return None

(* TODO: this needs to be computed in ocaml-docs-ci / voodoo and be part of the
   documentation status information *)
type search_index_cache_entry = { hash_digest : string option; time : float }

type doc_cache = {
  mutable doc_status_cache :
    documentation_status_cache_entry Version.Map.t Name.Map.t;
  mutable search_index_cache : search_index_cache_entry Version.Map.t Name.Map.t;
}

let doc_cache_empty =
  { doc_status_cache = Name.Map.empty; search_index_cache = Name.Map.empty }

(* TODO: should be computed by ocaml-docs-ci / voodoo and be part of
   status.json *)
let search_index_digest ~kind state t : string option Lwt.t =
  let open Lwt.Syntax in
  let get_and_cache () =
    let+ content = search_index ~kind t in
    let digest =
      match content with Some s -> Some (s |> Digest.string) | _ -> None
    in
    let entry = { hash_digest = digest; time = Unix.gettimeofday () } in
    state.search_index_cache <-
      Name.Map.update t.name
        (Version.Map.add t.version entry)
        (Version.Map.singleton t.version entry)
        state.search_index_cache;
    digest
  in

  let has_cache_expired time =
    Unix.gettimeofday () -. time > Config.package_caches_ttl
  in

  match
    Name.Map.find_opt t.name state.search_index_cache
    |> Option.map (Version.Map.find_opt t.version)
    |> Option.value ~default:None
  with
  | None -> get_and_cache ()
  | Some { time; _ } when has_cache_expired time -> get_and_cache ()
  | Some { hash_digest; _ } -> Lwt.return hash_digest

let status ~kind state (t : Package.t) : Status.t option Lwt.t =
  let open Lwt.Syntax in
  let package_url =
    package_url ~kind (Name.to_string t.name) (Version.to_string t.version)
  in

  let get_and_cache () =
    let+ content = http_get (package_url ^ "status.json") in
    let status =
      match content with
      | Ok s -> (
          match s |> Yojson.Safe.from_string |> Status.of_yojson with
          | Ok status -> Some status
          | Error e ->
              Logs.warn (fun m -> m "Error while parsing status.json: %s" e);
              None)
      | Error (`Msg e) ->
          Logs.warn (fun m -> m "Error while fetching status.json: %s" e);
          None
    in
    let status_entry =
      { documentation_status = status; time = Unix.gettimeofday () }
    in
    state.doc_status_cache <-
      Name.Map.update t.name
        (Version.Map.add t.version status_entry)
        (Version.Map.singleton t.version status_entry)
        state.doc_status_cache;
    status
  in

  let has_cache_expired time =
    Unix.gettimeofday () -. time > Config.package_caches_ttl
  in

  match
    Name.Map.find_opt t.name state.doc_status_cache
    |> Option.map (Version.Map.find_opt t.version)
    |> Option.value ~default:None
  with
  | None -> get_and_cache ()
  | Some { time; _ } when has_cache_expired time -> get_and_cache ()
  | Some { documentation_status; _ } -> Lwt.return documentation_status
