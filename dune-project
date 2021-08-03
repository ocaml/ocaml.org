(lang dune 2.8)

(name ood)

(generate_opam_files true)

(source
 (github patricoferris/ood))

(license ISC)

(authors "Patrick Ferris")

(maintainers "pf341@patricoferris.com")

(using mdx 0.1)

(package
 (name ood)
 (synopsis "OCaml.Org Data")
 (description
  "The ood library defines types for the different data types we store in this repository. It aims to be as platform agnostic as possible, that means just types no dependencies that could prevent someone from using the library.")
 (depends
  (mdx (and (>= 1.10.0) :with-test))))

(package
 (name ood-cli)
 (synopsis "OCaml.Org Data CLI tool")
 (description
  "The ood binary performs data linting, Netlify CMS configuration generation from types etc.")
 (depends
  (ppx_enumerate
   (>= v0.14.0))
  (jekyll-format
   (>= 0.2.0))
  yaml
  ppx_import
  ppx_deriving_yaml
  fmt
  cmdliner
  bos
  alcotest
  (netlify-cms
   (= :version))
  (ood
   (= :version))))

(package
 (name ood-preview)
 (synopsis "Preview ood content")
 (description "Preview ood content")
 (depends
  (ocaml
   (>= 4.08.0))
  dune
  crunch
  dream
  dream-cli
  dream-livereload
  yaml
  omd
  (ood
   (= :version))
  (alcotest :with-test)
  (odoc :with-doc)))

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
  ; Required by ocamlrss
  xmlm
  uri))
