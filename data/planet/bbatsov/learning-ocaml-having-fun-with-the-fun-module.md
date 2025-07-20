---
title: 'Learning OCaml: Having Fun with the Fun Module'
description: "When I started to play with OCaml I was kind of surprised that there
  was no id (identity) function that was available out-of-box (in Stdlib module, that\u2019s
  auto-opened). A quick search lead me to the Fun module, which is part of the standard
  library and is nested under Stdlib. It was introduced in OCaml 4.08, alongside other
  modules such as Int, Result and Option.1                 It was part of some broader
  efforts to slim down Stdlib and move in the direction of a more modular standard
  library.\_\u21A9"
url: https://batsov.com/articles/2025/07/19/learning-ocaml-having-fun-with-the-fun-module/
date: 2025-07-19T11:20:00-00:00
preview_image: https://batsov.com/assets/images/bozhidar_avatar.jpg
authors:
- Bozhidar Batsov
source:
ignore:
---

<p>When I started to play with OCaml I was kind of surprised that there was no
<code class="language-plaintext highlighter-rouge">id</code> (identity) function that was available out-of-box (in <code class="language-plaintext highlighter-rouge">Stdlib</code> module,
that’s auto-opened). A quick search lead me to the
<a href="https://ocaml.org/manual/5.3/api/Fun.html">Fun</a> module, which is part of the
standard library and is nested under
<code class="language-plaintext highlighter-rouge">Stdlib</code>. It was introduced in OCaml 4.08, alongside other
modules such as <code class="language-plaintext highlighter-rouge">Int</code>, <code class="language-plaintext highlighter-rouge">Result</code> and <code class="language-plaintext highlighter-rouge">Option</code>.<sup role="doc-noteref"><a href="https://batsov.com/feeds/OCaml.xml#fn:1" class="footnote" rel="footnote">1</a></sup></p>

<p>The <code class="language-plaintext highlighter-rouge">Fun</code> module provides a few basic combinators for working with functions.
Let’s go over them briefly:</p>

<ul>
  <li>
    <p><strong><code class="language-plaintext highlighter-rouge">Fun.id</code></strong></p>

    <div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="nn">Fun</span><span class="p">.</span><span class="n">id</span> <span class="o">:</span> <span class="k">'</span><span class="n">a</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">a</span>
</code></pre></div>    </div>

    <p>The identity function: returns its single argument unchanged.</p>
  </li>
  <li>
    <p><strong><code class="language-plaintext highlighter-rouge">Fun.const</code></strong></p>

    <div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="nn">Fun</span><span class="p">.</span><span class="n">const</span> <span class="o">:</span> <span class="k">'</span><span class="n">a</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">b</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">a</span>
