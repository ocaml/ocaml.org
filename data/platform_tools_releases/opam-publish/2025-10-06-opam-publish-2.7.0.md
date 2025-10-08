---
title: Opam-publish 2.7.0
tags:
- opam-publish
- platform
authors:
- kit-ty-kate
contributors:
changelog: |
    *   Use a token to push commits instead of SSH keys \[[#175](https://github.com/ocaml-opam/opam-publish/pull/175) [@filipeom](https://github.com/filipeom)\]
    *   Switch from lwt\_ssl to tls-lwt which avoid one dependency \[[#176](https://github.com/ocaml-opam/opam-publish/pull/176) [@kit-ty-kate](https://github.com/kit-ty-kate)\]
versions:
unstable: false
ignore: false
github_release_tags:
- 2.7.0
---

We are pleased to announce the release of `opam-publish` 2.7.0!

This release builds on the automation improvements introduced in version 2.6.0, making it even easier to publish your OCaml packages automatically in CI/CD environments.

## Enhanced Token-Based Authentication

Building on the `--token` argument and `OPAM_PUBLISH_GH_TOKEN` environment variable introduced in 2.6.0, this release takes automation further with improvements by [@filipeom](https://github.com/filipeom):

- **Token-based pushing**: SSH keys are no longer required for pushing branches to your fork—the GitHub token now handles everything, eliminating the need to manage SSH credentials in CI environments. This closes two long-standing feature requests (#109 and #170) for better non-interactive and CI support.
- **Automatic git configuration**: If `user.name` and `user.email` aren't set in your git config, they'll be automatically populated with your GitHub username and a default email address as a fallback

These token-based features work alongside the traditional SSH-based authentication, so you can choose whichever method works best for your workflow. For CI/CD pipelines, the token-based approach is significantly simpler.

Check out [this example CI workflow](https://github.com/formalsec/smtml/commit/3c98cc024583e69b87c6d63a233abff149471399) and the [automated publish script](https://github.com/formalsec/smtml/blob/3c98cc024583e69b87c6d63a233abff149471399/scripts/publish.sh) to see the complete automated setup in action, including the use of `--no-confirmation` and `--no-browser` flags for fully automated publishing.

## Additional Improvements

- **Dependency improvements**: Switched from `lwt_ssl` to `tls-lwt`, moving from a C binding to libssl to a pure OCaml implementation of TLS. This reduces dependencies by eliminating the `conf-libssl` opam dependency and its associated depext, which can be problematic on some platforms.

As a reminder from 2.6.0, opam-publish also displays a helpful message after opening a pull request, letting you know you can re-run the tool to update the same PR rather than opening a new one—addressing a common workflow issue where package authors would unnecessarily close and recreate PRs.

---

Happy publishing!

The opam team 🐫