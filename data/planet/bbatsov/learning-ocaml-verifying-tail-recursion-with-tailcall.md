---
title: 'Learning OCaml: Verifying tail-recursion with @tailcall'
description: "How can you be sure that an OCaml function you wrote is actually tail-recursive?
  You can certainly compile the code and look at the generated assembly code, but
  that\u2019d be quite the overkill, given there is a much simpler way to do this."
url: https://batsov.com/articles/2024/01/16/learning-ocaml-verifying-tail-recursion-with-tailcall/
date: 2024-01-16T08:52:00-00:00
preview_image: https://batsov.com/assets/images/bozhidar_avatar.jpg
authors:
- Bozhidar Batsov
source:
---

<p>How can you be sure that an OCaml function you wrote is actually tail-recursive?
You can certainly compile the code and look at the generated assembly code, but that’d be quite the overkill, given there is a much simpler way to do this.</p>

<p>OCaml 4.03 introduced the <code class="language-plaintext highlighter-rouge">@tailcall</code> <a href="https://v2.ocaml.org/manual/attributes.html">attribute</a> which will trigger a compiler warning if it’s not placed at an actual tail-call.<sup role="doc-noteref"><a href="https://batsov.com/feeds/OCaml.xml#fn:1" class="footnote" rel="footnote">1</a></sup> It should be used like this:</p>

<blockquote>
  <p><code class="language-plaintext highlighter-rouge">(f [@tailcall]) x y</code> warns if f x y is not a tail-call</p>
</blockquote>

<p>Here are a couple of trivial examples to help illustrate this:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="c">(* tail-recursive factorial function *)</span>
<span class="k">let</span> <span class="k">rec</span> <span class="n">fact1</span> <span class="n">acc</span> <span class="n">x</span> <span class="o">=</span>
  <span class="k">if</span> <span class="n">x</span> <span class="o">&lt;=</span> <span class="mi">1</span> <span class="k">then</span> <span class="n">acc</span> <span class="k">else</span> <span class="p">(</span><span class="n">fact1</span> <span class="p">[</span><span class="o">@</span><span class="n">tailcall</span><span class="p">])</span> <span class="p">(</span><span class="n">acc</span> <span class="o">*</span> <span class="n">x</span><span class="p">)</span> <span class="p">(</span><span class="n">x</span> <span class="o">-</span> <span class="mi">1</span><span class="p">)</span>

<span class="c">(* non tail-recursive factorial function *)</span>
<span class="k">let</span> <span class="k">rec</span> <span class="n">fact2</span> <span class="n">x</span> <span class="o">=</span>
  <span class="k">if</span> <span class="n">x</span> <span class="o">&lt;=</span> <span class="mi">1</span> <span class="k">then</span> <span class="mi">1</span> <span class="k">else</span> <span class="n">x</span> <span class="o">*</span> <span class="p">(</span><span class="n">fact2</span> <span class="p">[</span><span class="o">@</span><span class="n">tailcall</span><span class="p">])</span> <span class="p">(</span><span class="n">x</span> <span class="o">-</span> <span class="mi">1</span><span class="p">)</span>
</code></pre></div></div>

<p>Save the code above in a file named <code class="language-plaintext highlighter-rouge">tailcall.ml</code> and compile it with <code class="language-plaintext highlighter-rouge">ocamlc</code>:</p>

<div class="language-console highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="gp">$</span><span class="w"> </span>ocamlc tailcall.ml
<span class="go">File "./tailcall.ml", line 5, characters 28-55:
5 |   if x &lt;= 1 then 1 else x * (fact2 [@tailcall]) (x - 1)
                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^
Warning 51 [wrong-tailcall-expectation]: expected tailcall
</span></code></pre></div></div>

<p>As you can see the compiler properly detected that <code class="language-plaintext highlighter-rouge">fact2</code> is not tail-recursive, as the tail-call is <code class="language-plaintext highlighter-rouge">*</code> instead of <code class="language-plaintext highlighter-rouge">fact2</code>.
Small, but handy feature that helps you ensure your code works the way you intended it to work.</p>

<p>That’s all I have for you today. Keep hacking!</p>

<div class="footnotes" role="doc-endnotes">
  <ol>
    <li role="doc-endnote">
      <p>Basically the tail-call is the call that triggers the recursion in the function and for a function to be tail-recursive the last call has to be an invocation of the recursive function itself.&nbsp;<a href="https://batsov.com/feeds/OCaml.xml#fnref:1" class="reversefootnote" role="doc-backlink">↩</a></p>
    </li>
  </ol>
</div>
