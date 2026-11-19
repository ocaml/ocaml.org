(* --- Which package provides a module or a library. ---

   Answers "Unbound module X" and "Library \"x\" not found" when the name does
   not tell which package to look at. A global index of every module of every
   package would need the documentation of thousands of packages, so the search
   is bounded to candidates: the packages given, the direct dependencies of a
   package, and packages named after the module or library. Each candidate costs
   the status of its newest versions (to find a documented one, at most
   [doc_depth]) and one sidebar, all cached by [Documentation]; candidates are
   read through {!Ocamlorg_mcp.Fanout}, a bounded number at once, with a
   deadline after which the result is partial. A candidate whose status could
   not be read is a backend failure too, not a package without documentation. *)

module Package = Ocamlorg_package
module Tool = Ocamlorg_mcp.Tool
module Fanout = Ocamlorg_mcp.Fanout
module Navmap = Ocamlorg_frontend.Navmap

let max_candidates = 40
let max_matches = 50

(* How many of a candidate's newest versions are probed for documentation: 5, or
   fewer if OCAMLORG_LATEST_DOC_VERSION_DEPTH is lower, as for the other tools.
   A candidate costs a probe per version, and a call has up to 40. *)
let doc_depth = min 5 Package.latest_documented_version_depth

(* A module or library name: letters, digits and "_", "'", "-", in components
   separated by dots. *)
let valid_name s =
  String.length s <= 200
  && List.for_all
       (fun c ->
         c <> ""
         && String.for_all
              (function
                | 'A' .. 'Z' | 'a' .. 'z' | '0' .. '9' | '_' | '\'' | '-' ->
                    true
                | _ -> false)
              c)
       (String.split_on_char '.' s)

(* Package names guessed from a module or library name: the first component,
   lowercased, and its prefixes at each "_", each with "_" and with "-":
   "lwt.unix" -> "lwt"; "Lwt_main" -> "lwt_main", "lwt-main", "lwt";
   "Cohttp_lwt_unix" -> "cohttp_lwt_unix", "cohttp-lwt-unix", "cohttp_lwt",
   "cohttp-lwt", "cohttp". *)
let guessed_packages target =
  let root =
    match String.split_on_char '.' target with x :: _ -> x | [] -> target
  in
  let parts =
    String.split_on_char '_' (String.lowercase_ascii root)
    |> List.filter (( <> ) "")
  in
  let n = List.length parts in
  let prefixes =
    List.init n (fun i ->
        String.concat "_" (List.filteri (fun j _ -> j < n - i) parts))
  in
  let seen = Hashtbl.create 16 in
  List.concat_map
    (fun p -> [ p; String.map (fun c -> if c = '_' then '-' else c) p ])
    prefixes
  |> List.filter (fun p ->
      if Hashtbl.mem seen p then false
      else (
        Hashtbl.add seen p ();
        true))

