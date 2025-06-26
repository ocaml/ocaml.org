---
packages:
- name: "cohttp-lwt-unix"
  tested_version: "5.3.0"
  used_libraries:
  - cohttp-lwt-unix
- name: "cohttp"
  tested_version: "6.1.0"
  used_libraries:
  - cohttp
discussion: |
  This example shows how to use `cohttp-lwt-unix` to start an HTTP server and render a HTML template in OCaml
---
(* The server:
  - Handles any incoming request on port 8080
  - Responds with a static HTML template that displays "Hello World!"
  - Uses Server.respond_string to return the template with headers set as html/text
  - Uses Cohttp_lwt_unix for asynchronous operations
  - Uses Cohttp for HTTP handling
  *)

open Cohttp
open Cohttp_lwt_unix

let template = {|
  <!DOCTYPE html>
  <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Template Page</title>
    </head>
    <body>
      <h1>Hello World!</h1>
    </body>
  </html>
|}

let () =
  let callback _conn _req _body =
    Server.respond_string ~status:`OK ~body:template 
      ~headers:(Header.init_with "Content-Type" "text/html") ()
  in
  let server = Server.make ~callback () in
  let port = 8080 in
  let mode = `TCP (`Port port) in
  Format.printf "listening on http://localhost:%d\n%!" port;
  Server.create ~mode server |> Lwt_main.run
