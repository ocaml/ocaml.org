---
title: Shuffling Lists
description: Shuffling a list into a random order is usually handled by the Fisher-Yates
  Shuffle.
url: https://www.tunbury.org/2025/08/04/list-shuffle/
date: 2025-08-04T00:00:00-00:00
preview_image: https://www.tunbury.org/images/ocaml-logo.png
authors:
- Mark Elvers
source:
ignore:
---

<p>Shuffling a list into a random order is usually handled by the <a href="https://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle">Fisher-Yates Shuffle</a>.</p>

<p>It could be efficiently written in OCaml using arrays:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="nn">Random</span><span class="p">.</span><span class="n">self_init</span> <span class="bp">()</span><span class="p">;</span>

<span class="k">let</span> <span class="n">fisher_yates_shuffle</span> <span class="n">arr</span> <span class="o">=</span>
  <span class="k">let</span> <span class="n">n</span> <span class="o">=</span> <span class="nn">Array</span><span class="p">.</span><span class="n">length</span> <span class="n">arr</span> <span class="k">in</span>
  <span class="k">for</span> <span class="n">i</span> <span class="o">=</span> <span class="n">n</span> <span class="o">-</span> <span class="mi">1</span> <span class="k">downto</span> <span class="mi">1</span> <span class="k">do</span>
    <span class="k">let</span> <span class="n">j</span> <span class="o">=</span> <span class="nn">Random</span><span class="p">.</span><span class="n">int</span> <span class="p">(</span><span class="n">i</span> <span class="o">+</span> <span class="mi">1</span><span class="p">)</span> <span class="k">in</span>
    <span class="k">let</span> <span class="n">temp</span> <span class="o">=</span> <span class="n">arr</span><span class="o">.</span><span class="p">(</span><span class="n">i</span><span class="p">)</span> <span class="k">in</span>
    <span class="n">arr</span><span class="o">.</span><span class="p">(</span><span class="n">i</span><span class="p">)</span> <span class="o">&lt;-</span> <span class="n">arr</span><span class="o">.</span><span class="p">(</span><span class="n">j</span><span class="p">);</span>
    <span class="n">arr</span><span class="o">.</span><span class="p">(</span><span class="n">j</span><span class="p">)</span> <span class="o">&lt;-</span> <span class="n">temp</span>
  <span class="k">done</span>
</code></pre></div></div>

<p>However, I had a one-off requirement to randomise a list, and this approach felt very <em>functional</em>.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="nn">Random</span><span class="p">.</span><span class="n">self_init</span> <span class="bp">()</span><span class="p">;</span>

<span class="k">let</span> <span class="n">shuffle</span> <span class="n">lst</span> <span class="o">=</span>
  <span class="nn">List</span><span class="p">.</span><span class="n">map</span> <span class="p">(</span><span class="k">fun</span> <span class="n">x</span> <span class="o">-&gt;</span> <span class="p">(</span><span class="nn">Random</span><span class="p">.</span><span class="n">bits</span> <span class="bp">()</span><span class="o">,</span> <span class="n">x</span><span class="p">))</span> <span class="n">lst</span> <span class="o">|&gt;</span> <span class="nn">List</span><span class="p">.</span><span class="n">sort</span> <span class="n">compare</span> <span class="o">|&gt;</span> <span class="nn">List</span><span class="p">.</span><span class="n">map</span> <span class="n">snd</span>
</code></pre></div></div>
