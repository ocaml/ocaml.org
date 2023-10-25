---
title: Ocamlformat 0.19.0
date: "2021-07-19"
tags: [ocamlformat, platform]
changelog: |
  ### Bug fixes

  - Fix formatting of odoc tags: the argument should be on the same line, indent description that wraps (#1634, #1635, @gpetiot)
  - Consistently format let bindings and monadic let bindings, do not drop comments before monadic bindings (#1636, @gpetiot)
  - Fix dropped comments attached to pattern constrained by polynewtype (#1645, @gpetiot)
  - Fix comment attachment on infix operators (#1643, @gpetiot)
  - Add missing spaces inside begin-end delimiting an ite branch (#1646, @gpetiot)
  - Add missing parens around function at RHS of infix op (#1642, @gpetiot)
  - Preserve begin-end keywords delimiting match cases (#1651, @gpetiot)
  - Fix alignment of closing paren on separate line for anonymous functions (#1649, @gpetiot)
  - Preserve begin-end keywords around infix operators (#1652, @gpetiot)
  - Preserve `begin%ext` syntax for infix opererator expressions (#1653, @gpetiot)
  - Consistently format comments attached to let-and bindings located at toplevel (#1663, @gpetiot)
  - Remove double parens around a functor in a module application (#1681, @gpetiot)
  - Improve breaking of comments to avoid violating the margin (#1676, @jberdine)
  - Fix parentheses around successive unary operations (#1696, @gpetiot)
  - Add missing break between pattern and attribute (#1711, @gpetiot)
  - Add missing parentheses around expression having attributes or comments inside a shorthand let-open clause (#1708, @gpetiot)
  - Do not consider leading star '*' when checking the diff of doc comments (#1712, @hhugo)
  - Fix formatting of multiline non-wrapping comments (#1723, @gpetiot)
  - Fix position of comments following a record field (#1945, @gpetiot)

  ### Changes

  - Improve the diff of unstable docstrings displayed in error messages (#1654, @gpetiot)
  - Use UTF8 length of strings, not only in wrapped comments (#1673, @jberdine)
  - Improve position of `;;` tokens (#1688, @gpetiot)
  - Depend on `odoc-parser` instead of `odoc` (#1683, #1713, @kit-ty-kate, @jonludlam, @julow).
    The parser from odoc has been split from the main odoc package and put into its own package, `odoc-parser`.
  - Revert infix-form list formatting to pre-0.17.0 (#1717, @gpetiot)

  ### New features

  - Implement OCaml 4.13 features (#1680, @gpetiot)
    + Named existentials in pattern-matching (ocaml#9584)
    + Let-punning (ocaml#10013)
    + Module type substitutions (ocaml#10133)
  - Emacs integration (disabled for ocamlformat < 0.19.0):
    + Indent a line or a region with ocamlformat when pressing <TAB>
    + Break the line and reindent the cursor when pressing <ENTER>
    (#1639, #1685, @gpetiot) (#1687, @bcc32)
  - Add 'line-endings=lf|crlf' option to specify the line endings used in the
    formatted output. (#1703, @nojb)

  ### Internal

  - A script `tools/build-mingw64.sh` is provided to build a native Windows
    binary of `ocamlformat` using `mingw64` toolchain under Cygwin.
---
