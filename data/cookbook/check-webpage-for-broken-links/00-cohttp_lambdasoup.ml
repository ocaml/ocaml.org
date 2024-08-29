---
packages:
  - name: "lambdasoup"
    tested_version: "1.1.0"
    used_libraries:
      - lambdasoup
  - name: "cohttp"
    tested_version: "5.3.1"
    used_libraries:
      - cohttp
  - name: "cohttp-lwt-unix"
    tested_version: "5.3.0"
    used_libraries:
      - cohttp-lwt-unix
discussion: |
  - **Cohttp:** This is a library for HTTP clients and servers. It is used to test if a link returns a response.
  - **HTML Parsing:** This example uses the Lambda Soup library to parse the HTML string for links. 
  - **Synchronous:** This solution is synchronous.
---

open Soup
open Cohttp
open Cohttp_lwt_unix

(* `test_link` executes a GET request against the URL string `link` 
printing a message based on the response code or error message. *)
let test_link link =
  let uri = Uri.of_string link in
  try
    let resp, _body = Lwt_main.run (Client.call `GET uri) in
    let code = resp |> Response.status |> Code.code_of_status in
    if code = 200 then
      Printf.printf "Link valid: %s returned an http code %d\n" link code
    else
      Printf.printf "Link invalid: %s returned a non-200 http code %d\n" link code
  with
  | Failure msg -> Printf.printf "Link %s returned an error %s\n" link msg
  | exn -> Printf.printf "%s\n" (Printexc.to_string exn)


(* `validate_links` parses an html string for links and executes 
  the `test_link` function on each url. 
  
  Prints "No links found in document" if no links are in the document.
*)
let validate_links html_content =
  let document = parse html_content in
  let links = document $$ "a[href]" |> to_list in
  List.iter
    (fun link ->
      let href = attribute "href" link in
      match href with
      | Some url -> test_link url
      | None -> Printf.printf "No links found in document")
    links


(*
Example usage

Expected Outcome:

Link: https://ocaml.org/docs returned an http code 200
Link: https://pola.rs/ returned an http code 200
Link https://www.nonexistentwebsite.com returned an error TLS...
*)
let () =
  let html_content =
    "<!DOCTYPE html><body><main>
    <h1>My Cool Learning Links</h1>
    <section><ul>\
    <li><a href='https://ocaml.org/docs'>The Ocaml.org Learning Page</a></li>\
    <li><a href='https://pola.rs/'>Pola.rs: Modern Python Dataframes</a></li>\
    <li><a href='https://www.nonexistentwebsite.com'>It used to work.com</a></li>\
    </ul>
    </section></main></body></html>"
  in
  validate_links html_content

