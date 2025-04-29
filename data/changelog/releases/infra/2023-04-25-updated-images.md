---
title: "OCaml Infrastructure: Updated Linux Distros and OCaml versions"
tags: [infrastructure]
---

New Ubuntu 23.04 and Fedora 38 distributions have been added to docker base image builder. Following their respective releases:
 * Ubuntu 23.04 was released 20 April 2023
 * Fedora 38 was released 18 April 2023
These images started building from Apr 25th 2023 and have been pushed to https://hub.docker.com/r/ocaml/opam with a full range of OCaml versions and variants. As always the status of the images can be viewed on [images.ci.ocaml.org](https://images.ci.ocaml.org).

Alongside the Linux updates base images containing OCaml 5.1 have also been [published](https://hub.docker.com/r/ocaml/opam/tags?page=1&name=5.1) for supported Linux platforms. Following the OCaml 5.1 Alpha release announcement on [discuss.ocaml.org](https://discuss.ocaml.org/t/first-alpha-release-of-ocaml-5-1-0/11949). Enjoy and please report any issues on [ocurrent/docker-base-images/issues](https://github.com/ocurrent/docker-base-images/issues).
