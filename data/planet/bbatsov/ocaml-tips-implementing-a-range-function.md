---
title: 'OCaml Tips: Implementing a range Function'
description: "Lots of programming languages have some built-in range functionality,
  that\u2019s typically used to generate a list/array of integer numbers. Here are
  a couple of examples from Ruby and Clojure:"
url: https://batsov.com/articles/2022/10/31/ocaml-tips-implementing-a-range-function/
date: 2022-10-31T06:45:00-00:00
preview_image: https://batsov.com/assets/images/bozhidar_avatar.jpg
authors:
- Bozhidar Batsov
source:
---

<p>Lots of programming languages have some built-in range functionality, that’s
typically used to generate a list/array of integer numbers. Here are
a couple of examples from Ruby and Clojure:</p>

<div class="language-ruby highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="c1"># This is Ruby</span>

<span class="p">(</span><span class="mi">1</span><span class="o">..</span><span class="mi">10</span><span class="p">).</span><span class="nf">to_a</span>
<span class="c1"># =&gt; [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]</span>

<span class="p">(</span><span class="mi">1</span><span class="o">..</span><span class="mi">10</span><span class="p">).</span><span class="nf">filter</span><span class="p">(</span><span class="o">&amp;</span><span class="ss">:even?</span><span class="p">)</span>
<span class="c1"># =&gt; [2, 4, 6, 8, 10]</span>

<span class="c1"># And some related functionality, that doesn't use literal ranges</span>
<span class="mi">5</span><span class="p">.</span><span class="nf">downto</span><span class="p">(</span><span class="mi">1</span><span class="p">).</span><span class="nf">to_a</span> <span class="c1"># =&gt; [5, 4, 3, 2, 1]</span>

<span class="mi">10</span><span class="p">.</span><span class="nf">step</span><span class="p">(</span><span class="mi">1</span><span class="p">,</span> <span class="o">-</span><span class="mi">2</span><span class="p">).</span><span class="nf">to_a</span> <span class="c1"># =&gt; [10, 8, 6, 4, 2]</span>
</code></pre></div></div>

<div class="language-clojure highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="c1">;; This is Clojure</span><span class="w">

</span><span class="p">(</span><span class="nb">range</span><span class="w"> </span><span class="mi">1</span><span class="w"> </span><span class="mi">10</span><span class="p">)</span><span class="w">
</span><span class="c1">;; =&gt; (1 2 3 4 5 6 7 8 9)</span><span class="w">

</span><span class="p">(</span><span class="nb">range</span><span class="w"> </span><span class="mi">1</span><span class="w"> </span><span class="mi">10</span><span class="w"> </span><span class="mi">2</span><span class="p">)</span><span class="w">
</span><span class="c1">;; =&gt; (1 3 5 7 9)</span><span class="w">

</span><span class="p">(</span><span class="nb">range</span><span class="w"> </span><span class="mi">100</span><span class="w"> </span><span class="mi">0</span><span class="w"> </span><span class="mi">-10</span><span class="p">)</span><span class="w">
</span><span class="c1">;; (100 90 80 70 60 50 40 30 20 10)</span><span class="w">
</span></code></pre></div></div>

<p>Ruby has a special syntax for ranges (<code class="language-plaintext highlighter-rouge">..</code> and <code class="language-plaintext highlighter-rouge">...</code>) and Clojure provides
a <code class="language-plaintext highlighter-rouge">range</code> function to generate ranges (basically a sequences of integer numbers).
I’m pretty sure you’ve seen something like this. Not the most useful function in
the world for sure, but it’s handy from time to time.</p>

<p>There are many ways we can implement something similar in OCaml, with the
simplest one probably being to use <code class="language-plaintext highlighter-rouge">List.init</code> internally:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="c">(* simplest/shortest possible version *)</span>
<span class="k">let</span> <span class="n">range</span> <span class="n">i</span> <span class="o">=</span> <span class="nn">List</span><span class="p">.</span><span class="n">init</span> <span class="n">i</span> <span class="n">succ</span>

<span class="n">range</span> <span class="mi">10</span>
<span class="o">-</span> <span class="o">:</span> <span class="kt">int</span> <span class="kt">list</span> <span class="o">=</span> <span class="p">[</span><span class="mi">1</span><span class="p">;</span> <span class="mi">2</span><span class="p">;</span> <span class="mi">3</span><span class="p">;</span> <span class="mi">4</span><span class="p">;</span> <span class="mi">5</span><span class="p">;</span> <span class="mi">6</span><span class="p">;</span> <span class="mi">7</span><span class="p">;</span> <span class="mi">8</span><span class="p">;</span> <span class="mi">9</span><span class="p">;</span> <span class="mi">10</span><span class="p">]</span>

