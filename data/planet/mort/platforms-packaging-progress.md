---
title: Platforms, Packaging, Progress
description: Modernising a small OCaml package
url: https://mort.io/blog/past-present-future/
date: 2017-08-28T00:00:00-00:00
preview_image:
authors:
- Richard Mortier
source:
ignore:
keywords:
- MirageOS
- distrib
- jbuilder
- merlin
- ocal
- odoc
- opam
- pkg
- publish
- topkg
---

<p>I recently decided to refresh and update my <a href="https://github.com/mor1/ocal/" rel="external">ocal</a> package,<sup class="footnote-reference"><a href="https://mort.io/blog/past-present-future/#fn-1">[1]</a></sup> primarily to
port it to use the excellent <a href="https://github.com/pqwy/notty/" rel="external">notty</a> before adding support for indicating
week-of-year. At the same time, I took the opportunity to update the build
infrastructure now that the OCaml world has some shiny new packaging and build
tools to go with <a href="https://github.com/ocaml/opam/" rel="external">OPAM</a>, namely <a href="https://github.com/dbuenzli/topkg/" rel="external"><code>topkg</code></a> and <a href="https://github.com/janestreet/jbuilder/" rel="external"><code>jbuilder</code></a>. So, starting
from <a href="http://github.com/djs55/" rel="external">Dave Scott’s</a> <a href="https://mirage.io/wiki/packaging" rel="external">wiki entry</a> about how to package <a href="https://mirage.io/" rel="external">Mirage</a> libraries,
here’s what I had to do…</p>
<h2><a href="https://mort.io/rss.xml#remove-oasis-remnants" class="zola-anchor" aria-label="Anchor link for: remove-oasis-remnants">Remove Oasis remnants</a></h2>
<pre class="giallo z-code"><code data-lang="shellscript"><span class="giallo-l"><span class="z-1">git</span><span class="z-2"> rm _oasis setup.ml Makefile</span><span class="z-1">*</span><span class="z-2"> _tags myocamlbuild.ml .merlin</span></span>
<span class="giallo-l"><span class="z-1">mv</span><span class="z-2"> ocal.opam/opam o</span><span> &amp;&amp;</span><span class="z-1"> git</span><span class="z-2"> rm</span><span class="z-8"> -rf</span><span class="z-2"> ocal.opam</span><span> &amp;&amp;</span><span class="z-1"> mv</span><span class="z-2"> o ocal.opam</span><span> &amp;&amp;</span><span class="z-1"> git</span><span class="z-2"> add ocal.opam</span></span>
<span class="giallo-l"><span class="z-1">cat</span><span class="z-5"> &gt;|</span><span class="z-1"> .gitignore</span><span class="z-5"> &lt;&lt;</span><span>_EOF</span></span>
<span class="giallo-l"><span class="z-2">_build</span></span>
<span class="giallo-l"><span class="z-2">*.merlin</span></span>
<span class="giallo-l"><span class="z-2">*.install</span></span>
<span class="giallo-l"><span>_EOF</span></span></code></pre>
<p>Although we’re removing the <code>ocal.opam/descr</code> file, we’re not going to lose the
content: we’re going to let <code>topkg opam pkg</code> use its default <code>--readme</code> option
to extract the relevant info from the first marked up section of the
<a href="https://github.com/mor1/ocal/blob/0.2.0/README.md" rel="external"><code>README.md</code></a>:</p>
<pre class="giallo z-code"><code data-lang="markdown"><span class="giallo-l"><span class="z-1 z-b"># ocal — An improved Unix </span><span class="z-2">`cal`</span><span class="z-1 z-b"> utility</span></span>
<span class="giallo-l"></span>
<span class="giallo-l"><span>%%VERSION%%</span></span>
<span class="giallo-l"></span>
<span class="giallo-l"><span>A replacement for the standard Unix </span><span class="z-2">`cal`</span><span> utility. Partly because I could,</span></span>
<span class="giallo-l"><span>partly because I'd become too irritated with its command line interface.</span></span></code></pre>
<p>We also remove but don’t lose the functionality of the <code>.merlin</code> and OPAM
<code>ocal.install</code> files, as <a href="https://github.com/janestreet/jbuilder/" rel="external">jbuilder</a> will generate them for us.</p>
<h2><a href="https://mort.io/rss.xml#create-src-jbuild-file" class="zola-anchor" aria-label="Anchor link for: create-src-jbuild-file">Create <code>src/jbuild</code> file</a></h2>
<pre class="giallo z-code"><code data-lang="shellscript"><span class="giallo-l"><span class="z-1">cat</span><span class="z-5"> &gt;|</span><span class="z-1"> src/jbuild</span><span class="z-5"> &lt;&lt;</span><span>_EOF</span></span>
<span class="giallo-l"><span class="z-2">(jbuild_version 1)</span></span>
<span class="giallo-l"></span>
<span class="giallo-l"><span class="z-2">(executable</span></span>
<span class="giallo-l"><span class="z-2"> ((public_name ocal)</span></span>
<span class="giallo-l"><span class="z-2">  (package     ocal)</span></span>
<span class="giallo-l"><span class="z-2">  (name        main)</span></span>
<span class="giallo-l"></span>
<span class="giallo-l"><span class="z-2">  (libraries</span></span>
<span class="giallo-l"><span class="z-2">   (</span></span>
<span class="giallo-l"><span class="z-2">    astring</span></span>
<span class="giallo-l"><span class="z-2">    calendar</span></span>
<span class="giallo-l"><span class="z-2">    cmdliner</span></span>
<span class="giallo-l"><span class="z-2">    notty</span></span>
<span class="giallo-l"><span class="z-2">    notty.unix</span></span>
<span class="giallo-l"><span class="z-2">    ))</span></span>
<span class="giallo-l"><span class="z-2">  (flags (:standard -w "A-44-48-52" -safe-string))</span></span>
<span class="giallo-l"><span class="z-2">  ))</span></span>
<span class="giallo-l"><span>_EOF</span></span></code></pre>
<p>This corresponds to the <a href="https://github.com/mor1/ocal/releases/tag/0.2.0" rel="external">0.2.0</a>
release of <a href="https://github.com/mor1/ocal/" rel="external">ocal</a>. Note that the <code>name</code> parameter refers to the module that
contains the entrypoint for the executable, and that we turn on all warnings
(<code>A</code>) except for three that we wish to ignore:</p>
<ul>
<li><code>44</code>: Open statement shadows an already defined identifier.</li>
<li><code>48</code>: Implicit elimination of optional arguments.</li>
<li><code>52</code>: (see 8.5.1) Fragile constant pattern.</li>
</ul>
<p>After I did some tidying up of the code to deal with the newly imposed warnings,
<code>make</code> and <code>make install</code> satisfactorily (and quickly!) used <a href="https://github.com/janestreet/jbuilder/" rel="external">jbuilder</a> to
build and install the executable as <code>~/.opam/system/bin/ocal</code> (thanks to the
<code>public_name</code> stanza in the <code>src/jbuild</code> file, above). <code>make uninstall</code> then
caused <a href="https://github.com/janestreet/jbuilder/" rel="external">jbuilder</a> to remove it, before I <code>opam</code> pinned it and then reinstall
through <code>opam</code> to check that workflow worked as well:</p>
<pre class="giallo z-code"><code data-lang="shellscript"><span class="giallo-l"><span class="z-1">opam</span><span class="z-2"> remove ocal</span></span>
<span class="giallo-l"><span class="z-1">opam</span><span class="z-2"> pin add</span><span class="z-8"> -yn --dev-repo</span><span class="z-2"> ocal .</span></span>
<span class="giallo-l"><span class="z-1">opam</span><span class="z-2"> install ocal</span></span></code></pre><h2><a href="https://mort.io/rss.xml#create-the-topkg-skeletons" class="zola-anchor" aria-label="Anchor link for: create-the-topkg-skeletons">Create the <code>topkg</code> skeletons</a></h2>
<p>Having refreshed the basic build infrastructure, next it’s time to update the
packaging workflow. For a simple library we could use the automatic
<a href="https://github.com/janestreet/jbuilder/" rel="external">jbuilder</a>/<a href="https://github.com/dbuenzli/topkg/" rel="external">topkg</a> plugin per the <a href="https://mirage.io/wiki/packaging" rel="external">wiki entry</a>:</p>
<pre class="giallo z-code"><code data-lang="shellscript"><span class="giallo-l"><span class="z-1">mkdir</span><span class="z-2"> pkg</span></span>
<span class="giallo-l"><span class="z-1">cat</span><span class="z-5"> &gt;|</span><span class="z-1"> pkg/pkg.ml</span><span class="z-5"> &lt;&lt;</span><span>_EOF</span></span>
<span class="giallo-l"><span class="z-2">#!/usr/bin/env ocaml</span></span>
<span class="giallo-l"><span class="z-2">#use "topfind"</span></span>
<span class="giallo-l"><span class="z-2">#require "topkg-jbuilder.auto"</span></span>
<span class="giallo-l"><span>_EOF</span></span></code></pre>
<p>However, this isn’t a library so we don’t have documentation to build so we
don’t bother with the <code>odoc</code> skeleton. As a result we also need to customise
<a href="https://github.com/mor1/ocal/blob/0.2.0/pkg/pkg.ml" rel="external"><code>pkg/pkg.ml</code></a> so as to stop <code>topkg publish</code> failing when it can’t build docs:</p>
<pre class="giallo z-code"><code data-lang="ocaml"><span class="giallo-l"><span>#!/usr/bin/env ocaml</span></span>
<span class="giallo-l"><span class="z-3">#</span><span>use </span><span class="z-2">"topfind"</span></span>
<span class="giallo-l"><span>#require </span><span class="z-2">"topkg-jbuilder"</span></span>
<span class="giallo-l"></span>
<span class="giallo-l"><span class="z-10">open</span><span class="z-9"> Topkg</span></span>
<span class="giallo-l"></span>
<span class="giallo-l"><span class="z-5">let</span><span class="z-1"> publish</span><span class="z-5"> =</span></span>
<span class="giallo-l"><span class="z-9">  Pkg</span><span class="z-5">.</span><span>publish</span><span class="z-10"> ~</span><span class="z-7">artefacts</span><span class="z-5">:</span><span class="z-6">[</span><span>`</span><span class="z-6">Distrib] ()</span></span>
<span class="giallo-l"></span>
<span class="giallo-l"><span class="z-5">let</span><span class="z-6"> ()</span><span class="z-5"> =</span></span>
<span class="giallo-l"><span class="z-9">  Topkg_jbuilder</span><span class="z-5">.</span><span>describe</span><span class="z-10"> ~</span><span class="z-7">publish</span><span class="z-6"> ()</span></span></code></pre><h2><a href="https://mort.io/rss.xml#prepare-a-release" class="zola-anchor" aria-label="Anchor link for: prepare-a-release">Prepare a release</a></h2>
<p>Finally, we follow the standard <a href="https://github.com/dbuenzli/topkg/" rel="external">topkg</a> workflow to prepare a release. First,
add an entry to <a href="https://github.com/mor1/ocal/blob/0.2.0/CHANGES.md" rel="external"><code>CHANGES.md</code></a> with the correct formatting and commit the
result, and then:</p>
<pre class="giallo z-code"><code data-lang="make"><span class="giallo-l"><span class="z-1">distrib</span><span>:</span></span>
<span class="giallo-l"><span>	[ -x </span><span class="z-1">$$</span><span>(opam config var root)/plugins/opam-publish/repos/ocal ] || </span><span class="z-8">\</span></span>
<span class="giallo-l"><span>	  opam-publish repo add ocal mor1/ocal</span></span>
<span class="giallo-l"><span>	topkg tag</span></span>
<span class="giallo-l"><span>	topkg distrib</span></span></code></pre>
<p>…which creates tokens for accessing the GitHub repo for this project (if they
don’t already exist), creates a release tag based on entries in <a href="https://github.com/mor1/ocal/blob/0.2.0/CHANGES.md" rel="external"><code>CHANGES.md</code></a>,
and then creates the release tarballs (without the edits to <a href="https://github.com/mor1/ocal/blob/0.2.0/pkg/pkg.ml" rel="external"><code>pkg/pkg.ml</code></a> this
would also build the docs, but we have none).</p>
<h2><a href="https://mort.io/rss.xml#publish-a-release" class="zola-anchor" aria-label="Anchor link for: publish-a-release">Publish a release</a></h2>
<p>Finally, we publish the release to GitHub and issue a pull request to
the <a href="https://github.com/ocaml/opam/" rel="external">OPAM repository</a> to add the new release into OPAM after linting and
tests have passed.</p>
<pre class="giallo z-code"><code data-lang="make"><span class="giallo-l"><span class="z-1">publish</span><span>:</span></span>
<span class="giallo-l"><span>	topkg publish</span></span>
<span class="giallo-l"><span>	topkg opam pkg</span></span>
<span class="giallo-l"><span>	topkg opam submit</span></span></code></pre>
<p>Given that this repo has only a single package, we could in fact simply issue</p>
<pre class="giallo z-code"><code data-lang="plain"><span class="giallo-l"><span>topkg tag &amp;&amp; topkg bistro</span></span></code></pre>
<p>Also, as an alternative to customising the <a href="https://github.com/mor1/ocal/blob/0.2.0/pkg/pkg.ml" rel="external"><code>pkg/pkg.ml</code></a> as indicated above, we
could simply remember to indicate the appropriate customisation on the command
line:</p>
<pre class="giallo z-code"><code data-lang="plain"><span class="giallo-l"><span>topkg publish distrib</span></span></code></pre>
<p>…but <code>topkg bistro</code> wouldn’t then work.</p>
<h2><a href="https://mort.io/rss.xml#conclusion" class="zola-anchor" aria-label="Anchor link for: conclusion">Conclusion</a></h2>
<p>So that’s it: a simple executable distribution taken from old-school <a href="http://oasis.forge.ocamlcore.org/" rel="external">Oasis</a> and
<a href="https://ocaml.org/learn/tutorials/ocamlbuild/" rel="external">OCamlBuild</a> infrastructure to shiny new modern <a href="https://github.com/janestreet/jbuilder/" rel="external">jbuilder</a> and <a href="https://github.com/dbuenzli/topkg/" rel="external">topkg</a>. The new
scheme seems to me to be an improvement: faster build times, simpler (to my
eyes) metadata, autogeneration of more of the repeated metadata (<code>.merlin</code> etc),
and a reasonably simple <a href="https://github.com/mor1/ocal/blob/0.2.0/Makefile" rel="external"><code>Makefile</code></a> that I actually think I understand.
Definitely progress :)</p>
<section class="footnotes">
<ol class="footnotes-list">
<li>
<p>A somewhat over-featured replacement for the standard UNIX <code>cal</code> utility,
because I got irritated by its American-centricity and my
initial <a href="https://github.com/mor1/python-scripts/blob/master/cal.py" rel="external">Python replacement</a> was just too slow… <a href="https://mort.io/blog/past-present-future/#fr-1-1">↩</a></p>
</li>
</ol>
</section>
