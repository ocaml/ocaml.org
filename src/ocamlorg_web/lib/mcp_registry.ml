(* Every MCP tool, closing over the in-memory package state, as injected into
   the MCP routes by {!Router.mcp_route}: the tools of {!Mcp_tools}, and those
   defined in modules of their own, which build on {!Mcp_tools}. *)
let tools state : Ocamlorg_mcp.Tool.t list =
  List.concat
    [
      Mcp_tools.tools state;
      (* ocaml_module_find *)
      Mcp_find_module.tools state;
      (* ocaml_package_versions, ocaml_package_changelog *)
      Mcp_version_tools.tools state;
      (* ocaml_module_changes *)
      Mcp_api_changes.tools state;
    ]
