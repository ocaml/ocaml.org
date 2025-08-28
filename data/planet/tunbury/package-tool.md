---
title: Package Tool
description: Would you like to build every package in opam in a single Dockerfile
  using BuildKit?
url: https://www.tunbury.org/2025/07/22/package-tool/
date: 2025-07-22T00:00:00-00:00
preview_image: https://www.tunbury.org/images/opam.png
authors:
- Mark Elvers
source:
ignore:
---

<p>Would you like to build every package in opam in a single Dockerfile using BuildKit?</p>

<p>In <a href="https://github.com/mtelvers/package-tool">mtelvers/package-tool</a>, I have combined various opam sorting and graphing functions into a CLI tool that will work on a checked-out <a href="https://github.com/ocaml/opam-repository">opam-repository</a>. Many of these flags can be combined.</p>

<h1>Package version</h1>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code>package-tool <span class="nt">--opam-repository</span> ~/opam-repository &lt;package&gt;
</code></pre></div></div>

<p>The package can be given as <code class="language-plaintext highlighter-rouge">0install.2.18</code> or <code class="language-plaintext highlighter-rouge">0install</code>. The former specifies a specific version while the latter processes the latest version. <code class="language-plaintext highlighter-rouge">--all-versions</code> can be specified to generate files for all package versions.</p>

<h1>Dependencies</h1>

<p>Dump the dependencies for the latest version of 0install into a JSON file.</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code>package-tool <span class="nt">--opam-repository</span> ~/opam-repository <span class="nt">--deps</span> 0install
</code></pre></div></div>

<p>Produces <code class="language-plaintext highlighter-rouge">0install.2.18-deps.json</code>:</p>

<div class="language-json highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="p">{</span><span class="nl">"yojson.3.0.0"</span><span class="p">:[</span><span class="s2">"dune.3.19.1"</span><span class="p">],</span><span class="w">
</span><span class="nl">"xmlm.1.4.0"</span><span class="p">:[</span><span class="s2">"topkg.1.0.8"</span><span class="p">],</span><span class="w">
</span><span class="nl">"topkg.1.0.8"</span><span class="p">:[</span><span class="s2">"ocamlfind.1.9.8"</span><span class="p">,</span><span class="s2">"ocamlbuild.0.16.1"</span><span class="p">],</span><span class="w">
</span><span class="err">...</span><span class="w">
</span><span class="s2">"0install-solver.2.18"</span><span class="err">]</span><span class="p">}</span><span class="w">
</span></code></pre></div></div>

<h1>Installation order</h1>

<p>Create a list showing the installation order for the given package.</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code>package-tool <span class="nt">--opam-repository</span> ~/opam-repository <span class="nt">--list</span> 0install
</code></pre></div></div>

<p>Produces <code class="language-plaintext highlighter-rouge">0install.2.18-list.json</code>:</p>

<div class="language-json highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="p">[</span><span class="s2">"ocaml-compiler.5.3.0"</span><span class="p">,</span><span class="w">
</span><span class="s2">"ocaml-base-compiler.5.3.0"</span><span class="p">,</span><span class="w">
</span><span class="err">...</span><span class="w">
</span><span class="s2">"0install.2.18"</span><span class="p">]</span><span class="w">
</span></code></pre></div></div>

<h1>Solution DAG</h1>

<p>Output the solution graph in Graphviz format, which can then be converted into a PDF with <code class="language-plaintext highlighter-rouge">dot</code>.</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code>package-tool <span class="nt">--opam-repository</span> ~/opam-repository <span class="nt">--dot</span> 0install
dot <span class="nt">-Tpdf</span> 0install.2.18.dot 0install.2.18.pdf
</code></pre></div></div>
<h1>OCaml version</h1>

<p>By default, OCaml 5.3.0 is used, but this can be changed using the <code class="language-plaintext highlighter-rouge">--ocaml 4.14.2</code> parameter.</p>

<h1>Dockerfile</h1>

<p>The <code class="language-plaintext highlighter-rouge">--dockerfile</code> argument creates a Dockerfile to test the installation.</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code>package-tool <span class="nt">--opam-repository</span> ~/opam-repository <span class="nt">--dockerfile</span> <span class="nt">--all-versions</span> 0install
</code></pre></div></div>

