(* Streamable HTTP transport for MCP over Dream: JSON-RPC 2.0 over HTTP POST,
   plus a GET that opens the (optional) server->client SSE stream. This is the
   transport remote MCP clients speak. *)

let post_handler request =
  let open Lwt.Syntax in
  let* body = Dream.body request in
  match Server.handle body with
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

let routes () = [ Dream.post "/mcp" post_handler; Dream.get "/mcp" get_handler ]
