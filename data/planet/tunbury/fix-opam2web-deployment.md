---
title: Fix opam2web deployment
description: We maintain a mirror (archive) of all opam packages. To take advantage
  of this, add the archive mirror to opam by setting the global option.
url: https://www.tunbury.org/2025/05/28/opam2web/
date: 2025-05-28T00:00:00-00:00
preview_image: https://www.tunbury.org/images/opam.png
authors:
- Mark Elvers
source:
ignore:
---

<p>We maintain a mirror (archive) of all opam packages. To take advantage of this, add the archive mirror to opam by setting the global option.</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code>opam option <span class="nt">--global</span> <span class="s1">'archive-mirrors+="https://opam.ocaml.org/cache"'</span>
</code></pre></div></div>

<h1>How is the mirror generated and maintained?</h1>

<p>opam has a command that generates the mirror, which defaults to reading <code class="language-plaintext highlighter-rouge">packages</code> from the current directory.</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code>opam admin cache <span class="nt">--link</span><span class="o">=</span>archives ./cache
</code></pre></div></div>

<div class="mermaid">
sequenceDiagram
    participant BIB as Base Image Builder
    participant DH as Docker Hub
    participant O2W as opam2web

    Note over DH: ocaml/opam:archive
    DH--&gt;&gt;BIB: Pull ocaml/opam:archive

    Note over BIB: opam admin cache
    BIB-&gt;&gt;DH: Push image

    Note over DH: ocaml/opam:archive
    DH-&gt;&gt;O2W: Pull ocaml/opam:archive

    Note over O2W: opam admin cache
    Note over O2W: Publish https://opam.ocaml.org/cache
</div>

<p>The base image builder pulls <code class="language-plaintext highlighter-rouge">ocaml/opam:archive</code>, runs <code class="language-plaintext highlighter-rouge">opam admin cache</code> to update the cache, and then pushes it back <code class="language-plaintext highlighter-rouge">ocaml/opam:archive</code>.</p>

<p>opam2web, which publishes <a href="https://opam.ocaml.org">opam.ocaml.org</a>, pulls <code class="language-plaintext highlighter-rouge">ocaml/opam:archive</code> and then runs <code class="language-plaintext highlighter-rouge">opam admin cache</code> to populate any new items in the cache and then makes the cache available at <a href="https://opam.ocaml.org/cache">https://opam.ocaml.org/cache</a>.</p>

<p>Until today, the step indicated by the dotted line was missing. Kate had pointed this out as long ago as 2023 with <a href="https://github.com/ocurrent/docker-base-images/issues/249">issue #249</a> and <a href="https://github.com/ocurrent/docker-base-images/pull/248">PR #248</a>, but, for whatever reason, this was never actioned.</p>

<p>With the current unavailability of <a href="https://www.tunbury.org/camlcity.org">camlcity.org</a>, this has become a problem. On Monday, I patched opam2web’s <code class="language-plaintext highlighter-rouge">Dockerfile</code> to include access to the mirror/cache, which allowed opam2web to build. However, subsequent builds failed because the updated <a href="https://opam.ocaml.org">opam.ocaml.org</a> used the latest version of <code class="language-plaintext highlighter-rouge">ocaml/opam:archive</code>. This was built on Sunday when camlcity.org was down; therefore, the source for <code class="language-plaintext highlighter-rouge">ocamlfind</code> had been dropped from the mirror.</p>

<h1>How to do we get out of this problem?</h1>

<p>Updating the base image builder does not fix the problem, as camlcity.org is still down and the current <code class="language-plaintext highlighter-rouge">ocaml/opam:archive</code> does not contain the missing packages. We only tag the latest version on Dockerhub, but looking through the base image builder logs allowed me to find the SHA256 for last week’s build.  <code class="language-plaintext highlighter-rouge">ocaml/opam:archive@sha256:a0e2cd50e1185fd9a17a193f52d17981a6f9ccf0b56285cbc07f396d5e3f7882</code></p>

