---
title: Opam-publish 2.0.3
date: "2021-01-13"
tags: [opam-publish, platform]
changelog: |
  * Drop Github token generation feature, no longer supported by Github API.
  * Use newer `github` library, avoiding warning with deprecated authentication method
  * Allow publication of packages without URL (for conf packages)
  * Added flag `--no-browser` to disable browser popup
  * Fix detection of package names when specifying opam file names on the command-line
---

