---
title: Dipping toes into OxCaml
description: "Jane Street have been working for a few years on a whole suite of extensions
  to OCaml, many of which they\u2019ve both blogged and published about. I did some
  hacking last year getting a version of that running on Windows, which I really must
  resurrect. But today I actually had a go at doing a tiny something with its features!"
url: https://www.dra27.uk/blog/platform/2025/05/07/oxcaml-toes.html
date: 2025-05-07T00:00:00-00:00
preview_image:
authors:
- ""
source:
---

<p><a href="https://opensource.janestreet.com/">Jane Street</a> have been working for a few
years on a whole suite of extensions to OCaml, many of which they’ve both
blogged and published about. I did some hacking last year getting a version of
that running on Windows, which I really must resurrect. But today I actually had
a go at doing a tiny something with its features!</p>

<p>Stack allocation is a fascinating feature to add for me. I strongly believe that
OCaml’s strength lies in pragmatism, and the promise of stack allocated values
is that we’ll be able to write highly memory-performant code in OCaml <em>when we
want to</em> (i.e. unlike in Rust, when we really don’t care, we can just leave it
all to the GC as normal) and without having to compromise massively that code.</p>

<p>I’ve dusted off the first day of <a href="https://adventofcode.com/2024/day/1">Advent of Code 2024</a>.
Initially, not looking at solving the actual puzzle, but my input is 1000 lines
of text where each line is two 5 digit numbers separated by three spaces. Here’s
a trivial snippet over that:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">f</span> <span class="n">a</span> <span class="n">_s</span> <span class="o">=</span> <span class="n">succ</span> <span class="n">a</span>

<span class="k">let</span> <span class="n">execute</span> <span class="n">file</span> <span class="o">=</span>
  <span class="nn">In_channel</span><span class="p">.</span><span class="n">with_open_text</span> <span class="n">file</span> <span class="p">(</span><span class="nn">In_channel</span><span class="p">.</span><span class="n">fold_lines</span> <span class="n">f</span> <span class="mi">0</span><span class="p">)</span>

<span class="k">let</span> <span class="bp">()</span> <span class="o">=</span>
  <span class="k">let</span> <span class="n">c1</span> <span class="o">=</span> <span class="nn">Gc</span><span class="p">.</span><span class="n">minor_words</span> <span class="bp">()</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">r</span> <span class="o">=</span> <span class="n">execute</span> <span class="s2">"input-01"</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">c2</span> <span class="o">=</span> <span class="nn">Gc</span><span class="p">.</span><span class="n">minor_words</span> <span class="bp">()</span> <span class="k">in</span>
  <span class="nn">Printf</span><span class="p">.</span><span class="n">printf</span>
    <span class="s2">"Result: %d</span><span class="se">\n</span><span class="s2">%.0f words allocated across the call</span><span class="se">\n</span><span class="s2">"</span> <span class="n">r</span> <span class="p">(</span><span class="n">c2</span> <span class="o">-.</span> <span class="n">c1</span><span class="p">)</span>
</code></pre></div></div>

<p>This is just counting the number of lines and for me is showing 3012 words
allocated on the minor heap. There are 1000 lines in the file each of which
needs 14 bytes (including the terminator) so, until one of our GC experts
corrects me, I reckon that’s 1000 headers, 2000 words containing the strings
themselves and we can wave our hands about the channel and closure in those
calls to account for the other 12 words.</p>

<p>So far, so good - this is just counting the lines. Now, as a further toy example
(if one were really concerned about performance, this is totally not the way to
do this…), let’s add them up instead:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">f</span> <span class="n">a</span> <span class="n">s</span> <span class="o">=</span>
  <span class="k">let</span> <span class="n">fst</span> <span class="o">=</span> <span class="nn">String</span><span class="p">.</span><span class="n">sub</span> <span class="n">s</span> <span class="mi">0</span> <span class="mi">5</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">snd</span> <span class="o">=</span> <span class="nn">String</span><span class="p">.</span><span class="n">sub</span> <span class="n">s</span> <span class="mi">8</span> <span class="mi">5</span> <span class="k">in</span>
  <span class="n">a</span> <span class="o">+</span> <span class="n">int_of_string</span> <span class="n">fst</span> <span class="o">+</span> <span class="n">int_of_string</span> <span class="n">snd</span>
</code></pre></div></div>

