---
title: Ocamlformat 0.14.2
date: "2020-05-11"
tags: [ocamlformat, platform]
changelog: |
  ### Changes

  - Merge `doc-comments-val` option with `doc-comments`. The placement of documentation comments on `val` and `external` items is now controled by `doc-comments`.
    + `doc-comments=after` becomes `doc-comments=after-when-possible` to take into account the technical limitations of ocamlformat;
    + `doc-comments=before` is unchanged;
    + `doc-comments-val` is now replaced with `doc-comments`.
      To reproduce the former behaviors
      * `doc-comments=before` + `doc-comments-val=before`: now use `doc-comments=before`;
      * `doc-comments=before` + `doc-comments-val=after`: now use `doc-comments=before-except-val`;
      * `doc-comments=after` + `doc-comments-val=before`: this behavior did not make much sense and is not available anymore;
      * `doc-comments=after` + `doc-comments-val=after`: now use `doc-comments=after-when-possible`.
  (#1358, @jberdine, @Julow, @gpetiot).
  This reverts changes introduced in 0.14.1 (#1335) and 0.14.0 (#1012).
---

