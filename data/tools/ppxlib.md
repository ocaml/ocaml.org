---
name: Ppxlib
slug: ppxlib
source: https://github.com/ocaml-ppx/ppxlib
license: MIT
synopsis: Standard library for PPX rewriters
lifecycle: active
---

Ppxlib is the standard library for ppx rewriters and other programs
that manipulate the in-memory reprensation of OCaml programs, a.k.a
the "Parsetree".

It also comes bundled with two PPX rewriters that are commonly used to
write tools that manipulate and/or generate Parsetree values;
`ppxlib.metaquot` which allows to construct Parsetree values using the
OCaml syntax directly and `ppxlib.traverse` which provides various
ways of automatically traversing values of a given type, in particular
allowing to inject a complex structured value into generated code.
