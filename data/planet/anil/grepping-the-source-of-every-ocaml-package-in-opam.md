---
title: Grepping the source of every OCaml package in OPAM
description: Run grep on every OCaml package in OPAM using a simple script.
url: https://anil.recoil.org/notes/grepping-every-known-ocaml-package-source
date: 2013-04-08T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
---

<p>A regular question that comes up from OCaml developers is how to use
<a href="http://opam.ocaml.org">OPAM</a> as a hypothesis testing tool against the
known corpus of OCaml source code. In other words: can we quickly and
simply run <code>grep</code> over every source archive in OPAM? So that’s the topic
of today’s 5 minute blog post:</p>
<pre><code class="language-bash">git clone git://github.com/ocaml/opam-repository
cd opam-repository
opam-admin make
cd archives
for i in *.tar.gz; \
  do tar -zxOf $i | grep caml_stat_alloc_string; \
done
</code></pre>
<p>In this particular example we’re looking for instances of
<code>caml_stat_alloc_string</code>, so just replace that with the regular
expression of your choice. The <code>opam-admin</code> tool repacks upstream
archives into a straightforward tarball, so you don’t need to worry
about all the different <a href="http://opam.ocaml.org/doc/Packaging.html#h1-CreatingOPAMpackages%23Notes">archival
formats</a>
that OPAM supports (such as git or Darcs). It just adds an <code>archive</code>
directory to a normal
<a href="https://github.com/ocaml/opam-repository">opam-repository</a> checkout, so
you can reuse an existing checkout if you have one already.</p>
<pre><code class="language-bash">$ cd opam-repository/archives
$ du -h
669M    .
$ ls | wc -l
2092
</code></pre>