<span class="c">(* a version with some boundaries *)</span>
<span class="k">let</span> <span class="n">range</span> <span class="n">from</span> <span class="n">until</span> <span class="o">=</span>
  <span class="nn">List</span><span class="p">.</span><span class="n">init</span> <span class="p">(</span><span class="n">until</span> <span class="o">-</span> <span class="n">from</span><span class="p">)</span> <span class="p">(</span><span class="k">fun</span> <span class="n">i</span> <span class="o">-&gt;</span> <span class="n">i</span> <span class="o">+</span> <span class="n">from</span><span class="p">)</span>

<span class="n">range</span> <span class="mi">1</span> <span class="mi">10</span>
<span class="o">-</span> <span class="o">:</span> <span class="kt">int</span> <span class="kt">list</span> <span class="o">=</span> <span class="p">[</span><span class="mi">1</span><span class="p">;</span> <span class="mi">2</span><span class="p">;</span> <span class="mi">3</span><span class="p">;</span> <span class="mi">4</span><span class="p">;</span> <span class="mi">5</span><span class="p">;</span> <span class="mi">6</span><span class="p">;</span> <span class="mi">7</span><span class="p">;</span> <span class="mi">8</span><span class="p">;</span> <span class="mi">9</span><span class="p">]</span>

<span class="n">range</span> <span class="mi">5</span> <span class="mi">15</span>
<span class="o">-</span> <span class="o">:</span> <span class="kt">int</span> <span class="kt">list</span> <span class="o">=</span> <span class="p">[</span><span class="mi">5</span><span class="p">;</span> <span class="mi">6</span><span class="p">;</span> <span class="mi">7</span><span class="p">;</span> <span class="mi">8</span><span class="p">;</span> <span class="mi">9</span><span class="p">;</span> <span class="mi">10</span><span class="p">;</span> <span class="mi">11</span><span class="p">;</span> <span class="mi">12</span><span class="p">;</span> <span class="mi">13</span><span class="p">;</span> <span class="mi">14</span><span class="p">]</span>

