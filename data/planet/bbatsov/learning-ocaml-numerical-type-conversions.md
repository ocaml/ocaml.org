---
title: 'Learning OCaml: Numerical Type Conversions'
description: "Today I\u2019m going to cover a very basic topic - conversions between
  OCaml\u2019s primary numeric types int and float. I guess most of you are wondering
  if such a basic topic deserves a special treatment, but if you read on I promise
  that it will be worth it."
url: https://batsov.com/articles/2025/07/19/learning-ocaml-numerical-type-conversions/
date: 2025-07-19T08:12:00-00:00
preview_image: https://batsov.com/assets/images/bozhidar_avatar.jpg
authors:
- Bozhidar Batsov
source:
ignore:
---

<p>Today I’m going to cover a very basic topic - conversions between
OCaml’s primary numeric types <code class="language-plaintext highlighter-rouge">int</code> and <code class="language-plaintext highlighter-rouge">float</code>. I guess most of you
are wondering if such a basic topic deserves a special treatment, but
if you read on I promise that it will be worth it.</p>

<p>So, let’s start with the basics that probably everyone knows:</p>

<ul>
  <li>you can convert integers to floats with <code class="language-plaintext highlighter-rouge">float_of_int</code></li>
  <li>you can convert floats to integers with <code class="language-plaintext highlighter-rouge">int_of_float</code></li>
</ul>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="n">int_of_float</span> <span class="mi">10</span><span class="o">.</span><span class="mi">5</span><span class="p">;;</span>
<span class="o">-</span> <span class="o">:</span> <span class="kt">int</span> <span class="o">=</span> <span class="mi">10</span>
<span class="n">float_of_int</span> <span class="mi">9</span><span class="p">;;</span>
<span class="o">-</span> <span class="o">:</span> <span class="kt">float</span> <span class="o">=</span> <span class="mi">9</span>
</code></pre></div></div>

<p>Both functions live in <code class="language-plaintext highlighter-rouge">Stdlib</code> module, which is opened by default in OCaml.
Here it gets a bit more interesting. For whatever reasons there’s
also a <code class="language-plaintext highlighter-rouge">float</code> function, that’s a synonym to <code class="language-plaintext highlighter-rouge">float_of_int</code>. There’s
no <code class="language-plaintext highlighter-rouge">int</code> function, however. Go figure why…</p>

<p>Here’s a bit of trivia for you - <code class="language-plaintext highlighter-rouge">int_of_float</code> does truncation to
produce an integer. And there’s also a <code class="language-plaintext highlighter-rouge">truncate</code> function that’s
another alias for <code class="language-plaintext highlighter-rouge">int_of_float</code>. Again, for whatever reasons it seems
there are no functions that allow you to produce an integer by rounding
up or down. (although such functions exist for floats - e.g. <code class="language-plaintext highlighter-rouge">Float.round</code>, <code class="language-plaintext highlighter-rouge">Float.floor</code>
and <code class="language-plaintext highlighter-rouge">Float.ceil</code>)</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="n">int_of_float</span> <span class="mi">5</span><span class="o">.</span><span class="mi">5</span><span class="p">;;</span>
<span class="o">-</span> <span class="o">:</span> <span class="kt">int</span> <span class="o">=</span> <span class="mi">5</span>
<span class="n">truncate</span> <span class="mi">5</span><span class="o">.</span><span class="mi">5</span><span class="p">;;</span>
<span class="o">-</span> <span class="o">:</span> <span class="kt">int</span> <span class="o">=</span> <span class="mi">5</span>
<span class="mi">5</span><span class="o">.</span><span class="mi">5</span> <span class="o">|&gt;</span> <span class="nn">Float</span><span class="p">.</span><span class="n">round</span> <span class="o">|&gt;</span> <span class="n">int_of_float</span><span class="p">;;</span>
<span class="o">-</span> <span class="o">:</span> <span class="kt">int</span> <span class="o">=</span> <span class="mi">6</span>
</code></pre></div></div>

<p>More interestingly, OCaml 4.08 introduced the modules <code class="language-plaintext highlighter-rouge">Int</code> and <code class="language-plaintext highlighter-rouge">Float</code>
that bring together common functions for operating on integers and floats.<sup role="doc-noteref"><a href="https://batsov.com/feeds/OCaml.xml#fn:1" class="footnote" rel="footnote">1</a></sup>
And there are plenty of type conversion functions in those modules as well:</p>

<ul>
  <li><code class="language-plaintext highlighter-rouge">Int.to_float</code> and <code class="language-plaintext highlighter-rouge">Int.of_float</code></li>
  <li><code class="language-plaintext highlighter-rouge">Float.of_int</code> and <code class="language-plaintext highlighter-rouge">Float.to_int</code></li>
  <li><code class="language-plaintext highlighter-rouge">Int.to_string</code> and <code class="language-plaintext highlighter-rouge">Float.to_string</code></li>
</ul>

<p>The introduction of the <code class="language-plaintext highlighter-rouge">Int</code> and <code class="language-plaintext highlighter-rouge">Float</code> modules was part of (ongoing)
effort to make OCaml’s library more modular and more useful. I think
that’s great and I hope you’ll agree that most of the time it’s a
better idea to use the new modules instead of reaching to the
“historical” functions in the <code class="language-plaintext highlighter-rouge">Stdlib</code> module. Sadly, most OCaml
tutorials out there make no mention of the new modules, so I’m hoping that
my article (and tools like ChatGPT) will steer more people in the right direction.</p>

<p>If you’re familiar with Jane Street’s <code class="language-plaintext highlighter-rouge">Base</code>, you’ll probably notice that
it also employs similar structure when it comes to integer and float functionality.</p>

<p>Which type conversion functions do you prefer? Why?</p>

<p>That’s all I have for you today. Keep hacking!</p>

<div class="footnotes" role="doc-endnotes">
  <ol>
    <li role="doc-endnote">
      <p>Technically speaking, <code class="language-plaintext highlighter-rouge">Float</code> existed before 4.08, but it was extended then. 4.08 also introduced the modules <code class="language-plaintext highlighter-rouge">Bool</code>, <code class="language-plaintext highlighter-rouge">Fun</code>, <code class="language-plaintext highlighter-rouge">Option</code> and <code class="language-plaintext highlighter-rouge">Result</code>. Good stuff!&nbsp;<a href="https://batsov.com/feeds/OCaml.xml#fnref:1" class="reversefootnote" role="doc-backlink">↩</a></p>
    </li>
  </ol>
</div>
