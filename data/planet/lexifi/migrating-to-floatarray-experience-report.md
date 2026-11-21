---
title: 'Migrating to floatarray: experience report'
description: This post is about our use of OCaml inside LexiFi and how we managed
  a large refactoring of our codebase that we enterprised in order to take advantage
  of a new feature of OCaml.
url: https://www.lexifi.com/blog/ocaml/floatarray-migration/
date: 2021-03-30T00:00:00-00:00
preview_image:
authors:
- LexiFi
source:
ignore:
keywords:
- array
- flat
- float
- floatarray
- gadt
- lexifi
- migration
- pass
- rewriting
- tool
---

<p>This post is about our use of OCaml inside LexiFi and how we managed a large
refactoring of our codebase that we enterprised in order to take advantage of a
new feature of OCaml.</p>
<p>Namely, in OCaml 4.08 a specific type <code>floatarray</code> for arrays of floating-point
numbers was introduced which has a number of advantages relative to the usual
type <code>float array</code> (see below for some details or <a href="https://www.lexifi.com/blog/ocaml/about-unboxed-float-arrays/">this blog
post</a> to learn more about the
motivation for this change).</p>
