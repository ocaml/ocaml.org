---
title: Florian's OCaml compiler weekly, 24 April 2023
description:
url: http://cambium.inria.fr/blog/florian-compiler-weekly-2023-04-24
date: 2023-04-24T08:00:00-00:00
preview_image:
featured:
authors:
- gallium
---



  <p>This series of blog post aims to give a short weekly glimpse into my
(Florian Angeletti) daily work on the OCaml compiler. This week, the
focus is on two interesting bugs in the first alpha release of OCaml
5.1.0.</p>


  

<p>With the release of the first alpha for OCaml 5.1.0, I have shifted a
part of my time towards updating core tools like <a href="https://github.com/ocaml/odoc/pull/956">odoc</a> for OCaml 5.1 and
hunting bugs in the new release.</p>
<p>Last Monday, working with Kate Deplaix, we found two interesting bugs
by looking at <a href="http://check.ocamllabs.io">the opam-health-check
reports</a>.</p>
<ul>
<li>A bug in the new parsetree node for value bindings</li>
<li>A potentially painful change of behavior for explicitly polymorphic
with open polymorphic variant types.</li>
</ul>
<h3>Coercion on value
definitions</h3>
<p>The first bug stems from a rare construct in the OCaml language:
coercion in value definition:</p>
<div class="highlight"><pre><span></span>  <span class="k">let</span> <span class="n">x</span> <span class="o">:&gt;</span> <span class="o">&lt;</span> <span class="n">x</span> <span class="o">:</span> <span class="kt">int</span> <span class="o">&gt;</span> <span class="o">=</span> <span class="k">object</span>
    <span class="k">method</span> <span class="n">m</span> <span class="o">=</span> <span class="mi">0</span>
    <span class="k">method</span> <span class="n">n</span> <span class="o">=</span> <span class="mi">1</span>
  <span class="k">end</span>
</pre></div>

<p>Here, we are coercing the body of the value definition to the type
<code>&lt;x:int&gt;</code> masking the method <code>m</code>. This
syntax is a bit surprising we have an explicit coercion which is an
expression which is applied on the pattern side of the definition.</p>
<p>Before OCaml 5.1, such constructions were desugared in the parser
itself to:</p>
<div class="highlight"><pre><span></span>  <span class="k">let</span> <span class="o">(</span><span class="n">x</span> <span class="o">:</span> <span class="o">&lt;</span> <span class="n">x</span> <span class="o">:</span> <span class="kt">int</span> <span class="o">&gt;)</span> <span class="o">=</span> <span class="o">(</span><span class="k">object</span>
    <span class="k">method</span> <span class="n">m</span> <span class="o">=</span> <span class="mi">0</span>
    <span class="k">method</span> <span class="n">n</span> <span class="o">=</span> <span class="mi">1</span>
        <span class="k">end</span><span class="o">:&gt;</span> <span class="o">&lt;</span><span class="n">x</span><span class="o">:</span><span class="kt">int</span><span class="o">&gt;</span>
  <span class="o">)</span>
</pre></div>

<p>When I updated the abstract syntax tree to avoid desugaring value
bindings of the form</p>
<div class="highlight"><pre><span></span>let pat: typ = exp
</pre></div>

<p>in the parsetree, I forgot this case which means that the AST dropped
the coercion part of the annotation.</p>
<p>This mistake ought to be fixed but it leads to an interesting
question on how to represent constraints on value bindings. Should we be
generic and represent the constraints as:</p>
<div class="highlight"><pre><span></span><span class="n">type</span><span class="w"> </span><span class="n">value_constraint</span><span class="w"> </span><span class="o">=</span><span class="w"> </span><span class="p">{</span><span class="w"></span>
<span class="w">  </span><span class="n">locally_abstract_types</span><span class="p">:</span><span class="w"> </span><span class="n">string</span><span class="w"> </span><span class="n">loc</span><span class="w"> </span><span class="n">list</span><span class="p">;</span><span class="w"> </span><span class="p">(</span><span class="o">*</span><span class="w"> </span><span class="n">type</span><span class="w"> </span><span class="n">a</span><span class="w"> </span><span class="n">b</span><span class="w"> </span><span class="n">c</span><span class="w"> </span><span class="o">.</span><span class="w"> </span><span class="o">...</span><span class="w"> </span><span class="o">*</span><span class="p">);</span><span class="w"></span>
<span class="w">  </span><span class="n">typ</span><span class="p">:</span><span class="w"> </span><span class="n">type_expr</span><span class="w"> </span><span class="n">option</span><span class="w"> </span><span class="p">(</span><span class="o">*</span><span class="w"> </span><span class="o">...</span><span class="w"> </span><span class="p">:</span><span class="w"> </span><span class="n">typ</span><span class="err">?</span><span class="w"> </span><span class="o">...*</span><span class="w"> </span><span class="p">);</span><span class="w"></span>
<span class="w">  </span><span class="n">coercion</span><span class="p">:</span><span class="w"> </span><span class="n">type_expr</span><span class="w"> </span><span class="n">option</span><span class="w"> </span><span class="p">(</span><span class="o">*</span><span class="w"> </span><span class="o">...</span><span class="w">  </span><span class="p">:</span><span class="o">&gt;</span><span class="w"> </span><span class="n">typ</span><span class="err">?</span><span class="w"> </span><span class="o">*</span><span class="p">)</span><span class="w"></span>
<span class="p">}</span><span class="w"></span>
</pre></div>

