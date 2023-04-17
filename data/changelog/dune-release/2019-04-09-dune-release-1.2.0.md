---
title: Dune-release 1.2.0
date: "2019-04-09"
tags: [dune-release, platform]
changelog: |
  - Remove assert false in favor of error message. (#125, @ejgallego)
  - Embed a 'version: "$release-version"' in each opam file of the current
    directory to get reproducible releases (#128, #129, @hannesm)
  - Generate sha256 and sha512 checksums for release (#131, @hannesm)
  - Grammar fixes (#132, @anmonteiro)
  - Handle doc fields with no trailing slash (#133, @yomimono)
---
