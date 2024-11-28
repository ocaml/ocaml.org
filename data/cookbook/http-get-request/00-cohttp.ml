---
packages:
- name: "lwt"
  tested_version: "5.7.0"
  used_libraries:
  - lwt
  - lwt.unix
- name: "cohttp"
  tested_version: "5.3.1"
  used_libraries:
  - cohttp
- name: "cohttp-lwt-unix"
  tested_version: "5.3.0"
  used_libraries:
  - cohttp-lwt-unix
discussion: |
  The `cohttp` package provides a client and a server implementation of HTTP(S).

  Note: `Lwt` is OCaml's library for handling asynchronous operations,
    similar to Promises in JavaScript
  The package `lwt_ppx` can be used for syntactic
    sugar (`let%lwt` instead of having to define a custom
    shorthand for `Lwt.bind`).
---

let ( let* ) = Lwt.bind

(*
This function performs an HTTP GET request to a given URL and handles the response.
It returns a Result type: Ok with the response body if successful, or Error with an error message.

Step by step:
1. Takes a URL as a string parameter
2. Uses `Cohttp_lwt_unix.Client.get` to make the HTTP request
   (`let*` is used because this is an asynchronous operation
   within the `Lwt` monad)
3. Extracts the HTTP status code from the response
4. If the status code indicates success (2xx):
   - Converts the response body to a string
   - Returns Ok with the body string
5. If not successful:
   - Returns Error with the HTTP error message
*)
let http_get url =
  let* (resp, body) =
    Cohttp_lwt_unix.Client.get (Uri.of_string url)
  in
  let code = resp
             |> Cohttp.Response.status
             |> Cohttp.Code.code_of_status in
  if Cohttp.Code.is_success code
  then
    let* b = Cohttp_lwt.Body.to_string body in
    Lwt.return (Ok b)
  else
    Lwt.return (Error (
      Cohttp.Code.reason_phrase_of_code code
    ))

(*
This is the main program that:
1. Runs our `http_get` function with ocaml.org as the target
2. Uses `Lwt_main.run` to execute our async code
3. Handles the result:
   - If `Error`: prints the URL and error message
   - If `Ok`: prints the URL and the received HTML content
4. All printing is done inside the `Lwt` monad (hence the `Lwt.return ()`)
*)
let () =
  let url = "https://ocaml.org" in
  Lwt_main.run (
    let* result = http_get url in
    match result with
    | Error str ->
       Printf.printf "%s:fail\n" url;
       Printf.printf "Error: %s\n" str;
       Lwt.return ()
    | Ok result ->
       Printf.printf "%s:succed\n" url;
       print_string result;
       Lwt.return ()
  )
