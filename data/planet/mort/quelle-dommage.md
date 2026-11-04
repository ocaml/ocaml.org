---
title: Quelle dommage
description: Containerising Mirage
url: https://mort.io/blog/quelle-dommage/
date: 2017-11-05T00:00:00-00:00
preview_image:
authors:
- Richard Mortier
source:
ignore:
keywords:
- MirageOS
- build
- cli
- container
- docker
- dommage
- image
- inside
- mirage
- opam
---

<blockquote>
<p>Ed: this tool is perhaps less relevant now that both
<a href="https://mirage.io/" rel="external">Mirage</a> and <a href="https://ocaml.org/opam/" rel="external">OPAM</a> have moved
on. But perhaps it’ll be resurrected one day so here it is.</p>
</blockquote>
<p>Largely because I wanted to make a feeble attempt at a French pun,
<a href="https://github.com/mor1/dommage/" rel="external"><code>dommage</code></a> is a tool for
<a href="https://docker.com/" rel="external">Docker</a> containerising Mirage unikernels. From the
<a href="https://github.com/mor1/dommage" rel="external">README</a>:</p>
<h2><a href="https://mort.io/rss.xml#dommage-dockerised-mirage" class="zola-anchor" aria-label="Anchor link for: dommage-dockerised-mirage">Dommage, Dockerised Mirage</a></h2>
<p><code>dommage</code> is a shell script that wraps the <a href="https://mirage.io" rel="external">Mirage</a> CLI to make use of Docker
containers meaning that:</p>
<ul>
<li>you can cache the OPAM build artefacts in the container image, speeding up
local builds;</li>
<li>you can re-use the build container image in Travis builds by publishing it,
speeding those up considerably; and</li>
<li>you can easily test build <code>-t xen</code> targets on OSX.</li>
</ul>
<p>I’ve tried to minimise interference with the normal operation of <a href="https://mirage.io" rel="external">Mirage</a> CLI so
simply replacing <code>mirage</code> with <code>dommage</code> is supposed to work. To publish the
resulting container image, <code>dommage publish &lt;image&gt;</code>.</p>
<p>Issues, comments, suggestions and bug fixes all welcome!</p>
<h3><a href="https://mort.io/rss.xml#operation" class="zola-anchor" aria-label="Anchor link for: operation">Operation</a></h3>
<p>To start, <code>dommage</code> provides a few management commands to manipulate the build
container:</p>
<ul>
<li><code>dommage init BASE-IMAGE</code> creates a new container, based off <code>BASE-IMAGE</code>
from the <a href="https://hub.docker.com" rel="external">Docker Hub</a></li>
<li><code>dommage publish IMAGE</code> commits the current container and pushes it to
<a href="https://hub.docker.com" rel="external">Docker Hub</a> as <code>IMAGE</code></li>
<li><code>dommage destroy</code> stops and removes the current build container</li>
<li><code>dommage run ...</code> executes a command inside the current build container</li>
</ul>
<p>In addition, it wraps the main <a href="https://mirage.io" rel="external">Mirage</a> CLI commands:</p>
<ul>
<li><code>dommage configure ...</code> runs <code>mirage configure ... &amp;&amp; make depends</code> inside
the build contianer</li>
<li><code>dommage build ...</code> runs <code>mirage build ...</code> inside the build container</li>
<li><code>dommage clean ...</code> runs <code>mirage clean ...</code> inside the build container</li>
</ul>
