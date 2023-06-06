---
title: Behavioural types
description:
url: https://kcsrk.info/ocaml/types/2016/06/30/behavioural-types/
date: 2016-06-30T09:31:00-00:00
preview_image:
featured:
authors:
- KC Sivaramakrishnan
---

<p>Behavioural types such as session types, contracts and choreography describe the
behaviour of a software entity as a sequence of <em>operations</em> on a resource such
as a communication channel, web service session or a file descriptor.
Behavioural types capture well-defined interactions, which are enforced
statically with the help of type system machinery. In this post, I will describe
a lightweight embedding of behavioural types in OCaml using polymorphic variants
through a series of examples. The complete source code for the examples is
available
<a href="https://github.com/kayceesrk/code-snippets/blob/master/behavior.ml">here</a>.</p>



<p>The idea of encoding behavioural types using polymorphic variants comes from
<a href="http://www.di.unito.it/~padovani/Software/FuSe/FuSe.html">FuSe</a>, which is a
simple library implementation of binary sessions in OCaml. Similar to FuSe
linear use of resources is enforced through dynamic checks in the following
examples. We&rsquo;ll raise <code class="language-plaintext highlighter-rouge">LinearityViolation</code> when linearity is violated.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">exception</span> <span class="nc">LinearityViolation</span>
</code></pre></div></div>

<h2>Refs that explain their work</h2>

<p>Let us define a ref type that is constrained not only by the type of value
that it can hold but also by the sequence of operations that can be performed
on it.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">module</span> <span class="k">type</span> <span class="nc">Ref</span> <span class="o">=</span>
<span class="k">sig</span>
  <span class="k">type</span> <span class="p">(</span><span class="k">'</span><span class="n">a</span><span class="o">,</span> <span class="k">'</span><span class="n">b</span><span class="p">)</span> <span class="n">ref</span> <span class="k">constraint</span> <span class="k">'</span><span class="n">b</span> <span class="o">=</span> <span class="p">[</span><span class="o">&gt;</span><span class="p">]</span>

  <span class="k">val</span> <span class="n">ref</span>   <span class="o">:</span> <span class="k">'</span><span class="n">a</span> <span class="o">-&gt;</span> <span class="p">(</span><span class="k">'</span><span class="n">a</span><span class="o">,</span> <span class="k">'</span><span class="n">b</span><span class="p">)</span> <span class="n">ref</span>
  <span class="k">val</span> <span class="n">read</span>  <span class="o">:</span> <span class="p">(</span><span class="k">'</span><span class="n">a</span><span class="o">,</span> <span class="p">[</span><span class="nt">`Read</span> <span class="k">of</span> <span class="k">'</span><span class="n">b</span><span class="p">])</span> <span class="n">ref</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">a</span> <span class="o">*</span> <span class="p">(</span><span class="k">'</span><span class="n">a</span><span class="o">,</span> <span class="k">'</span><span class="n">b</span><span class="p">)</span> <span class="n">ref</span>
  <span class="k">val</span> <span class="n">write</span> <span class="o">:</span> <span class="p">(</span><span class="k">'</span><span class="n">a</span><span class="o">,</span> <span class="p">[</span><span class="nt">`Write</span> <span class="k">of</span> <span class="k">'</span><span class="n">b</span><span class="p">])</span> <span class="n">ref</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">a</span> <span class="o">-&gt;</span> <span class="p">(</span><span class="k">'</span><span class="n">a</span><span class="o">,</span> <span class="k">'</span><span class="n">b</span><span class="p">)</span> <span class="n">ref</span>
<span class="k">end</span>

<span class="k">module</span> <span class="nc">Ref</span> <span class="o">:</span> <span class="nc">Ref</span> <span class="o">=</span> <span class="k">struct</span> <span class="o">...</span> <span class="k">end</span>
</code></pre></div></div>

<p>The phantom type variable <code class="language-plaintext highlighter-rouge">'b</code> constrained to be a polymorphic variant (<code class="language-plaintext highlighter-rouge">'b =
[&gt;]</code>) describes the sequence of permitted operations. For example, a reference
can only be read when the type presents the read capability <code class="language-plaintext highlighter-rouge">[`Read of 'b]</code>.
Here, the <code class="language-plaintext highlighter-rouge">'b</code> represents the behaviour of the continuation. Consequently, the
result of the <code class="language-plaintext highlighter-rouge">read</code> operation is a tuple consisting of the value read and a
reference whose type is <code class="language-plaintext highlighter-rouge">('a,'b) ref</code>. It is useful to think of the <code class="language-plaintext highlighter-rouge">read</code>
operation as changing the type of the reference. The type for <code class="language-plaintext highlighter-rouge">write</code> is
similar.</p>

<p>Associating behaviours with references is quite handy. For example, below is a
reference that holds an integer, which can only be written once following which
a single read is permitted:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">my_ref1</span> <span class="o">:</span> <span class="p">(</span><span class="kt">int</span><span class="o">,</span> <span class="p">[</span><span class="nt">`Write</span> <span class="k">of</span> <span class="p">[</span><span class="nt">`Read</span> <span class="k">of</span> <span class="p">[</span><span class="nt">`Stop</span><span class="p">]]])</span> <span class="nn">Ref</span><span class="p">.</span><span class="n">ref</span> <span class="o">=</span> <span class="nn">Ref</span><span class="p">.</span><span class="n">ref</span> <span class="mi">10</span>
</code></pre></div></div>

<p>The behavioural types are also automatically inferred. For example,</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="n">utop</span> <span class="o">#</span> <span class="k">let</span> <span class="n">foo1</span> <span class="n">r</span> <span class="o">=</span>
  <span class="k">let</span> <span class="n">r</span> <span class="o">=</span> <span class="nn">Ref</span><span class="p">.</span><span class="n">write</span> <span class="n">r</span> <span class="mi">20</span> <span class="k">in</span>
  <span class="nn">Ref</span><span class="p">.</span><span class="n">read</span> <span class="n">r</span><span class="p">;;</span>