<p>However, with this representation, we cover two possible new cases
that could be written in fantasy syntax as</p>
<div class="highlight"><pre><span></span>type a b c. typ :&gt; coercion
</pre></div>

<p>and</p>
<div class="highlight"><pre><span></span>type a b c. :&gt; coercion
</pre></div>

<p>More problematically, this product type allows for constraints
without any real constraints</p>
<div class="highlight"><pre><span></span>type a b c.
</pre></div>

<p>Thus the generic product feels a tad too wide.</p>
<p>Another option is to tailor a type closer to the currently supported
syntax with</p>
<div class="highlight"><pre><span></span><span class="k">type</span> <span class="n">value_constraint</span> <span class="o">=</span>
  <span class="o">|</span> <span class="nc">Constraint</span> <span class="k">of</span> <span class="o">{</span>
      <span class="n">locally_abstract_types</span><span class="o">:</span> <span class="kt">string</span> <span class="n">loc</span> <span class="kt">list</span><span class="o">;</span> <span class="c">(* type a b c . ... *)</span><span class="o">;</span>
      <span class="n">typ</span><span class="o">:</span> <span class="n">type_expr</span> <span class="c">(* ...: typ *)</span>
    <span class="o">}</span>
  <span class="o">|</span> <span class="nc">Coercion</span> <span class="k">of</span> <span class="o">{</span>
      <span class="n">ground</span> <span class="n">type_expr</span> <span class="n">option</span> <span class="c">(* typ? ...* );</span>
<span class="c">      coercion: type_expr  (* ...  :&gt; typ *)</span>
<span class="c">    }</span>
</pre></div>

<p>This representation has the disadvantage of losing part of the
similarity between the <code>Coercion</code> and <code>constraint</code>
case but it covers exactly the constructs allowed in the syntax.</p>
<p>This my <a href="https://github.com/ocaml/ocaml/pull/12191">current
bug fix proposal</a> for OCaml 5.1.0 .</p>
<h3>Polymorphic
variants and explicit universal quantification</h3>
<p>Another interesting difference of behavior between OCaml 5.1.0 and
5.0.0 appears when writing code that mix both open polymorphic variant
types and explicit polymorphic annotation:</p>
<div class="highlight"><pre><span></span><span class="k">let</span> <span class="n">f</span> <span class="o">:</span> <span class="k">'</span><span class="n">a</span><span class="o">.</span> <span class="o">[&gt;</span> <span class="o">`</span><span class="nc">X</span> <span class="k">of</span> <span class="k">'</span><span class="n">a</span> <span class="o">]</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">a</span> <span class="o">=</span> <span class="k">function</span> <span class="o">(`</span><span class="nc">X</span> <span class="n">x</span><span class="o">)</span> <span class="o">-&gt;</span> <span class="n">x</span> <span class="o">|</span> <span class="o">_</span> <span class="o">-&gt;</span> <span class="k">assert</span> <span class="bp">false</span>
</pre></div>