(* One match in a package's sidebar. *)
type provider =
  | Library of { name : string; path : string option }
  | Module of Mcp_docs.module_match

(* The libraries named [target] in a sidebar. docs-ci gives library nodes no
   page, so their path is usually [None]. *)
let find_libraries ~name ~version ~target (sidebar : Navmap.t) =
  let rec go (nodes : Navmap.t) =
    List.concat_map
      (fun (n : Navmap.toc) ->
        match n.kind with
        | Navmap.Library when Mcp_docs.library_name n = target ->
            Library
              {
                name = target;
                path =
                  Option.map (Mcp_tools.doc_relative_path ~name ~version) n.href;
              }
            :: go n.children
        | _ -> go n.children)
      nodes
  in
  go sidebar

(* The libraries and modules of a sidebar that [target] names, for [kind]
   "module", "library" or "any", and whether the modules were cut at
   [Mcp_docs.default_max_matches]. A module path is resolved by
   {!Mcp_docs.resolve_module}: "Lwt_unix.LargeFile", or "Infix" for the least
   nested modules of that name. *)
let find_in_sidebar ~kind ~target ~name ~version sidebar =
  let libraries =
    if kind = "module" then []
    else find_libraries ~name ~version ~target sidebar
  in
  let modules, truncated =
    match (kind, Mcp_docs.parse_module_path target) with
    | "library", _ | _, Error _ -> ([], false)
    | _, Ok path ->
        let r = Mcp_docs.resolve_module ~name ~version sidebar path in
        (List.map (fun m -> Module m) r.matches, r.matches_truncated)
  in
  (libraries @ modules, truncated)

(* The libraries of the OCaml distribution, by module and by findlib name: no
   opam package provides them, and docs-ci does not document them. *)
let compiler_libraries =
  [
    "Stdlib";
    "Unix";
    "UnixLabels";
    "Str";
    "Dynlink";
    "Thread";
    "Event";
    "Runtime_events";
    "stdlib";
    "unix";
    "str";
    "dynlink";
    "threads";
    "runtime_events";
  ]

let compiler_library_note target =
  let root =
    match String.split_on_char '.' target with x :: _ -> x | [] -> target
  in
  if List.mem root compiler_libraries then
    Some
      (Printf.sprintf
         "%s comes with the OCaml compiler, not with an opam package: see the \
          API reference of the OCaml distribution at https://ocaml.org/api/"
         root)
  else None

let find_module_schema =
  `Assoc
    [
      ("type", `String "object");
      ( "properties",
        `Assoc
          [
            ( "name",
              `Assoc
                [
                  ("type", `String "string");
                  ( "description",
                    `String
                      "A module path as written in OCaml code (\"EzLwtSys\", \
                       \"Lwt_main\", \"Lwt_unix.LargeFile\") or a findlib \
                       library name (\"lwt.unix\")." );
                ] );
            ( "kind",
              `Assoc
                [
                  ("type", `String "string");
                  ( "enum",
                    `List [ `String "any"; `String "module"; `String "library" ]
                  );
                  ("description", `String "What to look for. Default \"any\".");
                ] );
            ( "packages",
              `Assoc
                [
                  ("type", `String "array");
                  ("items", `Assoc [ ("type", `String "string") ]);
                  ("description", `String "Optional packages to search.");
                ] );
            ( "dependencies_of",
              `Assoc
                [
                  ("type", `String "string");
                  ( "description",
                    `String
                      "Optional package whose direct dependencies (and \
                       optional dependencies) to search; not their own \
                       dependencies." );
                ] );
            ( "dependencies_of_version",
              `Assoc
                [
                  ("type", `String "string");
                  ( "description",
                    `String
                      "Optional version of dependencies_of. Defaults to its \
                       latest release." );
                ] );
          ] );
      ("required", `List [ `String "name" ]);
    ]

type query = {
  target : string;
  kind : string;
  given : string list;  (** the packages given, as given *)
  deps : string list;
}

let parse_query state args =
  let ( let* ) = Result.bind in
  let* target =
    match Mcp_tools.string_member "name" args with
    | None | Some "" -> Error "missing required argument: \"name\""
    | Some n when not (valid_name n) ->
        Error (Printf.sprintf "invalid name: %S" n)
    | Some n -> Ok n
  in
  let* kind =
    match Mcp_tools.optional_string_member "kind" args with
    | Ok (None | Some "any") -> Ok "any"
    | Ok (Some (("module" | "library") as k)) -> Ok k
    | Ok (Some k) -> Error (Printf.sprintf "unknown kind: %S" k)
    | Error e -> Error e
  in
  (* A name looked up only as a module must be a module path ("make.real" is
     not), as in ocaml_module_changes; with "any", it may still be a library. *)
  let* () =
    if kind = "module" then
      Result.map (fun _ -> ()) (Mcp_docs.parse_module_path target)
    else Ok ()
  in
  let* given =
    match args with
    | `Assoc f -> (
        match List.assoc_opt "packages" f with
        | None | Some `Null -> Ok []
        | Some (`List l) ->
            List.fold_right
              (fun x acc ->
                let* acc = acc in
                match x with
                | `String s -> Ok (s :: acc)
                | _ -> Error "argument \"packages\" must be an array of strings")
              l (Ok [])
        | Some _ -> Error "argument \"packages\" must be an array of strings")
    | _ -> Ok []
  in
  let* deps =
    let* of_ = Mcp_tools.optional_string_member "dependencies_of" args in
    let* version =
      Mcp_tools.optional_string_member "dependencies_of_version" args
    in
    match of_ with
    | None -> Ok []
    | Some p ->
        let* pkg = Mcp_tools.resolve state p version in
        Ok
          (List.map
             (fun (n, _) -> Package.Name.to_string n)
             (Package.dependencies pkg @ Package.depopts pkg))
  in
  Ok { target; kind; given; deps }

