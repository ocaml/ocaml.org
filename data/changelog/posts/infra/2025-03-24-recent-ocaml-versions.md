---
title: "OCaml Infrastructure: OCaml-version 4.0.0 released"
tags: [infrastructure]
---

Following a post on [discuss.ocaml.org](https://discuss.ocaml.org/t/docker-base-images-and-ocaml-ci-support-for-ocaml-4-08/16229), there has been a new release of [ocurrent/ocaml-version](https://github.com/ocurrent/ocaml-version) that moves the minimum version of OCaml, considered as _recent_, from 4.02 to 4.08.

```ocaml
let recent = [ v4_08; v4_09; v4_10; v4_11; v4_12; v4_13; v4_14; v5_0; v5_1; v5_2; v5_3 ]
```

This change has far reaching side effects as [OCaml-CI](https://github.com/ocurrent/ocaml-ci), [opam-repo-ci](https://github.com/ocurrent/opam-repo-ci), [Docker base image builder](https://github.com/ocurrent/docker-base-images) among other things, use this to determine the set of versions of OCaml to test against. As these services are updated, testing on the old releases will be removed.
