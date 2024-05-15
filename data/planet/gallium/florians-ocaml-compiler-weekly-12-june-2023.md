---
title: Florian's OCaml compiler weekly, 12 June 2023
description:
url: http://cambium.inria.fr/blog/florian-compiler-weekly-2023-06-12
date: 2023-06-12T08:00:00-00:00
preview_image:
authors:
- GaGallium
source:
---




<p>This series of blog post aims to give a short weekly glimpse into my
(Florian Angeletti) daily work on the OCaml compiler. This week, the
focus is on my roadmap for OCaml 5.2.0 .</p>


  

<h3>My roadmap for 5.2.0</h3>
<p>With the stabilisation of OCaml 5.1.0, I have been taking the time to
write down some of my main objectives for OCaml 5.2. There are two
improvements on the compiler interfaces, that I really want to see
materialise in OCaml 5.2: a structured output for compiler messages and
an unified <code>short-paths</code> implementation between Merlin and
the compiler.</p>
<h4>A structured output
for compiler messages.</h4>
<p>In order to better communicate with the various OCaml development
tools, it should be possible to emit compiler messages in a structured
format (JSON or SEXP). One of the Outreachy internship that I mentored
implemented a <a href="https://github.com/ocaml/ocaml/pull/9979">first
version of JSON messages</a> few years ago in 2020.</p>
<p>However, one criticism of this approach was that it was not clear if
the format would be useful for tools like dune. Similarly, it was not
clear if this format could evolve in a backward compatible way.</p>
<p>After discussing the issue further with dune developers, the
conclusion was that if any kind of structured output would be useful for
dune, a versioned and backward compatible output would be
<em>really</em> helpful.</p>
<p>This is why I am planning to go back on my structured output work in
OCaml 5.2 while focusing on a versioned and structured log facility,
that can be connected to various backend.</p>
<h4>Unified short paths in
compiler messages</h4>
<p>When printing type paths in error messages, it is useful to print
user-friendly type names like <code>M.t</code> and not whatever path the
typechecker stumbled upon after various expansions like
<code>A.Very.Long(Type).Application.t</code>.</p>
<p>Both the compiler type pretty-printer and Merlin have an
implementation for discovering and computing canonical type paths in
error messages, which is enabled by the <code>-short-paths</code>
option.</p>
<p>However, the implementation of this path normalisation is completely
different between Merlin and the compiler. Having two implementations is
painful in term of both maintenance and evolution of this feature.
Moreover, the compiler implementation was originally meant to be a
temporary prototype for OCaml 4.01.0, ten years ago.</p>
<p>This is why I am hoping to find the time to finally upstream Merlin&rsquo;s
implementation of the <code>-short-path</code> flag.</p>
<h3>Updating
<code>ppxlib</code> after a parsetree refinement</h3>
<p>Last week, I also spent some of my time working with the ppxlib team
to iron out the last wrinkles of the second alpha for 5.1.0.</p>
<p>From the point of view of ppxlib, one of the interesting challenge
introduced by the <code>value binding</code> parsetree change in 5.1.0
is that it added a new way to represent an old construct</p>
<div class="highlight"><pre><span></span>let x : typ = expr
</pre></div>

<p>rather than a completely new construct.</p>
<p>Indeed, before OCaml 5.1, this construct was desugared to</p>
<div class="highlight"><pre><span></span>let (x:&oslash;. typ) = (expr:typ)
</pre></div>

<p>whereas in OCaml 5.1, this construct is a new distinct parsetree
node.</p>
<p>This new parsetree node lead to some interesting questions when
migrating Abstract Syntax Tree between version:</p>
<h4>When
migrating from the 5.1 to 5.0, can we reproduce the old encoding down to
the location</h4>
<p>information?</p>
<p>Maybe surprisingly, the answer is <em>no</em>. This is due to the
ghost location used in the ghost constraint node: when desugaring
<code>let x: (((int))) = 0</code> to</p>
<div class="highlight"><pre><span></span><span class="k">let</span> <span class="o">(</span><span class="n">x</span><span class="o">:</span><span class="n">&oslash;</span><span class="o">.</span> <span class="kt">int</span><span class="o">)</span> <span class="o">=</span> <span class="mi">0</span>
</pre></div>

