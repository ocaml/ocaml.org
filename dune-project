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
  (mdx
   (and
    (>= 1.10.0)
    :with-test))))

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
  (yaml (>= 3.0))
  (omd
   (>= 2.0.0~alpha2))
  (ood
   (= :version))
  (alcotest :with-test)
  (odoc :with-doc)))

(package
 (name ood-gen)
 (synopsis "CLI to work with ood content")
 (description "CLI to generate, parse and compile ood content to OCaml")
 (depends
  (ocaml
   (>= 4.08.0))
  (yaml (>= 3.0))
  ppx_deriving_yaml
  ezjsonm
  ptime
  fmt
  fpath
  piaf
  lambdasoup
  cmdliner
  crunch
  ppx_deriving_yaml
  (omd
   (>= 2.0.0~alpha2))
  ; Required by ocamlrss
  xmlm
  uri))