<p>For example, the above command line outputs 5 Dockerfiles.</p>

<ul>
  <li>0install.2.15.1.dockerfile</li>
  <li>0install.2.15.2.dockerfile</li>
  <li>0install.2.16.dockerfile</li>
  <li>0install.2.17.dockerfile</li>
  <li>0install.2.18.dockerfile</li>
</ul>

<p>As an example, <code class="language-plaintext highlighter-rouge">0install.2.18.dockerfile</code>, contains:</p>

<div class="language-dockerfile highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">FROM</span><span class="w"> </span><span class="s">debian:12</span><span class="w"> </span><span class="k">AS</span><span class="w"> </span><span class="s">builder_0install_2_18</span>
<span class="k">RUN </span>apt update <span class="o">&amp;&amp;</span> apt upgrade <span class="nt">-y</span>
<span class="k">RUN </span>apt <span class="nb">install</span> <span class="nt">-y</span> build-essential git rsync unzip curl <span class="nb">sudo</span>
<span class="k">RUN if </span>getent passwd 1000<span class="p">;</span> <span class="k">then </span>userdel <span class="nt">-r</span> <span class="si">$(</span><span class="nb">id</span> <span class="nt">-nu</span> 1000<span class="si">)</span><span class="p">;</span> <span class="k">fi</span>
<span class="k">RUN </span>adduser <span class="nt">--uid</span> 1000 <span class="nt">--disabled-password</span> <span class="nt">--gecos</span> <span class="s1">''</span> opam
<span class="k">ADD</span><span class="s"> --chown=root:root --chmod=0755 [ "https://github.com/ocaml/opam/releases/download/2.3.0/opam-2.3.0-x86_64-linux", "/usr/local/bin/opam" ]</span>
<span class="k">RUN </span><span class="nb">echo</span> <span class="s1">'opam ALL=(ALL:ALL) NOPASSWD:ALL'</span> <span class="o">&gt;&gt;</span> /etc/sudoers.d/opam
<span class="k">RUN </span><span class="nb">chmod </span>440 /etc/sudoers.d/opam
<span class="k">USER</span><span class="s"> opam</span>
<span class="k">WORKDIR</span><span class="s"> /home/opam</span>
<span class="k">ENV</span><span class="s"> OPAMYES="1" OPAMCONFIRMLEVEL="unsafe-yes" OPAMERRLOGLEN="0" OPAMPRECISETRACKING="1"</span>
<span class="k">ADD</span><span class="s"> --chown=opam:opam --keep-git-dir=false [ ".", "/home/opam/opam-repository" ]</span>
<span class="k">RUN </span>opam init default <span class="nt">-k</span> <span class="nb">local</span> ~/opam-repository <span class="nt">--disable-sandboxing</span> <span class="nt">--bare</span>
<span class="k">RUN </span>opam switch create default <span class="nt">--empty</span>
<span class="k">RUN </span>opam <span class="nb">install </span>ocaml-compiler.5.3.0 <span class="o">&gt;&gt;</span> build.log 2&gt;&amp;1 <span class="o">||</span> <span class="nb">echo</span> <span class="s1">'FAILED'</span> <span class="o">&gt;&gt;</span> build.log
<span class="k">RUN </span>opam <span class="nb">install </span>ocaml-base-compiler.5.3.0 <span class="o">&gt;&gt;</span> build.log 2&gt;&amp;1 <span class="o">||</span> <span class="nb">echo</span> <span class="s1">'FAILED'</span> <span class="o">&gt;&gt;</span> build.log
...
<span class="k">RUN </span>opam <span class="nb">install </span>0install-solver.2.18 <span class="o">&gt;&gt;</span> build.log 2&gt;&amp;1 <span class="o">||</span> <span class="nb">echo</span> <span class="s1">'FAILED'</span> <span class="o">&gt;&gt;</span> build.log
<span class="k">RUN </span>opam <span class="nb">install </span>0install.2.18 <span class="o">&gt;&gt;</span> build.log 2&gt;&amp;1 <span class="o">||</span> <span class="nb">echo</span> <span class="s1">'FAILED'</span> <span class="o">&gt;&gt;</span> build.log
<span class="k">ENTRYPOINT</span><span class="s"> [ "opam", "exec", "--" ]</span>
<span class="k">CMD</span><span class="s"> bash</span>
</code></pre></div></div>

