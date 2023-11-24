---
title: Opam-publish 2.1.0
date: "2021-07-01"
tags: [opam-publish, platform]
changelog: |
  * Added an '--output-patch' option to allow use without a Github account
  * Use the latest opam libraries (2.1.0~rc) with better format-preserving printing
  * Avoid submission of packages without a reachable archive, except if `--force`
    was set or they are `conf` packages
---

