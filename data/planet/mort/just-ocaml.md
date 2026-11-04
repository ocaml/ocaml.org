---
title: '`just` OCaml'
description: '...yes, I prefer `just` to `make` now'
url: https://mort.io/blog/just-ocaml/
date: 2025-02-07T00:00:00-00:00
preview_image:
authors:
- Richard Mortier
source:
ignore:
keywords:
- docdir
- dune
- dune-release
- install
- lint
- ocal
- odoc
- opam
- pwd
- uninstall
---

<p>In similar vein to a <a href="https://mort.io/blog/just-latex">recent post</a>, I have also started using
<a href="https://just.systems/" rel="external"><code>just</code></a> when I periodically need to rebuild my
<a href="https://ocaml.org/" rel="external">OCaml</a> tool<sup class="footnote-reference"><a href="https://mort.io/blog/just-ocaml/#fn-1">[1]</a></sup> <a href="https://github.com/mor1/ocal" rel="external"><code>ocal</code></a>. So
I ended up replacing the old
<a href="https://github.com/mor1/ocal/blob/6bb129627f9d1f27ab31cee810013b362ab80067/Makefile" rel="external"><code>Makefile</code></a>
with a shiny new
<a href="https://github.com/mor1/ocal/blob/8ef8631ae5bbe0315e359d725d467e7d0403fd31/Justfile" rel="external"><code>Justfile</code></a>.</p>
<p>As it also proved useful in another (more esoteric) tool I wrote <a href="https://github.com/mor1/cst-tools" rel="external">for parsing
out exam results for my students so I can paste into email
easily</a>, I thought I’d put it here for the
record. So here it is…</p>
<p>Usual preamble of course:</p>
<pre class="giallo z-code"><code data-lang="just"><span class="giallo-l"><span class="z-5">_</span><span class="z-1">default</span><span class="z-5">:</span></span>
<span class="giallo-l"><span class="z-5">    @</span><span>just --list</span></span></code></pre>
<p>Then set some common variables:</p>
<pre class="giallo z-code"><code data-lang="just"><span class="giallo-l"><span class="z-1">PWD</span><span class="z-5"> :=</span><span class="z-1"> env</span><span>(</span><span class="z-2">"PWD"</span><span>)</span></span>
<span class="giallo-l"><span class="z-1">DOCDIR</span><span class="z-5"> :=</span><span class="z-2"> "_build/default/_doc/_html"</span></span>
<span class="giallo-l"><span class="z-1">BUILDDIR</span><span class="z-5"> :=</span><span class="z-2"> "_build/install/default/bin"</span></span></code></pre>
<p>Then set the target — the tool name, in this case <code>ocal</code> (so named as this is
an OCaml re-implementation of a tool approximating the trad Unix
<a href="https://en.wikipedia.org/wiki/Cal_(command)" rel="external"><code>cal</code></a> tool):</p>
<pre class="giallo z-code"><code data-lang="just"><span class="giallo-l"><span class="z-1">TARGET</span><span class="z-5"> :=</span><span class="z-2"> "ocal"</span></span></code></pre>
<p>Now for the actually useful stuff: some targets. Mostly these just call out to
<code>dune</code> but in a way I find more intuitive.</p>
<pre class="giallo z-code"><code data-lang="just"><span class="giallo-l"><span class="z-3 z-i"># build targets</span></span>
<span class="giallo-l"><span class="z-1">build</span><span class="z-5">:</span></span>
<span class="giallo-l"><span>    dune build @all</span></span>
<span class="giallo-l"></span>
<span class="giallo-l"><span class="z-3 z-i"># cleanup</span></span>
<span class="giallo-l"><span class="z-1">clean</span><span>:</span></span>
<span class="giallo-l"><span>    dune </span><span class="z-1">clean</span></span>
<span class="giallo-l"></span>
<span class="giallo-l"><span class="z-3 z-i"># uninstall targets</span></span>
<span class="giallo-l"><span class="z-1">uninstall</span><span class="z-5">:</span></span>
<span class="giallo-l"><span>    dune uninstall</span></span>
<span class="giallo-l"></span>
<span class="giallo-l"><span class="z-3 z-i"># run any tests</span></span>
<span class="giallo-l"><span class="z-1">test</span><span class="z-5">:</span></span>
<span class="giallo-l"><span>    dune runtest</span></span>
<span class="giallo-l"></span>
<span class="giallo-l"><span class="z-3 z-i"># format sources</span></span>
<span class="giallo-l"><span class="z-1">format</span><span class="z-5">:</span></span>
<span class="giallo-l"><span>    dune fmt</span></span></code></pre>
<p>Some compound calls next.</p>
<p>First, before building we might need to install dependencies, so do so in the
time-honoured fashion:</p>
<pre class="giallo z-code"><code data-lang="just"><span class="giallo-l"><span class="z-3 z-i"># install dependencies</span></span>
<span class="giallo-l"><span class="z-1">depends</span><span class="z-5">:</span></span>
<span class="giallo-l"><span>    opam install --yes dune-release odoc</span></span>
<span class="giallo-l"><span>    opam install --yes . --deps-only</span></span></code></pre>
<p>Next, to install I first build ready to install, then symlink the resulting
binary into the right place in my home directory:</p>
<pre class="giallo z-code"><code data-lang="just"><span class="giallo-l"><span class="z-3 z-i"># install targets</span></span>
<span class="giallo-l"><span class="z-1">install</span><span class="z-5">:</span><span class="z-1"> build</span></span>
<span class="giallo-l"><span>    dune build @install</span></span>
<span class="giallo-l"><span>    ln -sf </span><span class="z-2">{{PWD}}</span><span class="z-5">/</span><span class="z-2">{{BUILDDIR}}</span><span class="z-5">/</span><span class="z-2">{{TARGET}}</span><span> ~</span><span class="z-5">/</span><span>.local</span><span class="z-5">/</span><span>bin</span><span class="z-5">/</span></span></code></pre>
<p>To lint all the things, invoke <code>dune</code> twice:</p>
<pre class="giallo z-code"><code data-lang="just"><span class="giallo-l"><span class="z-3 z-i"># lint everything</span></span>
<span class="giallo-l"><span class="z-1">lint</span><span class="z-5">:</span></span>
<span class="giallo-l"><span>    dune build @lint</span></span>
<span class="giallo-l"><span>    dune-release lint</span></span></code></pre>
<p>Similarly, to build the docs, build <em>all</em> the docs:</p>
<pre class="giallo z-code"><code data-lang="just"><span class="giallo-l"><span class="z-3 z-i"># build docs</span></span>
<span class="giallo-l"><span class="z-1">doc</span><span class="z-5">:</span></span>
<span class="giallo-l"><span>    dune build @doc</span></span>
<span class="giallo-l"><span>    dune build @doc-private</span></span></code></pre>
<p>Try to open the docs on Linux and if that fails, on MacOS:</p>
<pre class="giallo z-code"><code data-lang="just"><span class="giallo-l"><span class="z-3 z-i"># open the docs for reading</span></span>
<span class="giallo-l"><span class="z-1">read</span><span>: doc</span></span>
<span class="giallo-l"><span>    handlr open </span><span class="z-2">{{DOCDIR}}</span><span class="z-5">/</span><span>index.html </span><span class="z-5">||</span><span> open </span><span class="z-2">{{DOCDIR}}</span></span></code></pre>
<p>Finally, tag and create a release; not actually done this in ages so no idea if
<code>dune-release</code> invocations are still a thing, let alone correct!</p>
<pre class="giallo z-code"><code data-lang="just"><span class="giallo-l"><span class="z-3 z-i"># tag and create a release</span></span>
<span class="giallo-l"><span class="z-1">release</span><span class="z-5">:</span></span>
<span class="giallo-l"><span>    dune-release tag</span></span>
<span class="giallo-l"><span>    dune-release -vv</span></span></code></pre><section class="footnotes">
<ol class="footnotes-list">
<li>
<p>Largely due to <a href="https://nixos.org/" rel="external">NixOS</a> upgrades moving tools into
different locations. <a href="https://mort.io/blog/just-ocaml/#fr-1-1">↩</a></p>
</li>
</ol>
</section>
