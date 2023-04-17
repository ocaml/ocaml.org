---
title: Dune-release 1.4.0
date: "2020-07-14"
tags: [dune-release, platform]
changelog: |
  ### Added

  - Add a `dune-release config` subcommand to display and edit the global
    configuration (#220, @NathanReb).
  - Add command `delegate-info` to print information needed by external
    release scripts (#221, @pitag-ha)
  - Use Curly instead of Cmd to interact with github (#202, @gpetiot)
  - Add `x-commit-hash` field to the opam file when releasing (#224, @gpetiot)
  - Add support for common alternative names for the license and
    ChangeLog file (#204, @paurkedal)

  ### Changed

  - Command `tag`: improve error and log messages by comparing the provided
    commit with the commit correspondent to the provided tag (#226, @pitag-ha)
  - Error logs: when an external command fails, include its error message in
    the error message posted by `dune-release` (#231, @pitag-ha)
  - Error log formatting: avoid unnecessary line-breaks; indent only slightly
    in multi-lines (#234, @pitag-ha)
  - Linting step of `dune-release distrib` does not fail when opam's `doc` field
    is missing. Do not try to generate nor publish the documentation when opam's
    `doc` field is missing. (#235, @gpetiot)

  ### Deprecated

  - Deprecate opam 1.x (#195, @gpetiot)

  ### Fixed

  - Separate packages names by spaces in `publish` logs (#171, @hannesm)
  - Fix uncaught exceptions in distrib subcommand and replace them with proper
    error messages (#176, @gpetiot)
  - Use the 'user' field in the configuration before inferring it from repo URI
    and handles HTTPS URIs (#183, @gpetiot)
  - Ignore backup files when looking for README, CHANGES and LICENSE files
    (#194, @gpetiot)
  - Do not echo input characters when reading token (#199, @gpetiot)
  - Improve the output of VCS command errors (#193, @gpetiot)
  - Better error handling when checking opam version (#195, @gpetiot)
  - Do not write 'version' and 'name' fields in opam file (#200, @gpetiot)
  - Use Yojson to parse github json response and avoid parsing bugs.
    (#177, @gpetiot)
  - The `git` command used in `publish doc` should check `DUNE_RELEASE_GIT` (even
    if deprecated) before `PATH`. (#242, @gpetiot)
  - Adapt the docs to the removal of the `log` subcommand (#196, @gpetiot)
---
