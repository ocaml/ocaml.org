(lang dune 2.8)

(name ood)

(generate_opam_files true)

(source
 (github patricoferris/ood))

(license ISC)

(authors "Patrick Ferris")

(maintainers "pf341@patricoferris.com")

(package
 (name ood)
 (synopsis "OCaml.Org Data")
 (description
  "The ood library defines types for the different data types we store in this repository. It aims to be as platform agnostic as possible, that means just types no dependencies that could prevent someone from using the library."))

(package
 (name lib-ood)
 (synopsis "OCaml.Org Data CLI tool libraries")
 (description
  "Lib-ood is used by the ood-cli tool, but if you don't mind taking on the dependencies it may also be useful for you as it exposes the \n   same data as the base ood package but with extra utilities like yaml parsing.")
 (depends
  yaml
  ppx_import
  ppx_deriving_yaml
  netlify-cms
  fmt
  cmdliner
  bos
  alcotest))

(package
 (name ood-cli)
 (synopsis "OCaml.Org Data CLI tool")
 (description
  "The ood binary performs data linting, Netlify CMS configuration generation from types etc.")
 (depends lib-ood))

(package
 (name netlify-cms)
 (synopsis "OCaml encoding of Netlify CMS Configuration Files")
 (description
  "The netlify-cms library provides types and tools for generating Netlify CMS configurations programmatically")
 (depends
  (cohttp-lwt-unix
   (>= 4.0.0))
  (bos :with-test)
  (alcotest :with-test)
  ppx_deriving_yaml
  ppx_deriving
  fmt
  yaml))
