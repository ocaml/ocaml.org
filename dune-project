(lang dune 2.7)

(name ocamlorg)

(documentation "https://tmattio.github.io/ocamlorg/")

(source
 (github tmattio/ocamlorg))

(license MIT)

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
  dream-livereload
  odoc
  opam-format
  logs
  cohttp-lwt-unix
  git-unix
  reason
  tyxml-jsx
  omd
  ; Vendored graphql-ppx
  reason
  yojson
  (ppxlib
   (>= 0.21.0))
  (alcotest :with-test)))