<p>This code compiled in OCaml 5.0.0, but fails in OCaml 5.1.0 with</p>
<div class="highlight"><pre><span></span><span class="n">Error</span><span class="o">:</span><span class="w"> </span><span class="n">This</span><span class="w"> </span><span class="n">pattern</span><span class="w"> </span><span class="n">matches</span><span class="w"> </span><span class="n">values</span><span class="w"> </span><span class="n">of</span><span class="w"> </span><span class="n">type</span><span class="w"> </span><span class="o">[?</span><span class="w"> </span><span class="err">`</span><span class="n">X</span><span class="w"> </span><span class="n">of</span><span class="w"> </span><span class="s1">'b ]</span>
<span class="s1">      but a pattern was expected which matches values of type [&gt; `X of '</span><span class="n">a</span><span class="w"> </span><span class="o">]</span><span class="w"></span>
<span class="w">      </span><span class="n">The</span><span class="w"> </span><span class="n">universal</span><span class="w"> </span><span class="n">variable</span><span class="w"> </span><span class="err">'</span><span class="n">a</span><span class="w"> </span><span class="n">would</span><span class="w"> </span><span class="nf">escape</span><span class="w"> </span><span class="n">its</span><span class="w"> </span><span class="n">scope</span><span class="w"></span>
</pre></div>

<p>because the universal variable <code>'a</code> might escape through
the global row variable hidden in <code>[&gt; X of _ ]</code>.</p>
<p>The issue can be fixed by making sure that the row variable is also
bound by the explicit universal quantification:</p>
<div class="highlight"><pre><span></span><span class="k">let</span> <span class="n">f</span> <span class="o">:</span> <span class="k">'</span><span class="n">a</span> <span class="k">'</span><span class="n">r</span><span class="o">.</span> <span class="o">(</span> <span class="o">[&gt;</span> <span class="o">`</span><span class="nc">X</span> <span class="k">of</span> <span class="k">'</span><span class="n">a</span> <span class="o">]</span> <span class="k">as</span> <span class="k">'</span><span class="n">r</span> <span class="o">)</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">a</span> <span class="o">=</span> <span class="k">function</span> <span class="o">(`</span><span class="nc">X</span> <span class="n">x</span><span class="o">)</span> <span class="o">-&gt;</span> <span class="n">x</span> <span class="o">|</span> <span class="o">_</span> <span class="o">-&gt;</span> <span class="k">assert</span> <span class="bp">false</span>
</pre></div>

<p>Not only this fix is not that obvious, but it is not compatible with
the short syntax for universal-outside and locally abstract-inside type
variables. For instance, if we start with</p>
<div class="highlight"><pre><span></span><span class="k">type</span> <span class="k">'</span><span class="n">a</span> <span class="n">w</span> <span class="o">=</span> <span class="nc">Int</span><span class="o">:</span> <span class="kt">int</span> <span class="n">w</span>
<span class="k">let</span> <span class="n">f</span> <span class="o">:</span> <span class="k">type</span> <span class="n">a</span><span class="o">.</span> <span class="n">a</span> <span class="n">w</span> <span class="o">-&gt;</span> <span class="o">[&gt;</span> <span class="o">`</span><span class="nc">X</span> <span class="k">of</span> <span class="n">a</span> <span class="o">]</span> <span class="o">-&gt;</span> <span class="n">a</span> <span class="o">=</span> <span class="k">fun</span> <span class="nc">Int</span> <span class="o">-&gt;</span> <span class="k">function</span> <span class="o">(`</span><span class="nc">X</span> <span class="n">x</span><span class="o">)</span> <span class="o">-&gt;</span> <span class="n">x</span> <span class="o">|</span> <span class="o">_</span> <span class="o">-&gt;</span> <span class="mi">0</span>
</pre></div>

<p>adding a local type <code>r</code> doesn&rsquo;t help</p>
<div class="highlight"><pre><span></span><span class="kr">type</span><span class="w"> </span><span class="p">(</span><span class="s">'a,'</span><span class="n">r</span><span class="p">)</span><span class="w"> </span><span class="n">c</span><span class="w"> </span><span class="o">=</span><span class="w"> </span><span class="p">[</span><span class="o">&gt;</span><span class="w"> </span><span class="err">`</span><span class="n">X</span><span class="w"> </span><span class="kr">of</span><span class="w">  </span><span class="s">'a ] as '</span><span class="n">r</span><span class="w"></span>
<span class="n">let</span><span class="w"> </span><span class="n">f</span><span class="w"> </span><span class="o">:</span><span class="w"> </span><span class="kr">type</span><span class="w"> </span><span class="n">a</span><span class="w"> </span><span class="n">r</span><span class="p">.</span><span class="w"> </span><span class="n">a</span><span class="w"> </span><span class="n">w</span><span class="w"> </span><span class="o">-&gt;</span><span class="w"> </span><span class="p">(</span><span class="n">a</span><span class="p">,</span><span class="n">r</span><span class="p">)</span><span class="w"> </span><span class="n">c</span><span class="w"> </span><span class="o">-&gt;</span><span class="w"> </span><span class="n">a</span><span class="w"> </span><span class="o">=</span><span class="w"> </span><span class="n">fun</span><span class="w"> </span><span class="n">Int</span><span class="w"> </span><span class="o">-&gt;</span><span class="w"> </span><span class="kr">function</span><span class="w"> </span><span class="p">(</span><span class="err">`</span><span class="n">X</span><span class="w"> </span><span class="n">x</span><span class="p">)</span><span class="w"> </span><span class="o">-&gt;</span><span class="w"> </span><span class="n">x</span><span class="w"> </span><span class="o">|</span><span class="w"> </span><span class="n">_</span><span class="w"> </span><span class="o">-&gt;</span><span class="w"> </span><span class="mi">0</span><span class="w"></span>
</pre></div>

<div class="highlight"><pre><span></span><span class="n">Error</span><span class="o">:</span><span class="w"> </span><span class="n">This</span><span class="w"> </span><span class="n">type</span><span class="w"> </span><span class="n">r</span><span class="w"> </span><span class="n">should</span><span class="w"> </span><span class="n">be</span><span class="w"> </span><span class="n">an</span><span class="w"> </span><span class="n">instance</span><span class="w"> </span><span class="n">of</span><span class="w"> </span><span class="n">type</span><span class="w"> </span><span class="o">[&gt;</span><span class="w"> </span><span class="err">`</span><span class="n">X</span><span class="w"> </span><span class="n">of</span><span class="w"> </span><span class="n">a</span><span class="w"> </span><span class="o">]</span><span class="w"></span>
</pre></div>

<p>because we would need a constrained abstract type.</p>
<p>Thus, we are left with no other options than desugaring the short
hand to:</p>
<div class="highlight"><pre><span></span><span class="k">let</span> <span class="n">f</span><span class="o">:</span> <span class="k">'</span><span class="n">a</span> <span class="k">'</span><span class="n">r</span><span class="o">.</span> <span class="k">'</span><span class="n">a</span> <span class="n">w</span> <span class="o">-&gt;</span> <span class="o">(</span> <span class="o">[&gt;</span> <span class="o">`</span><span class="nc">X</span> <span class="k">of</span> <span class="k">'</span><span class="n">a</span> <span class="o">]</span> <span class="k">as</span> <span class="k">'</span><span class="n">r</span> <span class="o">)</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">a</span> <span class="o">=</span> <span class="k">fun</span> <span class="o">(</span><span class="k">type</span> <span class="n">a</span><span class="o">):</span> <span class="o">(</span><span class="n">a</span> <span class="n">w</span> <span class="o">-&gt;</span> <span class="o">[&gt;</span> <span class="o">`</span><span class="nc">X</span> <span class="k">of</span> <span class="n">a</span> <span class="o">]</span> <span class="o">-&gt;</span> <span class="n">a</span><span class="o">)</span> <span class="o">-&gt;</span> <span class="k">fun</span> <span class="nc">Int</span> <span class="o">-&gt;</span>
<span class="k">function</span> <span class="o">(`</span><span class="nc">X</span> <span class="n">a</span><span class="o">)</span> <span class="o">-&gt;</span> <span class="n">a</span> <span class="o">|</span> <span class="o">_</span> <span class="o">-&gt;</span> <span class="mi">0</span>
</pre></div>

<p>which is a bit of mouthful compared to our starting point.</p>
<p>Thus, I have been investigating with Gabriel Scherer a possibility to
keep the previous definition working</p>
<div class="highlight"><pre><span></span><span class="n">let</span><span class="w"> </span><span class="n">f</span><span class="o">:</span><span class="w"> </span><span class="s">'a. [&gt; `X of '</span><span class="n">a</span><span class="w"> </span><span class="p">]</span><span class="w"> </span><span class="o">-&gt;</span><span class="w"> </span><span class="s">'a = function (`X x) -&gt; x | _ -&gt; assert false</span>
</pre></div>

<p>by making the assumption that any row variables that are unnamed in
an explicit type annotation under an explicit universal quantification
should be bound by the binder. In other words, we could consider that
whenever an user write</p>
<div class="highlight"><pre><span></span><span class="n">let</span><span class="w"> </span><span class="n">f</span><span class="o">:</span><span class="w"> </span><span class="s">'a. [&gt; `X of '</span><span class="n">a</span><span class="w"> </span><span class="p">]</span><span class="w"> </span><span class="o">-&gt;</span><span class="w"> </span><span class="s">'a = function (`X x) -&gt; x | _ -&gt; assert false</span>
</pre></div>

<p>they meant to write</p>
<div class="highlight"><pre><span></span><span class="n">let</span><span class="w"> </span><span class="n">f</span><span class="o">:</span><span class="w"> </span><span class="s">'a '</span><span class="n">r</span><span class="p">.</span><span class="w"> </span><span class="p">([</span><span class="o">&gt;</span><span class="w"> </span><span class="err">`</span><span class="n">X</span><span class="w"> </span><span class="kr">of</span><span class="w"> </span><span class="s">'a ] as '</span><span class="n">r</span><span class="p">)</span><span class="w"> </span><span class="o">-&gt;</span><span class="w"> </span><span class="s">'a = function (`X x) -&gt; x | _ -&gt; assert false</span>
</pre></div>

<p>and thus the typechecker ought to add implicitly the row variable
<code>'r'</code> to the list of bound variables in the left-hand side of
<code>.</code>.</p>


