---
title: 'Learning OCaml: Matching Anything or the Lack of Anything'
description: "I\u2019ve noticed that some newcomers to OCaml are a bit confused by
  code like the following:"
url: https://batsov.com/articles/2025/02/27/learning-ocaml-matching-anything-or-the-lack-of-anything/
date: 2025-02-27T11:48:00-00:00
preview_image: https://batsov.com/assets/images/bozhidar_avatar.jpg
authors:
- Bozhidar Batsov
source:
---

<p>I’ve noticed that some newcomers to OCaml are a bit confused by code like the following:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="bp">()</span> <span class="o">=</span> <span class="n">print_endline</span> <span class="s2">"Hello, world"</span>

<span class="k">let</span> <span class="n">_</span> <span class="o">=</span> <span class="n">foo</span> <span class="n">bar</span>
</code></pre></div></div>

<p>Both of those are forms of pattern matching, but one of them is a lot stricter
than the other. In OCaml <code class="language-plaintext highlighter-rouge">()</code> is the single value of the <code class="language-plaintext highlighter-rouge">unit</code> type that
indicates the absence of any meaningful value. You can think of it as something like <code class="language-plaintext highlighter-rouge">void</code> in
other languages. What this means is that <code class="language-plaintext highlighter-rouge">let ()</code> would only match an
expression that actually return <code class="language-plaintext highlighter-rouge">unit</code> (like the various <code class="language-plaintext highlighter-rouge">print_*</code> functions) and you’d get a compilation error
otherwise:</p>

<div class="language-console highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="gp">$</span><span class="w"> </span>ocaml foo.ml
<span class="go">File "./foo.ml", line 1, characters 9-11:
1 | let () = 10
             ^^
Error: The constant 10 has type int but an expression was expected of type unit
</span></code></pre></div></div>

<p><code class="language-plaintext highlighter-rouge">_</code> on the other hand is a placeholder for “anything” and it will match… anything. It’s useful
in cases when you just need to discard something. A common example to illustrate it would be something
like pattern matching on the elements of a list. Consider the following trivial function that returns
the last item from a list:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="k">rec</span> <span class="n">last</span> <span class="o">=</span> <span class="k">function</span>
  <span class="o">|</span> <span class="bp">[]</span> <span class="o">-&gt;</span> <span class="nc">None</span>
  <span class="o">|</span> <span class="p">[</span><span class="n">x</span><span class="p">]</span> <span class="o">-&gt;</span> <span class="nc">Some</span> <span class="n">x</span>
  <span class="o">|</span> <span class="n">_</span> <span class="o">::</span> <span class="n">t</span> <span class="o">-&gt;</span> <span class="n">last</span> <span class="n">t</span>
</code></pre></div></div>

<p>Just as in <code class="language-plaintext highlighter-rouge">match</code>, you can use <code class="language-plaintext highlighter-rouge">let _</code> to match against any value, effectively discarding it.</p>

<p>In practice, <code class="language-plaintext highlighter-rouge">let ()</code> is often used at the top level of programs to indicate the
main entry point, while <code class="language-plaintext highlighter-rouge">let _</code> is used when you need to evaluate an expression
for its side effects but don’t care about its return value. I mostly use <code class="language-plaintext highlighter-rouge">let _</code> when inserting
debug <code class="language-plaintext highlighter-rouge">print</code> expressions in a chain of nested <code class="language-plaintext highlighter-rouge">let</code>s. Here’s an example:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">foo</span> <span class="n">x</span> <span class="o">=</span>
  <span class="k">let</span> <span class="n">_</span> <span class="o">=</span> <span class="n">print_int</span> <span class="n">x</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">y</span> <span class="o">=</span> <span class="n">x</span> <span class="o">*</span> <span class="mi">2</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">_</span> <span class="o">=</span> <span class="n">print_int</span> <span class="n">y</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">z</span> <span class="o">=</span> <span class="n">y</span> <span class="o">+</span> <span class="mi">10</span> <span class="k">in</span>
  <span class="n">z</span>
</code></pre></div></div>

<p>The above example is a bit contrived, but I hope you get the idea. Also, you can totally use <code class="language-plaintext highlighter-rouge">let ()</code> in the example above,
although it seems to me that using <code class="language-plaintext highlighter-rouge">let _</code> is more intention revealing in such cases.</p>

<p>That’s all I have for you today. Keep hacking!</p>
