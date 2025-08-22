---
title: mlgpx is the first Tangled-hosted package available on opam
description:
url: https://anil.recoil.org/notes/tangled-and-ci
date: 2025-08-17T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
ignore:
---

<p>Since I wrote about the new <a href="https://anil.recoil.org/notes/disentangling-git-with-bluesky">ATProto-powered Tangled Git forge</a> a few months ago, it's come along by leaps and bounds!</p>
<p>First, and most excitingly, they've added <a href="https://blog.tangled.sh/ci">continuous integration via Spindles</a> which are built in a nice ATProto style:</p>
<blockquote>
<p>When you push code or open a pull request, the knot hosting your repository
emits a pipeline event (sh.tangled.pipeline). Running as a dedicated service,
spindle subscribes to these events via websocket connections to your knot.</p>
</blockquote>
<p>The pipelines are Nix-only right now, so I braved using it<sup><a href="https://anil.recoil.org/news.xml#fn-1" role="doc-noteref" class="fn-label">[1]</a></sup> for a new <a href="https://tangled.sh/@anil.recoil.org/ocaml-gpx">GPS Exchange Format library in OCaml</a> that I wrote. The <a href="https://tangled.sh/@anil.recoil.org/ocaml-gpx/pipelines">pipelines</a> should look familiar, and the <a href="https://tangled.sh/@anil.recoil.org/ocaml-gpx/blob/main/.tangled/workflows/build.yml">description format</a> very straightforward.</p>
<p>Secondly, the service has <a href="https://blog.tangled.sh/stacking">added</a> support for <a href="https://github.com/jj-vcs/jj">JJ</a> stacked pull requests, which are the closest I've seen to the <a href="https://blog.janestreet.com/ironing-out-your-release-process/">Jane Street Iron diff workflow</a> which I've been wanting to try in open source for ages.  You can see the interdiff review process on a recent PR by <a href="https://tangled.sh/@winter.bsky.social">Winter</a> who add support for <a href="https://tangled.sh/@tangled.sh/core/pulls/423">engine-agnostic Spindle workflows</a>, which should pave the path for a Docker or BuildKit engine alongside the existing Nixery-based one.</p>
<p>And thirdly, the general quality-of-life of the web frontend has improved dramatically, with a nice <a href="https://tangled.sh/">timeline</a>, <a href="https://tangled.sh/@anil.recoil.org?tab=repos">repo list</a>, and <a href="https://tangled.sh/@anil.recoil.org">profile pages</a>. I'm running two knots right now (one on Recoil, and one in the Cambridge Computer Lab), and both have been very painfree. I wrote one of the earliest <a href="https://tangled.sh/@anil.recoil.org/knot-docker">Dockerfiles</a> for it, but there's now a <a href="https://tangled.sh/@tangled.sh/knot-docker">community-maintained Knot Docker</a> setup which I've switched to. Doesn't take very long at all; give it a try!</p>
<p>Because I've been using Tangled so much, I <a href="https://github.com/ocaml/dune/pull/12197">added support for Tangled metadata</a> to Dune to make OCaml package maintainence easier. This will appear in Dune 3.21 in a few months, but in the meanwhile enjoy the first <a href="https://ocaml.org/p/mlgpx/latest">Tangled.sh package on opam</a>. It's a simple GPX library I used in my <a href="https://anil.recoil.org/notes/owntracks-and-lifecycle">recent trip</a> to Botswana. All you need in your <code>dune-project</code> will be:</p>
<pre><code>(lang dune 3.21)
(name mlgpx)
(generate_opam_files true)
(source (tangled @anil.recoil.org/ocaml-gpx))
</code></pre>
<p>The only major thing I'm missing from Tangled is support for private repositories now, but I'm very content using it for public content today. Beware as usual that it's still in alpha, so don't trust super-ultra-mega-important stuff to it unless you've git mirrored elsewhere.</p>
<section role="doc-endnotes"><ol>
<li>
<p>...with the help of my trusty local Nixer <a href="https://ryan.freumh.org" class="contact">Ryan Gibb</a>. Noone should ever Nix by themselves.</p>
<span><a href="https://anil.recoil.org/news.xml#ref-1-fn-1" role="doc-backlink" class="fn-label">↩︎︎</a></span></li></ol></section>

