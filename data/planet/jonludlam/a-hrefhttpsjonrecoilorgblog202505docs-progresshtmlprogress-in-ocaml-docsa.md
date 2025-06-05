---
title: Progress in OCaml docs
description:
url: https://jon.recoil.org/blog/2025/05/docs-progress.html
date: 2025-05-29T00:00:00-00:00
preview_image:
authors:
- Jon Ludlam
source:
ignore:
---

<section><h1><a href="https://jon.recoil.org/atom.xml#progress-in-ocaml-docs" class="anchor"></a>Progress in OCaml docs</h1><ul class="at-tags"><li class="published"><span class="at-tag">published</span> <p>2025-05-29</p></li></ul><p>The docs build is progress well, and we've <i>just about</i> hit 20,000 packages (20,038 to be precise). So at this point I thought it'd be useful to take a look through the various failures to see if there are any insights to be gained.</p><p>Odoc requires a built package in order to generate the docs, there are two steps that have to be done before we can begin building the docs. Step one is to figure out the exact set of packages to build - ie, doing an opam solve, and step two is to actually build the packages. These two steps are, to some extent, out of docs-ci's control, and rely on the state of opam repository. While there are efforts to keep this in as good a state as possible, it's still the case that these steps fail much more often than the actual docs build itself. Let's take a look at some of the failures we see in each of these steps.</p></section><p>Continue reading <a href="https://jon.recoil.org/blog/2025/05/docs-progress.html">here</a></p>
