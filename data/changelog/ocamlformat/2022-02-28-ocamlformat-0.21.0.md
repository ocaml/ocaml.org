---
title: Ocamlformat 0.21.0
date: "2022-02-28"
tags: [ocamlformat, platform]
changelog: |
  ### Bug fixes

  - Add missing parentheses around variant class arguments (#1967, @gpetiot)
  - Fix indentation of module binding RHS (#1969, @gpetiot)
  - Fix position of `:=` when `assignment-operator=end-line` (#1985, @gpetiot)
  - Fix position of comments attached to constructor decl (#1986, @gpetiot)
  - Do not wrap docstrings, `wrap-comments` should only impact non-documentation comments, wrapping invalid docstrings would cause the whole file to not be formatted (#1988, @gpetiot)
  - Do not break between 2 module items when the first one has a comment attached on the same line. Only a comment on the next line should induce a break to make it clear to which element it is attached to (#1989, @gpetiot)
  - Preserve position of comments attached to the last node of a subtree (#1667, @gpetiot)
  - Do not override the values of the following non-formatting options when a profile is set: `comment-check`, `disable`, `max-iters`, `ocaml-version`, and `quiet` (#1995, @gpetiot).
  - Remove incorrect parentheses around polymorphic type constraint (#2002, @gpetiot)
  - Handle cases where an attribute is added to a bind expression, e.g. `(x >>= (fun () -> ())) [@a]` (#2013, @emillon)
  - Fix indentation of constraints of a package type pattern (#2025, @gpetiot)

  ### Changes

  - More expressions are considered "simple" (not inducing a break e.g. as an argument of an application):
    + Variants with no argument (#1968, @gpetiot)
    + Empty or singleton arrays/lists (#1943, @gpetiot)
  - Print odoc code block delimiters on their own line (#1980, @gpetiot)
  - Make formatting of cons-list patterns consistent with cons-list expressions, (::) operators are aligned when possible, comments position also improved (#1983, @gpetiot)
  - Apply 'sequence-style' to add a space before ';;' between toplevel items, consistently with the formatting of ';' in sequences (#2004, @gpetiot)

  ### New features

  - Format toplevel phrases and their output (#1941, @Julow, @gpetiot).
    This feature is enabled with the flag `--parse-toplevel-phrases`.
    Toplevel phrases are supported when they are located in doc-comments blocks and cinaps comments.
    Whole input files can also be formatted as toplevel phrases with the flag `--repl-file`.

  ### RPC

  - ocamlformat-rpc-lib is now functorized over the IO (#1975, @gpetiot).
    Now handles `Csexp.t` types instead of `Sexplib0.Sexp.t`.
  - RPC v2 (#1935, @panglesd):
    Define a 'Format' command parameterized with optionnal arguments to set or override the config and path, to format in the style of a file.
  - Prevent RPC to crash on version mismatch with `.ocamlformat` (#2011, @panglesd, @Julow)
---

