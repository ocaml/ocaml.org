---
title: Terminal GUI for ocluster monitoring
description: "I\u2019ve been thinking about terminal-based GUI applications recently
  and decided to give notty a try."
url: https://www.tunbury.org/2025/08/24/ocluster-monitor/
date: 2025-08-24T00:00:00-00:00
preview_image: https://www.tunbury.org/images/ocluster-monitor.png
authors:
- Mark Elvers
source:
ignore:
---

<p>I’ve been thinking about terminal-based GUI applications recently and decided to give <a href="https://ocaml.org/p/notty/latest">notty</a> a try.</p>

<p>I decided to write a tool to display the status of the <a href="https://github.com/ocurrent/ocsluter">ocurrent/ocluster</a> in the terminal by gathering the statistics from <code class="language-plaintext highlighter-rouge">ocluster-admin</code>. I want to have histograms showing each pool’s current utilisation and backlog. The histograms will resize vertically and horizontally as the terminal size changes. And yes, I do love <code class="language-plaintext highlighter-rouge">btop</code>.</p>

<p>It’s functional, but still a work in progress. <a href="https://github.com/mtelvers/ocluster-monitor">mtelvers/ocluster-monitor</a></p>

<p>The histogram module uses braille characters (U+2800-U+28FF) to create dense visualizations where each character can represent up to 2x4 data points using the dots of a braille cell. In the code, these positions map to bit values:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>Left Column Bits    Right Column Bits
   0x01 (1)            0x08 (4)
   0x02 (2)            0x10 (5)
   0x04 (3)            0x20 (6)
   0x40 (7)            0x80 (8)
</code></pre></div></div>

<h1>1. Bit Mapping</h1>
<p>The code defines bit arrays for each column:</p>
<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">left_bits</span> <span class="o">=</span> <span class="p">[</span> <span class="mh">0x40</span><span class="p">;</span> <span class="mh">0x04</span><span class="p">;</span> <span class="mh">0x02</span><span class="p">;</span> <span class="mh">0x01</span> <span class="p">]</span>   <span class="c">(* Bottom to top *)</span>
<span class="k">let</span> <span class="n">right_bits</span> <span class="o">=</span> <span class="p">[</span> <span class="mh">0x80</span><span class="p">;</span> <span class="mh">0x20</span><span class="p">;</span> <span class="mh">0x10</span><span class="p">;</span> <span class="mh">0x08</span> <span class="p">]</span>  <span class="c">(* Bottom to top *)</span>
</code></pre></div></div>

<h1>2. Height to Dots Conversion</h1>
<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">level</span> <span class="o">=</span> <span class="n">int_of_float</span> <span class="p">(</span><span class="n">height</span> <span class="o">*.</span> <span class="mi">4</span><span class="o">.</span><span class="mi">0</span><span class="p">)</span>
</code></pre></div></div>
<p>This converts a height value (0.0-1.0) to the number of dots to fill (0-4).</p>

<h1>3. Dot Pattern Generation</h1>
<p>For each column, the algorithm:</p>
<ol>
  <li>Iterates through the bit array from bottom to top</li>
  <li>Sets each bit if the current level is high enough</li>
  <li>Uses bitwise OR to combine all active dots</li>
</ol>

<h1>4. Character Assembly</h1>
<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">braille_char</span> <span class="o">=</span> <span class="n">braille_base</span> <span class="ow">lor</span> <span class="n">left_dots</span> <span class="ow">lor</span> <span class="n">right_dots</span>
</code></pre></div></div>
<ul>
  <li><code class="language-plaintext highlighter-rouge">braille_base</code> = 0x2800 (base braille character)</li>
  <li><code class="language-plaintext highlighter-rouge">left_dots</code> and <code class="language-plaintext highlighter-rouge">right_dots</code> are OR’d together</li>
  <li>Result is converted to a Unicode character</li>
</ul>

<h1>5. Multi-Row Histograms</h1>
<p>For taller displays, the histogram is split into multiple rows:</p>
<ul>
  <li>Each row represents a fraction of the total height</li>
  <li>Data values are normalized to fit within each row’s range</li>
  <li>Rows are generated from top to bottom</li>
</ul>
