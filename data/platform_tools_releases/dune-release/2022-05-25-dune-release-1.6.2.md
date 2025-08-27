---
title: Dune-release 1.6.2
tags: [dune-release, platform]
changelog: |
  ### Fixed

  - Fix project name detection from `dune-project`. The parser could get confused
    when opam file generation is used. Now it only considers the first `(name X)`
    in the file. (#445, #446, @emillon)
github_release_tags: [1.6.2]
---