type candidate_result =
  | Match of { found : provider list; truncated : bool }
  | No_match
  | No_docs
  | Docs_unavailable

(* [deadline] bounds the time spent on docs-ci. *)
let find_module ?docs ?(deadline = Mcp_docs.call_deadline) state : Tool.t =
  {
    name = "ocaml_module_find";
    description =
      Printf.sprintf
        "Find which package provides a module or a findlib library, among \
         candidate packages: the ones given in \"packages\", the direct \
         dependencies (and optional dependencies) of \"dependencies_of\" (not \
         their own dependencies), and packages named after the module or \
         library or a prefix of it (\"lwt\" for \"Lwt_main\"), at most %d. For \
         each match: the package, its latest documented version, the library \
         defining the module, the module's full path (\"Infix\" finds \
         \"Lwt.Infix\"), and the page path to pass to \
         ocaml_module_documentation. Use it to find which package (or which of \
         a package's dependencies) a module comes from, e.g. when reading code \
         that uses it or after an \"Unbound module\" or \"Library not found\" \
         error. It searches the candidates only, not every package, and only \
         those documented in one of their %d newest versions. Packages given \
         that do not exist are listed in \"unknown_packages\". When docs-ci \
         could not be read for some candidates, or the call ran out of time, \
         \"partial\" is true: call again later. The modules of the OCaml \
         distribution (Stdlib, Unix, Str, ...) are in no package."
        max_candidates doc_depth;
    input_schema = find_module_schema;
    handler =
      (fun args ->
        match parse_query state args with
        | Error e -> Lwt.return (Error e)
        | Ok q -> (
            let open Lwt.Syntax in
            let docs =
              match docs with Some d -> d | None -> Mcp_docs.docs_ci state
            in
            let known n =
              match Package.Name.of_string_opt n with
              | Some name when Package.get_latest state name <> None ->
                  Some name
              | _ -> None
            in
            let unknown_packages =
              List.filter (fun n -> known n = None) q.given
            in
            let seen = Hashtbl.create 64 in
            (* given packages first, then guesses, then dependencies *)
            let candidates =
              List.filter_map known
                (q.given @ guessed_packages q.target @ q.deps)
              |> List.filter (fun name ->
                  let n = Package.Name.to_string name in
                  if Hashtbl.mem seen n then false
                  else (
                    Hashtbl.add seen n ();
                    true))
            in
            let candidates_truncated =
              List.length candidates > max_candidates
            in
            let candidates =
              List.filteri (fun i _ -> i < max_candidates) candidates
            in
            match candidates with
            | [] ->
                Lwt.return
                  (Error
                     (Printf.sprintf
                        "no package to search for %S: none is named after it, \
                         and no known package was given in \"packages\" or as \
                         a dependency of \"dependencies_of\"%s%s"
                        q.target
                        (match unknown_packages with
                        | [] -> ""
                        | l ->
                            " (unknown packages: "
                            ^ String.concat ", "
                                (List.map (Printf.sprintf "%S") l)
                            ^ ")")
                        (match compiler_library_note q.target with
                        | Some note -> ". " ^ note
                        | None -> "")))
            | _ ->
                let check name =
                  let* pkg =
                    Mcp_docs.latest_documented ~depth:doc_depth docs state name
                  in
                  match pkg with
                  | Ok None -> Lwt.return (None, No_docs)
                  | Error pkg ->
                      (* its status could not be read *)
                      Lwt.return
                        ( Some (Package.Version.to_string (Package.version pkg)),
                          Docs_unavailable )
                  | Ok (Some pkg) -> (
                      let v = Package.Version.to_string (Package.version pkg) in
                      let+ sidebar = docs.sidebar pkg in
                      if sidebar = [] then (Some v, Docs_unavailable)
                      else
                        match
                          find_in_sidebar ~kind:q.kind ~target:q.target
                            ~name:(Package.Name.to_string name)
                            ~version:v sidebar
                        with
                        | [], _ -> (Some v, No_match)
                        | found, truncated ->
                            (Some v, Match { found; truncated }))
                in
                let+ outcomes = Fanout.map ~deadline check candidates in
                List.iter
                  (Mcp_docs.log_failure ~what:"ocaml_module_find candidate")
                  outcomes;
                let opt = function Some s -> `String s | None -> `Null in
                let results =
                  List.map2
                    (fun name outcome -> (Package.Name.to_string name, outcome))
                    candidates outcomes
                in
                let all_matches =
                  List.concat_map
                    (fun (package, outcome) ->
                      match outcome with
                      | Fanout.Done (version, Match { found; _ }) ->
                          List.map
                            (fun p ->
                              let common =
                                [
                                  ("package", `String package);
                                  ("version", opt version);
                                ]
                              in
                              `Assoc
                                (common
                                @
                                match p with
                                | Library { name; path } ->
                                    [
                                      ("kind", `String "library");
                                      ("library", `String name);
                                      ("module", `Null);
                                      ("path", opt path);
                                    ]
                                | Module m ->
                                    [
                                      ("kind", `String m.kind);
                                      ("library", opt m.library);
                                      ( "module",
                                        `String (Mcp_docs.module_path_string m)
                                      );
                                      ("path", `String m.page);
                                    ]))
                            found
                      | _ -> [])
                    results
                in
                let matches =
                  List.filteri (fun i _ -> i < max_matches) all_matches
                in
                let status = function
                  | Fanout.Done (_, Match _) -> "match"
                  | Fanout.Done (_, No_match) -> "no-match"
                  | Fanout.Done (_, No_docs) -> "no-docs"
                  | Fanout.Done (_, Docs_unavailable) -> "docs-unavailable"
                  | Fanout.Failed _ -> "error"
                  | Fanout.Skipped -> "skipped"
                in
                let partial =
                  List.exists
                    (fun (_, o) ->
                      match o with
                      | Fanout.Done (_, Docs_unavailable)
                      | Fanout.Failed _ | Fanout.Skipped ->
                          true
                      | Fanout.Done _ -> false)
                    results
                in
                Mcp_docs.ok_json ~partial
                  ([
                     ("name", `String q.target);
                     ("kind", `String q.kind);
                     ("matches", `List matches);
                     ( "matches_truncated",
                       `Bool
                         (List.length all_matches > max_matches
                         || List.exists
                              (function
                                | _, Fanout.Done (_, Match { truncated; _ }) ->
                                    truncated
                                | _ -> false)
                              results) );
                     ( "checked",
                       `List
                         (List.map
                            (fun (package, o) ->
                              `Assoc
                                ([
                                   ("package", `String package);
                                   ( "version",
                                     match o with
                                     | Fanout.Done (v, _) -> opt v
                                     | _ -> `Null );
                                   ("status", `String (status o));
                                 ]
                                @
                                match o with
                                | Fanout.Done (_, Match { truncated = true; _ })
                                  ->
                                    [ ("matches_truncated", `Bool true) ]
                                | _ -> []))
                            results) );
                     ( "unknown_packages",
                       `List (List.map (fun s -> `String s) unknown_packages) );
                     ("candidates_truncated", `Bool candidates_truncated);
                     ("partial", `Bool partial);
                     ( "deadline_reached",
                       `Bool (Fanout.deadline_reached outcomes) );
                   ]
                  @
                  match compiler_library_note q.target with
                  | Some note -> [ ("note", `String note) ]
                  | None -> [])));
    cacheable = true;
    annotations = Some Tool.read_only_annotations;
  }

let tools state : Tool.t list = [ find_module state ]
