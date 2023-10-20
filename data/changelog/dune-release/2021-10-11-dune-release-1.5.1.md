---
title: Dune-release 1.5.1
date: "2021-10-11"
tags: [dune-release, platform]
changelog: |
  ### Added

  - Added support for creating releases from unannotated Git tags. `dune-release`
    supported unannotated tags in a few places already, now it supports using
    them for creating a release. (#383, @Leonidas-from-XIV)

  ### Fixed

  - Change the `---V` command option to be `-V` (#388, @Leonidas-from-XIV)
  - Infer release versions are inferred from VCS tags. This change allows using
    `dune-release` on projects that do not use the changelog or have it in a
    different format.  (#381, #383 @Leonidas-from-XIV)
  - Fix a bug where `dune-release` couldn't retrieve a release on GitHub if the
    tag and project version don't match (e.g. `v1.0` vs `1.0`). `dune-release`
    would in such case believe the release doesn't exist, attempt to create it
    and subsequently fail. (#387, #395, @Leonidas-from-XIV)
---