<span class="k">val</span> <span class="n">foo1</span> <span class="o">:</span>
  <span class="p">(</span><span class="kt">int</span><span class="o">,</span> <span class="p">[</span> <span class="nt">`Write</span> <span class="k">of</span> <span class="p">[</span> <span class="nt">`Read</span> <span class="k">of</span> <span class="p">[</span><span class="o">&gt;</span>  <span class="p">]</span> <span class="k">as</span> <span class="k">'</span><span class="n">a</span> <span class="p">]</span> <span class="p">])</span> <span class="nn">Ref</span><span class="p">.</span><span class="n">ref</span> <span class="o">-&gt;</span>
  <span class="kt">int</span> <span class="o">*</span> <span class="p">(</span><span class="kt">int</span><span class="o">,</span> <span class="k">'</span><span class="n">a</span><span class="p">)</span> <span class="nn">Ref</span><span class="p">.</span><span class="n">ref</span>
</code></pre></div></div>

<p>The inferred type says that <code class="language-plaintext highlighter-rouge">foo1</code> writes into <code class="language-plaintext highlighter-rouge">r</code> and then reads it. We can
apply <code class="language-plaintext highlighter-rouge">foo1</code> on <code class="language-plaintext highlighter-rouge">my_ref1</code> as their behaviours are compatible.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="n">utop</span> <span class="o">#</span> <span class="k">let</span> <span class="n">v</span><span class="o">,</span><span class="n">res_ref</span> <span class="o">=</span> <span class="n">foo1</span> <span class="n">my_ref1</span><span class="p">;;</span>
<span class="k">val</span> <span class="n">v</span> <span class="o">:</span> <span class="kt">int</span> <span class="o">=</span> <span class="mi">20</span>
<span class="k">val</span> <span class="n">res_ref</span> <span class="o">:</span> <span class="p">(</span><span class="kt">int</span><span class="o">,</span> <span class="p">[</span> <span class="nt">`Stop</span> <span class="p">])</span> <span class="nn">Ref</span><span class="p">.</span><span class="n">ref</span>
</code></pre></div></div>

<p>Recursive behavioural types are obtained painlessly.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="n">utop</span> <span class="o">#</span> <span class="k">let</span> <span class="k">rec</span> <span class="n">foo2</span> <span class="n">r</span> <span class="o">=</span>
  <span class="k">let</span> <span class="n">r</span> <span class="o">=</span> <span class="nn">Ref</span><span class="p">.</span><span class="n">write</span> <span class="n">r</span> <span class="mi">20</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">v</span><span class="o">,</span> <span class="n">r</span> <span class="o">=</span> <span class="nn">Ref</span><span class="p">.</span><span class="n">read</span> <span class="n">r</span> <span class="k">in</span>
  <span class="n">foo2</span> <span class="n">r</span><span class="p">;;</span>
<span class="k">val</span> <span class="n">foo2</span> <span class="o">:</span> <span class="p">(</span><span class="kt">int</span><span class="o">,</span> <span class="p">[</span> <span class="nt">`Write</span> <span class="k">of</span> <span class="p">[</span> <span class="nt">`Read</span> <span class="k">of</span> <span class="k">'</span><span class="n">a</span> <span class="p">]</span> <span class="p">]</span> <span class="k">as</span> <span class="k">'</span><span class="n">a</span><span class="p">)</span> <span class="nn">Ref</span><span class="p">.</span><span class="n">ref</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">b</span>
</code></pre></div></div>

<p>The inferred types says that <code class="language-plaintext highlighter-rouge">foo2</code> repeatedly writes and then reads the given
reference. Incompatible references are rejected statically. For example,</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="n">utop</span> <span class="o">#</span> <span class="k">let</span> <span class="n">my_ref2</span> <span class="o">:</span> <span class="p">(</span><span class="kt">int</span><span class="o">,</span> <span class="p">[</span><span class="nt">`Write</span> <span class="k">of</span> <span class="p">[</span><span class="nt">`Read</span> <span class="k">of</span> <span class="p">[</span><span class="nt">`Stop</span><span class="p">]]])</span> <span class="nn">Ref</span><span class="p">.</span><span class="n">ref</span> <span class="o">=</span> <span class="nn">Ref</span><span class="p">.</span><span class="n">ref</span> <span class="mi">10</span><span class="p">;;</span>
<span class="k">val</span> <span class="n">my_ref2</span> <span class="o">:</span> <span class="p">(</span><span class="kt">int</span><span class="o">,</span> <span class="p">[</span> <span class="nt">`Write</span> <span class="k">of</span> <span class="p">[</span> <span class="nt">`Read</span> <span class="k">of</span> <span class="p">[</span> <span class="nt">`Stop</span> <span class="p">]</span> <span class="p">]</span> <span class="p">])</span> <span class="nn">Ref</span><span class="p">.</span><span class="n">ref</span> <span class="o">=</span> <span class="o">&lt;</span><span class="n">abstr</span><span class="o">&gt;</span>
<span class="n">utop</span> <span class="o">#</span> <span class="k">let</span> <span class="n">_</span> <span class="o">=</span> <span class="n">foo2</span> <span class="n">my_ref2</span><span class="p">;;</span>
<span class="nc">Error</span><span class="o">:</span> <span class="nc">This</span> <span class="n">expression</span> <span class="n">has</span> <span class="k">type</span>
         <span class="p">(</span><span class="kt">int</span><span class="o">,</span> <span class="p">[</span> <span class="nt">`Write</span> <span class="k">of</span> <span class="p">[</span> <span class="nt">`Read</span> <span class="k">of</span> <span class="p">[</span> <span class="nt">`Stop</span> <span class="p">]</span> <span class="p">]</span> <span class="p">])</span> <span class="nn">Ref</span><span class="p">.</span><span class="n">ref</span>
       <span class="n">but</span> <span class="n">an</span> <span class="n">expression</span> <span class="n">was</span> <span class="n">expected</span> <span class="k">of</span> <span class="k">type</span>
         <span class="p">(</span><span class="kt">int</span><span class="o">,</span> <span class="p">[</span> <span class="nt">`Write</span> <span class="k">of</span> <span class="p">[</span> <span class="nt">`Read</span> <span class="k">of</span> <span class="k">'</span><span class="n">a</span> <span class="p">]</span> <span class="p">]</span> <span class="k">as</span> <span class="k">'</span><span class="n">a</span><span class="p">)</span> <span class="nn">Ref</span><span class="p">.</span><span class="n">ref</span>
       <span class="nc">These</span> <span class="n">two</span> <span class="n">variant</span> <span class="n">types</span> <span class="n">have</span> <span class="n">no</span> <span class="n">intersection</span>
</code></pre></div></div>

<p>whereas</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="n">utop</span> <span class="o">#</span> <span class="k">let</span> <span class="n">my_ref3</span> <span class="o">=</span> <span class="nn">Ref</span><span class="p">.</span><span class="n">ref</span> <span class="mi">10</span><span class="p">;;</span>
<span class="k">val</span> <span class="n">my_ref3</span> <span class="o">:</span> <span class="p">(</span><span class="kt">int</span><span class="o">,</span> <span class="n">_</span><span class="p">[</span><span class="o">&gt;</span>  <span class="p">])</span> <span class="nn">Ref</span><span class="p">.</span><span class="n">ref</span> <span class="o">=</span> <span class="o">&lt;</span><span class="n">abstr</span><span class="o">&gt;</span>
<span class="n">utop</span> <span class="o">#</span> <span class="k">let</span> <span class="n">_</span> <span class="o">=</span> <span class="n">foo2</span> <span class="n">my_ref3</span><span class="p">;;</span>
</code></pre></div></div>

<p>is accepted and runs forever. It is (sometimes) useful to write programs that
don&rsquo;t always run forever such as <code class="language-plaintext highlighter-rouge">foo3</code>:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="n">utop</span> <span class="o">#</span> <span class="k">let</span> <span class="k">rec</span> <span class="n">foo3</span> <span class="n">r</span> <span class="o">=</span> <span class="k">function</span>
  <span class="o">|</span> <span class="mi">0</span> <span class="o">-&gt;</span>
      <span class="n">print_endline</span> <span class="s2">&quot;done&quot;</span><span class="p">;</span>
      <span class="nn">Ref</span><span class="p">.</span><span class="n">read</span> <span class="n">r</span>
  <span class="o">|</span> <span class="n">n</span> <span class="o">-&gt;</span>
      <span class="k">let</span> <span class="n">r</span> <span class="o">=</span> <span class="nn">Ref</span><span class="p">.</span><span class="n">write</span> <span class="n">r</span> <span class="mi">20</span> <span class="k">in</span>
      <span class="k">let</span> <span class="n">v</span><span class="o">,</span> <span class="n">r</span> <span class="o">=</span> <span class="nn">Ref</span><span class="p">.</span><span class="n">read</span> <span class="n">r</span> <span class="k">in</span>
      <span class="n">foo3</span> <span class="n">r</span> <span class="p">(</span><span class="n">n</span><span class="o">-</span><span class="mi">1</span><span class="p">);;</span>
</code></pre></div></div>

<p>which runs for <code class="language-plaintext highlighter-rouge">n</code> iterations, where it performs a write and a read in every
iteration but the last one where it just performs a read. Unfortunately, this
program does not type check:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="nc">Error</span><span class="o">:</span> <span class="nc">This</span> <span class="n">expression</span> <span class="n">has</span> <span class="k">type</span> <span class="p">(</span><span class="k">'</span><span class="n">a</span><span class="o">,</span> <span class="p">[</span> <span class="nt">`Read</span> <span class="k">of</span> <span class="p">[</span><span class="o">&gt;</span>  <span class="p">]</span> <span class="p">])</span> <span class="nn">Ref</span><span class="p">.</span><span class="n">ref</span>
       <span class="n">but</span> <span class="n">an</span> <span class="n">expression</span> <span class="n">was</span> <span class="n">expected</span> <span class="k">of</span> <span class="k">type</span> <span class="p">(</span><span class="k">'</span><span class="n">a</span><span class="o">,</span> <span class="p">[</span> <span class="nt">`Write</span> <span class="k">of</span> <span class="p">[</span><span class="o">&gt;</span>  <span class="p">]</span> <span class="p">])</span> <span class="nn">Ref</span><span class="p">.</span><span class="n">ref</span>
       <span class="nc">These</span> <span class="n">two</span> <span class="n">variant</span> <span class="n">types</span> <span class="n">have</span> <span class="n">no</span> <span class="n">intersection</span>
</code></pre></div></div>

<p>The problem is that the behaviour of the two branches are incompatible, and the
program is rightly rejected. We distinguish the branches in the type using:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">val</span> <span class="n">branch</span> <span class="o">:</span> <span class="p">(</span><span class="k">'</span><span class="n">a</span><span class="o">,</span> <span class="p">[</span><span class="o">&gt;</span><span class="p">]</span> <span class="k">as</span> <span class="k">'</span><span class="n">b</span><span class="p">)</span> <span class="n">ref</span> <span class="o">-&gt;</span> <span class="p">((</span><span class="k">'</span><span class="n">a</span><span class="o">,</span> <span class="p">[</span><span class="o">&gt;</span><span class="p">]</span> <span class="k">as</span> <span class="k">'</span><span class="n">c</span><span class="p">)</span> <span class="n">ref</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">b</span><span class="p">)</span> <span class="o">-&gt;</span> <span class="p">(</span><span class="k">'</span><span class="n">a</span><span class="o">,</span> <span class="k">'</span><span class="n">c</span><span class="p">)</span> <span class="n">ref</span>
</code></pre></div></div>

<p><code class="language-plaintext highlighter-rouge">branch r f</code> indicates branch selection in <code class="language-plaintext highlighter-rouge">r</code> where <code class="language-plaintext highlighter-rouge">f</code> is a function that is
always of the form <code class="language-plaintext highlighter-rouge">fun x -&gt;  `Tag x</code>. The fixed version of <code class="language-plaintext highlighter-rouge">foo3</code> is:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="n">utop</span> <span class="o">#</span> <span class="k">let</span> <span class="k">rec</span> <span class="n">foo3</span> <span class="n">r</span> <span class="o">=</span> <span class="k">function</span>
  <span class="o">|</span> <span class="mi">0</span> <span class="o">-&gt;</span>
      <span class="n">print_endline</span> <span class="s2">&quot;done&quot;</span><span class="p">;</span>
      <span class="nn">Ref</span><span class="p">.</span><span class="n">write</span> <span class="p">(</span><span class="nn">Ref</span><span class="p">.</span><span class="n">branch</span> <span class="n">r</span> <span class="p">(</span><span class="k">fun</span> <span class="n">x</span> <span class="o">-&gt;</span> <span class="nt">`Zero</span> <span class="n">x</span><span class="p">))</span> <span class="mi">0</span>
  <span class="o">|</span> <span class="n">n</span> <span class="o">-&gt;</span>
      <span class="k">let</span> <span class="n">r</span> <span class="o">=</span> <span class="nn">Ref</span><span class="p">.</span><span class="n">write</span> <span class="p">(</span><span class="nn">Ref</span><span class="p">.</span><span class="n">branch</span> <span class="n">r</span> <span class="p">(</span><span class="k">fun</span> <span class="n">x</span> <span class="o">-&gt;</span> <span class="nt">`Succ</span> <span class="n">x</span><span class="p">))</span> <span class="mi">20</span> <span class="k">in</span>
      <span class="k">let</span> <span class="n">v</span><span class="o">,</span> <span class="n">r</span> <span class="o">=</span> <span class="nn">Ref</span><span class="p">.</span><span class="n">read</span> <span class="n">r</span> <span class="k">in</span>
      <span class="n">foo3</span> <span class="n">r</span> <span class="p">(</span><span class="n">n</span><span class="o">-</span><span class="mi">1</span><span class="p">);;</span>
<span class="k">val</span> <span class="n">foo3</span> <span class="o">:</span>
  <span class="p">(</span><span class="kt">int</span><span class="o">,</span>
   <span class="p">[</span><span class="o">&gt;</span> <span class="nt">`Succ</span> <span class="k">of</span> <span class="p">(</span><span class="kt">int</span><span class="o">,</span> <span class="p">[</span> <span class="nt">`Write</span> <span class="k">of</span> <span class="p">[</span> <span class="nt">`Read</span> <span class="k">of</span> <span class="k">'</span><span class="n">a</span> <span class="p">]</span> <span class="p">])</span> <span class="nn">Ref</span><span class="p">.</span><span class="n">ref</span>
    <span class="o">|</span> <span class="nt">`Zero</span> <span class="k">of</span> <span class="p">(</span><span class="kt">int</span><span class="o">,</span> <span class="p">[</span> <span class="nt">`Write</span> <span class="k">of</span> <span class="p">[</span><span class="o">&gt;</span>  <span class="p">]</span> <span class="k">as</span> <span class="k">'</span><span class="n">b</span> <span class="p">])</span> <span class="nn">Ref</span><span class="p">.</span><span class="n">ref</span> <span class="p">]</span>
   <span class="k">as</span> <span class="k">'</span><span class="n">a</span><span class="p">)</span>
  <span class="nn">Ref</span><span class="p">.</span><span class="n">ref</span> <span class="o">-&gt;</span> <span class="kt">int</span> <span class="o">-&gt;</span> <span class="p">(</span><span class="kt">int</span><span class="o">,</span> <span class="k">'</span><span class="n">b</span><span class="p">)</span> <span class="nn">Ref</span><span class="p">.</span><span class="n">ref</span> <span class="o">=</span> <span class="o">&lt;</span><span class="k">fun</span><span class="o">&gt;</span>
</code></pre></div></div>

<p>Observe that the inferred type captures the branching behaviour, and works as
expected:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="n">utop</span> <span class="o">#</span> <span class="k">let</span> <span class="n">my_ref4</span> <span class="o">=</span> <span class="nn">Ref</span><span class="p">.</span><span class="n">ref</span> <span class="mi">10</span> <span class="k">in</span> <span class="n">foo3</span> <span class="n">my_ref4</span> <span class="mi">32</span><span class="p">;;</span>
<span class="k">done</span>
<span class="o">-</span> <span class="o">:</span> <span class="p">(</span><span class="kt">int</span><span class="o">,</span> <span class="n">_</span><span class="p">[</span><span class="o">&gt;</span>  <span class="p">])</span> <span class="nn">Ref</span><span class="p">.</span><span class="n">ref</span> <span class="o">=</span> <span class="o">&lt;</span><span class="n">abstr</span><span class="o">&gt;</span>
</code></pre></div></div>

<h3>Implementation</h3>

<p>The implementation is unremarkable except for the machinery to dynamically
enforce linearity.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">module</span> <span class="nc">Ref</span> <span class="o">:</span> <span class="nc">Ref</span> <span class="o">=</span>
<span class="k">struct</span>

  <span class="k">type</span> <span class="p">(</span><span class="k">'</span><span class="n">a</span><span class="o">,</span> <span class="k">'</span><span class="n">b</span><span class="p">)</span> <span class="n">ref</span> <span class="o">=</span>
    <span class="p">{</span><span class="n">contents</span>     <span class="o">:</span> <span class="k">'</span><span class="n">a</span><span class="p">;</span>
     <span class="k">mutable</span> <span class="n">live</span> <span class="o">:</span> <span class="kt">bool</span><span class="p">}</span> <span class="c">(* For linearity *)</span>
     <span class="k">constraint</span> <span class="k">'</span><span class="n">b</span> <span class="o">=</span> <span class="p">[</span><span class="o">&gt;</span><span class="p">]</span>

  <span class="k">let</span> <span class="n">ref</span> <span class="n">v</span> <span class="o">=</span> <span class="p">{</span><span class="n">contents</span> <span class="o">=</span> <span class="n">v</span><span class="p">;</span> <span class="n">live</span> <span class="o">=</span> <span class="bp">true</span><span class="p">}</span>

  <span class="k">let</span> <span class="n">check</span> <span class="n">r</span> <span class="o">=</span>
    <span class="k">if</span> <span class="n">not</span> <span class="n">r</span><span class="o">.</span><span class="n">live</span> <span class="k">then</span> <span class="k">raise</span> <span class="nc">LinearityViolation</span><span class="p">;</span>
    <span class="n">r</span><span class="o">.</span><span class="n">live</span> <span class="o">&lt;-</span> <span class="bp">false</span>

  <span class="k">let</span> <span class="n">fresh</span> <span class="n">r</span> <span class="o">=</span> <span class="p">{</span><span class="n">r</span> <span class="k">with</span> <span class="n">live</span> <span class="o">=</span> <span class="bp">true</span><span class="p">}</span>

  <span class="k">let</span> <span class="n">read</span> <span class="n">r</span> <span class="o">=</span>
    <span class="n">check</span> <span class="n">r</span><span class="p">;</span>
    <span class="p">(</span><span class="n">r</span><span class="o">.</span><span class="n">contents</span><span class="o">,</span> <span class="n">fresh</span> <span class="n">r</span><span class="p">)</span>

  <span class="k">let</span> <span class="n">write</span> <span class="n">r</span> <span class="n">v</span> <span class="o">=</span>
    <span class="n">check</span> <span class="n">r</span><span class="p">;</span>
    <span class="p">{</span> <span class="n">contents</span> <span class="o">=</span> <span class="n">v</span><span class="p">;</span> <span class="n">live</span> <span class="o">=</span> <span class="bp">true</span> <span class="p">}</span>

  <span class="k">let</span> <span class="n">branch</span> <span class="n">r</span> <span class="n">_</span> <span class="o">=</span> <span class="n">check</span> <span class="n">r</span><span class="p">;</span> <span class="n">fresh</span> <span class="n">r</span>
<span class="k">end</span>
</code></pre></div></div>

<p>Behavioural types crucially depend on linear use of the resources. Since OCaml
does not have linear types, there is nothing that prevents writing the following
function that seemingly violates the behavioural contract.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="n">utop</span> <span class="o">#</span> <span class="k">let</span> <span class="n">foo</span> <span class="p">(</span><span class="n">r</span> <span class="o">:</span> <span class="p">(</span><span class="kt">int</span><span class="o">,</span> <span class="p">[</span><span class="nt">`Read</span> <span class="k">of</span> <span class="p">[</span><span class="nt">`Stop</span><span class="p">]])</span> <span class="nn">Ref</span><span class="p">.</span><span class="n">ref</span><span class="p">)</span> <span class="o">=</span>
         <span class="k">let</span> <span class="n">_</span><span class="o">,</span> <span class="n">_</span> <span class="o">=</span> <span class="nn">Ref</span><span class="p">.</span><span class="n">read</span> <span class="n">r</span> <span class="k">in</span>
         <span class="nn">Ref</span><span class="p">.</span><span class="n">read</span> <span class="n">r</span><span class="p">;;</span>
<span class="k">val</span> <span class="n">foo</span> <span class="o">:</span>
  <span class="p">(</span><span class="kt">int</span><span class="o">,</span> <span class="p">[</span> <span class="nt">`Read</span> <span class="k">of</span> <span class="p">[</span> <span class="nt">`Stop</span> <span class="p">]</span> <span class="p">])</span> <span class="nn">Ref</span><span class="p">.</span><span class="n">ref</span> <span class="o">-&gt;</span> <span class="kt">int</span> <span class="o">*</span> <span class="p">(</span><span class="kt">int</span><span class="o">,</span> <span class="p">[</span> <span class="nt">`Stop</span> <span class="p">])</span> <span class="nn">Ref</span><span class="p">.</span><span class="n">ref</span> <span class="o">=</span>
  <span class="o">&lt;</span><span class="k">fun</span><span class="o">&gt;</span>
</code></pre></div></div>

<p>While the type of <code class="language-plaintext highlighter-rouge">r</code> says that it will be read only once, the function <code class="language-plaintext highlighter-rouge">foo</code>
reads it twice. This non-linear use of <code class="language-plaintext highlighter-rouge">r</code> is caught dynamically; the second
read of <code class="language-plaintext highlighter-rouge">r</code> raises <code class="language-plaintext highlighter-rouge">LinearityViolation</code>.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="n">utop</span> <span class="o">#</span> <span class="k">let</span> <span class="n">_</span> <span class="o">=</span> <span class="n">foo</span> <span class="p">(</span><span class="nn">Ref</span><span class="p">.</span><span class="n">ref</span> <span class="mi">10</span><span class="p">);;</span>
<span class="nc">Exception</span><span class="o">:</span> <span class="nn">LinearityViolation</span><span class="p">.</span>
</code></pre></div></div>

<h2>Polymorphic References</h2>

<p>Since we can accurately track the behaviour of references, we can safely allow
differently typed values to be written and read from the reference. A reference
that holds a value of type <code class="language-plaintext highlighter-rouge">t</code> can be read multiple times at <code class="language-plaintext highlighter-rouge">t</code> before being
written at type <code class="language-plaintext highlighter-rouge">u</code>. This protocol is captured by the following type:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">module</span> <span class="k">type</span> <span class="nc">PolyRef</span> <span class="o">=</span>
<span class="k">sig</span>
  <span class="k">type</span> <span class="p">(</span><span class="k">'</span><span class="n">a</span><span class="o">,</span><span class="k">'</span><span class="n">b</span><span class="p">)</span> <span class="n">rw_prot</span>
    <span class="k">constraint</span> <span class="k">'</span><span class="n">b</span> <span class="o">=</span> <span class="p">[</span><span class="o">&gt;</span> <span class="nt">`Read</span> <span class="k">of</span> <span class="k">'</span><span class="n">a</span> <span class="o">*</span> <span class="k">'</span><span class="n">b</span> <span class="o">|</span> <span class="nt">`Write</span> <span class="k">of</span> <span class="k">'</span><span class="n">c</span> <span class="o">*</span> <span class="p">(</span><span class="k">'</span><span class="n">c</span><span class="o">,_</span><span class="p">)</span> <span class="n">rw_prot</span><span class="p">]</span>
  <span class="k">type</span> <span class="k">'</span><span class="n">c</span> <span class="n">ref</span> <span class="k">constraint</span> <span class="k">'</span><span class="n">c</span> <span class="o">=</span> <span class="p">(</span><span class="k">'</span><span class="n">a</span><span class="o">,</span><span class="k">'</span><span class="n">b</span><span class="p">)</span> <span class="n">rw_prot</span>
  <span class="o">...</span>
<span class="k">end</span>
</code></pre></div></div>

<p>As before, the reference holds values of <code class="language-plaintext highlighter-rouge">'a</code> with the behaviour given by <code class="language-plaintext highlighter-rouge">'b</code>.
The reference can either by read multiple times at <code class="language-plaintext highlighter-rouge">'a</code> or written once at <code class="language-plaintext highlighter-rouge">'c</code>
after which the reference holds values of type <code class="language-plaintext highlighter-rouge">'c</code>. The rest of the operations
are defined as usual:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">module</span> <span class="k">type</span> <span class="nc">PolyRef</span> <span class="o">=</span>
<span class="k">sig</span>
  <span class="o">...</span>
  <span class="k">val</span> <span class="n">ref</span>  <span class="o">:</span> <span class="k">'</span><span class="n">a</span> <span class="o">-&gt;</span> <span class="p">(</span><span class="k">'</span><span class="n">a</span><span class="o">,</span><span class="k">'</span><span class="n">b</span><span class="p">)</span> <span class="n">rw_prot</span> <span class="n">ref</span>
  <span class="k">val</span> <span class="n">read</span>  <span class="o">:</span> <span class="p">(</span><span class="k">'</span><span class="n">a</span><span class="o">,</span><span class="p">[</span><span class="o">&gt;</span> <span class="nt">`Read</span> <span class="k">of</span> <span class="k">'</span><span class="n">a</span> <span class="o">*</span> <span class="k">'</span><span class="n">b</span><span class="p">])</span> <span class="n">rw_prot</span> <span class="n">ref</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">a</span> <span class="o">*</span> <span class="p">(</span><span class="k">'</span><span class="n">a</span><span class="o">,</span><span class="k">'</span><span class="n">b</span><span class="p">)</span> <span class="n">rw_prot</span> <span class="n">ref</span>
  <span class="k">val</span> <span class="n">write</span> <span class="o">:</span> <span class="p">(</span><span class="k">'</span><span class="n">a</span><span class="o">,</span><span class="p">[</span><span class="o">&gt;</span> <span class="nt">`Write</span> <span class="k">of</span> <span class="k">'</span><span class="n">b</span> <span class="o">*</span> <span class="p">(</span><span class="k">'</span><span class="n">b</span><span class="o">,</span><span class="k">'</span><span class="n">c</span><span class="p">)</span> <span class="n">rw_prot</span><span class="p">])</span> <span class="n">rw_prot</span> <span class="n">ref</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">b</span> <span class="o">-&gt;</span>
    <span class="p">(</span><span class="k">'</span><span class="n">b</span><span class="o">,</span><span class="k">'</span><span class="n">c</span><span class="p">)</span> <span class="n">rw_prot</span> <span class="n">ref</span>
  <span class="k">val</span> <span class="n">branch</span> <span class="o">:</span> <span class="p">(</span><span class="k">'</span><span class="n">a</span><span class="o">,</span> <span class="p">[</span><span class="o">&gt;</span><span class="p">]</span> <span class="k">as</span> <span class="k">'</span><span class="n">b</span><span class="p">)</span> <span class="n">rw_prot</span> <span class="n">ref</span> <span class="o">-&gt;</span> <span class="p">((</span><span class="k">'</span><span class="n">a</span><span class="o">,</span> <span class="p">[</span><span class="o">&gt;</span><span class="p">]</span> <span class="k">as</span> <span class="k">'</span><span class="n">c</span><span class="p">)</span> <span class="n">rw_prot</span> <span class="n">ref</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">b</span><span class="p">)</span> <span class="o">-&gt;</span>
    <span class="p">(</span><span class="k">'</span><span class="n">a</span><span class="o">,</span> <span class="k">'</span><span class="n">c</span><span class="p">)</span> <span class="n">rw_prot</span> <span class="n">ref</span>
<span class="k">end</span>
</code></pre></div></div>

<p>We can now write interesting programs:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="n">utop</span> <span class="o">#</span> <span class="k">let</span> <span class="k">rec</span> <span class="n">foo</span> <span class="n">r</span> <span class="o">=</span>
  <span class="k">let</span> <span class="n">v</span><span class="o">,</span><span class="n">r</span> <span class="o">=</span> <span class="n">read</span> <span class="n">r</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">r</span> <span class="o">=</span> <span class="n">write</span> <span class="n">r</span> <span class="p">(</span><span class="n">string_of_int</span> <span class="p">(</span><span class="n">v</span><span class="o">+</span><span class="mi">1</span><span class="p">))</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">v</span><span class="o">,</span><span class="n">r</span> <span class="o">=</span> <span class="n">read</span> <span class="n">r</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">r</span> <span class="o">=</span> <span class="n">write</span> <span class="n">r</span> <span class="p">(</span><span class="n">int_of_string</span> <span class="n">v</span><span class="p">)</span> <span class="k">in</span>
  <span class="n">foo</span> <span class="n">r</span><span class="p">;;</span>
<span class="k">val</span> <span class="n">foo</span> <span class="o">:</span>
  <span class="p">(</span><span class="kt">int</span><span class="o">,</span>
   <span class="p">[</span><span class="o">&gt;</span> <span class="nt">`Read</span> <span class="k">of</span> <span class="kt">int</span> <span class="o">*</span> <span class="k">'</span><span class="n">a</span>
    <span class="o">|</span> <span class="nt">`Write</span> <span class="k">of</span>
        <span class="kt">string</span> <span class="o">*</span>
        <span class="p">(</span><span class="kt">string</span><span class="o">,</span>
         <span class="p">[</span><span class="o">&gt;</span> <span class="nt">`Read</span> <span class="k">of</span> <span class="kt">string</span> <span class="o">*</span> <span class="k">'</span><span class="n">b</span> <span class="o">|</span> <span class="nt">`Write</span> <span class="k">of</span> <span class="kt">int</span> <span class="o">*</span> <span class="p">(</span><span class="kt">int</span><span class="o">,</span> <span class="k">'</span><span class="n">a</span><span class="p">)</span> <span class="n">rw_prot</span> <span class="p">]</span> <span class="k">as</span> <span class="k">'</span><span class="n">b</span><span class="p">)</span>
        <span class="n">rw_prot</span> <span class="p">]</span>
   <span class="k">as</span> <span class="k">'</span><span class="n">a</span><span class="p">)</span>
  <span class="n">rw_prot</span> <span class="nn">PolyRef</span><span class="p">.</span><span class="n">ref</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">c</span> <span class="o">=</span> <span class="o">&lt;</span><span class="k">fun</span><span class="o">&gt;</span>
</code></pre></div></div>

<p>Observe that <code class="language-plaintext highlighter-rouge">foo</code> reads <code class="language-plaintext highlighter-rouge">r</code> as a integer, updates it as a string, reads it as
a string and then finally writing an integer into it. The inferred type
reflects this change from <code class="language-plaintext highlighter-rouge">int -&gt; string -&gt; int</code>. The implementation of
polymorphic references uses the unsafe <code class="language-plaintext highlighter-rouge">Obj.magic</code> to coerce the contents.
However, the behavioural types ensure that accesses are safe.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">module</span> <span class="nc">PolyRef</span> <span class="o">:</span> <span class="nc">PolyRef</span> <span class="o">=</span>
<span class="k">struct</span>
  <span class="k">type</span> <span class="p">(</span><span class="k">'</span><span class="n">a</span><span class="o">,</span><span class="k">'</span><span class="n">b</span><span class="p">)</span> <span class="n">rw_prot</span>
    <span class="k">constraint</span> <span class="k">'</span><span class="n">b</span> <span class="o">=</span> <span class="p">[</span><span class="o">&gt;</span> <span class="nt">`Read</span> <span class="k">of</span> <span class="k">'</span><span class="n">a</span> <span class="o">*</span> <span class="k">'</span><span class="n">b</span> <span class="o">|</span> <span class="nt">`Write</span> <span class="k">of</span> <span class="k">'</span><span class="n">c</span> <span class="o">*</span> <span class="p">(</span><span class="k">'</span><span class="n">c</span><span class="o">,_</span><span class="p">)</span> <span class="n">rw_prot</span><span class="p">]</span>

  <span class="k">type</span> <span class="k">'</span><span class="n">a</span> <span class="n">ref</span> <span class="o">=</span>
    <span class="p">{</span><span class="n">contents</span>     <span class="o">:</span> <span class="k">'</span><span class="n">b</span><span class="o">.</span><span class="k">'</span><span class="n">b</span><span class="p">;</span>
     <span class="k">mutable</span> <span class="n">live</span> <span class="o">:</span> <span class="kt">bool</span><span class="p">}</span> <span class="c">(* For linearity *)</span>
     <span class="k">constraint</span> <span class="k">'</span><span class="n">a</span> <span class="o">=</span> <span class="p">(</span><span class="k">'</span><span class="n">b</span><span class="o">,</span><span class="k">'</span><span class="n">c</span><span class="p">)</span> <span class="n">rw_prot</span>

  <span class="k">let</span> <span class="n">ref</span> <span class="n">v</span> <span class="o">=</span> <span class="p">{</span><span class="n">contents</span> <span class="o">=</span> <span class="nn">Obj</span><span class="p">.</span><span class="n">magic</span> <span class="n">v</span><span class="p">;</span> <span class="n">live</span> <span class="o">=</span> <span class="bp">true</span><span class="p">}</span>

  <span class="k">let</span> <span class="n">check</span> <span class="n">r</span> <span class="o">=</span>
    <span class="k">if</span> <span class="n">not</span> <span class="n">r</span><span class="o">.</span><span class="n">live</span> <span class="k">then</span> <span class="k">raise</span> <span class="nc">LinearityViolation</span><span class="p">;</span>
    <span class="n">r</span><span class="o">.</span><span class="n">live</span> <span class="o">&lt;-</span> <span class="bp">false</span>

  <span class="k">let</span> <span class="n">fresh</span> <span class="n">r</span> <span class="o">=</span> <span class="p">{</span><span class="n">r</span> <span class="k">with</span> <span class="n">live</span> <span class="o">=</span> <span class="bp">true</span><span class="p">}</span>

  <span class="k">let</span> <span class="n">read</span> <span class="n">r</span> <span class="o">=</span>
    <span class="n">check</span> <span class="n">r</span><span class="p">;</span>
    <span class="p">(</span><span class="nn">Obj</span><span class="p">.</span><span class="n">magic</span> <span class="n">r</span><span class="o">.</span><span class="n">contents</span><span class="o">,</span> <span class="n">fresh</span> <span class="n">r</span><span class="p">)</span>

  <span class="k">let</span> <span class="n">write</span> <span class="n">r</span> <span class="n">v</span> <span class="o">=</span>
    <span class="n">check</span> <span class="n">r</span><span class="p">;</span>
    <span class="p">{</span> <span class="n">contents</span> <span class="o">=</span> <span class="nn">Obj</span><span class="p">.</span><span class="n">magic</span> <span class="n">v</span><span class="p">;</span> <span class="n">live</span> <span class="o">=</span> <span class="bp">true</span> <span class="p">}</span>

  <span class="k">let</span> <span class="n">branch</span> <span class="n">r</span> <span class="n">_</span> <span class="o">=</span> <span class="n">check</span> <span class="n">r</span><span class="p">;</span> <span class="n">fresh</span> <span class="n">r</span>
<span class="k">end</span>
</code></pre></div></div>

<h2>File descriptors</h2>

<p>We can utilise behavioural types to apply meaningful restrictions to operations
on file descriptors.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">module</span> <span class="k">type</span> <span class="nc">File_descriptor</span> <span class="o">=</span> <span class="k">sig</span>
  <span class="k">type</span> <span class="k">'</span><span class="n">a</span> <span class="n">t</span> <span class="k">constraint</span> <span class="k">'</span><span class="n">a</span> <span class="o">=</span> <span class="p">[</span><span class="o">&gt;</span><span class="p">]</span>

  <span class="k">val</span> <span class="n">openfile</span> <span class="o">:</span> <span class="kt">string</span> <span class="o">-&gt;</span> <span class="nn">Unix</span><span class="p">.</span><span class="n">open_flag</span> <span class="kt">list</span> <span class="o">-&gt;</span> <span class="nn">Unix</span><span class="p">.</span><span class="n">file_perm</span> <span class="o">-&gt;</span>
    <span class="p">([</span><span class="o">&lt;</span> <span class="nt">`Close</span> <span class="o">|</span> <span class="nt">`Write</span> <span class="k">of</span> <span class="k">'</span><span class="n">a</span> <span class="o">|</span> <span class="nt">`Read</span> <span class="k">of</span> <span class="k">'</span><span class="n">a</span> <span class="o">&gt;</span> <span class="nt">`Close</span><span class="p">]</span> <span class="k">as</span> <span class="k">'</span><span class="n">a</span><span class="p">)</span> <span class="n">t</span>
  <span class="k">val</span> <span class="n">close</span> <span class="o">:</span> <span class="p">[</span><span class="o">&gt;</span> <span class="nt">`Close</span><span class="p">]</span> <span class="n">t</span> <span class="o">-&gt;</span> <span class="kt">unit</span>
  <span class="k">val</span> <span class="n">read</span> <span class="o">:</span> <span class="p">[</span><span class="o">&gt;</span> <span class="nt">`Read</span> <span class="k">of</span> <span class="k">'</span><span class="n">a</span><span class="p">]</span> <span class="n">t</span> <span class="o">-&gt;</span> <span class="n">bytes</span> <span class="o">-&gt;</span> <span class="kt">int</span> <span class="o">-&gt;</span> <span class="kt">int</span> <span class="o">-&gt;</span> <span class="kt">int</span> <span class="o">*</span> <span class="k">'</span><span class="n">a</span> <span class="n">t</span>
  <span class="k">val</span> <span class="n">write</span> <span class="o">:</span> <span class="p">[</span><span class="o">&gt;</span> <span class="nt">`Write</span> <span class="k">of</span> <span class="k">'</span><span class="n">a</span><span class="p">]</span> <span class="n">t</span> <span class="o">-&gt;</span> <span class="n">bytes</span> <span class="o">-&gt;</span> <span class="kt">int</span> <span class="o">-&gt;</span> <span class="kt">int</span> <span class="o">-&gt;</span> <span class="kt">int</span> <span class="o">*</span> <span class="k">'</span><span class="n">a</span> <span class="n">t</span>
  <span class="k">val</span> <span class="n">mk_read_only</span>  <span class="o">:</span> <span class="p">[</span><span class="o">&gt;</span> <span class="nt">`Read</span> <span class="k">of</span> <span class="k">'</span><span class="n">a</span><span class="p">]</span> <span class="n">t</span> <span class="o">-&gt;</span> <span class="p">([</span><span class="nt">`Close</span> <span class="o">|</span> <span class="nt">`Read</span> <span class="k">of</span> <span class="k">'</span><span class="n">a</span><span class="p">]</span> <span class="k">as</span> <span class="k">'</span><span class="n">a</span><span class="p">)</span> <span class="n">t</span>
  <span class="k">val</span> <span class="n">mk_write_only</span> <span class="o">:</span> <span class="p">[</span><span class="o">&gt;</span> <span class="nt">`Write</span> <span class="k">of</span> <span class="k">'</span><span class="n">a</span><span class="p">]</span> <span class="n">t</span> <span class="o">-&gt;</span> <span class="p">([</span><span class="nt">`Close</span> <span class="o">|</span> <span class="nt">`Write</span> <span class="k">of</span> <span class="k">'</span><span class="n">a</span><span class="p">]</span> <span class="k">as</span> <span class="k">'</span><span class="n">a</span><span class="p">)</span> <span class="n">t</span>

  <span class="k">val</span> <span class="n">open_stdin</span>  <span class="o">:</span> <span class="kt">unit</span> <span class="o">-&gt;</span> <span class="p">([</span><span class="nt">`Close</span> <span class="o">|</span> <span class="nt">`Read</span> <span class="k">of</span> <span class="k">'</span><span class="n">a</span><span class="p">]</span> <span class="k">as</span> <span class="k">'</span><span class="n">a</span><span class="p">)</span> <span class="n">t</span>
  <span class="k">val</span> <span class="n">open_stdout</span> <span class="o">:</span> <span class="kt">unit</span> <span class="o">-&gt;</span> <span class="p">([</span><span class="nt">`Close</span> <span class="o">|</span> <span class="nt">`Write</span> <span class="k">of</span> <span class="k">'</span><span class="n">a</span><span class="p">]</span> <span class="k">as</span> <span class="k">'</span><span class="n">a</span><span class="p">)</span> <span class="n">t</span>
  <span class="k">val</span> <span class="n">open_stderr</span> <span class="o">:</span> <span class="kt">unit</span> <span class="o">-&gt;</span> <span class="p">([</span><span class="nt">`Close</span> <span class="o">|</span> <span class="nt">`Write</span> <span class="k">of</span> <span class="k">'</span><span class="n">a</span><span class="p">]</span> <span class="k">as</span> <span class="k">'</span><span class="n">a</span><span class="p">)</span> <span class="n">t</span>
<span class="k">end</span>
</code></pre></div></div>

<p>The <code class="language-plaintext highlighter-rouge">File_descriptor</code> module is a thin wrapper around the file descriptors from
<code class="language-plaintext highlighter-rouge">Unix</code> module. The file descriptor obtained through openfile permits a subset
of operations to read, write and close. The precise set of capabilities is
dictated by the flags supplied. For example, with <code class="language-plaintext highlighter-rouge">O_RDONLY</code> the type of the
file descriptor obtained should be <code class="language-plaintext highlighter-rouge">([`Close | `Read of 'a] as 'a) t</code>. The
types of standard streams are also restricted. For example,</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="n">utop</span> <span class="o">#</span> <span class="n">open_stderr</span> <span class="bp">()</span> <span class="o">|&gt;</span> <span class="k">fun</span> <span class="n">fd</span> <span class="o">-&gt;</span> <span class="n">write</span> <span class="n">fd</span> <span class="s2">&quot;hello</span><span class="se">\n</span><span class="s2">&quot;</span> <span class="mi">0</span> <span class="mi">6</span><span class="p">;;</span>
<span class="n">hello</span>
<span class="o">-</span> <span class="o">:</span> <span class="kt">int</span> <span class="o">*</span> <span class="p">([</span> <span class="nt">`Close</span> <span class="o">|</span> <span class="nt">`Write</span> <span class="k">of</span> <span class="k">'</span><span class="n">a</span> <span class="p">]</span> <span class="k">as</span> <span class="k">'</span><span class="n">a</span><span class="p">)</span> <span class="n">t</span> <span class="o">=</span> <span class="p">(</span><span class="mi">6</span><span class="o">,</span> <span class="o">&lt;</span><span class="n">abstr</span><span class="o">&gt;</span><span class="p">)</span>
<span class="n">utop</span> <span class="o">#</span> <span class="n">open_stdin</span> <span class="bp">()</span> <span class="o">|&gt;</span> <span class="k">fun</span> <span class="n">fd</span> <span class="o">-&gt;</span> <span class="n">write</span> <span class="n">fd</span> <span class="s2">&quot;hello</span><span class="se">\n</span><span class="s2">&quot;</span> <span class="mi">0</span> <span class="mi">6</span><span class="p">;;</span>
<span class="nc">Error</span><span class="o">:</span> <span class="nc">This</span> <span class="n">expression</span> <span class="n">has</span> <span class="k">type</span> <span class="p">([</span> <span class="nt">`Close</span> <span class="o">|</span> <span class="nt">`Read</span> <span class="k">of</span> <span class="k">'</span><span class="n">a</span> <span class="p">]</span> <span class="k">as</span> <span class="k">'</span><span class="n">a</span><span class="p">)</span> <span class="n">t</span>
       <span class="n">but</span> <span class="n">an</span> <span class="n">expression</span> <span class="n">was</span> <span class="n">expected</span> <span class="k">of</span> <span class="k">type</span> <span class="p">[</span><span class="o">&gt;</span> <span class="nt">`Write</span> <span class="k">of</span> <span class="p">[</span><span class="o">&gt;</span>  <span class="p">]</span> <span class="p">]</span> <span class="n">t</span>
       <span class="nc">The</span> <span class="n">first</span> <span class="n">variant</span> <span class="k">type</span> <span class="n">does</span> <span class="n">not</span> <span class="n">allow</span> <span class="n">tag</span><span class="p">(</span><span class="n">s</span><span class="p">)</span> <span class="nt">`Write</span>
</code></pre></div></div>

<p>File descriptors can also be made read or write only.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="n">utop</span> <span class="o">#</span> <span class="k">let</span> <span class="n">foo</span> <span class="n">fd</span> <span class="o">=</span>
         <span class="k">let</span> <span class="n">_</span><span class="o">,</span> <span class="n">fd</span> <span class="o">=</span> <span class="n">write</span> <span class="n">fd</span>  <span class="s2">&quot;hello</span><span class="se">\n</span><span class="s2">&quot;</span> <span class="mi">0</span> <span class="mi">6</span> <span class="k">in</span>
         <span class="k">let</span> <span class="n">fd</span> <span class="o">=</span> <span class="n">mk_read_only</span> <span class="n">fd</span> <span class="k">in</span>
         <span class="n">write</span> <span class="n">fd</span> <span class="s2">&quot;hello</span><span class="se">\n</span><span class="s2">&quot;</span> <span class="mi">0</span> <span class="mi">6</span><span class="p">;;</span>
<span class="nc">Error</span><span class="o">:</span> <span class="nc">This</span> <span class="n">expression</span> <span class="n">has</span> <span class="k">type</span> <span class="p">([</span> <span class="nt">`Close</span> <span class="o">|</span> <span class="nt">`Read</span> <span class="k">of</span> <span class="k">'</span><span class="n">a</span> <span class="p">]</span> <span class="k">as</span> <span class="k">'</span><span class="n">a</span><span class="p">)</span> <span class="n">t</span>
       <span class="n">but</span> <span class="n">an</span> <span class="n">expression</span> <span class="n">was</span> <span class="n">expected</span> <span class="k">of</span> <span class="k">type</span> <span class="p">[</span><span class="o">&gt;</span> <span class="nt">`Write</span> <span class="k">of</span> <span class="p">[</span><span class="o">&gt;</span>  <span class="p">]</span> <span class="p">]</span> <span class="n">t</span>
       <span class="nc">The</span> <span class="n">first</span> <span class="n">variant</span> <span class="k">type</span> <span class="n">does</span> <span class="n">not</span> <span class="n">allow</span> <span class="n">tag</span><span class="p">(</span><span class="n">s</span><span class="p">)</span> <span class="nt">`Write</span>
</code></pre></div></div>

<p>The implementation of the module is straightforward.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">module</span> <span class="nc">File_descriptor</span> <span class="o">:</span> <span class="nc">File_descriptor</span> <span class="o">=</span> <span class="k">struct</span>
  <span class="k">open</span> <span class="nc">Unix</span>

  <span class="k">type</span> <span class="k">'</span><span class="n">a</span> <span class="n">t</span> <span class="o">=</span>
    <span class="p">{</span><span class="n">fd</span> <span class="o">:</span> <span class="n">file_descr</span><span class="p">;</span>
     <span class="k">mutable</span> <span class="n">live</span> <span class="o">:</span> <span class="kt">bool</span><span class="p">}</span> <span class="k">constraint</span> <span class="k">'</span><span class="n">a</span> <span class="o">=</span> <span class="p">[</span><span class="o">&gt;</span><span class="p">]</span>

  <span class="k">let</span> <span class="n">mk</span> <span class="n">fd</span> <span class="o">=</span> <span class="p">{</span><span class="n">fd</span> <span class="o">=</span> <span class="n">fd</span><span class="p">;</span> <span class="n">live</span> <span class="o">=</span> <span class="bp">true</span><span class="p">}</span>

  <span class="k">let</span> <span class="n">fresh</span> <span class="n">fd</span> <span class="o">=</span> <span class="p">{</span><span class="n">fd</span> <span class="k">with</span> <span class="n">live</span> <span class="o">=</span> <span class="bp">true</span><span class="p">}</span>

  <span class="k">let</span> <span class="n">check</span> <span class="n">fd</span> <span class="o">=</span>
    <span class="k">if</span> <span class="n">not</span> <span class="n">fd</span><span class="o">.</span><span class="n">live</span> <span class="k">then</span> <span class="k">raise</span> <span class="nc">LinearityViolation</span><span class="p">;</span>
    <span class="n">fd</span><span class="o">.</span><span class="n">live</span> <span class="o">&lt;-</span> <span class="bp">false</span>

  <span class="k">let</span> <span class="n">open_stdin</span> <span class="bp">()</span> <span class="o">=</span> <span class="n">mk</span> <span class="n">stdin</span>
  <span class="k">let</span> <span class="n">open_stdout</span> <span class="bp">()</span> <span class="o">=</span> <span class="n">mk</span> <span class="n">stdout</span>
  <span class="k">let</span> <span class="n">open_stderr</span> <span class="bp">()</span> <span class="o">=</span> <span class="n">mk</span> <span class="n">stderr</span>

  <span class="k">let</span> <span class="n">openfile</span> <span class="n">file</span> <span class="n">flags</span> <span class="n">perm</span> <span class="o">=</span>
    <span class="k">let</span> <span class="n">fd</span> <span class="o">=</span> <span class="n">openfile</span> <span class="n">file</span> <span class="n">flags</span> <span class="n">perm</span> <span class="k">in</span>
    <span class="n">mk</span> <span class="n">fd</span>

  <span class="k">let</span> <span class="n">close</span> <span class="n">fd</span> <span class="o">=</span> <span class="n">check</span> <span class="n">fd</span><span class="p">;</span> <span class="n">close</span> <span class="n">fd</span><span class="o">.</span><span class="n">fd</span>

  <span class="k">let</span> <span class="n">read</span> <span class="n">fd</span> <span class="n">buff</span> <span class="n">ofs</span> <span class="n">len</span> <span class="o">=</span>
    <span class="n">check</span> <span class="n">fd</span><span class="p">;</span>
    <span class="p">(</span><span class="n">read</span> <span class="n">fd</span><span class="o">.</span><span class="n">fd</span> <span class="n">buff</span> <span class="n">ofs</span> <span class="n">len</span><span class="o">,</span> <span class="n">fresh</span> <span class="n">fd</span><span class="p">)</span>

  <span class="k">let</span> <span class="n">write</span> <span class="n">fd</span> <span class="n">buff</span> <span class="n">ofs</span> <span class="n">len</span> <span class="o">=</span>
    <span class="n">check</span> <span class="n">fd</span><span class="p">;</span>
    <span class="p">(</span><span class="n">write</span> <span class="n">fd</span><span class="o">.</span><span class="n">fd</span> <span class="n">buff</span> <span class="n">ofs</span> <span class="n">len</span><span class="o">,</span> <span class="n">fresh</span> <span class="n">fd</span><span class="p">)</span>

  <span class="k">let</span> <span class="n">mk_read_only</span> <span class="n">fd</span> <span class="o">=</span> <span class="n">check</span> <span class="n">fd</span><span class="p">;</span> <span class="n">fresh</span> <span class="n">fd</span>
  <span class="k">let</span> <span class="n">mk_write_only</span> <span class="n">fd</span> <span class="o">=</span> <span class="n">check</span> <span class="n">fd</span><span class="p">;</span> <span class="n">fresh</span> <span class="n">fd</span>
<span class="k">end</span>

</code></pre></div></div>

<h2>Tracking Aliases</h2>

<p>The final example I will discuss is alias tracking.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">module</span> <span class="k">type</span> <span class="nc">Alias</span> <span class="o">=</span> <span class="k">sig</span>
  <span class="k">type</span> <span class="p">(</span><span class="k">'</span><span class="n">a</span><span class="o">,</span><span class="k">'</span><span class="n">b</span><span class="p">)</span> <span class="n">t</span> <span class="k">constraint</span> <span class="k">'</span><span class="n">b</span> <span class="o">=</span> <span class="p">[</span><span class="o">&gt;</span><span class="p">]</span>
  <span class="k">val</span> <span class="n">make</span>   <span class="o">:</span> <span class="p">(</span><span class="kt">unit</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">a</span><span class="p">)</span> <span class="o">-&gt;</span> <span class="p">(</span><span class="k">'</span><span class="n">a</span><span class="o">,</span> <span class="p">[</span><span class="nt">`One</span><span class="p">])</span> <span class="n">t</span>
  <span class="k">val</span> <span class="n">dup</span>    <span class="o">:</span> <span class="p">(</span><span class="k">'</span><span class="n">a</span><span class="o">,</span> <span class="k">'</span><span class="n">b</span><span class="p">)</span> <span class="n">t</span> <span class="o">-&gt;</span> <span class="p">(</span><span class="k">'</span><span class="n">a</span><span class="o">,</span><span class="p">[</span><span class="nt">`Succ</span> <span class="k">of</span> <span class="k">'</span><span class="n">b</span><span class="p">])</span> <span class="n">t</span> <span class="o">*</span> <span class="p">(</span><span class="k">'</span><span class="n">a</span><span class="o">,</span> <span class="p">[</span><span class="nt">`Succ</span> <span class="k">of</span> <span class="k">'</span><span class="n">b</span><span class="p">])</span> <span class="n">t</span>
  <span class="k">val</span> <span class="n">merge</span>  <span class="o">:</span> <span class="p">(</span><span class="k">'</span><span class="n">a</span><span class="o">,</span> <span class="p">[</span><span class="nt">`Succ</span> <span class="k">of</span> <span class="k">'</span><span class="n">b</span><span class="p">])</span> <span class="n">t</span> <span class="o">-&gt;</span> <span class="p">(</span><span class="k">'</span><span class="n">a</span><span class="o">,</span> <span class="p">[</span><span class="nt">`Succ</span> <span class="k">of</span> <span class="k">'</span><span class="n">b</span><span class="p">])</span> <span class="n">t</span> <span class="o">-&gt;</span> <span class="p">(</span><span class="k">'</span><span class="n">a</span><span class="o">,</span> <span class="k">'</span><span class="n">b</span><span class="p">)</span> <span class="n">t</span>
  <span class="k">val</span> <span class="n">free</span>   <span class="o">:</span> <span class="p">(</span><span class="k">'</span><span class="n">a</span><span class="o">,</span> <span class="p">[</span><span class="nt">`One</span><span class="p">])</span> <span class="n">t</span> <span class="o">-&gt;</span> <span class="p">(</span><span class="k">'</span><span class="n">a</span> <span class="o">-&gt;</span> <span class="kt">unit</span><span class="p">)</span> <span class="o">-&gt;</span> <span class="kt">unit</span>
  <span class="k">val</span> <span class="n">app</span>    <span class="o">:</span> <span class="p">(</span><span class="k">'</span><span class="n">a</span><span class="o">,</span><span class="k">'</span><span class="n">b</span><span class="p">)</span> <span class="n">t</span> <span class="o">-&gt;</span> <span class="p">(</span><span class="k">'</span><span class="n">a</span> <span class="o">-&gt;</span> <span class="kt">unit</span><span class="p">)</span> <span class="o">-&gt;</span> <span class="kt">unit</span>
<span class="k">end</span>

<span class="k">module</span> <span class="nc">Alias</span> <span class="o">:</span> <span class="nc">Alias</span> <span class="o">=</span> <span class="k">struct</span>
  <span class="k">type</span> <span class="p">(</span><span class="k">'</span><span class="n">a</span><span class="o">,</span><span class="k">'</span><span class="n">b</span><span class="p">)</span> <span class="n">t</span> <span class="o">=</span>
    <span class="p">{</span><span class="n">v</span> <span class="o">:</span> <span class="k">'</span><span class="n">a</span><span class="p">;</span> <span class="k">mutable</span> <span class="n">live</span> <span class="o">:</span> <span class="kt">bool</span><span class="p">}</span> <span class="k">constraint</span> <span class="k">'</span><span class="n">b</span> <span class="o">=</span> <span class="p">[</span><span class="o">&gt;</span><span class="p">]</span>

  <span class="k">let</span> <span class="n">fresh</span> <span class="n">a</span> <span class="o">=</span> <span class="p">{</span><span class="n">a</span> <span class="k">with</span> <span class="n">live</span> <span class="o">=</span> <span class="bp">true</span><span class="p">}</span>

  <span class="k">let</span> <span class="n">check</span> <span class="n">a</span> <span class="o">=</span>
    <span class="k">if</span> <span class="n">not</span> <span class="n">a</span><span class="o">.</span><span class="n">live</span> <span class="k">then</span> <span class="k">raise</span> <span class="nc">LinearityViolation</span><span class="p">;</span>
    <span class="n">a</span><span class="o">.</span><span class="n">live</span> <span class="o">&lt;-</span> <span class="bp">false</span>

  <span class="k">let</span> <span class="n">make</span> <span class="n">f</span> <span class="o">=</span> <span class="p">{</span><span class="n">v</span> <span class="o">=</span> <span class="n">f</span> <span class="bp">()</span><span class="p">;</span> <span class="n">live</span> <span class="o">=</span> <span class="bp">true</span><span class="p">}</span>
  <span class="k">let</span> <span class="n">dup</span> <span class="n">x</span> <span class="o">=</span> <span class="n">check</span> <span class="n">x</span><span class="p">;</span> <span class="p">(</span><span class="n">fresh</span> <span class="n">x</span><span class="o">,</span> <span class="n">fresh</span> <span class="n">x</span><span class="p">)</span>
  <span class="k">let</span> <span class="n">merge</span> <span class="n">x</span> <span class="n">y</span> <span class="o">=</span> <span class="n">check</span> <span class="n">x</span><span class="p">;</span> <span class="n">check</span> <span class="n">y</span><span class="p">;</span> <span class="n">fresh</span> <span class="n">x</span>
  <span class="k">let</span> <span class="n">free</span> <span class="n">x</span> <span class="n">f</span> <span class="o">=</span> <span class="n">check</span> <span class="n">x</span><span class="p">;</span> <span class="n">f</span> <span class="n">x</span><span class="o">.</span><span class="n">v</span>
  <span class="k">let</span> <span class="n">app</span> <span class="n">x</span> <span class="n">f</span> <span class="o">=</span> <span class="n">f</span> <span class="n">x</span><span class="o">.</span><span class="n">v</span>
<span class="k">end</span>
</code></pre></div></div>

<p>The type variable <code class="language-plaintext highlighter-rouge">'b</code> tracks aliases as a depth in the aliasing tree. New
resources are initialised with <code class="language-plaintext highlighter-rouge">make</code>, and the resultant resource has type
<code class="language-plaintext highlighter-rouge">('a,[`One]) t</code> indicating that there is just one reference to this resource.
Aliases are created explicitly with <code class="language-plaintext highlighter-rouge">dup</code>, which destroys the original
reference and returns two new references, each one level deeper than the
original reference. Two references from the same level can be merged together
to obtain a reference at the next higher level, and in doing so destroying the
original references. All of this machinery is to ensure that the resource can
only be <code class="language-plaintext highlighter-rouge">free</code>d when there is a unique reference.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="n">utop</span> <span class="o">#</span> <span class="k">let</span> <span class="n">r</span> <span class="o">=</span> <span class="n">make</span> <span class="p">(</span><span class="k">fun</span> <span class="n">_</span> <span class="o">-&gt;</span> <span class="n">ref</span> <span class="mi">0</span><span class="p">);;</span>
<span class="k">val</span> <span class="n">r</span> <span class="o">:</span> <span class="p">(</span><span class="kt">int</span> <span class="n">ref</span><span class="o">,</span> <span class="p">[</span> <span class="nt">`One</span> <span class="p">])</span> <span class="n">t</span> <span class="o">=</span> <span class="o">&lt;</span><span class="n">abstr</span><span class="o">&gt;</span>
<span class="n">utop</span> <span class="o">#</span> <span class="k">let</span> <span class="n">r1</span><span class="o">,</span><span class="n">r2</span> <span class="o">=</span> <span class="n">dup</span> <span class="n">r</span><span class="p">;;</span>
<span class="k">val</span> <span class="n">r1</span> <span class="o">:</span> <span class="p">(</span><span class="kt">int</span> <span class="n">ref</span><span class="o">,</span> <span class="p">[</span> <span class="nt">`Succ</span> <span class="k">of</span> <span class="p">[</span> <span class="nt">`One</span> <span class="p">]</span> <span class="p">])</span> <span class="n">t</span> <span class="o">=</span> <span class="o">&lt;</span><span class="n">abstr</span><span class="o">&gt;</span>
<span class="k">val</span> <span class="n">r2</span> <span class="o">:</span> <span class="p">(</span><span class="kt">int</span> <span class="n">ref</span><span class="o">,</span> <span class="p">[</span> <span class="nt">`Succ</span> <span class="k">of</span> <span class="p">[</span> <span class="nt">`One</span> <span class="p">]</span> <span class="p">])</span> <span class="n">t</span> <span class="o">=</span> <span class="o">&lt;</span><span class="n">abstr</span><span class="o">&gt;</span>
<span class="n">utop</span> <span class="o">#</span> <span class="k">let</span> <span class="n">r11</span><span class="o">,</span><span class="n">r12</span> <span class="o">=</span> <span class="n">dup</span> <span class="n">r1</span><span class="p">;;</span>
<span class="k">val</span> <span class="n">r11</span> <span class="o">:</span> <span class="p">(</span><span class="kt">int</span> <span class="n">ref</span><span class="o">,</span> <span class="p">[</span> <span class="nt">`Succ</span> <span class="k">of</span> <span class="p">[</span> <span class="nt">`Succ</span> <span class="k">of</span> <span class="p">[</span> <span class="nt">`One</span> <span class="p">]</span> <span class="p">]</span> <span class="p">])</span> <span class="n">t</span> <span class="o">=</span> <span class="o">&lt;</span><span class="n">abstr</span><span class="o">&gt;</span>
<span class="k">val</span> <span class="n">r12</span> <span class="o">:</span> <span class="p">(</span><span class="kt">int</span> <span class="n">ref</span><span class="o">,</span> <span class="p">[</span> <span class="nt">`Succ</span> <span class="k">of</span> <span class="p">[</span> <span class="nt">`Succ</span> <span class="k">of</span> <span class="p">[</span> <span class="nt">`One</span> <span class="p">]</span> <span class="p">]</span> <span class="p">])</span> <span class="n">t</span> <span class="o">=</span> <span class="o">&lt;</span><span class="n">abstr</span><span class="o">&gt;</span>
<span class="n">utop</span> <span class="o">#</span> <span class="k">let</span> <span class="n">r21</span><span class="o">,</span> <span class="n">r22</span> <span class="o">=</span> <span class="n">dup</span> <span class="n">r2</span><span class="p">;;</span>
<span class="k">val</span> <span class="n">r21</span> <span class="o">:</span> <span class="p">(</span><span class="kt">int</span> <span class="n">ref</span><span class="o">,</span> <span class="p">[</span> <span class="nt">`Succ</span> <span class="k">of</span> <span class="p">[</span> <span class="nt">`Succ</span> <span class="k">of</span> <span class="p">[</span> <span class="nt">`One</span> <span class="p">]</span> <span class="p">]</span> <span class="p">])</span> <span class="n">t</span> <span class="o">=</span> <span class="o">&lt;</span><span class="n">abstr</span><span class="o">&gt;</span>
<span class="k">val</span> <span class="n">r22</span> <span class="o">:</span> <span class="p">(</span><span class="kt">int</span> <span class="n">ref</span><span class="o">,</span> <span class="p">[</span> <span class="nt">`Succ</span> <span class="k">of</span> <span class="p">[</span> <span class="nt">`Succ</span> <span class="k">of</span> <span class="p">[</span> <span class="nt">`One</span> <span class="p">]</span> <span class="p">]</span> <span class="p">])</span> <span class="n">t</span> <span class="o">=</span> <span class="o">&lt;</span><span class="n">abstr</span><span class="o">&gt;</span>
<span class="n">utop</span> <span class="o">#</span> <span class="k">let</span> <span class="n">r1</span> <span class="o">=</span> <span class="n">merge</span> <span class="n">r11</span> <span class="n">r22</span><span class="p">;;</span>
<span class="k">val</span> <span class="n">r1</span> <span class="o">:</span> <span class="p">(</span><span class="kt">int</span> <span class="n">ref</span><span class="o">,</span> <span class="p">[</span> <span class="nt">`Succ</span> <span class="k">of</span> <span class="p">[</span> <span class="nt">`One</span> <span class="p">]</span> <span class="p">])</span> <span class="n">t</span> <span class="o">=</span> <span class="o">&lt;</span><span class="n">abstr</span><span class="o">&gt;</span>
<span class="n">utop</span> <span class="o">#</span> <span class="k">let</span> <span class="n">r2</span> <span class="o">=</span> <span class="n">merge</span> <span class="n">r12</span> <span class="n">r21</span><span class="p">;;</span>
<span class="k">val</span> <span class="n">r2</span> <span class="o">:</span> <span class="p">(</span><span class="kt">int</span> <span class="n">ref</span><span class="o">,</span> <span class="p">[</span> <span class="nt">`Succ</span> <span class="k">of</span> <span class="p">[</span> <span class="nt">`One</span> <span class="p">]</span> <span class="p">])</span> <span class="n">t</span> <span class="o">=</span> <span class="o">&lt;</span><span class="n">abstr</span><span class="o">&gt;</span>
<span class="n">utop</span> <span class="o">#</span> <span class="n">free</span> <span class="p">(</span><span class="n">merge</span> <span class="n">r1</span> <span class="n">r2</span><span class="p">);;</span>
<span class="o">-</span> <span class="o">:</span> <span class="p">(</span><span class="kt">int</span> <span class="n">ref</span> <span class="o">-&gt;</span> <span class="kt">unit</span><span class="p">)</span> <span class="o">-&gt;</span> <span class="kt">unit</span> <span class="o">=</span> <span class="o">&lt;</span><span class="k">fun</span><span class="o">&gt;</span>
</code></pre></div></div>

<h2>Conclusion</h2>

<p>Polymorphic variants are quite effective in encoding behavioural types.
However, the absence of linear types in OCaml makes us resort to dynamic tests
for linear use of resources. While it is possible to hide the resource under a
monad, combining the use of multiple resources would require monad
transformers, which is well known to be quite heavyweight in terms of
programmability. Perhaps an effect system would do the trick.</p>

