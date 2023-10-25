---
title: Ocamlformat 0.13.0
date: "2020-01-30"
tags: [ocamlformat, platform]
changelog: |
  ### New features

  - Add an option `--margin-check` to emit a warning if the formatted output exceeds the margin (#1110, @gpetiot)
  - Preserve comment indentation when `wrap-comments` is unset (#1138, #1159, @Julow)
  - Improve error messages (#1147, @Julow)
  - Display standard output in the emacs plugin even when ocamlformat does not fail (#1189, @gpetiot)

  ### Removed

  - Remove `ocamlformat_reason` (#254, #1185, @emillon).
    This tool has never been released to opam, has no known users, and overlaps
    with what `refmt` can do.
  - Remove `ocamlformat-diff` (#1205, @gpetiot).
    This tool has never been released to opam, has no known users, and overlaps
    with what `merge-fmt` can do.

  ### Packaging

  - Work with base v0.13.0 (#1163, @Julow)

  ### Bug fixes

  - Fix placement of comments just before a '|' (#1203, @Julow)
  - Fix build version detection when building in the absence of a git root (#1198, @avsm)
  - Fix wrapping of or-patterns in presence of comments with `break-cases=fit` (#1167, @Julow).
    This also fixes an unstable comment bug in or-patterns
  - Fix an unstable comment bug in variant declarations (#1108, @Julow)
  - Fix: break multiline comments (#1122, @gpetiot)
  - Fix: types on named arguments were wrapped incorrectly when preceding comments (#1124, @gpetiot)
  - Fix the indentation produced by max-indent (#1118, @gpetiot)
  - Fix break after Psig_include depending on presence of docstring (#1125, @gpetiot)
  - Remove some calls to if_newline and break_unless_newline and fix break before closing brackets (#1168, @gpetiot)
  - Fix unstable cmt in or-pattern (#1173, @gpetiot)
  - Fix location of comment attached to the underscore of an open record (#1208, @gpetiot)
  - Fix parentheses around optional module parameter (#1212, @cbarcenas)
  - Fix grouping of horizontally aligned comments (#1209, @gpetiot)
  - Fix dropped comments around module pack expressions (#1214, @Julow)
  - Fix regression of comment position in list patterns (#1141, @jberdine)
  - Fix: adjust definition of Location.is_single_line to reflect margin (#1102, @jberdine)

  ### Documentation

  - Fix documentation of option `version-check` (#1135, @Wilfred)
  - Fix hint when using `break-separators=after-and-docked` (#1130, @gretay-js)
---

