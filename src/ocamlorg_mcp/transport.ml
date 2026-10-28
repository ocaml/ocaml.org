(* Streamable HTTP transport for MCP over Dream: JSON-RPC 2.0 over HTTP POST.
   The GET is reserved for the (optional) server->client SSE stream, but we have
   no server-push yet, so it returns 405 (see [get_handler]). This is the
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

(* [/mcp] is public and unauthenticated, and the rate limiter bounds request
   *count*, not *size*; [Dream.body] buffers an unbounded body straight into the
   heap. A legitimate JSON-RPC request is a small object, so we reject anything
   past [max_body] bytes with 413 before it can cost us memory or downstream
   [Yojson]/[canonical_json] work (issue #3884). *)
let payload_too_large () =
  (* We respond without draining the rest of the (oversized) body — draining
     would reintroduce the very work we are refusing. On HTTP/1.1 an undrained
     body desyncs a keep-alive connection, so we ask for the connection to be
     closed rather than reused. *)
  Dream.respond ~status:`Payload_Too_Large
    ~headers:[ ("Content-Type", "application/json"); ("Connection", "close") ]
    {|{"error":"request body too large"}|}

(* Read the request body, aborting once more than [max_body] bytes have arrived.
   A declared [Content-Length] over the cap is rejected before any bytes are
   read; a chunked body with no declared length is read incrementally and cut
   off at the same bound ([Content-Length] is only a hint, so the incremental
   count is the real guard). Returns [None] iff the cap was exceeded; the cap is
   inclusive. *)
let read_body_capped ~max_body request =
  let open Lwt.Syntax in
  let over_declared =
    match Dream.header request "Content-Length" with
    | Some len -> (
        match int_of_string_opt (String.trim len) with
        | Some n -> n > max_body
        | None -> false)
    | None -> false
  in
  if over_declared then Lwt.return_none
  else
    let stream = Dream.body_stream request in
    let buf = Buffer.create 4096 in
    let rec loop () =
      let* chunk = Dream.read stream in
      match chunk with
      | None -> Lwt.return_some (Buffer.contents buf)
      | Some s ->
          (* Check before buffering so the high-water mark never exceeds
             [max_body]: a single oversized chunk is rejected without first
             copying it into [buf]. *)
          if Buffer.length buf + String.length s > max_body then Lwt.return_none
          else (
            Buffer.add_string buf s;
            loop ())
    in
    loop ()

let post_handler ~tools ~max_body cache request =
  let open Lwt.Syntax in
  let* body = read_body_capped ~max_body request in
  match body with
  | None -> payload_too_large ()
  | Some body -> (
      let* response = Server.handle ~cache ~tools body in
      match response with
      | None ->
          (* Notification: acknowledge with no body. *)
          Dream.respond ~status:`Accepted ""
      | Some response ->
          Dream.respond
            ~headers:[ ("Content-Type", "application/json") ]
            response)

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

let routes ?(tools = []) ~rate_limit ~rate_window ~cache_max ~cache_ttl
    ~max_body () =
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
        Dream.post "/mcp" (post_handler ~tools ~max_body cache);
        Dream.get "/mcp" get_handler;
      ];
  ]
