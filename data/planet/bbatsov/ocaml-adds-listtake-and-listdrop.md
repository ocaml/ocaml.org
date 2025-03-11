---
title: OCaml Adds `List.take` and `List.drop`
description: "One of my small issues with OCaml is that the standard library is quite
  spartan. Sometimes it misses functions that are quite common in other (similar)
  languages. One such example are functions like drop, drop_while, take and take_while
  in the List module.1 What\u2019s weird is that the similar Seq module features all
  those functions since OCaml 4.14.                 I believe it was Haskell that
  populirized them.\_\u21A9"
url: https://batsov.com/articles/2024/02/23/ocaml-adds-list-take-and-list-drop/
date: 2024-02-23T07:12:00-00:00
preview_image: https://batsov.com/assets/images/bozhidar_avatar.jpg
authors:
- Bozhidar Batsov
source:
---

<p>One of my small issues with OCaml is that the standard library is quite spartan.
Sometimes it misses functions that are quite common in other (similar)
languages. One such example are functions like <code class="language-plaintext highlighter-rouge">drop</code>, <code class="language-plaintext highlighter-rouge">drop_while</code>, <code class="language-plaintext highlighter-rouge">take</code> and
<code class="language-plaintext highlighter-rouge">take_while</code> in the <a href="https://v2.ocaml.org/api/List.html">List</a> module.<sup role="doc-noteref"><a href="https://batsov.com/feeds/OCaml.xml#fn:1" class="footnote" rel="footnote">1</a></sup> What’s weird is that the similar
<a href="https://v2.ocaml.org/api/Seq.html">Seq</a> module features all those functions
since OCaml 4.14.</p>

<p>Fortunately, that’s finally changing! While perusing the <a href="https://github.com/ocaml/ocaml/blob/trunk/Changes">OCaml
changelog</a> a few days ago, I
noticed a reference to a <a href="https://github.com/ocaml/ocaml/pull/9968">recently merged pull
request</a> that adds the missing <code class="language-plaintext highlighter-rouge">List</code>
functions. It’s interesting that this PR is a follow-up to another PR that was a
bit more ambitious and was created <a href="https://github.com/ocaml/ocaml/pull/9968">way back in Oct
2020</a>. Oh, well - better late than
never, right?</p>

<p>As you can imagine there’s nothing fancy about the implementation of the new functions:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">take</span> <span class="n">n</span> <span class="n">l</span> <span class="o">=</span>
  <span class="k">let</span><span class="p">[</span><span class="o">@</span><span class="n">tail_mod_cons</span><span class="p">]</span> <span class="k">rec</span> <span class="n">aux</span> <span class="n">n</span> <span class="n">l</span> <span class="o">=</span>
    <span class="k">match</span> <span class="n">n</span><span class="o">,</span> <span class="n">l</span> <span class="k">with</span>
    <span class="o">|</span> <span class="mi">0</span><span class="o">,</span> <span class="n">_</span> <span class="o">|</span> <span class="n">_</span><span class="o">,</span> <span class="bp">[]</span> <span class="o">-&gt;</span> <span class="bp">[]</span>
    <span class="o">|</span> <span class="n">n</span><span class="o">,</span> <span class="n">x</span><span class="o">::</span><span class="n">l</span> <span class="o">-&gt;</span> <span class="n">x</span><span class="o">::</span><span class="n">aux</span> <span class="p">(</span><span class="n">n</span> <span class="o">-</span> <span class="mi">1</span><span class="p">)</span> <span class="n">l</span>
  <span class="k">in</span>
  <span class="k">if</span> <span class="n">n</span> <span class="o">&lt;</span> <span class="mi">0</span> <span class="k">then</span> <span class="n">invalid_arg</span> <span class="s2">"List.take"</span><span class="p">;</span>
  <span class="n">aux</span> <span class="n">n</span> <span class="n">l</span>

