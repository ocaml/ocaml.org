(** MCP (Model Context Protocol) server for ocaml.org (issue #3775).

    Phase 1 smoke test: a Streamable HTTP endpoint exposing the [initialize] and
    [tools/list] handshake plus a single no-op [ping] tool. Feature blocks
    (package dependencies, docs, search) register further tools in {!Tool}. *)

(** MCP routes to mount on the Dream router (a POST + a GET on [/mcp], wrapped
    in a per-IP rate-limit middleware and sharing an in-app response cache). The
    rate-limit and cache parameters come from the web-app config. *)
let routes = Transport.routes

(** Handle one raw JSON-RPC request body, returning the response body, or [None]
    for a notification (which takes no reply). Transport-agnostic; exposed for
    testing. *)
let handle = Server.handle

module Tool = Tool
(** A tool the server exposes: name, description, JSON-Schema for arguments, and
    a JSON-in/JSON-out handler. Feature blocks in the web layer build {!Tool.t}
    values over their own data and inject them via [~tools] on {!routes}, so
    this library stays dependency-isolated (it never sees [ocamlorg_package]).
    See {!Tool}. *)

module Backend = Backend
(** SSRF allowlist: the choke point every future backend-fetching tool (Block B)
    must route outbound URLs through. See {!Backend}. *)

module Rate_limiter = Rate_limiter
(** Per-IP rate limiter guarding the [/mcp] route. See {!Rate_limiter}. *)

module Cache = Cache
(** Bounded TTL response cache for deterministic tool calls. See {!Cache}. *)
