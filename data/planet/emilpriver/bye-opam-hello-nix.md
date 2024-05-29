---
title: Bye Opam, Hello Nix
description: Article about replacing opam with nix for a easier life
url: https://priver.dev/blog/ocaml/bye-opam-hello-nix/
date: 2024-05-13T16:20:18-00:00
preview_image: https://priver.dev/images/ocaml.jpeg
authors:
- "Emil Priv\xE9r"
source:
---

<p>I&rsquo;ve been writing OCaml since November 2023 and I enjoy the language; it&rsquo;s fun to write and has some features I really appreciate. However, you may have noticed I only mentioned the &ldquo;language&rdquo; in the first sentence. That&rsquo;s because I have issues with Opam, the package manager for OCaml. It has been a pain in my development workflow and I want to eliminate it.</p>
<p>Not long ago, I was browsing Twitch and saw some content on Nix hosted by <a href="https://twitter.com/thealtf4stream">BlackGlasses</a> (<a href="https://www.twitch.tv/altf4stream">altf4stream</a>), <a href="https://twitter.com/metameeee">Metameeee</a> and <a href="https://twitter.com/dillon_mulroy">dmmulroy</a>. They discussed how to use Nix to manage your workspace, which intrigued me. Around the same time, I started working at CarbonCloud, my current employer, where we use Haskell with Nix for some apps. Having seen how they utilize Nix and its potential, I decided to try it out with OCaml.</p>
<h2>Why?</h2>
<p>In short, I&rsquo;ve experienced numerous frustrations with OPAM when working on multiple projects that use different versions of a library. This scenario often necessitates creating new switches and reinstalling everything. Though I&rsquo;ve heard that OCaml libraries should be backward compatible, I&rsquo;ve never found this to be the case in practice. For instance, if we need to modify a function in version 2.0.0 due to a security issue, it challenges the notion of &ldquo;backward compatibility&rdquo;.</p>
<p>Challenges may arise when opening the same folder in different terminal sessions, such as whether the command <code>opam install . --deps-only</code> needs to be run again to update the terminal to use the local switch instead of the global one. To clarify, a standard OPAM installation puts all packages globally in <code>$HOME/.opam</code>. To avoid using this global environment, a local environment can be created by running <code>opam install . --deps-only</code> in the desired folder. This command creates an <code>_opam</code> folder in the directory, which can help avoid some complications. Furthermore, OPAM allows you to set a specific package version in your <code>.opam</code> files. This is useful even for packages that strive for backward compatibility, as it allows for two repositories to require different versions of the same package. However, it can also lead to version conflicts as packages are typically installed in the global environment.</p>
<p>Another difficulty is the time it takes to release something on the OPAM repository. As a result, you may find yourself installing some packages directly from OPAM, while pinning others directly to a Git reference.</p>
<p>Another issue I noticed is that Opam sometimes installs non-OCaml libraries, like PostgreSQL, without asking, if a specific library requires it. This situation feels a bit odd.</p>
<p>Therefore, I replaced Opam with Nix.</p>
<h2>Moving to nix flakes</h2>
<p>I&rsquo;ve started transitioning to Nix, which allows me to completely remove Opam from my system, since OCaml can function without it. Another approach to achieve this is by cloning libraries using Git to a folder within the library, as Dune handles monorepo very efficiently.</p>
<p>If you&rsquo;re unfamiliar with Nix, I recommend reading this article: <a href="https://shopify.engineering/what-is-nix">https://shopify.engineering/what-is-nix</a>. It provides a good summary.</p>
<p>I use Nix across several projects, but I will demonstrate examples and code from my project &ldquo;ocamlbyexample&rdquo;, which is similar to <a href="https://gobyexample.com/">https://gobyexample.com</a> but for OCaml. I am using Nix for two purposes in this project:</p>
<ul>
<li>To create an easily reproducible developer environment. If a new developer wants to contribute, they can simply clone the repo and run <code>nix develop</code> to get an environment with everything they need.</li>
<li>To build the project. I also wanted the ability to build the project in CI using Nix so that I would get the HTML, CSS, and JS files ready to be published to the internet.</li>
</ul>
<p>Nix handles these tasks very efficiently for me.</p>
<h3>Installing ocaml compiler and more</h3>
<p>Integrating this is fairly straightforward because the work has already been accomplished in the <code>nix-ocaml/nix-overlay</code> repository. Additionally, some OCaml packages have already been published to <a href="https://search.nixos.org/packages?channel=23.11&amp;from=0&amp;size=50&amp;sort=relevance&amp;type=packages&amp;query=ocamlpackages">nix</a>. Therefore, I just need to specify the dependencies I require to nix.</p>
<div class="highlight"><div class="chroma">
<table class="lntable"><tr><td class="lntd">
<pre tabindex="0" class="chroma"><code><span class="lnt"> 1
</span><span class="lnt"> 2
</span><span class="lnt"> 3
</span><span class="lnt"> 4
</span><span class="lnt"> 5
</span><span class="lnt"> 6
</span><span class="lnt"> 7
</span><span class="lnt"> 8
</span><span class="lnt"> 9
</span><span class="lnt">10
</span><span class="lnt">11
</span><span class="lnt">12
</span><span class="lnt">13
</span><span class="lnt">14
</span><span class="lnt">15
</span><span class="lnt">16
</span><span class="lnt">17
</span><span class="lnt">18
</span><span class="lnt">19
</span><span class="lnt">20
</span><span class="lnt">21
</span><span class="lnt">22
</span><span class="lnt">23
</span><span class="lnt">24
</span><span class="lnt">25
</span><span class="lnt">26
</span><span class="lnt">27
</span><span class="lnt">28
</span><span class="lnt">29
</span><span class="lnt">30
</span><span class="lnt">31
</span><span class="lnt">32
</span><span class="lnt">33
</span><span class="lnt">34
</span><span class="lnt">35
</span><span class="lnt">36
</span><span class="lnt">37
</span><span class="lnt">38
</span><span class="lnt">39
</span></code></pre></td>
<td class="lntd">
<pre tabindex="0" class="chroma"><code class="language-nix" data-lang="nix"><span class="line"><span class="cl"><span class="p">{</span>
</span></span><span class="line"><span class="cl">  <span class="n">description</span> <span class="o">=</span> <span class="s2">&quot;A development environment for ocamlbyexample&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">
</span></span><span class="line"><span class="cl">  <span class="n">inputs</span> <span class="o">=</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">    <span class="n">nixpkgs</span><span class="o">.</span><span class="n">url</span> <span class="o">=</span> <span class="s2">&quot;github:nix-ocaml/nix-overlays&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">    <span class="n">flake-utils</span><span class="o">.</span><span class="n">url</span> <span class="o">=</span> <span class="s2">&quot;github:numtide/flake-utils&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">  <span class="p">};</span>
</span></span><span class="line"><span class="cl">
</span></span><span class="line"><span class="cl">  <span class="n">outputs</span> <span class="o">=</span> <span class="p">{</span> <span class="n">self</span><span class="o">,</span> <span class="n">nixpkgs</span><span class="o">,</span> <span class="n">flake-utils</span><span class="o">,</span> <span class="o">...</span> <span class="p">}:</span>
</span></span><span class="line"><span class="cl">    <span class="n">flake-utils</span><span class="o">.</span><span class="n">lib</span><span class="o">.</span><span class="n">eachDefaultSystem</span> <span class="p">(</span><span class="n">system</span><span class="p">:</span>
</span></span><span class="line"><span class="cl">      <span class="k">let</span>
</span></span><span class="line"><span class="cl">        <span class="n">pkgs</span> <span class="o">=</span> <span class="n">nixpkgs</span><span class="o">.</span><span class="n">legacyPackages</span><span class="o">.</span><span class="s2">&quot;</span><span class="si">${</span><span class="n">system</span><span class="si">}</span><span class="s2">&quot;</span><span class="o">.</span><span class="n">extend</span> <span class="p">(</span><span class="n">self</span><span class="p">:</span> <span class="n">super</span><span class="p">:</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">          <span class="n">ocamlPackages</span> <span class="o">=</span> <span class="n">super</span><span class="o">.</span><span class="n">ocaml-ng</span><span class="o">.</span><span class="n">ocamlPackages_5_1</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">        <span class="p">});</span>
</span></span><span class="line"><span class="cl">        <span class="n">ocamlPackages</span> <span class="o">=</span> <span class="n">pkgs</span><span class="o">.</span><span class="n">ocamlPackages</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">        <span class="p">};</span>
</span></span><span class="line"><span class="cl">        <span class="n">packages</span> <span class="err">=</span> <span class="p">[</span>
</span></span><span class="line"><span class="cl">          <span class="n">ocamlPackages</span><span class="o">.</span><span class="n">brr</span> <span class="c1"># I inform nix that I need the brr library</span>
</span></span><span class="line"><span class="cl">          <span class="n">ocamlPackages</span><span class="o">.</span><span class="n">utop</span>
</span></span><span class="line"><span class="cl">        <span class="p">];</span>
</span></span><span class="line"><span class="cl">      <span class="n">in</span>
</span></span><span class="line"><span class="cl">      <span class="p">{</span>
</span></span><span class="line"><span class="cl">        <span class="n">formatter</span> <span class="o">=</span> <span class="n">nixpkgs</span><span class="o">.</span><span class="n">legacyPackages</span><span class="o">.</span><span class="n">x86_64-linux</span><span class="o">.</span><span class="n">nixpkgs-fmt</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">        <span class="n">defaultPackage</span> <span class="o">=</span> <span class="n">pkgs</span><span class="o">.</span><span class="n">stdenv</span><span class="o">.</span><span class="n">mkDerivation</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">          <span class="n">name</span> <span class="o">=</span> <span class="s2">&quot;ocamlbyexample&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">          <span class="n">src</span> <span class="o">=</span> <span class="sr">./.</span><span class="p">:</span>
</span></span><span class="line"><span class="cl">          <span class="c1"># My code for when I need to build the project</span>
</span></span><span class="line"><span class="cl">        <span class="p">};</span>
</span></span><span class="line"><span class="cl">
</span></span><span class="line"><span class="cl">        <span class="n">devShell</span> <span class="o">=</span> <span class="n">pkgs</span><span class="o">.</span><span class="n">mkShell</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">          <span class="n">nativeBuildInputs</span> <span class="o">=</span> <span class="k">with</span> <span class="n">pkgs</span><span class="o">.</span><span class="n">ocamlPackages</span><span class="p">;</span> <span class="p">[</span> <span class="n">cppo</span> <span class="n">findlib</span> <span class="p">];</span>
</span></span><span class="line"><span class="cl">          <span class="n">buildInputs</span> <span class="o">=</span> <span class="k">with</span> <span class="n">pkgs</span><span class="p">;</span> <span class="p">[</span>
</span></span><span class="line"><span class="cl">            <span class="n">packages</span>
</span></span><span class="line"><span class="cl">            <span class="n">caddy</span> <span class="c1"># Local http server</span>
</span></span><span class="line"><span class="cl">          <span class="p">];</span>
</span></span><span class="line"><span class="cl">        <span class="p">};</span>
</span></span><span class="line"><span class="cl">      <span class="p">}</span>
</span></span><span class="line"><span class="cl">    <span class="p">);</span>
</span></span><span class="line"><span class="cl"><span class="p">}</span>
</span></span></code></pre></td></tr></table>
</div>
</div><p><em>Please note that this code may not work perfectly as it could be missing some steps.</em></p>
<p>Instead of using <code>opam install brr</code>, you can replace it with <code>ocamlPackages.brr</code> as an argument for nix <code>buildInputs</code>. This installs the package when I run either <code>nix develop</code> or <code>nix build</code></p>
<h3>Libraries that don&rsquo;t exist on nix yet</h3>
<p>However, not all packages exists on nix yet but it&rsquo;s possible to install the packages directly from source using <code>builtins.fetchurl</code> as in the example below:</p>
<div class="highlight"><div class="chroma">
<table class="lntable"><tr><td class="lntd">
<pre tabindex="0" class="chroma"><code><span class="lnt"> 1
</span><span class="lnt"> 2
</span><span class="lnt"> 3
</span><span class="lnt"> 4
</span><span class="lnt"> 5
</span><span class="lnt"> 6
</span><span class="lnt"> 7
</span><span class="lnt"> 8
</span><span class="lnt"> 9
</span><span class="lnt">10
</span><span class="lnt">11
</span><span class="lnt">12
</span><span class="lnt">13
</span><span class="lnt">14
</span><span class="lnt">15
</span><span class="lnt">16
</span><span class="lnt">17
</span><span class="lnt">18
</span><span class="lnt">19
</span><span class="lnt">20
</span><span class="lnt">21
</span><span class="lnt">22
</span><span class="lnt">23
</span><span class="lnt">24
</span><span class="lnt">25
</span><span class="lnt">26
</span><span class="lnt">27
</span><span class="lnt">28
</span><span class="lnt">29
</span><span class="lnt">30
</span><span class="lnt">31
</span><span class="lnt">32
</span><span class="lnt">33
</span><span class="lnt">34
</span><span class="lnt">35
</span><span class="lnt">36
</span><span class="lnt">37
</span><span class="lnt">38
</span></code></pre></td>
<td class="lntd">
<pre tabindex="0" class="chroma"><code class="language-nix" data-lang="nix"><span class="line"><span class="cl"><span class="p">{</span>
</span></span><span class="line"><span class="cl">  <span class="n">description</span> <span class="o">=</span> <span class="s2">&quot;A development environment for ocamlbyexample&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">
</span></span><span class="line"><span class="cl">  <span class="n">inputs</span> <span class="o">=</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">    <span class="n">nixpkgs</span><span class="o">.</span><span class="n">url</span> <span class="o">=</span> <span class="s2">&quot;github:nix-ocaml/nix-overlays&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">    <span class="n">flake-utils</span><span class="o">.</span><span class="n">url</span> <span class="o">=</span> <span class="s2">&quot;github:numtide/flake-utils&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">  <span class="p">};</span>
</span></span><span class="line"><span class="cl">
</span></span><span class="line"><span class="cl">  <span class="n">outputs</span> <span class="o">=</span> <span class="p">{</span> <span class="n">self</span><span class="o">,</span> <span class="n">nixpkgs</span><span class="o">,</span> <span class="n">flake-utils</span><span class="o">,</span> <span class="o">...</span> <span class="p">}:</span>
</span></span><span class="line"><span class="cl">    <span class="n">flake-utils</span><span class="o">.</span><span class="n">lib</span><span class="o">.</span><span class="n">eachDefaultSystem</span> <span class="p">(</span><span class="n">system</span><span class="p">:</span>
</span></span><span class="line"><span class="cl">      <span class="k">let</span>
</span></span><span class="line"><span class="cl">        <span class="n">pkgs</span> <span class="o">=</span> <span class="n">nixpkgs</span><span class="o">.</span><span class="n">legacyPackages</span><span class="o">.</span><span class="s2">&quot;</span><span class="si">${</span><span class="n">system</span><span class="si">}</span><span class="s2">&quot;</span><span class="o">.</span><span class="n">extend</span> <span class="p">(</span><span class="n">self</span><span class="p">:</span> <span class="n">super</span><span class="p">:</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">          <span class="n">ocamlPackages</span> <span class="o">=</span> <span class="n">super</span><span class="o">.</span><span class="n">ocaml-ng</span><span class="o">.</span><span class="n">ocamlPackages_5_1</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">        <span class="p">});</span>
</span></span><span class="line"><span class="cl">        <span class="n">ocamlPackages</span> <span class="o">=</span> <span class="n">pkgs</span><span class="o">.</span><span class="n">ocamlPackages</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">        <span class="n">code_mirror</span> <span class="o">=</span> <span class="n">ocamlPackages</span><span class="o">.</span><span class="n">buildDunePackage</span> <span class="k">rec</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">          <span class="n">pname</span> <span class="o">=</span> <span class="s2">&quot;code-mirror&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">          <span class="n">version</span> <span class="o">=</span> <span class="s2">&quot;&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">          <span class="n">src</span> <span class="o">=</span> <span class="nb">builtins</span><span class="o">.</span><span class="n">fetchurl</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">            <span class="n">url</span> <span class="o">=</span> <span class="s2">&quot;https://github.com/emilpriver/jsoo-code-mirror/archive/refs/tags/v0.0.1.tar.gz&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">            <span class="n">sha256</span> <span class="o">=</span> <span class="s2">&quot;sha256:0rby6kd9973icp72fj8i07awibamwsi3afy71dhrbq771dgz16cq&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">          <span class="p">};</span>
</span></span><span class="line"><span class="cl">          <span class="n">propagatedBuildInputs</span> <span class="o">=</span> <span class="k">with</span> <span class="n">pkgs</span><span class="p">;</span> <span class="p">[</span>
</span></span><span class="line"><span class="cl">	          <span class="c1"># Add the packages needed</span>
</span></span><span class="line"><span class="cl">            <span class="n">ocamlPackages</span><span class="o">.</span><span class="n">brr</span>
</span></span><span class="line"><span class="cl">            <span class="n">ocamlPackages</span><span class="o">.</span><span class="n">js_of_ocaml</span>
</span></span><span class="line"><span class="cl">          <span class="p">];</span>
</span></span><span class="line"><span class="cl">        <span class="p">};</span>
</span></span><span class="line"><span class="cl">        <span class="n">packages</span> <span class="o">=</span> <span class="p">[</span>
</span></span><span class="line"><span class="cl">          <span class="n">ocamlPackages</span><span class="o">.</span><span class="n">brr</span>
</span></span><span class="line"><span class="cl">          <span class="n">code_mirror</span>
</span></span><span class="line"><span class="cl">        <span class="p">];</span>
</span></span><span class="line"><span class="cl">      <span class="k">in</span>
</span></span><span class="line"><span class="cl">      <span class="p">{</span>
</span></span><span class="line"><span class="cl">       <span class="c1">## Same code</span>
</span></span><span class="line"><span class="cl">      <span class="p">}</span>
</span></span><span class="line"><span class="cl">    <span class="p">);</span>
</span></span><span class="line"><span class="cl"><span class="p">}</span>
</span></span></code></pre></td></tr></table>
</div>
</div><p>Since <code>dune</code> supports the installation and building of multiple packages, we utilize it here to build the package as seen in <code>ocamlPackages.buildDunePackage</code>.</p>
<blockquote>
<p>Dune is the build system for OCaml. It uses ocamlc under the hood to run and compile your project. The homepage can be found at: <a href="https://dune.build/">https://dune.build/</a></p>
</blockquote>
<p>There&rsquo;s a difference between using <code>ocamlPackages</code> and installing a package from the source. In the latter, a <code>sha256</code> hash of the downloaded file is required. Fortunately, you can easily obtain this hash.</p>
<p>By setting <code>sha256</code> to an empty string, Nix will calculate the hash for you, returning it in the terminal as an error message.</p>
<div class="highlight"><div class="chroma">
<table class="lntable"><tr><td class="lntd">
<pre tabindex="0" class="chroma"><code><span class="lnt">1
</span><span class="lnt">2
</span><span class="lnt">3
</span></code></pre></td>
<td class="lntd">
<pre tabindex="0" class="chroma"><code class="language-bash" data-lang="bash"><span class="line"><span class="cl"> error: <span class="nb">hash</span> mismatch in file downloaded from <span class="s1">'&lt;https://github.com/emilpriver/js_top_worker/archive/refs/tags/v0.0.1.tar.gz&gt;'</span>:
</span></span><span class="line"><span class="cl">         specified: sha256:0000000000000000000000000000000000000000000000000000
</span></span><span class="line"><span class="cl">         got:       sha256:1xkmq70lf0xk1r0684zckplhy9xxvf8vaa9xj6h1x2nksj717byy
</span></span></code></pre></td></tr></table>
</div>
</div><p>Simply copy the entire <code>got</code> value and input it into <code>sha256</code>, as demonstrated in the example, to have the correct hash ready.</p>
<h2>What does this mean for other developers</h2>
<p>Of course, other developers aren&rsquo;t required to use Nix if they prefer not to. However, if you want to contribute to the project with as little hassle as possible, simply run <code>nix develop</code>. This command provides you with the exact environment I&rsquo;m using, because Nix operates with reproducible environments. My devShell config for <a href="http://ocamlbyexample.com">ocamlbyexample.com</a> is</p>
<div class="highlight"><div class="chroma">
<table class="lntable"><tr><td class="lntd">
<pre tabindex="0" class="chroma"><code><span class="lnt"> 1
</span><span class="lnt"> 2
</span><span class="lnt"> 3
</span><span class="lnt"> 4
</span><span class="lnt"> 5
</span><span class="lnt"> 6
</span><span class="lnt"> 7
</span><span class="lnt"> 8
</span><span class="lnt"> 9
</span><span class="lnt">10
</span><span class="lnt">11
</span><span class="lnt">12
</span><span class="lnt">13
</span><span class="lnt">14
</span><span class="lnt">15
</span><span class="lnt">16
</span><span class="lnt">17
</span><span class="lnt">18
</span><span class="lnt">19
</span><span class="lnt">20
</span><span class="lnt">21
</span><span class="lnt">22
</span><span class="lnt">23
</span><span class="lnt">24
</span><span class="lnt">25
</span><span class="lnt">26
</span><span class="lnt">27
</span><span class="lnt">28
</span><span class="lnt">29
</span><span class="lnt">30
</span></code></pre></td>
<td class="lntd">
<pre tabindex="0" class="chroma"><code class="language-nix" data-lang="nix"><span class="line"><span class="cl"> <span class="n">devShell</span> <span class="err">=</span> <span class="n">pkgs</span><span class="o">.</span><span class="n">mkShell</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">	<span class="n">nativeBuildInputs</span> <span class="o">=</span> <span class="k">with</span> <span class="n">pkgs</span><span class="o">.</span><span class="n">ocamlPackages</span><span class="p">;</span> <span class="p">[</span> <span class="n">cppo</span> <span class="n">findlib</span> <span class="p">];</span>
</span></span><span class="line"><span class="cl">	<span class="n">buildInputs</span> <span class="o">=</span> <span class="k">with</span> <span class="n">pkgs</span><span class="p">;</span> <span class="p">[</span>
</span></span><span class="line"><span class="cl">	  <span class="n">packages</span>
</span></span><span class="line"><span class="cl">	  <span class="n">caddy</span> <span class="c1"># Add Caddy as a local http server</span>
</span></span><span class="line"><span class="cl">	<span class="p">];</span>
</span></span><span class="line"><span class="cl">	
</span></span><span class="line"><span class="cl">	<span class="n">shellHook</span> <span class="o">=</span> <span class="s1">''
</span></span></span><span class="line"><span class="cl"><span class="s1">	  echo &quot;Welcome to your ocamlbyexample dev environment!&quot;
</span></span></span><span class="line"><span class="cl"><span class="s1">	  echo &quot;Run 'dune build' to build the project. Or during development run 'dune build -w' for re-building on change.&quot;
</span></span></span><span class="line"><span class="cl"><span class="s1">	
</span></span></span><span class="line"><span class="cl"><span class="s1">	  # Write a Caddyfile if it does not exist
</span></span></span><span class="line"><span class="cl"><span class="s1">	  echo &quot;Writing Caddyfile...&quot;
</span></span></span><span class="line"><span class="cl"><span class="s1">	  if [ ! -f Caddyfile ]; then
</span></span></span><span class="line"><span class="cl"><span class="s1">	    echo &quot;
</span></span></span><span class="line"><span class="cl"><span class="s1">	    :3333 {
</span></span></span><span class="line"><span class="cl"><span class="s1">	      root * _build/default/ocamlbyexample/dist
</span></span></span><span class="line"><span class="cl"><span class="s1">	      file_server browse
</span></span></span><span class="line"><span class="cl"><span class="s1">	    }&quot; &gt; Caddyfile
</span></span></span><span class="line"><span class="cl"><span class="s1">	    echo &quot;Caddyfile written.&quot;
</span></span></span><span class="line"><span class="cl"><span class="s1">	  fi
</span></span></span><span class="line"><span class="cl"><span class="s1">	
</span></span></span><span class="line"><span class="cl"><span class="s1">	  echo &quot;Starting Caddy server on http://localhost:3333&quot;
</span></span></span><span class="line"><span class="cl"><span class="s1">	  # Start Caddy in the background and trap exit to kill it
</span></span></span><span class="line"><span class="cl"><span class="s1">	  caddy start --config ./Caddyfile --adapter caddyfile
</span></span></span><span class="line"><span class="cl"><span class="s1">	  trap &quot;pkill -9 caddy&quot; EXIT
</span></span></span><span class="line"><span class="cl"><span class="s1">	
</span></span></span><span class="line"><span class="cl"><span class="s1">	  echo &quot;There is a Caddy server running on port 3333 (http://localhost:3333) which is hosting the project&quot;
</span></span></span><span class="line"><span class="cl"><span class="s1">	''</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">	<span class="p">};</span>
</span></span></code></pre></td></tr></table>
</div>
</div><p>This implies that the developer only needs to execute <code>dune build</code> to generate CSS, HTML, and JS files, and then preview the changes at <code>http://localhost:3333</code>.</p>
<h2>Building for production</h2>
<p>The advantage of using &rsquo;nix&rsquo; is that it enables me to build the project both locally and in the CI using <code>nix build</code>. This ensures consistent output, simplifying the entire build process in the CI.</p>
<p>Previously, I had to install opam, ocaml, make a switch, and install the library. Now, all these steps are replaced with a simple <code>nix build</code>. Here is my configuration for <code>nix build</code>:</p>
<div class="highlight"><div class="chroma">
<table class="lntable"><tr><td class="lntd">
<pre tabindex="0" class="chroma"><code><span class="lnt"> 1
</span><span class="lnt"> 2
</span><span class="lnt"> 3
</span><span class="lnt"> 4
</span><span class="lnt"> 5
</span><span class="lnt"> 6
</span><span class="lnt"> 7
</span><span class="lnt"> 8
</span><span class="lnt"> 9
</span><span class="lnt">10
</span><span class="lnt">11
</span><span class="lnt">12
</span><span class="lnt">13
</span><span class="lnt">14
</span><span class="lnt">15
</span></code></pre></td>
<td class="lntd">
<pre tabindex="0" class="chroma"><code class="language-nix" data-lang="nix"><span class="line"><span class="cl"><span class="n">defaultPackage</span> <span class="err">=</span> <span class="n">pkgs</span><span class="o">.</span><span class="n">stdenv</span><span class="o">.</span><span class="n">mkDerivation</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">  <span class="n">name</span> <span class="o">=</span> <span class="s2">&quot;ocamlbyexample&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">  <span class="n">src</span> <span class="o">=</span> <span class="sr">./.</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">  <span class="n">nativeBuildInputs</span> <span class="o">=</span> <span class="k">with</span> <span class="n">pkgs</span><span class="o">.</span><span class="n">ocamlPackages</span><span class="p">;</span> <span class="p">[</span> <span class="n">cppo</span> <span class="n">findlib</span> <span class="p">];</span>
</span></span><span class="line"><span class="cl">  <span class="n">buildInputs</span> <span class="o">=</span> <span class="k">with</span> <span class="n">pkgs</span><span class="p">;</span> <span class="p">[</span>
</span></span><span class="line"><span class="cl">    <span class="n">packages</span>
</span></span><span class="line"><span class="cl">  <span class="p">];</span>
</span></span><span class="line"><span class="cl">  <span class="n">buildPhase</span> <span class="o">=</span> <span class="s1">''
</span></span></span><span class="line"><span class="cl"><span class="s1">    dune build
</span></span></span><span class="line"><span class="cl"><span class="s1">  ''</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">
</span></span><span class="line"><span class="cl">  <span class="n">installPhase</span> <span class="o">=</span> <span class="s1">''
</span></span></span><span class="line"><span class="cl"><span class="s1">    cp -r _build/default/ocamlbyexample/dist $out
</span></span></span><span class="line"><span class="cl"><span class="s1">  ''</span><span class="p">;</span>
</span></span><span class="line"><span class="cl"><span class="p">};</span>
</span></span></code></pre></td></tr></table>
</div>
</div><p>This means I can directly use the files in the <code>result</code> folder, created by <code>nix build</code>, and publish them to my CDN.</p>
<h2>The end</h2>
<p>Will I use Nix for all my OCaml projects? Not likely, as using Nix can sometimes seem excessive for small, short-term projects. Additionally, the team building Dune is adding package management, which I might use. However, I appreciate the simplicity of <code>nix build</code> in continuous integration (CI).</p>
<p>While not all packages are available on Nix, there&rsquo;s a concerted effort to increase the number of libraries installable with Nix Flakes. For example, there&rsquo;s now a <code>flake.nix</code> in the <a href="https://github.com/riot-ml/riot">Riot GitHub repo</a> that we can use to add Riot to our stack.</p>
<p>The only downside i&rsquo;ve found so far is that it sometimes take some time to setup a new dev environment when running <code>nix develop</code>.</p>
<p>I hope this article was inspiring. If you wish to contact or follow me, you can do so on Twitter: <a href="https://twitter.com/emil_priver">https://twitter.com/emil_priver</a></p>

