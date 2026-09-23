(* Streamable HTTP transport for MCP over Dream: JSON-RPC 2.0 over HTTP POST,
   plus a GET that opens the (optional) server->client SSE stream. This is the
   transport remote MCP clients speak.

   The [/mcp] routes are wrapped in a per-IP rate-limit middleware and share an
   in-app response cache (the edge Varnish passes POST uncached), both built
   once per server from the config passed by the router. *)

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
