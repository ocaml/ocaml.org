---
title: Ocamlformat 0.18.0
date: "2021-04-01"
tags: [ocamlformat, platform]
changelog: |
  ### Bug fixes

  - Fix extraneous parenthesis after `let open` with `closing-on-separate-line` (#1612, @Julow)
  - Add missing break between polytype quantification and arrow-type body (#1615, @gpetiot)

  ### Changes

  - Use dune instrumentation backend for `bisect_ppx` (#1550, @tmattio)
  - Format objects and classes consistently with structure and signature items (#1569, @bikallem)

  ### New features

  - Expose a RPC interface through a new binary `ocamlformat-rpc` and a new library `ocamlformat-rpc-lib` (#1586, @gpetiot, @voodoos)
---

