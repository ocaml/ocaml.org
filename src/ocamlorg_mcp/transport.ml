(* Streamable HTTP transport for MCP over Dream: JSON-RPC 2.0 over HTTP POST,
   plus a GET that opens the (optional) server->client SSE stream. This is the
   transport remote MCP clients speak.

   The [/mcp] routes are wrapped in a per-IP rate-limit middleware and share an
   in-app response cache (the edge Varnish passes POST uncached), both built
   once per server from the config passed by the router. *)

let post_handler cache request =
  let open Lwt.Syntax in
  let* body = Dream.body request in
  match Server.handle ~cache body with
  | None ->
      (* Notification: acknowledge with no body. *)
      Dream.respond ~status:`Accepted ""
  | Some response ->
      Dream.respond ~headers:[ ("Content-Type", "application/json") ] response

(* Minimal SSE endpoint. The Streamable HTTP GET stream carries server-initiated
   messages; we hold it open with an initial comment. Real server-push arrives
   with later feature blocks. *)
let get_handler _request =
  Dream.stream
    ~headers:
      [
        ("Content-Type", "text/event-stream");
        ("Cache-Control", "no-cache");
        ("Connection", "keep-alive");
      ]
    (fun stream ->
      let open Lwt.Syntax in
      let* () = Dream.write stream ": ocaml.org MCP endpoint\n\n" in
      Dream.flush stream)

let routes ~rate_limit ~rate_window ~cache_max ~cache_ttl () =
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
      [ Dream.post "/mcp" (post_handler cache); Dream.get "/mcp" get_handler ];
  ]
