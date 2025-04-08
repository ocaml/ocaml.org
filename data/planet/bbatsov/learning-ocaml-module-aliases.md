---
title: 'Learning OCaml: Module Aliases'
description: "OCaml is famous for allow you to do a lot of things like modules. Like
  really a lot! Advanced features like functors, aside, it\u2019s really common to
  either alias module names to something shorter or localize open Module_name to a
  smaller scope:"
url: https://batsov.com/articles/2025/04/06/learning-ocaml-module-aliases/
date: 2025-04-06T19:06:00-00:00
preview_image: https://batsov.com/assets/images/bozhidar_avatar.jpg
authors:
- Bozhidar Batsov
source:
---

<p>OCaml is famous for allow you to do a lot of things like modules. Like really a lot!
Advanced features like functors, aside, it’s really common to either alias
module names to something shorter or localize <code class="language-plaintext highlighter-rouge">open Module_name</code> to a smaller
scope:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="c">(* module alias *)</span>
<span class="k">module</span> <span class="nc">Printf</span> <span class="o">=</span> <span class="nc">P</span>

<span class="c">(* open module for subsequent scope *)</span>
<span class="k">let</span> <span class="k">open</span> <span class="nc">Printf</span> <span class="k">in</span>
<span class="k">let</span> <span class="n">portfolio</span> <span class="o">=</span> <span class="nn">List</span><span class="p">.</span><span class="n">map</span> <span class="n">parse_line</span> <span class="n">portfolio_lines</span> <span class="k">in</span>
<span class="nn">List</span><span class="p">.</span><span class="n">iter</span> <span class="p">(</span><span class="k">fun</span> <span class="p">(</span><span class="n">ticker</span><span class="o">,</span> <span class="n">shares</span><span class="o">,</span> <span class="n">price</span><span class="p">)</span> <span class="o">-&gt;</span>
  <span class="n">printf</span> <span class="s2">"%s: %d shares at $%.2f</span><span class="se">\n</span><span class="s2">"</span> <span class="n">ticker</span> <span class="n">shares</span> <span class="n">price</span>
<span class="p">)</span> <span class="n">portfolio</span><span class="p">;</span>
<span class="k">let</span> <span class="n">total</span> <span class="o">=</span> <span class="n">total_value</span> <span class="n">portfolio</span> <span class="k">in</span>
<span class="n">printf</span> <span class="s2">"Total portfolio value: $%.2f</span><span class="se">\n</span><span class="s2">"</span> <span class="n">total</span>

<span class="c">(* open module for an expression *)</span>
<span class="nn">List</span><span class="p">.([</span><span class="mi">1</span><span class="p">;</span> <span class="mi">2</span><span class="p">;</span> <span class="mi">3</span><span class="p">;</span> <span class="mi">4</span><span class="p">;</span> <span class="mi">5</span><span class="p">]</span> <span class="o">|&gt;</span> <span class="n">map</span> <span class="p">(</span><span class="k">fun</span> <span class="n">x</span> <span class="o">-&gt;</span> <span class="n">x</span> <span class="o">*</span> <span class="mi">2</span><span class="p">)</span> <span class="o">|&gt;</span> <span class="n">fold_left</span> <span class="p">(</span><span class="o">+</span><span class="p">)</span> <span class="mi">0</span><span class="p">);;</span>
</code></pre></div></div>

<p>All of them have their uses, but I’d like to also mention one less known
approach - namely a scoped module alias:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="k">module</span> <span class="nc">P</span> <span class="o">=</span> <span class="nc">Printf</span> <span class="k">in</span>
<span class="k">let</span> <span class="n">portfolio</span> <span class="o">=</span> <span class="nn">List</span><span class="p">.</span><span class="n">map</span> <span class="n">parse_line</span> <span class="n">portfolio_lines</span> <span class="k">in</span>
<span class="nn">List</span><span class="p">.</span><span class="n">iter</span> <span class="p">(</span><span class="k">fun</span> <span class="p">(</span><span class="n">ticker</span><span class="o">,</span> <span class="n">shares</span><span class="o">,</span> <span class="n">price</span><span class="p">)</span> <span class="o">-&gt;</span>
  <span class="nn">P</span><span class="p">.</span><span class="n">printf</span> <span class="s2">"%s: %d shares at $%.2f</span><span class="se">\n</span><span class="s2">"</span> <span class="n">ticker</span> <span class="n">shares</span> <span class="n">price</span>
<span class="p">)</span> <span class="n">portfolio</span><span class="p">;</span>
<span class="k">let</span> <span class="n">total</span> <span class="o">=</span> <span class="n">total_value</span> <span class="n">portfolio</span> <span class="k">in</span>
<span class="nn">P</span><span class="p">.</span><span class="n">printf</span> <span class="s2">"Total portfolio value: $%.2f</span><span class="se">\n</span><span class="s2">"</span> <span class="n">total</span>
</code></pre></div></div>

<p>I think in some way that’s the best of both worlds as it makes it obvious
that certain functions are coming from a module, and you’re still not
doing that much extra typing. Finding the right balance between conciseness,
readability and maintainability is never easy, though.</p>

<p><strong>Note:</strong> Interestingly OCaml’s younger sibling F# chose not to implement
scoped module opens at all. I’m guessing this happened due to maintainability
concerns.</p>

<p>What are your thoughts on the subject? In which situations would you prefer
<code class="language-plaintext highlighter-rouge">let open Module in</code> over a local module alias and vice versa?</p>

<p>That’s all I have for you today. Keep hacking!</p>
