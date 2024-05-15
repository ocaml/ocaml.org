---
title: What's 2024 brought to Melange so far?
description:
url: https://melange.re/blog/posts/whats-2024-brought-to-melange-so-far
date: 2024-04-09T00:00:00-00:00
preview_image:
authors:
- Melange Blog
source:
---

<p>Last year we saw the <a href="https://anmonteiro.substack.com/p/melange-10-is-here" target="_blank" rel="noreferrer">first major
release</a> of Melange. Over
the course of 2023, what started as disjoint sets of tooling has gradually
evolved into a cohesive development experience within the <a href="https://ocaml.org/docs/platform" target="_blank" rel="noreferrer">OCaml
Platform</a>.</p>
<p>But we're not done yet. In the next few paragraphs, I'll tell you everything
we've shipped so far in the first 3 months of 2024.</p>
<hr/>
<h2 tabindex="-1">Releasing <a href="https://melange.re/blog/announcing-melange-3.html">Melange 3</a> <a href="https://melange.re/blog/feed.rss#releasing-melange-3" class="header-anchor" aria-label="Permalink to &quot;Releasing [Melange 3](./announcing-melange-3)&quot;"></a></h2>
<p>We released Melange 3.0 in February. This release mostly focused on addressing
long-standing deprecations, crashes, error messages and making the Melange
distribution leaner.</p>
<p>One highlight of the Melange 3 release is the support for more versions of
OCaml. Melange 3 supports OCaml 4.14 and 5.1; the next major release will
additionally feature support for OCaml 5.2.</p>
<p><a href="https://github.com/reasonml/reason-react" target="_blank" rel="noreferrer"><code>reason-react</code></a> and the Melange
libraries in <a href="https://github.com/melange-community" target="_blank" rel="noreferrer"><code>melange-community</code></a> were
also updated and released with support for this new Melange major version.</p>
<p>Melange 3 has been running in production at Ahrefs since its release. This is
the largest Melange codebase that we are aware of (on the scale of tens of
libraries with support for <code>(modes melange)</code> and <code>melange.emit</code> stanzas, across
dozens of apps).</p>
<h2 tabindex="-1">Emitting <a href="https://github.com/melange-re/melange/issues/134" target="_blank" rel="noreferrer">ES6</a> <a href="https://melange.re/blog/feed.rss#emitting-es6" class="header-anchor" aria-label="Permalink to &quot;Emitting [ES6](https://github.com/melange-re/melange/issues/134)&quot;"></a></h2>
<p>As the great majority of browsers <a href="https://caniuse.com/?search=es6." target="_blank" rel="noreferrer">supports ECMAScript 2015
(ES6)</a>, we decided to bump the version that
Melange targets. In
<a href="https://github.com/melange-re/melange/pull/1019" target="_blank" rel="noreferrer">melange#1019</a> and
<a href="https://github.com/melange-re/melange/pull/1059" target="_blank" rel="noreferrer">melange#1059</a> we changed the
emission of <code>var</code> to <code>let</code> (and <code>const</code>, where possible). <code>let</code>'s lexical scope
makes some closure allocations in <code>for</code> loops unnecessary, which we promptly
removed in <a href="https://github.com/melange-re/melange/pull/1020" target="_blank" rel="noreferrer">melange#1020</a>.
This change also results in a slight reduction of bundle size as Melange emits
a bit less code.</p>
<p>Starting to emit ES6 also unblocks working on
<a href="https://github.com/melange-re/melange/issues/342" target="_blank" rel="noreferrer">melange#342</a>, which requests
support for tagged <a href="https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals" target="_blank" rel="noreferrer">template
literals</a>.
We'll consider adding support for more features in ES6 and later on a
case-per-case basis, if the added expressivity justifies the complexity of the
implementation. Feel free to <a href="https://github.com/melange-re/melange/issues/new" target="_blank" rel="noreferrer">open an
issue</a> if you feel that
Melange should emit ES6 features that your project requires.</p>
<h2 tabindex="-1">Identifying Melange exceptions in JavaScript <a href="https://melange.re/blog/feed.rss#identifying-melange-exceptions-in-javascript" class="header-anchor" aria-label="Permalink to &quot;Identifying Melange exceptions in JavaScript&quot;"></a></h2>
<p>Until Melange 3, exceptions originating from OCaml code compiled with Melange
are roughly thrown as such:</p>
<div class="language-js vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">js</span><pre class="shiki shiki-themes github-light github-dark vp-code" v-pre=""><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583">throw</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> {</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">  MEL_EXN_ID: </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF">&quot;Assert_failure&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">,</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">  _1: [</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF">&quot;x.ml&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF">42</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF">8</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">],</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">  Error: </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583">new</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0"> Error</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">()</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">};</span></span></code></pre>
</div><p>As stated in an <a href="https://github.com/rescript-lang/rescript-compiler/issues/4506" target="_blank" rel="noreferrer">old ReScript
issue</a>, the
encoding above is at odds with user exception monitoring in popular vendors.</p>
<p>We set out to fix this for Melange 4. The next release of Melange includes
<a href="https://github.com/melange-re/melange/pull/1036" target="_blank" rel="noreferrer">melange#1036</a> and
<a href="https://github.com/melange-re/melange/pull/1043" target="_blank" rel="noreferrer">melange#1043</a>, where we
changed the encoding to throw a dedicated <code>MelangeError</code> instance:</p>
<div class="language-diff vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">diff</span><pre class="shiki shiki-themes github-light github-dark vp-code" v-pre=""><code><span class="line"><span style="--shiki-light:#B31D28;--shiki-dark:#FDAEB7">-throw {</span></span>
<span class="line"><span style="--shiki-light:#22863A;--shiki-dark:#85E89D">+throw new Caml_js_exceptions.MelangeError(&quot;Assert_failure&quot;, {</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">  MEL_EXN_ID: &quot;Assert_failure&quot;,</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">  _1: [&quot;x.ml&quot;, 42, 8],</span></span>
<span class="line"><span style="--shiki-light:#B31D28;--shiki-dark:#FDAEB7">- Error: new Error()</span></span>
<span class="line"><span style="--shiki-light:#B31D28;--shiki-dark:#FDAEB7">-};</span></span>
<span class="line"><span style="--shiki-light:#22863A;--shiki-dark:#85E89D">+});</span></span></code></pre>
</div><p>Besides fixing the immediate issue &ndash; vendor SDKs for error monitoring now
understand Melange runtime errors &ndash; this change brings a few additional
benefits to users of Melange:</p>
<ul>
<li>Detecting an exception originating from Melange-compiled code is now as easy
as using the JS <code>instanceof</code> operator to check if the exception is an
instance of <code>Caml_js_exceptions.MelangeError</code>.</li>
<li><code>MelangeError</code> adds support for &ndash; and polyfills, if necessary &ndash; the
<a href="https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Error/cause" target="_blank" rel="noreferrer"><code>cause</code></a>
property in instances of <code>Error</code>, which lets us squeeze out some extra
<a href="https://caniuse.com/mdn-javascript_builtins_error_cause" target="_blank" rel="noreferrer">browser support</a>.
<ul>
<li>Additionally, this enables even better integrations with 3rd party
monitoring tools, which will look for JavaScript error details in
<code>Error.prototype.cause</code>.</li>
</ul>
</li>
</ul>
<h2 tabindex="-1"><code>melange.js</code> keeps getting better <a href="https://melange.re/blog/feed.rss#melange-js-keeps-getting-better" class="header-anchor" aria-label="Permalink to &quot;`melange.js` keeps getting better&quot;"></a></h2>
<p>The <a href="https://melange.re/blog/announcing-melange-3.html#runtime-stdlib">Melange 3
announcement</a>
touched a bit on the improvements we did in the <code>Js.*</code> modules recently. We're
always trying to improve the number of zero-cost bindings to functions in the
JS runtime, and their quality. In next release, we're adding more functions to
cover <code>Map</code>, <code>Set</code>, <code>WeakMap</code>, <code>WeakSet</code>, <code>BigInt</code> and <code>Iterator</code>.</p>
<p>We're also taking advantage of Dune's obscure extension that models libraries
like the OCaml <code>Stdlib</code> (<code>(using experimental_building_ocaml_compiler_with_dune 0.1)</code> in <code>dune-project</code>, the <code>stdlib</code> field in <code>library</code> stanzas). Here's the
difference between a &quot;stdlib library&quot; and a regular library: a stdlib library's
main module depends on just a subset of the internal modules in the libraries,
while others depend on this main module. Dune doesn't allow regular library
modules to depend on their main module name.</p>
<p>In the next release of Melange, we treat the <code>Js.*</code> modules like a &quot;stdlib&quot;
library (<a href="https://github.com/melange-re/melange/pull/1091" target="_blank" rel="noreferrer">melange#1091</a>):
modules are only accessible through the <code>Js.*</code> namespace; as a fortunate
side-effect, we stop exposing <code>Js__Js_internal</code>, which could leak into some
error messages, causing unnecessary confusion.</p>
<h2 tabindex="-1">OCaml 5.2 <a href="https://melange.re/blog/feed.rss#ocaml-5-2" class="header-anchor" aria-label="Permalink to &quot;OCaml 5.2&quot;"></a></h2>
<p>With OCaml 5.2 around the corner (the first
<a href="https://github.com/ocaml/ocaml/archive/refs/tags/5.2.0-beta1.tar.gz" target="_blank" rel="noreferrer">beta</a>
was released just a couple weeks ago), we made Melange ready for the upcoming
release. In <a href="https://github.com/melange-re/melange/pull/1074" target="_blank" rel="noreferrer">melange#1074</a> and
<a href="https://github.com/melange-re/melange/pull/1078" target="_blank" rel="noreferrer">melange#1078</a> we upgraded
both the Melange core and the Stdlib to the changes in OCaml 5.2. As mentioned
above, we're happy that the next release of Melange will support an even wider
range of OCaml compiler versions, making 5.2 the latest addition to the
supported compiler versions.</p>
<h2 tabindex="-1">Leveraging Dune's potential <a href="https://melange.re/blog/feed.rss#leveraging-dune-s-potential" class="header-anchor" aria-label="Permalink to &quot;Leveraging Dune's potential&quot;"></a></h2>
<h3 tabindex="-1">Making Dune faster <a href="https://melange.re/blog/feed.rss#making-dune-faster" class="header-anchor" aria-label="Permalink to &quot;Making Dune faster&quot;"></a></h3>
<p>Back in January, <a href="https://twitter.com/javierwchavarri" target="_blank" rel="noreferrer">Javi</a> found a
performance regression in Dune
(<a href="https://github.com/ocaml/dune/issues/9738" target="_blank" rel="noreferrer">dune#9738</a>) after upgrading to
Dune 3.13. The whole fact-finding process of profiling Dune's performance and
working closely with the team to patch this regression
(<a href="https://github.com/ocaml/dune/pull/9769" target="_blank" rel="noreferrer">dune#9769</a>) ended up being quite the
learning experience.</p>
<p>Once the dust settled, Javi took the time to write a <a href="https://tech.ahrefs.com/profiling-dune-builds-a8de589ec268" target="_blank" rel="noreferrer">blog
post</a> outlining
some of the tools he used and the steps he used to gather information about
Dune's runtime behavior.</p>
<h3 tabindex="-1">Improving <code>dune describe pp</code> <a href="https://melange.re/blog/feed.rss#improving-dune-describe-pp" class="header-anchor" aria-label="Permalink to &quot;Improving `dune describe pp`&quot;"></a></h3>
<p>The command <code>dune describe pp</code> prints a given source file after preprocessing.
This is useful to quickly inspect the code generate by a (set of) ppx.</p>
<p><code>dune describe pp</code> didn't, however, support <a href="https://dune.readthedocs.io/en/stable/overview.html#term-dialect" target="_blank" rel="noreferrer">Dune
dialects</a>. I
<a href="https://github.com/ocaml/dune/issues/4470#issuecomment-1135120774" target="_blank" rel="noreferrer">found out</a>
about this limitation when trying to get the preprocessed output of a ReasonML
file.</p>
<p>We recently set out to fix this problem. In
<a href="https://github.com/ocaml/dune/pull/10321" target="_blank" rel="noreferrer">dune#10321</a> we made Reason files and
dialects generally work within <code>dune describe pp</code>, and we followed up with the
ability to print back the preprocessed output in the same dialect as the given
file (<a href="https://github.com/ocaml/dune/pull/10322" target="_blank" rel="noreferrer">dune#10322</a>,
<a href="https://github.com/ocaml/dune/pull/10339" target="_blank" rel="noreferrer">dune#10339</a> and
<a href="https://github.com/ocaml/dune/pull/10340" target="_blank" rel="noreferrer">dune#10340</a>).</p>
<h3 tabindex="-1"><a href="https://dune.readthedocs.io/en/stable/variants.html" target="_blank" rel="noreferrer">Virtual libraries</a> in Melange <a href="https://melange.re/blog/feed.rss#virtual-libraries-in-melange" class="header-anchor" aria-label="Permalink to &quot;[Virtual libraries](https://dune.readthedocs.io/en/stable/variants.html) in Melange&quot;"></a></h3>
<p>From Dune's own documentation:</p>
<blockquote>
<p>Virtual libraries correspond to Dune&rsquo;s ability to compile parameterised
libraries and delay the selection of concrete implementations until linking an
executable.</p>
</blockquote>
<p>In the Melange case there's no executable linking going on, but we can still
delay the selection of concrete implementations until JavaScript emission &ndash; in
practice, this means programming against the interface of &quot;virtual modules&quot; in
libraries and deferring the dependency on the concrete implementation until the
<code>melange.emit</code> stanza.</p>
<p>Or rather, this is <em>now</em> possible after landing
<a href="https://github.com/melange-re/melange/pull/1067" target="_blank" rel="noreferrer">melange#1067</a> and
<a href="https://github.com/ocaml/dune/pull/10051" target="_blank" rel="noreferrer">dune#10051</a>: in particular, while
Dune support for Melange has shipped with virtual libraries since day one, it
didn't support one of the most useful features that they provide: programming
against the interface of a virtual module.</p>
<h3 tabindex="-1">Melange rules work within the Dune sandbox <a href="https://melange.re/blog/feed.rss#melange-rules-work-within-the-dune-sandbox" class="header-anchor" aria-label="Permalink to &quot;Melange rules work within the Dune sandbox&quot;"></a></h3>
<p>Within the last month, we also fixed a bug where Dune didn't track all Melange
dependencies precisely during the JavaScript emission phase. While the
<a href="https://github.com/ocaml/dune/issues/9190" target="_blank" rel="noreferrer">originally reported issue</a> saw this
bug manifest when moving modules across directories when <code>(include_subdirs ..)</code>
is enabled, the fix we applied in
<a href="https://github.com/ocaml/dune/pull/10286" target="_blank" rel="noreferrer">dune#10286</a> and
<a href="https://github.com/ocaml/dune/pull/10297" target="_blank" rel="noreferrer">dune#10297</a> brings with it the
fortunate side-effect of making Melange rules work in the <a href="https://dune.readthedocs.io/en/stable/concepts/sandboxing.html" target="_blank" rel="noreferrer">Dune
sandbox</a>.
We're glad this issue is fixed since it could result in the <a href="https://dune.readthedocs.io/en/stable/caching.html" target="_blank" rel="noreferrer">Dune
Cache</a> being poisoned,
leading to very confusing results.</p>
<p>To make sure that sandboxing keeps working with Melange, we enabled it by
default in <a href="https://github.com/ocaml/dune/pull/10312" target="_blank" rel="noreferrer">dune#10312</a> for the
Melange tests in Dune.</p>
<h2 tabindex="-1">Towards Universal React in OCaml <a href="https://melange.re/blog/feed.rss#towards-universal-react-in-ocaml" class="header-anchor" aria-label="Permalink to &quot;Towards Universal React in OCaml&quot;"></a></h2>
<p>One of our goals for 2024 is to ship a good developer experience around
&quot;universal libraries&quot; in OCaml, the ability to write a mixed OCaml / Melange
codebase that shares most libraries and modules pertaining to DOM rendering
logic.</p>
<p><a href="https://twitter.com/davesnx" target="_blank" rel="noreferrer">Dave</a> wrote
<a href="https://github.com/ml-in-barcelona/server-reason-react" target="_blank" rel="noreferrer">server-reason-react</a>
for this purpose. He also wrote a <a href="https://sancho.dev/blog/server-side-rendering-react-in-ocaml" target="_blank" rel="noreferrer">post on his
blog</a> detailing
the motivation behind this approach and what he wants to achieve with
<code>server-reason-react</code>.</p>
<p>While React component hydration in native OCaml is a challenge specific to
Melange and React codebases, there are reusable primitives that we needed to
implement in Dune to make it possible. They also unlock a host of new use cases
for Dune that we expect will start getting adoption over time.</p>
<p>Universal libraries are already deployed for a small subset of apps at Ahrefs.
Javi wrote about how Ahrefs is <a href="https://tech.ahrefs.com/building-react-server-components-in-ocaml-81c276713f19" target="_blank" rel="noreferrer">sharing component
code</a>
for those apps.</p>
<p>This past quarter, we took it a step further. We added support in Dune for
libraries that share the same name, as long as they're defined in different
build contexts (<a href="https://github.com/ocaml/dune/issues/10222" target="_blank" rel="noreferrer">dune#10222</a>).
Support for libraries with the same name in multiple contexts landed in
<a href="https://github.com/ocaml/dune/pull/10307" target="_blank" rel="noreferrer">dune#10307</a>. We'll be diving deeper
into what led us to this solution and what it enables in a separate blog post.
For now, the remaining work relates to selecting which build context to use for
editor integration when using multi-context builds.</p>
<h2 tabindex="-1">Community at large <a href="https://melange.re/blog/feed.rss#community-at-large" class="header-anchor" aria-label="Permalink to &quot;Community at large&quot;"></a></h2>
<h3 tabindex="-1">Bootstrapping Melange projects with <code>create-melange-app</code> <a href="https://melange.re/blog/feed.rss#bootstrapping-melange-projects-with-create-melange-app" class="header-anchor" aria-label="Permalink to &quot;Bootstrapping Melange projects with `create-melange-app`&quot;"></a></h3>
<p>In January, <a href="https://twitter.com/dillon_mulroy" target="_blank" rel="noreferrer">Dillon</a> released v1.0 of
<a href="https://github.com/dmmulroy/create-melange-app" target="_blank" rel="noreferrer"><code>create-melange-app</code></a>, and
we're now recommending it for bootstrapping <a href="https://melange.re/v3.0.0/getting-started.html#getting-started-automated-create-melange-app" target="_blank" rel="noreferrer">new Melange
projects</a></p>
<p><code>create-melange-app</code> is a friendly and familiar way to get started with OCaml,
ReasonML, and Melange, geared towards JavaScript and TypeScript developers.</p>
<p><code>create-melange-app</code> quickly became a community favorite after its release,
attracting a number of contributors that are helping make it better.</p>
<h3 tabindex="-1">Melange Book <a href="https://melange.re/blog/feed.rss#melange-book" class="header-anchor" aria-label="Permalink to &quot;Melange Book&quot;"></a></h3>
<p><a href="https://twitter.com/feihonghsu" target="_blank" rel="noreferrer">Feihong</a> keeps making really good progress on
our book <a href="https://react-book.melange.re" target="_blank" rel="noreferrer">Melange for React Devs</a>, a
project-based introduction to Melange for React developers. The newest chapter
on <a href="https://dune.readthedocs.io/en/stable/tests.html#cram-tests" target="_blank" rel="noreferrer">Cram testing</a>
guides you through the necessary steps for writing tests and snapshotting their
output.</p>
<p>There are more chapters in the pipeline that we'll be releasing incrementally
as they're ready for consumption. We're also gathering feedback on the book; we
invite you to go through it and open issues in the <a href="https://github.com/melange-re/melange-for-react-devs" target="_blank" rel="noreferrer">GitHub
repository</a> for any
material that deserves rewording.</p>
<h2 tabindex="-1">Looking forward <a href="https://melange.re/blog/feed.rss#looking-forward" class="header-anchor" aria-label="Permalink to &quot;Looking forward&quot;"></a></h2>
<p>As we look forward, towards the next phase of Melange development, I'd like to
take a moment to thank <a href="https://ahrefs.com" target="_blank" rel="noreferrer">Ahrefs</a>, the <a href="https://ocaml-sf.org/" target="_blank" rel="noreferrer">OCaml Software
Foundation</a> and my <a href="https://github.com/sponsors/anmonteiro/" target="_blank" rel="noreferrer">GitHub
sponsors</a> for the funding and support,
without which developing Melange wouldn't have been possible over this
sustained period of time.</p>
<p>On a personal note, it fills me with joy to have the opportunity to share the
amazing work that Melange contributors have been putting in. It represents a
stark contrast from not long ago and the Melange project and community are
better for it. Thank you everyone!</p>
<p>As a final note, we thank you for reading through our updates for the first
three months of 2024! As we finish planning our work for the next period, we'll
share updates on what's to come for Melange in the not-so-distant future.</p>
<p>Until then, stay tuned and happy hacking!</p>

