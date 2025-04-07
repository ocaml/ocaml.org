---
title: 'Learning OCaml: Parsing Data with Scanf'
description: "In my previous article I mentioned that OCaml\u2019s Stdlib leaves a
  lot to be desire when it comes to regular expressions. One thing I didn\u2019t discuss
  back then was that the problem is somewhat mitigated by the excellent module Scanf,
  which makes it easy to parse structured data."
url: https://batsov.com/articles/2025/04/06/learning-ocaml-parsing-data-with-scanf/
date: 2025-04-06T08:40:00-00:00
preview_image: https://batsov.com/assets/images/bozhidar_avatar.jpg
authors:
- Bozhidar Batsov
source:
---

<p>In my <a href="https://batsov.com/articles/2025/04/04/learning-ocaml-regular-expressions/">previous article</a> I mentioned that OCaml’s
<code class="language-plaintext highlighter-rouge">Stdlib</code> leaves a lot to be desire when it comes to regular
expressions. One thing I didn’t discuss back then was that
the problem is somewhat mitigated by the excellent module
<a href="https://ocaml.org/manual/5.3/api/Scanf.html">Scanf</a>, which makes it easy to parse structured data.</p>

<p>Image that we’re dealing with a simple investment portfolio,
where we have multiple records containing:</p>

<ul>
  <li>Ticker symbol (e.g. <code class="language-plaintext highlighter-rouge">AAPL</code>)</li>
  <li>Number of shares</li>
  <li>Current share price</li>
</ul>

<p>Let’s assume this portfolio is stored in <code class="language-plaintext highlighter-rouge">.csv</code> file and each
entry there looks something like <code class="language-plaintext highlighter-rouge">APPL,10,150.50</code>. While there
are many ways to parse this data, I think <code class="language-plaintext highlighter-rouge">Scanf</code> is probably
the simplest and most elegant of them:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="nn">Scanf</span><span class="p">.</span><span class="n">sscanf</span> <span class="s2">"AAPL, 10, 150.5"</span> <span class="s2">"%[^,], %d, %f"</span> <span class="p">(</span><span class="k">fun</span> <span class="n">ticker</span> <span class="n">shares</span> <span class="n">price</span> <span class="o">-&gt;</span> <span class="p">(</span><span class="n">ticker</span><span class="o">,</span> <span class="n">shares</span><span class="o">,</span> <span class="n">price</span><span class="p">));;</span>
<span class="o">-</span> <span class="o">:</span> <span class="kt">string</span> <span class="o">*</span> <span class="kt">int</span> <span class="o">*</span> <span class="kt">float</span> <span class="o">=</span> <span class="p">(</span><span class="s2">"AAPL"</span><span class="o">,</span> <span class="mi">10</span><span class="o">,</span> <span class="mi">150</span><span class="o">.</span><span class="mi">5</span><span class="p">)</span>
</code></pre></div></div>

<p>As you can see we’re using a parsing format specifier that’s pretty similar to what we’d
normally use with <code class="language-plaintext highlighter-rouge">printf</code>. <code class="language-plaintext highlighter-rouge">%[^,]</code> is kind of weird and it means “read string until ,”.
We can’t use the regular <code class="language-plaintext highlighter-rouge">%s</code> format specifier here, as it expects space-separated strings.
This, however, will work fine with <code class="language-plaintext highlighter-rouge">%s</code>:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="nn">Scanf</span><span class="p">.</span><span class="n">sscanf</span> <span class="s2">"John Doe 33"</span> <span class="s2">"%s %s %d"</span> <span class="p">(</span><span class="k">fun</span> <span class="n">name</span> <span class="n">surname</span> <span class="n">age</span> <span class="o">-&gt;</span> <span class="p">(</span><span class="n">name</span><span class="o">,</span> <span class="n">surname</span><span class="o">,</span> <span class="n">age</span><span class="p">));;</span>
<span class="o">-</span> <span class="o">:</span> <span class="kt">string</span> <span class="o">*</span> <span class="kt">string</span> <span class="o">*</span> <span class="kt">int</span> <span class="o">=</span> <span class="p">(</span><span class="s2">"John"</span><span class="o">,</span> <span class="s2">"Doe"</span><span class="o">,</span> <span class="mi">33</span><span class="p">)</span>
</code></pre></div></div>

<p>Here’s a more complete example that parses a few portfolio records and
calculates the value of the portfolio:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="c">(* Example portfolio entries as strings *)</span>
<span class="k">let</span> <span class="n">portfolio_lines</span> <span class="o">=</span> <span class="p">[</span>
  <span class="s2">"AAPL,10,178.23"</span><span class="p">;</span>
  <span class="s2">"GOOG,5,150.50"</span><span class="p">;</span>
  <span class="s2">"MSFT,20,299.01"</span><span class="p">;</span>
<span class="p">]</span>

