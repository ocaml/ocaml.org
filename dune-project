(lang dune 2.7)

(name ocamlorg)

(documentation "https://tmattio.github.io/ocamlorg/")

(source
 (github tmattio/ocamlorg))

(license ISC)

(authors "Thibaut Mattio")

(maintainers "Thibaut Mattio")

(generate_opam_files true)

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
  fpath
  fmt
  opam-format
  logs
  omd
  bos
  yojson
  cohttp
  cohttp-lwt-unix
  ood
  lwt
  js_of_ocaml
  js_of_ocaml-ppx
  js_of_ocaml-compiler
  js_of_ocaml-tyxml
  js_of_ocaml-toplevel
  js_of_ocaml-lwt
  (alcotest :with-test)))
