(lang dune 2.8)

(name ocamlorg)

(documentation "https://ocaml.github.io/v3.ocaml.org-server/")

(source
 (github ocaml/v3.ocaml.org-server))

(license ISC)

(authors
 "Thibaut Mattio"
 "Lucas Pluvinage"
 "Patrick Ferris"
 "Ashish Agarwal"
 "Kanishka Azimi"
 "Richard Davison"
 "Jiae Kam")

(maintainers "Thibaut Mattio" "Patrick Ferris")

(generate_opam_files true)

(using mdx 0.1)

(package
 (name ocamlorg)
 (synopsis "Server-side of the next version of the ocaml.org website")
 (description
  "ocamlorg is a Dream-based server for the next version of the ocaml.org website.\nIt serves the OCaml packages pages and their documentation by using the data available at https://docs-data.ocaml.org/ and serves the static files generated from the NextJS application at https://github.com/ocaml/v3.ocaml.org.")
 (depends
  (ocaml
   (>= 4.08.0))
  dune
  cohttp
  cohttp-lwt-unix
  bos
  crunch
  mirage-kv-mem
  (dream
   (>= 1.0.0~alpha3))
  dream-accept
  dream-encoding
  fpath
  fmt
  logs
  (omd
   (= "2.0.0~alpha2"))
  opam-format
  timedesc
  yojson
  lwt
  brr
  rpclib
  rpclib-lwt
  ppx_deriving_rpc
  (js_of_ocaml
   (>= 4.0))
  (js_of_ocaml-ppx
   (>= 4.0))
  (js_of_ocaml-compiler
   (>= 4.0))
  (js_of_ocaml-tyxml
   (>= 4.0))
  (js_of_ocaml-toplevel
   (>= 4.0))
  tailwindcss
  (alcotest :with-test)
  ; ocamlorg-data
  (mdx
   (and
    :with-test
    (>= 1.10.0)))
  ; hilite
  textmate-language
  omd
  yojson
  ; river
  (syndic
   (>= 1.5))
  (cohttp
   (>= 5.0.0))
  (cohttp-lwt
   (>= 5.0.0))
  (cohttp-lwt-unix
   (>= 5.0.0))
  ptime
  lwt
  ocamlnet
  ; src/ocamlorg_dasbhoard
  (dream
   (>= 1.0.0~alpha3))
  (hyper
   (>= 1.0.0~alpha1))
  dune-build-info
  luv
  metrics-lwt
  user-agent-parser
  digestif
  ppx_deriving_yojson
  yojson
  ; tools/ood-gen
  piaf
  ppx_deriving_yaml
  ezjsonm
  lambdasoup
  ptime
  (cmdliner
   (>= 1.1.0))
  xmlm
  uri))
