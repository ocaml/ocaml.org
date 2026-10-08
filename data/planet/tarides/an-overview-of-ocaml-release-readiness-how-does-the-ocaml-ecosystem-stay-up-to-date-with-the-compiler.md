---
title: 'An Overview of OCaml Release Readiness: How Does the OCaml Ecosystem Stay
  Up-to-Date with the Compiler?'
description: "What is the OCaml ecosystem doing to make upgrading to the latest version
  of the language seamless? When the OCaml compiler receives a new update, it has
  the potential to have wide-ranging effects to the ecosystem of tools that surround
  it. In the past, users have hesitated to move forward with the latest release due
  to proper tooling support lagging behind. To improve the user experience and make
  transitions smoother, OCaml developers and maintainers agreed to work together to
  ensure that the core tools were always ready near release time.\nThis effort is
  referred to as \u2018OCaml Release Readiness\u2019. It is a complex task spread
  across many actors in the ecosystem and supervised by Florian Angeletti (Inria)
  and Kate Deplaix (OCSF).\nIn this post, we will give you a behind-the-scenes look
  at the work that goes into getting the OCaml ecosystem \u2018release ready\u2019.\nWhat
  are the \u2018Core Tools\u2019?\nThere is no definitive rule for which tools are
  part of the release readiness effort, but, as a general guideline, it includes the
  kind of tools that provide key support in projects. If an update is incompatible
  with a core tool, it will be too disruptive for the user to migrate to the latest
  compiler version.\nLet\u2019s look at the tools that are currently part of the release
  readiness cycle and what the maintainers do to get them up-to-date with new releases.\nPpxlib\nPpxlib
  is a library for building pre-processors in OCaml. Pre-processors are called at
  compile time and alter the program before compilation. They can perform a whole
  host of helpful functions, such as including a file, generating boilerplate, or
  extending the language. More or less half of the OCaml ecosystem depends (transitively)
  on Ppxlib.\nInternally, ppxlib has a copy of every abstract syntax tree (AST) of
  every supported compiler. Currently, that is every compiler version from 4.08 to
  5.5. This is necessary because ppxlib has to migrate the ASTs of every user to a
  common AST (5.2 at the time of writing) to perform the pre-processing, and then
  migrate back to the AST of the user for the rest of the compilation process.\nFor
  each new OCaml release, a new AST corresponding to the latest version is added to
  the migration chain, and transformations are written to and from that AST. If this
  AST includes new syntactic features or new representations of existing features,
  then the complexity of the task grows. The maintainers need to write encodings that
  preserve the new features and representations, particularly in the migrations to
  and from older ASTs.\nNew Ppxlib releases are prepared by Nathan Rebours, via the
  OCaml Software Foundation (OCSF) and OCamlPro, and by Patrick Ferris at Tarides.\nMerlin\nMerlin
  is an editor service for OCaml that supports advanced IDE features. It is an analysis
  tool that provides semantic information about OCaml code, communicated to editors
  via a protocol such as LSP.\nA cornerstone of its architecture is the ability to
  recover from parsing and typing errors, so it can keep providing useful information
  on lines below the error rather than stopping. Achieving this requires patching
  large parts of the compiler's parser and typechecker in non-trivial ways, which
  makes upgrading Merlin's vendored parser and typer to each new compiler version
  a complex, time-consuming task.\nSeveral ongoing upstreaming efforts should make
  future updates much easier, like type-recovery which is scheduled to be upstreamed
  in the 5.6 version of the compiler, and the open proposal to upstream Merlin's new
  -short-paths implementation directly into the compiler as well, removing a long-standing
  source of drift between the two.\nThe release readiness work for Merlin is undertaken
  by a team at Tarides.\nOCaml-LSP\nOCaml-LSP is the LSP frontend for Merlin. It has
  only minor dependencies on the compiler, so once Merlin's upgrade to a new OCaml
  version is done, upgrading OCaml-LSP is usually straightforward.\nThe release readiness
  work for OCaml-LSP is done at Tarides.\nDune\nDune is a composable build system
  for OCaml. Its support for both monorepos and multi-package repositories has made
  it popular among OCaml developers.\nIts main branch tracks the latest compiler versions,
  and because it sits so early in the dependency graph, failures are quick to surface.
  In practice, the problems that come up are about compiling Dune itself with a newer
  compiler and not about the projects it builds. Strictly speaking this isn't even
  required, since a Dune binary built with an older compiler can still build projects
  with a newer one. But opam constrains a switch to a single compiler version for
  all packages in it, so in practice Dune has to stay compatible with the latest compiler
  releases.\nThe release readiness work for Dune is done by a team at Tarides.\nOCamlFormat\nOCamlFormat
  parses and pretty-prints OCaml code. We need to update it every time new syntax
  is added to the language, which surprisingly happens in almost every OCaml minor
  release. OCamlFormat vendors two versions of the OCaml parser, so upgrading requires
  backporting patches with Git and resolving conflicts. We then update and test the
  printing code.\nThe first parser is used purely for verification: OCamlformat parses
  the code before and after formatting, compares the two ASTs, and refuses to format
  if they diverge.\nThe second parser is extended to keep more information about the
  concrete syntax. For example, these two snippets would have the same AST with OCaml's
  parser: [ 1; 2 ] and 1 :: 2 :: []. They are encoded differently with our extended
  parser.\nThe release readiness work for OCamlFormat is done at Tarides.\nOdoc\nOdoc
  reads compiler-produced artifacts containing the abstract syntax tree of compilation
  units in order to generate module documentation. Since the type of those ASTs evolves
  between OCaml versions, odoc defines its own internal AST to be independent of the
  compiler version. Odoc uses cppo to adapt how the compiler's AST is loaded into
  odoc's internal representation at compile time.\nWhen a new OCaml version introduces
  changes to the typedtree, odoc fails to compile until it's adapted. At minimum,
  this means updating the loading logic to handle the new types while staying compatible
  with older versions via cppo conditionals. Beyond that, odoc's internal AST may
  need to be extended to represent new features, and add the logic to support rendering
  the changes in the generated API documentation when applicable.\nThe release readiness
  work on odoc is done at Tarides.\nStay in Touch\nDid you know how much work goes
  on behind-the-scenes to keep the OCaml ecosystem\u2019s tools up-to-date with new
  compiler versions? Connect with us on Bluesky, Mastodon, Threads, and LinkedIn or
  sign up for our mailing list to stay updated on our latest projects. We look forward
  to hearing from you!"
url: https://tarides.com/blog/2026-10-07-an-overview-of-ocaml-release-readiness-how-does-the-ocaml-ecosystem-stay-up-to-date-with-the-compiler
date: 2026-10-07T00:00:00-00:00
preview_image: https://tarides.com/blog/images/release-readiness-26-1360w.webp
authors:
- Tarides
source:
ignore:
---