<span class="c">(* let's name this -- for good measure *)</span>
<span class="k">let</span> <span class="p">(</span><span class="o">--</span><span class="p">)</span> <span class="o">=</span> <span class="n">range</span>

<span class="mi">1</span> <span class="o">--</span> <span class="mi">10</span>
<span class="o">-</span> <span class="o">:</span> <span class="kt">int</span> <span class="kt">list</span> <span class="o">=</span> <span class="p">[</span><span class="mi">1</span><span class="p">;</span> <span class="mi">2</span><span class="p">;</span> <span class="mi">3</span><span class="p">;</span> <span class="mi">4</span><span class="p">;</span> <span class="mi">5</span><span class="p">;</span> <span class="mi">6</span><span class="p">;</span> <span class="mi">7</span><span class="p">;</span> <span class="mi">8</span><span class="p">;</span> <span class="mi">9</span><span class="p">]</span>

<span class="c">(* you can also consider using the names --&gt; and --&lt; for inclusive and exclusive ranges *)</span>
</code></pre></div></div>

<p>The above implementations are super basic and have a few quirks (e.g. the second
implementation doesn’t allow setting the step and it can’t handle descending
ranges), but they mostly get the job done. A more full-featured implementation
would look something like this:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">range</span> <span class="o">?</span><span class="p">(</span><span class="n">from</span><span class="o">=</span><span class="mi">1</span><span class="p">)</span> <span class="o">?</span><span class="p">(</span><span class="n">step</span><span class="o">=</span><span class="mi">1</span><span class="p">)</span> <span class="n">until</span> <span class="o">=</span>
  <span class="k">let</span> <span class="n">cmp</span> <span class="o">=</span> <span class="k">match</span> <span class="n">step</span> <span class="k">with</span>
    <span class="o">|</span> <span class="n">i</span> <span class="k">when</span> <span class="n">i</span> <span class="o">&lt;</span> <span class="mi">0</span> <span class="o">-&gt;</span> <span class="p">(</span><span class="o">&gt;</span><span class="p">)</span>
    <span class="o">|</span> <span class="n">i</span> <span class="k">when</span> <span class="n">i</span> <span class="o">&gt;</span> <span class="mi">0</span> <span class="o">-&gt;</span> <span class="p">(</span><span class="o">&lt;</span><span class="p">)</span>
    <span class="o">|</span> <span class="n">_</span> <span class="o">-&gt;</span> <span class="k">raise</span> <span class="p">(</span><span class="nc">Invalid_argument</span> <span class="s2">"step cannot be 0"</span><span class="p">)</span>
  <span class="k">in</span>
  <span class="nn">Seq</span><span class="p">.</span><span class="n">unfold</span> <span class="p">(</span><span class="k">function</span>
        <span class="o">|</span> <span class="n">i</span> <span class="k">when</span> <span class="n">cmp</span> <span class="n">i</span> <span class="n">until</span> <span class="o">-&gt;</span> <span class="nc">Some</span> <span class="p">(</span><span class="n">i</span><span class="o">,</span> <span class="n">i</span> <span class="o">+</span> <span class="n">step</span><span class="p">)</span>
        <span class="o">|</span> <span class="n">_</span> <span class="o">-&gt;</span> <span class="nc">None</span>
    <span class="p">)</span> <span class="n">from</span>
</code></pre></div></div>

<p>This function has a few advantages over the implementations so far:</p>

<ul>
  <li>It uses optional labeled arguments (<code class="language-plaintext highlighter-rouge">from</code> and <code class="language-plaintext highlighter-rouge">step</code>)</li>
  <li>It allows us to set the step explicitly</li>
  <li>It handles descending ranges</li>
  <li>It’s implemented in terms of <code class="language-plaintext highlighter-rouge">Seq</code>, meaning it’s lazy</li>
</ul>

<p><strong>Note:</strong> The order of the arguments in the definition matters, as optional
arguments are only filled in once a positional argument after them has been
applied. If <code class="language-plaintext highlighter-rouge">?step</code> is the last argument that can never happen.</p>

<p>And here’s how using it in practice looks:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="n">range</span> <span class="mi">10</span> <span class="o">|&gt;</span> <span class="nn">List</span><span class="p">.</span><span class="n">of_seq</span><span class="p">;;</span>
<span class="o">-</span> <span class="o">:</span> <span class="kt">int</span> <span class="kt">list</span> <span class="o">=</span> <span class="p">[</span><span class="mi">1</span><span class="p">;</span> <span class="mi">2</span><span class="p">;</span> <span class="mi">3</span><span class="p">;</span> <span class="mi">4</span><span class="p">;</span> <span class="mi">5</span><span class="p">;</span> <span class="mi">6</span><span class="p">;</span> <span class="mi">7</span><span class="p">;</span> <span class="mi">8</span><span class="p">;</span> <span class="mi">9</span><span class="p">]</span>

<span class="n">range</span> <span class="o">~</span><span class="n">from</span><span class="o">:</span><span class="mi">10</span> <span class="mi">20</span> <span class="o">|&gt;</span> <span class="nn">List</span><span class="p">.</span><span class="n">of_seq</span><span class="p">;;</span>
<span class="o">-</span> <span class="o">:</span> <span class="kt">int</span> <span class="kt">list</span> <span class="o">=</span> <span class="p">[</span><span class="mi">10</span><span class="p">;</span> <span class="mi">11</span><span class="p">;</span> <span class="mi">12</span><span class="p">;</span> <span class="mi">13</span><span class="p">;</span> <span class="mi">14</span><span class="p">;</span> <span class="mi">15</span><span class="p">;</span> <span class="mi">16</span><span class="p">;</span> <span class="mi">17</span><span class="p">;</span> <span class="mi">18</span><span class="p">;</span> <span class="mi">19</span><span class="p">]</span>

<span class="n">range</span> <span class="mi">100</span> <span class="o">~</span><span class="n">step</span><span class="o">:</span><span class="mi">10</span> <span class="o">|&gt;</span> <span class="nn">List</span><span class="p">.</span><span class="n">of_seq</span><span class="p">;;</span>
<span class="o">-</span> <span class="o">:</span> <span class="kt">int</span> <span class="kt">list</span> <span class="o">=</span> <span class="p">[</span><span class="mi">1</span><span class="p">;</span> <span class="mi">11</span><span class="p">;</span> <span class="mi">21</span><span class="p">;</span> <span class="mi">31</span><span class="p">;</span> <span class="mi">41</span><span class="p">;</span> <span class="mi">51</span><span class="p">;</span> <span class="mi">61</span><span class="p">;</span> <span class="mi">71</span><span class="p">;</span> <span class="mi">81</span><span class="p">;</span> <span class="mi">91</span><span class="p">]</span>

<span class="n">range</span> <span class="o">~</span><span class="n">from</span><span class="o">:</span><span class="mi">5</span> <span class="mi">20</span> <span class="o">~</span><span class="n">step</span><span class="o">:</span><span class="mi">5</span> <span class="o">|&gt;</span> <span class="nn">List</span><span class="p">.</span><span class="n">of_seq</span><span class="p">;;</span>
<span class="o">-</span> <span class="o">:</span> <span class="kt">int</span> <span class="kt">list</span> <span class="o">=</span> <span class="p">[</span><span class="mi">5</span><span class="p">;</span> <span class="mi">10</span><span class="p">;</span> <span class="mi">15</span><span class="p">]</span>

<span class="n">range</span> <span class="o">~</span><span class="n">from</span><span class="o">:</span><span class="mi">20</span> <span class="mi">5</span> <span class="o">~</span><span class="n">step</span><span class="o">:</span><span class="p">(</span><span class="o">-</span><span class="mi">5</span><span class="p">)</span> <span class="o">|&gt;</span> <span class="nn">List</span><span class="p">.</span><span class="n">of_seq</span><span class="p">;;</span>
<span class="o">-</span> <span class="o">:</span> <span class="kt">int</span> <span class="kt">list</span> <span class="o">=</span> <span class="p">[</span><span class="mi">20</span><span class="p">;</span> <span class="mi">15</span><span class="p">;</span> <span class="mi">10</span><span class="p">]</span>
</code></pre></div></div>

<p>Now we’re talking!</p>

<p>One funny thing to note is that originally I wanted to use <code class="language-plaintext highlighter-rouge">from</code> and <code class="language-plaintext highlighter-rouge">to</code> as
the parameter names, but I couldn’t use <code class="language-plaintext highlighter-rouge">to</code> as it’s a keyword is OCaml:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">for</span> <span class="n">variable</span> <span class="o">=</span> <span class="n">start_value</span> <span class="k">to</span> <span class="n">end_value</span> <span class="k">do</span>
  <span class="n">expression</span>
<span class="k">done</span>
</code></pre></div></div>

<p>I keep forgetting about this, as I never use those <code class="language-plaintext highlighter-rouge">for</code> loops and Clojure has
spoiled me with its extremely small set of keywords.</p>

<p>Another funny bit worth sharing, as that one of the test cases for <code class="language-plaintext highlighter-rouge">Seq.unfold</code> is
exactly a trivial implementation of <code class="language-plaintext highlighter-rouge">range</code>:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="c">(* unfold *)</span>
<span class="k">let</span> <span class="bp">()</span> <span class="o">=</span>
  <span class="k">let</span> <span class="n">range</span> <span class="n">first</span> <span class="n">last</span> <span class="o">=</span>
    <span class="k">let</span> <span class="n">step</span> <span class="n">i</span> <span class="o">=</span> <span class="k">if</span> <span class="n">i</span> <span class="o">&gt;</span> <span class="n">last</span> <span class="k">then</span> <span class="nc">None</span>
                 <span class="k">else</span> <span class="nc">Some</span> <span class="p">(</span><span class="n">i</span><span class="o">,</span> <span class="n">succ</span> <span class="n">i</span><span class="p">)</span> <span class="k">in</span>
    <span class="nn">Seq</span><span class="p">.</span><span class="n">unfold</span> <span class="n">step</span> <span class="n">first</span>
  <span class="k">in</span>
  <span class="k">begin</span>
    <span class="k">assert</span> <span class="p">([</span><span class="mi">1</span><span class="p">;</span><span class="mi">2</span><span class="p">;</span><span class="mi">3</span><span class="p">]</span> <span class="o">=</span> <span class="o">!!</span><span class="p">(</span><span class="n">range</span> <span class="mi">1</span> <span class="mi">3</span><span class="p">));</span>
    <span class="k">assert</span> <span class="p">([]</span> <span class="o">=</span> <span class="o">!!</span><span class="p">(</span><span class="n">range</span> <span class="mi">1</span> <span class="mi">0</span><span class="p">));</span>
  <span class="k">end</span>
<span class="p">;;</span>
</code></pre></div></div>

<p>A <a href="https://doc.sherlocode.com/?q=int%20-%3E%20int%20-%3E%20int%20list">quick
search</a> on
Sherlodoc reveals a ton of similar functions in many OCaml libraries, so clearly
there’s some use for a <code class="language-plaintext highlighter-rouge">range</code> function in one form or another.</p>

<p>That’s all I have for you today. Keep hacking!</p>
