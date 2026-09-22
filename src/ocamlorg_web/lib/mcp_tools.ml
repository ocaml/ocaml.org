(* Block A of the ocaml.org MCP server (issue #3775): package-dependency tools.

   These live in the web layer, not in [ocamlorg_mcp], on purpose. The MCP
   library is dependency-isolated (dream/lwt/yojson/unix only) and must never
   depend on [ocamlorg_package]. A tool's handler is a plain [Yojson.Safe.t ->
   (Yojson.Safe.t list, string) result], carrying no package types in its
   signature, so we build the tools here — closing over the in-memory
   [Ocamlorg_package.state] — and inject them into the routes via [~tools] (see
   {!Router.mcp_route}).

   The dependency data is all precomputed in [Ocamlorg_package.Info] at startup
   (direct/optional/conflicts, and reverse deps), so every tool is an O(1) field
   read — cheap even on a cache miss. We reuse the same accessors the GraphQL
   API and the package pages use (see [Graphql.get_info], [Handler] package
   overview). *)

module Package = Ocamlorg_package
module Info = Ocamlorg_package.Info
module Tool = Ocamlorg_mcp.Tool

(* Shared input schema: a package name and an optional exact version. *)
let input_schema =
  `Assoc
    [
      ("type", `String "object");
      ( "properties",
        `Assoc
          [
            ( "package",
              `Assoc
                [
                  ("type", `String "string");
                  ( "description",
                    `String "opam package name, e.g. \"lwt\" or \"dream\"." );
                ] );
            ( "version",
              `Assoc
                [
                  ("type", `String "string");
                  ( "description",
                    `String
                      "Optional exact version (e.g. \"5.9.0\"). Defaults to \
                       the latest release." );
                ] );
          ] );
      ("required", `List [ `String "package" ]);
    ]

let string_member key = function
  | `Assoc fields -> (
      match List.assoc_opt key fields with
      | Some (`String s) -> Some s
      | _ -> None)
  | _ -> None

(* Parse the [arguments] object into (package, optional version). *)
let parse_args args =
  match string_member "package" args with
  | None | Some "" -> Error "missing required argument: \"package\""
  | Some package -> Ok (package, string_member "version" args)

(* Resolve to a concrete [Package.t]: latest release when no version is given,
   else the exact version. Misses are returned as in-band tool errors (the MCP
   [isError:true] convention), not JSON-RPC errors. *)
let resolve state package version =
  match Package.Name.of_string_opt package with
  | None -> Error (Printf.sprintf "invalid package name: %S" package)
  | Some name -> (
      match version with
      | None -> (
          match Package.get_latest state name with
          | Some pkg -> Ok pkg
          | None -> Error (Printf.sprintf "unknown package: %S" package))
      | Some v -> (
          let ver = Package.Version.of_string v in
          match Package.get state name ver with
          | Some pkg -> Ok pkg
          | None ->
              Error
                (Printf.sprintf "unknown version %S of package %S" v package)))

let constraint_json = function Some s -> `String s | None -> `Null

(* [(name, constraint) list] -> JSON, matching Graphql.get_info's shape. *)
let deps_json (deps : (Package.Name.t * string option) list) : Yojson.Safe.t =
  `List
    (List.map
       (fun (name, cstr) ->
         `Assoc
           [
             ("name", `String (Package.Name.to_string name));
             ("constraint", constraint_json cstr);
           ])
       deps)

(* Run a handler that maps a resolved package's [Info.t] to a JSON object,
   wrapping the result in the single text-content block MCP clients expect. *)
let with_package state args (f : Info.t -> (string * Yojson.Safe.t) list) =
  let open Stdlib.Result in
  bind (parse_args args) (fun (package, version) ->
      bind (resolve state package version) (fun pkg ->
          let common =
            [
              ("package", `String (Package.Name.to_string (Package.name pkg)));
              ( "version",
                `String (Package.Version.to_string (Package.version pkg)) );
            ]
          in
          let body = f (Package.info pkg) in
          Ok
            [
              Tool.text_content (Yojson.Safe.to_string (`Assoc (common @ body)));
            ]))

let dependencies state : Tool.t =
  {
    name = "ocaml_package_dependencies";
    description =
      "Direct dependencies (with version constraints), optional dependencies, \
       and conflicts of an opam package. Defaults to the latest release; pass \
       \"version\" for a specific one.";
    input_schema;
    handler =
      (fun args ->
        with_package state args (fun info ->
            [
              ("dependencies", deps_json info.dependencies);
              ("optional", deps_json info.depopts);
              ("conflicts", deps_json info.conflicts);
            ]));
    cacheable = true;
  }

let reverse_dependencies state : Tool.t =
  {
    name = "ocaml_package_reverse_dependencies";
    description =
      "Packages that depend on the given opam package (\"used by\"), each with \
       its version constraint and latest release. Defaults to the latest \
       release of the queried package.";
    input_schema;
    handler =
      (fun args ->
        with_package state args (fun info ->
            let used_by =
              List.map
                (fun (name, cstr, version) ->
                  `Assoc
                    [
                      ("name", `String (Package.Name.to_string name));
                      ("constraint", constraint_json cstr);
                      ( "latest_version",
                        `String (Package.Version.to_string version) );
                    ])
                info.rev_deps
            in
            [
              ("count", `Int (List.length info.rev_deps));
              ("used_by", `List used_by);
            ]));
    cacheable = true;
  }

(* The Block A tools, closing over the in-memory package state. Injected into
   the MCP routes by {!Router.mcp_route}. *)
let tools state : Tool.t list =
  [ dependencies state; reverse_dependencies state ]
