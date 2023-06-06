---
title: Opam Switch to Multicore OCaml
description:
url: https://kcsrk.info/multicore/opam/ocaml/2015/03/25/opam-switch-to-multicore/
date: 2015-03-25T18:15:00-00:00
preview_image:
featured:
authors:
- KC Sivaramakrishnan
---

<p>OPAM has a great <a href="https://opam.ocaml.org/doc/Usage.html#opamswitch">compiler
switch</a> feature that lets you
simultaneously host several OCaml installations, each with its own compiler
version and a set of installed packages. I wanted to use the power of <code class="language-plaintext highlighter-rouge">opam
switch</code> for working with the experimental <a href="https://github.com/ocamllabs/ocaml-multicore">multicore
OCaml</a> compiler. The key
advantage of doing this is that it lets you easily install packages from the
<a href="http://opam.ocaml.org/">OPAM repository</a>, while sandboxing it from other OCaml
installations on your system. The post will show how to create OPAM compiler
switch for multicore OCaml.</p>



<h2>Install opam-compiler-conf</h2>

<p>The first step is to install Gabriel Scherer&rsquo;s <a href="https://github.com/gasche/opam-compiler-conf">opam-compiler-conf
script</a> which lets you do opam
switches on local installations:</p>

<figure class="highlight"><pre><code class="language-bash" data-lang="bash"><span class="nv">$ </span>git clone https://github.com/gasche/opam-compiler-conf
<span class="nv">$ </span><span class="nb">cd </span>opam-compiler-conf
<span class="nv">$ </span><span class="nb">mkdir</span> <span class="nt">-p</span> ~/.local/bin
<span class="nv">$ </span>make <span class="nv">BINDIR</span><span class="o">=</span>~/.local/bin <span class="nb">install</span></code></pre></figure>

<p>This installs the <code class="language-plaintext highlighter-rouge">opam-compiler-conf</code> script under <code class="language-plaintext highlighter-rouge">~/.local/bin</code>. Make sure
this directory is under your search path. Now, <code class="language-plaintext highlighter-rouge">$opam compiler-conf</code> should
give you the list of available commands.</p>

<h2>Build multicore OCaml locally</h2>

<p>Typing <code class="language-plaintext highlighter-rouge">opam switch</code> should list the compilers currently installed in your
system and those that are available. For instance, here is my setup:</p>

<figure class="highlight"><pre><code class="language-bash" data-lang="bash"><span class="nv">$ </span>opam switch
system  C system  System compiler <span class="o">(</span>4.02.1<span class="o">)</span>
4.02.1  I 4.02.1  Official 4.02.1 release
4.02.0  I 4.02.0  Official 4.02.0 release
4.01.0  I 4.01.0  Official 4.01.0 release
<span class="nt">--</span>     <span class="nt">--</span> 3.11.2  Official 3.11.2 release
<span class="nt">--</span>     <span class="nt">--</span> 3.12.1  Official 3.12.1 release
<span class="nt">--</span>     <span class="nt">--</span> 4.00.0  Official 4.00.0 release
<span class="nt">--</span>     <span class="nt">--</span> 4.00.1  Official 4.00.1 release
<span class="c"># 66 more patched or experimental compilers, use '--all' to show</span></code></pre></figure>

<p>You can easily switch between the installations using <code class="language-plaintext highlighter-rouge">opam switch
[system-name]</code>. Let us now install multicore OCaml as a new switch:</p>

<figure class="highlight"><pre><code class="language-bash" data-lang="bash"><span class="nv">$ </span>git clone https://github.com/ocamllabs/ocaml-multicore
<span class="nv">$ </span><span class="nb">cd </span>ocaml-multicore
<span class="nv">$ </span>opam compiler-conf configure
<span class="nv">$ </span>make world
<span class="nv">$ </span>opam compiler-conf <span class="nb">install</span>
<span class="nv">$ </span><span class="nb">eval</span> <span class="sb">`</span>opam config <span class="nb">env</span><span class="sb">`</span></code></pre></figure>

<p>The multicore compiler is now installed and has been made the current compiler:</p>

<figure class="highlight"><pre><code class="language-bash" data-lang="bash"><span class="nv">$ </span>opam switch
system                      I system                      System compiler <span class="o">(</span>4.02.1<span class="o">)</span>
4.02.1+local-git-multicore  C 4.02.1+local-git-multicore  Local checkout of 4.02.1 at /Users/kc/ocaml-multicore
4.02.1                      I 4.02.1                      Official 4.02.1 release
4.02.0                      I 4.02.0                      Official 4.02.0 release
4.01.0                      I 4.01.0                      Official 4.01.0 release
<span class="nt">--</span>                         <span class="nt">--</span> 3.11.2                      Official 3.11.2 release
<span class="nt">--</span>                         <span class="nt">--</span> 3.12.1                      Official 3.12.1 release
<span class="nt">--</span>                         <span class="nt">--</span> 4.00.0                      Official 4.00.0 release
<span class="nt">--</span>                         <span class="nt">--</span> 4.00.1                      Official 4.00.1 release
<span class="c"># 66 more patched or experimental compilers, use '--all' to show</span></code></pre></figure>

<p>This can be confirmed by:</p>

<figure class="highlight"><pre><code class="language-bash" data-lang="bash"><span class="nv">$ </span>ocamlc <span class="nt">-version</span>
4.02.1+multicore-dev0</code></pre></figure>

<p>which shows the current OCaml bytecode compiler version.</p>

<h2>Working with the local switch</h2>

<p>Every time you change the compiler source, you need to rebuild the compiler and
reinstall the switch:</p>

<figure class="highlight"><pre><code class="language-bash" data-lang="bash"><span class="c"># Changed compiler source...</span>
<span class="nv">$ </span>make world
<span class="nv">$ </span>opam compiler-conf reinstall</code></pre></figure>

<p>The local installation can be removed by <code class="language-plaintext highlighter-rouge">opam compiler-conf uninstall</code>.</p>

