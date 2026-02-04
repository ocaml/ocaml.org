---
title: Opam-publish 2.7.1
tags:
- opam-publish
- platform
authors: []
contributors:
changelog: |
    *   Advertise the need, and check, for the `workflow` scope for github personal access tokens \[[#184](https://github.com/ocaml-opam/opam-publish/pull/184) [@kit-ty-kate](https://github.com/kit-ty-kate) - fix [#180](https://github.com/ocaml-opam/opam-publish/issues/180)\]
    *   Enforce the git remote used to push branches to users' fork to be used instead of the SSH method, for users migrating from versions of opam-publish prior to 2.7.0 \[[#179](https://github.com/ocaml-opam/opam-publish/pull/179) [@filipeom](https://github.com/filipeom) - fix [#178](https://github.com/ocaml-opam/opam-publish/issues/178)\]
    *   Avoid potential previously used tokens with the wrong permissions to be used instead of the new one \[[#179](https://github.com/ocaml-opam/opam-publish/pull/179) [@filipeom](https://github.com/filipeom) - fix [#187](https://github.com/ocaml-opam/opam-publish/issues/187)\]
    *   Add support for the opam 2.5 API \[[#181](https://github.com/ocaml-opam/opam-publish/pull/181) [#173](https://github.com/ocaml-opam/opam-publish/pull/173) [@kit-ty-kate](https://github.com/kit-ty-kate)\]
versions:
experimental: false
ignore: false
released_on_github_by: kit-ty-kate
github_release_tags:
- 2.7.1
---

We announce the release of opam-publish 2.7.1, whose full release notes can be seen [here](https://github.com/ocaml-opam/opam-publish/releases/tag/2.7.1).

## Changes in opam-publish 2.7.1

In 2.7.0, opam-publish changed the way user’s branches are pushed to their GitHub forks before opening a PR, switching from using SSH keys to using the GitHub API token that opam-publish already requires.

2.7.1 fixes a couple of bugs related to that where opam-publish stopped working if the GitHub Action workflow files of upstream opam-repository are changed, owing to the way GitHub token permissions work.
Thanks to @filipeom both for the original contribution in 2.7.0 and for subsequent work on it in 2.7.1.

Read our [blog post](https://opam.ocaml.org/blog/opam-2-5-0-rc1-publish/) for more details.

Please report any issues to the [opam-publish bug-tracker](https://github.com/ocaml/opam-publish/issues).

