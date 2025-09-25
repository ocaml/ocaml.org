---
title: Opam-publish 2.3.0
tags: [opam-publish, platform]
changelog: |
  - Add a new `--no-confirmation` argument for use in automated pipeline [#158 @AltGr - fix #132]
  - Improve the error message when a file expected to be an opam file is given as argument [#150 @kit-ty-kate - partially fix #149]
  - Adopt the OCaml Code of Conduct [#151 @rikusilvola]
  - Changes the makefile to make sure the standard "make && make install" works [#157 @kit-ty-kate]
github_release_tags:
- 2.3.0
---

We’re pleased to announce the release of `opam-publish` 2.3.0.

This release, apart from a couple of light improvements, mainly consists of the following new option:
- You can now use `opam-publish` with the `--no-confirmation` argument for use in automated pipeline. Use this option with extreme caution if you do use it.

The full changelog is available below.

Enjoy,
The opam team
