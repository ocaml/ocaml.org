---
title: Dune-release 0.1.0
date: "2018-04-14"
tags: [dune-release, platform]
changelog: |
---

Initial release.

Import some code from [topkg](http://erratique.ch/software/topkg).

- Use of `Astring`, `Logs`, `Fpath` and`Bos` instead of custom
  re-implementations;
- Remove the IPC layer which is used between `topkg` and `topkg-care`;
- Bundle everything as a single binary;
- Assume that the package is built using [dune](https://github.com/ocaml/dune);
- Do not read/need a `pkg/pkg.ml` file.