<p>That gives me 7012 minor words - another 4000, which corresponds to all of those
<code class="language-plaintext highlighter-rouge">String.sub</code> calls (2000 6-byte strings, 2000 header words). So what can stack
allocation bring us? Well, I’m wanting to “lift the bonnet” with all this, so
rather than using Base, let’s have a little bit of hand-rolled support (I said
this was a toy example):</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">module</span> <span class="nc">String</span> <span class="o">=</span> <span class="k">struct</span>
  <span class="k">include</span> <span class="nc">String</span>

  <span class="k">external</span> <span class="n">unsafe_create_local</span> <span class="o">:</span> <span class="kt">int</span> <span class="o">-&gt;</span> <span class="n">local_</span> <span class="n">bytes</span> <span class="o">=</span> <span class="s2">"caml_create_local_bytes"</span>

  <span class="k">external</span> <span class="n">unsafe_blit_string</span> <span class="o">:</span>
    <span class="p">(</span><span class="kt">string</span><span class="p">[</span><span class="o">@</span><span class="n">local_opt</span><span class="p">])</span> <span class="o">-&gt;</span> <span class="kt">int</span> <span class="o">-&gt;</span> <span class="p">(</span><span class="n">bytes</span><span class="p">[</span><span class="o">@</span><span class="n">local_opt</span><span class="p">])</span> <span class="o">-&gt;</span> <span class="kt">int</span> <span class="o">-&gt;</span> <span class="kt">int</span> <span class="o">-&gt;</span> <span class="kt">unit</span>
      <span class="o">=</span> <span class="s2">"caml_blit_string"</span> <span class="p">[</span><span class="o">@@</span><span class="n">noalloc</span><span class="p">]</span>

  <span class="k">external</span> <span class="n">unsafe_to_string</span> <span class="o">:</span>
    <span class="p">(</span><span class="n">bytes</span><span class="p">[</span><span class="o">@</span><span class="n">local_opt</span><span class="p">])</span> <span class="o">-&gt;</span> <span class="p">(</span><span class="kt">string</span><span class="p">[</span><span class="o">@</span><span class="n">local_opt</span><span class="p">])</span> <span class="o">=</span> <span class="s2">"%bytes_to_string"</span>

  <span class="k">external</span> <span class="n">get</span> <span class="o">:</span>
    <span class="p">(</span><span class="kt">string</span><span class="p">[</span><span class="o">@</span><span class="n">local_opt</span><span class="p">])</span> <span class="o">-&gt;</span> <span class="p">(</span><span class="kt">int</span><span class="p">[</span><span class="o">@</span><span class="n">local_opt</span><span class="p">])</span> <span class="o">-&gt;</span> <span class="kt">char</span> <span class="o">=</span> <span class="s2">"%string_safe_get"</span>

  <span class="k">let</span> <span class="n">sub_local</span> <span class="n">s</span> <span class="n">ofs</span> <span class="n">len</span> <span class="o">=</span> <span class="n">exclave_</span>
    <span class="k">if</span> <span class="n">ofs</span> <span class="o">&lt;</span> <span class="mi">0</span> <span class="o">||</span> <span class="n">len</span> <span class="o">&lt;</span> <span class="mi">0</span> <span class="o">||</span> <span class="n">ofs</span> <span class="o">&gt;</span> <span class="n">length</span> <span class="n">s</span> <span class="o">-</span> <span class="n">len</span>
    <span class="k">then</span> <span class="n">invalid_arg</span> <span class="s2">"String.sub"</span>
    <span class="k">else</span> <span class="k">begin</span>
      <span class="k">let</span> <span class="n">r</span> <span class="o">=</span> <span class="n">unsafe_create_local</span> <span class="n">len</span> <span class="k">in</span>
      <span class="n">unsafe_blit_string</span> <span class="n">s</span> <span class="n">ofs</span> <span class="n">r</span> <span class="mi">0</span> <span class="n">len</span><span class="p">;</span>
      <span class="n">unsafe_to_string</span> <span class="n">r</span>
<span class="k">end</span>
</code></pre></div></div>

<p>What’s interesting to me is that this doesn’t look <em>too</em> different from an
expanded version of <code class="language-plaintext highlighter-rouge">String.sub</code> from the Standard Library:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">sub</span> <span class="n">s</span> <span class="n">ofs</span> <span class="n">len</span> <span class="o">=</span>
  <span class="k">if</span> <span class="n">ofs</span> <span class="o">&lt;</span> <span class="mi">0</span> <span class="o">||</span> <span class="n">len</span> <span class="o">&lt;</span> <span class="mi">0</span> <span class="o">||</span> <span class="n">ofs</span> <span class="o">&gt;</span> <span class="n">length</span> <span class="n">s</span> <span class="o">-</span> <span class="n">len</span>
  <span class="k">then</span> <span class="n">invalid_arg</span> <span class="s2">"String.sub / Bytes.sub"</span>
  <span class="k">else</span> <span class="k">begin</span>
    <span class="k">let</span> <span class="n">r</span> <span class="o">=</span> <span class="n">create</span> <span class="n">len</span> <span class="k">in</span>
    <span class="n">unsafe_blit</span> <span class="n">s</span> <span class="n">ofs</span> <span class="n">r</span> <span class="mi">0</span> <span class="n">len</span><span class="p">;</span>
    <span class="n">unsafe_to_string</span> <span class="n">r</span>
  <span class="k">end</span>
</code></pre></div></div>

