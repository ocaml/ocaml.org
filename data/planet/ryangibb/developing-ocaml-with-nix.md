---
title: Developing OCaml with Nix
description:
url: https://ryan.freumh.org/ocaml-nix.html
date: 2023-06-07T00:00:00-00:00
preview_image:
authors:
- Ryan Gibb
source:
---

<article>
    <div class="container">
        
        <span>Published  7 Jun 2023.</span>
        
        
        <span style="font-style: italic;">Last update  7 Jun 2023.</span>
        
    </div>
    
    <section>
        <p><span>Lately, I’ve been writing a significant amount of
OCaml as part of my PhD. Instead of using the OCaml package manager
(opam) command-line interface (CLI) for these projects, I prefer to use
<a href="https://ryan.freumh.org/nix.html">Nix</a> to provide declarative and reproducible
development environments and builds. However I still want to be able to
interoperate with opam’s file format and access packages from the opam
repository. In this blog post we’ll walk through creating a
<code>flake.nix</code> file to do this for a hello world project at <a href="https://github.com/RyanGibb/ocaml-nix-hello">github.com/RyanGibb/ocaml-nix-hello</a>.
Our aim is to make building an OCaml project, and setting up a
development environment, as simple as one command.</span></p>
<h3>Nix?</h3>
<p><span>I’ve said that Nix can provide declarative and
reproducible environments and builds. Let’s break down what this
means:</span></p>
<ul>
<li>Declarative: instead of using imperative commands to manipulate an
opam switch<a href="https://ryan.freumh.org/atom.xml#fn1" class="footnote-ref" role="doc-noteref"><sup>1</sup></a> into a desirable state for a
project, we instead declare the state we want in a functional Domain
Specific Language (DSL) and use Nix to build it for us.</li>
<li>Reproducible: this declarative specification will give us the same
result every time. It does this by pinning the inputs for a build (a
‘derivation’) by hash and building it in a sandboxed environment<a href="https://ryan.freumh.org/atom.xml#fn2" class="footnote-ref" role="doc-noteref"><sup>2</sup></a>.</li>
</ul>
<p><span>This aims to solve the problem of ‘it works on
my machine’ but not elsewhere. Container images are also often used for
a similar purpose, however in Nix’s case we only need to specify the
inputs and build rules precisely.</span></p>
<p><span>For an introduction to Nix and it’s ecosystems,
I’ve written more <a href="https://ryan.freumh.org/hillingar/#nix">here</a>.</span></p>
<h3>Flakes</h3>
<p><span>I’m taking an opinionated stance and using
Nix Flakes<a href="https://ryan.freumh.org/atom.xml#fn3" class="footnote-ref" role="doc-noteref"><sup>3</sup></a>. Flakes are a new way to specify a
source tree as a Nix project using a <code>flake.nix</code>. They
provide a lot of benefits: pinning project dependencies using a lockfile
<code>flake.lock</code><a href="https://ryan.freumh.org/atom.xml#fn4" class="footnote-ref" role="doc-noteref"><sup>4</sup></a>, resolving Nix expressions in
isolation<a href="https://ryan.freumh.org/atom.xml#fn5" class="footnote-ref" role="doc-noteref"><sup>5</sup></a>, provide a Nix-native<a href="https://ryan.freumh.org/atom.xml#fn6" class="footnote-ref" role="doc-noteref"><sup>6</sup></a> way
of composing Nix projects<a href="https://ryan.freumh.org/atom.xml#fn7" class="footnote-ref" role="doc-noteref"><sup>7</sup></a>, and a new CLI<a href="https://ryan.freumh.org/atom.xml#fn8" class="footnote-ref" role="doc-noteref"><sup>8</sup></a> to
use Nix. If this sounds a bit complex, just take away despite them being
behind a feature flag Nix flakes are the future and are worth using for
their benefits now.</span></p>
<p><span>To enable flakes on your NixOS system add
this fragment to your configuration:</span></p>
<div class="sourceCode"><pre class="sourceCode nix"><code class="sourceCode nix"><span><a href="https://ryan.freumh.org/atom.xml#cb1-1" aria-hidden="true" tabindex="-1"></a>nix.settings.experimental<span class="op">-</span>features = <span class="op">[</span> <span class="st">"nix-command"</span> <span class="st">"flakes"</span> <span class="op">]</span>;</span></code></pre></div>
<h3><code>opam-nix</code></h3>
<p><span>I’ve said that I still want to
interoperate with opam for 2 reasons:</span></p>
<ul>
<li>If we use the opam file format to specify dependancies we can use
other people’s opam-based projects comparatively easily, and if other’s
want to use our project we aren’t forcing them to use Nix.</li>
<li>Relying on the set of OCaml projects packaged in Nixpkgs under
<code>ocamlPackages.&lt;name&gt;</code> will leave us with 833 packages
instead of the 4229 in <a href="https://github.com/ocaml/opam-repository/">github.com/ocaml/opam-repository/</a>
as of 2023-03-20. We also might run into issues with dependency version
resolution<a href="https://ryan.freumh.org/atom.xml#fn9" class="footnote-ref" role="doc-noteref"><sup>9</sup></a>.</li>
</ul>
<p><span>Fortunately a project already exists that
solves this for us: <a href="https://github.com/tweag/opam-nix">github.com/tweag/opam-nix</a>.
<code>opam-nix</code> translates opam packages into Nix derivations, so
we can use dependencies from <code>opam-repository</code>. It also
allows us to declare our project’s dependencies in opam’s format, so
that other users don’t have to use Nix. It uses opam’s dependency
version solver under the hood when building a project. Read more at <a href="https://www.tweag.io/blog/2023-02-16-opam-nix/">www.tweag.io/blog/2023-02-16-opam-nix/</a>.</span></p>
<p><span><code>opam-nix</code> also reproducibly
provides system dependencies (picking them up from opam
<code>depexts</code>) through Nix’s mechanisms. Nix provides great
support for cross-language project dependencies in general.</span></p>
<h3>A Simple Example</h3>
<p><span>The minimum required to get our
project building is:</span></p>
<div class="sourceCode"><pre class="sourceCode nix"><code class="sourceCode nix"><span><a href="https://ryan.freumh.org/atom.xml#cb2-1" aria-hidden="true" tabindex="-1"></a><span class="op">{</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb2-2" aria-hidden="true" tabindex="-1"></a>  <span class="va">inputs</span>.<span class="va">opam-nix</span>.<span class="va">url</span> <span class="op">=</span> <span class="st">"github:tweag/opam-nix"</span><span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb2-3" aria-hidden="true" tabindex="-1"></a></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb2-4" aria-hidden="true" tabindex="-1"></a>  <span class="va">outputs</span> <span class="op">=</span> <span class="op">{</span> <span class="va">self</span><span class="op">,</span> <span class="va">opam-nix</span> <span class="op">}</span>:</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb2-5" aria-hidden="true" tabindex="-1"></a>    <span class="kw">let</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb2-6" aria-hidden="true" tabindex="-1"></a>      <span class="va">system</span> <span class="op">=</span> <span class="st">"x86_64-linux"</span><span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb2-7" aria-hidden="true" tabindex="-1"></a>      <span class="va">inherit</span> (<span class="va">opam-nix</span>.<span class="va">lib</span>.${<span class="va">system</span>}) <span class="va">buildOpamProject</span>;</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb2-8" aria-hidden="true" tabindex="-1"></a>      <span class="va">package</span> <span class="op">=</span> <span class="st">"hello"</span><span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb2-9" aria-hidden="true" tabindex="-1"></a>    <span class="kw">in</span> <span class="kw">rec</span> <span class="op">{</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb2-10" aria-hidden="true" tabindex="-1"></a>      <span class="va">packages</span>.${<span class="va">system</span><span class="op">}</span> = buildOpamProject <span class="op">{</span> <span class="op">}</span> package <span class="ss">./.</span> <span class="op">{</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb2-11" aria-hidden="true" tabindex="-1"></a>        <span class="va">ocaml-base-compiler</span> <span class="op">=</span> <span class="st">"*"</span><span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb2-12" aria-hidden="true" tabindex="-1"></a>      <span class="op">};</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb2-13" aria-hidden="true" tabindex="-1"></a>      <span class="va">defaultPackage</span>.${<span class="va">system</span><span class="op">}</span> = packages.$<span class="op">{</span><span class="va">system</span><span class="op">}</span>.$<span class="op">{</span><span class="va">package</span><span class="op">}</span>;</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb2-14" aria-hidden="true" tabindex="-1"></a>    };</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb2-15" aria-hidden="true" tabindex="-1"></a>}</span></code></pre></div>
<p><span>Documentation for
<code>buildOpamProject</code> can be found at <a href="https://github.com/tweag/opam-nix/#buildOpamProject">github.com/tweag/opam-nix/#buildOpamProject</a>.</span></p>
<p><span>This is sufficient to build the
project with:</span></p>
<div class="sourceCode"><pre class="sourceCode sh"><code class="sourceCode bash"><span><a href="https://ryan.freumh.org/atom.xml#cb3-1" aria-hidden="true" tabindex="-1"></a><span class="ex">$</span> nix build .</span></code></pre></div>
<p><span>We can also get a <a href="https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-develop.html">development
shell</a> and build the project outside a Nix derivation – benefitting
from the dune cache – using:</span></p>
<div class="sourceCode"><pre class="sourceCode sh"><code class="sourceCode bash"><span><a href="https://ryan.freumh.org/atom.xml#cb4-1" aria-hidden="true" tabindex="-1"></a><span class="ex">$</span> nix develop . <span class="at">-c</span> dune build</span></code></pre></div>
<p><span>Each of the following sections
will modify this MVP flake to add new functionality, before we combine
them all into the final product.</span></p>
<h3>Development Environment</h3>
<p><span>A user may also want to
benefit from developer tools, such as the <a href="https://github.com/ocaml/ocaml-lsp">OCaml LSP</a> server, which
can be added to the query made to opam:</span></p>
<div class="sourceCode"><pre class="sourceCode nix"><code class="sourceCode nix"><span><a href="https://ryan.freumh.org/atom.xml#cb5-1" aria-hidden="true" tabindex="-1"></a> <span class="op">{</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb5-2" aria-hidden="true" tabindex="-1"></a>   <span class="va">inputs</span>.<span class="va">opam-nix</span>.<span class="va">url</span> <span class="op">=</span> <span class="st">"github:tweag/opam-nix"</span><span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb5-3" aria-hidden="true" tabindex="-1"></a></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb5-4" aria-hidden="true" tabindex="-1"></a>-  <span class="va">outputs</span> <span class="op">=</span> <span class="op">{</span> <span class="va">self</span><span class="op">,</span> <span class="va">opam-nix</span> <span class="op">}</span>:</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb5-5" aria-hidden="true" tabindex="-1"></a><span class="op">+</span>  outputs = <span class="op">{</span> <span class="va">self</span><span class="op">,</span> <span class="va">nixpkgs</span><span class="op">,</span> <span class="va">opam-nix</span> <span class="op">}</span>:</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb5-6" aria-hidden="true" tabindex="-1"></a>     <span class="kw">let</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb5-7" aria-hidden="true" tabindex="-1"></a>       <span class="va">system</span> <span class="op">=</span> <span class="st">"x86_64-linux"</span><span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb5-8" aria-hidden="true" tabindex="-1"></a>+      <span class="co"># instantiate nixpkgs with this system</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb5-9" aria-hidden="true" tabindex="-1"></a>+      <span class="va">pkgs</span> <span class="op">=</span> nixpkgs.legacyPackages.$<span class="op">{</span><span class="va">system</span><span class="op">};</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb5-10" aria-hidden="true" tabindex="-1"></a>       <span class="va">inherit</span> (<span class="va">opam-nix</span>.<span class="va">lib</span>.${<span class="va">system</span>}) <span class="va">buildOpamProject</span>;</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb5-11" aria-hidden="true" tabindex="-1"></a>       <span class="va">package</span> <span class="op">=</span> <span class="st">"hello"</span><span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb5-12" aria-hidden="true" tabindex="-1"></a>     <span class="kw">in</span> <span class="kw">rec</span> <span class="op">{</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb5-13" aria-hidden="true" tabindex="-1"></a>       <span class="va">packages</span>.${<span class="va">system</span><span class="op">}</span> = buildOpamProject <span class="op">{</span> <span class="op">}</span> package <span class="ss">./.</span> <span class="op">{</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb5-14" aria-hidden="true" tabindex="-1"></a>         <span class="va">ocaml-base-compiler</span> <span class="op">=</span> <span class="st">"*"</span><span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb5-15" aria-hidden="true" tabindex="-1"></a>+        <span class="va">ocaml-lsp-server</span> <span class="op">=</span> <span class="st">"*"</span><span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb5-16" aria-hidden="true" tabindex="-1"></a>       <span class="op">};</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb5-17" aria-hidden="true" tabindex="-1"></a>       <span class="va">defaultPackage</span>.${<span class="va">system</span><span class="op">}</span> = packages.$<span class="op">{</span><span class="va">system</span><span class="op">}</span>.$<span class="op">{</span><span class="va">package</span><span class="op">}</span>;</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb5-18" aria-hidden="true" tabindex="-1"></a><span class="op">+</span>      <span class="co"># create a development environment with ocaml-lsp-server</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb5-19" aria-hidden="true" tabindex="-1"></a><span class="op">+</span>      devShells.$<span class="op">{</span><span class="va">system</span><span class="op">}</span>.default = pkgs.mkShell <span class="op">{</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb5-20" aria-hidden="true" tabindex="-1"></a>+        <span class="va">inputsFrom</span> <span class="op">=</span> <span class="op">[</span> defaultPackage.$<span class="op">{</span><span class="va">system</span><span class="op">}</span> <span class="op">];</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb5-21" aria-hidden="true" tabindex="-1"></a>+        <span class="va">buildInputs</span> <span class="op">=</span> <span class="op">[</span> packages.$<span class="op">{</span><span class="va">system</span><span class="op">}</span>.<span class="st">"ocaml-lsp-server"</span> <span class="op">];</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb5-22" aria-hidden="true" tabindex="-1"></a>+      <span class="op">}</span>;</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb5-23" aria-hidden="true" tabindex="-1"></a>     };</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb5-24" aria-hidden="true" tabindex="-1"></a> }</span></code></pre></div>
<p><span>Users can then launch an
editor with <code>ocaml-lsp-server</code> in the environment
with:</span></p>
<div class="sourceCode"><pre class="sourceCode sh"><code class="sourceCode bash"><span><a href="https://ryan.freumh.org/atom.xml#cb6-1" aria-hidden="true" tabindex="-1"></a><span class="ex">$</span> nix develop . <span class="at">-c</span> <span class="va">$EDITOR</span> <span class="kw">`</span><span class="bu">pwd</span><span class="kw">`</span></span></code></pre></div>
<p><span>For
<code>nix develop</code> documentation see <a href="https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-develop.html">nixos.org/manual/nix/stable/command-ref/new-cli/nix3-develop.html</a>.</span></p>
<h3>Managing Dependencies</h3>
<p><span>We might want to specify a
specific version of the opam-respository to get more up to date
packages, which we can do by tracking it as a seperate input to the
flake. We can do the same with the Nixpkgs monorepo<a href="https://ryan.freumh.org/atom.xml#fn10" class="footnote-ref" role="doc-noteref"><sup>10</sup></a>.</span></p>
<div class="sourceCode"><pre class="sourceCode nix"><code class="sourceCode nix"><span><a href="https://ryan.freumh.org/atom.xml#cb7-1" aria-hidden="true" tabindex="-1"></a> <span class="op">{</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb7-2" aria-hidden="true" tabindex="-1"></a>-  <span class="va">inputs</span>.<span class="va">opam-nix</span>.<span class="va">url</span> <span class="op">=</span> <span class="st">"github:tweag/opam-nix"</span><span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb7-3" aria-hidden="true" tabindex="-1"></a>+  <span class="va">inputs</span> <span class="op">=</span> <span class="op">{</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb7-4" aria-hidden="true" tabindex="-1"></a>+    <span class="va">nixpkgs</span>.<span class="va">url</span> <span class="op">=</span> <span class="st">"github:NixOS/nixpkgs"</span><span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb7-5" aria-hidden="true" tabindex="-1"></a>+    <span class="va">opam-nix</span>.<span class="va">url</span> <span class="op">=</span> <span class="st">"github:tweag/opam-nix"</span><span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb7-6" aria-hidden="true" tabindex="-1"></a>+    <span class="va">opam-repository</span> <span class="op">=</span> <span class="op">{</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb7-7" aria-hidden="true" tabindex="-1"></a>+      <span class="va">url</span> <span class="op">=</span> <span class="st">"github:ocaml/opam-repository"</span><span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb7-8" aria-hidden="true" tabindex="-1"></a>+      <span class="va">flake</span> <span class="op">=</span> <span class="cn">false</span><span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb7-9" aria-hidden="true" tabindex="-1"></a>+    <span class="op">};</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb7-10" aria-hidden="true" tabindex="-1"></a>+    <span class="va">opam-nix</span>.<span class="va">inputs</span>.<span class="va">opam-repository</span>.<span class="va">follows</span> <span class="op">=</span> <span class="st">"opam-repository"</span><span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb7-11" aria-hidden="true" tabindex="-1"></a>+    <span class="va">opam-nix</span>.<span class="va">inputs</span>.<span class="va">nixpkgs</span>.<span class="va">follows</span> <span class="op">=</span> <span class="st">"nixpkgs"</span><span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb7-12" aria-hidden="true" tabindex="-1"></a>+  <span class="op">};</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb7-13" aria-hidden="true" tabindex="-1"></a></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb7-14" aria-hidden="true" tabindex="-1"></a>-  <span class="va">outputs</span> <span class="op">=</span> <span class="op">{</span> <span class="va">self</span><span class="op">,</span> <span class="va">opam-nix</span> <span class="op">}</span>:</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb7-15" aria-hidden="true" tabindex="-1"></a><span class="op">+</span>  outputs = <span class="op">{</span> <span class="va">self</span><span class="op">,</span> <span class="va">opam-nix</span><span class="op">,</span> <span class="op">...</span> <span class="op">}</span>:</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb7-16" aria-hidden="true" tabindex="-1"></a>     <span class="kw">let</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb7-17" aria-hidden="true" tabindex="-1"></a>       <span class="va">system</span> <span class="op">=</span> <span class="st">"x86_64-linux"</span><span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb7-18" aria-hidden="true" tabindex="-1"></a>       <span class="va">inherit</span> (<span class="va">opam-nix</span>.<span class="va">lib</span>.${<span class="va">system</span>}) <span class="va">buildOpamProject</span>;</span></code></pre></div>
<p><span>The opam-repository can also
be chosen granularly <code>opam-nix</code> function call with the <a href="https://github.com/tweag/opam-nix#querytoscope"><code>repos</code>
argument</a>, but we just override <code>opam-nix</code>’s
<code>opam-repository</code> input. Note that some packages, notably
ocamlfind, required patches to work with <code>opam-nix</code>. If you
run into errors you can force the resolution of an old version,
e.g.&nbsp;<code>ocamlfind = "1.9.5";</code>.</span></p>
<p><span>One can pin an input to a
specific commit with, e.g.:</span></p>
<pre><code>nix flake update --override-input opam-repository github:ocaml/opam-repository/&lt;commit&gt;</code></pre>
<h3>Materialization</h3>
<p><span>Every time we call
<code>buildOpamProject</code>, or an equivalent function that calls
<code>queryToScope</code> under the hood, we perform a computationally
expensive dependency resolution using a SAT solver. We can save the
results of this query to a file with materialization<a href="https://ryan.freumh.org/atom.xml#fn11" class="footnote-ref" role="doc-noteref"><sup>11</sup></a>.</span></p>
<div class="sourceCode"><pre class="sourceCode nix"><code class="sourceCode nix"><span><a href="https://ryan.freumh.org/atom.xml#cb9-1" aria-hidden="true" tabindex="-1"></a> <span class="op">{</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb9-2" aria-hidden="true" tabindex="-1"></a>   <span class="va">inputs</span>.<span class="va">opam-nix</span>.<span class="va">url</span> <span class="op">=</span> <span class="st">"github:tweag/opam-nix"</span><span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb9-3" aria-hidden="true" tabindex="-1"></a></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb9-4" aria-hidden="true" tabindex="-1"></a>-  <span class="va">outputs</span> <span class="op">=</span> <span class="op">{</span> <span class="va">self</span><span class="op">,</span> <span class="va">opam-nix</span> <span class="op">}</span>:</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb9-5" aria-hidden="true" tabindex="-1"></a><span class="op">+</span>  outputs = <span class="op">{</span> <span class="va">self</span><span class="op">,</span> <span class="va">opam-nix</span><span class="op">,</span> <span class="op">...</span> <span class="op">}</span>:</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb9-6" aria-hidden="true" tabindex="-1"></a>     <span class="kw">let</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb9-7" aria-hidden="true" tabindex="-1"></a>       <span class="va">system</span> <span class="op">=</span> <span class="st">"x86_64-linux"</span><span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb9-8" aria-hidden="true" tabindex="-1"></a>-      <span class="va">inherit</span> (<span class="va">opam-nix</span>.<span class="va">lib</span>.${<span class="va">system</span>}) <span class="va">buildOpamProject</span>;</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb9-9" aria-hidden="true" tabindex="-1"></a>+      <span class="va">inherit</span> (<span class="va">opam-nix</span>.<span class="va">lib</span>.${<span class="va">system</span>})</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb9-10" aria-hidden="true" tabindex="-1"></a>+        <span class="va">buildOpamProject</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb9-11" aria-hidden="true" tabindex="-1"></a>+        <span class="va">materializedDefsToScope</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb9-12" aria-hidden="true" tabindex="-1"></a>+        <span class="va">materializeOpamProject'</span>;</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb9-13" aria-hidden="true" tabindex="-1"></a>       <span class="va">package</span> <span class="op">=</span> <span class="st">"hello"</span><span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb9-14" aria-hidden="true" tabindex="-1"></a>-    <span class="kw">in</span> <span class="kw">rec</span> <span class="op">{</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb9-15" aria-hidden="true" tabindex="-1"></a>-      <span class="va">packages</span>.${<span class="va">system</span><span class="op">}</span> = buildOpamProject <span class="op">{</span> <span class="op">}</span> package <span class="ss">./.</span> <span class="op">{</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb9-16" aria-hidden="true" tabindex="-1"></a>+      <span class="va">query</span> <span class="op">=</span> <span class="op">{</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb9-17" aria-hidden="true" tabindex="-1"></a>         <span class="va">ocaml-base-compiler</span> <span class="op">=</span> <span class="st">"*"</span><span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb9-18" aria-hidden="true" tabindex="-1"></a>       <span class="op">};</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb9-19" aria-hidden="true" tabindex="-1"></a>-      <span class="va">defaultPackage</span>.${<span class="va">system</span><span class="op">}</span> = packages.$<span class="op">{</span><span class="va">system</span><span class="op">}</span>.$<span class="op">{</span><span class="va">package</span><span class="op">};</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb9-20" aria-hidden="true" tabindex="-1"></a>+      <span class="va">resolved-scope</span> <span class="op">=</span> buildOpamProject <span class="op">{</span> <span class="op">}</span> package <span class="ss">./.</span> query<span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb9-21" aria-hidden="true" tabindex="-1"></a>+      <span class="va">materialized-scope</span> <span class="op">=</span> materializedDefsToScope</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb9-22" aria-hidden="true" tabindex="-1"></a><span class="op">+</span>        <span class="op">{</span> <span class="va">sourceMap</span>.${<span class="va">package</span><span class="op">}</span> = <span class="ss">./.</span><span class="op">;</span> <span class="op">}</span> <span class="ss">./package-defs.json</span>;</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb9-23" aria-hidden="true" tabindex="-1"></a><span class="op">+</span>    in <span class="kw">rec</span> <span class="op">{</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb9-24" aria-hidden="true" tabindex="-1"></a>+      <span class="va">packages</span> <span class="op">=</span> <span class="op">{</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb9-25" aria-hidden="true" tabindex="-1"></a>+        <span class="va">resolved</span> <span class="op">=</span> resolved<span class="op">-</span>scope<span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb9-26" aria-hidden="true" tabindex="-1"></a>+        <span class="va">materialized</span>.${<span class="va">system</span><span class="op">}</span> = materialized<span class="op">-</span>scope<span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb9-27" aria-hidden="true" tabindex="-1"></a>+        <span class="co"># to generate:</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb9-28" aria-hidden="true" tabindex="-1"></a>+        <span class="co">#   cat $(nix eval .#package-defs --raw) &gt; package-defs.json</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb9-29" aria-hidden="true" tabindex="-1"></a>+        ${<span class="va">system</span><span class="op">}</span>.package<span class="op">-</span>defs = materializeOpamProject' <span class="op">{</span> <span class="op">}</span> <span class="ss">./.</span> query;</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb9-30" aria-hidden="true" tabindex="-1"></a><span class="op">+</span>      };</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb9-31" aria-hidden="true" tabindex="-1"></a><span class="op">+</span>      defaultPackage.$<span class="op">{</span><span class="va">system</span><span class="op">}</span> = packages.materialized.$<span class="op">{</span><span class="va">system</span><span class="op">}</span>.$<span class="op">{</span><span class="va">package</span><span class="op">}</span>;</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb9-32" aria-hidden="true" tabindex="-1"></a>     };</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb9-33" aria-hidden="true" tabindex="-1"></a> }</span></code></pre></div>
<p><span>The <code>package-defs.json</code>
file generated by
<code>cat $(nix eval .#package-defs --raw) &gt; package-defs.json</code>
should be committed to the repository.</span></p>
<h3>Overlays</h3>
<p><span>We can modify derivations with Nix
overlays<a href="https://ryan.freumh.org/atom.xml#fn12" class="footnote-ref" role="doc-noteref"><sup>12</sup></a>.</span></p>
<div class="sourceCode"><pre class="sourceCode nix"><code class="sourceCode nix"><span><a href="https://ryan.freumh.org/atom.xml#cb10-1" aria-hidden="true" tabindex="-1"></a>       system = <span class="st">"x86_64-linux"</span>;</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb10-2" aria-hidden="true" tabindex="-1"></a>       inherit <span class="op">(</span>opam<span class="op">-</span>nix.lib.$<span class="op">{</span><span class="va">system</span><span class="op">})</span> buildOpamProject;</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb10-3" aria-hidden="true" tabindex="-1"></a>       package = <span class="st">"hello"</span>;</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb10-4" aria-hidden="true" tabindex="-1"></a><span class="op">-</span>    in <span class="kw">rec</span> <span class="op">{</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb10-5" aria-hidden="true" tabindex="-1"></a>-      <span class="va">packages</span>.${<span class="va">system</span><span class="op">}</span> = buildOpamProject <span class="op">{</span> <span class="op">}</span> package <span class="ss">./.</span> <span class="op">{</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb10-6" aria-hidden="true" tabindex="-1"></a>-        <span class="va">ocaml-base-compiler</span> <span class="op">=</span> <span class="st">"*"</span><span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb10-7" aria-hidden="true" tabindex="-1"></a>+      <span class="va">overlay</span> <span class="op">=</span> <span class="va">final</span><span class="op">:</span> <span class="va">prev</span><span class="op">:</span> <span class="op">{</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb10-8" aria-hidden="true" tabindex="-1"></a>+        <span class="st">"</span><span class="sc">${</span>package<span class="sc">}</span><span class="st">"</span> <span class="op">=</span> prev.$<span class="op">{</span><span class="va">package</span><span class="op">}</span>.overrideAttrs <span class="op">(</span><span class="va">_</span><span class="op">:</span> <span class="op">{</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb10-9" aria-hidden="true" tabindex="-1"></a>+          <span class="co"># override derivation attributes, e.g. add additional dependacies</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb10-10" aria-hidden="true" tabindex="-1"></a>+          <span class="va">buildInputs</span> <span class="op">=</span> <span class="op">[</span> <span class="op">];</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb10-11" aria-hidden="true" tabindex="-1"></a>+        <span class="op">});</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb10-12" aria-hidden="true" tabindex="-1"></a>       <span class="op">};</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb10-13" aria-hidden="true" tabindex="-1"></a>+      <span class="va">overlayed-scope</span> <span class="op">=</span> <span class="kw">let</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb10-14" aria-hidden="true" tabindex="-1"></a>+        <span class="va">scope</span> <span class="op">=</span> buildOpamProject <span class="op">{</span> <span class="op">}</span> package <span class="ss">./.</span> <span class="op">{</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb10-15" aria-hidden="true" tabindex="-1"></a>+          <span class="va">ocaml-base-compiler</span> <span class="op">=</span> <span class="st">"*"</span><span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb10-16" aria-hidden="true" tabindex="-1"></a>+        <span class="op">};</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb10-17" aria-hidden="true" tabindex="-1"></a>+        <span class="kw">in</span> scope.overrideScope' overlay<span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb10-18" aria-hidden="true" tabindex="-1"></a>+    <span class="va">in</span> <span class="va">rec</span> {</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb10-19" aria-hidden="true" tabindex="-1"></a>+      <span class="va">packages</span>.${<span class="va">system</span><span class="op">}</span> = overlayed<span class="op">-</span>scope;</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb10-20" aria-hidden="true" tabindex="-1"></a>       defaultPackage.$<span class="op">{</span><span class="va">system</span><span class="op">}</span> = packages.$<span class="op">{</span><span class="va">system</span><span class="op">}</span>.$<span class="op">{</span><span class="va">package</span><span class="op">}</span>;</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb10-21" aria-hidden="true" tabindex="-1"></a>     };</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb10-22" aria-hidden="true" tabindex="-1"></a> }</span></code></pre></div>
<h3>Multiple Systems</h3>
<p><span>Nix flakes are evaluated
hermetically and as a result don’t take any arguments<a href="https://ryan.freumh.org/atom.xml#fn13" class="footnote-ref" role="doc-noteref"><sup>13</sup></a>.
However different systems will have different packages built for them.
We essentially parametrize based on system by different derivation
paths, e.g.&nbsp;<code>nix build .</code> implicitly builds the derivation
<code>packages.${system}.default</code>. We can support multiple systems
by creating derivations for each system. <code>flake-utils</code><a href="https://ryan.freumh.org/atom.xml#fn14" class="footnote-ref" role="doc-noteref"><sup>14</sup></a> provides a convient mechanism for
creating these derivations.</span></p>
<div class="sourceCode"><pre class="sourceCode nix"><code class="sourceCode nix"><span><a href="https://ryan.freumh.org/atom.xml#cb11-1" aria-hidden="true" tabindex="-1"></a> <span class="op">{</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb11-2" aria-hidden="true" tabindex="-1"></a>   <span class="va">inputs</span>.<span class="va">opam-nix</span>.<span class="va">url</span> <span class="op">=</span> <span class="st">"github:tweag/opam-nix"</span><span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb11-3" aria-hidden="true" tabindex="-1"></a></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb11-4" aria-hidden="true" tabindex="-1"></a>-  <span class="va">outputs</span> <span class="op">=</span> <span class="op">{</span> <span class="va">self</span><span class="op">,</span> <span class="va">opam-nix</span> <span class="op">}</span>:</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb11-5" aria-hidden="true" tabindex="-1"></a><span class="op">-</span>    <span class="kw">let</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb11-6" aria-hidden="true" tabindex="-1"></a>-      <span class="va">system</span> <span class="op">=</span> <span class="st">"x86_64-linux"</span><span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb11-7" aria-hidden="true" tabindex="-1"></a>-      <span class="va">inherit</span> (<span class="va">opam-nix</span>.<span class="va">lib</span>.${<span class="va">system</span>}) <span class="va">buildOpamProject</span>;</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb11-8" aria-hidden="true" tabindex="-1"></a>-      <span class="va">package</span> <span class="op">=</span> <span class="st">"hello"</span><span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb11-9" aria-hidden="true" tabindex="-1"></a>-    <span class="kw">in</span> <span class="kw">rec</span> <span class="op">{</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb11-10" aria-hidden="true" tabindex="-1"></a>-      <span class="va">packages</span>.${<span class="va">system</span><span class="op">}</span> = buildOpamProject <span class="op">{</span> <span class="op">}</span> package <span class="ss">./.</span> <span class="op">{</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb11-11" aria-hidden="true" tabindex="-1"></a>-        <span class="va">ocaml-base-compiler</span> <span class="op">=</span> <span class="st">"*"</span><span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb11-12" aria-hidden="true" tabindex="-1"></a>-      <span class="op">};</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb11-13" aria-hidden="true" tabindex="-1"></a>-      <span class="va">defaultPackage</span>.${<span class="va">system</span><span class="op">}</span> = packages.$<span class="op">{</span><span class="va">system</span><span class="op">}</span>.$<span class="op">{</span><span class="va">package</span><span class="op">}</span>;</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb11-14" aria-hidden="true" tabindex="-1"></a><span class="op">-</span>    };</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb11-15" aria-hidden="true" tabindex="-1"></a><span class="op">+</span>  outputs = <span class="op">{</span> <span class="va">self</span><span class="op">,</span> <span class="va">opam-nix</span><span class="op">,</span> <span class="va">flake-utils</span> <span class="op">}</span>:</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb11-16" aria-hidden="true" tabindex="-1"></a><span class="op">+</span>    flake<span class="op">-</span>utils.lib.eachDefaultSystem <span class="op">(</span><span class="va">system</span><span class="op">:</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb11-17" aria-hidden="true" tabindex="-1"></a><span class="op">+</span>      <span class="kw">let</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb11-18" aria-hidden="true" tabindex="-1"></a>+        <span class="va">system</span> <span class="op">=</span> <span class="st">"x86_64-linux"</span><span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb11-19" aria-hidden="true" tabindex="-1"></a>+        <span class="va">inherit</span> (<span class="va">opam-nix</span>.<span class="va">lib</span>.${<span class="va">system</span>}) <span class="va">buildOpamProject</span>;</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb11-20" aria-hidden="true" tabindex="-1"></a>+        <span class="va">package</span> <span class="op">=</span> <span class="st">"hello"</span><span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb11-21" aria-hidden="true" tabindex="-1"></a>+      <span class="kw">in</span> <span class="kw">rec</span> <span class="op">{</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb11-22" aria-hidden="true" tabindex="-1"></a>+        <span class="va">packages</span>.${<span class="va">system</span><span class="op">}</span> = buildOpamProject <span class="op">{</span> <span class="op">}</span> package <span class="ss">./.</span> <span class="op">{</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb11-23" aria-hidden="true" tabindex="-1"></a>+          <span class="va">ocaml-base-compiler</span> <span class="op">=</span> <span class="st">"*"</span><span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb11-24" aria-hidden="true" tabindex="-1"></a>+        <span class="op">}</span>;</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb11-25" aria-hidden="true" tabindex="-1"></a><span class="op">+</span>        defaultPackage.$<span class="op">{</span><span class="va">system</span><span class="op">}</span> = packages.$<span class="op">{</span><span class="va">system</span><span class="op">}</span>.$<span class="op">{</span><span class="va">package</span><span class="op">}</span>;</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb11-26" aria-hidden="true" tabindex="-1"></a><span class="op">+</span>      }</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb11-27" aria-hidden="true" tabindex="-1"></a><span class="op">+</span>    <span class="op">)</span>;</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb11-28" aria-hidden="true" tabindex="-1"></a> }</span></code></pre></div>
<h3>Combining…</h3>
<p><span>We can combine all of:</span></p>
<ul>
<li><a href="https://ryan.freumh.org/atom.xml#a-simple-example">§</a> A Simple Example</li>
<li><a href="https://ryan.freumh.org/atom.xml#development-environment">§</a> Development
Environment</li>
<li><a href="https://ryan.freumh.org/atom.xml#managing-dependancies">§</a> Managing Dependancies</li>
<li><a href="https://ryan.freumh.org/atom.xml#materialization">§</a> Materialization</li>
<li><a href="https://ryan.freumh.org/atom.xml#overlays">§</a> Overlays</li>
<li><a href="https://ryan.freumh.org/atom.xml#multiple-systems">§</a> Multiple Systems</li>
</ul>
<p><span>To gives us a complete flake for our
project:</span></p>
<div class="sourceCode"><pre class="sourceCode nix"><code class="sourceCode nix"><span><a href="https://ryan.freumh.org/atom.xml#cb12-1" aria-hidden="true" tabindex="-1"></a><span class="op">{</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-2" aria-hidden="true" tabindex="-1"></a>  <span class="va">inputs</span> <span class="op">=</span> <span class="op">{</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-3" aria-hidden="true" tabindex="-1"></a>    <span class="va">nixpkgs</span>.<span class="va">url</span> <span class="op">=</span> <span class="st">"github:NixOS/nixpkgs"</span><span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-4" aria-hidden="true" tabindex="-1"></a>    <span class="va">opam-nix</span>.<span class="va">url</span> <span class="op">=</span> <span class="st">"github:tweag/opam-nix"</span><span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-5" aria-hidden="true" tabindex="-1"></a>    <span class="va">opam-repository</span> <span class="op">=</span> <span class="op">{</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-6" aria-hidden="true" tabindex="-1"></a>      <span class="va">url</span> <span class="op">=</span> <span class="st">"github:ocaml/opam-repository"</span><span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-7" aria-hidden="true" tabindex="-1"></a>      <span class="va">flake</span> <span class="op">=</span> <span class="cn">false</span><span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-8" aria-hidden="true" tabindex="-1"></a>    <span class="op">};</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-9" aria-hidden="true" tabindex="-1"></a>    <span class="va">opam-nix</span>.<span class="va">inputs</span>.<span class="va">opam-repository</span>.<span class="va">follows</span> <span class="op">=</span> <span class="st">"opam-repository"</span><span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-10" aria-hidden="true" tabindex="-1"></a>    <span class="va">opam-nix</span>.<span class="va">inputs</span>.<span class="va">nixpkgs</span>.<span class="va">follows</span> <span class="op">=</span> <span class="st">"nixpkgs"</span><span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-11" aria-hidden="true" tabindex="-1"></a>  <span class="op">};</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-12" aria-hidden="true" tabindex="-1"></a></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-13" aria-hidden="true" tabindex="-1"></a>  <span class="va">outputs</span> <span class="op">=</span> <span class="op">{</span> <span class="va">self</span><span class="op">,</span> <span class="va">nixpkgs</span><span class="op">,</span> <span class="va">opam-nix</span><span class="op">,</span> <span class="va">flake-utils</span><span class="op">,</span> <span class="op">...</span> <span class="op">}</span>:</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-14" aria-hidden="true" tabindex="-1"></a>    flake<span class="op">-</span>utils.lib.eachDefaultSystem <span class="op">(</span><span class="va">system</span><span class="op">:</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-15" aria-hidden="true" tabindex="-1"></a>      <span class="kw">let</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-16" aria-hidden="true" tabindex="-1"></a>        <span class="va">system</span> <span class="op">=</span> <span class="st">"x86_64-linux"</span><span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-17" aria-hidden="true" tabindex="-1"></a>        <span class="va">pkgs</span> <span class="op">=</span> nixpkgs.legacyPackages.$<span class="op">{</span><span class="va">system</span><span class="op">};</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-18" aria-hidden="true" tabindex="-1"></a>        <span class="va">inherit</span> (<span class="va">opam-nix</span>.<span class="va">lib</span>.${<span class="va">system</span>})</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-19" aria-hidden="true" tabindex="-1"></a>          <span class="va">buildOpamProject</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-20" aria-hidden="true" tabindex="-1"></a>          <span class="va">materializedDefsToScope</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-21" aria-hidden="true" tabindex="-1"></a>          <span class="va">materializeOpamProject'</span>;</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-22" aria-hidden="true" tabindex="-1"></a>        <span class="va">package</span> <span class="op">=</span> <span class="st">"hello"</span><span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-23" aria-hidden="true" tabindex="-1"></a>        <span class="va">query</span> <span class="op">=</span> <span class="op">{</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-24" aria-hidden="true" tabindex="-1"></a>          <span class="va">ocaml-base-compiler</span> <span class="op">=</span> <span class="st">"*"</span><span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-25" aria-hidden="true" tabindex="-1"></a>        <span class="op">};</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-26" aria-hidden="true" tabindex="-1"></a>        <span class="va">overlay</span> <span class="op">=</span> <span class="va">final</span><span class="op">:</span> <span class="va">prev</span><span class="op">:</span> <span class="op">{</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-27" aria-hidden="true" tabindex="-1"></a>          <span class="st">"</span><span class="sc">${</span>package<span class="sc">}</span><span class="st">"</span> <span class="op">=</span> prev.$<span class="op">{</span><span class="va">package</span><span class="op">}</span>.overrideAttrs <span class="op">(</span><span class="va">_</span><span class="op">:</span> <span class="op">{</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-28" aria-hidden="true" tabindex="-1"></a>            <span class="co"># override derivation attributes, e.g. add additional dependacies</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-29" aria-hidden="true" tabindex="-1"></a>            <span class="va">buildInputs</span> <span class="op">=</span> <span class="op">[</span> <span class="op">];</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-30" aria-hidden="true" tabindex="-1"></a>          <span class="op">});</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-31" aria-hidden="true" tabindex="-1"></a>        <span class="op">};</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-32" aria-hidden="true" tabindex="-1"></a>        <span class="va">resolved-scope</span> <span class="op">=</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-33" aria-hidden="true" tabindex="-1"></a>          <span class="kw">let</span> <span class="va">scope</span> <span class="op">=</span> buildOpamProject <span class="op">{</span> <span class="op">}</span> package <span class="ss">./.</span> query<span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-34" aria-hidden="true" tabindex="-1"></a>          <span class="kw">in</span> scope.overrideScope' overlay<span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-35" aria-hidden="true" tabindex="-1"></a>        <span class="va">materialized-scope</span> <span class="op">=</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-36" aria-hidden="true" tabindex="-1"></a>          <span class="kw">let</span> <span class="va">scope</span> <span class="op">=</span> materializedDefsToScope</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-37" aria-hidden="true" tabindex="-1"></a>            <span class="op">{</span> <span class="va">sourceMap</span>.${<span class="va">package</span><span class="op">}</span> = <span class="ss">./.</span><span class="op">;</span> } ./<span class="va">package-defs</span>.<span class="va">json</span>;</span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-38" aria-hidden="true" tabindex="-1"></a>          <span class="kw">in</span> scope.overrideScope' overlay<span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-39" aria-hidden="true" tabindex="-1"></a>      <span class="kw">in</span> <span class="kw">rec</span> <span class="op">{</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-40" aria-hidden="true" tabindex="-1"></a>        <span class="va">packages</span> <span class="op">=</span> <span class="op">{</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-41" aria-hidden="true" tabindex="-1"></a>          <span class="va">resolved</span> <span class="op">=</span> resolved<span class="op">-</span>scope<span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-42" aria-hidden="true" tabindex="-1"></a>          <span class="va">materialized</span> <span class="op">=</span> materialized<span class="op">-</span>scope<span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-43" aria-hidden="true" tabindex="-1"></a>          <span class="co"># to generate:</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-44" aria-hidden="true" tabindex="-1"></a>          <span class="co">#   cat $(nix eval .#package-defs --raw) &gt; package-defs.json</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-45" aria-hidden="true" tabindex="-1"></a>          <span class="va">package-defs</span> <span class="op">=</span> materializeOpamProject' <span class="op">{</span> <span class="op">}</span> <span class="ss">./.</span> query<span class="op">;</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-46" aria-hidden="true" tabindex="-1"></a>        <span class="op">};</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-47" aria-hidden="true" tabindex="-1"></a>        <span class="va">defaultPackage</span> <span class="op">=</span> packages.materialized.$<span class="op">{</span><span class="va">package</span><span class="op">};</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-48" aria-hidden="true" tabindex="-1"></a>        <span class="va">devShells</span>.<span class="va">default</span> <span class="op">=</span> pkgs.mkShell <span class="op">{</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-49" aria-hidden="true" tabindex="-1"></a>          <span class="va">inputsFrom</span> <span class="op">=</span> <span class="op">[</span> defaultPackage <span class="op">];</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-50" aria-hidden="true" tabindex="-1"></a>          <span class="va">buildInputs</span> <span class="op">=</span> <span class="op">[</span> packages.<span class="st">"ocaml-lsp-server"</span> <span class="op">];</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-51" aria-hidden="true" tabindex="-1"></a>        <span class="op">};</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-52" aria-hidden="true" tabindex="-1"></a>      <span class="op">}</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-53" aria-hidden="true" tabindex="-1"></a>    <span class="op">);</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb12-54" aria-hidden="true" tabindex="-1"></a><span class="op">}</span></span></code></pre></div>
<p><span>Try it out yourself at <a href="https://github.com/RyanGibb/ocaml-nix-hello/commits/main">github.com/RyanGibb/ocaml-nix-hello/commits/main</a>.</span></p>
<h3>Continuous Integration</h3>
<p><span>With a flake, we can easily
create a CI job from our Nix flake to build our program. For example, a
GitHub action would be:</span></p>
<div class="sourceCode"><pre class="sourceCode yaml"><code class="sourceCode yaml"><span><a href="https://ryan.freumh.org/atom.xml#cb13-1" aria-hidden="true" tabindex="-1"></a><span class="fu">name</span><span class="kw">:</span><span class="at"> ci</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb13-2" aria-hidden="true" tabindex="-1"></a><span class="fu">on</span><span class="kw">:</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb13-3" aria-hidden="true" tabindex="-1"></a><span class="at">  </span><span class="fu">push</span><span class="kw">:</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb13-4" aria-hidden="true" tabindex="-1"></a><span class="at">    </span><span class="fu">branches</span><span class="kw">:</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb13-5" aria-hidden="true" tabindex="-1"></a><span class="at">      </span><span class="kw">-</span><span class="at"> </span><span class="st">'main'</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb13-6" aria-hidden="true" tabindex="-1"></a><span class="at">  </span><span class="fu">pull_request</span><span class="kw">:</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb13-7" aria-hidden="true" tabindex="-1"></a><span class="at">    </span><span class="fu">branches</span><span class="kw">:</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb13-8" aria-hidden="true" tabindex="-1"></a><span class="at">      </span><span class="kw">-</span><span class="at"> </span><span class="st">"main"</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb13-9" aria-hidden="true" tabindex="-1"></a><span class="at">  </span><span class="fu">workflow_dispatch</span><span class="kw">:</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb13-10" aria-hidden="true" tabindex="-1"></a><span class="fu">jobs</span><span class="kw">:</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb13-11" aria-hidden="true" tabindex="-1"></a><span class="at">  </span><span class="fu">nix</span><span class="kw">:</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb13-12" aria-hidden="true" tabindex="-1"></a><span class="at">    </span><span class="fu">name</span><span class="kw">:</span><span class="at"> Build with Nix</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb13-13" aria-hidden="true" tabindex="-1"></a><span class="at">    </span><span class="fu">runs-on</span><span class="kw">:</span><span class="at"> ubuntu-latest</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb13-14" aria-hidden="true" tabindex="-1"></a><span class="at">    </span><span class="fu">steps</span><span class="kw">:</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb13-15" aria-hidden="true" tabindex="-1"></a><span class="at">      </span><span class="kw">-</span><span class="at"> </span><span class="fu">uses</span><span class="kw">:</span><span class="at"> actions/checkout@v3</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb13-16" aria-hidden="true" tabindex="-1"></a><span class="at">      </span><span class="kw">-</span><span class="at"> </span><span class="fu">uses</span><span class="kw">:</span><span class="at"> cachix/install-nix-action@v12</span></span>
<span><a href="https://ryan.freumh.org/atom.xml#cb13-17" aria-hidden="true" tabindex="-1"></a><span class="at">      </span><span class="kw">-</span><span class="at"> </span><span class="fu">run</span><span class="kw">:</span><span class="at"> nix --extra-experimental-features "nix-command flakes" build</span></span></code></pre></div>
<p><span>See it in action at <a href="https://github.com/RyanGibb/ocaml-nix-hello/actions/runs/5199834104">github.com/RyanGibb/ocaml-nix-hello/actions/runs/5199834104</a>.</span></p>
<h3>Nix Store</h3>
<p><span>The final benefit we’ll mentione that
this workflow provides is that all dependencies are stored in the global
Nix store and transparently shared between projects. When they differ
they’re duplicated so projects don’t interfere with each other.
Derivations can be garbage collected to save on disk space when they’re
no longer used.</span></p>
<p><span>To garbage collect globally:</span></p>
<div class="sourceCode"><pre class="sourceCode sh"><code class="sourceCode bash"><span><a href="https://ryan.freumh.org/atom.xml#cb14-1" aria-hidden="true" tabindex="-1"></a><span class="ex">$</span> nix-collect-garbage</span></code></pre></div>
<p><span>To garbage collect a specific
path:</span></p>
<pre><code>$ PATH=`readlink result`
$ rm result
$ nix-store --delete $(nix-store -qR $PATH)</code></pre>
<h3>Real-world Example</h3>
<p><span>A full-featured example of a Nix
flake building a project I’ve been working on recently, an effects-based
direct-style Domain Name System implementation written in OCaml, can be
found at <a href="https://github.com/RyanGibb/aeon/blob/main/flake.nix">github.com/RyanGibb/aeon/blob/main/flake.nix</a>.</span></p>
<h3>Conclusion</h3>
<p><span>Now someone getting started with our
repository can clone and build it with only:</span></p>
<pre><code>$ git clone git@github.com:RyanGibb/ocaml-nix-hello.git
$ cd ocaml-nix-hello
$ nix build .</code></pre>
<p><span>They can set up a development
environment with:</span></p>
<pre><code>$ nix develop -c dune build
$ nix develop -c $EDITOR `pwd`</code></pre>
<p><span>They could also build it without
manually cloning it:</span></p>
<pre><code>$ nix shell github:RyanGibb/ocaml-nix-hello
$ hello
Hello, World!</code></pre>
<p><span>They can even run it in a single
command!</span></p>
<pre><code>$ nix run github:ryangibb/ocaml-nix-hello
Hello, World!</code></pre>
<p><span>If this blog post has made you curious,
go try this for your own projects! Feel free to get in touch at <a href="mailto:ryan@freumh.html">ryan@freumh.org</a>.</span></p>
<h3>Thanks</h3>
<p><span>Thanks to Alexander Bantyev (balsoft) for
creating and maintaining opam-nix.</span></p>
<section class="footnotes footnotes-end-of-document" role="doc-endnotes">
<hr>
<ol>
<li><p><span><a href="https://opam.ocaml.org/doc/man/opam-switch.html">opam.ocaml.org/doc/man/opam-switch.html</a></span><a href="https://ryan.freumh.org/atom.xml#fnref1" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
<li><p><span>NB this doesn’t guarantee
<em>binary</em> reproducibility as there could still be some randomness
involved. This is why derivations are stored at a hash of their inputs
rather than their result. But there is work on providing a content
addressable store: <a href="https://www.tweag.io/blog/2020-09-10-nix-cas/">www.tweag.io/blog/2020-09-10-nix-cas/</a></span><a href="https://ryan.freumh.org/atom.xml#fnref2" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
<li><p><span>For an introduction to Flakes
see this blog post series: <a href="https://www.tweag.io/blog/2020-05-25-flakes/">www.tweag.io/blog/2020-05-25-flakes/</a>.</span><a href="https://ryan.freumh.org/atom.xml#fnref3" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
<li><p><span>Which replace imperatively
managed <a href="https://nixos.org/manual/nix/stable/package-management/channels.html">Nix
channels</a>.</span><a href="https://ryan.freumh.org/atom.xml#fnref4" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
<li><p><span>Existing Nix derivations are
built in isolation, but flakes also evaluate the Nix expression in
isolation which enabled caching of expression evaluation. Note Nix
expression refers to an expression in the <a href="https://nixos.org/manual/nix/stable/language/index.html">Nix
Language</a>.</span><a href="https://ryan.freumh.org/atom.xml#fnref5" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
<li><p><span>As opposed to an external tool
like <a href="https://github.com/nmattia/niv">github.com/nmattia/niv</a>.</span><a href="https://ryan.freumh.org/atom.xml#fnref6" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
<li><p><span>Without having to include them
in the Nixpkgs monorepo.</span><a href="https://ryan.freumh.org/atom.xml#fnref7" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
<li><p><span>See <a href="https://nixos.org/manual/nix/stable/command-ref/experimental-commands.html">nixos.org/manual/nix/stable/command-ref/experimental-commands.html</a>
for the new CLI reference.</span><a href="https://ryan.freumh.org/atom.xml#fnref8" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
<li><p><span> <a href="https://ryan.freumh.org/hillingar/#building-unikernels-para-5">../hillingar/#building-unikernels-para-5</a>
</span><a href="https://ryan.freumh.org/atom.xml#fnref9" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
<li><p><span>See <a href="https://ryan.freumh.org/hillingar/#nixpkgs">../hillingar#nixpkgs</a> for more
information.</span><a href="https://ryan.freumh.org/atom.xml#fnref10" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
<li><p><span><a href="https://github.com/tweag/opam-nix#materialization">github.com/tweag/opam-nix#materialization</a></span><a href="https://ryan.freumh.org/atom.xml#fnref11" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
<li><p><span><a href="https://nixos.wiki/wiki/Overlays">nixos.wiki/wiki/Overlays</a></span><a href="https://ryan.freumh.org/atom.xml#fnref12" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
<li><p><span>See <a href="https://ryan.freumh.org/github.com/NixOS/nix/issues/2861">github.com/NixOS/nix/issues/2861</a>
for more context on Nix flake arguments.</span><a href="https://ryan.freumh.org/atom.xml#fnref13" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
<li><p><span><a href="https://github.com/numtide/flake-utils">github.com/numtide/flake-utils</a>,
included in <a href="https://github.com/NixOS/flake-registry">github.com/NixOS/flake-registry</a></span><a href="https://ryan.freumh.org/atom.xml#fnref14" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
</ol>
</section>
    </section>
</article>

