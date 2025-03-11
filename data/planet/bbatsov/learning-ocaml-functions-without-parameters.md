---
title: 'Learning OCaml: Functions without Parameters'
description: "A couple of days ago I noticed on OCaml\u2019s Discord server that someone
  was confused by OCaml function applications (invocations) like these:"
url: https://batsov.com/articles/2025/03/02/learning-ocaml-functions-without-parameters/
date: 2025-03-02T10:47:00-00:00
preview_image: https://batsov.com/assets/images/bozhidar_avatar.jpg
authors:
- Bozhidar Batsov
source:
---

<p>A couple of days ago I noticed on OCaml’s Discord server that someone was
confused by OCaml function applications (invocations) like these:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="n">print_newline</span> <span class="bp">()</span>

<span class="n">read_input</span> <span class="bp">()</span>
</code></pre></div></div>

<p>To people coming from “conventional” programming languages this might look like
calling a function/method without any arguments. (e.g. <code class="language-plaintext highlighter-rouge">foo()</code> in Python) Of course,
function application in OCaml is quite different from JavaScript, Python and the like -
the function arguments are space separated and simply follow the function’s name:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="n">foo</span> <span class="n">arg1</span> <span class="n">arg1</span> <span class="n">arg3</span>
</code></pre></div></div>

<p>So what are those <code class="language-plaintext highlighter-rouge">()</code> then and why are they needed? I’ll start with the second part of the question.
In OCaml you can’t really define a function without any parameters - if we have to be super
precise, every function takes <strong>exactly</strong> one parameter, no matter how it might look
at a glance.<sup role="doc-noteref"><a href="https://batsov.com/feeds/OCaml.xml#fn:1" class="footnote" rel="footnote">1</a></sup> If you try to do something like:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">my_print</span> <span class="o">=</span> <span class="n">print_endline</span> <span class="s2">"Hello"</span>
<span class="k">val</span> <span class="n">my_print</span> <span class="o">:</span> <span class="kt">unit</span> <span class="o">=</span> <span class="bp">()</span>
</code></pre></div></div>

<p>You’ll just end up with static binding to nothing. Or not quite nothing, as it’s time to
talk about <code class="language-plaintext highlighter-rouge">()</code>, which happens to be the single instance of the <code class="language-plaintext highlighter-rouge">unit</code> type, used to represent
the absence of a meaningful value. So, when you want to define a function that doesn’t need
any parameters the convention is to use a single <code class="language-plaintext highlighter-rouge">unit</code> parameter:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="c">(* This defines a function that takes unit *)</span>
<span class="k">let</span> <span class="n">say_hello</span> <span class="bp">()</span> <span class="o">=</span>
  <span class="n">print_endline</span> <span class="s2">"Hello, world!"</span>

<span class="c">(* same here *)</span>
<span class="k">let</span> <span class="n">random_int</span> <span class="bp">()</span> <span class="o">=</span>
  <span class="nn">Random</span><span class="p">.</span><span class="n">int</span> <span class="mi">100</span>
</code></pre></div></div>

<p>I hope this also explains why’d have to call such functions with <code class="language-plaintext highlighter-rouge">()</code> as their
argument. If you don’t do this - you’d just receive the underlying function
object as the result:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="o">#</span> <span class="n">say_hello</span><span class="p">;;</span>
<span class="o">-</span> <span class="o">:</span> <span class="kt">unit</span> <span class="o">-&gt;</span> <span class="kt">unit</span> <span class="o">=</span> <span class="o">&lt;</span><span class="k">fun</span><span class="o">&gt;</span>
<span class="o">#</span> <span class="n">say_hello</span> <span class="bp">()</span><span class="p">;;</span>
<span class="nc">Hello</span><span class="o">,</span> <span class="n">world</span><span class="o">!</span>
<span class="o">-</span> <span class="o">:</span> <span class="kt">unit</span> <span class="o">=</span> <span class="bp">()</span>
<span class="o">#</span> <span class="n">random_int</span><span class="p">;;</span>
<span class="o">-</span> <span class="o">:</span> <span class="kt">unit</span> <span class="o">-&gt;</span> <span class="kt">int</span> <span class="o">=</span> <span class="o">&lt;</span><span class="k">fun</span><span class="o">&gt;</span>
<span class="o">#</span> <span class="n">random_int</span> <span class="bp">()</span><span class="p">;;</span>
<span class="o">-</span> <span class="o">:</span> <span class="kt">int</span> <span class="o">=</span> <span class="mi">10</span>
</code></pre></div></div>

<p>Basically, you need to pass the argument to have an actual function application.
Remember that in OCaml (and most functional programming languages), functions are first-class
objects that you can pass around like any other value.</p>

<p>And that’s a wrap. I hope you learned something useful today. Keep hacking!</p>

<div class="footnotes" role="doc-endnotes">
  <ol>
    <li role="doc-endnote">
      <p>See <a href="https://dev.realworldocaml.org/variables-and-functions.html#multi-argument-functions">https://dev.realworldocaml.org/variables-and-functions.html#multi-argument-functions</a>.&nbsp;<a href="https://batsov.com/feeds/OCaml.xml#fnref:1" class="reversefootnote" role="doc-backlink">↩</a></p>
    </li>
  </ol>
</div>
