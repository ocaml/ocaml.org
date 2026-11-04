---
title: "Platforms, Packaging, Progress\u2014 Addendum"
description: Fixing OPAM Release Metadata Errors
url: https://mort.io/blog/topkg-addendum/
date: 2017-09-01T00:00:00-00:00
preview_image:
authors:
- Richard Mortier
source:
ignore:
keywords:
- addendum
- all-in-all
- carelessness
- cue
- gnashing
- mondet
- ocal
- opam
- teeth
- wailing
---

<p>This is a short addendum to my <a href="http://mort.io/blog/2017/08/28/past-present-future/" rel="external">post of a couple of days
ago</a> caused by my
carelessness in writing the <a href="https://github.com/mor1/ocal/blob/13a9a7f5b8f2e0be4c2b55941a00a885df202cf8/ocal.opam#L16-L22" rel="external">OPAM
file</a>.
Careful readers will observe the lack of any dependency on <a href="https://github.com/pqwy/notty/" rel="external">notty</a>. Read on for
what happened next…</p>
<p>The result of this carelessness was that everything worked just fine locally,
but <a href="https://github.com/ocaml/opam-repository/pull/10176" rel="external">my PR to the OPAM package
repository</a> failed. Cue
much wailing and gnashing of teeth.</p>
<p>However, thanks to a moment’s assistance
from <a href="http://erratique.ch/contact.en" rel="external">Daniel Bünzli</a>, this was easy to fix:</p>
<pre class="giallo z-code"><code data-lang="shellscript"><span class="giallo-l"><span class="z-1">$</span><span class="z-2"> git checkout</span><span class="z-9"> 0.2.0</span><span class="z-3 z-i">       # checkout the relevant release version tag</span></span>
<span class="giallo-l"><span class="z-1">$</span><span class="z-2"> topkg opam pkg</span><span class="z-3 z-i">           # create the release metadata</span></span>
<span class="giallo-l"><span class="z-1">$</span><span class="z-2"> e _build/ocal.0.2.0/opam</span><span class="z-3 z-i"> # invoke editor so I can add the missing dep</span></span>
<span class="giallo-l"><span class="z-1">$</span><span class="z-2"> topkg opam submit</span><span class="z-3 z-i">        # submit the updated OPAM metadata, updating the PR</span></span>
<span class="giallo-l"><span class="z-1">Submitting</span><span class="z-2"> _build/ocal.0.2.0</span></span>
<span class="giallo-l"><span>[ocal-0.2.0.tbz] http://github.com/mor1/ocal/releases/download/0.2.0/ocal-0.2.0.tbz downloaded</span></span>
<span class="giallo-l"><span class="z-1">Updating</span><span class="z-2"> existing pull-request</span><span class="z-3 z-i"> #10176</span></span>
<span class="giallo-l"><span class="z-1">Pull-requested:</span><span class="z-2"> https://github.com/ocaml/opam-repository/pull/10176</span></span></code></pre>
<p>For me, the main thing to note here is that the OPAM metadata in the repo at the
commit ref tagged for release doesn’t match that which OPAM uses to install the
release. But as <a href="http://seb.mondet.org/" rel="external">Sebastien Mondet</a> pointed out to me,
this is neither relevant nor (in the long term) likely, as (e.g.) version
constraints on dependencies may need to be added to old versions of dependent
packages to keep them working. (Though I did add and commit the dependency to
<code>master</code>, naturally.)</p>
<p>So, all-in-all, an easy fix to a common problem. Which is the way it should
be…</p>
