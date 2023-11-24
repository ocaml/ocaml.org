---
title: Ocamlformat 0.12
date: "2019-11-04"
tags: [ocamlformat, platform]
changelog: |
  ### Changes

  - Set "conventional" as the default profile (#1060, @gpetiot).
    This new profile is made to better match the most used style and is encouraged.
    To continue using the previous default, use `profile = ocamlformat` in your `.ocamlformat`.
  - CLI: Allow both values of boolean options (#1062, @Julow).
    Now, both `--opt` and --no-opt` are available on the CLI for any boolean option "opt".
    Previously, only one of them were available depending on the default value.
  - Auto mode for `break-string-literals` (#1057, @gpetiot).
    `wrap`, `newlines` and `newlines-and-wrap` values of `break-string-literals` are removed.
    `auto` replaces them, it is equivalent to `newlines-and-wrap`.
  - Dock collection brackets (#1014, @gpetiot).
    `after-and-docked` value of `break-separators` is removed and is replaced by a new `dock-collection-brackets` option.
  - Preserve `begin` and `end` keywords in if-then-else (#978, @Julow).
    Previously, `begin`/`end` keywords around if-then-else branches were turned into parentheses.

  #### New features

  - Give a hint when warning 50 is raised (#1111, @gpetiot)
  - Add a message when a config value is removed (#1089, @emillon).
    Explain what replaces removed options and avoid printing a parsing error.
  - Implement `sequence-blank-line=preserve-one` for let bindings (#1077, @Julow).
    Preserve a blank line after `let .. in` when `sequence-blank-line` set to `preserve-one`.
    Previously, only blank lines after `;` could be preserved.
  - Parse toplevel directives (#1020, @Julow).
    Allow `#directives` in `.ml` files.
    Previously, files containing a directive needed to be parsed as "use file".
    The "use file" mode is removed and `--use-file` is now the same as `--impl`.
  - Don't require `--name`, require kind, forbid `--inplace`, allow `--check`, make `--enable-outside-detected-project` implicit when reading from stdin (#1018, @gpetiot)
  - Parse code in docstrings (#941, @gpetiot).
    Format OCaml code in cinaps-style comments `(*$ code *)` and code blocks in documentation comments `(** {[ code ]} *)`.
  - Parse documentation comments with Odoc (#721, @Julow).
    Formatting of documentation comments is more robust and support newer Odoc syntaxes.
    Internally, Odoc replaces Octavius as the documentation parser.

  #### Bug fixes

  - Fix unstabilizing comments on assignments (#1093, @gpetiot)
  - Fix the default value documentation for `max-indent` (#1105, @gpetiot)
  - Fix closing parenthesis exceeding the margin in function application (#1098, @Julow)
  - Missing break before attributes of `Pmty_with` (#1103, @jberdine)
  - Fix closing quote exceeding the margin (#1096, @Julow)
  - Fix break before the closing bracket of collections (exceeding the margin) (#1073, @gpetiot)
  - Fix precedence of Dot wrt Hash (#1058, @gpetiot)
  - Fix break in variant type definition to not exceed the margin (#1064, @gpetiot)
  - Fix newlines and indentation in toplevel extension points (#1054, @gpetiot)
  - Fix placement of doc comments around extensions (#1052, @Julow)
  - Inline extensions that do not break (#1050, @gpetiot)
  - Add missing cut before attributes in type declarations (#1051, @gpetiot)
  - Fix alignment of cases (#1046, @gpetiot)
  - Fix blank line after comments at the end of lists (#1045, @gpetiot)
  - Fix indexing operators precedence (#1039, @Julow)
  - Fix dropped comment after infix op (#1030, @gpetiot)
  - No newline if the input is empty (#1031, @gpetiot)
  - Fix unstable comments around attributes (#1029, @gpetiot)
  - Fix extra blank line in sequence (#1021, @Julow)
  - Check functor arguments when computing placement of doc comments (#1013, @Julow)
  - Fix indentation of labelled args (#1006, @gpetiot)
  - Fix linebreak between or-cases with comments when `break-cases=all` (#1002, @gpetiot)
  - Fix unstable unattached doc comment in records (#998, @Julow)
  - Fix string literal changed (#995, @Julow)
  - Fix type variable (#996, @Julow)
  - Fix crash on extension sequence (#992, @gpetiot)
  - Fix position of expressions regarding of comments in infix-op expressions (#986, @gpetiot)
  - Escape special characters in external declaration (#988, @Julow)
  - Fix parens around constrained expr with attrs (#987, @gpetiot)
  - Fix the margin, and correctly breaks comments (#957, @gpetiot)
  - Fix formatting of custom indexing operators (#975, @gpetiot)
  - Fix position of comments of labelled arrow types (#976, @gpetiot)
  - No box around inline odoc styles (#971, @gpetiot)
  - Fix boxing of collection expressions/patterns (#960, @gpetiot)
  - Fix crash on record expr with pack fields (#963, @Julow)
  - Fix letop in subexpr (#956, @hhugo)

  ### Internal

  - Take file kind from --name when formatting stdin (#1119, @Julow)
  - Make Fmt.t abstract (#1109, @Julow)
  - Future-proof Fmt API in case Fmt.t goes abstract (#1106, @emillon)
  - Future-proof `Fmt` API in case `Fmt.t` goes abstract (#1106, @emillon)
  - Optional names for formatting boxes in debug output (#1083, @gpetiot)
  - Check ocamlformat error codes in the testsuite (#1084, @emillon)
  - Clean `Translation_unit` (#1078, @gpetiot)
  - Use dune file generation in test/passing/dune (#1082, @emillon)
  - CI: factorize tests and check reason build (#1079, @gpetiot)
  - Use short form for action in src/dune (#1076, @emillon)
  - Cleanup `sequence_blank_line` (#1075, @Julow)
  - CI: use a script travis-ci.sh to simplify .travis.yml (#1063, @gpetiot)
  - Remove utility functions from `Fmt_ast` (#1059, @gpetiot)
  - CI: use opam-2.0.5 in Travis (#1044, @XVilka)
  - CI: check the build with OCaml 4.07.1 and 4.08.0 (#1036, @Julow)
  - Use the same sets of options for both branches by default in `test_branch.sh` (#1033, @gpetiot)
  - Fix `test_branch.sh` and CI checking of CHANGES.md (#1032, #1034, @Julow)
  - Fix flag of git-worktree in `test_branch.sh` and `bisect.sh` (#1027, @gpetiot)
  - Remove the `bisect_ppx` dependency and clean the `Makefile` (#1005, @Julow)
  - Use a `CHANGES.md` log file again (#1023, @gpetiot)
  - Support OCaml 4.09.0 (add the odoc.1.4.2 dependency) (#1024, @gpetiot)
  - Update labels of issue templates (#1017, @gpetiot)
  - Update labels in `CONTRIBUTING.md` (#1007, @gpetiot)
  - Allow to ignore invalid options (#984, @hhugo).
    The `--ignore-invalid-option` flag is added to ignore invalid options in `.ocamlformat` files.
  - Improve the documentation of `--doc-comments` (#982, @Julow)
  - Remove symbolic links and change naming convention of tests (#980, @gpetiot)
  - Change the type of `fmt_code` (#974, @gpetiot)
  - Simplify `Makefile` (#973, @hhugo)
  - Dune should not be flagged as a build dep anymore (#954, @gpetiot)
---

