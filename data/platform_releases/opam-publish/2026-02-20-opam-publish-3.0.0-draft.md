---
title: Opam-publish 3.0.0
tags:
- opam-publish
- platform
contributors:
changelog: |
  * No longer allow option names to be specified by a prefix if the prefix is unambiguous [#202 @kit-ty-kate]
  * Query upstream repo for default branch instead of defaulting to `master` [#201 @mbarbin]
  * Query fork name from GitHub to support users whose fork of opam-repository isn't named `opam-repository` [#199 @mbarbin]
  * Fix an infinit loop if the user repeatedly provided an invalid token [#186 @filipeom]
  * Remove the deprecated `--split` option [#194 @kit-ty-kate]
  * Remove the `github-unix` dependency [#196 @kit-ty-kate]
  * Upgrade to cmdliner 2.0 [#202 @kit-ty-kate]
versions:
authors: []
experimental: false
ignore: false
released_on_github_by: kit-ty-kate
github_release_tags:
- 3.0.0
---

We're happy to announce the release of opam-publish 3.0.0.

This major release contains breaking changes: the deprecated `--split` option has been removed ([#194](https://github.com/ocaml-opam/opam-publish/pull/194)), and following the upgrade to cmdliner 2.0, option names can no longer be abbreviated to an unambiguous prefix (for example, `--dry` is no longer accepted as an alias of `--dry-run`) ([#202](https://github.com/ocaml-opam/opam-publish/pull/202)). The `github-unix` dependency has also been dropped ([#196](https://github.com/ocaml-opam/opam-publish/pull/196)).

For more details, see the full changelog below.
