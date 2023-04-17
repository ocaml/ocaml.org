---
title: Ocamlformat 0.2
date: "2018-01-08"
tags: [ocamlformat, platform]
changelog: |
  ### Features

  - Check fatal warnings not only in inplace mode

  ### Documentation

  - Improve doc of --no-warn-error
  - Mention object language not implemented
  - Update documentation of --output

  ### Bug fixes

  - Colon instead of arrow before type for GADT constructors with no arguments (@mbouaziz)
  - Fix some dropped comments attached to idents
  - Fix missing parens around Ppat_alias under Ppat_variant
  - Fix module type constraints on functors
  - Fix broken record field punning
  - Fix broken docstring attachment with multiple docstrings
  - Fix missing parens around application operators
  - Fix missing parens around Ppat_or under Ppat_variant
  - Fix missing/excess parens around Pexp_open under Pexp_apply/Pexp_construct
  - Fix duplicated attributes on Pexp_function
  - Fix missing parens around Ptyp_package under Pstr_type
  - Add '#' to the list of infix operator prefix (@octachron)
  - Do not add space between `[` and `<` or `>` in variant types
  - Add a break hint before "constraint" in a type def (@hcarty)

  ### Formatting improvements

  - Remove unnecessary parens around Pexp_tuple under Pexp_open
  - Improve single-case matches
  - Improve constructor arguments
  - Remove unnecessary parens around match, etc. with attributes
  - Fix missing parens around constraint arg of variant type
  - Fix missing parens on left arg of infix list constructor
  - Fix missing parens around arrow type args of variant constructors
  - Fix missing parens around type of constraints on module exps

  ### Build and packaging

  - Separate Format patch into ocamlformat_support package
  - Fix test script
  - Unbreak build of ocamlformat_reason.ml (@mroch)
  - Improve opam installation (JacquesPa)
  - Install emacs support via opam package
---