<p>the 5.0 parser attributed to the pattern <code>x:&oslash;. typ</code> the
ghost location</p>
<div class="highlight"><pre><span></span><span class="k">let</span> <span class="n">x</span> <span class="o">:</span> <span class="o">((((</span><span class="kt">int</span><span class="o">))))</span>  <span class="o">=</span>
    <span class="o">^^^^^^^^^^^^^^^</span>
</pre></div>

<p>But the new parsetree node only contains the location of the type
<code>int</code> and not the location of the end of the parentheses. We
are thus losing a bit of information because the former encoding was
using a concrete syntax tree location that we no longer have access to.
Fortunately, this only happens on a ghost location of a ghost parsetree
node.</p>
<h4>Is
the migration from the 5.1 parsetree to the 5.0 parsetree always
injective?</h4>
<p>Most of the time, it is possible to map an OCaml 5.1 value binding
onto an unique OCaml 5.0 encoded value binding. This works because the
encoding used for value bindings in 5.0 constructs type expressions of
the form <code>&oslash;. typ</code> that are not allowed in OCaml. We can thus
use those special type expressions to recognise desugared value
bindings.</p>
<p>Unfortunately, this is only the case when binding variables. Indeed,
as soon as the pattern in the value binding is not a variable</p>
<div class="highlight"><pre><span></span><span class="k">let</span> <span class="o">(</span><span class="n">x</span><span class="o">,</span><span class="n">y</span><span class="o">)</span> <span class="o">:</span> <span class="kt">int</span> <span class="o">*</span> <span class="kt">int</span> <span class="o">=</span> <span class="mi">0</span><span class="o">,</span> <span class="mi">1</span>
</pre></div>

<p>the 5.0 parser desugars this value binding to</p>
<div class="highlight"><pre><span></span><span class="k">let</span> <span class="o">((</span><span class="n">x</span><span class="o">,</span><span class="n">y</span><span class="o">)</span> <span class="o">:</span> <span class="kt">int</span> <span class="o">*</span> <span class="kt">int</span><span class="o">)</span> <span class="o">=</span> <span class="mi">0</span><span class="o">,</span> <span class="mi">1</span>
</pre></div>

<p>without any encoding of the type constraint. This means in particular
that the 5.0 parser creates the same AST node for both</p>
<div class="highlight"><pre><span></span><span class="k">let</span> <span class="o">((</span><span class="n">x</span><span class="o">,</span><span class="n">y</span><span class="o">)</span> <span class="o">:</span> <span class="kt">int</span> <span class="o">*</span> <span class="kt">int</span><span class="o">)</span> <span class="o">=</span> <span class="mi">0</span><span class="o">,</span> <span class="mi">1</span>
</pre></div>

<p>and</p>
<div class="highlight"><pre><span></span><span class="k">let</span> <span class="o">(</span><span class="n">x</span><span class="o">,</span><span class="n">y</span><span class="o">)</span> <span class="o">:</span> <span class="kt">int</span> <span class="o">*</span> <span class="kt">int</span> <span class="o">=</span> <span class="mi">0</span><span class="o">,</span> <span class="mi">1</span>
</pre></div>

<p>which are two different constructs in OCaml 5.1.</p>
<p>Consequently, when we migrate a 5.0 parsetree of this form to the
5.1, we have to decide if we should migrate this syntactic construct to
the old parsetree node or to the new node. In this case, since the new
syntactic node corresponds to a &ldquo;more pleasant&rdquo; syntactic form, we
decided to favour this form.</p>


