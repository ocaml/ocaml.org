---
title: opam-repository for OxCaml
description: "This morning, Anil proposed that having an opam-repository that didn\u2019t
  have old versions of the packages that require patches to work with OxCaml would
  be good."
url: https://www.tunbury.org/2025/06/12/oxcaml-repository/
date: 2025-06-12T00:00:00-00:00
preview_image: https://www.tunbury.org/images/ocaml-logo.png
authors:
- Mark Elvers
source:
ignore:
---

<p>This morning, Anil proposed that having an opam-repository that didn’t have old versions of the packages that require patches to work with OxCaml would be good.</p>

<p>This is a fast-moving area, so this post is likely to be outdated very quickly, but at the time of writing, the development repository is <a href="https://github.com/janestreet/opam-repository/tree/with-extensions">https://github.com/janestreet/opam-repository#with-extensions</a>. This is a fork of <a href="https://github.com/ocaml/opam-repository">opam-repository</a> but with some patched packages designated with <code class="language-plaintext highlighter-rouge">+ox</code>.</p>

<p>I have a short shell script which clones both <a href="https://github.com/ocaml/opam-repository">opam-repository</a> and <a href="https://github.com/janestreet/opam-repository/tree/with-extensions">https://github.com/janestreet/opam-repository#with-extensions</a> and searches for all packages with <code class="language-plaintext highlighter-rouge">+ox</code>. All versions of these packages are removed from opam-repository and replaced with the single <code class="language-plaintext highlighter-rouge">+ox</code> version. The resulting repository is pushed to <a href="https://github.com/mtelvers/opam-repository-ox">https://github.com/mtelvers/opam-repository-ox</a>.</p>

<p>To test the repository (and show that <code class="language-plaintext highlighter-rouge">eio</code> doesn’t build), I have created a <code class="language-plaintext highlighter-rouge">Dockerfile</code> based largely on the base-image-builder format. This <code class="language-plaintext highlighter-rouge">Dockerfile</code> uses this modified opam-repository to build an OxCaml switch.</p>

<p>My build script and test Dockerfile are in [https://github.com/mtelvers/opam-repo-merge] (https://github.com/mtelvers/opam-repo-merge). Thanks to David for being the sounding board during the day!</p>
