---
title: Trivial meta-programming with cinaps
description: From now and then, I found myself having to write some mechanical and
  repetitivecode. The usual solution for this is to write a code generator; for instance
  ...
url: https://blog.janestreet.com/trivial-meta-programming-with-cinaps/
date: 2017-03-20T00:00:00-00:00
preview_image: https://blog.janestreet.com/static/img/header.png
featured:
---

<p>From now and then, I found myself having to write some mechanical and repetitive
code. The usual solution for this is to write a code generator; for instance in
the form of a ppx rewriter in the case of OCaml code. This however comes with a
cost: code generators are harder to review than plain code and it is a new
syntax to learn for other developers. So when the repetitive pattern is local to
a specific library or not widely used, it is often not worth the effort.
Especially if the code in question is meant to be reviewed and maintained by
several people.</p>


