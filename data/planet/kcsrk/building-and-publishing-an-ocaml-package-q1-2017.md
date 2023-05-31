---
title: 'Building and Publishing an OCaml Package: Q1 2017'
description:
url: https://kcsrk.info/ocaml/opam/topkg/carcass/2017/03/05/building-and-publishing-an-OCaml-package/
date: 2017-03-05T13:56:00-00:00
preview_image:
featured:
authors:
- KC Sivaramakrishnan
---

<p>One of the key indicators of maturity of a language ecosystem is the ease of
building, managing and publishing software packages in that language. OCaml
platform has made steady progress in the last few years to this end. While
<a href="https://opam.ocaml.org/">OPAM</a> simplified package (and compiler) management,
the developing and publishing packages remained a constant pain point. This
situation has remarkably improved recently with the
<a href="http://erratique.ch/software/topkg">Topkg</a> and
<a href="https://github.com/dbuenzli/carcass">Carcass</a>. This post provides a short
overview of my workflow for building and publishing an OCaml package using Topkg
and Carcass.</p>



<p>Topkg is packager for distributing OCaml software. It provides an API for
describing rules for package builds and installs. Topkg-care provides the
command line tool <code class="language-plaintext highlighter-rouge">topkg</code> with support for creating and linting the
distribution, publishing the distribution and its documentation on WWW, and
making the package available through OPAM. Carcass is a library and a command
line tool for defining and generating the directory structure for the OCaml
package. At the time of writing this post, carcass was unreleased.</p>

<h2>Workflow</h2>

<p>I recently released a package for <a href="https://github.com/kayceesrk/mergeable-vector">mergeable
vectors</a> based on operational
transformation. The following describes my workflow to build and publish the
package.</p>

<h3>Setup</h3>

<p>Install <code class="language-plaintext highlighter-rouge">topkg-care</code> and <code class="language-plaintext highlighter-rouge">carcass</code>:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>$ opam install topkg-care opam-publish
$ opam pin add -kgit carcass https://github.com/dbuenzli/carcass
</code></pre></div></div>

<h3>Develop</h3>

<ul>
  <li>Create the directory structure
    <div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>  $ carcass body topkg/pkg mergeable_vector
</code></pre></div>    </div>
  </li>
  <li>Init
    <div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>  $ cd mergeable_vector &amp;&amp; git init &amp;&amp; git add . &amp;&amp; git commit -m &quot;First commit.&quot;
  $ git remote add origin https://github.com/kayceesrk/mergeable-vector
  $ git push --set-upstream origin master
</code></pre></div>    </div>
  </li>
  <li>
    <p>Develop: The <code class="language-plaintext highlighter-rouge">mergeable_vector/src</code> directory has the source files. I use
<a href="https://github.com/kayceesrk/mergeable-vector/blob/master/Makefile">this Makefile</a>
at the root of the package.</p>
  </li>
  <li>Test the package locally with OPAM
    <div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>  $ opam pin add mergeable_vector .
</code></pre></div>    </div>
  </li>
</ul>

<h3>Publish</h3>

<ul>
  <li>Update the
<a href="https://github.com/kayceesrk/mergeable-vector/blob/master/CHANGES.md">CHANGES</a> file for the new release.</li>
  <li>Tag the release
    <div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>  $ topkg tag 0.1.0
</code></pre></div>    </div>
  </li>
  <li>Build the distribution
    <div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>  $ topkg distrib
</code></pre></div>    </div>
  </li>
  <li>Publish the distribution
    <div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>  $ topkg publish distrib
</code></pre></div>    </div>
    <p>This makes a new release on <a href="https://github.com/kayceesrk/mergeable-vector/releases">Github</a>.</p>
  </li>
  <li>Publish the doc
    <div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>  $ topkg publish doc
</code></pre></div>    </div>
    <p>This publishes the documentation on <a href="http://kayceesrk.github.io/mergeable-vector/doc/">Github</a>.</p>
  </li>
  <li>Make an OPAM package info and submit it to OPAM repository at <a href="https://opam.ocaml.org/">opam.ocaml.org</a>.
    <div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>  $ topkg opam pkg
  $ topkg opam submit
</code></pre></div>    </div>
    <p>This creates a Github <a href="https://github.com/ocaml/opam-repository/pull/8623">PR</a>
to the <a href="https://github.com/ocaml/opam-repository">opam-repository</a>. Once the
PR is merged, the package becomes available to the users.</p>
  </li>
</ul>

