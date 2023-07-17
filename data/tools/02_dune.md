---
name: Dune
slug: dune
source: https://github.com/ocaml/dune
license: MIT
synopsis: Fast, portable, and opinionated build system
lifecycle: active
---

Dune is a build system that was designed to simplify the release of
Jane Street packages. It reads metadata from "dune" files following a
very simple s-expression syntax.

Dune is fast, has very low-overhead, and supports parallel builds on
all platforms. It has no system dependencies; all you need to build
Dune or packages using Dune is OCaml. You don't need make or bash
as long as the packages themselves don't use bash explicitly.

Dune supports multi-package development by simply dropping multiple
repositories into the same directory.

It also supports multicontext builds, such as building against
several opam roots/switches simultaneously. This helps maintaining
packages across several versions of OCaml and gives cross-compilation
for free.
