---
packages:
- name: "camlnet"
  version: "4.1.9-2"
- name: "conf-gnutls"
  version: "1"
libraries:
- netclient
  nettls-gnutls
discussion: |
  - **Understanding `ocamlnet`:** The `ocamlnet` provides a rich set of networking libraries that cover many protocols. It provides some modules with a rich set of parameters. But for simple needs, the `Nethttp_client.Convenience` provides simple functions for basic interaction with the server. Note: These functions don't handle redirections.
  - **Reference:** The `Convenience` module used for simple HTTP interaction is documented on [the ocamlnet site](http://projects.camlcity.org/projects/dl/ocamlnet-4.1.9/doc/html-main/Nethttp_client.Convenience.html)
---

(* Initialise the TLS library (needed for any HTTPS site) *)

let () =
  Nettls_gnutls.init();

(* Just get the page *)

let content =
  Nethttp_client.Convenience.http_get "https://www.ocaml.org"

let () =
  print_string content
