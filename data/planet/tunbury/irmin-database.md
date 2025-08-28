---
title: Irmin Database
description: "After Thomas\u2019 talk today I wanted to try Irmin for myself."
url: https://www.tunbury.org/2025/03/17/irmin/
date: 2025-03-17T00:00:00-00:00
preview_image: https://www.tunbury.org/images/irmin.png
authors:
- Mark Elvers
source:
ignore:
---

<p>After Thomas’ talk today I wanted to try <a href="https://irmin.org">Irmin</a> for myself.</p>

<p>In a new switch I installed Irmin via opam <code class="language-plaintext highlighter-rouge">opam install irmin-git</code> and then built the <a href="https://irmin.org/tutorial/getting-started/">example code</a></p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">open</span> <span class="nn">Lwt</span><span class="p">.</span><span class="nc">Syntax</span>
<span class="k">module</span> <span class="nc">Git_store</span> <span class="o">=</span> <span class="nn">Irmin_git_unix</span><span class="p">.</span><span class="nn">FS</span><span class="p">.</span><span class="nc">KV</span> <span class="p">(</span><span class="nn">Irmin</span><span class="p">.</span><span class="nn">Contents</span><span class="p">.</span><span class="nc">String</span><span class="p">)</span>
<span class="k">module</span> <span class="nc">Git_info</span> <span class="o">=</span> <span class="nn">Irmin_unix</span><span class="p">.</span><span class="nc">Info</span> <span class="p">(</span><span class="nn">Git_store</span><span class="p">.</span><span class="nc">Info</span><span class="p">)</span>

<span class="k">let</span> <span class="n">git_config</span> <span class="o">=</span> <span class="nn">Irmin_git</span><span class="p">.</span><span class="n">config</span> <span class="o">~</span><span class="n">bare</span><span class="o">:</span><span class="bp">true</span> <span class="s2">"./db"</span>
<span class="k">let</span> <span class="n">info</span> <span class="n">message</span> <span class="o">=</span> <span class="nn">Git_info</span><span class="p">.</span><span class="n">v</span> <span class="o">~</span><span class="n">author</span><span class="o">:</span><span class="s2">"Example"</span> <span class="s2">"%s"</span> <span class="n">message</span>

<span class="k">let</span> <span class="n">main_branch</span> <span class="n">config</span> <span class="o">=</span>
  <span class="k">let</span><span class="o">*</span> <span class="n">repo</span> <span class="o">=</span> <span class="nn">Git_store</span><span class="p">.</span><span class="nn">Repo</span><span class="p">.</span><span class="n">v</span> <span class="n">config</span> <span class="k">in</span>
  <span class="nn">Git_store</span><span class="p">.</span><span class="n">main</span> <span class="n">repo</span>

<span class="k">let</span> <span class="n">main</span> <span class="o">=</span>
  <span class="k">let</span><span class="o">*</span> <span class="n">t</span> <span class="o">=</span> <span class="n">main_branch</span> <span class="n">git_config</span> <span class="k">in</span>
  <span class="c">(* Set a/b/c to "Hello, Irmin!" *)</span>
  <span class="k">let</span><span class="o">*</span> <span class="bp">()</span> <span class="o">=</span>
    <span class="nn">Git_store</span><span class="p">.</span><span class="n">set_exn</span> <span class="n">t</span> <span class="p">[</span> <span class="s2">"a"</span><span class="p">;</span> <span class="s2">"b"</span><span class="p">;</span> <span class="s2">"c"</span> <span class="p">]</span> <span class="s2">"Hello, Irmin!"</span>
      <span class="o">~</span><span class="n">info</span><span class="o">:</span><span class="p">(</span><span class="n">info</span> <span class="s2">"my first commit"</span><span class="p">)</span>
  <span class="k">in</span>
  <span class="c">(* Get a/b/c *)</span>
  <span class="k">let</span><span class="o">+</span> <span class="n">s</span> <span class="o">=</span> <span class="nn">Git_store</span><span class="p">.</span><span class="n">get</span> <span class="n">t</span> <span class="p">[</span> <span class="s2">"a"</span><span class="p">;</span> <span class="s2">"b"</span><span class="p">;</span> <span class="s2">"c"</span> <span class="p">]</span> <span class="k">in</span>
  <span class="k">assert</span> <span class="p">(</span><span class="n">s</span> <span class="o">=</span> <span class="s2">"Hello, Irmin!"</span><span class="p">)</span>

<span class="k">let</span> <span class="bp">()</span> <span class="o">=</span> <span class="nn">Lwt_main</span><span class="p">.</span><span class="n">run</span> <span class="n">main</span>
</code></pre></div></div>

<p>I’m pretty excited about the possibilities.</p>
