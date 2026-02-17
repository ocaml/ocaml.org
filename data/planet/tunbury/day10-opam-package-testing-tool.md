---
title: 'Day10: opam package testing tool'
description: ocurrent/obuilder is the workhorse of OCaml CI testing, but the current
  deployment causes packages to be built repeatedly because the opam switch is assembled
  from scratch for each package, leading to common dependencies being frequently recompiled.
  day10 uses an alternative model whereby switches are assembled from their component
  packages.
url: https://www.tunbury.org/2026/02/16/day10/
date: 2026-02-16T19:30:00-00:00
preview_image: https://www.tunbury.org/images/ocaml-logo.png
authors:
- Mark Elvers
source:
ignore:
---
