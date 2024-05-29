---
title: From Computer to Production With Nix
description: Article developing a flake.nix that you can use for development, testing
  and building for production releases
url: https://priver.dev/blog/nix/from-computer-to-production-with-nix/
date: 2024-05-22T00:58:21-00:00
preview_image: https://priver.dev/images/ocaml.jpeg
authors:
- "Emil Priv\xE9r"
source:
---

<p>A while ago, I wrote &ldquo;<a href="https://priver.dev/blog/ocaml/bye-opam-hello-nix/">Bye Opam, Hello Nix</a>&rdquo; where the topic of that post was that I replaced Opam with Nix as it works much better. This post is about taking this a bit further, discussing how I use Nix for local development, testing, and building Docker images.</p>
<p>The core concept of Nix is &ldquo;reproducible builds,&rdquo; which means that &ldquo;it works on my machine&rdquo; is actually true. The idea of Nix is that you should be able to make an exact copy of something and send it to someone else&rsquo;s computer, and they should get the same environment. The good thing about this is that we can extend it further to the cloud by building Docker images.</p>
<p>Even if Docker&rsquo;s goal was to also solve the &ldquo;it works on my machine&rdquo; problem, it only does so to a certain level as it is theoretically possible to change the content of a tag (I guess that you also tag a new <code>latest</code> image ;) ? ) by building a new image and pushing it to the same tag.</p>
<p>

  <picture>
    <source media="(max-width: 640px)" srcset="/images/nix/star-wars-meme_huba2b610da43f242ce085fde436aa1825_321388_1280x0_resize_q100_h2_box.webp" type="image/webp" loading="lazy">
    <source media="(min-width: 640px)" srcset="/images/nix/star-wars-meme_huba2b610da43f242ce085fde436aa1825_321388_1920x0_resize_q100_h2_box.webp" type="image/webp" loading="lazy">

    <img src="https://priver.dev/images/nix/star-wars-meme_huba2b610da43f242ce085fde436aa1825_321388_1280x0_resize_q100_box.jpg" srcset="/images/nix/star-wars-meme_huba2b610da43f242ce085fde436aa1825_321388_1280x0_resize_q100_box.jpg 640w, /images/nix/star-wars-meme_huba2b610da43f242ce085fde436aa1825_321388_1920x0_resize_q100_box.jpg 800w" sizes="(max-width: 640px) 640px, 800px" loading="lazy" width="1280" alt="From Computer to Production With Nix"/>
  </source></source></picture></p>
