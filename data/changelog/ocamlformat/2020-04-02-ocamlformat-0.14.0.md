---
title: Ocamlformat 0.14.0
date: "2020-04-02"
tags: [ocamlformat, platform]
changelog: |
  ### New features

  - Add an option `--format-invalid-files` to print unparsable parts of the input as verbatim text. This feature is still experimental. (#1026, @gpetiot)
  - Support multi-indices extended indexing operators (#1279, #1277, @Julow, @gpetiot).
    This feature has been added in OCaml 4.10.0
  - Handle OCaml 4.10.0 AST (#1276, @gpetiot)
  - Preserve functor syntax for consistency (#1312, @gpetiot).
    Previously both functor syntax: `module M = functor (K : S) -> struct end` and `module M (K : S) = struct end` would be formatted as the latter, the original syntax is now preserved.

  ### Changes

  - Add the option `doc-comments-val=before|after` (#1012, @Julow).
    This option set the placement of documentation comment on `val` and `external` only.
    It is set to `after` by default.
  - The default for `doc-comments` is changed from `after` to `before` (#1012, #1325, @Julow).
    This affects both `conventional` (default) and `ocamlformat` profiles.
  - Some options are now deprecated:
    + `doc-comments` (#1293, #1012).
      This option depends on a flawed heuristic.
      It is replaced by `doc-comments-val` for `val` and `external` declarations.
      There is no equivalent to this option in the general case.
    + `escape-chars`, `escape-strings` and `extension-sugar` (#1293).
      These options are rarely used and their default behavior is considered to be the right behavior.
  - Add space between `row_field` attributes and the label or arguments, to be
    consistent with the non-polymorphic case. (#1299, @CraigFe)

  ### Bug fixes

  - Fix missing parentheses around `let open` (#1229, @Julow).
    eg. `M.f (M.(x) [@attr])` would be formatted to `M.f M.(x) [@attr]`, which would crash OCamlformat
  - Remove unecessary parentheses with attributes in some structure items:
    + extensions and eval items (#1230, @Julow).
      eg. the expression `[%ext (() [@attr])]` or the structure item `(() [@attr]) ;;`
    + `let _ = ...`  constructs (#1244, @emillon)
  - Fix some bugs related to comments:
    + after a function on the rhs of an infix (#1231, @Julow).
      eg. the comment in `(x >>= fun y -> y (* A *))` would be dropped
    + in module unpack (#1309, @Julow).
      eg. in the module expression `module M = (val x : S (* A *))`
  - Fix formatting of empty signature payload `[%a:]` (#1236, @emillon)
  - Fix parenthesizing when accessing field of construct application (#1247, @gpetiot)
  - Fix formatting of attributes on object overrides `{< >}` (#1238, @emillon)
  - Fix attributes on coercion (#1239, @emillon)
  - Fix formatting of attributes on packed modules (#1243, @emillon)
  - Fix parens around binop operations with attributes (#1252, #1306, @gpetiot, @CraigFe)
  - Remove unecessary parentheses in the argument of indexing operators (#1280, @Julow)
  - Retain attributes on various AST nodes:
    + field set expressions, e.g. `(a.x <- b) [@a]` (#1284, @CraigFe)
    + instance variable set expressions, e.g. `(a <- b) [@a]` (#1288, @CraigFe)
    + indexing operators, e.g. `(a.(b)) [@a]` (#1300, @CraigFe)
    + sequences, e.g. `(a; b) [@a]` (#1291, @CraigFe)
  - Avoid unnecessary spacing after object types inside records and polymorphic variants, e.g. `{foo : < .. > [@a]}` and `{ foo : < .. > }` (#1296, @CraigFe)
  - Fix missing parentheses around tuples with attributes. (#1301, @CraigFe).
    Previously, `f ((0, 0) [@a])` would be formatted to `f (0, 0) [@a]`, crashing OCamlformat.
  - Avoid emitting `>]` when an object type is contained in an extension point or attribute payload (#1298, @CraigFe)
  - Fix crash on the expression `(0).*(0)` (#1304, @Julow).
    It was formatting to `0.*(0)` which parses as an other expression.
  - Preserve empty doc-comments syntax. (#1311, @gpetiot).
    Previously `(**)` would be formatted to `(***)`.
  - Do not crash when a comment contains just a newline (#1290, @emillon)
  - Handle lazy patterns as arguments to `class` (#1289, @emillon)
  - Preserve cinaps comments containing unparsable code (#1303, @Julow).
    Previously, OCamlformat would fallback to the "wrapping" logic, making the comment unreadable and crashing in some cases.
  - Fix normalization of attributes, fixing the docstrings in attributes (#1314, @gpetiot)
  - Add missing parentheses around OR-patterns with attributes (#1317, @gpetiot)
  - Fix spacing inside parens for symbols when the spacing was handled by the englobing exp (#1316, @gpetiot)
  - Fix invalid (unparsable) docstrings (#1315, @gpetiot).
    When parsing a comment raises an error in odoc, it is printed as-is.
  - Fix parenthesizing of optional arguments rebound to non-variables, e.g.
    `let f ?a:(A) = ()` rather than the unparsable `let f ?a:A = ()` (#1305, @CraigFe)
---

