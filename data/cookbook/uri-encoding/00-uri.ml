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

(* In order to compose an URI, we have a complex function whose parameters are all optional (except the `()` at the end. *)

let uri =
  Uri.make
    ~scheme:"https"
    ~userinfo:"login:password"
    ~host:"ocaml.org"
    ~port:8080
    ~path:"/cgi-bin/dummy.exe"
    ~query:["param1",["a";"b"];"param2",["déjà "]]
    ~fragment:"anchor"
    ()
let () =
  assert (Uri.to_string
           = "https://login:password@ocaml.org:8080/cgi-bin/dummy.exe?param1=a,b&param2=d%C3%A9j%C3%A0%20#anchor")

(* An other approach is to start with a known URI and change some of its components. The following functions are available: `with_scheme`, `with_userinfo`, `with_password`, `with_port`, `with_path`, `with_query`, and `with_fragment`. Except `with_path` and `with_query`, all of them take an `option` type parameter. Note, these functions have a first parameter, which is the URI to modify, and a second that contains the corresponding field's new value. *)

let uri = Uri.of_string "https://ocaml.org/"

let uri' = uri
  |> Fun.flip Uri.with_path "/cgi-bin/dummy2.exe"
  |> Fun.flip Uri.with_port (Some 8080)
  |> Fun.flip Uri.with_userinfo (Some "user:password")
  |> Fun.flip Uri.with_query ["param1", ["42"]]

(* We can also add parameters, one by one, or from a list *)

let uri'' = Uri.add_query_param uri' ("param2",["**"])
let uri''' = Uri.add_query_params uri'' ["param3",["?"];"param4",["&"]]

