(* Shared pieces of the MCP tools that read docs-ci beyond one page (issue
   #3775): which docs-ci accessors they use, how many fetches they make at once,
   how they find the latest documented version, how long they wait for docs-ci,
   how they resolve a module path in a sidebar, and how they report a partial
   result.

   The docs-ci accessors are a record ({!backend}), the production one being
   {!docs_ci}, so that a handler can be tested end to end on fixture pages. Its
   fetches share one process-wide bound ({!docs_ci_limiter}).

   {!resolve_module} is the one place that turns a module path as written in
   OCaml code ("Lwt_unix.LargeFile", "Infix", "Term" for why3's "Why3.Term")
   into documentation pages.

   Handlers that read many versions or packages in one call map over them with
   {!Ocamlorg_mcp.Fanout}, and mark a result that misses items (a failed fetch,
   the deadline) with {!ok_json} [~partial:true], so that the MCP response cache
   skips it.

   The status of a version has three outcomes: documented (or a failed build),
   no documentation, or a status that could not be read. The last one is a
   backend failure, which a tool reports as such (an error, or a partial
   result), never as "no documentation": that would be cached as a complete
   answer. *)

module Package = Ocamlorg_package
module Documentation = Package.Documentation
module Navmap = Ocamlorg_frontend.Navmap
module Tool = Ocamlorg_mcp.Tool

(* --- docs-ci accessors --- *)

type backend = {
  status : Package.t -> (Documentation.Status.t option, unit) result Lwt.t;
      (** The documentation build status of a version: [Ok None] when docs-ci
          has none (never built), [Error] when it could not be read. *)
  sidebar : Package.t -> Navmap.t Lwt.t;
      (** Its sidebar: [[]] when it has none or the fetch failed. *)
  page : Package.t -> string -> Documentation.t option Lwt.t;
      (** A page, by its doc-relative path ("lwt/Lwt/index.html"). *)
  file : Package.t -> string -> Documentation.t option Lwt.t;
      (** A file of the package, by its path from the package root
          ("doc/CHANGES.html"). *)
}

(* --- one bound on the docs-ci fetches of all calls --- *)

(* {!Ocamlorg_mcp.Fanout} bounds the fetches of one call, but calls run in
   parallel, each from a client that chooses how much it fetches (40 candidate
   packages, 60 versions). A limiter bounds the fetches of all of them: an
   accessor of {!limited} waits for one of its slots. A cached answer also takes
   a slot, though only for an instant. *)
type limiter = unit Lwt_pool.t

let limiter n : limiter = Lwt_pool.create (max 1 n) (fun () -> Lwt.return_unit)

let limited (l : limiter) (b : backend) : backend =
  let use f = Lwt_pool.use l (fun () -> f ()) in
  {
    status = (fun pkg -> use (fun () -> b.status pkg));
    sidebar = (fun pkg -> use (fun () -> b.sidebar pkg));
    page = (fun pkg path -> use (fun () -> b.page pkg path));
    file = (fun pkg path -> use (fun () -> b.file pkg path));
  }

(* The limiter of every MCP call: at most [OCAMLORG_MCP_DOCS_CONCURRENCY]
   docs-ci fetches at once. *)
let docs_ci_limiter = limiter Config.mcp_docs_concurrency

let docs_ci state =
  limited docs_ci_limiter
    {
      status = Documentation.status_result ~kind:`Package state;
      sidebar = Documentation.sidebar ~kind:`Package;
      page = Documentation.documentation_page ~kind:`Package;
      file = Documentation.file ~kind:`Package;
    }

(* The first of [versions] whose documentation was built, probing at most
   [depth] of them, in order: one status.json fetch each, cached by
   [Documentation]. [Error pkg] when the status of [pkg] could not be read: a
   later version may be the one, so the search stops there. *)
let first_documented ~depth backend state name
    (versions : Package.Version.t list) :
    (Package.t option, Package.t) result Lwt.t =
  let open Lwt.Syntax in
  let rec go fuel = function
    | [] -> Lwt.return (Ok None)
    | _ when fuel <= 0 -> Lwt.return (Ok None)
    | v :: rest -> (
        match Package.get state name v with
        | None -> go (fuel - 1) rest
        | Some pkg -> (
            let* status = backend.status pkg in
            match status with
            | Ok (Some { failed = false; _ }) -> Lwt.return (Ok (Some pkg))
            | Ok _ -> go (fuel - 1) rest
            | Error _ -> Lwt.return (Error pkg)))
  in
  go depth versions

(* All versions of [name], newest first. *)
let versions_newest_first state name =
  List.map
    (fun (v : Package.version_summary) -> v.version)
    (Package.get_versions state name)

let latest_documented ~depth backend state name =
  first_documented ~depth backend state name (versions_newest_first state name)

(* --- time --- *)

(* How long a tool waits for docs-ci in one call. Past it, the tool reports what
   it has, as a partial result or an error. Each fetch also has its own timeout
   (OCAMLORG_DOC_FETCH_TIMEOUT, 30 s by default), longer than this, but a call
   can make many fetches. *)
let call_deadline = 15.

(* [Some v] when [f ()] resolves to [v] within [seconds], else [None]: [f ()] is
   then cancelled, and so are its docs-ci fetches, which cache nothing. *)
let within seconds (f : unit -> 'a Lwt.t) : 'a option Lwt.t =
  let p = f () in
  match Lwt.state p with
  | Lwt.Return v -> Lwt.return (Some v)
  | _ ->
      Lwt.pick
        [
          Lwt.map Option.some p;
          Lwt.map (fun () -> None) (Lwt_unix.sleep (Float.max 0. seconds));
        ]

(* --- module paths --- *)

let valid_module_component p =
  p <> ""
  && (match p.[0] with 'A' .. 'Z' | 'a' .. 'z' | '_' -> true | _ -> false)
  && String.for_all
       (function
         | 'A' .. 'Z' | 'a' .. 'z' | '0' .. '9' | '_' | '\'' -> true
         | _ -> false)
       p

(* "Ortools.Sat" -> ["Ortools"; "Sat"]. A module whose name contains a quote
   ("M'") is valid OCaml, but its documentation page cannot be fetched (the path
   guard {!Mcp_tools.is_safe_path} excludes quotes), so it is rejected with that
   reason rather than reported missing. *)
let parse_module_path s =
  let parts = String.split_on_char '.' (String.trim s) in
  if not (List.for_all valid_module_component parts) then
    Error (Printf.sprintf "invalid module path: %S" s)
  else if String.contains s '\'' then
    Error
      (Printf.sprintf
         "invalid module path: %S (module names containing a quote are not \
          supported)"
         s)
  else Ok parts

(* --- resolving a module path in a sidebar --- *)

type module_match = {
  path : string list;  (** The full module path: ["Lwt"; "Infix"]. *)
  kind : string;  (** "module" or "module-type". *)
  library : string option;  (** The library that defines it. *)
  page : string;
      (** Its doc-relative page, safe to fetch (see {!Mcp_tools.is_safe_path}).
      *)
}

type resolution = {
  matches : module_match list;
  matches_truncated : bool;
  top_level : string list;
      (** The top-level modules of the sidebar, to suggest when nothing matches.
      *)
  top_level_truncated : bool;
}

let default_max_matches = 20
let max_top_level = 100
let title (n : Navmap.toc) = String.trim (Mcp_tools.strip_html n.title)
let library_name (n : Navmap.toc) = Navmap.library_name (title n)

let module_kind (n : Navmap.toc) =
  match n.kind with
  | Navmap.Module -> Some "module"
  | Navmap.Module_type -> Some "module-type"
  | _ -> None

let take n l = (List.filteri (fun i _ -> i < n) l, List.length l > n)

(* The modules of [sidebar] that module path [target] may name, as written in
   code that opened some modules.

   The first component is looked for among all the modules and module types of
   the tree, at any depth, and each next component among the children of the
   previous one: "Lwt_unix.LargeFile" is module [LargeFile] of top-level module
   [Lwt_unix], and "Term" can be "Why3.Term", for code that opened [Why3].

   Only the shallowest matches are kept (those whose first component has the
   fewest enclosing modules): a top-level [Result] wins over [Aaa.Result].
   Several matches at that depth are ambiguous: "Infix" in lwt is both
   [Lwt.Infix] and [Lwt_result.Infix]. They are returned in sidebar order, at
   most [max_matches].

   The sidebar of a docs-ci build lists every module, at every depth, so this
   needs no other fetch. *)
let resolve_module ?(max_matches = default_max_matches) ~name ~version
    (sidebar : Navmap.t) (target : string list) : resolution =
  let page_of (n : Navmap.toc) =
    match n.href with
    | Some href ->
        let page = Mcp_tools.doc_relative_path ~name ~version href in
        if Mcp_tools.is_safe_path page then Some page else None
    | None -> None
  in
  (* [n] is named after the first component of [rest]'s parent; follow [rest]
     through its descendants. *)
  let rec follow ancestors library (n : Navmap.toc) rest =
    let path = ancestors @ [ title n ] in
    match rest with
    | [] -> (
        match (module_kind n, page_of n) with
        | Some kind, Some page -> [ { path; kind; library; page } ]
        | _ -> [])
    | c :: rest ->
        List.concat_map
          (fun (child : Navmap.toc) ->
            if module_kind child <> None && title child = c then
              follow path library child rest
            else [])
          n.children
  in
  (* Every match, in sidebar order, with the number of modules enclosing its
     first component. *)
  let rec walk ancestors library (nodes : Navmap.t) =
    List.concat_map
      (fun (n : Navmap.toc) ->
        match (n.kind, module_kind n, target) with
        | Navmap.Library, _, _ ->
            walk ancestors (Some (library_name n)) n.children
        | _, Some _, first :: rest ->
            let here =
              if title n = first then
                List.map
                  (fun m -> (List.length ancestors, m))
                  (follow ancestors library n rest)
              else []
            in
            here @ walk (ancestors @ [ title n ]) library n.children
        | _ -> walk ancestors library n.children)
      nodes
  in
  let all = walk [] None sidebar in
  let shallowest =
    match all with
    | [] -> []
    | _ ->
        let depth = List.fold_left (fun d (d', _) -> min d d') max_int all in
        List.filter_map (fun (d, m) -> if d = depth then Some m else None) all
  in
  let matches, matches_truncated = take max_matches shallowest in
  let rec top (nodes : Navmap.t) =
    List.concat_map
      (fun (n : Navmap.toc) ->
        match module_kind n with
        | Some _ -> [ title n ]
        | None -> top n.children)
      nodes
  in
  let seen = Hashtbl.create 64 in
  let top_level =
    List.filter
      (fun t ->
        if Hashtbl.mem seen t then false
        else (
          Hashtbl.add seen t ();
          true))
      (top sidebar)
  in
  let top_level, top_level_truncated = take max_top_level top_level in
  { matches; matches_truncated; top_level; top_level_truncated }

let module_path_string (m : module_match) = String.concat "." m.path

let module_match_json (m : module_match) : Yojson.Safe.t =
  `Assoc
    [
      ("module", `String (module_path_string m));
      ("kind", `String m.kind);
      ("library", match m.library with Some l -> `String l | None -> `Null);
      ("path", `String m.page);
    ]

(* --- results --- *)

(* [Mcp_tools.ok_json], marked partial (see {!Tool.partial}) when [partial]: the
   result is served but not cached, since it misses items because of a failed
   fetch or the deadline. *)
let ok_json ~partial fields =
  let block = Tool.text_content (Yojson.Safe.to_string (`Assoc fields)) in
  Ok [ (if partial then Tool.partial block else block) ]

(* Log the items of a fan-out that raised, which the result reports as errors
   without the detail. *)
let log_failure ~what = function
  | Ocamlorg_mcp.Fanout.Failed e ->
      Logs.warn (fun m -> m "MCP: %s failed: %s" what (Printexc.to_string e))
  | _ -> ()
