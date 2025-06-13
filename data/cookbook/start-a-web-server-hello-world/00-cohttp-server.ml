---
packages:
- name: "cohttp-lwt-unix"
  tested_version: "5.3.0"
  used_libraries:
  - cohttp-lwt-unix
- name: "lwt"
  tested_version: "5.7.0"
  used_libraries:
  - lwt
  - lwt.infix
discussion: |
  This example shows how to use `cohttp-lwt-unix` to start an HTTP server in OCaml using `Lwt`
---
(* The server:
  - Handles any incoming request on port 8080
  - Responds with a static `Hello world` message
  - Uses Server.respond_string to return a simple text response
  `Lwt (Lwt.Infix)` is used for chaining asynchronous computations *)
open Lwt.Infix
open Cohttp_lwt_unix

let () =
  let callback _conn _req body =
    Cohttp_lwt.Body.drain_body body >>= fun () -> 
    Server.respond_string ~status:`OK ~body:"Hello world" ()
  in
  let server = Server.make ~callback () in
  let port = 8080 in
  let mode = `TCP (`Port port) in
  Format.printf "listening on http://localhost:%d\n%!" port;
  Server.create ~mode server |> Lwt_main.run