</code></pre></div>    </div>

    <p>Returns a function that always returns the first argument, ignoring its second argument.</p>
  </li>
  <li>
    <p><strong><code class="language-plaintext highlighter-rouge">Fun.compose</code></strong></p>

    <div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="nn">Fun</span><span class="p">.</span><span class="n">compose</span> <span class="o">:</span> <span class="p">(</span><span class="k">'</span><span class="n">b</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">c</span><span class="p">)</span> <span class="o">-&gt;</span> <span class="p">(</span><span class="k">'</span><span class="n">a</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">b</span><span class="p">)</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">a</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">c</span>
</code></pre></div>    </div>

    <p>Composes two functions, applying the second function to the result of the
first. Haskell and F# have special syntax for function composition, but that’s
not the case in OCaml. (although you can easily map this to some operator if
you wish to do so) Also, <code class="language-plaintext highlighter-rouge">compose</code> introduced a bit later than the other
functions in the module - namely in OCaml 5.2.</p>
  </li>
  <li>
    <p><strong><code class="language-plaintext highlighter-rouge">Fun.flip</code></strong></p>

    <div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="nn">Fun</span><span class="p">.</span><span class="n">flip</span> <span class="o">:</span> <span class="p">(</span><span class="k">'</span><span class="n">a</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">b</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">c</span><span class="p">)</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">b</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">a</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">c</span>
</code></pre></div>    </div>

    <p>Reverses the order of arguments to a two-argument function.</p>
  </li>
  <li>
    <p><strong><code class="language-plaintext highlighter-rouge">Fun.negate</code></strong></p>

    <div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="nn">Fun</span><span class="p">.</span><span class="n">negate</span> <span class="o">:</span> <span class="p">(</span><span class="k">'</span><span class="n">a</span> <span class="o">-&gt;</span> <span class="kt">bool</span><span class="p">)</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">a</span> <span class="o">-&gt;</span> <span class="kt">bool</span>
</code></pre></div>    </div>

    <p>Negates a boolean-returning function, returning the opposite boolean value. Useful when you want to provide
a pair of inverse predicates (e.g. <code class="language-plaintext highlighter-rouge">is_positive</code> and <code class="language-plaintext highlighter-rouge">is_negative</code>)</p>
  </li>
</ul>

<p>I believe that those functions are pretty self-explanatory, but still below we’ll go over
a few examples of using them:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="c">(* Fun.id *)</span>
<span class="nn">Fun</span><span class="p">.</span><span class="n">id</span> <span class="mi">42</span>
<span class="c">(* 42 *)</span>

<span class="c">(* Fun.const *)</span>
<span class="k">let</span> <span class="n">always_hello</span> <span class="o">=</span> <span class="nn">Fun</span><span class="p">.</span><span class="n">const</span> <span class="s2">"hello"</span>
<span class="n">always_hello</span> <span class="mi">12345</span>
<span class="c">(* "hello" *)</span>

<span class="c">(* Fun.flip *)</span>
<span class="k">let</span> <span class="n">subtract</span> <span class="n">a</span> <span class="n">b</span> <span class="o">=</span> <span class="n">a</span> <span class="o">-</span> <span class="n">b</span>
<span class="k">let</span> <span class="n">flipped_subtract</span> <span class="o">=</span> <span class="nn">Fun</span><span class="p">.</span><span class="n">flip</span> <span class="n">subtract</span>
<span class="n">flipped_subtract</span> <span class="mi">2</span> <span class="mi">10</span>
<span class="c">(* 8 *)</span>

<span class="c">(* Fun.negate *)</span>
<span class="k">let</span> <span class="n">is_odd</span> <span class="o">=</span> <span class="n">negate</span> <span class="n">is_even</span>
<span class="n">is_odd</span> <span class="mi">5</span>
<span class="c">(* true *)</span>

<span class="c">(* Fun.compose *)</span>
<span class="k">let</span> <span class="n">comp_f</span> <span class="o">=</span> <span class="nn">Fun</span><span class="p">.</span><span class="n">compose</span> <span class="p">(</span><span class="k">fun</span> <span class="n">x</span> <span class="o">-&gt;</span> <span class="n">x</span> <span class="o">*</span> <span class="n">x</span><span class="p">)</span> <span class="p">(</span><span class="k">fun</span> <span class="n">x</span> <span class="o">-&gt;</span> <span class="n">x</span> <span class="o">+</span> <span class="mi">1</span><span class="p">)</span>
<span class="n">comp_f</span> <span class="mi">5</span>
<span class="c">(* 36 *)</span>
</code></pre></div></div>

<p>Admittedly the examples are not great, but I hope they managed to convey how to use
the various combinators.</p>

<p>Those are definitely not the type of functions that you would use every day, but they can
be useful in certain situations. Obviously I needed <code class="language-plaintext highlighter-rouge">id</code> at some point to discover the
<code class="language-plaintext highlighter-rouge">Fun</code> module in the first place, and all of the functions there can be considered
“classic” combinators in functional programming.</p>

<p>In practice most often I need <code class="language-plaintext highlighter-rouge">id</code> and <code class="language-plaintext highlighter-rouge">negate</code>, and infrequently <code class="language-plaintext highlighter-rouge">comp</code> and <code class="language-plaintext highlighter-rouge">const</code>.
Right now I’m struggling to come up with good use-cases for <code class="language-plaintext highlighter-rouge">flip</code>, but
I’m sure those exist. Perhaps you’ll share some examples in the comments?</p>

<p>How often do you use the various combinators? Which ones do you find most useful?</p>

<p>I find myself wondering if such fundamental functions shouldn’t have been part of
<code class="language-plaintext highlighter-rouge">Stdlib</code> module directly, but overall I really like the modular standard library approach
that OCaml’s team has been working towards in the past several years.<sup role="doc-noteref"><a href="https://batsov.com/feeds/OCaml.xml#fn:2" class="footnote" rel="footnote">2</a></sup> The important
thing in the end of the day is to know that these functions exist and you can
make use of them. Writing this short article will definitely help me to remember
this.</p>

<p>That’s all I have for you today. Keep hacking!</p>

<div class="footnotes" role="doc-endnotes">
  <ol>
    <li role="doc-endnote">
      <p>It was part of some broader efforts to slim down <code class="language-plaintext highlighter-rouge">Stdlib</code> and move in the direction of a more modular standard library.&nbsp;<a href="https://batsov.com/feeds/OCaml.xml#fnref:1" class="reversefootnote" role="doc-backlink">↩</a></p>
    </li>
    <li role="doc-endnote">
      <p>And obviously you can open the <code class="language-plaintext highlighter-rouge">Fun</code> module if you wish to at whatever level you desire.&nbsp;<a href="https://batsov.com/feeds/OCaml.xml#fnref:2" class="reversefootnote" role="doc-backlink">↩</a></p>
    </li>
  </ol>
</div>
