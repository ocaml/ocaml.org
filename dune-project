(lang dune 2.7)

(name ocamlorg)

(documentation "https://tmattio.github.io/ocamlorg/")

(source
 (github tmattio/ocamlorg))

(license ISC)

(authors "Thibaut Mattio")

(maintainers "Thibaut Mattio")

(generate_opam_files true)

(using mdx 0.1)

(package
 (name ocamlorg)
 (synopsis "OCaml.org website")
 (description "OCaml.org website")
 (depends
  (ocaml
   (>= 4.08.0))
  dune
  crunch
  dream
  dream-cli
  dream-livereload
  fpath
  fmt
  opam-format
  logs
  omd
  bos
  yojson
  (alcotest :with-test)))

(package
 (name ood)
 (synopsis "OCaml.Org Data")
 (description
  "The ood library defines types for the different data types we store in this repository. It aims to be as platform agnostic as possible, that means just types no dependencies that could prevent someone from using the library.")
 (depends
  (mdx
   (and
    (>= 1.10.0)
    :with-test))))

(package
 (name ood-gen)
 (synopsis "CLI to generate ood content")
 (description "CLI to generate ood content")
 (depends
  (ocaml
   (>= 4.08.0))
  yaml
  ptime
  fmt
  piaf
  lambdasoup
  crunch
  ppx_deriving_yaml
  ; Required by ocamlrss
  xmlm
  uri))
