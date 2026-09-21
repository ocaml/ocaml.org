(** MCP (Model Context Protocol) server for ocaml.org (issue #3775).

    Phase 1 smoke test: a Streamable HTTP endpoint exposing the [initialize] and
    [tools/list] handshake plus a single no-op [ping] tool. Feature blocks
    (package dependencies, docs, search) register further tools in {!Tool}. *)

(** MCP routes to mount on the Dream router (a POST + a GET on [/mcp]). *)
let routes = Transport.routes

(** Handle one raw JSON-RPC request body, returning the response body, or [None]
    for a notification (which takes no reply). Transport-agnostic; exposed for
    testing. *)
let handle = Server.handle
