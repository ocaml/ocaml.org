---
title: Dune-release 1.5.2
date: "2021-11-05"
tags: [dune-release, platform]
changelog: |
  ### Fixed

  - Fixed the release asset URL for projects with multiple opam packages. Before,
    the packages would attempt to infer their URL and fail in rare cases where
    the project uses `v` as prefix for tags but the project version omits it. Now
    they share the same URL. (#402, #404, @Leonidas-from-XIV)
---
