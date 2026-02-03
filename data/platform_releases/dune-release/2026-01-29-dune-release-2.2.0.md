---
title: Dune-release 2.2.0
tags:
- dune-release
- platform
authors: []
contributors:
changelog: |
    ### Breaking

    *   Update to use cmdliner 2.0.0. Shortened arguments will not work anymore. ([#512](https://github.com/tarides/dune-release/pull/512), [@psafont](https://github.com/psafont))
versions:
experimental: false
ignore: false
released_on_github_by: avsm
github_release_tags:
- 2.2.0
---

We are excited to announce the release of `dune-release` `2.2.0` which brings full compatibility with `cmdliner` `2.0.0`!

Please note that this release introduces a change in user-facing behavior: following the stricter requirements of Cmdliner `2.0`, prefix-matching for command options is no longer supported. Users must now provide the full wording for all flags (for example, `--skip-tests` instead of `--skip-test`).

We recommend that all users update their automation scripts to use explicit, full-length options to ensure a smooth transition.
