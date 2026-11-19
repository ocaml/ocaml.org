(* Every MCP tool, closing over the in-memory package state, as injected into
   the MCP routes by {!Router.mcp_route}: the tools of {!Mcp_tools}, and those
   defined in modules of their own because they build on {!Mcp_tools} and
   {!Mcp_docs}. *)
let tools state : Ocamlorg_mcp.Tool.t list =
  List.concat [ Mcp_tools.tools state; Mcp_version_tools.tools state ]
