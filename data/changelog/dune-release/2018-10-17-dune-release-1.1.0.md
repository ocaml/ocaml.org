---
title: Dune-release 1.1.0
date: "2018-10-17"
tags: [dune-release, platform]
changelog: |
  - Remove the status and log commands (#95, @samoht)
  - Fix `dune-release publish doc` when using multiple packages (#96, @samoht)
  - Fix inferred package name when reading `dune-project` files (#104. @samoht)
  - Add .ps and .eps files to default files excluded from watermarking
    (backport of dbuenzli/topkg@6cf1eae)
  - Fix distribution uri when homepage is using github.io (#102, @samoht)
  - `dune-release lint` now checks that a description and a synopsis exist
    in opam2 files (#101, @samoht)
  - Add a more explicit error message if `git checkout` fails in the local
    opam-repository (#98, @samoht)
  - Do not create an extra `_html` folder when publishing docs on Linux
    (#94, @anuragsoni and @samoht)
---
