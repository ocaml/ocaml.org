---
title: Dune-release 2.1.0
tags: [dune-release, platform]
changelog: |
  ## Added

  - Add `dune-release delegate-info version` to show the current version as infered
    by the tool (#495, @samoht)
  - Add `--dev-repo` to `dune-release` and `dune-release publish` to overwrite
    the `dev-repo` field specified in the opam file (#494, @samoht)

  ### Changed

  - Use the 'user' option as the fork owner, only attempt to decode the remote URL
    if the user option is not set. (#480, @Julow)

  ### Fixed

  - Make `dune-release` not fail in the presence of `~/.dune/bin/dune` (which is present
    when using dune package management)

  ### Removed

  - `dune-release` no longer publishes docs to github pages. Instead, we rely on
    the docs published under `ocaml.org/packages` (#499 #500, @v-gb @samoht)

github_release_tags: [2.1.0]
---

Dune-release 2.1.0 has been released!

With this update,
* A new command`dune-release delegate-info version` has been added, which
  shows the current version of the package, as inferred by `dune-release`.
* The `dev-repo` field in the `.opam` file can now be overridden using the `--dev-repo`
  flag on the commands `dune-release` and `dune-release publish`.
* A bug related to decoding GitHub URLs has been fixed (FIXME:explain context and what's working now that wasn't before)
* `dune-release` no longer publishes docs to github pages. This choice has been made
  because, as a consequence of publishing to `opam-repository`, the package
  documentation is built and served by `ocaml.org/packages`.
* `dune-release` now works with the experimental package management
  feature from Dune Developer Preview.
