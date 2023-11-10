---
title: Ocamlformat 0.20.0
date: "2021-12-06"
tags: [ocamlformat, platform]
changelog: |
  ### Deprecated

  - Profiles `compact` and `sparse` are now deprecated and will be removed by version 1.0 (#1803, @gpetiot)
  - Options that are not set by the preset profiles are now deprecated and will be removed by version 1.0:
    + `align-cases`, `align-constructors-decl` and `align-variants-decl` (#1793, @gpetiot)
    + `disambiguate-non-breaking-match` (#1805, @gpetiot)
    + `break-before-in` (#1888, @gpetiot)
    + `break-cases={toplevel,all}` (#1890, @gpetiot)
    + `break-collection-expressions` (#1891, @gpetiot)
    + `break-fun-decl=smart` (#1892, @gpetiot)
    + `break-fun-sig=smart` (#1893, @gpetiot)
    + `break-string-literals` (#1894, @gpetiot)
    + `break-struct` (#1895, @gpetiot)
    + `extension-indent` (#1896, @gpetiot)
    + `function-indent` (#1897, @gpetiot)
    + `function-indent-nested` (#1898, @gpetiot)
    + `if-then-else={fit-or-vertical,k-r}` (#1899, @gpetiot)
    + `indicate-multiline-delimiters=closing-on-separate-line` (#1900, @gpetiot)
    + `indent-after-in` (#1901, @gpetiot)
    + `let-binding-indent` (#1902, @gpetiot)
    + `let-binding-spacing=sparse` (#1903, @gpetiot)
    + `match-indent` (#1904, @gpetiot)
    + `match-indent-nested` (#1905, @gpetiot)
    + `module-item-spacing=preserve` (#1906, @gpetiot)
    + `nested-match` (#1907, @gpetiot)
    + `parens-tuple-patterns` (#1908, @gpetiot)
    + `sequence-style=before` (#1909, @gpetiot)
    + `stritem-extension-indent` (#1910, @gpetiot)
    + `type-decl-indent` (#1911, @gpetiot)

  ### Bug fixes

  - Fix normalization of sequences of expressions (#1731, @gpetiot)
  - Type constrained patterns are now always parenthesized, parentheses were missing in a class context (#1734, @gpetiot)
  - Support sugared form of coercions in let bindings (#1739, @gpetiot)
  - Add missing parentheses around constructor used as indexing op (#1740, @gpetiot)
  - Honour .ocamlformat-ignore on Windows (#1752, @nojb)
  - Avoid normalizing newlines inside quoted strings `{|...|}` (#1754, @nojb, @hhugo)
  - Fix quadratic behavior when certain constructs are nested. This corresponds
    to the cases where a partial layout is triggered to determine if a construct
    fits on a single line for example. (#1750, #1766, @emillon)
  - Fix non stabilizing comments after infix operators (`*`, `%`, `#`-ops) (#1776, @gpetiot)
  - Fix excessive break and wrong indentation after a short-open when `indicate-multiline-delimiters=closing-on-separate-line` (#1786, @gpetiot)
  - Add parentheses around type alias used as type constraint (#1801, @gpetiot)
  - Fix alignment of comments inside a tuple pattern and remove incorrect linebreak.
    Fix formatting of labelled arguments containing comments. (#1797, @gpetiot)
  - Emacs: only hook ocamlformat mode on tuareg/caml modes when ocamlformat is not disabled (#1814, @gpetiot)
  - Fix boxing of labelled arguments, avoid having a linebreak after a label when the argument has a comment attached (#1830, #1885, @gpetiot)
  - Add missing parentheses around application of prefix op when applied to other operands (#1825, @gpetiot)
  - Fix application of a monadic binding when 'break-infix-before-func=false' (#1849, @gpetiot)
  - Fix dropped comments attached to a sequence in a sugared extension node (#1853, @gpetiot)
  - Fix formatting of exception types, and add missing parentheses (#1873, @gpetiot)
  - Fix indentation of with-type constraints (#1883, @gpetiot)
  - Preserve sugared syntax of extension points with attributes (#1913, @gpetiot)
  - Improve comment attachment when followed but not preceded by a linebreak (#1926, @gpetiot)
  - Fix position of comments preceding Pmod_ident (#1939, @gpetiot)
  - Make the formatting of attributes and docstrings more consistent (#1929, @gpetiot)
  - Fix stabilization of comments inside attributes (#1942, @gpetiot)

  ### Changes

  - Set 'module-item-spacing=compact' in the default/conventional profile (#1848, @gpetiot)
  - Preserve bracketed lists in the Parsetree (#1694, #1876, #1914, @gpetiot)
  - Line directives now cause OCamlFormat to emit an error, they were previously silently ignored (#1845, @gpetiot)
  - Apply option 'module-item-spacing' on mutually recursive type declarations for more consistency (#1854, @gpetiot)

  ### New features

  - Handle merlin typed holes (#1698, @gpetiot)
  - Handle punned labelled arguments with type constraint in function applications.
    For example, function application of the form `foo ~(x:int)` instead of the explicit `foo ~x:(x:int)`. (ocaml#10434) (#1756, #1759, @gpetiot).
    This syntax is only produced when the output syntax is at least OCaml 4.14.
  - Allow explicit binders for type variables (ocaml#10437) (#1757, @gpetiot)
  - Add a new `ocaml-version` option to select the version of OCaml syntax of the output (#1759, @gpetiot)
  - Allow disambiguated global identifiers (like t/2) so they can be formatted by tools like OCaml-LSP (#1716, @let-def)
  - Handle let operator punning uniformly with other punning forms.
    Normalizes let operator to the punned form where possible, if output syntax version is at least OCaml 4.13.0. (#1834, #1846, @jberdine)
  - Remove unnecessary surrounding parentheses for immediate objects.
    This syntax is only produced when the output syntax is at least OCaml 4.14. (#1934, @gpetiot)
---

