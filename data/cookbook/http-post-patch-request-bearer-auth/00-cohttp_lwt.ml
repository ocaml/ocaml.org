---
packages:
  - name: "cohttp"
    tested_version: "5.3.1"
    used_libraries:
      - cohttp
  - name: "cohttp-lwt-unix"
    tested_version: "5.3.1"
    used_libraries:
      - cohttp-lwt-unix
  - name: "lwt"
    tested_version: "5.7.0"
    used_libraries:
      - lwt
  - name: "lwt_ppx"
    tested_version: "2.1.0"
    used_libraries:
      - lwt_ppx
  - name: "tls-lwt"
    tested_version: "0.17.5"
    used_libraries:
      - tls-lwt
discussion: |
  Running this example may result in an error: `Exception: Failure No SSL or TLS support compiled into Conduit`. To resolve this issue you can run `opam install tls-lwt`

  The code below uses the GitHub REST API as an example. Please review the documentation here: [github.com/restap/issues/comments](https://docs.github.com/en/rest/issues/comments?apiVersion=2022-11-28#create-an-issue-comment).
---

open Lwt.Syntax
open Cohttp
open Cohttp_lwt_unix

(* Create message payloads in JSON format *)
let post_message_body =
  ref "{\"body\":\"This is a good issue to work on!\"}"
let patch_message_body =
  ref "{\"body\":\"Updated with the Github REST API!\"}"

(*
Make an HTTP request with Bearer Token authentication.
The `Authorization` header has the form `Bearer <your token>`.
Ensure you always keep your token secret.
*)
let make_request ~method_ ~uri ~message_body =
  let header_add s1 s2 h = Header.add h s1 s2 in
  let headers =
    Header.init ()
    |> header_add "Accept" "application/vnd.github+json"
    |> header_add "Authorization" "Bearer <your token>"
    |> header_add "X-GitHub-Api-Version" "2022-11-28"
  in
  let body = Cohttp_lwt.Body.of_string !message_body in

  let* resp, resp_body =
    Client.call ~headers ~body method_ uri
  in
  let code =
    resp |> Response.status |> Code.code_of_status
  in
  let+ body = Cohttp_lwt.Body.to_string resp_body in
  code, body

let () =
(* POST request example *)
  let post_uri =
    Uri.of_string
      "https://api.github.com/repos/<username>/<repo>/issues/<issue number>/comments"
  in
  let post_response_code, post_response_body =
    Lwt_main.run (
      make_request
        ~method_:`POST
        ~uri:post_uri
        ~message_body:post_message_body
    )
  in
  Printf.printf "POST Response code: %d\n" post_response_code;
  Printf.printf "POST Response body: %s\n\n" post_response_body;

(* PATCH request example *)
  let patch_uri =
    Uri.of_string
      "https://api.github.com/repos/<username>/<repo>/issues/comments/<comment_id>"
  in
  let patch_response_code, patch_response_body =
    Lwt_main.run (
      make_request
        ~method_:`PATCH
        ~uri:patch_uri
        ~message_body:patch_message_body
    )
  in
  Printf.printf "PATCH Response code: %d\n" patch_response_code;
  Printf.printf "PATCH Response body: %s\n" patch_response_body
