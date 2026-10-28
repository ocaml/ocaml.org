module Status = struct
  type redirection = { old_path : string; new_path : string }
  [@@deriving yojson]

  type t = {
    name : string;
    version : string;
    failed : bool;
    files : string list;
    redirections : redirection list;
    search_index_digest : string option; [@default None]
        (* Optional: digest of the odoc search index (doc/index.js), computed by
           ocaml-docs-ci / voodoo. When present, ocaml.org uses it directly
           instead of downloading the whole index to hash it. See
           ocaml/ocaml.org#3765 and ocurrent/ocaml-docs-ci#193. *)
  }
  [@@deriving yojson { strict = false }]
  (* [strict = false]: tolerate unknown fields so the docs backend can extend
     status.json (e.g. adding [search_index_digest]) without breaking parsing on
     older/newer deployments. *)

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

  (* [files] lists every file of the package's documentation, often thousands of
     names, but is only ever searched for the README, LICENSE and CHANGES names
     above. [slim] keeps just those, so a cached status record stays small. *)
  let slim (v : t) : t =
    let is_special_file x =
      match Fpath.of_string x with
      | Ok p -> is_special Fpath.(p |> rem_ext |> filename)
      | Error _ -> false
    in
    { v with files = List.filter is_special_file v.files }
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

  let to_navmap s =
    let map_url = Option.map (fun url -> "/" ^ url) in
    let rec navmap_of_sidebar ?(first_layer = false) (sidebar : tree) =
      Ocamlorg_frontend.Navmap.
        {
          title = sidebar.node.content;
          kind =
            (match sidebar.node.kind with
            | Some "module" -> Module
            | (Some ("page" | "leaf-page") | None)
              when String.starts_with ~prefix:"Library " sidebar.node.content ->
                Library
            | Some ("page" | "leaf-page") -> Page
            | Some "module-type" -> Module_type
            | Some "parameter" -> Parameter
            | Some "class" -> Class
            | Some "class-type" -> Class_type
            | Some "file" -> File
            | Some "source" -> Source
            | None -> Page
            | _ -> File);
          href = map_url sidebar.node.url;
          children =
            (let children =
               List.map (navmap_of_sidebar ~first_layer:false) sidebar.children
             in
             (* The docs CI generates readme files in the wring place, and they
                end up in the toc, so we filter them out here *)
             if first_layer then
               List.filter
                 (function
                   | Ocamlorg_frontend.Navmap.{ title; _ }
                     when Status.is_special title ->
                       false
                   | _ -> true)
                 children
             else children);
        }
    in
    navmap_of_sidebar s
end

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
  let uri = Uri.of_string url in
  let max_bytes = Config.max_doc_fetch_bytes in
  Lwt.catch
    (fun () ->
      (* We drive the connection explicitly rather than through
         [Cohttp_lwt_unix.Client.get] so that we can [Connection.close] it on
         the reject paths. cohttp tears a connection down only once its response
         body stream has been fully consumed, so simply dropping an over-large
         body leaks the socket for the life of the process (the same class of
         fd-exhaustion seen on 2026-10-03). An explicit close drops the socket
         without reading the rest of the payload. See ocaml/ocaml.org#3765. *)
      let ctx = Lazy.force Cohttp_lwt_unix.Net.default_ctx in
      let* endp = Cohttp_lwt_unix.Net.resolve ~ctx uri in
      let* conn =
        Cohttp_lwt_unix.Connection.connect ~ctx ~persistent:false endp
      in
      let close () = Cohttp_lwt_unix.Connection.close conn in
      let too_large n =
        Logs.warn (fun m ->
            m "Response too large (%d bytes > %d limit) for %s" n max_bytes url);
        close ();
        Lwt.return
          (Error
             (`Msg
               (Printf.sprintf "response too large (> %d bytes) for %s"
                  max_bytes url)))
      in
      let* response, body =
        Cohttp_lwt_unix.Connection.call conn ~headers `GET uri
      in
      match Cohttp.Code.(code_of_status response.status |> is_success) with
      | false ->
          close ();
          Lwt.return (Error (`Msg ("Failed to fetch " ^ url)))
      | true -> (
          let content_length =
            Cohttp.Header.get response.headers "content-length"
            |> Fun.flip Option.bind int_of_string_opt
          in
          match content_length with
          | Some n when n > max_bytes -> too_large n
          | _ ->
              (* Stream the body, enforcing the cap as we read, so a chunked or
                 mislabelled response can't blow up memory. Pre-size the buffer
                 from Content-Length when present to avoid repeated doublings on
                 the hot path. *)
              let initial =
                match content_length with
                | Some n when n > 0 && n <= max_bytes -> n
                | _ -> 65536
              in
              let buf = Buffer.create initial in
              let exception Too_large in
              Lwt.catch
                (fun () ->
                  let* () =
                    Cohttp_lwt.Body.to_stream body
                    |> Lwt_stream.iter_s (fun chunk ->
                           if
                             Buffer.length buf + String.length chunk > max_bytes
                           then raise Too_large
                           else (
                             Buffer.add_string buf chunk;
                             Lwt.return_unit))
                  in
                  close ();
                  Lwt.return (Ok (Buffer.contents buf)))
                (function
                  | Too_large -> too_large (Buffer.length buf)
                  | e ->
                      close ();
                      Lwt.reraise e)))
    (function
      | e ->
          Logs.err (fun m -> m "%s" (Printexc.to_string e));
          Lwt.return (Error (`Msg (Printexc.to_string e))))

(* Fetch a resource's ETag with a headers-only HEAD, transferring no body. dill
   serves a per-version ETag for doc assets (verified on [doc/index.js]); it is
   a ready-made content fingerprint, so we can use it as a cache-busting token
   for the search index without ever downloading the (potentially huge) body.
   The value is opaque — downstream it is base64url-encoded into a URL and never
   compared server-side — so we only normalise away the optional weak-validator
   [W/] prefix and surrounding quotes to keep the token stable. See
   ocaml/ocaml.org#3765. *)
let head_etag url =
  let open Lwt.Syntax in
  Logs.info (fun m -> m "HEAD %s" url);
  Lwt.catch
    (fun () ->
      let* response = Cohttp_lwt_unix.Client.head (Uri.of_string url) in
      if Cohttp.Code.(code_of_status response.status |> is_success) then
        Cohttp.Header.get response.headers "etag"
        |> Option.map (fun s ->
               let s =
                 if String.length s >= 2 && String.sub s 0 2 = "W/" then
                   String.sub s 2 (String.length s - 2)
                 else s
               in
               let n = String.length s in
               if n >= 2 && s.[0] = '"' && s.[n - 1] = '"' then
                 String.sub s 1 (n - 2)
               else s)
        |> Lwt.return
      else Lwt.return None)
    (fun e ->
      Logs.warn (fun m -> m "HEAD %s failed: %s" url (Printexc.to_string e));
      Lwt.return None)

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
        (* [String.concat], not [header ^ preamble ^ content]: the [^] chain
           allocates an intermediate [header ^ preamble] and then re-copies it
           into the result, so it copies the prefix twice. [String.concat]
           pre-sizes the result and blits each part once. These are per-doc-page
           strings, so halving the copies trims GC churn under crawler load. See
           ocaml/ocaml.org#3765.

           A fully churn-free version would keep the three parts and write them
           as separate chunks to the response, never materialising this combined
           string — but that means changing [content] to carry the parts, giving
           the page template three slots instead of one, and updating the other
           consumers (readme, package overview). Out of scope here. *)
        content = String.concat "" [ header; preamble; content ];
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

(* The docs-ci response caches (sidebars, rendered pages, per-version build
   status and search-index tokens) all use the shared {!Bounded_cache}: the docs
   backend is proxied uncached, so these bound memory and expire entries so
   documentation rebuilds are eventually picked up. Access is synchronous under
   cooperative Lwt scheduling, so the cache needs no lock; two concurrent misses
   may both fetch (harmless). The clock is passed in per call. *)
let now () = Unix.gettimeofday ()
let kind_key = function `Package -> "p" | `Universe s -> "u:" ^ s

let sidebar_cache : Ocamlorg_frontend.Navmap.t Bounded_cache.t =
  Bounded_cache.create ~max_entries:Config.doc_cache_max
    ~ttl:Config.package_caches_ttl

let generic_url base ~kind name version =
  match kind with
  | `Package -> base ^ "p/" ^ name ^ "/" ^ version ^ "/"
  | `Universe s -> base ^ "u/" ^ s ^ "/" ^ name ^ "/" ^ version ^ "/"

let package_url ~kind name version =
  generic_url Config.documentation_url ~kind name version

(* Build status is tracked per package version, not per universe (universes only
   disambiguate cross-reference link targets), so the status URL always uses the
   [`Package] form even when reached from a universe doc page. *)
let doc_status_url name version =
  generic_url Config.documentation_status_url ~kind:`Package name version

let sidebar ~kind (t : Package.t) =
  let package_url =
    package_url ~kind (Name.to_string t.name) (Version.to_string t.version)
  in
  let open Lwt.Syntax in
  let key =
    Name.to_string t.name ^ "|"
    ^ Version.to_string t.version
    ^ "|" ^ kind_key kind
  in
  (* Negative-cache a miss ([[]]) for a short TTL so a retry storm for an
     undocumented package does not re-hit the backend on every request, while a
     documentation rebuild is still picked up within [doc_negative_ttl]. *)
  let cache_miss () =
    Bounded_cache.store ~ttl:Config.doc_negative_ttl sidebar_cache ~now:(now ())
      ~key []
  in
  match Bounded_cache.find sidebar_cache ~now:(now ()) ~key with
  | Some sidebar -> Lwt.return sidebar
  | None -> (
      let url = package_url ^ "doc/sidebar.json" in
      let+ content = http_get url in
      match content with
      | Ok v -> (
          let json = Yojson.Safe.from_string v in
          match Sidebar.of_yojson json with
          | Ok x ->
              let x = List.map Sidebar.to_navmap x in
              (* A non-empty sidebar is cached for the full TTL; an empty one is
                 a miss and gets the short negative TTL. *)
              if x <> [] then
                Bounded_cache.store sidebar_cache ~now:(now ()) ~key x
              else cache_miss ();
              x
          | Error msg ->
              Logs.info (fun m -> m "Failed to parse sidebar at %s: %s" url msg);
              cache_miss ();
              [])
      | Error _ ->
          Logs.info (fun m -> m "Failed to fetch sidebar at %s" url);
          cache_miss ();
          [])

(* The rendered doc page is keyed on its full fetch URL, which already encodes
   name/version/kind/path uniquely. *)
let page_cache : t option Bounded_cache.t =
  Bounded_cache.create ~max_entries:Config.doc_cache_max
    ~ttl:Config.package_caches_ttl

let odoc_page ~url =
  let open Lwt.Syntax in
  (* Negative-cache a miss ([None]) for a short TTL so repeated requests for a
     nonexistent/unparseable page do not re-hit the backend every time, while a
     documentation rebuild is still picked up within [doc_negative_ttl]. *)
  let cache_miss () =
    Bounded_cache.store ~ttl:Config.doc_negative_ttl page_cache ~now:(now ())
      ~key:url None
  in
  match Bounded_cache.find page_cache ~now:(now ()) ~key:url with
  | Some maybe_doc -> Lwt.return maybe_doc
  | None -> (
      let* content = http_get url in
      match content with
      | Ok content ->
          let maybe_doc =
            try Some (doc_from_string content)
            with Invalid_argument err ->
              Logs.err (fun m -> m "Invalid documentation page: %s" err);
              None
          in
          (* A successful parse is cached for the full TTL; a fetch/parse
             failure ([None]) is a miss and gets the short negative TTL. *)
          (match maybe_doc with
          | Some doc ->
              Bounded_cache.store page_cache ~now:(now ()) ~key:url (Some doc)
          | None -> cache_miss ());
          Logs.info (fun m -> m "Found documentation page for %s" url);
          Lwt.return maybe_doc
      | Error _ ->
          Logs.info (fun m -> m "Failed to fetch documentation page for %s" url);
          cache_miss ();
          Lwt.return None)

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
(* Per package version caches of the docs-ci build status and of the search
   index token. Both hold at most [doc_cache_max] entries (FIFO) and expire
   after [package_caches_ttl], like the page and sidebar caches. A cached [None]
   records a failed fetch so it is not retried on every request. *)
type doc_cache = {
  doc_status_cache : Status.t option Bounded_cache.t;
  search_index_cache : string option Bounded_cache.t;
}

let doc_cache_create () =
  {
    doc_status_cache =
      Bounded_cache.create ~max_entries:Config.doc_cache_max
        ~ttl:Config.package_caches_ttl;
    search_index_cache =
      Bounded_cache.create ~max_entries:Config.doc_cache_max
        ~ttl:Config.package_caches_ttl;
  }

let version_key (t : Package.t) =
  Name.to_string t.name ^ "|" ^ Version.to_string t.version

let status ~kind state (t : Package.t) : Status.t option Lwt.t =
  let open Lwt.Syntax in
  let package_url =
    package_url ~kind (Name.to_string t.name) (Version.to_string t.version)
  in

  let key = version_key t in
  match Bounded_cache.find state.doc_status_cache ~now:(now ()) ~key with
  | Some status -> Lwt.return status
  | None ->
      let+ content = http_get (package_url ^ "status.json") in
      let status =
        match content with
        | Ok s -> (
            match s |> Yojson.Safe.from_string |> Status.of_yojson with
            | Ok status -> Some (Status.slim status)
            | Error e ->
                Logs.warn (fun m -> m "Error while parsing status.json: %s" e);
                None)
        | Error (`Msg e) ->
            Logs.warn (fun m -> m "Error while fetching status.json: %s" e);
            None
      in
      Bounded_cache.store state.doc_status_cache ~now:(now ()) ~key status;
      status

let search_index_digest ~kind state (t : Package.t) : string option Lwt.t =
  let open Lwt.Syntax in
  let index_url =
    package_url ~kind (Name.to_string t.name) (Version.to_string t.version)
    ^ "doc/index.js"
  in
  (* Produce a cache-busting token for the search index. Prefer dill's ETag (a
     per-version fingerprint from a headers-only HEAD, so no body is
     transferred); only when no ETag is served do we fall back to downloading
     and hashing the (size-capped) index. The token is opaque —
     base64url-encoded into a URL and never compared server-side — so any value
     that changes with the content works. See ocaml/ocaml.org#3765 and
     ocurrent/ocaml-docs-ci#193. *)
  let compute_token () =
    let* etag = head_etag index_url in
    match etag with
    | Some _ as token -> Lwt.return token
    | None ->
        let+ content = search_index ~kind t in
        Option.map Digest.string content
  in
  let from_backend () =
    let key = version_key t in
    match Bounded_cache.find state.search_index_cache ~now:(now ()) ~key with
    | Some token -> Lwt.return token
    | None ->
        let+ token = compute_token () in
        Bounded_cache.store state.search_index_cache ~now:(now ()) ~key token;
        token
  in

  (* Prefer the digest published in status.json (no network beyond the status
     fetch we already cache). Otherwise fall back to the backend: ETag first,
     then hashing. *)
  let* status = status ~kind state t in
  match Option.bind status (fun s -> s.Status.search_index_digest) with
  | Some _ as digest -> Lwt.return digest
  | None -> from_backend ()