<p>Taking <a href="https://github.com/ocurrent/docker-base-images/pull/248">PR #248</a>, and pointing it to the older image, I used the base image builder locally to push an updated <code class="language-plaintext highlighter-rouge">ocaml/opam:archive</code>. This is <code class="language-plaintext highlighter-rouge">ocaml/opam:archive@sha256:fb7b62ee305b0b9fff82748803e57a655ca92130ab8624476cd7af428101a643</code>.</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>-  from ~alias:"opam-archive" "ocaml/opam:archive" @@
+  from ~alias:"opam-archive" "ocaml/opam:archive@sha256:a0e2cd50e1185fd9a17a193f52d17981a6f9ccf0b56285cbc07f396d5e3f7882" @@
</code></pre></div></div>

<p>Now I need to update opam.ocaml.org, but <code class="language-plaintext highlighter-rouge">opam2web</code> doesn’t build due to the missing <code class="language-plaintext highlighter-rouge">ocamlfind</code>.  Checking the <code class="language-plaintext highlighter-rouge">opam</code> file showed two source files are needed. One is on GitHub so that’ll be ok.</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>...
url {
  src: "http://download.camlcity.org/download/findlib-1.9.6.tar.gz"
  checksum: [
    "md5=96c6ee50a32cca9ca277321262dbec57"
    "sha512=cfaf1872d6ccda548f07d32cc6b90c3aafe136d2aa6539e03143702171ee0199add55269bba894c77115535dc46a5835901a5d7c75768999e72db503bfd83027"
  ]
}
available: os != "win32"
extra-source "0001-Harden-test-for-OCaml-5.patch" {
  src:
    "https://raw.githubusercontent.com/ocaml/opam-source-archives/main/patches/ocamlfind/0001-Harden-test-for-OCaml-5.patch"
  checksum: [
    "sha256=6fcca5f2f7abf8d6304da6c385348584013ffb8602722a87fb0bacbab5867fe8"
    "md5=3cddbf72164c29d4e50e077a92a37c6c"
  ]
}
</code></pre></div></div>

<p>Luck was on my side, as <code class="language-plaintext highlighter-rouge">find ~/.opam/download-cache/ -name 96c6ee50a32cca9ca277321262dbec57</code> showed that I had the source in my local opam download cache. I checked out opam2web, copied in the file <code class="language-plaintext highlighter-rouge">96c6ee50a32cca9ca277321262dbec57</code> and patched the <code class="language-plaintext highlighter-rouge">Dockerfile</code> to inject it into the cache:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>diff --git i/Dockerfile w/Dockerfile
index eaf0567..84c9db8 100644
--- i/Dockerfile
+++ w/Dockerfile
@@ -34,6 +34,7 @@ RUN sudo mkdir -p /usr/local/bin \
     &amp;&amp; sudo chmod a+x /usr/local/bin/man2html
 RUN sudo mv /usr/bin/opam-2.3 /usr/bin/opam &amp;&amp; opam update
 RUN opam option --global 'archive-mirrors+="https://opam.ocaml.org/cache"'
+COPY 96c6ee50a32cca9ca277321262dbec57 /home/opam/.opam/download-cache/md5/96/96c6ee50a32cca9ca277321262dbec57
 RUN opam install odoc
 RUN git clone https://github.com/ocaml/opam --single-branch --depth 1 --branch master /home/opam/opam
 WORKDIR /home/opam/opam
</code></pre></div></div>

<p>The final step is to build and deploy an updated opam2web incorporating the updated mirror cache. In conjunction with the updated base image builder, this will be self-sustaining. I wrapped the necessary steps into a <code class="language-plaintext highlighter-rouge">Makefile</code>.</p>

