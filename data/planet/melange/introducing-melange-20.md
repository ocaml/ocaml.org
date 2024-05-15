---
title: Introducing Melange 2.0
description:
url: https://melange.re/blog/posts/introducing-melange-20
date: 2023-09-20T00:00:00-00:00
preview_image:
authors:
- Melange Blog
source:
---

<p>Today, the Melange team is excited to introduce Melange 2.0. This iteration
brings an upgrade to the OCaml 5.1 type checker, along with increased
compatibility with the OCaml Platform. Melange 2.0 unifies the compiler
attributes and libraries under the Melange brand and it improves developer
experience across the ecosystem. We're also publishing a few battle-tested
libraries to&nbsp;<a href="https://github.com/ocaml/opam-repository" target="_blank" rel="noreferrer">OPAM</a>.</p>
<hr/>
<p>Everything we have included in this release has been designed to enhance your
experience writing Reason / OCaml for modern JS workflows. Here's a
comprehensive look at what's new.</p>
<h2 tabindex="-1"><strong>What's New in Melange 2.0?</strong> <a href="https://melange.re/blog/feed.rss#what-s-new-in-melange-2-0" class="header-anchor" aria-label="Permalink to &quot;**What's New in Melange 2.0?**&quot;"></a></h2>
<h3 tabindex="-1">OCaml 5 <a href="https://melange.re/blog/feed.rss#ocaml-5" class="header-anchor" aria-label="Permalink to &quot;OCaml 5&quot;"></a></h3>
<p><a href="https://discuss.ocaml.org/t/ocaml-5-1-0-released/13021" target="_blank" rel="noreferrer">OCaml 5.1</a>&nbsp;has just
been released. Melange 2.0 has been upgraded to use the newly released OCaml 5.1
type checker and compiler libs. As the OCaml community starts to upgrade to the
newest version of OCaml, Melange will be co-installable in your OPAM switch.</p>
<p>While the Melange type checker has been upgraded to the 5.x release line,
Melange doesn't yet include support for&nbsp;<a href="https://v2.ocaml.org/manual/effects.html" target="_blank" rel="noreferrer">effect
handlers</a>&nbsp;and some of the multicore
OCaml primitives. Stay tuned for future updates on this.</p>
<h3 tabindex="-1">The reign of&nbsp;<code>melange.ppx</code> <a href="https://melange.re/blog/feed.rss#the-reign-of-melange-ppx" class="header-anchor" aria-label="Permalink to &quot;The reign of&nbsp;`melange.ppx`&quot;"></a></h3>
<p>The compiler frontend transformations related to
the&nbsp;<a href="https://en.wikipedia.org/wiki/Foreign_function_interface" target="_blank" rel="noreferrer">FFI</a>,&nbsp;<a href="https://melange.re/v2.0.0/communicate-with-javascript/#list-of-attributes-and-extension-nodes" target="_blank" rel="noreferrer">extensions</a>&nbsp;and&nbsp;<a href="https://melange.re/v2.0.0/communicate-with-javascript/#generate-getters-setters-and-constructors" target="_blank" rel="noreferrer">derivers</a>&nbsp;have
been fully extracted from the compiler to the Melange PPX. Going forward, it's
likely you'll need to preprocess most Melange code with&nbsp;<code>melange.ppx</code>.</p>
<h3 tabindex="-1">Wrapping the Melange Core Libraries <a href="https://melange.re/blog/feed.rss#wrapping-the-melange-core-libraries" class="header-anchor" aria-label="Permalink to &quot;Wrapping the Melange Core Libraries&quot;"></a></h3>
<p>In this release, we wrapped the Melange runtime and core libraries. Each library
exposes only a single top-level module, avoiding namespace pollution. The only
modules exposed by Melange are now:</p>
<ul>
<li>
<p>The&nbsp;<code>Js</code>&nbsp;module contains utilities to interact with JavaScript standard APIs.
Modules such as&nbsp;<code>Js_string</code>&nbsp;now only accessible via&nbsp;<code>Js.String</code>.</p>
</li>
<li>
<p>The&nbsp;<code>Belt</code>&nbsp;library contains utilities inherited from BuckleScript. Its
sub-modules similarly nested under&nbsp;<code>Belt</code>, e.g. you'll use&nbsp;<code>Belt.List</code>&nbsp;instead
of&nbsp;<code>Belt_List</code>.</p>
</li>
<li>
<p>Melange 2.0 exposes only a single&nbsp;<code>Stdlib</code>&nbsp;module, where previously it was
leaking e.g.&nbsp;<code>Stdlib__String</code>, etc.</p>
</li>
<li>
<p><strong>New libraries</strong>: The&nbsp;<code>Node</code>&nbsp;module has been extracted to a
new&nbsp;<code>melange.node</code>&nbsp;library. Similarly,&nbsp;<code>Dom</code>&nbsp;is now only accessible via
the&nbsp;<code>melange.dom</code>&nbsp;library. Both libraries are released with the Melange
distribution, but not included by default; they can be added to the
Dune&nbsp;<code>(libraries ...)</code>&nbsp;field.</p>
</li>
</ul>
<h3 tabindex="-1">Enforcing the Melange brand <a href="https://melange.re/blog/feed.rss#enforcing-the-melange-brand" class="header-anchor" aria-label="Permalink to &quot;Enforcing the Melange brand&quot;"></a></h3>
<p><code>bs.*</code>&nbsp;<a href="https://melange.re/v2.0.0/communicate-with-javascript/#attributes" target="_blank" rel="noreferrer">attributes</a>&nbsp;have
been deprecated in this release in favor of&nbsp;<code>mel.*</code>.
The&nbsp;<a href="https://melange.re/v2.0.0/communicate-with-javascript/#binding-to-callbacks" target="_blank" rel="noreferrer">uncurried</a>&nbsp;<code>[@bs]</code>&nbsp;attribute
is now simply&nbsp;<code>[@u]</code>. The next major Melange release will be removing them
entirely.&nbsp;<code>%bs.*</code>&nbsp;<a href="https://melange.re/v2.0.0/communicate-with-javascript/#extension-nodes" target="_blank" rel="noreferrer">extension
nodes</a>&nbsp;have,
however, been replaced with&nbsp;<code>%mel.*&nbsp;</code>due to limitations
in&nbsp;<a href="https://github.com/ocaml-ppx/ppxlib" target="_blank" rel="noreferrer">ppxlib</a>. This is a breaking change.</p>
<h3 tabindex="-1">Development experience <a href="https://melange.re/blog/feed.rss#development-experience" class="header-anchor" aria-label="Permalink to &quot;Development experience&quot;"></a></h3>
<p>We've done significant work making Melange easier to use in this release:</p>
<ol>
<li>
<p>Attributes like&nbsp;<code>[@{bs,mel}.val]</code>&nbsp;have been deprecated as they're redundant
in the Melange FFI.</p>
</li>
<li>
<p>We're introducing more ways of using&nbsp;<code>@mel.as</code>&nbsp;in:</p>
<ol>
<li>
<p><code>let</code><a href="https://github.com/melange-re/melange/pull/714" target="_blank" rel="noreferrer">&nbsp;bindings</a>&nbsp;to
allow exporting otherwise invalid OCaml identifiers;</p>
</li>
<li>
<p><code>external</code><a href="https://github.com/melange-re/melange/pull/722" target="_blank" rel="noreferrer">&nbsp;polymorphic
variants</a>&nbsp;without
needing to use&nbsp;<code>[@mel.{string,int}]</code>;</p>
</li>
<li>
<p><a href="https://github.com/melange-re/melange/pull/732" target="_blank" rel="noreferrer">inline records</a>&nbsp;in both
regular and extensible variants and custom exceptions.</p>
</li>
</ol>
</li>
</ol>
<h3 tabindex="-1">Ecosystem <a href="https://melange.re/blog/feed.rss#ecosystem" class="header-anchor" aria-label="Permalink to &quot;Ecosystem&quot;"></a></h3>
<ul>
<li>
<p>With this release, we're starting to publish some widely used libraries from
the&nbsp;<code>melange-community</code>&nbsp;and&nbsp;<code>ahrefs</code>&nbsp;organizations. Be on the lookout for new
Melange-ready releases popping up in the&nbsp;<a href="https://github.com/ocaml/opam-repository" target="_blank" rel="noreferrer">OPAM
repository</a>&nbsp;in the next few
days.&nbsp;<a href="https://github.com/ocaml/opam-repository/pull/24396" target="_blank" rel="noreferrer">Reason 3.10</a>&nbsp;is
also a companion release to Melange 2.0.</p>
</li>
<li>
<p>The new&nbsp;<code>reason-react</code>&nbsp;releases greatly increase developer experience
by&nbsp;<a href="https://github.com/reasonml/reason-react/pull/748" target="_blank" rel="noreferrer">improving the editor
integration</a>. React props
and children now point to the correct source code locations, making React
components much easier to track in your editor.</p>
</li>
<li>
<p>We've also released an OPAM
plugin,&nbsp;<a href="https://github.com/jchavarri/opam-check-npm-deps/" target="_blank" rel="noreferrer">check-npm-deps</a>.
This tool checks whether the NPM dependencies in your&nbsp;<code>node_modules</code>&nbsp;folder
match what libraries released to OPAM need.&nbsp;<code>check-npm-deps</code>&nbsp;is currently in
preview and we're looking for your feedback on how we can evolve it.</p>
</li>
</ul>
<h2 tabindex="-1"><strong>Support &amp; Sponsorship</strong> <a href="https://melange.re/blog/feed.rss#support-sponsorship" class="header-anchor" aria-label="Permalink to &quot;**Support &amp; Sponsorship**&quot;"></a></h2>
<p>This release was made possible with the continued support of:</p>
<ul>
<li>
<p><a href="https://ahrefs.com/?utm_source=anmonteiro&amp;utm_medium=email&amp;utm_campaign=melange-hits-v10" target="_blank" rel="noreferrer">Ahrefs</a>,
who have been supporting Melange development since October 2022, having
fully&nbsp;<a href="https://tech.ahrefs.com/ahrefs-is-now-built-with-melange-b14f5ec56df4?utm_source=anmonteiro&amp;utm_medium=email&amp;utm_campaign=melange-hits-v10" target="_blank" rel="noreferrer">migrated their codebase to
Melange</a>&nbsp;and
making the work towards&nbsp;<a href="https://anmonteiro.substack.com/p/melange-10-is-here" target="_blank" rel="noreferrer">Melange
1.0</a>&nbsp;possible.</p>
</li>
<li>
<p>The&nbsp;<a href="https://ocaml-sf.org/?utm_source=anmonteiro&amp;utm_medium=email&amp;utm_campaign=melange-hits-v10" target="_blank" rel="noreferrer">OCaml Software
Foundation</a>,
who has previously&nbsp;<a href="https://twitter.com/_anmonteiro/status/1589044352479035393?utm_source=anmonteiro&amp;utm_medium=email&amp;utm_campaign=melange-hits-v10" target="_blank" rel="noreferrer">committed
funding</a>&nbsp;for
the Melange project in October 2022, and renewed it for another half-year
ending in August 2023.</p>
</li>
<li>
<p><a href="https://github.com/sponsors/anmonteiro/?utm_source=anmonteiro&amp;utm_medium=email&amp;utm_campaign=melange-hits-v10" target="_blank" rel="noreferrer">My (Antonio)
sponsors</a>&nbsp;on
GitHub, both past and present.</p>
</li>
</ul>
<h3 tabindex="-1">Parting thoughts <a href="https://melange.re/blog/feed.rss#parting-thoughts" class="header-anchor" aria-label="Permalink to &quot;Parting thoughts&quot;"></a></h3>
<p>The goal of Melange is to provide a robust and evolving toolchain that matches
the dynamic nature of modern JS development. Melange 2.0 is a testament to that
commitment. In this release, we've shipped the majority of our&nbsp;<a href="https://docs.google.com/document/d/1UhanM28sOAmS3NI4q4BJBeoCX0SdBMqUIq0rofdpOfU" target="_blank" rel="noreferrer">Q3
roadmap</a>.
Dive in, explore the new features, and let us know your feedback.</p>
<p>Consult the&nbsp;<a href="https://github.com/melange-re/melange/blob/main/Changes.md#200-2023-09-13" target="_blank" rel="noreferrer">full change
log</a>&nbsp;and
the&nbsp;<a href="https://melange.re/v2.0.0/how-to-guides/#to-v2-from-v1" target="_blank" rel="noreferrer">migration guide from
1.0</a>&nbsp;for a more detailed
look at all the changes that went into this packed release.</p>
<p>If you or your company are interested in seeing what Melange can do for your
JavaScript needs, feel free to get in touch. We'd love to hear from you.</p>
<p>Happy hacking!</p>
<p>Antonio &amp; the Melange team</p>

