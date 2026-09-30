(* Streamable HTTP transport for MCP over Dream: JSON-RPC 2.0 over HTTP POST,
   plus a GET that opens the (optional) server->client SSE stream. This is the
   transport remote MCP clients speak.

   The [/mcp] routes are wrapped in a per-IP rate-limit middleware and share an
   in-app response cache (the edge Varnish passes POST uncached), both built
   once per server from the config passed by the router.

   No [Origin] validation (issue #3813). The spec (2025-06-18) recommends it to
   blunt DNS-rebinding, but that threat model defends a loopback server that
   trusts privileged local state: a victim's browser is tricked into reaching a
   local endpoint that grants access it would deny a real cross-origin caller.
   This endpoint has nothing to protect that way -- it is public, read-only,
   no-auth, and holds no per-session state, so a rebound request reads only
   already-public data and carries no credentials to abuse. A strict [Origin]
   allowlist would also reject legitimate browser-based MCP clients. Revisit if
   that calculus changes: when server-push (the GET SSE stream below) or any
   session/auth state lands, [Origin] validation becomes worthwhile. *)

let post_handler ~tools cache request =
  let open Lwt.Syntax in
  let* body = Dream.body request in
  let* response = Server.handle ~cache ~tools body in
  match response with
  | None ->
      (* Notification: acknowledge with no body. *)
      Dream.respond ~status:`Accepted ""
  | Some response ->
      Dream.respond ~headers:[ ("Content-Type", "application/json") ] response

(* The Streamable HTTP GET stream carries server-initiated messages over
   [text/event-stream]. We have no server-push feature yet, so we decline the
   GET with 405 rather than opening a stream that closes immediately: the
   spec-sanctioned signal that this endpoint is POST-only, which strict clients
   (Gemini among them) rely on. When real server-push lands, replace this with a
   [Dream.stream] handler emitting [Content-Type: text/event-stream]. *)
let get_handler _request =
  Dream.respond ~status:`Method_Not_Allowed
    ~headers:[ ("Allow", "POST") ]
    "GET is not supported: this MCP endpoint has no server-initiated stream; \
     use POST."

let routes ?(tools = []) ~rate_limit ~rate_window ~cache_max ~cache_ttl () =
  let limiter =
    Rate_limiter.create ~max_requests:rate_limit
      ~window_seconds:(float_of_int rate_window) ()
  in
  let cache =
    Cache.create ~max_entries:cache_max ~ttl:(float_of_int cache_ttl)
  in
  [
    Dream.scope ""
      [ Rate_limiter.middleware limiter ]
      [
        Dream.post "/mcp" (post_handler ~tools cache);
        Dream.get "/mcp" get_handler;
      ];
  ]