<div class="language-makefile highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="nv">OPAM_REPO_GIT_SHA</span> <span class="o">:=</span> <span class="nf">$(</span><span class="nb">shell</span> git <span class="nt">-C</span> ~/opam-repository fetch upstream <span class="o">&amp;&amp;</span> git <span class="nt">-C</span> ~/opam-repository rev-parse upstream/master<span class="nf">)</span>
<span class="nv">BLOG_GIT_SHA</span> <span class="o">:=</span> bdef1bbf939db6797dcd51faef2ea9ac1826f4a5
<span class="nv">OPAM_GIT_SHA</span> <span class="o">:=</span> 46234090daf4f9c5f446af56a50f78809c04a20a

<span class="nl">all</span><span class="o">:</span>    <span class="nf">opam2web</span>
        <span class="err">cd</span> <span class="err">opam2web</span> <span class="err">&amp;&amp;</span> <span class="err">docker</span> <span class="err">--context</span> <span class="err">registry.ci.dev</span> <span class="err">build</span> <span class="err">--pull</span> <span class="err">\</span>
                <span class="err">--build-arg</span> <span class="nv">OPAM_REPO_GIT_SHA</span><span class="o">=</span><span class="nv">$(OPAM_REPO_GIT_SHA)</span> <span class="se">\</span>
                <span class="nt">--build-arg</span> <span class="nv">BLOG_GIT_SHA</span><span class="o">=</span><span class="nv">$(BLOG_GIT_SHA)</span> <span class="se">\</span>
                <span class="nt">--build-arg</span> <span class="nv">OPAM_GIT_SHA</span><span class="o">=</span><span class="nv">$(OPAM_GIT_SHA)</span> <span class="se">\</span>
                <span class="nt">-f</span> Dockerfile <span class="nt">--iidfile</span> ../docker-iid <span class="nt">--</span> .
        <span class="err">@</span><span class="nv">SHA256</span><span class="o">=</span><span class="err">$$</span><span class="o">(</span><span class="nb">cat </span>docker-iid<span class="o">)</span>
        <span class="nl">docker --context registry.ci.dev tag $$SHA256 registry.ci.dev/opam.ocaml.org</span><span class="o">:</span><span class="nf">live</span>
        <span class="err">docker</span> <span class="err">--context</span> <span class="err">registry.ci.dev</span> <span class="err">login</span> <span class="err">-u</span> <span class="err">$(USERNAME)</span> <span class="err">-p</span> <span class="err">$(PASSWORD)</span> <span class="err">registry.ci.dev</span>
        <span class="nl">docker --context registry.ci.dev push registry.ci.dev/opam.ocaml.org</span><span class="o">:</span><span class="nf">live</span>
        <span class="nl">docker --context opam-4.ocaml.org pull registry.ci.dev/opam.ocaml.org</span><span class="o">:</span><span class="nf">live</span>
        <span class="err">docker</span> <span class="err">--context</span> <span class="err">opam-4.ocaml.org</span> <span class="err">service</span> <span class="err">update</span> <span class="err">infra_opam_live</span> <span class="err">--image</span> <span class="err">$$SHA256</span>
        <span class="nl">docker --context opam-5.ocaml.org pull registry.ci.dev/opam.ocaml.org</span><span class="o">:</span><span class="nf">live</span>
        <span class="err">docker</span> <span class="err">--context</span> <span class="err">opam-5.ocaml.org</span> <span class="err">service</span> <span class="err">update</span> <span class="err">infra_opam_live</span> <span class="err">--image</span> <span class="err">$$SHA256</span>

<span class="nl">opam2web</span><span class="o">:</span>
        <span class="nl">git clone --recursive "https</span><span class="o">:</span><span class="nf">//github.com/ocaml-opam/opam2web.git" -b "live"</span>
</code></pre></div></div>

<p>Check that <code class="language-plaintext highlighter-rouge">ocamlfind</code> is included in the new cache</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code>wget https://opam-4.ocaml.org/cache/md5/96/96c6ee50a32cca9ca277321262dbec57
wget https://opam-5.ocaml.org/cache/md5/96/96c6ee50a32cca9ca277321262dbec57

</code></pre></div></div>