<span class="c">(* Parse a line into (ticker, shares, price) *)</span>
<span class="k">let</span> <span class="n">parse_line</span> <span class="n">line</span> <span class="o">=</span>
  <span class="nn">Scanf</span><span class="p">.</span><span class="n">sscanf</span> <span class="n">line</span> <span class="s2">"%[^,],%d,%f"</span> <span class="p">(</span><span class="k">fun</span> <span class="n">ticker</span> <span class="n">shares</span> <span class="n">price</span> <span class="o">-&gt;</span>
    <span class="p">(</span><span class="n">ticker</span><span class="o">,</span> <span class="n">shares</span><span class="o">,</span> <span class="n">price</span><span class="p">)</span>
  <span class="p">)</span>

<span class="c">(* Compute total value of the portfolio *)</span>
<span class="k">let</span> <span class="n">total_value</span> <span class="n">entries</span> <span class="o">=</span>
  <span class="nn">List</span><span class="p">.</span><span class="n">fold_left</span> <span class="p">(</span><span class="k">fun</span> <span class="n">acc</span> <span class="p">(</span><span class="n">_ticker</span><span class="o">,</span> <span class="n">shares</span><span class="o">,</span> <span class="n">price</span><span class="p">)</span> <span class="o">-&gt;</span>
    <span class="n">acc</span> <span class="o">+.</span> <span class="n">float_of_int</span> <span class="n">shares</span> <span class="o">*.</span> <span class="n">price</span>
  <span class="p">)</span> <span class="mi">0</span><span class="o">.</span><span class="mi">0</span> <span class="n">entries</span>

<span class="k">let</span> <span class="bp">()</span> <span class="o">=</span>
  <span class="k">let</span> <span class="k">open</span> <span class="nc">Printf</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">portfolio</span> <span class="o">=</span> <span class="nn">List</span><span class="p">.</span><span class="n">map</span> <span class="n">parse_line</span> <span class="n">portfolio_lines</span> <span class="k">in</span>
  <span class="nn">List</span><span class="p">.</span><span class="n">iter</span> <span class="p">(</span><span class="k">fun</span> <span class="p">(</span><span class="n">ticker</span><span class="o">,</span> <span class="n">shares</span><span class="o">,</span> <span class="n">price</span><span class="p">)</span> <span class="o">-&gt;</span>
    <span class="n">printf</span> <span class="s2">"%s: %d shares at $%.2f</span><span class="se">\n</span><span class="s2">"</span> <span class="n">ticker</span> <span class="n">shares</span> <span class="n">price</span>
  <span class="p">)</span> <span class="n">portfolio</span><span class="p">;</span>
  <span class="k">let</span> <span class="n">total</span> <span class="o">=</span> <span class="n">total_value</span> <span class="n">portfolio</span> <span class="k">in</span>
  <span class="n">printf</span> <span class="s2">"Total portfolio value: $%.2f</span><span class="se">\n</span><span class="s2">"</span> <span class="n">total</span>
</code></pre></div></div>

<p>Not bad, right?</p>

<p><code class="language-plaintext highlighter-rouge">Scanf</code> has several functions in it and quite a lot of format specifiers that you can
leverage in various situations.</p>

<p>The formatted input functions can read from any kind of input, including
strings, files, or anything that can return characters. The more general source
of characters is named a formatted input channel (or scanning buffer) and has
type <code class="language-plaintext highlighter-rouge">Scanf.Scanning.in_channel</code>. The more general formatted input function reads
from any scanning buffer and is named <code class="language-plaintext highlighter-rouge">bscanf</code>.</p>

<p>Generally speaking, the formatted input functions have 3 arguments:</p>

<ul>
  <li>the first argument is a source of characters for the input,</li>
  <li>the second argument is a format string that specifies the values to read,</li>
  <li>the third argument is a receiver function that is applied to the values read.</li>
</ul>

<p>My trivial examples dealt only with input strings, but you can easily leverage
other input sources. Here’s an example reading from the standard input:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="nn">Scanf</span><span class="p">.</span><span class="n">scanf</span> <span class="s2">"%s %f</span><span class="se">\n</span><span class="s2">"</span> <span class="p">(</span><span class="k">fun</span> <span class="n">name</span> <span class="n">price</span> <span class="o">-&gt;</span>
    <span class="nn">Printf</span><span class="p">.</span><span class="n">printf</span> <span class="s2">"Item: %s, Price: %.2f</span><span class="se">\n</span><span class="s2">"</span> <span class="n">name</span> <span class="n">price</span><span class="p">)</span>

<span class="c">(* input -&gt; Table 100.20 *)</span>

<span class="c">(* output -&gt; Item: Table, Price: 100.20 *)</span>
<span class="o">-</span> <span class="o">:</span> <span class="kt">unit</span> <span class="o">=</span> <span class="bp">()</span>
</code></pre></div></div>

<p>Enter something like “Chair 20.25” and observe the results.</p>

<p>I’d encourage everyone to get familiar with the module’s
documentation for all the nitty-gritty details.</p>

<p>Please, share in the comments how you’re using <code class="language-plaintext highlighter-rouge">Scanf</code> in your OCaml projects and any tips
you might have about making the best of it.</p>

<p>That’s all I have for you. Keep hacking!</p>
