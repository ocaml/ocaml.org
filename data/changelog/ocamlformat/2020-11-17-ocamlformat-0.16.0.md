---
title: Ocamlformat 0.16.0
date: "2020-11-17"
tags: [ocamlformat, platform]
changelog: |
  ### Removed

  - Remove the 'escape-chars' option, deprecated since 0.14.0 (#1462, @gpetiot)
  - Remove the 'escape-strings' option, deprecated since 0.14.0 (#1463, @gpetiot)
  - Remove the 'doc-comments-val' option, deprecated since 0.14.2 (#1461, @gpetiot)
  - Removed options are now listed in the commandline manual (new REMOVED OPTIONS section) (#1469, @Julow)

  ### Changes

  - Set 'indicate-multiline-delimiters=no' on default profile (#1452, @gpetiot)
  - Option 'let-open' is now deprecated, concrete syntax will always be preserved starting from OCamlFormat v0.17.0, corresponding to the current 'let-open=preserve' behavior. (#1467, @gpetiot)
  - Warnings printed by ocamlformat itself now use the 4.12 style with symbolic names (#1511, #1518, @emillon)
  - Remove extension from executable name in error messages. On Windows, this means that messages now start with "ocamlformat: ..." instead of "ocamlformat.exe: ..." (#1531, @emillon)
  - Using tokens instead of string manipulation when inspecting the original source (#1526, #1533, #1541 @hhugo) (#1532, @gpetiot)

  ### Bug fixes

  - Allow a break after `if%ext` with `if-then-else=keyword-first` (#1419, #1543, @gpetiot)
  - Fix parentheses around infix applications having attributes (#1464, @gpetiot)
  - Fix parentheses around the index arg of a non-sugared index operation (#1465, @gpetiot)
  - Preserve comment position around `match` and `try` keywords (#1458, @gpetiot)
  - Add missing break in module statement (#1431, @gpetiot)
  - Indent attributes attached to included modules better (#1468, @gpetiot)
  - Clean up `ocamlformat.el` for submission to MELPA (#1476, #1495, @bcc32)
    + Added missing package metadata to `ocamlformat.el` (#1474, @bcc32)
    + Fix `ocamlformat.el` buffer replacement for MacOS Emacs (#1481, @juxd)
  - Add missing parentheses around a pattern matching that is the left-hand part of a sequence when an attribute is attached (#1483, @gpetiot)
  - Add missing parentheses around infix operator used to build a function (#1486, @gpetiot)
  - Fix comments around desugared expression (#1487, @gpetiot)
  - Fix invalid fragment delimiters of format-invalid-files recovery mode (#1485, @hhugo)
  - Fix misalignment of cases in docked `function` match (#1498, @gpetiot)
  - Preserve short-form extensions for structure item extensions (#1502, @gpetiot).
    For example `open%ext M` will not get rewritten to `[%%ext open M]`.
  - Do not change the spaces within the code spans in docstrings (#1499, @gpetiot)
  - Comments of type constrained label in record pattern have to be relocated in 4.12 (#1517, @gpetiot)
  - Preserve functor syntax for OCaml 4.12 (#1514, @gpetiot)
  - Fix inconsistencies of the closing parentheses with indicate-multiline-delimiters (#1377, #1540, @gpetiot)
  - Fix position of comments around list constructor (::) (#1524, @gpetiot)
  - Fix comments position in extensions (#1525, @gpetiot)
  - Fix formatting of field override with constraint (#1544, @gpetiot)
---

