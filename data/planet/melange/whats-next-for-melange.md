---
title: What's next for Melange
description:
url: https://melange.re/blog/posts/whats-next-for-melange
date: 2023-07-10T00:00:00-00:00
preview_image:
featured:
authors:
- Melange Blog
source:
---

<p>We're quite happy with how far Melange has come -- I previously wrote
about&nbsp;<a href="https://anmonteiro.substack.com/p/melange-10-is-here" target="_blank" rel="noreferrer">releasing Melange
1.0</a>&nbsp;and a&nbsp;<a href="https://anmonteiro.substack.com/p/melange-q2-2023-retrospective" target="_blank" rel="noreferrer">retrospective
on Q2 2023</a>.</p>
<p>But we're not done yet: there's more in slate for the next quarter. I'll tell
you what we're looking to achieve in Q3 2023.</p>
<hr/>
<p>We've decided to call the next Melange version 2.0 -- we plan to make a few
breaking changes. The main goal for this quarter is to release Melange 2.0. We
will focus across a few different axes.</p>
<h3 tabindex="-1">OCaml (and OCaml Platform) compatibility <a href="https://melange.re/blog/feed.rss#ocaml-and-ocaml-platform-compatibility" class="header-anchor" aria-label="Permalink to &quot;OCaml (and OCaml Platform) compatibility&quot;"></a></h3>
<p>Melange integrates with the most popular workflows in the OCaml
ecosystem.&nbsp;<a href="https://dune.build/" target="_blank" rel="noreferrer">Dune</a>&nbsp;builds Melange
projects.&nbsp;<a href="https://github.com/ocaml/merlin" target="_blank" rel="noreferrer">Merlin</a>&nbsp;and the&nbsp;<a href="https://github.com/ocaml/ocaml-lsp" target="_blank" rel="noreferrer">OCaml
LSP</a>&nbsp;power editor
integration.&nbsp;<a href="https://github.com/ocaml-ppx/ocamlformat" target="_blank" rel="noreferrer">OCamlformat</a>&nbsp;and&nbsp;<a href="https://github.com/reasonml/reason" target="_blank" rel="noreferrer">Reason</a>'s&nbsp;<code>refmt</code>&nbsp;automatically
format code.&nbsp;<a href="https://github.com/tarides/dune-release" target="_blank" rel="noreferrer">dune-release</a>&nbsp;publishes
Melange libraries and PPX to the&nbsp;<a href="https://github.com/ocaml/opam-repository/" target="_blank" rel="noreferrer">OPAM
repository</a>.&nbsp;<a href="https://github.com/ocaml/odoc" target="_blank" rel="noreferrer">odoc</a>&nbsp;builds
package documentation.</p>
<p>In Melange 2.0, we will:</p>
<ul>
<li>
<p>Upgrade the Melange type-checker and standard library to OCaml 5.1:</p>
<ul>
<li>
<p>Turn off&nbsp;<a href="https://v2.ocaml.org/manual/effects.html" target="_blank" rel="noreferrer">Effect Handlers</a>&nbsp;for the
time being.</p>
</li>
<li>
<p>Provide a compatible&nbsp;<a href="https://v2.ocaml.org/api/Domain.html" target="_blank" rel="noreferrer">Domain</a>&nbsp;module
shim.</p>
</li>
</ul>
</li>
<li>
<p>Move the Melange internal PPX completely out of the compiler,
into&nbsp;<code>melange.ppx</code>:</p>
</li>
<li>
<p>Wrap the&nbsp;<code>Belt</code>&nbsp;and&nbsp;<code>Js</code>&nbsp;libraries:</p>
<ul>
<li>These currently expose all their internal modules. Dune can wrap them nicely
under a single top-level module.</li>
</ul>
</li>
<li>
<p>Break out&nbsp;<code>melange.node</code>:</p>
<ul>
<li>The Node.js bindings are rarely used. We will require&nbsp;<code>melange.node</code>&nbsp;be
added to the Dune&nbsp;<code>libraries</code>&nbsp;field.</li>
</ul>
</li>
</ul>
<h3 tabindex="-1">Developer Experience <a href="https://melange.re/blog/feed.rss#developer-experience" class="header-anchor" aria-label="Permalink to &quot;Developer Experience&quot;"></a></h3>
<p>While Melange already integrates with the OCaml Platform tooling and workflow,
there is space to make the experience of developing Melange projects even
better.</p>
<p>We want to focus on:</p>
<ul>
<li>
<p>Improving the editing experience:</p>
<ul>
<li>
<p>Melange can compile FFI&nbsp;<code>external</code>s better, in a way that works better with
analysis tools such as Merlin.</p>
</li>
<li>
<p><code>reason-react-ppx</code>&nbsp;doesn't faithfully respect the JSX node locations. We
want to fix that so that &quot;go to definition&quot; works better for Reason JSX.</p>
</li>
</ul>
</li>
<li>
<p>Improving the interaction between OPAM and npm:</p>
<ul>
<li>
<p>Melange bridges the OPAM and npm ecosystems. Some packages published to OPAM
depend on npm dependencies at runtime.</p>
</li>
<li>
<p>We want to&nbsp;<a href="https://github.com/melange-re/melange/issues/629" target="_blank" rel="noreferrer">explore
solving</a>&nbsp;this issue,
starting with a tool that checks that the required npm dependencies are
installed in Melange projects.</p>
</li>
</ul>
</li>
<li>
<p>Generating&nbsp;<a href="https://docs.google.com/document/d/1U1RGAehQwRypUTovF1KRlpiOFze0b-_2gc6fAH0KY0k/edit?hl=en_US&amp;pli=1&amp;pli=1" target="_blank" rel="noreferrer">Source
Maps</a>:</p>
<ul>
<li>
<p>Source Maps allow mapping generated code back to the original OCaml / Reason
source.</p>
</li>
<li>
<p>Among other benefits, source maps allow for better stack traces that map to
the original lines of code that triggered runtime crashes.</p>
</li>
</ul>
</li>
</ul>
<h3 tabindex="-1">Documentation and Branding: <a href="https://melange.re/blog/feed.rss#documentation-and-branding" class="header-anchor" aria-label="Permalink to &quot;Documentation and Branding:&quot;"></a></h3>
<p>We released&nbsp;<a href="https://melange.re/" target="_blank" rel="noreferrer">melange.re</a>&nbsp;alongside Melange 1.0. The website
contains our initial efforts to document Melange workflows, and it can be
improved upon. Over the next few months, we will:</p>
<ul>
<li>
<p>Develop unified Melange brand guidelines and apply them to the website.</p>
</li>
<li>
<p>Continue documenting Melange workflows:</p>
<ul>
<li>We've already seen some&nbsp;<a href="https://github.com/melange-re/melange-re.github.io/pulls?q=is:pr%20is:closed" target="_blank" rel="noreferrer">user
contributions</a>.
We're looking to keep improving the Melange documentation in response to
feedback from Melange users.</li>
</ul>
</li>
</ul>
<h3 tabindex="-1">Wrapping up <a href="https://melange.re/blog/feed.rss#wrapping-up" class="header-anchor" aria-label="Permalink to &quot;Wrapping up&quot;"></a></h3>
<p>We have a lot of work ahead of us. The best way to help us is to&nbsp;<a href="https://melange.re/v1.0.0/getting-started/" target="_blank" rel="noreferrer">try
Melange</a>. We'd love to read your
feedback.</p>
<p>I tried to summarize what we'll be up to in the near future. The full&nbsp;<a href="https://docs.google.com/document/d/1UhanM28sOAmS3NI4q4BJBeoCX0SdBMqUIq0rofdpOfU/edit" target="_blank" rel="noreferrer">Melange
Roadmap for Q3
2023</a>&nbsp;goes
into more detail.</p>
<p>Happy hacking!</p>

