---
title: Melange 4.0 is here
description:
url: https://melange.re/blog/posts/melange-4-is-here
date: 2024-05-22T00:00:00-00:00
preview_image:
authors:
- Melange Blog
source:
---

<p>Today, we're introducing Melange 4.0, the latest version of our backend for the
OCaml compiler that emits JavaScript.</p>
<p>Melange is now compatible with OCaml 5.2! In this release, Melange starts
emitting more ES6 constructs, supports more JavaScript builtins, improves error
handling, and makes using Dune virtual libraries fully supported. Read on for
more details.</p>
<hr/>
<h2 tabindex="-1">Embracing OCaml 5.2 <a href="https://melange.re/blog/feed.rss#embracing-ocaml-5-2" class="header-anchor" aria-label="Permalink to &quot;Embracing OCaml 5.2&quot;"></a></h2>
<p>OCaml 5.2 was released just last week. With Melange 4, you can now leverage all
the power and enhancements in this latest OCaml version. We've upgraded the
OCaml type checker and the standard library to match OCaml 5.2's, ensuring you
can select a 5.2-compatible Melange in your projects.</p>
<p>This does <strong>not</strong> mean Melange is only compatible with OCaml 5.2. As previously
mentioned in the <a href="https://melange.re/blog/announcing-melange-3.html#multiple-ocaml-version-releases">Melange 3
announcement</a>, each
Melange version ships one release for every compiler version that it supports;
for OCaml 5.1, this would correspond to Melange <code>4.0.0-51</code>.</p>
<h2 tabindex="-1">Full Support for Dune Virtual Libraries <a href="https://melange.re/blog/feed.rss#full-support-for-dune-virtual-libraries" class="header-anchor" aria-label="Permalink to &quot;Full Support for Dune Virtual Libraries&quot;"></a></h2>
<p>Melange now fully supports <a href="https://dune.readthedocs.io/en/stable/variants.html" target="_blank" rel="noreferrer">Dune virtual
libraries</a>, which requires
Dune 3.15.2. There were a few bumps in road when we thought it wouldn't be
possible to support this use case in Melange. We were thankfully proven wrong
(<a href="https://github.com/melange-re/melange/pull/1067" target="_blank" rel="noreferrer">#1067</a>), and we think that
virtual libraries can become an interesting way to write libraries that work
across Melange and native OCaml, sharing a common interface.</p>
<h2 tabindex="-1">Emitting ES6 and Enhanced JavaScript Interop <a href="https://melange.re/blog/feed.rss#emitting-es6-and-enhanced-javascript-interop" class="header-anchor" aria-label="Permalink to &quot;Emitting ES6 and Enhanced JavaScript Interop&quot;"></a></h2>
<p>In this release, Melange starts emitting ES6, particularly:</p>
<ul>
<li>Melange 4.0 emits <code>let</code> instead of <code>var</code>, and <code>const</code> where possible
(<a href="https://github.com/melange-re/melange/pull/1019" target="_blank" rel="noreferrer">#1019</a>,
<a href="https://github.com/melange-re/melange/pull/1059" target="_blank" rel="noreferrer">#1059</a>).</li>
<li>Emitting <code>let</code> allowed us to remove a bit of legacy code related to compiling
<code>for</code> loops, taking advantage of <code>let</code>'s lexical scoping.
(<a href="https://github.com/melange-re/melange/pull/1020" target="_blank" rel="noreferrer">#1020</a>)</li>
</ul>
<p>In our effort to expand the API surface area for JavaScript interoperability,
we've added new bindings to a few more JavaScript features in the <code>melange.js</code>
library (whose main entrypoint is the <code>Js</code> module):</p>
<ul>
<li><strong>Js.Bigint</strong>: <a href="https://github.com/melange-re/melange/pull/1044" target="_blank" rel="noreferrer">#1044</a> added
bindings to work with <code>BigInt</code>;</li>
<li>The <strong>Js.Set</strong> and <strong>Js.Map</strong> modules now bind to even more methods available
in these JavaScript data structures
(<a href="https://github.com/melange-re/melange/pull/1047" target="_blank" rel="noreferrer">#1047</a>,
<a href="https://github.com/melange-re/melange/pull/1101" target="_blank" rel="noreferrer">#1101</a>).</li>
<li><strong>JS Iterators</strong>: We introduced minimal bindings for JavaScript iterators,
making it easier to work with iterable objects, which some other modules'
methods can now return
(<a href="https://github.com/melange-re/melange/pull/1060" target="_blank" rel="noreferrer">#1060</a>).</li>
<li><strong>WeakMap and WeakSet</strong>: Bindings for these weakly referenced collections
have also been added
(<a href="https://github.com/melange-re/melange/pull/1058" target="_blank" rel="noreferrer">#1058</a>).</li>
</ul>
<h2 tabindex="-1">Improved Error Handling and Code Generation <a href="https://melange.re/blog/feed.rss#improved-error-handling-and-code-generation" class="header-anchor" aria-label="Permalink to &quot;Improved Error Handling and Code Generation&quot;"></a></h2>
<p>In this release, we've also made significant improvements in how Melange
handles errors and generates JavaScript code:</p>
<ul>
<li>Instead of throwing JavaScript objects with Melange exception payloads, we
now emit a Melange-specific error (<code>throw new MelangeError(..)</code>) for more
consistent error handling
(<a href="https://github.com/melange-re/melange/pull/1036" target="_blank" rel="noreferrer">#1036</a>).
<ul>
<li>An interesting corollary to this change is that catching Melange errors
from external JavaScript only needs to check <code>instanceof MelangeError</code>.</li>
</ul>
</li>
</ul>
<h2 tabindex="-1">Additional Fixes &amp; Enhancements <a href="https://melange.re/blog/feed.rss#additional-fixes-enhancements" class="header-anchor" aria-label="Permalink to &quot;Additional Fixes &amp; Enhancements&quot;"></a></h2>
<ul>
<li><strong>Slimmer Executable</strong>: We've removed unnecessary internal code from
<code>melange-compiler-libs</code>, making the Melange compiled executable smaller in
size and faster to build
(<a href="https://github.com/melange-re/melange/pull/1075" target="_blank" rel="noreferrer">#1075</a>).</li>
<li><strong>Float Operations</strong>: Fixed runtime primitives for <code>Float.{min,max}</code> and
related functions, ensuring more accurate mathematical operations
(<a href="https://github.com/melange-re/melange/pull/1050" target="_blank" rel="noreferrer">#1050</a>).</li>
<li><strong>Warning 51 (<code>wrong-tailcall-expectation</code>)</strong>: Melange 4 ships with support
for enabling warning 51 and triggering the warning when
<a href="https://ocaml.org/manual/5.2/attributes.html#ss:builtin-attributes" target="_blank" rel="noreferrer"><code>[@tailcall]</code></a>
is used (<a href="https://github.com/melange-re/melange/pull/1075" target="_blank" rel="noreferrer">#1075</a>).</li>
</ul>
<h2 tabindex="-1">Conclusion <a href="https://melange.re/blog/feed.rss#conclusion" class="header-anchor" aria-label="Permalink to &quot;Conclusion&quot;"></a></h2>
<p>The <a href="https://github.com/melange-re/melange/blob/main/Changes.md#400-2024-05-15" target="_blank" rel="noreferrer">Melange 4.0
changelog</a>
lists all the changes that made it to this release.</p>
<p>Thanks for reading and stay tuned for more updates. Happy hacking!</p>

