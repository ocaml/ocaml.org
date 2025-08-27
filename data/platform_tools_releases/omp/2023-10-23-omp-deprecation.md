---
title: OMP Deprecation
tags: [omp, platform]
---

After [giving space for feedback and objections by the community](https://discuss.ocaml.org/t/rfc-deprecating-ocaml-migrate-parsetree-in-favor-of-ppxlib-also-as-a-platform-tool/13240),
we have deprecated `ocaml-migrate-parsetree` (aka OMP). It is superseded by [Ppxlib](https://github.com/ocaml-ppx/ppxlib).

There are four major differences between OMP and Ppxlib, which all go hand in hand.

The first major difference is in the library and therefore impacts how to write PPXs.
With OMP, each PPX author had to choose a parsetree version to define their PPX against.
There was no version agreement between different PPXs. With Ppxlib, each PPX author uses
the same parsetree version.

The second major difference is about compatibility with new compiler syntax. While with
OMP, each PPX was on its own parsetree version, Ppxlib keeps them all on the version of
the latest stably released compiler. That makes using any PPX compatible with using the
latest compiler syntax features!

The third major difference is in the philosophy of PPXs. With OMP, all PPX transformations
were global transformations, i.e., transformations of the whole parsetree. Ppxlib has
introduced the concept of "context-free" transformations, i.e., transformations that transform
only one parsetree node. By restricting their scope of action, context-free PPXs are a lot
more predictable and less dangerous! Also, Ppxlib merges all context-free PPXs into one
parsetree pass, defining clear semantics of PPX composition.

The fourth major difference is in the driver, i.e., the binary that drives the application
of all used PPXs in a project. The Ppxlib driver is significantly more performant than the
OMP driver used to be. That's partly because it does a lot fewer parsetree migrations and
partly thanks to merging all context-free PPXs into one parsetree pass.

As a consequence of the deprecation, OMP will be incompatible with any new compiler version.
The first incompatible compiler version is OCaml 5.1.

Thanks a lot to everyone involved in OCaml's transition from OMP to Ppxlib, for example
by porting their PPX!
