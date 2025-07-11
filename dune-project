(lang dune 3.15)

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

(using mdx 0.1)

(package
  (name tailwindcss) (allow_empty))

(package
 (name ocamlorg)
 (synopsis "Official OCaml website")
 (description
  "This repository contains the server that serves the official OCaml website at https://ocaml.org.")
 (depends
  (ocaml
   (= 5.2.0))
  ppx_deriving
  cohttp
  cohttp-lwt-unix
  bos
  crunch
  mirage-kv-mem
  dream-accept
  dream-encoding
  (graphql
   (>= 0.14.0))
  fpath
  fmt
  logs
  (cmarkit
   (>= 0.2.0))
  opam-format
  (timedesc
   (>= 2.0.0))
  yojson
  lwt
  (hilite
   (>= 0.4.0))
  river
  syndic
  ounit
  (alcotest :with-test)
  (mdx
   (and
    :with-test
    (>= 1.10.0)))
  ; tools/ood-gen
  ppx_deriving_yaml
  ppx_import
  ppx_stable
  ezjsonm
  lambdasoup
  ptime
  (cmdliner
   (>= 1.1.0))
  xmlm
  uri))

(dialect
 (name eml)
 (implementation
  (extension eml)
  (preprocess
   (run
    %{bin:dream_eml}
    %{input-file}
    --workspace %{workspace_root}
    --stdout))))
