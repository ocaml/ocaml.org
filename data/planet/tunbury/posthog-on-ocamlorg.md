---
title: Posthog on OCaml.org
description: Sabine would like to switch OCaml.org from using Plausible over to Posthog.
  The underlying reason for the move is that the self-hosted product from Posthog
  has more features than the equivalent from Plausible. Of particular interest is
  the heatmap feature to assess the number of visitors who finish the Tour of OCaml.
url: https://www.tunbury.org/2025/05/12/posthog/
date: 2025-05-12T12:00:00-00:00
preview_image: https://www.tunbury.org/images/posthog.png
authors:
- Mark Elvers
source:
ignore:
---

<p>Sabine would like to switch <a href="https://ocaml.org">OCaml.org</a> from using <a href="https://plausible.io">Plausible</a> over to <a href="https://posthog.com">Posthog</a>. The underlying reason for the move is that the self-hosted product from Posthog has more features than the equivalent from Plausible. Of particular interest is the heatmap feature to assess the number of visitors who finish the <a href="https://ocaml.org/docs/tour-of-ocaml">Tour of OCaml</a>.</p>

<p>Posthog has <a href="https://posthog.com/docs/self-host">documentation</a> on the self-hosted solution. In short, create a VM with 4 vCPU, 16GB RAM, and 30GB storage and run the setup script:</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code>/bin/bash <span class="nt">-c</span> <span class="s2">"</span><span class="si">$(</span>curl <span class="nt">-fsSL</span> https://raw.githubusercontent.com/posthog/posthog/HEAD/bin/deploy-hobby<span class="si">)</span><span class="s2">”
</span></code></pre></div></div>

<p>Any subsequent upgrades can be achieved with:</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code>/bin/bash <span class="nt">-c</span> <span class="s2">"</span><span class="si">$(</span>curl <span class="nt">-fsSL</span> https://raw.githubusercontent.com/posthog/posthog/HEAD/bin/upgrade-hobby<span class="si">)</span><span class="s2">"</span>
</code></pre></div></div>

<p>After installation, I created a <a href="https://posthog.ci.dev/shared/seqtamWuMXLwxJEAX1XNjwhzciAajw">public dashboard</a> as with <a href="https://plausible.ci.dev/ocaml.org">Plausible</a>. I also enabled the option <code class="language-plaintext highlighter-rouge">Discard client IP data</code>.</p>

<p>The OCaml website can be updated with <a href="https://github.com/ocaml/ocaml.org/pull/3101">PR#3101</a>.</p>