<p>Another thing I like about Nix is that it allows me to create a copy of my machine and send it to production. I can create layers, import them using Docker, and then tag and push them to my registry.</p>
<p>This specific post was written after working with and using Nix at work. However, the code in this post won&rsquo;t be work-related, but I will show code that accomplishes the same task in OCaml instead of Python.</p>
<p>The problems I wanted to solve at work were:</p>
<ol>
<li>Making it easy for our data team to develop in a shared project.</li>
<li>Being able to create a copy of my machine and move it to the cloud.</li>
<li>Making it easier for us in CI and CD steps by preventing CI failures due to missing tools not being installed on the runner, and so on.</li>
</ol>
<p>In this article, we will create a new basic setup for an OCaml project using Nix for building and development. The initial code will be as follows, and it will also be available at <a href="https://github.com/emilpriver/ocaml-nix-template">https://github.com/emilpriver/ocaml-nix-template</a></p>
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
</span></code></pre></td>
<td class="lntd">
<pre tabindex="0" class="chroma"><code class="language-nix" data-lang="nix"><span class="line"><span class="cl"><span class="p">{</span>
</span></span><span class="line"><span class="cl">  <span class="n">description</span> <span class="o">=</span> <span class="s2">&quot;Nix and Ocaml template&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">
</span></span><span class="line"><span class="cl">  <span class="n">inputs</span> <span class="o">=</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">    <span class="n">nixpkgs</span><span class="o">.</span><span class="n">url</span> <span class="o">=</span> <span class="s2">&quot;github:NixOS/nixpkgs/nixos-unstable&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">  <span class="p">};</span>
</span></span><span class="line"><span class="cl">
</span></span><span class="line"><span class="cl">  <span class="n">outputs</span> <span class="o">=</span> <span class="n">inputs</span><span class="o">@</span><span class="p">{</span> <span class="n">flake-parts</span><span class="o">,</span> <span class="o">...</span> <span class="p">}:</span>
</span></span><span class="line"><span class="cl">    <span class="n">flake-parts</span><span class="o">.</span><span class="n">lib</span><span class="o">.</span><span class="n">mkFlake</span> <span class="p">{</span> <span class="k">inherit</span> <span class="n">inputs</span><span class="p">;</span> <span class="p">}</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">      <span class="n">systems</span> <span class="o">=</span> <span class="p">[</span> <span class="s2">&quot;x86_64-linux&quot;</span> <span class="s2">&quot;aarch64-linux&quot;</span> <span class="s2">&quot;aarch64-darwin&quot;</span> <span class="s2">&quot;x86_64-darwin&quot;</span> <span class="p">];</span>
</span></span><span class="line"><span class="cl">      <span class="n">perSystem</span> <span class="o">=</span> <span class="p">{</span> <span class="n">config</span><span class="o">,</span> <span class="n">self'</span><span class="o">,</span> <span class="n">inputs'</span><span class="o">,</span> <span class="n">pkgs</span><span class="o">,</span> <span class="n">system</span><span class="o">,</span> <span class="o">...</span> <span class="p">}:</span>
</span></span><span class="line"><span class="cl">        <span class="k">let</span>
</span></span><span class="line"><span class="cl">          <span class="n">version</span> <span class="o">=</span> <span class="s2">&quot;0.0.1&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">        <span class="k">in</span>
</span></span><span class="line"><span class="cl">        <span class="p">{</span>
</span></span><span class="line"><span class="cl">          <span class="n">devShells</span> <span class="o">=</span> <span class="p">{};</span>
</span></span><span class="line"><span class="cl">          <span class="n">packages</span> <span class="o">=</span> <span class="p">{};</span>
</span></span><span class="line"><span class="cl">          <span class="n">formatter</span> <span class="o">=</span> <span class="n">pkgs</span><span class="o">.</span><span class="n">nixpkgs-fmt</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">        <span class="p">};</span>
</span></span><span class="line"><span class="cl">    <span class="p">};</span>
</span></span><span class="line"><span class="cl"><span class="p">}</span>
</span></span></code></pre></td></tr></table>
</div>
</div><p>The code in this Nix config is for building OCaml projects, so there will be OCaml related code in the config. However, you can customize your config to suit the language and the tools you work with.</p>
<p>The content of this config informs us that we can&rsquo;t use the unstable channel of Nix packages, as it often provides us with newer versions of packages. We also define the systems for which we will build, due to Riot not supporting Windows. Additionally, we create an empty devShells and packages config, which we will populate later. We also specify the formatter we want to use with Nix.</p>
<p>It&rsquo;s important to note that this article is based on <code>nix flakes</code>, which you can read more about here: <a href="https://shopify.engineering/what-is-nix">https://shopify.engineering/what-is-nix</a></p>
<h2>Development environment</h2>
<p>The first thing I wanted to fix is the development environment for everyone working on the project. The goal is to simplify the setup for those who want to contribute to the project and to achieve the magical &ldquo;one command to get up and running&rdquo; situation. This is something we can easily accomplish with Nix.</p>
<p>The first thing we need to do is define our package by adding the content below to our flake.nix.</p>
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
</span></code></pre></td>
<td class="lntd">
<pre tabindex="0" class="chroma"><code class="language-nix" data-lang="nix"><span class="line"><span class="cl"><span class="n">packages</span> <span class="err">=</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">  <span class="n">default</span> <span class="o">=</span> <span class="n">buildDunePackage</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">    <span class="k">inherit</span> <span class="n">version</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">    <span class="n">pname</span> <span class="o">=</span> <span class="s2">&quot;nix_template&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">    <span class="n">buildInputs</span> <span class="o">=</span> <span class="p">[</span>
</span></span><span class="line"><span class="cl">      <span class="n">inputs'</span><span class="o">.</span><span class="n">riot</span><span class="o">.</span><span class="n">packages</span><span class="o">.</span><span class="n">default</span>
</span></span><span class="line"><span class="cl">    <span class="p">];</span>
</span></span><span class="line"><span class="cl">    <span class="c1"># Tell nix that the source of the content is in the root</span>
</span></span><span class="line"><span class="cl">    <span class="n">src</span> <span class="o">=</span> <span class="sr">./.</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">  <span class="p">};</span>
</span></span><span class="line"><span class="cl"><span class="p">};</span>
</span></span></code></pre></td></tr></table>
</div>
</div><p>Here, I tell Nix that I want to build a dune package and that I need Riot, which is added to inputs:</p>
<div class="highlight"><div class="chroma">
<table class="lntable"><tr><td class="lntd">
<pre tabindex="0" class="chroma"><code><span class="lnt">1
</span><span class="lnt">2
</span><span class="lnt">3
</span><span class="lnt">4
</span><span class="lnt">5
</span><span class="lnt">6
</span><span class="lnt">7
</span></code></pre></td>
<td class="lntd">
<pre tabindex="0" class="chroma"><code class="language-nix" data-lang="nix"><span class="line"><span class="cl"><span class="n">inputs</span> <span class="err">=</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">  <span class="n">nixpkgs</span><span class="o">.</span><span class="n">url</span> <span class="o">=</span> <span class="s2">&quot;github:NixOS/nixpkgs/nixos-unstable&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">  <span class="n">riot</span> <span class="o">=</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">    <span class="n">url</span> <span class="o">=</span> <span class="s2">&quot;github:emilpriver/riot&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">    <span class="n">inputs</span><span class="o">.</span><span class="n">nixpkgs</span><span class="o">.</span><span class="n">follows</span> <span class="o">=</span> <span class="s2">&quot;nixpkgs&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">  <span class="p">};</span>
</span></span><span class="line"><span class="cl"><span class="p">};</span>
</span></span></code></pre></td></tr></table>
</div>
</div><p>This also makes it possible for me to add our dev shell by adding this:</p>
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
</span></code></pre></td>
<td class="lntd">
<pre tabindex="0" class="chroma"><code class="language-nix" data-lang="nix"><span class="line"><span class="cl"><span class="n">devShells</span> <span class="err">=</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">  <span class="n">default</span> <span class="o">=</span> <span class="n">mkShell</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">	  <span class="c1"># Add packages I need for my dev shell</span>
</span></span><span class="line"><span class="cl">    <span class="n">buildInputs</span> <span class="o">=</span> <span class="p">[</span>
</span></span><span class="line"><span class="cl">      <span class="n">ocamlPackages</span><span class="o">.</span><span class="n">dune_3</span>
</span></span><span class="line"><span class="cl">      <span class="n">ocamlPackages</span><span class="o">.</span><span class="n">ocaml</span>
</span></span><span class="line"><span class="cl">      <span class="n">ocamlPackages</span><span class="o">.</span><span class="n">utop</span>
</span></span><span class="line"><span class="cl">      <span class="n">ocamlPackages</span><span class="o">.</span><span class="n">ocamlformat</span>
</span></span><span class="line"><span class="cl">    <span class="p">];</span>
</span></span><span class="line"><span class="cl">    <span class="c1"># Also include inputs from the default package</span>
</span></span><span class="line"><span class="cl">    <span class="n">inputsFrom</span> <span class="o">=</span> <span class="p">[</span>
</span></span><span class="line"><span class="cl">      <span class="n">self'</span><span class="o">.</span><span class="n">packages</span><span class="o">.</span><span class="n">default</span>
</span></span><span class="line"><span class="cl">    <span class="p">];</span>
</span></span><span class="line"><span class="cl">    <span class="n">packages</span> <span class="o">=</span> <span class="nb">builtins</span><span class="o">.</span><span class="n">attrValues</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">      <span class="k">inherit</span> <span class="p">(</span><span class="n">pkgs</span><span class="p">)</span> <span class="n">clang_17</span> <span class="n">clang-tools_17</span> <span class="n">pkg-config</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">      <span class="k">inherit</span> <span class="p">(</span><span class="n">ocamlPackages</span><span class="p">)</span> <span class="n">ocaml-lsp</span> <span class="n">ocamlformat-rpc-lib</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">    <span class="p">};</span>
</span></span><span class="line"><span class="cl">    <span class="n">dontDetectOcamlConflicts</span> <span class="o">=</span> <span class="no">true</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">  <span class="p">};</span>
</span></span><span class="line"><span class="cl"><span class="p">};</span>
</span></span></code></pre></td></tr></table>
</div>
</div><p>So, what we have done now is that we have created a package called &ldquo;nix_template&rdquo; which we use as input within our devShell. So, when we run <code>nix develop</code>, we now get everything the <code>nix_template</code> needs and we get the necessary tools we need to develop, such as LSP, dune, and ocamlformat.</p>
<p>This means that we are now working with a configuration like this:</p>
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
</span><span class="lnt">40
</span><span class="lnt">41
</span><span class="lnt">42
</span><span class="lnt">43
</span><span class="lnt">44
</span><span class="lnt">45
</span><span class="lnt">46
</span><span class="lnt">47
</span><span class="lnt">48
</span><span class="lnt">49
</span><span class="lnt">50
</span><span class="lnt">51
</span><span class="lnt">52
</span><span class="lnt">53
</span></code></pre></td>
<td class="lntd">
<pre tabindex="0" class="chroma"><code class="language-nix" data-lang="nix"><span class="line"><span class="cl"><span class="p">{</span>
</span></span><span class="line"><span class="cl">  <span class="n">description</span> <span class="o">=</span> <span class="s2">&quot;Nix and Ocaml template&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">
</span></span><span class="line"><span class="cl">  <span class="n">inputs</span> <span class="o">=</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">    <span class="n">nixpkgs</span><span class="o">.</span><span class="n">url</span> <span class="o">=</span> <span class="s2">&quot;github:NixOS/nixpkgs/nixos-unstable&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">    <span class="n">riot</span> <span class="o">=</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">      <span class="n">url</span> <span class="o">=</span> <span class="s2">&quot;github:emilpriver/riot&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">      <span class="n">inputs</span><span class="o">.</span><span class="n">nixpkgs</span><span class="o">.</span><span class="n">follows</span> <span class="o">=</span> <span class="s2">&quot;nixpkgs&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">    <span class="p">};</span>
</span></span><span class="line"><span class="cl">  <span class="p">};</span>
</span></span><span class="line"><span class="cl">
</span></span><span class="line"><span class="cl">  <span class="n">outputs</span> <span class="o">=</span> <span class="n">inputs</span><span class="o">@</span><span class="p">{</span> <span class="n">flake-parts</span><span class="o">,</span> <span class="o">...</span> <span class="p">}:</span>
</span></span><span class="line"><span class="cl">    <span class="n">flake-parts</span><span class="o">.</span><span class="n">lib</span><span class="o">.</span><span class="n">mkFlake</span> <span class="p">{</span> <span class="k">inherit</span> <span class="n">inputs</span><span class="p">;</span> <span class="p">}</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">      <span class="n">systems</span> <span class="o">=</span> <span class="p">[</span> <span class="s2">&quot;x86_64-linux&quot;</span> <span class="s2">&quot;aarch64-linux&quot;</span> <span class="s2">&quot;aarch64-darwin&quot;</span> <span class="s2">&quot;x86_64-darwin&quot;</span> <span class="p">];</span>
</span></span><span class="line"><span class="cl">      <span class="n">perSystem</span> <span class="o">=</span> <span class="p">{</span> <span class="n">config</span><span class="o">,</span> <span class="n">self'</span><span class="o">,</span> <span class="n">inputs'</span><span class="o">,</span> <span class="n">pkgs</span><span class="o">,</span> <span class="n">system</span><span class="o">,</span> <span class="o">...</span> <span class="p">}:</span>
</span></span><span class="line"><span class="cl">        <span class="k">let</span>
</span></span><span class="line"><span class="cl">          <span class="k">inherit</span> <span class="p">(</span><span class="n">pkgs</span><span class="p">)</span> <span class="n">ocamlPackages</span> <span class="n">mkShell</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">          <span class="k">inherit</span> <span class="p">(</span><span class="n">ocamlPackages</span><span class="p">)</span> <span class="n">buildDunePackage</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">          <span class="n">version</span> <span class="o">=</span> <span class="s2">&quot;0.0.1+dev&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">        <span class="k">in</span>
</span></span><span class="line"><span class="cl">        <span class="p">{</span>
</span></span><span class="line"><span class="cl">          <span class="n">devShells</span> <span class="o">=</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">            <span class="n">default</span> <span class="o">=</span> <span class="n">mkShell</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">              <span class="n">buildInputs</span> <span class="o">=</span> <span class="p">[</span>
</span></span><span class="line"><span class="cl">                <span class="n">ocamlPackages</span><span class="o">.</span><span class="n">dune_3</span>
</span></span><span class="line"><span class="cl">                <span class="n">ocamlPackages</span><span class="o">.</span><span class="n">ocaml</span>
</span></span><span class="line"><span class="cl">                <span class="n">ocamlPackages</span><span class="o">.</span><span class="n">utop</span>
</span></span><span class="line"><span class="cl">                <span class="n">ocamlPackages</span><span class="o">.</span><span class="n">ocamlformat</span>
</span></span><span class="line"><span class="cl">              <span class="p">];</span>
</span></span><span class="line"><span class="cl">              <span class="n">inputsFrom</span> <span class="o">=</span> <span class="p">[</span>
</span></span><span class="line"><span class="cl">                <span class="n">self'</span><span class="o">.</span><span class="n">packages</span><span class="o">.</span><span class="n">default</span>
</span></span><span class="line"><span class="cl">              <span class="p">];</span>
</span></span><span class="line"><span class="cl">              <span class="n">packages</span> <span class="o">=</span> <span class="nb">builtins</span><span class="o">.</span><span class="n">attrValues</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">                <span class="k">inherit</span> <span class="p">(</span><span class="n">pkgs</span><span class="p">)</span> <span class="n">clang_17</span> <span class="n">clang-tools_17</span> <span class="n">pkg-config</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">                <span class="k">inherit</span> <span class="p">(</span><span class="n">ocamlPackages</span><span class="p">)</span> <span class="n">ocaml-lsp</span> <span class="n">ocamlformat-rpc-lib</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">              <span class="p">};</span>
</span></span><span class="line"><span class="cl">              <span class="n">dontDetectOcamlConflicts</span> <span class="o">=</span> <span class="no">true</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">            <span class="p">};</span>
</span></span><span class="line"><span class="cl">          <span class="p">};</span>
</span></span><span class="line"><span class="cl">          <span class="n">packages</span> <span class="o">=</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">            <span class="n">default</span> <span class="o">=</span> <span class="n">buildDunePackage</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">              <span class="k">inherit</span> <span class="n">version</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">              <span class="n">pname</span> <span class="o">=</span> <span class="s2">&quot;nix_template&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">              <span class="n">buildInputs</span> <span class="o">=</span> <span class="p">[</span>
</span></span><span class="line"><span class="cl">                <span class="n">inputs'</span><span class="o">.</span><span class="n">riot</span><span class="o">.</span><span class="n">packages</span><span class="o">.</span><span class="n">default</span>
</span></span><span class="line"><span class="cl">              <span class="p">];</span>
</span></span><span class="line"><span class="cl">              <span class="n">src</span> <span class="o">=</span> <span class="sr">./.</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">            <span class="p">};</span>
</span></span><span class="line"><span class="cl">          <span class="p">};</span>
</span></span><span class="line"><span class="cl">          <span class="n">formatter</span> <span class="o">=</span> <span class="n">pkgs</span><span class="o">.</span><span class="n">nixpkgs-fmt</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">        <span class="p">};</span>
</span></span><span class="line"><span class="cl">    <span class="p">};</span>
</span></span><span class="line"><span class="cl"><span class="p">}</span>
</span></span></code></pre></td></tr></table>
</div>
</div><h2>Running tests</h2>
<p>When working with Nix, I prefer to use it for running the necessary tools both locally and in the CI. This helps prevent discrepancies between local and CI environments. It also simplifies the process for others to run tests locally; they only need to execute a single command to replicate my setup. For example, I like to run my tests using Nix. It allows me to run the tests, including setting up everything I need such as Docker, with just one command.</p>
<p>Let&rsquo;s add some code into the <code>packages</code> object in our flake.nix.</p>
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
</span></code></pre></td>
<td class="lntd">
<pre tabindex="0" class="chroma"><code class="language-nix" data-lang="nix"><span class="line"><span class="cl"><span class="n">test</span> <span class="err">=</span> <span class="n">pkgs</span><span class="o">.</span><span class="n">stdenv</span><span class="o">.</span><span class="n">mkDerivation</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">  <span class="n">name</span> <span class="o">=</span> <span class="s2">&quot;ocaml-test&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">  <span class="n">buildInputs</span> <span class="o">=</span> <span class="p">[</span>
</span></span><span class="line"><span class="cl">    <span class="n">ocamlPackages</span><span class="o">.</span><span class="n">dune_3</span>
</span></span><span class="line"><span class="cl">    <span class="n">ocamlPackages</span><span class="o">.</span><span class="n">ocaml</span>
</span></span><span class="line"><span class="cl">    <span class="n">ocamlPackages</span><span class="o">.</span><span class="n">utop</span>
</span></span><span class="line"><span class="cl">    <span class="n">ocamlPackages</span><span class="o">.</span><span class="n">ocamlformat</span>
</span></span><span class="line"><span class="cl">    <span class="n">ocamlPackages</span><span class="o">.</span><span class="n">ounit2</span>
</span></span><span class="line"><span class="cl">  <span class="p">];</span>
</span></span><span class="line"><span class="cl">  <span class="n">inputsFrom</span> <span class="o">=</span> <span class="p">[</span>
</span></span><span class="line"><span class="cl">    <span class="n">self'</span><span class="o">.</span><span class="n">packages</span><span class="o">.</span><span class="n">default</span>
</span></span><span class="line"><span class="cl">  <span class="p">];</span>
</span></span><span class="line"><span class="cl">  <span class="n">src</span> <span class="o">=</span> <span class="sr">./.</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">  <span class="n">buildPhase</span> <span class="o">=</span> <span class="s1">''
</span></span></span><span class="line"><span class="cl"><span class="s1">    dune runtest
</span></span></span><span class="line"><span class="cl"><span class="s1">  ''</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">  <span class="n">doCheck</span> <span class="o">=</span> <span class="no">true</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">  <span class="c1">## Create and output the result. for instance the coverage.txt</span>
</span></span><span class="line"><span class="cl">  <span class="n">installPhase</span> <span class="o">=</span> <span class="s1">''
</span></span></span><span class="line"><span class="cl"><span class="s1">    mkdir -p $out
</span></span></span><span class="line"><span class="cl"><span class="s1">    touch $out/coverage.txt
</span></span></span><span class="line"><span class="cl"><span class="s1">    echo &quot;I am the coverage of the test&quot; &gt; $out/coverage.txt 
</span></span></span><span class="line"><span class="cl"><span class="s1">  ''</span><span class="p">;</span>
</span></span><span class="line"><span class="cl"><span class="p">};</span>
</span></span></code></pre></td></tr></table>
</div>
</div><p>In the code provided, we create a new package named <code>test</code>. This executes <code>dune runtest</code> to verify our code. To run our tests in the CI or locally, we use <code>nix build '#.packages.x86_64-linux.test</code>. This method could potentially eliminate the need for installing tools directly in the CI and running tests, replacing all of it with a single Nix command. Including Docker as a package and running a Docker container in the buildPhase is also possible.</p>
<p>This is just one effective method I&rsquo;ve discovered during my workflows, but there are other ways to achieve this as well.</p>
<p>Additionally, you can execute tasks like linting or security checks. To do this, replace <code>dune runtest</code> with the necessary command. Then, add the output, such as coverage, to the <code>$out</code> folder so you can read it later.</p>
<p>I have tried to use Nix apps for this type of task, but I have always fallen back to just adding a new package and building a package as it has always been simpler for me.</p>
<h2>Building for release</h2>
<p>So, time for building for release and this is the part where we make a optimized build which we can send out to production. How this works will depend on what you want to achieve but I will cover 2 common ways of building for release which is either docker image or building the binary.</p>
<h3>Building the Binary</h3>
<p>To enable binary building, we only need to add a <code>buildPhase</code> and an <code>installPhase</code> to our default package used for building. This makes our definition appear as follows:</p>
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
</span></code></pre></td>
<td class="lntd">
<pre tabindex="0" class="chroma"><code class="language-nix" data-lang="nix"><span class="line"><span class="cl"><span class="n">default</span> <span class="err">=</span> <span class="n">buildDunePackage</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">  <span class="k">inherit</span> <span class="n">version</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">  <span class="n">pname</span> <span class="o">=</span> <span class="s2">&quot;nix_template&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">  <span class="n">buildInputs</span> <span class="o">=</span> <span class="p">[</span>
</span></span><span class="line"><span class="cl">    <span class="n">inputs'</span><span class="o">.</span><span class="n">riot</span><span class="o">.</span><span class="n">packages</span><span class="o">.</span><span class="n">default</span>
</span></span><span class="line"><span class="cl">  <span class="p">];</span>
</span></span><span class="line"><span class="cl">  <span class="n">src</span> <span class="o">=</span> <span class="sr">./.</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">  <span class="c1">## Execute the build</span>
</span></span><span class="line"><span class="cl">  <span class="n">buildPhase</span> <span class="o">=</span> <span class="s1">''
</span></span></span><span class="line"><span class="cl"><span class="s1">    dune build
</span></span></span><span class="line"><span class="cl"><span class="s1">  ''</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">  <span class="n">doCheck</span> <span class="o">=</span> <span class="no">true</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">  <span class="c1">## Copy the binary to $out</span>
</span></span><span class="line"><span class="cl">  <span class="n">installPhase</span> <span class="o">=</span> <span class="s1">''
</span></span></span><span class="line"><span class="cl"><span class="s1">    mkdir $out
</span></span></span><span class="line"><span class="cl"><span class="s1">    cp _build/default/bin/main.exe $out
</span></span></span><span class="line"><span class="cl"><span class="s1">  ''</span><span class="p">;</span>
</span></span><span class="line"><span class="cl"><span class="p">};</span>
</span></span></code></pre></td></tr></table>
</div>
</div><p>This implies that when we construct the project using <code>nix build '#.packages.x86_64-linux.default'</code>, we are building the project in an isolated sandbox environment and returning only the required binary. For example, the <code>result</code> folder now includes:</p>
<div class="highlight"><div class="chroma">
<table class="lntable"><tr><td class="lntd">
<pre tabindex="0" class="chroma"><code><span class="lnt">1
</span><span class="lnt">2
</span><span class="lnt">3
</span></code></pre></td>
<td class="lntd">
<pre tabindex="0" class="chroma"><code class="language-bash" data-lang="bash"><span class="line"><span class="cl">&#8906;&gt; ~/C/O/ocaml-nix-template on main &#10799; ls -al result/                                                                                                                                                                                                         
</span></span><span class="line"><span class="cl">-r-xr-xr-x    <span class="m">1</span> root root   <span class="m">7960208</span> Jan  <span class="m">1</span>  <span class="m">1970</span> main.exe*
</span></span><span class="line"><span class="cl">dr-xr-xr-x    <span class="m">2</span> root root      <span class="m">4096</span> Jan  <span class="m">1</span>  <span class="m">1970</span> nix-support/
</span></span></code></pre></td></tr></table>
</div>
</div><p>Here, main.exe is the binary we built.</p>
<h3>Building a docker image</h3>
<p>Another way to achieve a release is by building a docker image layers using nix that we later import into docker to make it possible to run it. The benefit of this is that we get a reproducible docker as we don&rsquo;t use <code>Dockerfile</code> to build our image and that we can reuse a lof of the existing code to build the image and the way we achieve this is by creating a new <code>package</code> where I in this case call this  <code>dockerImage</code></p>
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
</span></code></pre></td>
<td class="lntd">
<pre tabindex="0" class="chroma"><code class="language-bash" data-lang="bash"><span class="line"><span class="cl"><span class="nv">dockerImage</span> <span class="o">=</span> pkgs.dockerTools.buildLayeredImage <span class="o">{</span>
</span></span><span class="line"><span class="cl">  <span class="nv">name</span> <span class="o">=</span> <span class="s2">&quot;nix-template&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">  <span class="nv">tag</span> <span class="o">=</span> <span class="s2">&quot;0.0.1+dev&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">  <span class="nv">contents</span> <span class="o">=</span> <span class="o">[</span> self<span class="s1">'.packages.default ocamlPackages.ounit2 ];
</span></span></span><span class="line"><span class="cl"><span class="s1">  config = {
</span></span></span><span class="line"><span class="cl"><span class="s1">    Cmd = [ &quot;${self'</span>.packages.default<span class="o">}</span>/bin/main.exe<span class="s2">&quot; ];
</span></span></span><span class="line"><span class="cl"><span class="s2">    ExposedPorts = { &quot;</span>8000/tcp<span class="s2">&quot; = { }; };
</span></span></span><span class="line"><span class="cl"><span class="s2">    Env = [
</span></span></span><span class="line"><span class="cl"><span class="s2">      (&quot;</span><span class="nv">GITHUB_SHA</span><span class="o">=</span>123123<span class="s2">&quot;)
</span></span></span><span class="line"><span class="cl"><span class="s2">    ];
</span></span></span><span class="line"><span class="cl"><span class="s2">  };
</span></span></span><span class="line"><span class="cl"><span class="s2">};
</span></span></span></code></pre></td></tr></table>
</div>
</div><p>And to build our docker image now do we simply only need to run</p>
<div class="highlight"><div class="chroma">
<table class="lntable"><tr><td class="lntd">
<pre tabindex="0" class="chroma"><code><span class="lnt">1
</span></code></pre></td>
<td class="lntd">
<pre tabindex="0" class="chroma"><code class="language-bash" data-lang="bash"><span class="line"><span class="cl">nix --accept-flake-config build --impure <span class="s1">'.#packages.x86_64-linux.dockerImage'</span>
</span></span></code></pre></td></tr></table>
</div>
</div><p>And we can later on load the layers into docker</p>
<div class="highlight"><div class="chroma">
<table class="lntable"><tr><td class="lntd">
<pre tabindex="0" class="chroma"><code><span class="lnt">1
</span></code></pre></td>
<td class="lntd">
<pre tabindex="0" class="chroma"><code class="language-gdscript3" data-lang="gdscript3"><span class="line"><span class="cl"><span class="n">docker</span> <span class="nb">load</span> <span class="o">&lt;</span> <span class="o">./</span><span class="n">result</span>
</span></span></code></pre></td></tr></table>
</div>
</div><p>Afterwards, we can tag the image and distribute it. Quite convenient.</p>
<p>There are some tools specifically designed for this purpose, which are very useful. For example, <code>skopeo</code> can be used to tag and push an image to a container registry, such as in a GitHub action.</p>
<div class="highlight"><div class="chroma">
<table class="lntable"><tr><td class="lntd">
<pre tabindex="0" class="chroma"><code><span class="lnt">1
</span><span class="lnt">2
</span></code></pre></td>
<td class="lntd">
<pre tabindex="0" class="chroma"><code class="language-bash" data-lang="bash"><span class="line"><span class="cl"><span class="nb">echo</span> <span class="s2">&quot;</span><span class="si">${</span><span class="nv">DOCKER_PASSWORD</span><span class="si">}</span><span class="s2">&quot;</span> <span class="p">|</span> skopeo login -u <span class="si">${</span><span class="nv">DOCKER_USER</span><span class="si">}</span> --password-stdin <span class="si">${</span><span class="nv">DOCKER_REPO</span><span class="si">}</span>
</span></span><span class="line"><span class="cl">skopeo copy docker-archive://<span class="si">${</span><span class="nv">PWD</span><span class="si">}</span>/result docker://<span class="si">${</span><span class="nv">DOCKER_REPO</span><span class="si">}</span>/<span class="si">${</span><span class="nv">IMAGE_NAME</span><span class="si">}</span>:<span class="si">${</span><span class="nv">WF_IMAGE_TAG</span><span class="si">}</span>
</span></span></code></pre></td></tr></table>
</div>
</div><p>What Nix does when building a Docker image is that it replaces the Docker build system, often referred to as <code>Dockerfile</code>. Instead, we build layers that we then import into Docker.</p>
<h2>Adding a library that don&rsquo;t exist on nix packages</h2>
<p>Not all packages exist on <a href="https://search.nixos.org/packages">https://search.nixos.org/packages</a>, but it&rsquo;s not impossible to use that library if it doesn&rsquo;t. Under the hood, all the packages on the Nix packages page are just Nix configs that build projects, which means that it&rsquo;s possible to build projects directly from source as well. This is how I do it with the <code>random</code> package below:</p>
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
</span><span class="lnt">40
</span><span class="lnt">41
</span><span class="lnt">42
</span><span class="lnt">43
</span><span class="lnt">44
</span><span class="lnt">45
</span><span class="lnt">46
</span><span class="lnt">47
</span></code></pre></td>
<td class="lntd">
<pre tabindex="0" class="chroma"><code class="language-nix" data-lang="nix"><span class="line"><span class="cl"><span class="n">packages</span> <span class="err">=</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">  <span class="n">randomconv</span> <span class="o">=</span> <span class="n">buildDunePackage</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">	  <span class="n">version</span> <span class="o">=</span> <span class="s2">&quot;0.2.0&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">	  <span class="n">pname</span> <span class="o">=</span> <span class="s2">&quot;randomconv&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">	  <span class="n">src</span> <span class="o">=</span> <span class="n">pkgs</span><span class="o">.</span><span class="n">fetchFromGitHub</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">	    <span class="n">owner</span> <span class="o">=</span> <span class="s2">&quot;hannesm&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">	    <span class="n">repo</span> <span class="o">=</span> <span class="s2">&quot;randomconv&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">	    <span class="n">rev</span> <span class="o">=</span> <span class="s2">&quot;b2ce656d09738d676351f5a1c18aff0ff37a7dcc&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">	    <span class="n">hash</span> <span class="o">=</span> <span class="s2">&quot;sha256-KIvx/UNtPTg0EqfwuJgzSCtr6RgKIXK6yv9QkUUHbJk=&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">	  <span class="p">};</span>
</span></span><span class="line"><span class="cl">	  <span class="n">dontDetectOcamlConflicts</span> <span class="o">=</span> <span class="no">true</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">	<span class="p">};</span>
</span></span><span class="line"><span class="cl">	<span class="n">random</span> <span class="o">=</span> <span class="n">buildDunePackage</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">	  <span class="n">version</span> <span class="o">=</span> <span class="s2">&quot;0.0.1&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">	  <span class="n">pname</span> <span class="o">=</span> <span class="s2">&quot;random&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">	  <span class="n">src</span> <span class="o">=</span> <span class="n">pkgs</span><span class="o">.</span><span class="n">fetchFromGitHub</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">	    <span class="n">owner</span> <span class="o">=</span> <span class="s2">&quot;leostera&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">	    <span class="n">repo</span> <span class="o">=</span> <span class="s2">&quot;random&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">	    <span class="n">rev</span> <span class="o">=</span> <span class="s2">&quot;abb07c253dbc208219ac1983b34c78dab5fe93fd&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">	    <span class="n">hash</span> <span class="o">=</span> <span class="s2">&quot;sha256-dcJDuWE3qLEanu+TBBSeJPxxQvAN9eq88R5W3XMEGiA=&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">	  <span class="p">};</span>
</span></span><span class="line"><span class="cl">	  <span class="n">buildInputs</span> <span class="o">=</span> <span class="k">with</span> <span class="n">ocamlPackages</span><span class="p">;</span> <span class="p">[</span>
</span></span><span class="line"><span class="cl">	    <span class="n">mirage-crypto-rng</span>
</span></span><span class="line"><span class="cl">	    <span class="n">mirage-crypto</span>
</span></span><span class="line"><span class="cl">	    <span class="n">self'</span><span class="o">.</span><span class="n">packages</span><span class="o">.</span><span class="n">randomconv</span>
</span></span><span class="line"><span class="cl">	  <span class="p">];</span>
</span></span><span class="line"><span class="cl">	  <span class="n">dontDetectOcamlConflicts</span> <span class="o">=</span> <span class="no">true</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">	<span class="p">};</span>
</span></span><span class="line"><span class="cl">	<span class="n">default</span> <span class="o">=</span> <span class="n">buildDunePackage</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">	  <span class="k">inherit</span> <span class="n">version</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">	  <span class="n">pname</span> <span class="o">=</span> <span class="s2">&quot;nix_template&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">	  <span class="n">buildInputs</span> <span class="o">=</span> <span class="p">[</span>
</span></span><span class="line"><span class="cl">	    <span class="n">self'</span><span class="o">.</span><span class="n">packages</span><span class="o">.</span><span class="n">random</span>
</span></span><span class="line"><span class="cl">	    <span class="n">inputs'</span><span class="o">.</span><span class="n">riot</span><span class="o">.</span><span class="n">packages</span><span class="o">.</span><span class="n">default</span>
</span></span><span class="line"><span class="cl">	  <span class="p">];</span>
</span></span><span class="line"><span class="cl">	  <span class="n">src</span> <span class="o">=</span> <span class="sr">./.</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">	  <span class="n">buildPhase</span> <span class="o">=</span> <span class="s1">''
</span></span></span><span class="line"><span class="cl"><span class="s1">	    dune build
</span></span></span><span class="line"><span class="cl"><span class="s1">	  ''</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">	  <span class="n">doCheck</span> <span class="o">=</span> <span class="no">true</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">	  <span class="n">dontDetectOcamlConflicts</span> <span class="o">=</span> <span class="no">true</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">	  <span class="n">installPhase</span> <span class="o">=</span> <span class="s1">''
</span></span></span><span class="line"><span class="cl"><span class="s1">	    mkdir $out
</span></span></span><span class="line"><span class="cl"><span class="s1">	    cp _build/default/bin/main.exe $out
</span></span></span><span class="line"><span class="cl"><span class="s1">	  ''</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">	<span class="p">};</span>
</span></span><span class="line"><span class="cl"><span class="p">};</span>
</span></span></code></pre></td></tr></table>
</div>
</div><p>This now allows me to refer to this package in other packages to let Nix know that I need it and that it needs to build it for me.</p>
<blockquote>
<p>Something to keep in mind when you fetch from sources is that if you use something such as <code>builtins.fetchGit</code>, you use the host machine&rsquo;s ssh-agent while <code>pkgs.fetchFromGitHub</code> uses the sandbox environment&rsquo;s ssh-agent if it has any. This means that some requests don&rsquo;t work unless you either use something like <code>builtins.fetchGit</code> or add your ssh config during the build step.</p>
</blockquote>
<h2>The final flake.nix</h2>
<p>After all these configurations, we should now have a flake.nix file that matches the code below</p>
<div class="highlight"><div class="chroma">
<table class="lntable"><tr><td class="lntd">
<pre tabindex="0" class="chroma"><code><span class="lnt">  1
</span><span class="lnt">  2
</span><span class="lnt">  3
</span><span class="lnt">  4
</span><span class="lnt">  5
</span><span class="lnt">  6
</span><span class="lnt">  7
</span><span class="lnt">  8
</span><span class="lnt">  9
</span><span class="lnt"> 10
</span><span class="lnt"> 11
</span><span class="lnt"> 12
</span><span class="lnt"> 13
</span><span class="lnt"> 14
</span><span class="lnt"> 15
</span><span class="lnt"> 16
</span><span class="lnt"> 17
</span><span class="lnt"> 18
</span><span class="lnt"> 19
</span><span class="lnt"> 20
</span><span class="lnt"> 21
</span><span class="lnt"> 22
</span><span class="lnt"> 23
</span><span class="lnt"> 24
</span><span class="lnt"> 25
</span><span class="lnt"> 26
</span><span class="lnt"> 27
</span><span class="lnt"> 28
</span><span class="lnt"> 29
</span><span class="lnt"> 30
</span><span class="lnt"> 31
</span><span class="lnt"> 32
</span><span class="lnt"> 33
</span><span class="lnt"> 34
</span><span class="lnt"> 35
</span><span class="lnt"> 36
</span><span class="lnt"> 37
</span><span class="lnt"> 38
</span><span class="lnt"> 39
</span><span class="lnt"> 40
</span><span class="lnt"> 41
</span><span class="lnt"> 42
</span><span class="lnt"> 43
</span><span class="lnt"> 44
</span><span class="lnt"> 45
</span><span class="lnt"> 46
</span><span class="lnt"> 47
</span><span class="lnt"> 48
</span><span class="lnt"> 49
</span><span class="lnt"> 50
</span><span class="lnt"> 51
</span><span class="lnt"> 52
</span><span class="lnt"> 53
</span><span class="lnt"> 54
</span><span class="lnt"> 55
</span><span class="lnt"> 56
</span><span class="lnt"> 57
</span><span class="lnt"> 58
</span><span class="lnt"> 59
</span><span class="lnt"> 60
</span><span class="lnt"> 61
</span><span class="lnt"> 62
</span><span class="lnt"> 63
</span><span class="lnt"> 64
</span><span class="lnt"> 65
</span><span class="lnt"> 66
</span><span class="lnt"> 67
</span><span class="lnt"> 68
</span><span class="lnt"> 69
</span><span class="lnt"> 70
</span><span class="lnt"> 71
</span><span class="lnt"> 72
</span><span class="lnt"> 73
</span><span class="lnt"> 74
</span><span class="lnt"> 75
</span><span class="lnt"> 76
</span><span class="lnt"> 77
</span><span class="lnt"> 78
</span><span class="lnt"> 79
</span><span class="lnt"> 80
</span><span class="lnt"> 81
</span><span class="lnt"> 82
</span><span class="lnt"> 83
</span><span class="lnt"> 84
</span><span class="lnt"> 85
</span><span class="lnt"> 86
</span><span class="lnt"> 87
</span><span class="lnt"> 88
</span><span class="lnt"> 89
</span><span class="lnt"> 90
</span><span class="lnt"> 91
</span><span class="lnt"> 92
</span><span class="lnt"> 93
</span><span class="lnt"> 94
</span><span class="lnt"> 95
</span><span class="lnt"> 96
</span><span class="lnt"> 97
</span><span class="lnt"> 98
</span><span class="lnt"> 99
</span><span class="lnt">100
</span><span class="lnt">101
</span><span class="lnt">102
</span><span class="lnt">103
</span><span class="lnt">104
</span><span class="lnt">105
</span><span class="lnt">106
</span><span class="lnt">107
</span><span class="lnt">108
</span><span class="lnt">109
</span><span class="lnt">110
</span><span class="lnt">111
</span><span class="lnt">112
</span><span class="lnt">113
</span><span class="lnt">114
</span><span class="lnt">115
</span><span class="lnt">116
</span><span class="lnt">117
</span><span class="lnt">118
</span><span class="lnt">119
</span><span class="lnt">120
</span><span class="lnt">121
</span><span class="lnt">122
</span><span class="lnt">123
</span><span class="lnt">124
</span><span class="lnt">125
</span><span class="lnt">126
</span><span class="lnt">127
</span></code></pre></td>
<td class="lntd">
<pre tabindex="0" class="chroma"><code class="language-nix" data-lang="nix"><span class="line"><span class="cl"><span class="p">{</span>
</span></span><span class="line"><span class="cl">  <span class="n">description</span> <span class="o">=</span> <span class="s2">&quot;Nix and Ocaml template&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">
</span></span><span class="line"><span class="cl">  <span class="n">inputs</span> <span class="o">=</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">    <span class="n">nixpkgs</span><span class="o">.</span><span class="n">url</span> <span class="o">=</span> <span class="s2">&quot;github:NixOS/nixpkgs/nixos-unstable&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">    <span class="n">riot</span> <span class="o">=</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">      <span class="n">url</span> <span class="o">=</span> <span class="s2">&quot;github:emilpriver/riot&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">      <span class="n">inputs</span><span class="o">.</span><span class="n">nixpkgs</span><span class="o">.</span><span class="n">follows</span> <span class="o">=</span> <span class="s2">&quot;nixpkgs&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">    <span class="p">};</span>
</span></span><span class="line"><span class="cl">  <span class="p">};</span>
</span></span><span class="line"><span class="cl">
</span></span><span class="line"><span class="cl">  <span class="n">outputs</span> <span class="o">=</span> <span class="n">inputs</span><span class="o">@</span><span class="p">{</span> <span class="n">flake-parts</span><span class="o">,</span> <span class="o">...</span> <span class="p">}:</span>
</span></span><span class="line"><span class="cl">    <span class="n">flake-parts</span><span class="o">.</span><span class="n">lib</span><span class="o">.</span><span class="n">mkFlake</span> <span class="p">{</span> <span class="k">inherit</span> <span class="n">inputs</span><span class="p">;</span> <span class="p">}</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">      <span class="n">systems</span> <span class="o">=</span> <span class="p">[</span> <span class="s2">&quot;x86_64-linux&quot;</span> <span class="s2">&quot;aarch64-linux&quot;</span> <span class="s2">&quot;aarch64-darwin&quot;</span> <span class="s2">&quot;x86_64-darwin&quot;</span> <span class="p">];</span>
</span></span><span class="line"><span class="cl">      <span class="n">perSystem</span> <span class="o">=</span> <span class="p">{</span> <span class="n">config</span><span class="o">,</span> <span class="n">self'</span><span class="o">,</span> <span class="n">inputs'</span><span class="o">,</span> <span class="n">pkgs</span><span class="o">,</span> <span class="n">system</span><span class="o">,</span> <span class="o">...</span> <span class="p">}:</span>
</span></span><span class="line"><span class="cl">        <span class="k">let</span>
</span></span><span class="line"><span class="cl">          <span class="k">inherit</span> <span class="p">(</span><span class="n">pkgs</span><span class="p">)</span> <span class="n">ocamlPackages</span> <span class="n">mkShell</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">          <span class="k">inherit</span> <span class="p">(</span><span class="n">ocamlPackages</span><span class="p">)</span> <span class="n">buildDunePackage</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">          <span class="n">version</span> <span class="o">=</span> <span class="s2">&quot;0.0.1+dev&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">        <span class="k">in</span>
</span></span><span class="line"><span class="cl">        <span class="p">{</span>
</span></span><span class="line"><span class="cl">          <span class="n">devShells</span> <span class="o">=</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">            <span class="n">default</span> <span class="o">=</span> <span class="n">mkShell</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">              <span class="n">buildInputs</span> <span class="o">=</span> <span class="p">[</span>
</span></span><span class="line"><span class="cl">                <span class="n">ocamlPackages</span><span class="o">.</span><span class="n">dune_3</span>
</span></span><span class="line"><span class="cl">                <span class="n">ocamlPackages</span><span class="o">.</span><span class="n">ocaml</span>
</span></span><span class="line"><span class="cl">                <span class="n">ocamlPackages</span><span class="o">.</span><span class="n">utop</span>
</span></span><span class="line"><span class="cl">                <span class="n">ocamlPackages</span><span class="o">.</span><span class="n">ocamlformat</span>
</span></span><span class="line"><span class="cl">                <span class="n">ocamlPackages</span><span class="o">.</span><span class="n">ounit2</span>
</span></span><span class="line"><span class="cl">              <span class="p">];</span>
</span></span><span class="line"><span class="cl">              <span class="n">inputsFrom</span> <span class="o">=</span> <span class="p">[</span>
</span></span><span class="line"><span class="cl">                <span class="n">self'</span><span class="o">.</span><span class="n">packages</span><span class="o">.</span><span class="n">default</span>
</span></span><span class="line"><span class="cl">              <span class="p">];</span>
</span></span><span class="line"><span class="cl">              <span class="n">packages</span> <span class="o">=</span> <span class="nb">builtins</span><span class="o">.</span><span class="n">attrValues</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">                <span class="k">inherit</span> <span class="p">(</span><span class="n">pkgs</span><span class="p">)</span> <span class="n">clang_17</span> <span class="n">clang-tools_17</span> <span class="n">pkg-config</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">                <span class="k">inherit</span> <span class="p">(</span><span class="n">ocamlPackages</span><span class="p">)</span> <span class="n">ocaml-lsp</span> <span class="n">ocamlformat-rpc-lib</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">              <span class="p">};</span>
</span></span><span class="line"><span class="cl">              <span class="n">dontDetectOcamlConflicts</span> <span class="o">=</span> <span class="no">true</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">            <span class="p">};</span>
</span></span><span class="line"><span class="cl">          <span class="p">};</span>
</span></span><span class="line"><span class="cl">          <span class="n">packages</span> <span class="o">=</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">            <span class="n">randomconv</span> <span class="o">=</span> <span class="n">buildDunePackage</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">              <span class="n">version</span> <span class="o">=</span> <span class="s2">&quot;0.2.0&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">              <span class="n">pname</span> <span class="o">=</span> <span class="s2">&quot;randomconv&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">              <span class="n">src</span> <span class="o">=</span> <span class="n">pkgs</span><span class="o">.</span><span class="n">fetchFromGitHub</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">                <span class="n">owner</span> <span class="o">=</span> <span class="s2">&quot;hannesm&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">                <span class="n">repo</span> <span class="o">=</span> <span class="s2">&quot;randomconv&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">                <span class="n">rev</span> <span class="o">=</span> <span class="s2">&quot;b2ce656d09738d676351f5a1c18aff0ff37a7dcc&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">                <span class="n">hash</span> <span class="o">=</span> <span class="s2">&quot;sha256-KIvx/UNtPTg0EqfwuJgzSCtr6RgKIXK6yv9QkUUHbJk=&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">              <span class="p">};</span>
</span></span><span class="line"><span class="cl">              <span class="n">dontDetectOcamlConflicts</span> <span class="o">=</span> <span class="no">true</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">            <span class="p">};</span>
</span></span><span class="line"><span class="cl">            <span class="n">random</span> <span class="o">=</span> <span class="n">buildDunePackage</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">              <span class="n">version</span> <span class="o">=</span> <span class="s2">&quot;0.0.1&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">              <span class="n">pname</span> <span class="o">=</span> <span class="s2">&quot;random&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">              <span class="n">src</span> <span class="o">=</span> <span class="n">pkgs</span><span class="o">.</span><span class="n">fetchFromGitHub</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">                <span class="n">owner</span> <span class="o">=</span> <span class="s2">&quot;leostera&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">                <span class="n">repo</span> <span class="o">=</span> <span class="s2">&quot;random&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">                <span class="n">rev</span> <span class="o">=</span> <span class="s2">&quot;abb07c253dbc208219ac1983b34c78dab5fe93fd&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">                <span class="n">hash</span> <span class="o">=</span> <span class="s2">&quot;sha256-dcJDuWE3qLEanu+TBBSeJPxxQvAN9eq88R5W3XMEGiA=&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">              <span class="p">};</span>
</span></span><span class="line"><span class="cl">              <span class="n">buildInputs</span> <span class="o">=</span> <span class="k">with</span> <span class="n">ocamlPackages</span><span class="p">;</span> <span class="p">[</span>
</span></span><span class="line"><span class="cl">                <span class="n">mirage-crypto-rng</span>
</span></span><span class="line"><span class="cl">                <span class="n">mirage-crypto</span>
</span></span><span class="line"><span class="cl">                <span class="n">self'</span><span class="o">.</span><span class="n">packages</span><span class="o">.</span><span class="n">randomconv</span>
</span></span><span class="line"><span class="cl">              <span class="p">];</span>
</span></span><span class="line"><span class="cl">              <span class="n">dontDetectOcamlConflicts</span> <span class="o">=</span> <span class="no">true</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">            <span class="p">};</span>
</span></span><span class="line"><span class="cl">            <span class="n">default</span> <span class="o">=</span> <span class="n">buildDunePackage</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">              <span class="k">inherit</span> <span class="n">version</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">              <span class="n">pname</span> <span class="o">=</span> <span class="s2">&quot;nix_template&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">              <span class="n">buildInputs</span> <span class="o">=</span> <span class="p">[</span>
</span></span><span class="line"><span class="cl">                <span class="n">self'</span><span class="o">.</span><span class="n">packages</span><span class="o">.</span><span class="n">random</span>
</span></span><span class="line"><span class="cl">                <span class="n">inputs'</span><span class="o">.</span><span class="n">riot</span><span class="o">.</span><span class="n">packages</span><span class="o">.</span><span class="n">default</span>
</span></span><span class="line"><span class="cl">              <span class="p">];</span>
</span></span><span class="line"><span class="cl">              <span class="n">src</span> <span class="o">=</span> <span class="sr">./.</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">              <span class="n">buildPhase</span> <span class="o">=</span> <span class="s1">''
</span></span></span><span class="line"><span class="cl"><span class="s1">                dune build
</span></span></span><span class="line"><span class="cl"><span class="s1">              ''</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">              <span class="n">doCheck</span> <span class="o">=</span> <span class="no">true</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">              <span class="n">dontDetectOcamlConflicts</span> <span class="o">=</span> <span class="no">true</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">              <span class="n">installPhase</span> <span class="o">=</span> <span class="s1">''
</span></span></span><span class="line"><span class="cl"><span class="s1">                mkdir $out
</span></span></span><span class="line"><span class="cl"><span class="s1">                cp _build/default/bin/main.exe $out
</span></span></span><span class="line"><span class="cl"><span class="s1">              ''</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">            <span class="p">};</span>
</span></span><span class="line"><span class="cl">            <span class="n">test</span> <span class="o">=</span> <span class="n">pkgs</span><span class="o">.</span><span class="n">stdenv</span><span class="o">.</span><span class="n">mkDerivation</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">              <span class="n">name</span> <span class="o">=</span> <span class="s2">&quot;ocaml-test&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">              <span class="n">buildInputs</span> <span class="o">=</span> <span class="p">[</span>
</span></span><span class="line"><span class="cl">                <span class="n">ocamlPackages</span><span class="o">.</span><span class="n">dune_3</span>
</span></span><span class="line"><span class="cl">                <span class="n">ocamlPackages</span><span class="o">.</span><span class="n">ocaml</span>
</span></span><span class="line"><span class="cl">                <span class="n">ocamlPackages</span><span class="o">.</span><span class="n">utop</span>
</span></span><span class="line"><span class="cl">                <span class="n">ocamlPackages</span><span class="o">.</span><span class="n">ocamlformat</span>
</span></span><span class="line"><span class="cl">                <span class="n">ocamlPackages</span><span class="o">.</span><span class="n">ounit2</span>
</span></span><span class="line"><span class="cl">              <span class="p">];</span>
</span></span><span class="line"><span class="cl">              <span class="n">inputsFrom</span> <span class="o">=</span> <span class="p">[</span>
</span></span><span class="line"><span class="cl">                <span class="n">self'</span><span class="o">.</span><span class="n">packages</span><span class="o">.</span><span class="n">default</span>
</span></span><span class="line"><span class="cl">              <span class="p">];</span>
</span></span><span class="line"><span class="cl">              <span class="n">src</span> <span class="o">=</span> <span class="sr">./.</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">              <span class="n">buildPhase</span> <span class="o">=</span> <span class="s1">''
</span></span></span><span class="line"><span class="cl"><span class="s1">                dune runtest
</span></span></span><span class="line"><span class="cl"><span class="s1">              ''</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">              <span class="n">doCheck</span> <span class="o">=</span> <span class="no">true</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">              <span class="c1">## Create and output the result. for instance the coverage.txt</span>
</span></span><span class="line"><span class="cl">              <span class="n">installPhase</span> <span class="o">=</span> <span class="s1">''
</span></span></span><span class="line"><span class="cl"><span class="s1">                mkdir -p $out
</span></span></span><span class="line"><span class="cl"><span class="s1">                touch $out/coverage.txt
</span></span></span><span class="line"><span class="cl"><span class="s1">                echo &quot;I am the coverage of the test&quot; &gt; $out/coverage.txt 
</span></span></span><span class="line"><span class="cl"><span class="s1">              ''</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">            <span class="p">};</span>
</span></span><span class="line"><span class="cl">            <span class="n">dockerImage</span> <span class="o">=</span> <span class="n">pkgs</span><span class="o">.</span><span class="n">dockerTools</span><span class="o">.</span><span class="n">buildLayeredImage</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">              <span class="n">name</span> <span class="o">=</span> <span class="s2">&quot;nix-template&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">              <span class="n">tag</span> <span class="o">=</span> <span class="s2">&quot;0.0.1+dev&quot;</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">              <span class="n">contents</span> <span class="o">=</span> <span class="p">[</span> <span class="n">self'</span><span class="o">.</span><span class="n">packages</span><span class="o">.</span><span class="n">default</span> <span class="n">ocamlPackages</span><span class="o">.</span><span class="n">ounit2</span> <span class="p">];</span>
</span></span><span class="line"><span class="cl">              <span class="n">config</span> <span class="o">=</span> <span class="p">{</span>
</span></span><span class="line"><span class="cl">                <span class="n">Cmd</span> <span class="o">=</span> <span class="p">[</span> <span class="s2">&quot;</span><span class="si">${</span><span class="n">self'</span><span class="o">.</span><span class="n">packages</span><span class="o">.</span><span class="n">default</span><span class="si">}</span><span class="s2">/bin/main.exe&quot;</span> <span class="p">];</span>
</span></span><span class="line"><span class="cl">                <span class="n">ExposedPorts</span> <span class="o">=</span> <span class="p">{</span> <span class="s2">&quot;8000/tcp&quot;</span> <span class="o">=</span> <span class="p">{</span> <span class="p">};</span> <span class="p">};</span>
</span></span><span class="line"><span class="cl">                <span class="n">Env</span> <span class="o">=</span> <span class="p">[</span>
</span></span><span class="line"><span class="cl">                  <span class="p">(</span><span class="s2">&quot;GITHUB_SHA=123123&quot;</span><span class="p">)</span>
</span></span><span class="line"><span class="cl">                <span class="p">];</span>
</span></span><span class="line"><span class="cl">              <span class="p">};</span>
</span></span><span class="line"><span class="cl">            <span class="p">};</span>
</span></span><span class="line"><span class="cl">          <span class="p">};</span>
</span></span><span class="line"><span class="cl">          <span class="n">formatter</span> <span class="o">=</span> <span class="n">pkgs</span><span class="o">.</span><span class="n">nixpkgs-fmt</span><span class="p">;</span>
</span></span><span class="line"><span class="cl">        <span class="p">};</span>
</span></span><span class="line"><span class="cl">    <span class="p">};</span>
</span></span><span class="line"><span class="cl"><span class="p">}</span>
</span></span></code></pre></td></tr></table>
</div>
</div><p>This code also exist at <a href="http://github.com/emilpriver/ocaml-nix-template">github.com/emilpriver/ocaml-nix-template</a></p>
<h2>The end</h2>
<p>I hope this article has helped you with working with Nix. In this post, I built a flake.nix for OCaml projects, but it shouldn&rsquo;t be too hard to replace the OCaml components with whatever language you want. For instance, packages exist for JavaScript to replace NPM and Rust to replace Cargo.</p>
<p>These days, I use Nix for the development environment, testing, and building, and for me, it has been a quite good experience, especially when working with prebuilt flakes.</p>
<p>My goal with this post was just to show &ldquo;a way&rdquo; of doing it. I&rsquo;ve noticed that the Nix community tends to give a lot of opinions about how you should do things in Nix. The hard truth is that there are a lot of different ways to solve the same problem in Nix, and you should pick a way that suits you.</p>
<p>If you like this type of content and want to follow me to get more information on when I post stuff, I recommend following me on Twitter: <a href="https://x.com/emil_priver">https://x.com/emil_priver</a></p>

