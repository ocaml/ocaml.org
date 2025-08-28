---
title: Recent OCaml Versions
description: Following my post on discuss.ocaml.org, I have created a new release
  of ocurrent/ocaml-version that moves the minimum version of OCaml, considered as
  recent, from 4.02 to 4.08.
url: https://www.tunbury.org/2025/03/24/recent-ocaml-version/
date: 2025-03-24T00:00:00-00:00
preview_image: https://www.tunbury.org/images/ocaml-logo.png
authors:
- Mark Elvers
source:
ignore:
---

<p>Following my <a href="https://discuss.ocaml.org/t/docker-base-images-and-ocaml-ci-support-for-ocaml-4-08/16229">post on discuss.ocaml.org</a>, I have created a new release of <a href="https://github.com/ocurrent/ocaml-version">ocurrent/ocaml-version</a> that moves the minimum version of OCaml, considered as <em>recent</em>, from 4.02 to 4.08.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">recent</span> <span class="o">=</span> <span class="p">[</span> <span class="n">v4_08</span><span class="p">;</span> <span class="n">v4_09</span><span class="p">;</span> <span class="n">v4_10</span><span class="p">;</span> <span class="n">v4_11</span><span class="p">;</span> <span class="n">v4_12</span><span class="p">;</span> <span class="n">v4_13</span><span class="p">;</span> <span class="n">v4_14</span><span class="p">;</span> <span class="n">v5_0</span><span class="p">;</span> <span class="n">v5_1</span><span class="p">;</span> <span class="n">v5_2</span><span class="p">;</span> <span class="n">v5_3</span> <span class="p">]</span>
</code></pre></div></div>

<p>This may feel like a mundane change, but <a href="https://github.com/ocurrent/ocaml-ci">OCaml-CI</a>, <a href="https://github.com/ocurrent/opam-repo-ci">opam-repo-ci</a>, <a href="https://github.com/ocurrent/docker-base-images">Docker base image builder</a> among other things, use this to determine the set of versions of OCaml to test against. Therefore, as these services are updated, testing on the old releases will be removed.</p>