<span class="k">let</span> <span class="n">drop</span> <span class="n">n</span> <span class="n">l</span> <span class="o">=</span>
  <span class="k">let</span> <span class="k">rec</span> <span class="n">aux</span> <span class="n">i</span> <span class="o">=</span> <span class="k">function</span>
    <span class="o">|</span> <span class="n">_x</span><span class="o">::</span><span class="n">l</span> <span class="k">when</span> <span class="n">i</span> <span class="o">&lt;</span> <span class="n">n</span> <span class="o">-&gt;</span> <span class="n">aux</span> <span class="p">(</span><span class="n">i</span> <span class="o">+</span> <span class="mi">1</span><span class="p">)</span> <span class="n">l</span>
    <span class="o">|</span> <span class="n">rest</span> <span class="o">-&gt;</span> <span class="n">rest</span>
  <span class="k">in</span>
  <span class="k">if</span> <span class="n">n</span> <span class="o">&lt;</span> <span class="mi">0</span> <span class="k">then</span> <span class="n">invalid_arg</span> <span class="s2">"List.drop"</span><span class="p">;</span>
  <span class="n">aux</span> <span class="mi">0</span> <span class="n">l</span>

<span class="k">let</span> <span class="n">take_while</span> <span class="n">p</span> <span class="n">l</span> <span class="o">=</span>
  <span class="k">let</span><span class="p">[</span><span class="o">@</span><span class="n">tail_mod_cons</span><span class="p">]</span> <span class="k">rec</span> <span class="n">aux</span> <span class="o">=</span> <span class="k">function</span>
    <span class="o">|</span> <span class="n">x</span><span class="o">::</span><span class="n">l</span> <span class="k">when</span> <span class="n">p</span> <span class="n">x</span> <span class="o">-&gt;</span> <span class="n">x</span><span class="o">::</span><span class="n">aux</span> <span class="n">l</span>
    <span class="o">|</span> <span class="n">_rest</span> <span class="o">-&gt;</span> <span class="bp">[]</span>
  <span class="k">in</span>
  <span class="n">aux</span> <span class="n">l</span>

<span class="k">let</span> <span class="k">rec</span> <span class="n">drop_while</span> <span class="n">p</span> <span class="o">=</span> <span class="k">function</span>
  <span class="o">|</span> <span class="n">x</span><span class="o">::</span><span class="n">l</span> <span class="k">when</span> <span class="n">p</span> <span class="n">x</span> <span class="o">-&gt;</span> <span class="n">drop_while</span> <span class="n">p</span> <span class="n">l</span>
  <span class="o">|</span> <span class="n">rest</span> <span class="o">-&gt;</span> <span class="n">rest</span>
</code></pre></div></div>

<p>Pretty standard recursive implementations. If you’re not familiar with
<code class="language-plaintext highlighter-rouge">@tail_mod_cons</code> - it’s basically tail-call optimization for <code class="language-plaintext highlighter-rouge">::</code> (a.k.a. <code class="language-plaintext highlighter-rouge">cons</code>)
in the final position of a recursive function.<sup role="doc-noteref"><a href="https://batsov.com/feeds/OCaml.xml#fn:2" class="footnote" rel="footnote">2</a></sup></p>

<p>It seems the new <code class="language-plaintext highlighter-rouge">List</code> functions will be shipped with OCaml 5.3. OCaml 5.2 is
not out at the time I’m writing this, but I’m guessing the PR missed the merge
window for 5.2.  In the mean time - we can continue to rely on the excellent
<a href="http://c-cube.github.io/ocaml-containers/last/containers/CCList/index.html">Containers
library</a>
for that functionality.</p>

<p>That’s all I have for you today. Keep hacking!</p>

<div class="footnotes" role="doc-endnotes">
  <ol>
    <li role="doc-endnote">
      <p>I believe it was Haskell that populirized them.&nbsp;<a href="https://batsov.com/feeds/OCaml.xml#fnref:1" class="reversefootnote" role="doc-backlink">↩</a></p>
    </li>
    <li role="doc-endnote">
      <p>See <a href="https://v2.ocaml.org/manual/tail_mod_cons.html">https://v2.ocaml.org/manual/tail_mod_cons.html</a> for more details.&nbsp;<a href="https://batsov.com/feeds/OCaml.xml#fnref:2" class="reversefootnote" role="doc-backlink">↩</a></p>
    </li>
  </ol>
</div>
