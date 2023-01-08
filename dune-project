(lang dune 2.8)

(name ocamlorg)

(documentation "https://ocaml.github.io/ocaml.org/")

(source
 (github ocaml/ocaml.org))

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
 (synopsis "Official OCaml website")
 (description
  "This repository contains the server that serves the official OCaml website at https://ocaml.org.")
 (depends
  (ocaml
   (>= 4.14.0))
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
  (graphql
   (>= 0.14.0))
  fpath
  fmt
  logs
  (omd
   (= "2.0.0~alpha2"))
  opam-format
  (timedesc
   (>= 0.8.0))
  yojson
  lwt
  tailwindcss
  hilite
  river
  syndic
  (alcotest :with-test)
  (mdx
   (and
    :with-test
    (>= 1.10.0)))
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
  (timedesc
   (>= 0.8.0))
  ; tools/ood-gen
  ppx_deriving_yaml
  ezjsonm
  lambdasoup
  ptime
  (cmdliner
   (>= 1.1.0))
  xmlm
  uri))
