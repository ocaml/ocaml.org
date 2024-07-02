---
packages:
  - name: "lwt"
    tested_version: "5.7.0"
    used_libraries:
      - lwt
  - name: "lwt_ppx"
    tested_version: "2.1.0"
    used_libraries:
      - lwt_ppx
  - name: "cohttp"
    tested_version: "5.3.1"
    used_libraries:
      - cohttp
  - name: "cohttp-lwt-unix"
    tested_version: "5.3.1"
    used_libraries:
      - cohttp-lwt-unix
  - name: "tls-lwt"
    tested_version: "0.17.5"
    used_libraries:
      - tls-lwt
discussion: |  
  - **SSL-TLS Exception:** Running this example may result in an error: `Exception: Failure No SSL or TLS support compiled into Conduit`. To resolve this issue you can run `opam install tls-lwt`
  - **Reference:** The code below uses the GitHub REST API as an example. Please review the documentation here: [github.com/restap/issues/comments](https://docs.github.com/en/rest/issues/comments?apiVersion=2022-11-28#create-an-issue-comment)
---

open Lwt.Syntax
open Cohttp
open Cohttp_lwt_unix

(* create the message payload for our PATCH request.*)
let message_body = ref "{\"body\":\"Updated with the Github REST API!\"}"

(* 
Since we are using Bearer Token authentication, we need to add the `Authorization` header, which has the form `Bearer <your token>`. 
Ensure you always keep your token secret.
*)
let request_body =
  let uri =
    Uri.of_string "https://api.github.com/repos/<username>/<repo>/issues/comments/<comment_id>" 
  in
  let header_add s1 s2 h = Header.add h s1 s2 in
  let headers =
    Header.init ()
    |> header_add "Accept" "application/vnd.github+json"
    |> header_add "Authorization" "Bearer <your token here>"
    |> header_add "X-GitHub-Api-Version" "2022-11-28"
  in
  let body = Cohttp_lwt.Body.of_string !message_body in

  let* resp, resp_body = Client.call ~headers ~body `PATCH uri in
  let code = resp |> Response.status |> Code.code_of_status in
  let+ body = Cohttp_lwt.Body.to_string resp_body in
  code, body

(* Example usage to print response code and response body *)
let () =
  let response_code, response_body = Lwt_main.run request_body in
  Printf.printf "Respose code: %d\n" response_code;
  Printf.printf "Response body: %s\n" response_body
