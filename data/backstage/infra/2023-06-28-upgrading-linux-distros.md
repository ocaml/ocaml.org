---
title: "OCaml Infrastructure: Upgrading to Debian 12 for OCaml docker images"
tags: [infrastructure]
---

The OCaml infrastructure team is going to move to Debian 12 as the main distribution from Debian 11. We will continue to provide Debian 11 and 10 images while they are supported, dropping Debian 10 when it reaches end of life in 2024-06-30. In addition to these changes we are deprecating Ubuntu 18.04, Alpine 3.16/17, OL7, OpenSuse 15.2 distributions as the have reached end of life. We strongly recommend updating to a newer version if you are still using them.

Please get in touch on https://github.com/ocaml/infrastructure/issues if you have questions or requests for additional support.

## Changes

* OCaml Debian images upgraded to Debian 12 ([ocaml-dockerfile#172](https://github.com/ocurrent/ocaml-dockerfile/pull/172/files), @MisterDA)
* Deprecation of Ubuntu 18.04, Alpine 3.16 and 3.17, OracleLinux 7, OpenSUSE 15.2 images ([ocaml-dockerfile#176](https://github.com/ocurrent/ocaml-dockerfile/pull/176/files), @avsm)
* Deprecate Ubuntu 18.04, Alpine 3.16/17, OL7, OpenSuse 15.2 for OCaml-CI ([ocaml-ci#832](https://github.com/ocurrent/ocaml-ci/pull/832), @tmcgilchrist)
* Deprecate Ubuntu 18.04, Alpine 3.16/17, OL7, OpenSuse 15.2 for opam-repo-ci ([opam-repo-ci#226](https://github.com/ocurrent/opam-repo-ci/pull/226), @tmcgilchrist)
* Deprecate Ubuntu 18.04, Alpine 3.16/17, OL7, OpenSuse 15.2 for docker-base-images ([docker-base-images#237](https://github.com/ocurrent/docker-base-images/pull/237), @tmcgilchrist)
