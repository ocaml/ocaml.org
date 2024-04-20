---
title: A Preview of Universal Libraries in Dune
description:
url: https://melange.re/blog/posts/dune-universal-libraries-preview
date: 2024-04-10T00:00:00-00:00
preview_image:
featured:
authors:
- Melange Blog
source:
---

<p>I recently shared a <a href="https://melange.re/blog/whats-2024-brought-to-melange-so-far.html">2024 progress
update</a> about our work on Melange. In
that message, I briefly wrote about &quot;universal libraries&quot; in Dune, the ability
to write a shared OCaml / Melange codebase while varying specific module
implementations, flags, preprocessing steps, etc. according to the compilation
target.</p>
<p>I also promised to dive deeper into what &quot;universal libraries&quot; are all about,
and the new use cases that they unlock in Dune. Keep reading for an in-depth
look at the history behind this new feature rolling out in Dune 3.16.</p>
<hr/>
<h2 tabindex="-1">The Bird's-eye View <a href="https://melange.re/blog/feed.rss#the-bird-s-eye-view" class="header-anchor" aria-label="Permalink to &quot;The Bird's-eye View&quot;"></a></h2>
<p>Let's walk backwards from our end-goal: having a shared OCaml / Melange
codebase that can render React.js components on the server, such that the
<a href="https://ahrefs.com" target="_blank" rel="noreferrer">Ahrefs</a> website can be rendered on the server without
JavaScript. And, finally, having React.js hydrate the server-rendered HTML in
the browser. <a href="https://twitter.com/davesnx" target="_blank" rel="noreferrer">Dave</a> explains the motivation behind
this goal in more depth <a href="https://sancho.dev/blog/server-side-rendering-react-in-ocaml" target="_blank" rel="noreferrer">in his blog
</a>.</p>
<p>To look at a specific example, we'll start with a Melange codebase already
using <a href="https://github.com/reasonml/reason-react" target="_blank" rel="noreferrer"><code>reason-react</code></a>. Our goal is
to get those <code>reason-react</code> components to compile server-side with the OCaml
compiler, where we'll use
<a href="https://github.com/ml-in-barcelona/server-reason-react" target="_blank" rel="noreferrer"><code>server-reason-react</code></a>
as a drop-in replacement for <code>reason-react</code>.</p>
<p>What gets in our way is that:</p>
<ul>
<li>not everything is supported on both sides: some Melange modules use APIs that
don't exist in OCaml (and extensive shimming is undesirable).
<ul>
<li>vice-versa on the Melange side; especially code that calls into C bindings.</li>
</ul>
</li>
<li>we can't choose what implementation to use inside a module or conditionally
apply different preprocessing steps and/or flags.</li>
</ul>
<p>In summary, we would like to vary specific module implementations across the
same library, based on their compilation target. If we try to use it in a
real-world codebase, we'll also find the need to specify different
preprocessing definitions, compilation flags, the set of modules belonging to
the library &ndash; effectively most fields in the <code>(library ..)</code> stanza.</p>
<h2 tabindex="-1">A First <s>Hack</s> Approach <a href="https://melange.re/blog/feed.rss#a-first-hack-approach" class="header-anchor" aria-label="Permalink to &quot;A First ~~Hack~~ Approach&quot;"></a></h2>
<p>We concluded that it would be desirable to write two library definitions. That
would allow us to configure each <code>(library ..)</code> stanza field separately,
achieving our goal.</p>
<p>But Dune doesn't allow you to have two libraries with the same name. How could
it? If Dune derives the artifact directory for libraries from their <code>(name ..)</code>
field, two conflicting names compete for the same artifact directory.</p>
<p>So we first tried to work around that, and set up:</p>
<ul>
<li>unwrapped (<code>(wrapped false)</code>) Dune libraries with different names
<ul>
<li>with unwrapped libraries, we could share modules across compilation
targets, e.g. <code>react.ml</code> originating from both <code>reason-react</code> and
<code>server-reason-react</code>;</li>
</ul>
</li>
<li>defined in different directories;</li>
<li><code>(copy_files ..)</code> from one of the directories into the other, duplicating
shared modules.
<ul>
<li>Modules with the same name and different implementations, specific to
each directory.</li>
</ul>
</li>
</ul>
<div class="language-clj vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">clj</span><pre class="shiki shiki-themes github-light github-dark vp-code" v-pre=""><code><span class="line"><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D">;; native/dune</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">(</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">library</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> (</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">name</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> native_lib)</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> (</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">wrapped</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF"> false</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">)</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> (</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">modules</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> a b c))</span></span>
<span class="line"></span>
<span class="line"><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D">;; melange/dune</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">(</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">library</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> (</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">name</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> melange_lib)</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> (</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">wrapped</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF"> false</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">)</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> (</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">modes</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> melange)</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> (</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">modules</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> a b c))</span></span>
<span class="line"></span>
<span class="line"><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D">;; Copy modules `A` and `B` from `../native`</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">(</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">copy_files#</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> ../native</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> (</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">files</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> {a,b}.ml{,i}))</span></span>
<span class="line"></span>
<span class="line"><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D">;; module `C` has a specific Melange implementation</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">(</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">rule</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> (</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">with-stdout-to</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> c.ml</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">  (</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">echo</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF"> &quot;let backend = </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF">\&quot;</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF">melange</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF">\&quot;</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF">&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">)))</span></span></code></pre>
</div><p>This worked until it didn't: we quickly ran into a limitation in <code>(copy_files ..)</code> (<a href="https://github.com/ocaml/dune/issues/9709" target="_blank" rel="noreferrer">dune#9709</a>). Because this
stanza operates in the build directory, it was impossible to exclude some of
build artifacts that get generated with <code>.ml{,i}</code> extensions from the copy glob
&ndash; Dune uses extensions such as <code>.pp.ml</code> and <code>.re.pp.ml</code> as targets of its
<a href="https://dune.readthedocs.io/en/stable/overview.html#term-dialect" target="_blank" rel="noreferrer">dialect</a> and
<a href="https://dune.readthedocs.io/en/stable/reference/preprocessing-spec.html" target="_blank" rel="noreferrer">preprocessing</a>
phases.</p>
<h2 tabindex="-1">Limiting <code>(copy_files ..)</code> to source-files only <a href="https://melange.re/blog/feed.rss#limiting-copy-files-to-source-files-only" class="header-anchor" aria-label="Permalink to &quot;Limiting `(copy_files ..)` to source-files only&quot;"></a></h2>
<p>What we would want from <code>copy_files</code> in our scenario is the ability to limit
copying only to files that are present in source. That way we can address all
the <code>.re{,i}</code> and <code>.ml{,i}</code> files in source directories without worrying about
polluting our target directories with some intermediate Dune targets.</p>
<p>In <a href="https://github.com/ocaml/dune/pull/9827" target="_blank" rel="noreferrer">dune#9827</a>, we added a new option
to <code>copy_files</code> that allows precisely that: if the field <code>(only_sources &lt;optional_boolean_language&gt;)</code> is present, Dune will only match files in the
source directory, and won't apply the glob to the targets of rules.</p>
<p>After this change, our Dune file just needs to contemplate one more line:</p>
<div class="language-diff vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">diff</span><pre class="shiki shiki-themes github-light github-dark vp-code" v-pre=""><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> ;; Copy modules `A` and `B` from `../native`</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> (copy_files# ../native</span></span>
<span class="line"><span style="--shiki-light:#22863A;--shiki-dark:#85E89D">+ (only_sources)</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">  (files {a,b}.ml{,i}))</span></span></code></pre>
</div><h2 tabindex="-1">Checkpoint <a href="https://melange.re/blog/feed.rss#checkpoint" class="header-anchor" aria-label="Permalink to &quot;Checkpoint&quot;"></a></h2>
<p>Our Dune file allows us to move forward. We were now able to define multiple
libraries that share common implementations across native code and Melange.
Though library names still need to be different. And, overall, we still face
some other glaring limitations:</p>
<ul>
<li>The <code>(wrapped false)</code> requirement makes it impossible to namespace these
libraries;</li>
<li>Defining libraries in different directories and using <code>copy_files</code> places
extra separation between common implementations, and adds extra build
configuration overhead;</li>
<li>Publishing a library with <code>(modes :standard melange)</code> adds a non-optional
dependency on Melange, which should really be optional for native-only
consumers.</li>
<li>Extensive usage of <code>(copy_files ..)</code> as shared in the example above breaks
editor integration and &quot;jump to definition&quot;; Merlin and OCaml-LSP don't track
the original source in this scenario.</li>
</ul>
<h2 tabindex="-1">Testing a New Solution <a href="https://melange.re/blog/feed.rss#testing-a-new-solution" class="header-anchor" aria-label="Permalink to &quot;Testing a New Solution&quot;"></a></h2>
<p>We became intentful on removing these limitations, and realized at some point
that our use case is somewhat similar to cross-compilation, which Dune <a href="https://dune.readthedocs.io/en/stable/cross-compilation.html" target="_blank" rel="noreferrer">already
supports well</a>.
The key insight, which we shared in a Dune proposal
(<a href="https://github.com/ocaml/dune/issues/10222" target="_blank" rel="noreferrer">dune#10222</a>), is that we could
share library names as long as they resolved to a single library per <a href="https://dune.readthedocs.io/en/stable/reference/dune-workspace/context.html" target="_blank" rel="noreferrer">build
context</a>.</p>
<p>After making the proposed changes to Dune
(<a href="https://github.com/ocaml/dune/pull/10220" target="_blank" rel="noreferrer">dune#10220</a>,
<a href="https://github.com/ocaml/dune/pull/10307" target="_blank" rel="noreferrer">dune#10307</a>,
<a href="https://github.com/ocaml/dune/pull/10354" target="_blank" rel="noreferrer">dune#10354</a>,
<a href="https://github.com/ocaml/dune/pull/10355" target="_blank" rel="noreferrer">dune#10355</a>) we found ourselves
having implemented support for:</p>
<ul>
<li>Dune libraries with the same name;</li>
<li>which may be defined in the same directory;</li>
<li>as long as they don't conflict in the same context.
<ul>
<li>to achieve that, we use e.g. <code>(enabled_if (= %{context_name} melange))</code>.</li>
</ul>
</li>
</ul>
<p>Putting it all together, our example can be adapted to look like:</p>
<div class="language-clj vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">clj</span><pre class="shiki shiki-themes github-light github-dark vp-code" v-pre=""><code><span class="line"><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D">;; src/dune</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">(</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">library</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> (</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">name</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> a)</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> (</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">modules</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> a b c)</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> (</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">enabled_if</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">  (</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> %{context_name} </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583">default</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">)))</span></span>
<span class="line"></span>
<span class="line"><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D">;; can also be defined in src/dune(!)</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">(</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">library</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> (</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">name</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> a)</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> (</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">modes</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> melange)</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> (</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">modules</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> a b c)</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> (</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">enabled_if</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">  (</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> %{context_name} melange)))</span></span></code></pre>
</div><p>In other words, we define two libraries named <code>a</code>, each in their own build
context (with build artifacts ending up in <code>_build/default</code> and
<code>_build/melange</code>). In the <code>melange</code> context, the library has <code>(modes melange)</code>.</p>
<p>Both libraries contain modules <code>A</code>, <code>B</code> and <code>C</code> like before. Their
corresponding source files can live in a single directory, no copying required.
If we need to vary <code>C</code>'s implementation, we can express that in Dune rules:</p>
<div class="language-clj vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">clj</span><pre class="shiki shiki-themes github-light github-dark vp-code" v-pre=""><code><span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">(</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">rule</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> (</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">target</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> c.ml)</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> (</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">deps</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> c.native.ml)</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> (</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">action</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">  (</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">with-stdout-to</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">   %{target}</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">   (</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">echo</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF"> &quot;let backend = </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF">\&quot;</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF">OCaml</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF">\&quot;</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF">&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">)))</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> (</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">enabled_if</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">  (</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> %{context_name} </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583">default</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">)))</span></span>
<span class="line"></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">(</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">rule</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> (</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">target</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> c.ml)</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> (</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">deps</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> c.melange.ml)</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> (</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">action</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">  (</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">with-stdout-to</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">   %{target}</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">   (</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">echo</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF"> &quot;let backend = </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF">\&quot;</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF">Melange</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF">\&quot;</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF">&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">)))</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> (</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">enabled_if</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8">  (</span><span style="--shiki-light:#6F42C1;--shiki-dark:#B392F0">=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8"> %{context_name} melange)))</span></span></code></pre>
</div><p>In short, both libraries get a module <code>C</code>. <code>c.ml</code>'s contents vary according to
the build context. The example above is currently illustrative, even if
functional. We're still working on the developer experience of multi-context
libraries. This might not be the best setup for editor support, which we'll
find out as we take it for a spin.</p>
<h2 tabindex="-1">Missing Pieces <a href="https://melange.re/blog/feed.rss#missing-pieces" class="header-anchor" aria-label="Permalink to &quot;Missing Pieces&quot;"></a></h2>
<p>We proved that compiling libraries with the same name in different contexts can
work after migrating some of the libraries to the new configuration.</p>
<p>Before deploying such a major change at scale, we need to get the developer
experience right. To illustrate some examples:</p>
<ul>
<li><a href="https://github.com/ocaml/dune/pull/10324" target="_blank" rel="noreferrer">Dune</a> and
<a href="https://github.com/ocaml/ocaml-lsp/pull/1238" target="_blank" rel="noreferrer"><code>ocaml-lsp</code></a> must support
selecting the context to know where to look for compiled artifacts;</li>
<li>Editor plugins must have commands or configuration associating certain files
with their respective context;</li>
<li>Dune can do better to <a href="https://github.com/ocaml/dune/issues/10378" target="_blank" rel="noreferrer">show the
context</a> to which errors belong</li>
</ul>
<p>We will need some additional time to let all pieces fall in their right places
before we can start recommending compiling Melange code in a separate Dune
context. Before that happens, we wanted to share the problems we faced, how we
ended up lifting some interesting limitations in a composable way, and the new
constructs that will be available in Dune 3.16.</p>

