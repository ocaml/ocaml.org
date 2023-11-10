---
title: Ocamlformat 0.15.0
date: "2020-08-06"
tags: [ocamlformat, platform]
changelog: |
  ### Changes

  - Do not break inline elements such as `{i blah}` in docstrings (#1346, @jberdine)
  - Distinguish hash-getter from hash-comparison infix operators. Operators of the form `#**#` or `#**.` where `**` can be 0 or more operator chars are considered getter operators and are not surrounded by spaces, as opposed to regular infix operators (#1376, @gpetiot)
  - Type constraint on return type of functions is now always printed before the function body (#1381, #1397, @gpetiot)

  ### Bug fixes

  - Restore previous functionality for pre-post extension points (#1342, @jberdine)
  - Fix extra break before `function` body of a `fun` (#1343, @jberdine)
  - Indent further args of anonymous functions (#1440, @gpetiot)
  - Do not clear the emacs `*compilation*` buffer on successful reformat (#1350, @jberdine)
  - Fix disabling with attributes on OCaml < 4.08 (#1322, @emillon)
  - Preserve unwrapped comments by not adding artificial breaks when `wrap-comments=false` and `ocp-indent-compat=true` are set to avoid interfering with ocp-indent indentation. (#1352, @gpetiot)
  - Break long literal strings at the margin (#1367, @gpetiot)
  - Break after a multiline argument in an argument list (#1360, @gpetiot)
  - Remove unnecessary parens around object (#1379, @gpetiot)
  - Fix placement of comments on constants (#1383, @gpetiot)
  - Do not escape arguments of some Odoc tags (#1391, 1408, @gpetiot, @Julow).
    The characters `[]{}` must not be escaped in the arguments of `@raise`, `@author`, `@version` and others.
  - Fix missing open line between multi-line let-binding with poly-typexpr (#1372, @jberdine)
  - Remove trailing space after expression when followed by an attribute and break before attributes attached to multi-line phrases (#1382, @gpetiot)
  - Do not add a space to minimal comments `(* *)`, `(** *)` and `(*$ *)` (#1407, @gpetiot)
  - Fix attributes position in labelled arguments type (#1434, @gpetiot)
  - Add missing parens around type annotation in anonymous function (#1433, @gpetiot)
  - Fix alignment of 'then' keyword in parenthesised expression (#1421, @gpetiot)

  ### New features

  - Support quoted extensions (added in ocaml 4.11) (#1405, @gpetiot)
  - Recognise eliom file extensions (#1430, @jrochel)
---

