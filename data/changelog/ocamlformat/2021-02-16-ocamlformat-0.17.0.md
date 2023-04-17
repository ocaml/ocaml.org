---
title: Ocamlformat 0.17.0
date: "2021-02-16"
tags: [ocamlformat, platform]
changelog: |
  ### Removed

  - Remove the 'let-open' option, deprecated since 0.16.0 (#1563, @gpetiot)
  - Remove support for OCaml 4.06 and 4.07, minimal version requirement bumped to OCaml 4.08 (#1549, @gpetiot)
  - Remove the 'extension-sugar' option, deprecated since 0.14.0 (#1588, @gpetiot)

  ### Bug fixes

  - Fix parsing of invalid file wrt original source handling (#1542, @hhugo)
  - Preserve the syntax of infix set/get operators (#1528, @gpetiot).
    `String.get` and similar calls used to be automatically rewritten to their corresponding infix form `.()`, that was incorrect when using the `-unsafe` compilation flag. Now the concrete syntax of these calls is preserved.
  - Add location of invalid docstring in warning messages (#1529, @gpetiot)
  - Fix comments on the same line as prev and next elements (#1556, @gpetiot)
  - Break or-patterns after comments and preserve their position at the end of line (#1555, @gpetiot)
  - Fix linebreak between signature items of the same group (#1560, @gpetiot)
  - Fix stack overflow on large string constants (#1562, @gpetiot)
  - Fix comment position around list cons operator (#1567, @gpetiot)
  - Fix the vertical alignment test to break down comment groups (#1575, @gpetiot)
  - Preserve spacing of toplevel comments (#1554, @gpetiot)
  - Support more sugared extension points (#1587, @gpetiot)

  ### Changes

  - Add buffer filename in the logs when applying ocamlformat (#1557, @dannywillems)
  - Improve comment position in pattern collection (#1576, @gpetiot)
  - Consistent positioning of lambda return type annotations when no-break-infix-before-func and pre/post extensions (#1581, @gpetiot)

  ### New features

  - Support injectivity type annotations (OCaml 4.12 feature) (#1523, @gpetiot)
---

