---
name: opam-publish
slug: opam-publish
source: https://github.com/ocaml-opam/opam-publish
license: LGPLv2
synopsis: A tool to ease contributions to Opam repositories
lifecycle: active
---

`opam-publish` automates publishing packages to package repositories: it checks that the
Opam file is complete using `opam lint`, verifies and adds the archive URL and its
checksum and files a GitHub pull request for merging it.
