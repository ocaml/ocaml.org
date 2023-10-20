---
title: Opam-publish 2.0.0~beta
date: "2018-04-12"
tags: [opam-publish, platform]
changelog: |
  * Now based on opam 2 libs and intended for publications in the 2.0 format
    (inclusive opam files, etc.)
  * Bumped version number to avoid confusion with opam versions
  * Removed the two-step operation ("prepare" and "publish"). A single invocation
    does all
  * Removed looking up current opam pinnings and repositories for metadata, which
    was too complex and counter-intuitive. Now opam files are looked up only in
    the specified directories or archives
  * Multiple publications without added complexity
  * Simplified command-line: URLs, directories, opam files, package names can be
    specified directly on the command-line, and repeated for multiple
    publications
  * Allow providing the auth token directly
---

