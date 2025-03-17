---
title: Simple Ways to Run OCaml Code
description: "When people think of OCaml they are usually thinking of compiling code
  to a binary before they are able to run it. While most OCaml code is indeed compiled
  to binaries, you don\u2019t really need to do this, especially while you\u2019re
  learning the language and are mostly playing with small exercises."
url: https://batsov.com/articles/2025/02/23/simple-ways-to-run-ocaml-code/
date: 2025-02-23T18:49:00-00:00
preview_image: https://batsov.com/assets/images/bozhidar_avatar.jpg
authors:
- Bozhidar Batsov
source:
---

<p>When people think of OCaml they are usually thinking of compiling code to a
binary before they are able to run it. While most OCaml code is indeed compiled
to binaries, you don’t really need to do this, especially while you’re learning
the language and are mostly playing with small exercises.</p>

<p>Imagine you have something like this in a file named <code class="language-plaintext highlighter-rouge">hello.ml</code>:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="bp">()</span> <span class="o">=</span> <span class="n">print_endline</span> <span class="s2">"Hello, world!"</span>
</code></pre></div></div>

<p>You can compile this if you want, but you can also run it directly with OCaml’s
interpreter <code class="language-plaintext highlighter-rouge">ocaml</code>:</p>

<div class="language-console highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="gp">$</span><span class="w"> </span>ocaml hello.ml 
<span class="go">Hello, world!
</span></code></pre></div></div>

<p>This approach should be familiar to anyone who has ever used a scripting
language like Perl, Python, Ruby or JavaScript. You can do the same with <code class="language-plaintext highlighter-rouge">utop</code>
as well:</p>

<div class="language-console highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="gp">$</span><span class="w"> </span>utop hello.ml 
<span class="go">Hello, world!
</span></code></pre></div></div>

<p>Of course, one can argue that it’s just as simple to start <code class="language-plaintext highlighter-rouge">utop</code> and then
do <code class="language-plaintext highlighter-rouge">#use "hello.ml"</code> from it. Feel free to do whatever works best for you.</p>

<p>You can take things one step further like this:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="o">#!/</span><span class="n">usr</span><span class="o">/</span><span class="n">bin</span><span class="o">/</span><span class="n">env</span> <span class="n">ocaml</span>
<span class="k">let</span> <span class="bp">()</span> <span class="o">=</span> <span class="n">print_endline</span> <span class="s2">"Hello, world!"</span>
</code></pre></div></div>

<p>Now you can make this file an executable script and run it directly:</p>

<div class="language-console highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="gp">$</span><span class="w"> </span><span class="nb">chmod</span> +x hello.ml
<span class="gp">$</span><span class="w"> </span>./hello.ml
<span class="go">Hello, world!
</span></code></pre></div></div>

<p>While this approach should be used mostly when dealing with code that doesn’t
use external libraries, there’s nothing preventing you from doing so:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="o">#</span><span class="n">use</span> <span class="s2">"topfind"</span><span class="p">;;</span>
<span class="o">#</span><span class="n">require</span> <span class="s2">"package_name"</span><span class="p">;;</span>
<span class="c">(* Your OCaml code here *)</span>
</code></pre></div></div>

<p>This should be familiar to everyone who has required any packages in <code class="language-plaintext highlighter-rouge">utop</code>.
<code class="language-plaintext highlighter-rouge">topfind</code> is a file that <a href="https://github.com/ocaml/ocamlfind">ocamlfind</a> installs
in the standard library, so that it can be used from the toplevel.
Don’t forget to install <code class="language-plaintext highlighter-rouge">ocamlfind</code> first:</p>

<div class="language-shell highlighter-rouge"><div class="highlight"><pre class="highlight"><code>opam <span class="nb">install </span>ocamlfind
</code></pre></div></div>

<p>One last thing before we wrap up - you might be wondering about the use
of <code class="language-plaintext highlighter-rouge">let ()</code> in the simple examples I’ve provided. Technically that’s not
needed, but you have to keep in mind that when you have multiple expressions in
the source files with boundaries that the compiler can’t infer you’ll need to
separate those with <code class="language-plaintext highlighter-rouge">;;</code>. Using <code class="language-plaintext highlighter-rouge">let</code> for everything eliminates the need for this:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="o">#!/</span><span class="n">usr</span><span class="o">/</span><span class="n">bin</span><span class="o">/</span><span class="n">env</span> <span class="n">ocaml</span>
<span class="k">let</span> <span class="bp">()</span> <span class="o">=</span> <span class="n">print_endline</span> <span class="s2">"Hello, world!"</span>

<span class="k">let</span> <span class="bp">()</span> <span class="o">=</span> <span class="n">print_endline</span> <span class="s2">"Bye, world!"</span>
</code></pre></div></div>

<p>The example above works. The one below, however, doesn’t:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="o">#!/</span><span class="n">usr</span><span class="o">/</span><span class="n">bin</span><span class="o">/</span><span class="n">env</span> <span class="n">ocaml</span>
<span class="n">print_endline</span> <span class="s2">"Hello, world!"</span>

<span class="n">print_endline</span> <span class="s2">"Bye, world!"</span>
</code></pre></div></div>

<p>It will result in a syntax error, because to OCaml this code is basically one expression.
To fix this will need to add <code class="language-plaintext highlighter-rouge">;;</code> to help the compiler:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="o">#!/</span><span class="n">usr</span><span class="o">/</span><span class="n">bin</span><span class="o">/</span><span class="n">env</span> <span class="n">ocaml</span>
<span class="n">print_endline</span> <span class="s2">"Hello, world!"</span><span class="p">;;</span>

<span class="n">print_endline</span> <span class="s2">"Bye, world!"</span><span class="p">;;</span>
</code></pre></div></div>

<p>If you know that you can also use <code class="language-plaintext highlighter-rouge">;</code> to separate expressions that are
evaluation only for their side effects (like <code class="language-plaintext highlighter-rouge">print_endline</code>) you might be
tempted to write instead the following:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="o">#!/</span><span class="n">usr</span><span class="o">/</span><span class="n">bin</span><span class="o">/</span><span class="n">env</span> <span class="n">ocaml</span>
<span class="n">print_endline</span> <span class="s2">"Hello, world!"</span><span class="p">;</span>
<span class="n">print_endline</span> <span class="s2">"Bye, world!"</span><span class="p">;;</span>
</code></pre></div></div>

<p>I’m not a big fan of this at the top-level, though, as it’s intended to be
used mostly in bindings:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">a</span> <span class="o">=</span> <span class="mi">1</span> <span class="k">in</span>
<span class="k">let</span> <span class="n">b</span> <span class="o">=</span> <span class="mi">2</span> <span class="k">in</span>
<span class="n">print_int</span> <span class="n">a</span><span class="p">;</span>
<span class="n">print_int</span> <span class="n">b</span><span class="p">;</span>
<span class="n">a</span> <span class="o">+</span> <span class="n">b</span>
</code></pre></div></div>

<p>If you have any other tips on running simple OCaml programs, please
share those in the comments.</p>

<p>That’s all I have for you today. Keep hacking!</p>
