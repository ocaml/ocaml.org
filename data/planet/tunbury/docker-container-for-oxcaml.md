---
title: Docker Container for OxCaml
description: Jon asked me to make a Docker image that contains OxCaml ready to run
  without the need to build it from scratch.
url: https://www.tunbury.org/2025/07/18/docker-oxcaml/
date: 2025-07-18T18:00:00-00:00
preview_image: https://www.tunbury.org/images/oxcaml.png
authors:
- Mark Elvers
source:
ignore:
---

<p>Jon asked me to make a Docker image that contains <a href="https://oxcaml.org">OxCaml</a> ready to run without the need to build it from scratch.</p>

<p>I have written a simple OCurrent pipeline to periodically poll <a href="https://github.com/oxcaml/opam-repository">oxcaml/opam-repository</a>. If the SHA has changed, it builds a Docker image and pushes it to current/opam-staging:oxcaml.</p>

<p>The resulting image can be run like this:</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="nv">$ </span>docker run <span class="nt">--rm</span> <span class="nt">-it</span> ocurrent/opam-staging:oxcaml
ubuntu@146eab4efc18:/<span class="nv">$ </span>ocaml
OCaml version 5.2.0+ox
Enter
<span class="c">#help;; for help.</span>

<span class="c">#</span>
</code></pre></div></div>

<p>The exact content of the image may change depending upon requirements, and we should also pick a better place to put it rather than ocurrent/opam-staging!</p>

<p>The pipeline code is available here <a href="https://github.com/mtelvers/docker-oxcaml">mtelvers/docker-oxcaml</a> and the service is deployed at <a href="https://oxcaml.image.ci.dev">oxcaml.image.ci.dev</a>.</p>
