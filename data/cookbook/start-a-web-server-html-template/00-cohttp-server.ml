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
- name: "tyxml"
  tested_version: "4.6.0"
  used_libraries:
  - tyxml
discussion: |
  This example demonstrates how to build an HTTP server using `cohttp-lwt-unix` and safely render an HTML template with `Tyxml` in OCaml
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
open Tyxml.Html

let html_template =
  html
    (head (title (txt "Template Page")) [meta ~a:[a_charset "UTF-8"] ()])
    (body [h1 [txt "Hello World!"]])

let response_body = Format.asprintf "%a" (pp ()) html_template

let () =
  let callback _conn _req _body =
    Server.respond_string ~status:`OK ~body:response_body 
      ~headers:(Header.init_with "Content-Type" "text/html") ()
  in
  let server = Server.make ~callback () in
  let port = 8080 in
  let mode = `TCP (`Port port) in
  Format.printf "listening on http://localhost:%d\n%!" port;
  Server.create ~mode server |> Lwt_main.run