<p>This can be built using Docker in the normal way. Note that the build context is your checkout of <a href="https://github.com/ocaml/opam-repository">opam-repository</a>.</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code>docker build <span class="nt">-f</span> 0install.2.18.dockerfile ~/opam-repository
</code></pre></div></div>

<p>Additionally, it outputs <code class="language-plaintext highlighter-rouge">Dockerfile</code>, which contains the individual package builds as a multistage build and an aggregation stage as the final layer:</p>

<div class="language-dockerfile highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">FROM</span><span class="w"> </span><span class="s">debian:12</span><span class="w"> </span><span class="k">AS</span><span class="w"> </span><span class="s">results</span>
<span class="k">WORKDIR</span><span class="s"> /results</span>
<span class="k">RUN </span>apt update <span class="o">&amp;&amp;</span> apt upgrade <span class="nt">-y</span>
<span class="k">RUN </span>apt <span class="nb">install</span> <span class="nt">-y</span> less
<span class="k">COPY</span><span class="s"> --from=builder_0install_2_15_1 [ "/home/opam/build.log", "/results/0install.2.15.1" ]</span>
<span class="k">COPY</span><span class="s"> --from=builder_0install_2_15_2 [ "/home/opam/build.log", "/results/0install.2.15.2" ]</span>
<span class="k">COPY</span><span class="s"> --from=builder_0install_2_16 [ "/home/opam/build.log", "/results/0install.2.16" ]</span>
<span class="k">COPY</span><span class="s"> --from=builder_0install_2_17 [ "/home/opam/build.log", "/results/0install.2.17" ]</span>
<span class="k">COPY</span><span class="s"> --from=builder_0install_2_18 [ "/home/opam/build.log", "/results/0install.2.18" ]</span>
<span class="k">CMD</span><span class="s"> bash</span>
</code></pre></div></div>

<p>Build all the versions of 0install in parallel using BuildKit’s layer caching:</p>

<div class="language-shell highlighter-rouge"><div class="highlight"><pre class="highlight"><code>docker build <span class="nt">-f</span> Dockerfile <span class="nt">-t</span> opam-results ~/opam-repository
</code></pre></div></div>

<p>We can inspect the build logs in the Docker container:</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="nv">$ </span>docker run <span class="nt">--rm</span> <span class="nt">-it</span> opam-results
root@b28da667e754:/results# <span class="nb">ls</span>^C
root@b28da667e754:/results# <span class="nb">ls</span> <span class="nt">-l</span>
total 76
<span class="nt">-rw-r--r--</span> 1 1000 1000 12055 Jul 22 20:17 0install.2.15.1
<span class="nt">-rw-r--r--</span> 1 1000 1000 15987 Jul 22 20:19 0install.2.15.2
<span class="nt">-rw-r--r--</span> 1 1000 1000 15977 Jul 22 20:19 0install.2.16
<span class="nt">-rw-r--r--</span> 1 1000 1000 16376 Jul 22 20:19 0install.2.17
<span class="nt">-rw-r--r--</span> 1 1000 1000 15150 Jul 22 20:19 0install.2.18
</code></pre></div></div>

<p>Annoyingly, Docker doesn’t seem to be able to cope with all of opam at once. I get various RPC errors.</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>[+] Building 2.9s (4/4) FINISHED                                                                                                    docker:default
 =&gt; [internal] load build definition from Dockerfile
 =&gt; =&gt; transferring dockerfile: 10.79MB
 =&gt; resolve image config for docker-image://docker.io/docker/dockerfile:1
 =&gt; CACHED docker-image://docker.io/docker/dockerfile:1@sha256:9857836c9ee4268391bb5b09f9f157f3c91bb15821bb77969642813b0d00518d
 =&gt; [internal] load build definition from Dockerfile
ERROR: failed to receive status: rpc error: code = Unavailable desc = error reading from server: connection error: COMPRESSION_ERROR
</code></pre></div></div>
