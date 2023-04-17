---
title: Ocamlformat 0.4
date: "2018-02-24"
tags: [ocamlformat, platform]
changelog: |
  ### Features

  - Wrap lines in string literals, comments and docstrings
  - Improve char escaping to ascii / uniform hexa / utf8 (#73)
  - Add support for `Pexp_new` expressions (#76, @smondet)
  - Add support for `Pexp_send _` expressions (#72, @smondet)
  - Add options to format chars and break strings (#70, @smondet)
  - Formatting of %ext on if/while/for/match/try/; (#63, @hcarty)
  - Disable formatting with [@@@ocamlformat.disable] (#66, @hcarty)

  ### Formatting improvements

  - Improve sequences under if-then-else with unnecessary but safer parens
  - Improve optional arguments with type constraints
  - Improve let-bound functions with type constraints
  - Improve newtype constraints in let-bindings
  - Improve placement of exception docstrings

  ### Bug fixes

  - Fix missing break hint before comment on sugared `[]`
  - Fix formatting of [%ext e1]; e2 (#75, @hcarty)
  - Fix missing parens around let exception, let module, for, while under apply
  - Fix missing parens under alias patterns
  - Fix placement of attributes on extension constructors
  - Fix missing parens around unpack patterns
  - Fix let-bindings with pattern constraints
  - Fix mutually recursive signatures
---

