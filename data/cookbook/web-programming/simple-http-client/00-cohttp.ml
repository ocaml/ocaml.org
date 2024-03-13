---
packages:
- name: "lwt"
  version: "5.7.0"
- name: "lwt_ppx"
  version: "2.1.0"
- name: "cohttp"
  version: "5.3.1"
- name: "cohttp-lwt-unix"
  version: "5.3.0"
libraries:
- lwt
  lwt.unix
  cohttp
  cohttp-lwt-unix
ppxes:
- lwt_ppx
discussion: |
  - **About `cohttp`:** The `cohttp` provides a client and a server implementation of HTTP(S)
  - **Reference:** The `cohttp` package is documented on the [ocaml-cohttp page](https://github.com/mirage/ocaml-cohttp).
---

let url = "https://www.ocaml.org"

(* The `get` function fetch the ressource. The status code is analysed, and if all is ok, return the body of the answer. If not, the reason of the failure *)

let http_get url =
  let%lwt (resp,body) = Cohttp_lwt_unix.Client.get
                          (Uri.of_string url) in
  let code = resp
             |> Cohttp.Response.status
             |> Cohttp.Code.code_of_status in
  if Cohttp.Code.is_success code
  then
    let%lwt b = Cohttp_lwt.Body.to_string body in
    Lwt.return (Ok b)
  else
    Lwt.return (Error (Cohttp.Code.reason_phrase_of_code code))

(* Let's call the `http_get` function. *)
let () =
  Lwt_main.run @@
    match%lwt http_get url with
    | Error str ->
       Printf.printf "%s:fail\n" url;
       Printf.printf "Error: %s\n" str;
       Lwt.return ()
    | Ok result ->
       Printf.printf "%s:succed\n" url;
       print_string result;
       Lwt.return ()
