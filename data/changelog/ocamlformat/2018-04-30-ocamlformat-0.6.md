---
title: Ocamlformat 0.6
date: "2018-04-30"
tags: [ocamlformat, platform]
changelog: |
  ### Features

  - Add: option to align all infix ops (#150, @hhugo)
  - Add: option to attempt to indent the same as ocp-indent (#162)
  - Add: option for no discretionary parens for tuples (#157, @hhugo)
  - Add: alternative format for if-then-else construct (#155, @hhugo)
  - Add: option to customize position of doc comments (#153, @hhugo)

  ### Bug fixes

  - Fix: dropped item attributes on module expressions
  - Fix: toplevel let%ext (#167, @hhugo)
  - Fix: parens around type alias & empty object type (#166, @hhugo)
  - Fix: missing comments for [let open] (#165, @hhugo)
  - Fix: missing comments in ppat_record (#164, @hhugo)
  - Fix: check_typ wrt constraint on module type (#163, @hhugo)
  - Fix: let binding with constraint (#160, @hhugo)
  - Fix: handle generative functor type (#152, @hhugo)

  ### Formatting improvements

  - Improve: remove redundant parens around application operators
  - Improve: parenthesize and break infix constructors the same as infix ops
  - Improve: consider prefix ops and `not` to be trivial if their arg is
  - Improve: align arrow type args and do not wrap them (#161)
  - Improve: formatting for multiple attributes (#154, @hhugo)
  - Improve: keep the original string escaping (#159, @hhugo)
  - Improve: discretionary parens in patterns (#151, @hhugo)
  - Improve: breaking of infix op arguments
  - Improve: consider some extensions to be "simple"
  - Improve: punning (#158, @hhugo)
  - Improve: force break of let module/open/exception/pats (#149, @hhugo)

  ### Build, packaging, and testing

  - Add support for bisect (#169, @hhugo)
  - Exclude failing tests from `make -C test`
---

