---
title: Opam-publish 2.6.0
tags:
- opam-publish
- platform
authors:
- kit-ty-kate
contributors:
changelog: |
 * Add a new --token argument (also accessible through the OPAM_PUBLISH_GH_TOKEN environment variable) which accepts GitHub tokens to simplify non-interactive usages \[[#174](https://github.com/ocaml-opam/opam-publish/pull/174) [@filipeom](https://github.com/filipeom)\]
 * Add a message after the PR is open, to notify users that they can re-run opam-publish to update the PR \[[#172](https://github.com/ocaml-opam/opam-publish/pull/172) [@punchagan](https://github.com/punchagan)\]
 * Remove the use of the deprecated github.unix in favour of github-unix (added in ocaml-github 3.1.0) \[[@kit-ty-kate](https://github.com/kit-ty-kate)\]
versions:
unstable: false
ignore: false
github_release_tags:
- 2.6.0
---

We're pleased to announce the release of `opam-publish` 2.6.0! This update brings improvements for automation and better user experience.

## What's New

**Enhanced automation support**: A new `--token` argument (also available via the `OPAM_PUBLISH_GH_TOKEN` environment variable) now accepts GitHub tokens, making it easier to use opam-publish in CI/CD pipelines and other non-interactive environments.

**Re-run to update existing PR**: After opening a pull request, opam-publish now displays a helpful message letting you know that you can re-run the command to update your existing PR. This addresses a common workflow issue where package authors would close PRs and open new ones, often unaware that opam-publish can update existing PRs.

Thanks to @filipeom and @punchagan for their contributions to this release!
