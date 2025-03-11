---
title: 'OCaml Tips: Converting a String to a List of Characters'
description: "While playing with OCaml I was surprised to learn there\u2019s no built-in
  function the convert a string to a list of its characters. Admittedly, that\u2019s
  not something you need very often, but it does come handy from time to time. There
  are many ways to implement such a function ourselves and the one I like the most
  makes use of List.init:"
url: https://batsov.com/articles/2022/10/24/ocaml-tips-converting-a-string-to-a-list-of-characters/
date: 2022-10-24T07:33:00-00:00
preview_image: https://batsov.com/assets/images/bozhidar_avatar.jpg
authors:
- Bozhidar Batsov
source:
---

<p>While playing with OCaml I was surprised to learn there’s no built-in
function the convert a string to a list of its characters. Admittedly, that’s
not something you need very often, but it does come handy from time to time.
There are many ways to implement such a function ourselves and the one I like
the most makes use of <code class="language-plaintext highlighter-rouge">List.init</code>:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">explode_string</span> <span class="n">s</span> <span class="o">=</span> <span class="nn">List</span><span class="p">.</span><span class="n">init</span> <span class="p">(</span><span class="nn">String</span><span class="p">.</span><span class="n">length</span> <span class="n">s</span><span class="p">)</span> <span class="p">(</span><span class="nn">String</span><span class="p">.</span><span class="n">get</span> <span class="n">s</span><span class="p">);;</span>
<span class="k">val</span> <span class="n">explode_string</span> <span class="o">:</span> <span class="kt">string</span> <span class="o">-&gt;</span> <span class="kt">char</span> <span class="kt">list</span> <span class="o">=</span> <span class="o">&lt;</span><span class="k">fun</span><span class="o">&gt;</span>

<span class="n">explode_string</span> <span class="s2">"hello, world!"</span><span class="p">;;</span>
<span class="o">-</span> <span class="o">:</span> <span class="kt">char</span> <span class="kt">list</span> <span class="o">=</span> <span class="p">[</span><span class="k">'</span><span class="n">h'</span><span class="p">;</span> <span class="k">'</span><span class="n">e'</span><span class="p">;</span> <span class="k">'</span><span class="n">l'</span><span class="p">;</span> <span class="k">'</span><span class="n">l'</span><span class="p">;</span> <span class="k">'</span><span class="n">o'</span><span class="p">;</span> <span class="k">'</span><span class="o">,</span><span class="k">'</span><span class="p">;</span> <span class="k">'</span> <span class="k">'</span><span class="p">;</span> <span class="k">'</span><span class="n">w'</span><span class="p">;</span> <span class="k">'</span><span class="n">o'</span><span class="p">;</span> <span class="k">'</span><span class="n">r'</span><span class="p">;</span> <span class="k">'</span><span class="n">l'</span><span class="p">;</span> <span class="k">'</span><span class="n">d'</span><span class="p">;</span> <span class="k">'</span><span class="o">!</span><span class="k">'</span><span class="p">]</span>
</code></pre></div></div>

<p>I went with the name <code class="language-plaintext highlighter-rouge">explode_string</code> as the name <code class="language-plaintext highlighter-rouge">explode</code> is often used to describe this type of operation (with <code class="language-plaintext highlighter-rouge">implode</code> being the name of the inverse operation).</p>

<p>Searching for the signature <code class="language-plaintext highlighter-rouge">string -&gt; char list</code> on <a href="https://doc.sherlocode.com/">Sherlodoc</a> reveals that many libraries offer some version of the above function.
Perhaps one day we’ll have something like <code class="language-plaintext highlighter-rouge">String.to_list</code> in the standard library.</p>

<p>By the way, it’s also pretty easy to define the inverse operation - namely creating a string out of a list of characters:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">implode_char_list</span> <span class="n">l</span> <span class="o">=</span> <span class="nn">String</span><span class="p">.</span><span class="n">of_seq</span> <span class="p">(</span><span class="nn">List</span><span class="p">.</span><span class="n">to_seq</span> <span class="n">l</span><span class="p">);;</span>
<span class="k">val</span> <span class="n">implode_char_list</span> <span class="o">:</span> <span class="kt">char</span> <span class="kt">list</span> <span class="o">-&gt;</span> <span class="kt">string</span> <span class="o">=</span> <span class="o">&lt;</span><span class="k">fun</span><span class="o">&gt;</span>

<span class="n">implode_char_list</span> <span class="p">(</span><span class="n">explode_string</span> <span class="s2">"hello"</span><span class="p">);;</span>
<span class="o">-</span> <span class="o">:</span> <span class="kt">string</span> <span class="o">=</span> <span class="s2">"hello"</span>
</code></pre></div></div>

<p>Note that <code class="language-plaintext highlighter-rouge">List.init</code> was added in OCaml 4.06 and <code class="language-plaintext highlighter-rouge">String.of_seq</code> was added in OCaml 4.07.</p>

<p>Keep in mind that lists of chars are quite memory inefficient, as each character
takes 4 bytes (64 bits) on a modern 64 bit CPU.<sup role="doc-noteref"><a href="https://batsov.com/feeds/OCaml.xml#fn:1" class="footnote" rel="footnote">1</a></sup> When you factor the pointers to
the next element in the list, each character is effectively taking 8 bytes,
which is pretty far from the memory efficiency of a string. The take away is that
you should avoid using them if you’re dealing with large data sets.</p>

<p>That’s all I have for you today. Keep hacking!</p>

<div class="footnotes" role="doc-endnotes">
  <ol>
    <li role="doc-endnote">
      <p>You can learn more about OCaml’s runtime memory layout <a href="https://dev.realworldocaml.org/runtime-memory-layout.html">here</a>.&nbsp;<a href="https://batsov.com/feeds/OCaml.xml#fnref:1" class="reversefootnote" role="doc-backlink">↩</a></p>
    </li>
  </ol>
</div>
