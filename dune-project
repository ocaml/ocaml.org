(lang dune 2.7)

(name ocamlorg)

(documentation "https://ocaml.github.io/v3.ocaml.org-server/")

(source
 (github ocaml/v3.ocaml.org-server))

(license ISC)

(authors "Thibaut Mattio" "Lucas Pluvinage" "Patrick Ferris")

(maintainers "Thibaut Mattio" "Lucas Pluvinage" "Patrick Ferris")

(generate_opam_files true)

(package
 (name ocamlorg)
 (synopsis "Server-side of the next version of the ocaml.org website")
 (description
  "ocamlorg is a Dream-based server for the next version of the ocaml.org website.\nIt serves the OCaml packages pages and their documentation by using the data available at https://docs-data.ocaml.org/ and serves the static files generated from the NextJS application at https://github.com/ocaml/v3.ocaml.org.")
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
  (gettext
   (>= 0.5.0))
  (gettext-camomile
   (>= 0.5.0))
  (alcotest :with-test)))
