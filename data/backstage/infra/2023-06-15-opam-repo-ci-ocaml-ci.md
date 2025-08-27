---
title: "OCaml Infrastructure: Relocation of opam.ci.ocaml.org and ocaml.ci.dev"
tags: [infrastructure]
---

The server `toxis` where [Opam-Repo-CI](https://opam.ci.ocaml.org) and [OCaml-CI](https://ocaml.ci.dev) were deployed suffered hardware difficulties yesterday, resulting in BTRFS filesystem corruption and memory issues.  These issues are tracked on [ocaml/infrastructure#51](https://github.com/ocaml/infrastructure/issues/51).  Services were restored temporarily using a spare spinning disk, but we continued to see ECC memory issues.

All services have now been redeployed on new ARM64 hardware.  We retained the databases for Prometheus, OCaml-CI and Opam-Repo-CI, but unfortunately, older job logs have been lost.

The external URLs for these services are unchanged.