<p>we just had to <em>choose</em> to create the stack-allocated strings (yes, yes, stack
allocated is still allocated, which isn’t necessary, of course). But we can now
plug that in:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">f</span> <span class="n">a</span> <span class="n">s</span> <span class="o">=</span>
  <span class="k">let</span> <span class="n">fst</span> <span class="o">=</span> <span class="nn">String</span><span class="p">.</span><span class="n">sub_local</span> <span class="n">s</span> <span class="mi">0</span> <span class="mi">5</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">snd</span> <span class="o">=</span> <span class="nn">String</span><span class="p">.</span><span class="n">sub_local</span> <span class="n">s</span> <span class="mi">8</span> <span class="mi">5</span> <span class="k">in</span>
  <span class="n">a</span> <span class="o">+</span> <span class="n">int_of_string</span> <span class="n">fst</span> <span class="o">+</span> <span class="n">int_of_string</span> <span class="n">snd</span>
</code></pre></div></div>

<p>and:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>   |   a + int_of_string fst + int_of_string snd
                         ^^^
Error: This value escapes its region.
</code></pre></div></div>

<p>Ah, interesting to see how it spreads: we need an updated <code class="language-plaintext highlighter-rouge">int_of_string</code>:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">external</span> <span class="n">int_of_string</span> <span class="o">:</span> <span class="p">(</span><span class="kt">string</span><span class="p">[</span><span class="o">@</span><span class="n">local_opt</span><span class="p">])</span> <span class="o">-&gt;</span> <span class="kt">int</span> <span class="o">=</span> <span class="s2">"caml_int_of_string"</span>
</code></pre></div></div>

<p>and now it works <em>and we’re back to the same allocations as when counting the
lines instead</em>!</p>

<p>All the mode inference works as you’d expect too: rewriting it so that <code class="language-plaintext highlighter-rouge">f</code> takes
the <code class="language-plaintext highlighter-rouge">sub</code> function as an argument:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">f</span> <span class="n">sub</span> <span class="n">a</span> <span class="n">s</span> <span class="o">=</span>
  <span class="k">let</span> <span class="n">fst</span> <span class="o">=</span> <span class="n">sub</span> <span class="n">s</span> <span class="mi">0</span> <span class="mi">5</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">snd</span> <span class="o">=</span> <span class="n">sub</span> <span class="n">s</span> <span class="mi">8</span> <span class="mi">5</span> <span class="k">in</span>
  <span class="n">a</span> <span class="o">+</span> <span class="n">int_of_string</span> <span class="n">fst</span> <span class="o">+</span> <span class="n">int_of_string</span> <span class="n">snd</span>

<span class="k">let</span> <span class="n">execute</span> <span class="n">sub</span> <span class="n">file</span> <span class="o">=</span>
  <span class="nn">In_channel</span><span class="p">.</span><span class="n">with_open_text</span> <span class="n">file</span> <span class="p">(</span><span class="nn">In_channel</span><span class="p">.</span><span class="n">fold_lines</span> <span class="p">(</span><span class="n">f</span> <span class="n">sub</span><span class="p">)</span> <span class="mi">0</span><span class="p">)</span>

<span class="k">let</span> <span class="n">show</span> <span class="n">name</span> <span class="n">sub</span> <span class="o">=</span>
  <span class="k">let</span> <span class="n">c1</span> <span class="o">=</span> <span class="nn">Gc</span><span class="p">.</span><span class="n">minor_words</span> <span class="bp">()</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">r</span> <span class="o">=</span> <span class="n">execute</span> <span class="n">sub</span> <span class="s2">"input-01"</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">c2</span> <span class="o">=</span> <span class="nn">Gc</span><span class="p">.</span><span class="n">minor_words</span> <span class="bp">()</span> <span class="k">in</span>
  <span class="nn">Printf</span><span class="p">.</span><span class="n">printf</span>
    <span class="s2">"Result for %s: %d</span><span class="se">\n</span><span class="s2">%.0f words allocated across the call</span><span class="se">\n</span><span class="s2">"</span>
    <span class="n">name</span> <span class="n">r</span> <span class="p">(</span><span class="n">c2</span> <span class="o">-.</span> <span class="n">c1</span><span class="p">)</span>

<span class="k">let</span> <span class="bp">()</span> <span class="o">=</span>
  <span class="n">show</span> <span class="s2">"sub"</span> <span class="nn">String</span><span class="p">.</span><span class="n">sub</span><span class="p">;</span>
  <span class="n">show</span> <span class="s2">"sub_local"</span> <span class="nn">String</span><span class="p">.</span><span class="n">sub_local</span>
</code></pre></div></div>

<p>and still 4000 words fewer on the minor heap for <code class="language-plaintext highlighter-rouge">String.sub_local</code>. Tiny first
impression: the <code class="language-plaintext highlighter-rouge">[@local_opt]</code> annotation feels quite infectious for library
authors!</p>

<p>More serious playing to come… who knows, might even re-do the puzzle!</p>
