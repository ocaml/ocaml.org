---
packages:
- name: "uri"
  tested_version: "4.2.0"
  used_libraries:
  - uri
discussion: |
  - **Understanding `Uri`:** `Uri` provides useful functions for parsing and encoding URI (URL or URN). It can be handy with complex URI (parameters, special, or non-ASCII characters)
  - **Reference:** The [uri.mli file](https://github.com/mirage/ocaml-uri/blob/main/lib/uri.mli) is well commented.
---

(* In order to decompose a URI, we convert a string into an `Uri.t` and use accessor functions. *)

let uri_string =
  "https://user:password@ocaml.org/cgi-bin/dummy.exe?param1=a,b&param2=d%C3%A9j%C3%A0%20#anchor"
let uri = Uri.of_string uri_string

let () =
  assert (Uri.scheme = Some "https")
let () =
  assert (Uri.user = Some "user")
let () =
  assert (Uri.password = Some "password")
let () =
  assert (Uri.userinfo = Some "user:password")
let () =
  assert (Uri.host uri = Some "ocaml.org")
let () =
  assert (Uri.host port = None)
let () =
  assert (Uri.path uri = "/cgi-bin/dummy.exe")
let () =
  assert (Uri.path_and_query uri
          = "/cgi-bin/dummy.exe?param1=a,b&param2=d%C3%A9j%C3%A0%20")
let () =
  assert (Uri.query uri =  [("param1", ["a"; "b"]); ("param2", ["déjà "])] )
let () =
  assert (Uri.query_param uri "param1" = Some "a,b")
let () =
  assert (Uri.query_param uri "param2" = Some "déjà ")
let () =
  assert (Uri.query_param uri "param3" = None)
let () =
  assert (Uri.fragment uri = "anchor")
