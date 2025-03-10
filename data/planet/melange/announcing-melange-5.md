---
title: Announcing Melange 5
description:
url: https://melange.re/blog/posts/announcing-melange-5
date: 2025-03-05T00:00:00-00:00
preview_image:
authors:
- Melange Blog
source:
---

<p>We are excited to announce the release of Melange 5, the compiler for OCaml
that targets JavaScript.</p>
<p>A lot of goodies went into this release! While our focus was mostly on features
that make it easy to express more JavaScript constructs and supporting OCaml
5.3, we also managed to fit additional improvements in the release: better
editor support for Melange <code>external</code>s, code generation improvements, and
better compiler output for generated JS. The most notable feature we're
shipping in Melange 5 is support for JavaScript's <a href="https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/import" target="_blank" rel="noreferrer">dynamic
<code>import()</code></a>,
which we'll describe in detail below.</p>
<p>Read on for the highlights.</p>
<hr>
<h2 tabindex="-1">Dynamic <code>import()</code> without sacrificing type safety <a href="https://melange.re/blog/feed.rss#dynamic-import-without-sacrificing-type-safety" class="header-anchor" aria-label="Permalink to &quot;Dynamic `import()` without sacrificing type safety&quot;"></a></h2>
<p>Support for JavaScript's dynamic <code>import()</code> is probably what I'm most excited
about in this Melange release. In Melange 5, we're releasing support for
JavaScript's <code>import()</code> via a new function in <code>melange.js</code>, <code>Js.import: 'a -&gt; 'a promise</code>. I gave a small preview of dynamic <code>import()</code> during my <a href="https://www.youtube.com/watch?v=3oCXT-ycHHs" target="_blank" rel="noreferrer">Melange
talk</a> at <a href="https://fun-ocaml.com" target="_blank" rel="noreferrer">Fun OCaml
2024</a>.</p>
<p><code>Js.import</code> is <strong>type-safe</strong> and <strong>build system-compatible</strong>. Let's break it
down:</p>
<ol>
<li><strong>build system-compatible</strong>: dynamic <code>import()</code>s in Melange work with Dune
out of the box: as usual, you must specify your <code>(library ..)</code> dependencies
in the <code>dune</code> file. At compile time, Melange will be aware of the
dynamically imported module locations to emit the arguments to
<code>import("/path/to/module.js)</code> automatically.</li>
<li><strong>type-safe</strong>: your OCaml code is still aware of its dependencies at
compile-time, but Melange will skip emitting static JavaScript <code>import ..</code>
declarations if the values are exclusively used through <code>Js.import(..)</code>.</li>
</ol>
<h3 tabindex="-1">Dynamically importing OCaml code <a href="https://melange.re/blog/feed.rss#dynamically-importing-ocaml-code" class="header-anchor" aria-label="Permalink to &quot;Dynamically importing OCaml code&quot;"></a></h3>
<p>The example below makes it clear: we import the entire <code>Stdlib.Int</code> module,
specify its type signature, and observe that no static <code>import</code>s appear in the
resulting JavaScript:</p>
<div class="language-js vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">js</span><pre class="shiki shiki-themes github-light github-dark vp-code" v-pre=""><code><span class="line"><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D">// dynamic_import_int.re</span></span>
<span class="line"></span>
<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583">module</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0"> type</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0"> int</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> = (</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">module</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0"> type</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0"> of</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0"> Int</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">);</span></span>
<span class="line"></span>
<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583">let</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> _</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583">:</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0"> Js</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">Promise</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">t</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">(</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">unit</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583">=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> {</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">  Js.import((module Stdlib.Int): (</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF">module</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> int))</span></span>
<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583">  |&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> Js.Promise.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">then_</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">((</span><span style="--shiki-light:#E36209;--shiki-dark:#FFAB70">module</span><span style="--shiki-light:#E36209;--shiki-dark:#FFAB70"> Int</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583">:</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0"> int</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583">=&gt;</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">      Js.Promise.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">resolve</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">(Js.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">log</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">(Int.max))</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">  );</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">};</span></span></code></pre>
</div><div class="language-js vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">js</span><pre class="shiki shiki-themes github-light github-dark vp-code" v-pre=""><code><span class="line"><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D">// dynamic_import_int.js</span></span>
<span class="line"></span>
<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583">import</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF">"melange/int.js"</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">).</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">then</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">(</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583">function</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> (</span><span style="--shiki-light:#E36209;--shiki-dark:#FFAB70">Int</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">) {</span></span>
<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583">  return</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF"> Promise</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">resolve</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">((console.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">log</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">(Int.max), </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF">undefined</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">));</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">});</span></span></code></pre>
</div><h3 tabindex="-1">Dynamically importing JavaScript from OCaml <a href="https://melange.re/blog/feed.rss#dynamically-importing-javascript-from-ocaml" class="header-anchor" aria-label="Permalink to &quot;Dynamically importing JavaScript from OCaml&quot;"></a></h3>
<p>One of Melange's primary operating principles is the ability to support
seamless interop with JavaScript constructs. As such, we implemented <code>import()</code>
in a way that also allows importing JS modules dynamically: you can call
<code>Js.import</code> on JavaScript values declared with <code>external</code>. The abstractions
compose nicely to produce the expected result. Check out this example of
dynamically importing <code>React.useEffect</code>:</p>
<div class="language-js vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">js</span><pre class="shiki shiki-themes github-light github-dark vp-code" v-pre=""><code><span class="line"><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D">// dynamically_imported_useEffect.re</span></span>
<span class="line"></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">[@mel.module </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF">"react"</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">]</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">external </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">useEffect</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">:</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">([@</span><span style="--shiki-light:#E36209;--shiki-dark:#FFAB70">mel</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">.</span><span style="--shiki-light:#E36209;--shiki-dark:#FFAB70">uncurry</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">] (</span><span style="--shiki-light:#E36209;--shiki-dark:#FFAB70">unit</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583"> =&gt;</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0"> option</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">(</span><span style="--shiki-light:#E36209;--shiki-dark:#FFAB70">unit</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583"> =&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> unit))) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> unit </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583">=</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF"> "useEffect"</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">;</span></span>
<span class="line"></span>
<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583">let</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> dynamicallyImportedUseEffect </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583">=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> Js.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">import</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">(useEffect);</span></span></code></pre>
</div><p>And the JS output:</p>
<div class="language-js vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">js</span><pre class="shiki shiki-themes github-light github-dark vp-code" v-pre=""><code><span class="line"><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D">// dynamically_imported_useEffect.js</span></span>
<span class="line"></span>
<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583">const</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF"> dynamicallyImportedUseEffect</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583"> =</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583"> import</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF">"react"</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">).</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">then</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">(</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583">function</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> (</span><span style="--shiki-light:#E36209;--shiki-dark:#FFAB70">m</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">) {</span></span>
<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583">  return</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> m.useEffect;</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">});</span></span>
<span class="line"></span>
<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583">export</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> {</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">  dynamicallyImportedUseEffect,</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">}</span></span></code></pre>
</div><h2 tabindex="-1">Discriminated unions support: <code>@mel.as</code> in variants <a href="https://melange.re/blog/feed.rss#discriminated-unions-support-mel-as-in-variants" class="header-anchor" aria-label="Permalink to &quot;Discriminated unions support: `@mel.as` in variants&quot;"></a></h2>
<p>This release of Melange includes a major feature that improves the compilation
of variants, including really good support for representing <a href="https://www.typescriptlang.org/docs/handbook/typescript-in-5-minutes-func.html#discriminated-unions" target="_blank" rel="noreferrer">discriminated
unions</a>,
a common pattern to represent polymorphic objects with a discriminator in
JavaScript/TypeScript.</p>
<p>In <a href="https://github.com/melange-re/melange/pull/1189" target="_blank" rel="noreferrer">melange-re/melange#1189</a>,
we introduced support for 2 attributes in OCaml types that define variants:</p>
<h3 tabindex="-1"><code>@mel.as</code> <a href="https://melange.re/blog/feed.rss#mel-as" class="header-anchor" aria-label="Permalink to &quot;`@mel.as`&quot;"></a></h3>
<p>Specifying <code>[@mel.as ".."]</code> changes the variant emission in JavaScript to that
string value.</p>
<div class="language-js vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">js</span><pre class="shiki shiki-themes github-light github-dark vp-code" v-pre=""><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583">type</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0"> t</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583"> =</span></span>
<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583">  |</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> [@</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">mel</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">as</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF"> "World"</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">] </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">Hello</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">;</span></span>
<span class="line"></span>
<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583">let</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> t </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583">=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> Hello</span></span></code></pre>
</div><div class="language-js vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">js</span><pre class="shiki shiki-themes github-light github-dark vp-code" v-pre=""><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583">const</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF"> t</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583"> =</span><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D"> /* Hello */</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF"> "World"</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">;</span></span></code></pre>
</div><h3 tabindex="-1"><code>@mel.tag</code> <a href="https://melange.re/blog/feed.rss#mel-tag" class="header-anchor" aria-label="Permalink to &quot;`@mel.tag`&quot;"></a></h3>
<p>A <code>@mel.as</code> variant type combined with <code>@mel.tag</code> allows expressing
discriminated unions in an unobtrusive way:</p>
<div class="language-js vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">js</span><pre class="shiki shiki-themes github-light github-dark vp-code" v-pre=""><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">[@mel.tag </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF">"kind"</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">]</span></span>
<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583">type</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0"> t</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583"> =</span></span>
<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583">  |</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> [@</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">mel</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">as</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF"> "Foo"</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">] </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">Foo</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">({ </span><span style="--shiki-light:#E36209;--shiki-dark:#FFAB70">a</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583">:</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF"> string</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">, </span><span style="--shiki-light:#E36209;--shiki-dark:#FFAB70">b</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583">:</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF"> string</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">, })</span></span>
<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583">  |</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> [@</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">mel</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">.</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">as</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF"> "Bar"</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">] </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">Bar</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">({ </span><span style="--shiki-light:#E36209;--shiki-dark:#FFAB70">c</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583">:</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF"> string</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">, </span><span style="--shiki-light:#E36209;--shiki-dark:#FFAB70">d</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583">:</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF"> string</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">, });</span></span>
<span class="line"></span>
<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583">let</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> x </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583">=</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0"> Foo</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">({ a: </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF">"a"</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">, b: </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF">"b"</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">, });</span></span>
<span class="line"></span>
<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583">let</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> y </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583">=</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0"> Bar</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">({ c: </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF">"c"</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">, d: </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF">"d"</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">, });</span></span></code></pre>
</div><p>The Reason code above produces the following JavaScript:</p>
<div class="language-js vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">js</span><pre class="shiki shiki-themes github-light github-dark vp-code" v-pre=""><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583">const</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF"> x</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583"> =</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> {</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">  kind: </span><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D">/* Foo */</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF"> "Foo"</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">,</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">  a: </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF">"a"</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">,</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">  b: </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF">"b"</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">};</span></span>
<span class="line"></span>
<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583">const</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF"> y</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583"> =</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> {</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">  kind: </span><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D">/* Bar */</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF"> "Bar"</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">,</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">  c: </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF">"c"</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">,</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">  d: </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF">"d"</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">};</span></span></code></pre>
</div><p>In summary:</p>
<ul>
<li><code>[@mel.tag "kind"]</code> specifies that each variant containing a payload should
be tagged with <code>"kind"</code>.</li>
<li>the <code>[@mel.as ".."]</code> attribute in each variant type specifies what that
payload should be for each branch of the variant type.</li>
</ul>
<h2 tabindex="-1"><code>@mel.send</code> is way, way better <a href="https://melange.re/blog/feed.rss#mel-send-is-way-way-better" class="header-anchor" aria-label="Permalink to &quot;`@mel.send` is way, way better&quot;"></a></h2>
<p>When binding to methods of an object in JavaScript, Melange has historically
supported 2 different ways of achieving the same: <code>@mel.send</code> and
<code>@mel.send.pipe</code>. The only real reason why 2 constructs existed to do the same
was to support two alternatives for chaining them in OCaml:
<a href="https://melange.re/v5.0.0/language-concepts.html#pipe-first" target="_blank" rel="noreferrer">pipe-first</a> and
<a href="https://melange.re/v5.0.0/language-concepts.html#pipe-last" target="_blank" rel="noreferrer">pipe-last</a>. But
this always felt like an afterthought, and code using <code>@mel.send.pipe</code> never
felt intuitive to look at (e.g. in <code>external say: unit [@mel.send.pipe: t]</code>,
one had to mentally place the <code>t</code> before <code>unit</code>, since the real signature is <code>t -&gt; unit</code>).</p>
<p>In Melange 5, we wanted to remove this weird split and further reduce the
cognitive overhead of writing bindings to call JavaScript methods on an object
or instance.</p>
<p>We're introducing a way to mark the "self" instance argument with
<code>@mel.this</code> and recommending only the use of <code>@mel.send</code> going forward.
Starting from this release, <code>@mel.send.pipe</code> has been deprecated, and will be
removed in the next major release of Melange. Here's an example:</p>
<div class="language-js vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">js</span><pre class="shiki shiki-themes github-light github-dark vp-code" v-pre=""><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">[@mel.send]</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">external </span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">push</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">: (</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583">~</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">value: </span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF">'a=?, [@mel.this] array('</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">a)) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583">=&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> unit </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583">=</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF"> "push"</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">;</span></span>
<span class="line"></span>
<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583">let</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> () </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583">=</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0"> push</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">([</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583">||</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">], </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583">~</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">value</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF">3</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">);</span></span></code></pre>
</div><p>The code above marks the <code>array('a)</code> argument as the instance to call the
<code>push</code> method, which produces the following JavaScript:</p>
<div class="language-js vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">js</span><pre class="shiki shiki-themes github-light github-dark vp-code" v-pre=""><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">[].</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">push</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">(</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF">3</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">);</span></span></code></pre>
</div><p>Besides being more versatile, having an explicit marker with <code>@mel.this</code> is
also more visually intuitive: when scanning Melange code containing <code>external</code>
bindings, it becomes easier to spot which is the "this" argument. This feature
is fully backwards compatible with <code>@mel.send</code>: in the absence of <code>@mel.this</code>,
the instance argument defaults to the first one declared in the signature, as
previously supported.</p>
<h2 tabindex="-1">Additional quality of life improvements <a href="https://melange.re/blog/feed.rss#additional-quality-of-life-improvements" class="header-anchor" aria-label="Permalink to &quot;Additional quality of life improvements&quot;"></a></h2>
<h3 tabindex="-1">OCaml 5.3 Compatibility / Stdlib Upgrade <a href="https://melange.re/blog/feed.rss#ocaml-5-3-compatibility-stdlib-upgrade" class="header-anchor" aria-label="Permalink to &quot;OCaml 5.3 Compatibility / Stdlib Upgrade&quot;"></a></h3>
<p>Since <a href="https://anmonteiro.com/2021/03/on-ocaml-and-the-js-platform/" target="_blank" rel="noreferrer">Melange's
inception</a>, one
of its goals has been to keep it up to date with the latest OCaml releases.
<a href="https://github.com/melange-re/melange/releases/download/5.0.1-53/melange-5.0.1-53.tbz" target="_blank" rel="noreferrer">This
release</a>
brings Melange up to speed with OCaml 5.3, including upgrades to the <code>Stdlib</code>
library as well. We're also releasing Melange 5 for OCaml
<a href="https://github.com/melange-re/melange/releases/download/5.0.1-414/melange-5.0.1-414.tbz" target="_blank" rel="noreferrer">4.14</a>,
<a href="https://github.com/melange-re/melange/releases/download/5.0.1-51/melange-5.0.1-51.tbz" target="_blank" rel="noreferrer">5.1</a>
and
<a href="https://github.com/melange-re/melange/releases/download/5.0.1-52/melange-5.0.1-52.tbz" target="_blank" rel="noreferrer">5.2</a>.</p>
<h3 tabindex="-1">Melange runtime NPM packages <a href="https://melange.re/blog/feed.rss#melange-runtime-npm-packages" class="header-anchor" aria-label="Permalink to &quot;Melange runtime NPM packages&quot;"></a></h3>
<p>Starting from this release, we're shipping NPM packages with the precompiled
Melange runtime. This feature, requested by a few users in
<a href="https://github.com/melange-re/melange/issues/620" target="_blank" rel="noreferrer">melange#620</a> allows to use
Melange without compiling its own runtime and stdlib (essentially, in
combination with <code>(emit_stdlib false)</code> in <code>(melange.emit ..)</code>).</p>
<p>This can be useful in monorepos that compile multiple Melange applications but,
perhaps most importantly, it enables Melange libraries and packages to also
be published in NPM without the weight of the full runtime / stdlib.</p>
<h3 tabindex="-1">Better editor support for Melange <code>external</code>s <a href="https://melange.re/blog/feed.rss#better-editor-support-for-melange-externals" class="header-anchor" aria-label="Permalink to &quot;Better editor support for Melange `external`s&quot;"></a></h3>
<p>Melange bindings to JavaScript, specified through <code>external</code> declarations, used
to propagate internal information in the <a href="https://ocaml.org/manual/5.3/intfc.html#external-declaration" target="_blank" rel="noreferrer">native
payload</a>. In
practice, hovering over one of these in your editor could end up looking a bit
weird:</p>
<p><img src="https://melange.re/externals-before.png" alt=""></p>
<p>Since
<a href="https://github.com/melange-re/melange/pull/1222" target="_blank" rel="noreferrer">melange-re/melange#1222</a>,
Melange now propagates this information via internal attributes that only the
Melange compiler recognizes. These don't show up when hovering over
declarations in editors, making the resulting output much less jarring to look
at:</p>
<p><img src="https://melange.re/externals-after.png" alt=""></p>
<h3 tabindex="-1">Prettified JavaScript Output <a href="https://melange.re/blog/feed.rss#prettified-javascript-output" class="header-anchor" aria-label="Permalink to &quot;Prettified JavaScript Output&quot;"></a></h3>
<p>In Melange 5, we modernized the JavaScript emitter to produce cleaner, more
readable, and better-indented code. Melange 5 generated JS looks remarkably
closer to hand-written JavaScript, with this release enhancing that quality
even further.</p>
<h2 tabindex="-1">Conclusion <a href="https://melange.re/blog/feed.rss#conclusion" class="header-anchor" aria-label="Permalink to &quot;Conclusion&quot;"></a></h2>
<p>Melange 5 crosses a major milestone for JavaScript expressivity, bringing great
features like idiomatic dynamic <code>import()</code>s and support for discriminated
unions. Compatibility with OCaml 5.3 marks Melange's commitment to parity with
the latest OCaml versions. In this latest version, Melange raises the bar for
increasingly prettier JavaScript prettification, and the Melange precompiled
runtime starts to be available on NPM.</p>
<p>Check out the <a href="https://github.com/melange-re/melange/blob/main/Changes.md#500-53-2025-02-09" target="_blank" rel="noreferrer">full
changelog</a>
for detailed information on all the changes that made it into this release. If
you find any issues or have questions, feel free to open an issue on our
<a href="https://github.com/melange-re/melange/issues" target="_blank" rel="noreferrer">GitHub issue tracker</a>.</p>
<p>This release was sponsored by the generous support of
<a href="https://ahrefs.com/" target="_blank" rel="noreferrer">Ahrefs</a> and the <a href="https://ocaml-sf.org/" target="_blank" rel="noreferrer">OCaml Software
Foundation</a>.</p>

