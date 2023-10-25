---
title: Ocamlformat 0.5
date: "2018-04-17"
tags: [ocamlformat, platform]
changelog: |
  ### Features

  - Add: support for `new%js` (#136, @hhugo)
  - Add: support for Ptyp_object (#104, @smondet)
  - Use original filename when given in error messages. (#96, @mbarbin)

  ### Bug fixes

  - Fix: allow extensions in types (#143, @hhugo)
  - Fix: parens on symbol type constructor
  - Fix: parenthesization of '!=' partial application as a prefix op (#126, @hhugo)
  - Fix: parens around Ppat_constraint under Pexp_match or Pexp_try (#124, @hhugo)
  - Fix: parenthesization of tuple args of variant type declarations (#122, @hhugo)
  - Fix: missing parens around list inside Constr pattern (#123, @hhugo)
  - Fix: incorrect breaking of long strings (#130, @hhugo)
  - Fix: missing parens inside array literal (#129, @hhugo)
  - Fix: attributes on arguments of function (#121, @hhugo)
  - Fix: floating docstrings within a type declaration group
  - Fix: missing parens in sugared Array.set
  - Fix: missing attributes on patterns
  - Fix: is_prefix_id for != (#112, @hhugo)
  - Fix: missing parens around module value types in signatures (#108, @hcarty)
  - Fix: floating docstrings within a value binding group
  - Fix: missing attributes on extension points (#102, @hcarty)
  - Fix: extensible variants with aliases (#100, @hcarty)
  - Fix: several issues with extension sequence expressions
  - Fix: generative functors
  - Fix: preserve files with an empty ast (instead of failing) (#92, @mbarbin)
  - Fix: missing extension on Pexp_sequence
  - Fix: missing docstrings and attributes on types
  - Fix: missing parens around sugared Array and String operations
  - Fix: missing parens around Pexp_newtype
  - Fix: missing parens around Ppat_constraint, Ppat_or, and Ppat_unpack
  - Fix: dropped space when string wrapped between spaces
  - Fix: repeated ppx extension on mutual/recursive let-bindings (#83, @mbarbin)
  - Fix: dropped comments on Pmty_typeof
  - Fix: missing parens around Ppat_unpack under Ppat_constraint

  ### Formatting improvements

  - Improve: two open lines following multiline definition only with --sparse (#144)
  - Improve: indent rhs of ref update (#139, @hhugo)
  - Improve: no parens around precedence 0 infix ops (refines #115) (#141, @hhugo)
  - Improve: support `(type a b c)` (#142, hhugo)
  - Improve: no parens for `{ !e with a }` (#138, @hhugo)
  - Improve: no parens for constr inside list pattern. (#140, @hhugo)
  - Improve: generative functor applications (#137, @hhugo)
  - Improve: omit parens around lists in local opens (#134, @hhugo)
  - Prepare for ocaml#1705 (#131, @hhugo)
  - Improve: comment wrapping for dangling close
  - Improve: if-then-else conditions that break
  - Improve: suppress spurious terminal line break in wrapped strings
  - Improve: parens for nested constructors in pattern (#125, @hhugo)
  - Improve: remove duplicate parens around Ptyp_package
  - Improve: indentation after comment within record type declaration
  - Improve: add discretionary parens on nested binops with different precedence
  - Improve: empty module as functor argument (#113, @hhugo)
  - Improve: indentation of multiple attributes
  - Improve: attributes on short structure items
  - Improve: attributes on type declarations
  - Improve: tuple attribute args
  - Improve: parenthesization of Ppat_or
  - Improve: determination of file kind based on provided name
  - Improve: extension on the let at toplevel: e.g. let%expect_test _ (#94, @mbarbin)
  - Improve: constraints in punned record fields (#93, @mbarbin)
  - Improve: nullary attributes
  - Improve: Ppat_tuple under Ppat_array with unnecessary but clearer parens
  - Improve: breaking of arguments following wrapped strings

  ### Build, packaging, and testing

  - Simplify using `(universe)` support in jbuilder 1.0+beta20
  - Add some regtests (#135, @hhugo)
  - Upgrade to Base v0.11.0 (#103, @jeremiedimino)
  - Add Travis CI script
  - Fix: build [make reason] (#97, @mbarbin)
  - Simplify Makefile due to jbuilder 1.0+beta18
---

