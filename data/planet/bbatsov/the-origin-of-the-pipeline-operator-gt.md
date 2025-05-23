---
title: The origin of the pipeline operator (`|&gt;`)
description: "These days a lot of programming languages (especially those leaning
  towards functional programming) offer a pipeline operator (|>), that allows you
  to feed some data through a \u201Cpipeline\u201D of transformation steps.1 Here\u2019s
  a trivial example in F#:                 Funny enough, even Ruby has a pipeline
  operator these days, although it\u2019s not particularly useful there.\_\u21A9"
url: https://batsov.com/articles/2025/05/22/the-origin-of-the-pipeline-operator/
date: 2025-05-22T10:49:00-00:00
preview_image: https://batsov.com/assets/images/bozhidar_avatar.jpg
authors:
- Bozhidar Batsov
source:
ignore:
---

<p>These days a lot of programming languages (especially those leaning towards functional programming)
offer a pipeline operator (|&gt;), that allows you to feed some data through a “pipeline” of transformation
steps.<sup role="doc-noteref"><a href="https://batsov.com/feeds/OCaml.xml#fn:1" class="footnote" rel="footnote">1</a></sup> Here’s a trivial example in F#:</p>

<div class="language-fsharp highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">processNumbers</span> <span class="n">numbers</span> <span class="p">=</span>
    <span class="n">numbers</span>
    <span class="p">|&gt;</span> <span class="nn">List</span><span class="p">.</span><span class="n">filter</span> <span class="p">(</span><span class="k">fun</span> <span class="n">x</span> <span class="p">-&gt;</span> <span class="n">x</span> <span class="o">%</span> <span class="mi">2</span> <span class="p">=</span> <span class="mi">0</span><span class="p">)</span>        <span class="c1">// keep even numbers</span>
    <span class="p">|&gt;</span> <span class="nn">List</span><span class="p">.</span><span class="n">map</span> <span class="p">(</span><span class="k">fun</span> <span class="n">x</span> <span class="p">-&gt;</span> <span class="n">x</span> <span class="p">*</span> <span class="n">x</span><span class="p">)</span>               <span class="c1">// square them</span>
    <span class="p">|&gt;</span> <span class="nn">List</span><span class="p">.</span><span class="n">sum</span>                                <span class="c1">// sum the result</span>
</code></pre></div></div>

<p>I think I first saw the pipeline operator in Elixir and afterwards in OCaml.
When I started to play with F# recently, I learned that F# was widely credited as
the language that made the pipeline operator popular. While reading the excellent paper
<a href="https://fsharp.org/history/hopl-final/hopl-fsharp.pdf">The Early History of F#</a> I learned
even more on the topic. Below, you’ll find the relevant excerpt from the paper.</p>

<hr>

<p>One of the first things to become associated with F# was also one of the simplest: the “pipe-forward”
operator, added to the F# standard library in 2003:</p>

<div class="language-fsharp highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="o">(|&gt;)</span> <span class="n">x</span> <span class="n">f</span> <span class="p">=</span> <span class="n">f</span> <span class="n">x</span>
</code></pre></div></div>

<p>In conjunction with curried function application this allows an intermediate result to be passed
through a chain of functions, e.g.</p>

<div class="language-fsharp highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="p">[</span> <span class="mi">1</span> <span class="p">..</span> <span class="mi">10</span> <span class="p">]</span>
    <span class="p">|&gt;</span> <span class="nn">List</span><span class="p">.</span><span class="n">map</span> <span class="p">(</span><span class="k">fun</span> <span class="n">x</span> <span class="p">-&gt;</span> <span class="n">x</span> <span class="p">*</span><span class="n">x</span><span class="p">)</span>
    <span class="p">|&gt;</span> <span class="nn">List</span><span class="p">.</span><span class="n">filter</span> <span class="p">(</span><span class="k">fun</span> <span class="n">x</span> <span class="p">-&gt;</span> <span class="n">x</span> <span class="o">%</span> <span class="mi">2</span> <span class="p">=</span> <span class="mi">0</span><span class="p">)</span>
</code></pre></div></div>

<p>instead of</p>

<div class="language-fsharp highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="nn">List</span><span class="p">.</span><span class="n">filter</span> <span class="p">(</span><span class="k">fun</span> <span class="n">x</span> <span class="p">-&gt;</span> <span class="n">x</span> <span class="o">%</span> <span class="mi">2</span> <span class="p">=</span> <span class="mi">0</span><span class="p">)</span>
    <span class="p">(</span><span class="nn">List</span><span class="p">.</span><span class="n">map</span> <span class="p">(</span><span class="k">fun</span> <span class="n">x</span> <span class="p">-&gt;</span> <span class="n">x</span> <span class="p">*</span><span class="n">x</span><span class="p">)</span> <span class="p">[</span> <span class="mi">1</span> <span class="p">..</span> <span class="mi">10</span> <span class="o">])</span>
</code></pre></div></div>

<p>Despite being heavily associated with F#, the use of the pipeline symbol in ML dialects actually
originates from Tobias Nipkow, in May 1994 (with obvious semiotic inspiration from UNIX pipes)
[archives 1994; Syme 2011].</p>

<blockquote>
  <p>… I promised to dig into my old mail folders to uncover the true story behind |&gt; in Isabelle/ML, which
also turned out popular in F#…
In the attachment you find the original mail thread of the three of us [ Larry Paulson; Tobias Nipkow;
Marius Wenzel], coming up with this now indispensable piece of ML art in April/May 1994. The mail
exchange starts as a response of Larry to my changes.
…Tobias …came up with the actual name |&gt; in the end…</p>
</blockquote>

<hr>

<p>Note that in F# the <code class="language-plaintext highlighter-rouge">|&gt;</code> operator is called “pipe-forward” mostly because they have
several variations of it, including a pretty confusing “pipe-backward” operator.</p>

<p>Before reading this article I had never heard of Isabelle/ML, and I had never realized
that <code class="language-plaintext highlighter-rouge">|&gt;</code> is somewhat modeled after the <code class="language-plaintext highlighter-rouge">|</code> (pipe) operator in Unix shells. I guess the
reason for this is that I first got exposed to a similar concept in Clojure, where
there <code class="language-plaintext highlighter-rouge">-&gt;</code> (thread-first) and <code class="language-plaintext highlighter-rouge">-&gt;&gt;</code> (thread-last) macros serve a pretty similar purpose.
While there are no “pipes” in them, I think the fundamental idea is pretty much the same.
Still, it was OCaml and F# that made me really appreciate the “real” pipeline operator
and develop a deep fondness for it.</p>

<p>That’s all I have for you today! Keep hacking!</p>

<div class="footnotes" role="doc-endnotes">
  <ol>
    <li role="doc-endnote">
      <p>Funny enough, even Ruby has a pipeline operator these days, although it’s not particularly useful there.&nbsp;<a href="https://batsov.com/feeds/OCaml.xml#fnref:1" class="reversefootnote" role="doc-backlink">↩</a></p>
    </li>
  </ol>
</div>
