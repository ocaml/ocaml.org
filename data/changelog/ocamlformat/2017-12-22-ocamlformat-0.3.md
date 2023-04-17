---
title: Ocamlformat 0.3
date: "2017-12-22"
tags: [ocamlformat, platform]
changelog: |
  ### Features

  - Output to stdout if output file omitted

  ### Bug fixes

  - Fix Ppat_any value bindings
  - Fix missing parens around variant patterns in fun arg
  - Fix position of comments attached to end of sugared lists
  - Fix missing comments on module names
  - Fix package type constraints
  - Fix first-class module alias patterns
  - Fix first-class module patterns in let bindings
  - Fix missing parens around Ptyp_package under Psig_type
  - Fix missing "as" in Ptyp_alias formatting (@hcarty)
  - Fix let bindings with constraints under 4.06

  ### Formatting improvements

  - Improve line breaking of or-patterns
  - Improve placement of comments within pattern matches
  - Improve clarity of aliased or-patterns with parens
  - Improve matches on aliased or-patterns
  - Improve infix applications in limbs of if-then-else
  - Improve final function arguments following other complex arguments
  - Improve consistency of paren spacing after Pexp_fun
  - Improve sugar for Pexp_let under Pexp_extension
  - Improve sugar for newtype
  - Improve first-class module expressions
  - Improve indentation when comments are sprinkled through types
  - Do not add open line after last binding in a structure

  ### Build and packaging

  - Simplify build and packaging, and adopt some common practices
  - Add Warnings.Errors argument for < 4.06 compatibility (@hcarty)
  - Update base to v0.10.0 (@hcarty)
---

