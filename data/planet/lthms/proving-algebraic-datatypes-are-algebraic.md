---
title: "Proving Algebraic Datatypes are \u201CAlgebraic\u201D"
description: "The set of types which can be defined in a language together with +++
  and \u2217*\u2217 form an \u201Calgebraic structure\u201D in the mathematical sense,
  hence the name. It means the definitions of +++ and \u2217*\u2217 have to satisfy
  properties such as commutativity or the existence of neutral elements. In this article,
  we prove the sum and prod Coq types satisfy these properties."
url: https://soap.coffee/~lthms/posts/AlgebraicDatatypes.html
date: 2020-07-12T00:00:00-00:00
preview_image: https://soap.coffee/~lthms/img/thinking.png
authors:
- "Thomas Letan\u2019s Blog"
source:
---


        
        <h1>Proving Algebraic Datatypes are “Algebraic”</h1><div><span class="icon"><svg><use href="/~lthms/img/icons.svg#tag"></use></svg></span>&nbsp;<a href="https://soap.coffee/~lthms/tags/coq.html" marked="" class="tag">coq</a> </div>
<p>Several programming languages allow programmers to define (potentially
recursive) custom types, by composing together existing ones. For instance, in
OCaml, one can define lists as follows:</p>
<pre><code class="hljs language-ocaml"><span class="hljs-keyword">type</span> <span class="hljs-symbol">'a</span> <span class="hljs-built_in">list</span> =
| <span class="hljs-type">Cons</span> <span class="hljs-keyword">of</span> <span class="hljs-symbol">'a</span> * <span class="hljs-symbol">'a</span> <span class="hljs-built_in">list</span>
| <span class="hljs-type">Nil</span>
</code></pre>
<p>This translates in Haskell as</p>
<pre><code class="hljs language-haskell"><span class="hljs-class"><span class="hljs-keyword">data</span> <span class="hljs-type">List</span> a =</span>
  <span class="hljs-type">Cons</span> a (<span class="hljs-type">List</span> a)
| <span class="hljs-type">Nil</span>
</code></pre>
<p>In Rust as</p>
<pre><code class="hljs language-rust"><span class="hljs-keyword">enum</span> <span class="hljs-title class_">List</span>&lt;A&gt; {
  <span class="hljs-title function_ invoke__">Cons</span>(A, <span class="hljs-type">Box</span>&lt;List&lt;a&gt;&gt;),
  Nil,
}
</code></pre>
<p>Or in Coq as</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Inductive</span> list a :=
| <span class="hljs-type">cons</span> : a -&gt; list a -&gt; list a
| <span class="hljs-type">nil</span>
</code></pre>
<p>And so forth.</p>
<p>Each language will have its own specific constructions, and the type systems
of OCaml, Haskell, Rust and Coq —to only cite them— are far from being
equivalent. That being said, they often share a common “base formalism,”
usually (and sometimes abusively) referred to as <em>algebraic datatypes</em>. This
expression is used because under the hood any datatype can be encoded as a
composition of types using two operators: sum (<span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mo>+</mo></mrow><annotation encoding="application/x-tex">+</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6667em;vertical-align:-0.0833em;"></span><span class="mord">+</span></span></span></span>) and product (<span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mo>∗</mo></mrow><annotation encoding="application/x-tex">*</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.4653em;"></span><span class="mord">∗</span></span></span></span>) for
types.</p>
<ul>
<li><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>a</mi><mo>+</mo><mi>b</mi></mrow><annotation encoding="application/x-tex">a + b</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6667em;vertical-align:-0.0833em;"></span><span class="mord mathnormal">a</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">+</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:0.6944em;"></span><span class="mord mathnormal">b</span></span></span></span> is the disjoint union of types <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>a</mi></mrow><annotation encoding="application/x-tex">a</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.4306em;"></span><span class="mord mathnormal">a</span></span></span></span> and <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>b</mi></mrow><annotation encoding="application/x-tex">b</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6944em;"></span><span class="mord mathnormal">b</span></span></span></span>. Any term of <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>a</mi></mrow><annotation encoding="application/x-tex">a</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.4306em;"></span><span class="mord mathnormal">a</span></span></span></span>
can be injected into <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>a</mi><mo>+</mo><mi>b</mi></mrow><annotation encoding="application/x-tex">a + b</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6667em;vertical-align:-0.0833em;"></span><span class="mord mathnormal">a</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">+</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:0.6944em;"></span><span class="mord mathnormal">b</span></span></span></span>, and the same goes for <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>b</mi></mrow><annotation encoding="application/x-tex">b</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6944em;"></span><span class="mord mathnormal">b</span></span></span></span>. Conversely,
a term of <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>a</mi><mo>+</mo><mi>b</mi></mrow><annotation encoding="application/x-tex">a + b</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6667em;vertical-align:-0.0833em;"></span><span class="mord mathnormal">a</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">+</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:0.6944em;"></span><span class="mord mathnormal">b</span></span></span></span> can be projected into either <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>a</mi></mrow><annotation encoding="application/x-tex">a</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.4306em;"></span><span class="mord mathnormal">a</span></span></span></span> or <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>b</mi></mrow><annotation encoding="application/x-tex">b</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6944em;"></span><span class="mord mathnormal">b</span></span></span></span>.</li>
<li><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>a</mi><mo>∗</mo><mi>b</mi></mrow><annotation encoding="application/x-tex">a * b</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.4653em;"></span><span class="mord mathnormal">a</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">∗</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:0.6944em;"></span><span class="mord mathnormal">b</span></span></span></span> is the Cartesian product of types <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>a</mi></mrow><annotation encoding="application/x-tex">a</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.4306em;"></span><span class="mord mathnormal">a</span></span></span></span> and <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>b</mi></mrow><annotation encoding="application/x-tex">b</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6944em;"></span><span class="mord mathnormal">b</span></span></span></span>. Any term of <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>a</mi><mo>∗</mo><mi>b</mi></mrow><annotation encoding="application/x-tex">a *
b</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.4653em;"></span><span class="mord mathnormal">a</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">∗</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:0.6944em;"></span><span class="mord mathnormal">b</span></span></span></span> is made of one term of <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>a</mi></mrow><annotation encoding="application/x-tex">a</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.4306em;"></span><span class="mord mathnormal">a</span></span></span></span> and one term of <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>b</mi></mrow><annotation encoding="application/x-tex">b</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6944em;"></span><span class="mord mathnormal">b</span></span></span></span> (think tuples).</li>
</ul>
<p>For an algebraic datatype, one constructor allows for defining “named
tuples,” that is ad hoc product types. Besides, constructors are mutually
exclusive: you cannot define the same term using two different constructors.
Therefore, a datatype with several constructors is reminiscent of a disjoint
union.  Coming back to the <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi mathvariant="normal">l</mi><mi mathvariant="normal">i</mi><mi mathvariant="normal">s</mi><mi mathvariant="normal">t</mi></mrow><annotation encoding="application/x-tex">\mathrm{list}</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6944em;"></span><span class="mord"><span class="mord mathrm">list</span></span></span></span></span> type, under the syntactic sugar of
algebraic datatypes, we can define it as</p>
<p class="katex-block"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><msub><mrow><mi mathvariant="normal">l</mi><mi mathvariant="normal">i</mi><mi mathvariant="normal">s</mi><mi mathvariant="normal">t</mi></mrow><mi>α</mi></msub><mo>≡</mo><mrow><mi mathvariant="normal">u</mi><mi mathvariant="normal">n</mi><mi mathvariant="normal">i</mi><mi mathvariant="normal">t</mi></mrow><mo>+</mo><mi>α</mi><mo>∗</mo><msub><mrow><mi mathvariant="normal">l</mi><mi mathvariant="normal">i</mi><mi mathvariant="normal">s</mi><mi mathvariant="normal">t</mi></mrow><mi>α</mi></msub></mrow><annotation encoding="application/x-tex">\mathrm{list}_\alpha \equiv \mathrm{unit} + \alpha * \mathrm{list}_\alpha
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.8444em;vertical-align:-0.15em;"></span><span class="mord"><span class="mord"><span class="mord mathrm">list</span></span><span class="msupsub"><span class="vlist-t vlist-t2"><span class="vlist-r"><span class="vlist" style="height:0.1514em;"><span style="top:-2.55em;margin-right:0.05em;"><span class="pstrut" style="height:2.7em;"></span><span class="sizing reset-size6 size3 mtight"><span class="mord mathnormal mtight" style="margin-right:0.0037em;">α</span></span></span></span><span class="vlist-s">​</span></span><span class="vlist-r"><span class="vlist" style="height:0.15em;"><span></span></span></span></span></span></span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">≡</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.7512em;vertical-align:-0.0833em;"></span><span class="mord"><span class="mord mathrm">unit</span></span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">+</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:0.4653em;"></span><span class="mord mathnormal" style="margin-right:0.0037em;">α</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">∗</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:0.8444em;vertical-align:-0.15em;"></span><span class="mord"><span class="mord"><span class="mord mathrm">list</span></span><span class="msupsub"><span class="vlist-t vlist-t2"><span class="vlist-r"><span class="vlist" style="height:0.1514em;"><span style="top:-2.55em;margin-right:0.05em;"><span class="pstrut" style="height:2.7em;"></span><span class="sizing reset-size6 size3 mtight"><span class="mord mathnormal mtight" style="margin-right:0.0037em;">α</span></span></span></span><span class="vlist-s">​</span></span><span class="vlist-r"><span class="vlist" style="height:0.15em;"><span></span></span></span></span></span></span></span></span></span></span></p>
<p>where <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi mathvariant="normal">u</mi><mi mathvariant="normal">n</mi><mi mathvariant="normal">i</mi><mi mathvariant="normal">t</mi></mrow><annotation encoding="application/x-tex">\mathrm{unit}</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6679em;"></span><span class="mord"><span class="mord mathrm">unit</span></span></span></span></span> models the <code class="hljs language-coq">nil</code> case, and <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>α</mi><mo>∗</mo><msub><mrow><mi mathvariant="normal">l</mi><mi mathvariant="normal">i</mi><mi mathvariant="normal">s</mi><mi mathvariant="normal">t</mi></mrow><mi>α</mi></msub></mrow><annotation encoding="application/x-tex">α * \mathrm{list}_\alpha</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.4653em;"></span><span class="mord mathnormal" style="margin-right:0.0037em;">α</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">∗</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:0.8444em;vertical-align:-0.15em;"></span><span class="mord"><span class="mord"><span class="mord mathrm">list</span></span><span class="msupsub"><span class="vlist-t vlist-t2"><span class="vlist-r"><span class="vlist" style="height:0.1514em;"><span style="top:-2.55em;margin-right:0.05em;"><span class="pstrut" style="height:2.7em;"></span><span class="sizing reset-size6 size3 mtight"><span class="mord mathnormal mtight" style="margin-right:0.0037em;">α</span></span></span></span><span class="vlist-s">​</span></span><span class="vlist-r"><span class="vlist" style="height:0.15em;"><span></span></span></span></span></span></span></span></span></span>
models the <code class="hljs language-coq">cons</code> case.</p>
<p>The set of types which can be defined in a language together with <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mo>+</mo></mrow><annotation encoding="application/x-tex">+</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6667em;vertical-align:-0.0833em;"></span><span class="mord">+</span></span></span></span> and
<span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mo>∗</mo></mrow><annotation encoding="application/x-tex">*</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.4653em;"></span><span class="mord">∗</span></span></span></span> form an “algebraic structure” in the mathematical sense, hence the
name. It means the definitions of <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mo>+</mo></mrow><annotation encoding="application/x-tex">+</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6667em;vertical-align:-0.0833em;"></span><span class="mord">+</span></span></span></span> and <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mo>∗</mo></mrow><annotation encoding="application/x-tex">*</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.4653em;"></span><span class="mord">∗</span></span></span></span> have to satisfy properties
such as commutativity or the existence of neutral elements. In this article,
we will prove some of them in Coq. More precisely,</p>
<ul>
<li><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mo>+</mo></mrow><annotation encoding="application/x-tex">+</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6667em;vertical-align:-0.0833em;"></span><span class="mord">+</span></span></span></span> is commutative, that is <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi mathvariant="normal">∀</mi><mo stretchy="false">(</mo><mi>x</mi><mo separator="true">,</mo><mi>y</mi><mo stretchy="false">)</mo><mo separator="true">,</mo><mtext>&nbsp;</mtext><mi>x</mi><mo>+</mo><mi>y</mi><mo>=</mo><mi>y</mi><mo>+</mo><mi>x</mi></mrow><annotation encoding="application/x-tex">\forall (x, y),\ x + y = y + x</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mord">∀</span><span class="mopen">(</span><span class="mord mathnormal">x</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord mathnormal" style="margin-right:0.03588em;">y</span><span class="mclose">)</span><span class="mpunct">,</span><span class="mspace">&nbsp;</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord mathnormal">x</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">+</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:0.625em;vertical-align:-0.1944em;"></span><span class="mord mathnormal" style="margin-right:0.03588em;">y</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.7778em;vertical-align:-0.1944em;"></span><span class="mord mathnormal" style="margin-right:0.03588em;">y</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">+</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:0.4306em;"></span><span class="mord mathnormal">x</span></span></span></span></li>
<li><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mo>+</mo></mrow><annotation encoding="application/x-tex">+</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6667em;vertical-align:-0.0833em;"></span><span class="mord">+</span></span></span></span> is associative, that is <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi mathvariant="normal">∀</mi><mo stretchy="false">(</mo><mi>x</mi><mo separator="true">,</mo><mi>y</mi><mo separator="true">,</mo><mi>z</mi><mo stretchy="false">)</mo><mo separator="true">,</mo><mtext>&nbsp;</mtext><mo stretchy="false">(</mo><mi>x</mi><mo>+</mo><mi>y</mi><mo stretchy="false">)</mo><mo>+</mo><mi>z</mi><mo>=</mo><mi>x</mi><mo>+</mo><mo stretchy="false">(</mo><mi>y</mi><mo>+</mo><mi>z</mi><mo stretchy="false">)</mo></mrow><annotation encoding="application/x-tex">\forall (x, y, z),\ (x + y) + z = x + (y + z)</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mord">∀</span><span class="mopen">(</span><span class="mord mathnormal">x</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord mathnormal" style="margin-right:0.03588em;">y</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord mathnormal" style="margin-right:0.04398em;">z</span><span class="mclose">)</span><span class="mpunct">,</span><span class="mspace">&nbsp;</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mopen">(</span><span class="mord mathnormal">x</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">+</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mord mathnormal" style="margin-right:0.03588em;">y</span><span class="mclose">)</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">+</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:0.4306em;"></span><span class="mord mathnormal" style="margin-right:0.04398em;">z</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.6667em;vertical-align:-0.0833em;"></span><span class="mord mathnormal">x</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">+</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mopen">(</span><span class="mord mathnormal" style="margin-right:0.03588em;">y</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">+</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mord mathnormal" style="margin-right:0.04398em;">z</span><span class="mclose">)</span></span></span></span></li>
<li><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mo>+</mo></mrow><annotation encoding="application/x-tex">+</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6667em;vertical-align:-0.0833em;"></span><span class="mord">+</span></span></span></span> has a neutral element, that is <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi mathvariant="normal">∃</mi><msub><mi>e</mi><mi>s</mi></msub><mo separator="true">,</mo><mtext>&nbsp;</mtext><mi mathvariant="normal">∀</mi><mi>x</mi><mo separator="true">,</mo><mtext>&nbsp;</mtext><mi>x</mi><mo>+</mo><msub><mi>e</mi><mi>s</mi></msub><mo>=</mo><mi>x</mi></mrow><annotation encoding="application/x-tex">\exists e_s,\ \forall x,\ x + e_s = x</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.8889em;vertical-align:-0.1944em;"></span><span class="mord">∃</span><span class="mord"><span class="mord mathnormal">e</span><span class="msupsub"><span class="vlist-t vlist-t2"><span class="vlist-r"><span class="vlist" style="height:0.1514em;"><span style="top:-2.55em;margin-left:0em;margin-right:0.05em;"><span class="pstrut" style="height:2.7em;"></span><span class="sizing reset-size6 size3 mtight"><span class="mord mathnormal mtight">s</span></span></span></span><span class="vlist-s">​</span></span><span class="vlist-r"><span class="vlist" style="height:0.15em;"><span></span></span></span></span></span></span><span class="mpunct">,</span><span class="mspace">&nbsp;</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord">∀</span><span class="mord mathnormal">x</span><span class="mpunct">,</span><span class="mspace">&nbsp;</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord mathnormal">x</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">+</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:0.5806em;vertical-align:-0.15em;"></span><span class="mord"><span class="mord mathnormal">e</span><span class="msupsub"><span class="vlist-t vlist-t2"><span class="vlist-r"><span class="vlist" style="height:0.1514em;"><span style="top:-2.55em;margin-left:0em;margin-right:0.05em;"><span class="pstrut" style="height:2.7em;"></span><span class="sizing reset-size6 size3 mtight"><span class="mord mathnormal mtight">s</span></span></span></span><span class="vlist-s">​</span></span><span class="vlist-r"><span class="vlist" style="height:0.15em;"><span></span></span></span></span></span></span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.4306em;"></span><span class="mord mathnormal">x</span></span></span></span></li>
<li><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mo>∗</mo></mrow><annotation encoding="application/x-tex">*</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.4653em;"></span><span class="mord">∗</span></span></span></span> is commutative, that is <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi mathvariant="normal">∀</mi><mo stretchy="false">(</mo><mi>x</mi><mo separator="true">,</mo><mi>y</mi><mo stretchy="false">)</mo><mo separator="true">,</mo><mtext>&nbsp;</mtext><mi>x</mi><mo>∗</mo><mi>y</mi><mo>=</mo><mi>y</mi><mo>∗</mo><mi>x</mi></mrow><annotation encoding="application/x-tex">\forall (x, y),\ x * y = y * x</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mord">∀</span><span class="mopen">(</span><span class="mord mathnormal">x</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord mathnormal" style="margin-right:0.03588em;">y</span><span class="mclose">)</span><span class="mpunct">,</span><span class="mspace">&nbsp;</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord mathnormal">x</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">∗</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:0.625em;vertical-align:-0.1944em;"></span><span class="mord mathnormal" style="margin-right:0.03588em;">y</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.6597em;vertical-align:-0.1944em;"></span><span class="mord mathnormal" style="margin-right:0.03588em;">y</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">∗</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:0.4306em;"></span><span class="mord mathnormal">x</span></span></span></span></li>
<li><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mo>∗</mo></mrow><annotation encoding="application/x-tex">*</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.4653em;"></span><span class="mord">∗</span></span></span></span> is associative, that is <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi mathvariant="normal">∀</mi><mo stretchy="false">(</mo><mi>x</mi><mo separator="true">,</mo><mi>y</mi><mo separator="true">,</mo><mi>z</mi><mo stretchy="false">)</mo><mo separator="true">,</mo><mtext>&nbsp;</mtext><mo stretchy="false">(</mo><mi>x</mi><mo>∗</mo><mi>y</mi><mo stretchy="false">)</mo><mo>∗</mo><mi>z</mi><mo>=</mo><mi>x</mi><mo>∗</mo><mo stretchy="false">(</mo><mi>y</mi><mo>∗</mo><mi>z</mi><mo stretchy="false">)</mo></mrow><annotation encoding="application/x-tex">\forall (x, y, z),\ (x * y) * z = x * (y * z)</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mord">∀</span><span class="mopen">(</span><span class="mord mathnormal">x</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord mathnormal" style="margin-right:0.03588em;">y</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord mathnormal" style="margin-right:0.04398em;">z</span><span class="mclose">)</span><span class="mpunct">,</span><span class="mspace">&nbsp;</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mopen">(</span><span class="mord mathnormal">x</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">∗</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mord mathnormal" style="margin-right:0.03588em;">y</span><span class="mclose">)</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">∗</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:0.4306em;"></span><span class="mord mathnormal" style="margin-right:0.04398em;">z</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.4653em;"></span><span class="mord mathnormal">x</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">∗</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mopen">(</span><span class="mord mathnormal" style="margin-right:0.03588em;">y</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">∗</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mord mathnormal" style="margin-right:0.04398em;">z</span><span class="mclose">)</span></span></span></span></li>
<li><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mo>∗</mo></mrow><annotation encoding="application/x-tex">*</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.4653em;"></span><span class="mord">∗</span></span></span></span> has a neutral element, that is <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi mathvariant="normal">∃</mi><msub><mi>e</mi><mi>p</mi></msub><mo separator="true">,</mo><mtext>&nbsp;</mtext><mi mathvariant="normal">∀</mi><mi>x</mi><mo separator="true">,</mo><mtext>&nbsp;</mtext><mi>x</mi><mo>∗</mo><msub><mi>e</mi><mi>p</mi></msub><mo>=</mo><mi>x</mi></mrow><annotation encoding="application/x-tex">\exists e_p,\ \forall x,\ x * e_p = x</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.9805em;vertical-align:-0.2861em;"></span><span class="mord">∃</span><span class="mord"><span class="mord mathnormal">e</span><span class="msupsub"><span class="vlist-t vlist-t2"><span class="vlist-r"><span class="vlist" style="height:0.1514em;"><span style="top:-2.55em;margin-left:0em;margin-right:0.05em;"><span class="pstrut" style="height:2.7em;"></span><span class="sizing reset-size6 size3 mtight"><span class="mord mathnormal mtight">p</span></span></span></span><span class="vlist-s">​</span></span><span class="vlist-r"><span class="vlist" style="height:0.2861em;"><span></span></span></span></span></span></span><span class="mpunct">,</span><span class="mspace">&nbsp;</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord">∀</span><span class="mord mathnormal">x</span><span class="mpunct">,</span><span class="mspace">&nbsp;</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord mathnormal">x</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">∗</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:0.7167em;vertical-align:-0.2861em;"></span><span class="mord"><span class="mord mathnormal">e</span><span class="msupsub"><span class="vlist-t vlist-t2"><span class="vlist-r"><span class="vlist" style="height:0.1514em;"><span style="top:-2.55em;margin-left:0em;margin-right:0.05em;"><span class="pstrut" style="height:2.7em;"></span><span class="sizing reset-size6 size3 mtight"><span class="mord mathnormal mtight">p</span></span></span></span><span class="vlist-s">​</span></span><span class="vlist-r"><span class="vlist" style="height:0.2861em;"><span></span></span></span></span></span></span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.4306em;"></span><span class="mord mathnormal">x</span></span></span></span></li>
<li>The distributivity of <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mo>+</mo></mrow><annotation encoding="application/x-tex">+</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6667em;vertical-align:-0.0833em;"></span><span class="mord">+</span></span></span></span> and <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mo>∗</mo></mrow><annotation encoding="application/x-tex">*</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.4653em;"></span><span class="mord">∗</span></span></span></span>, that is <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi mathvariant="normal">∀</mi><mo stretchy="false">(</mo><mi>x</mi><mo separator="true">,</mo><mi>y</mi><mo separator="true">,</mo><mi>z</mi><mo stretchy="false">)</mo><mo separator="true">,</mo><mtext>&nbsp;</mtext><mi>x</mi><mo>∗</mo><mo stretchy="false">(</mo><mi>y</mi><mo>+</mo><mi>z</mi><mo stretchy="false">)</mo><mo>=</mo><mi>x</mi><mo>∗</mo><mi>y</mi><mo>+</mo><mi>x</mi><mo>∗</mo><mi>z</mi></mrow><annotation encoding="application/x-tex">\forall
(x, y, z),\ x * (y + z) = x * y + x * z</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mord">∀</span><span class="mopen">(</span><span class="mord mathnormal">x</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord mathnormal" style="margin-right:0.03588em;">y</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord mathnormal" style="margin-right:0.04398em;">z</span><span class="mclose">)</span><span class="mpunct">,</span><span class="mspace">&nbsp;</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord mathnormal">x</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">∗</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mopen">(</span><span class="mord mathnormal" style="margin-right:0.03588em;">y</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">+</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mord mathnormal" style="margin-right:0.04398em;">z</span><span class="mclose">)</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.4653em;"></span><span class="mord mathnormal">x</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">∗</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:0.7778em;vertical-align:-0.1944em;"></span><span class="mord mathnormal" style="margin-right:0.03588em;">y</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">+</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:0.4653em;"></span><span class="mord mathnormal">x</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">∗</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:0.4306em;"></span><span class="mord mathnormal" style="margin-right:0.04398em;">z</span></span></span></span></li>
<li><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mo>∗</mo></mrow><annotation encoding="application/x-tex">*</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.4653em;"></span><span class="mord">∗</span></span></span></span> has an absorbing element, that is <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi mathvariant="normal">∃</mi><msub><mi>e</mi><mi>a</mi></msub><mo separator="true">,</mo><mtext>&nbsp;</mtext><mi mathvariant="normal">∀</mi><mi>x</mi><mo separator="true">,</mo><mtext>&nbsp;</mtext><mi>x</mi><mo>∗</mo><msub><mi>e</mi><mi>a</mi></msub><mo>=</mo><msub><mi>e</mi><mi>a</mi></msub></mrow><annotation encoding="application/x-tex">\exists e_a,\ \forall x, \ x * e_a = e_a</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.8889em;vertical-align:-0.1944em;"></span><span class="mord">∃</span><span class="mord"><span class="mord mathnormal">e</span><span class="msupsub"><span class="vlist-t vlist-t2"><span class="vlist-r"><span class="vlist" style="height:0.1514em;"><span style="top:-2.55em;margin-left:0em;margin-right:0.05em;"><span class="pstrut" style="height:2.7em;"></span><span class="sizing reset-size6 size3 mtight"><span class="mord mathnormal mtight">a</span></span></span></span><span class="vlist-s">​</span></span><span class="vlist-r"><span class="vlist" style="height:0.15em;"><span></span></span></span></span></span></span><span class="mpunct">,</span><span class="mspace">&nbsp;</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord">∀</span><span class="mord mathnormal">x</span><span class="mpunct">,</span><span class="mspace">&nbsp;</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord mathnormal">x</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">∗</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:0.5806em;vertical-align:-0.15em;"></span><span class="mord"><span class="mord mathnormal">e</span><span class="msupsub"><span class="vlist-t vlist-t2"><span class="vlist-r"><span class="vlist" style="height:0.1514em;"><span style="top:-2.55em;margin-left:0em;margin-right:0.05em;"><span class="pstrut" style="height:2.7em;"></span><span class="sizing reset-size6 size3 mtight"><span class="mord mathnormal mtight">a</span></span></span></span><span class="vlist-s">​</span></span><span class="vlist-r"><span class="vlist" style="height:0.15em;"><span></span></span></span></span></span></span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.5806em;vertical-align:-0.15em;"></span><span class="mord"><span class="mord mathnormal">e</span><span class="msupsub"><span class="vlist-t vlist-t2"><span class="vlist-r"><span class="vlist" style="height:0.1514em;"><span style="top:-2.55em;margin-left:0em;margin-right:0.05em;"><span class="pstrut" style="height:2.7em;"></span><span class="sizing reset-size6 size3 mtight"><span class="mord mathnormal mtight">a</span></span></span></span><span class="vlist-s">​</span></span><span class="vlist-r"><span class="vlist" style="height:0.15em;"><span></span></span></span></span></span></span></span></span></span></li>
</ul>
<p>For the record, the <code class="hljs language-coq"><span class="hljs-built_in">sum</span></code> (<span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mo>+</mo></mrow><annotation encoding="application/x-tex">+</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6667em;vertical-align:-0.0833em;"></span><span class="mord">+</span></span></span></span>) and <code class="hljs language-coq">prod</code> (<span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mo>∗</mo></mrow><annotation encoding="application/x-tex">*</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.4653em;"></span><span class="mord">∗</span></span></span></span>) types are defined
in Coq as follows:</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Inductive</span> <span class="hljs-built_in">sum</span> (A B : <span class="hljs-keyword">Type</span>) : <span class="hljs-keyword">Type</span> :=
| <span class="hljs-type">inl</span> : A -&gt; <span class="hljs-built_in">sum</span> A B
| <span class="hljs-type">inr</span> : B -&gt; <span class="hljs-built_in">sum</span> A B

<span class="hljs-keyword">Inductive</span> prod (A B : <span class="hljs-keyword">Type</span>) : <span class="hljs-keyword">Type</span> :=
| <span class="hljs-type">pair</span> : A -&gt; B -&gt; prod A B
</code></pre>
<h2>An Equivalence for <code class="hljs language-coq"><span class="hljs-keyword">Type</span></code></h2>
<p>Algebraic structures come with <em>equations</em> expected to be true.  This means
there is an implicit dependency which is —to my opinion— too easily overlooked:
the definition of <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mo>=</mo></mrow><annotation encoding="application/x-tex">=</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.3669em;"></span><span class="mrel">=</span></span></span></span>. In Coq, <code class="hljs language-coq">=</code> is a built-in relation that states
that two terms are “equal” if they can be reduced to the same “hierarchy” of
constructors. This is too strong in the general case, and in particular for our
study of algebraic structures of <code class="hljs language-coq"><span class="hljs-keyword">Type</span></code>. It is clear that, to Coq’s
opinion, <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>α</mi><mo>+</mo><mi>β</mi></mrow><annotation encoding="application/x-tex">\alpha + \beta</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6667em;vertical-align:-0.0833em;"></span><span class="mord mathnormal" style="margin-right:0.0037em;">α</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">+</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:0.8889em;vertical-align:-0.1944em;"></span><span class="mord mathnormal" style="margin-right:0.05278em;">β</span></span></span></span> is not structurally <em>equal</em> to <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>β</mi><mo>+</mo><mi>α</mi></mrow><annotation encoding="application/x-tex">\beta + \alpha</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.8889em;vertical-align:-0.1944em;"></span><span class="mord mathnormal" style="margin-right:0.05278em;">β</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">+</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:0.4306em;"></span><span class="mord mathnormal" style="margin-right:0.0037em;">α</span></span></span></span>, yet
we will have to prove they are “equivalent.”</p>
<h3>Introducing <code class="hljs language-coq">type_equiv</code></h3>
<p>Since <code class="hljs language-coq">=</code> for <code class="hljs language-coq"><span class="hljs-keyword">Type</span></code> is not suitable for reasoning about algebraic
datatypes, we introduce our own equivalence relation, denoted <code class="hljs language-coq">==</code>.  We
say two types <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>α</mi></mrow><annotation encoding="application/x-tex">\alpha</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.4306em;"></span><span class="mord mathnormal" style="margin-right:0.0037em;">α</span></span></span></span> and <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>β</mi></mrow><annotation encoding="application/x-tex">\beta</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.8889em;vertical-align:-0.1944em;"></span><span class="mord mathnormal" style="margin-right:0.05278em;">β</span></span></span></span> are equivalent up to an isomorphism
when for any term of type <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>α</mi></mrow><annotation encoding="application/x-tex">\alpha</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.4306em;"></span><span class="mord mathnormal" style="margin-right:0.0037em;">α</span></span></span></span>, there exists a counterpart term of type
<span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>β</mi></mrow><annotation encoding="application/x-tex">\beta</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.8889em;vertical-align:-0.1944em;"></span><span class="mord mathnormal" style="margin-right:0.05278em;">β</span></span></span></span> and vice versa. In other words, <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>α</mi></mrow><annotation encoding="application/x-tex">\alpha</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.4306em;"></span><span class="mord mathnormal" style="margin-right:0.0037em;">α</span></span></span></span> and <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>β</mi></mrow><annotation encoding="application/x-tex">\beta</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.8889em;vertical-align:-0.1944em;"></span><span class="mord mathnormal" style="margin-right:0.05278em;">β</span></span></span></span> are equivalent if
we can exhibit two functions <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>f</mi></mrow><annotation encoding="application/x-tex">f</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.8889em;vertical-align:-0.1944em;"></span><span class="mord mathnormal" style="margin-right:0.10764em;">f</span></span></span></span> and <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>g</mi></mrow><annotation encoding="application/x-tex">g</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.625em;vertical-align:-0.1944em;"></span><span class="mord mathnormal" style="margin-right:0.03588em;">g</span></span></span></span> such that:</p>
<p class="katex-block"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mi mathvariant="normal">∀</mi><mo stretchy="false">(</mo><mi>x</mi><mo>:</mo><mi>α</mi><mo stretchy="false">)</mo><mo separator="true">,</mo><mtext>&nbsp;</mtext><mi>x</mi><mo>=</mo><mi>g</mi><mo stretchy="false">(</mo><mi>f</mi><mo stretchy="false">(</mo><mi>x</mi><mo stretchy="false">)</mo><mo stretchy="false">)</mo></mrow><annotation encoding="application/x-tex">\forall (x : α),\ x = g(f(x))
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mord">∀</span><span class="mopen">(</span><span class="mord mathnormal">x</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">:</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mord mathnormal" style="margin-right:0.0037em;">α</span><span class="mclose">)</span><span class="mpunct">,</span><span class="mspace">&nbsp;</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord mathnormal">x</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mord mathnormal" style="margin-right:0.03588em;">g</span><span class="mopen">(</span><span class="mord mathnormal" style="margin-right:0.10764em;">f</span><span class="mopen">(</span><span class="mord mathnormal">x</span><span class="mclose">))</span></span></span></span></span></p>
<p class="katex-block"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mi mathvariant="normal">∀</mi><mo stretchy="false">(</mo><mi>y</mi><mo>:</mo><mi>β</mi><mo stretchy="false">)</mo><mo separator="true">,</mo><mtext>&nbsp;</mtext><mi>y</mi><mo>=</mo><mi>f</mi><mo stretchy="false">(</mo><mi>g</mi><mo stretchy="false">(</mo><mi>y</mi><mo stretchy="false">)</mo><mo stretchy="false">)</mo></mrow><annotation encoding="application/x-tex">\forall (y : β),\ y = f(g(y))
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mord">∀</span><span class="mopen">(</span><span class="mord mathnormal" style="margin-right:0.03588em;">y</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">:</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mord mathnormal" style="margin-right:0.05278em;">β</span><span class="mclose">)</span><span class="mpunct">,</span><span class="mspace">&nbsp;</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord mathnormal" style="margin-right:0.03588em;">y</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mord mathnormal" style="margin-right:0.10764em;">f</span><span class="mopen">(</span><span class="mord mathnormal" style="margin-right:0.03588em;">g</span><span class="mopen">(</span><span class="mord mathnormal" style="margin-right:0.03588em;">y</span><span class="mclose">))</span></span></span></span></span></p>
<p>This translates into the following inductive type.</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Reserved</span> <span class="hljs-keyword">Notation</span> <span class="hljs-string">"x == y"</span> (<span class="hljs-built_in">at</span> level <span class="hljs-number">72</span>).

<span class="hljs-keyword">Inductive</span> type_equiv (α β : <span class="hljs-keyword">Type</span>) : <span class="hljs-keyword">Prop</span> :=
| <span class="hljs-type">mk_type_equiv</span> (f : α -&gt; β) (g : β -&gt; α)
                (equ1 : <span class="hljs-keyword">forall</span> (x : α), x = g (f x))
                (equ2 : <span class="hljs-keyword">forall</span> (y : β), y = f (g y))
  : α == β
<span class="hljs-keyword">where</span> <span class="hljs-string">"x == y"</span> := (type_equiv x y).
</code></pre>
<p>As mentioned earlier, we prove two types are equivalent by exhibiting
two functions, and proving these functions satisfy two properties. We
introduce a <code class="hljs">Ltac</code> notation to that end.</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Tactic</span> <span class="hljs-keyword">Notation</span> <span class="hljs-string">"equiv"</span> <span class="hljs-string">"with"</span> uconstr(f) <span class="hljs-string">"and"</span> uconstr(g)
  := <span class="hljs-built_in">apply</span> (mk_type_equiv f g).
</code></pre>
<p>The tactic <code class="hljs language-coq">equiv <span class="hljs-built_in">with</span> f and g</code> will turn a goal of the form <code class="hljs language-coq">α == β</code> into two subgoals to prove <code class="hljs">f</code> and <code class="hljs">g</code> form an isomorphism.</p>
<h3><code class="hljs language-coq">type_equiv</code> is an Equivalence</h3>
<p>We can prove it by demonstrating it is</p>
<ol>
<li>Reflexive,</li>
<li>Symmetric, and</li>
<li>Transitive.</li>
</ol>
<h4><code class="hljs language-coq">type_equiv</code> is reflexive</h4>
<p>This proof is straightforward. A type <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>α</mi></mrow><annotation encoding="application/x-tex">\alpha</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.4306em;"></span><span class="mord mathnormal" style="margin-right:0.0037em;">α</span></span></span></span> is equivalent to itself because:</p>
<p class="katex-block"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mi mathvariant="normal">∀</mi><mo stretchy="false">(</mo><mi>x</mi><mo>:</mo><mi>α</mi><mo stretchy="false">)</mo><mo separator="true">,</mo><mtext>&nbsp;</mtext><mi>x</mi><mo>=</mo><mi>i</mi><mi>d</mi><mo stretchy="false">(</mo><mi>i</mi><mi>d</mi><mo stretchy="false">(</mo><mi>x</mi><mo stretchy="false">)</mo><mo stretchy="false">)</mo></mrow><annotation encoding="application/x-tex">\forall (x : α),\ x = id(id(x))
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mord">∀</span><span class="mopen">(</span><span class="mord mathnormal">x</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">:</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mord mathnormal" style="margin-right:0.0037em;">α</span><span class="mclose">)</span><span class="mpunct">,</span><span class="mspace">&nbsp;</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord mathnormal">x</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mord mathnormal">i</span><span class="mord mathnormal">d</span><span class="mopen">(</span><span class="mord mathnormal">i</span><span class="mord mathnormal">d</span><span class="mopen">(</span><span class="mord mathnormal">x</span><span class="mclose">))</span></span></span></span></span></p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Lemma</span> type_equiv_refl (α : <span class="hljs-keyword">Type</span>) : α == α.
<span class="hljs-keyword">Proof</span>.
  now equiv <span class="hljs-built_in">with</span> (@id α) and (@id α).
<span class="hljs-keyword">Qed</span>.
</code></pre>
<h4><code class="hljs language-coq">type_equiv</code> is symmetric</h4>
<p>If <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>α</mi><mo>=</mo><mi>β</mi></mrow><annotation encoding="application/x-tex">\alpha = \beta</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.4306em;"></span><span class="mord mathnormal" style="margin-right:0.0037em;">α</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.8889em;vertical-align:-0.1944em;"></span><span class="mord mathnormal" style="margin-right:0.05278em;">β</span></span></span></span>, then we know there exists two functions <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>f</mi></mrow><annotation encoding="application/x-tex">f</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.8889em;vertical-align:-0.1944em;"></span><span class="mord mathnormal" style="margin-right:0.10764em;">f</span></span></span></span> and <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>g</mi></mrow><annotation encoding="application/x-tex">g</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.625em;vertical-align:-0.1944em;"></span><span class="mord mathnormal" style="margin-right:0.03588em;">g</span></span></span></span> which
satisfy the expected properties. We can “swap” them to prove that <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>β</mi><mo>=</mo><mo>=</mo><mi>α</mi></mrow><annotation encoding="application/x-tex">\beta ==
\alpha</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.8889em;vertical-align:-0.1944em;"></span><span class="mord mathnormal" style="margin-right:0.05278em;">β</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">==</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.4306em;"></span><span class="mord mathnormal" style="margin-right:0.0037em;">α</span></span></span></span>.</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Lemma</span> type_equiv_sym {α β} (equ : α == β) : β == α.
<span class="hljs-keyword">Proof</span>.
  <span class="hljs-built_in">destruct</span> equ <span class="hljs-built_in">as</span> [f g equ1 equ2].
  now equiv <span class="hljs-built_in">with</span> g and f.
<span class="hljs-keyword">Qed</span>.
</code></pre>
<h4><code class="hljs language-coq">type_equiv</code> is transitive</h4>
<p>If <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>α</mi><mo>=</mo><mi>β</mi></mrow><annotation encoding="application/x-tex">\alpha = \beta</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.4306em;"></span><span class="mord mathnormal" style="margin-right:0.0037em;">α</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.8889em;vertical-align:-0.1944em;"></span><span class="mord mathnormal" style="margin-right:0.05278em;">β</span></span></span></span>, we know there exists two functions <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><msub><mi>f</mi><mi>α</mi></msub></mrow><annotation encoding="application/x-tex">f_\alpha</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.8889em;vertical-align:-0.1944em;"></span><span class="mord"><span class="mord mathnormal" style="margin-right:0.10764em;">f</span><span class="msupsub"><span class="vlist-t vlist-t2"><span class="vlist-r"><span class="vlist" style="height:0.1514em;"><span style="top:-2.55em;margin-left:-0.1076em;margin-right:0.05em;"><span class="pstrut" style="height:2.7em;"></span><span class="sizing reset-size6 size3 mtight"><span class="mord mathnormal mtight" style="margin-right:0.0037em;">α</span></span></span></span><span class="vlist-s">​</span></span><span class="vlist-r"><span class="vlist" style="height:0.15em;"><span></span></span></span></span></span></span></span></span></span> and
<span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><msub><mi>g</mi><mi>β</mi></msub></mrow><annotation encoding="application/x-tex">g_\beta</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.7167em;vertical-align:-0.2861em;"></span><span class="mord"><span class="mord mathnormal" style="margin-right:0.03588em;">g</span><span class="msupsub"><span class="vlist-t vlist-t2"><span class="vlist-r"><span class="vlist" style="height:0.3361em;"><span style="top:-2.55em;margin-left:-0.0359em;margin-right:0.05em;"><span class="pstrut" style="height:2.7em;"></span><span class="sizing reset-size6 size3 mtight"><span class="mord mathnormal mtight" style="margin-right:0.05278em;">β</span></span></span></span><span class="vlist-s">​</span></span><span class="vlist-r"><span class="vlist" style="height:0.2861em;"><span></span></span></span></span></span></span></span></span></span> which satisfy the expected properties of <code class="hljs language-coq">type_equiv</code>.
Similarly, because <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>β</mi><mo>=</mo><mi>γ</mi></mrow><annotation encoding="application/x-tex">\beta = \gamma</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.8889em;vertical-align:-0.1944em;"></span><span class="mord mathnormal" style="margin-right:0.05278em;">β</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.625em;vertical-align:-0.1944em;"></span><span class="mord mathnormal" style="margin-right:0.05556em;">γ</span></span></span></span>,
we know there exists two additional functions <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><msub><mi>f</mi><mi>β</mi></msub></mrow><annotation encoding="application/x-tex">f_\beta</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.9805em;vertical-align:-0.2861em;"></span><span class="mord"><span class="mord mathnormal" style="margin-right:0.10764em;">f</span><span class="msupsub"><span class="vlist-t vlist-t2"><span class="vlist-r"><span class="vlist" style="height:0.3361em;"><span style="top:-2.55em;margin-left:-0.1076em;margin-right:0.05em;"><span class="pstrut" style="height:2.7em;"></span><span class="sizing reset-size6 size3 mtight"><span class="mord mathnormal mtight" style="margin-right:0.05278em;">β</span></span></span></span><span class="vlist-s">​</span></span><span class="vlist-r"><span class="vlist" style="height:0.2861em;"><span></span></span></span></span></span></span></span></span></span> and <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><msub><mi>g</mi><mi>γ</mi></msub></mrow><annotation encoding="application/x-tex">g_\gamma</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.7167em;vertical-align:-0.2861em;"></span><span class="mord"><span class="mord mathnormal" style="margin-right:0.03588em;">g</span><span class="msupsub"><span class="vlist-t vlist-t2"><span class="vlist-r"><span class="vlist" style="height:0.1514em;"><span style="top:-2.55em;margin-left:-0.0359em;margin-right:0.05em;"><span class="pstrut" style="height:2.7em;"></span><span class="sizing reset-size6 size3 mtight"><span class="mord mathnormal mtight" style="margin-right:0.05556em;">γ</span></span></span></span><span class="vlist-s">​</span></span><span class="vlist-r"><span class="vlist" style="height:0.2861em;"><span></span></span></span></span></span></span></span></span></span>. We can
compose these functions together to prove <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>α</mi><mo>=</mo><mi>γ</mi></mrow><annotation encoding="application/x-tex">\alpha = \gamma</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.4306em;"></span><span class="mord mathnormal" style="margin-right:0.0037em;">α</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.625em;vertical-align:-0.1944em;"></span><span class="mord mathnormal" style="margin-right:0.05556em;">γ</span></span></span></span>.</p>
<p>As a reminder, composing two functions <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>f</mi></mrow><annotation encoding="application/x-tex">f</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.8889em;vertical-align:-0.1944em;"></span><span class="mord mathnormal" style="margin-right:0.10764em;">f</span></span></span></span> and <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>g</mi></mrow><annotation encoding="application/x-tex">g</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.625em;vertical-align:-0.1944em;"></span><span class="mord mathnormal" style="margin-right:0.03588em;">g</span></span></span></span> (denoted by <code class="hljs language-coq">f &gt;&gt;&gt; g</code>
thereafter) consists in using the result of <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>f</mi></mrow><annotation encoding="application/x-tex">f</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.8889em;vertical-align:-0.1944em;"></span><span class="mord mathnormal" style="margin-right:0.10764em;">f</span></span></span></span> as the input of <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>g</mi></mrow><annotation encoding="application/x-tex">g</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.625em;vertical-align:-0.1944em;"></span><span class="mord mathnormal" style="margin-right:0.03588em;">g</span></span></span></span>.</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Infix</span> <span class="hljs-string">"&gt;&gt;&gt;"</span> := (<span class="hljs-keyword">fun</span> f g x =&gt; g (f x)) (<span class="hljs-built_in">at</span> level <span class="hljs-number">70</span>).

<span class="hljs-keyword">Lemma</span> type_equiv_trans {α β γ} (equ1 : α == β) (equ2 : β == γ)
  : α == γ.
<span class="hljs-keyword">Proof</span>.
  <span class="hljs-built_in">destruct</span> equ1 <span class="hljs-built_in">as</span> [fα gβ equαβ equβα],
           equ2 <span class="hljs-built_in">as</span> [fβ gγ equβγ equγβ].
  equiv <span class="hljs-built_in">with</span> (fα &gt;&gt;&gt; fβ) and (gγ &gt;&gt;&gt; gβ).
  + <span class="hljs-built_in">intros</span> x.
    <span class="hljs-built_in">rewrite</span> &lt;- equβγ.
    now <span class="hljs-built_in">rewrite</span> &lt;- equαβ.
  + <span class="hljs-built_in">intros</span> x.
    <span class="hljs-built_in">rewrite</span> &lt;- equβα.
    now <span class="hljs-built_in">rewrite</span> &lt;- equγβ.
<span class="hljs-keyword">Qed</span>.
</code></pre>
<h4>Conclusion</h4>
<p>The Coq standard library introduces the <code class="hljs language-coq">Equivalence</code> type class. We can
provide an instance of this type class for <code class="hljs language-coq">type_equiv</code>, using the three
lemmas we have proven in this section.</p>
<pre><code class="hljs language-coq">#[<span class="hljs-built_in">refine</span>]
<span class="hljs-keyword">Instance</span> type_equiv_Equivalence : Equivalence type_equiv :=
  {}.

<span class="hljs-keyword">Proof</span>.
  + <span class="hljs-built_in">intros</span> x.
    <span class="hljs-built_in">apply</span> type_equiv_refl.
  + <span class="hljs-built_in">intros</span> x y.
    <span class="hljs-built_in">apply</span> type_equiv_sym.
  + <span class="hljs-built_in">intros</span> x y z.
    <span class="hljs-built_in">apply</span> type_equiv_trans.
<span class="hljs-keyword">Qed</span>.
</code></pre>
<h3>Examples</h3>
<h4><code class="hljs language-coq">list</code>’s canonical form</h4>
<p>We now come back to our initial example, given in the introduction of this
write-up. We can prove our assertion, that is <code class="hljs language-coq">list α == unit + α * list α</code>.</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Lemma</span> list_equiv (α : <span class="hljs-keyword">Type</span>)
  : list α == unit + α * list α.

<span class="hljs-keyword">Proof</span>.
  equiv <span class="hljs-built_in">with</span> (<span class="hljs-keyword">fun</span> x =&gt; <span class="hljs-keyword">match</span> x <span class="hljs-built_in">with</span>
                       | <span class="hljs-type">[] =&gt; inl</span> tt
                       | <span class="hljs-type">x</span> :: rst =&gt; inr (x, rst)
                       <span class="hljs-keyword">end</span>)
         and (<span class="hljs-keyword">fun</span> x =&gt; <span class="hljs-keyword">match</span> x <span class="hljs-built_in">with</span>
                       | <span class="hljs-type">inl</span> <span class="hljs-keyword">_</span> =&gt; []
                       | <span class="hljs-type">inr</span> (x, rst) =&gt; x :: rst
                       <span class="hljs-keyword">end</span>).
  + now <span class="hljs-built_in">intros</span> [| <span class="hljs-type">x</span> rst].
  + now <span class="hljs-built_in">intros</span> [[] | <span class="hljs-type">[x</span> rst]].
<span class="hljs-keyword">Qed</span>.
</code></pre>
<h4><code class="hljs language-coq">list</code> is a morphism</h4>
<p>This means that if <code class="hljs language-coq">α == β</code>, then <code class="hljs language-coq">list α == list β</code>. We prove this
by defining an instance of the <code class="hljs language-coq">Proper</code> type class.</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Instance</span> list_Proper
  : Proper (type_equiv ==&gt; type_equiv) list.

<span class="hljs-keyword">Proof</span>.
  add_morphism_tactic.
  <span class="hljs-built_in">intros</span> α β [f g equαβ equβα].
  equiv <span class="hljs-built_in">with</span> (map f) and (map g).
  all: <span class="hljs-built_in">setoid_rewrite</span> map_map; <span class="hljs-built_in">intros</span> l.
  + <span class="hljs-built_in">replace</span> (<span class="hljs-keyword">fun</span> x : α =&gt; g (f x))
       <span class="hljs-built_in">with</span> (@id α).
    ++ <span class="hljs-built_in">symmetry</span>; <span class="hljs-built_in">apply</span> map_id.
    ++ <span class="hljs-built_in">apply</span> functional_extensionality.
       <span class="hljs-built_in">apply</span> equαβ.
  + <span class="hljs-built_in">replace</span> (<span class="hljs-keyword">fun</span> x : β =&gt; f (g x))
       <span class="hljs-built_in">with</span> (@id β).
    ++ <span class="hljs-built_in">symmetry</span>; <span class="hljs-built_in">apply</span> map_id.
    ++ <span class="hljs-built_in">apply</span> functional_extensionality.
       <span class="hljs-built_in">apply</span> equβα.
<span class="hljs-keyword">Qed</span>.
</code></pre>
<p>The use of the <code class="hljs language-coq">Proper</code> type class allows for leveraging hypotheses of
the form <code class="hljs language-coq">α == β</code> with the <code class="hljs">rewrite</code> tactic. I personally consider
providing instances of <code class="hljs language-coq">Proper</code> whenever it is possible to be a good
practice, and would encourage any Coq programmers to do so.</p>
<h4><code class="hljs language-coq">nat</code> is a special purpose <code class="hljs">list</code></h4>
<p>Did you notice? Now, using <code class="hljs language-coq">type_equiv</code>, we can prove it!</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Lemma</span> nat_and_list : nat == list unit.
<span class="hljs-keyword">Proof</span>.
  equiv <span class="hljs-built_in">with</span> (<span class="hljs-built_in">fix</span> to_list n :=
                <span class="hljs-keyword">match</span> n <span class="hljs-built_in">with</span>
                | <span class="hljs-type">S</span> m =&gt; tt :: to_list m
                | <span class="hljs-type">_</span> =&gt; []
                <span class="hljs-keyword">end</span>)
         and (<span class="hljs-built_in">fix</span> of_list l :=
                <span class="hljs-keyword">match</span> l <span class="hljs-built_in">with</span>
                | <span class="hljs-type">_</span> :: rst =&gt; S (of_list rst)
                | <span class="hljs-type">_</span> =&gt; <span class="hljs-number">0</span>
                <span class="hljs-keyword">end</span>).
  + <span class="hljs-built_in">induction</span> x; <span class="hljs-built_in">auto</span>.
  + <span class="hljs-built_in">induction</span> y; <span class="hljs-built_in">auto</span>.
    <span class="hljs-built_in">rewrite</span> &lt;- IHy.
    now <span class="hljs-built_in">destruct</span> a.
<span class="hljs-keyword">Qed</span>.
</code></pre>
<h4>Non-empty lists</h4>
<p>We can introduce a variant of <code class="hljs language-coq">list</code> which contains at least one element
by modifying the <code class="hljs language-coq">nil</code> constructor so that it takes one argument instead
of none.</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Inductive</span> non_empty_list (α : <span class="hljs-keyword">Type</span>) :=
| <span class="hljs-type">ne_cons</span> : α -&gt; non_empty_list α -&gt; non_empty_list α
| <span class="hljs-type">ne_singleton</span> : α -&gt; non_empty_list α.
</code></pre>
<p>We can demonstrate the relation between <code class="hljs language-coq">list</code> and
<code class="hljs language-coq">non_empty_list</code>, which reveals an alternative implementation of
<code class="hljs language-coq">non_empty_list</code>. More precisely, we can prove that <code class="hljs language-coq"><span class="hljs-keyword">forall</span> (α : <span class="hljs-keyword">Type</span>), non_empty_list α == α * list α</code>. It is a bit more cumbersome, but not that
much. We first define the conversion functions, then prove they satisfy the
properties expected by <code class="hljs language-coq">type_equiv</code>.</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Fixpoint</span> non_empty_list_of_list {α} (x : α) (l : list α)
  : non_empty_list α :=
  <span class="hljs-keyword">match</span> l <span class="hljs-built_in">with</span>
  | <span class="hljs-type">y</span> :: rst =&gt; ne_cons x (non_empty_list_of_list y rst)
  | <span class="hljs-type">[] =&gt; ne_singleton</span> x
  <span class="hljs-keyword">end</span>.

#[local]
<span class="hljs-keyword">Fixpoint</span> list_of_non_empty_list {α} (l : non_empty_list α)
  : list α :=
  <span class="hljs-keyword">match</span> l <span class="hljs-built_in">with</span>
  | <span class="hljs-type">ne_cons</span> x rst =&gt; x :: list_of_non_empty_list rst
  | <span class="hljs-type">ne_singleton</span> x =&gt; [x]
  <span class="hljs-keyword">end</span>.

<span class="hljs-keyword">Definition</span> list_of_non_empty_list {α} (l : non_empty_list α)
  : α * list α :=
  <span class="hljs-keyword">match</span> l <span class="hljs-built_in">with</span>
  | <span class="hljs-type">ne_singleton</span> x =&gt; (x, [])
  | <span class="hljs-type">ne_cons</span> x rst =&gt; (x, list_of_non_empty_list rst)
  <span class="hljs-keyword">end</span>.

<span class="hljs-keyword">Lemma</span> ne_list_list_equiv (α : <span class="hljs-keyword">Type</span>)
  : non_empty_list α == α * list α.

<span class="hljs-keyword">Proof</span>.
  equiv <span class="hljs-built_in">with</span> list_of_non_empty_list
         and (prod_curry non_empty_list_of_list).
  + <span class="hljs-built_in">intros</span> [x rst|<span class="hljs-type">x</span>]; <span class="hljs-built_in">auto</span>.
    <span class="hljs-built_in">cbn</span>.
    <span class="hljs-built_in">revert</span> x.
    <span class="hljs-built_in">induction</span> rst; <span class="hljs-built_in">intros</span> x; <span class="hljs-built_in">auto</span>.
    <span class="hljs-built_in">cbn</span>; now <span class="hljs-built_in">rewrite</span> IHrst.
  + <span class="hljs-built_in">intros</span> [x rst].
    <span class="hljs-built_in">cbn</span>.
    <span class="hljs-built_in">destruct</span> rst; <span class="hljs-built_in">auto</span>.
    <span class="hljs-built_in">change</span> (non_empty_list_of_list x (α<span class="hljs-number">0</span> :: rst))
      <span class="hljs-built_in">with</span> (ne_cons x (non_empty_list_of_list α<span class="hljs-number">0</span> rst)).
    <span class="hljs-built_in">replace</span> (α<span class="hljs-number">0</span> :: rst)
      <span class="hljs-built_in">with</span> (list_of_non_empty_list
              (non_empty_list_of_list α<span class="hljs-number">0</span> rst)); <span class="hljs-built_in">auto</span>.
    <span class="hljs-built_in">revert</span> α<span class="hljs-number">0.</span>
    <span class="hljs-built_in">induction</span> rst; <span class="hljs-built_in">intros</span> y; [ <span class="hljs-built_in">reflexivity</span> | <span class="hljs-type">cbn</span> ].
    now <span class="hljs-built_in">rewrite</span> IHrst.
<span class="hljs-keyword">Qed</span>.
</code></pre>
<h2>The <code class="hljs language-coq"><span class="hljs-built_in">sum</span></code> Operator</h2>
<h3><code class="hljs language-coq"><span class="hljs-built_in">sum</span></code> Is a Morphism</h3>
<p>To prove this, we compose together the functions whose existence is implied by
<span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>α</mi><mo>=</mo><msup><mi>α</mi><mo mathvariant="normal" lspace="0em" rspace="0em">′</mo></msup></mrow><annotation encoding="application/x-tex">\alpha = \alpha'</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.4306em;"></span><span class="mord mathnormal" style="margin-right:0.0037em;">α</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.7519em;"></span><span class="mord"><span class="mord mathnormal" style="margin-right:0.0037em;">α</span><span class="msupsub"><span class="vlist-t"><span class="vlist-r"><span class="vlist" style="height:0.7519em;"><span style="top:-3.063em;margin-right:0.05em;"><span class="pstrut" style="height:2.7em;"></span><span class="sizing reset-size6 size3 mtight"><span class="mord mtight"><span class="mord mtight">′</span></span></span></span></span></span></span></span></span></span></span></span> and <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>β</mi><mo>=</mo><msup><mi>β</mi><mo mathvariant="normal" lspace="0em" rspace="0em">′</mo></msup></mrow><annotation encoding="application/x-tex">\beta = \beta'</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.8889em;vertical-align:-0.1944em;"></span><span class="mord mathnormal" style="margin-right:0.05278em;">β</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.9463em;vertical-align:-0.1944em;"></span><span class="mord"><span class="mord mathnormal" style="margin-right:0.05278em;">β</span><span class="msupsub"><span class="vlist-t"><span class="vlist-r"><span class="vlist" style="height:0.7519em;"><span style="top:-3.063em;margin-right:0.05em;"><span class="pstrut" style="height:2.7em;"></span><span class="sizing reset-size6 size3 mtight"><span class="mord mtight"><span class="mord mtight">′</span></span></span></span></span></span></span></span></span></span></span></span>. To that end, we introduce the
auxiliary function <code class="hljs language-coq">lr_map</code>.</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Definition</span> lr_map_sum {α β α' β'} (f : α -&gt; α') (g : β -&gt; β')
    (x : α + β)
  : α' + β' :=
  <span class="hljs-keyword">match</span> x <span class="hljs-built_in">with</span>
  | <span class="hljs-type">inl</span> x =&gt; inl (f x)
  | <span class="hljs-type">inr</span> y =&gt; inr (g y)
  <span class="hljs-keyword">end</span>.
</code></pre>
<p>Then, we prove <code class="hljs language-coq"><span class="hljs-built_in">sum</span></code> is a morphism by defining a <code class="hljs language-coq">Proper</code> instance.</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Instance</span> sum_Proper
  : Proper (type_equiv ==&gt; type_equiv ==&gt; type_equiv) <span class="hljs-built_in">sum</span>.
<span class="hljs-keyword">Proof</span>.
  add_morphism_tactic.
  <span class="hljs-built_in">intros</span> α α' [fα gα' equαα' equα'α]
         β β' [fβ gβ' equββ' equβ'β].
  equiv <span class="hljs-built_in">with</span> (lr_map_sum fα fβ)
         and (lr_map_sum gα' gβ').
  + <span class="hljs-built_in">intros</span> [x|<span class="hljs-type">y</span>]; <span class="hljs-built_in">cbn</span>.
    ++ now <span class="hljs-built_in">rewrite</span> &lt;- equαα'.
    ++ now <span class="hljs-built_in">rewrite</span> &lt;- equββ'.
  + <span class="hljs-built_in">intros</span> [x|<span class="hljs-type">y</span>]; <span class="hljs-built_in">cbn</span>.
    ++ now <span class="hljs-built_in">rewrite</span> &lt;- equα'α.
    ++ now <span class="hljs-built_in">rewrite</span> &lt;- equβ'β.
<span class="hljs-keyword">Qed</span>.
</code></pre>
<h3><code class="hljs language-coq"><span class="hljs-built_in">sum</span></code> Is Commutative</h3>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Definition</span> sum_invert {α β} (x : α + β) : β + α :=
  <span class="hljs-keyword">match</span> x <span class="hljs-built_in">with</span>
  | <span class="hljs-type">inl</span> x =&gt; inr x
  | <span class="hljs-type">inr</span> x =&gt; inl x
  <span class="hljs-keyword">end</span>.

<span class="hljs-keyword">Lemma</span> sum_com {α β} : α + β == β + α.
<span class="hljs-keyword">Proof</span>.
  equiv <span class="hljs-built_in">with</span> sum_invert and sum_invert;
    now <span class="hljs-built_in">intros</span> [x|<span class="hljs-type">x</span>].
<span class="hljs-keyword">Qed</span>.
</code></pre>
<h3><code class="hljs language-coq"><span class="hljs-built_in">sum</span></code> Is Associative</h3>
<p>The associativity of <code class="hljs language-coq"><span class="hljs-built_in">sum</span></code> is straightforward to prove, and should not
pose a particular challenge to prospective readers<label for="fn1" class="sidenote-number margin-toggle"></label><input type="checkbox" class="margin-toggle"><span class="note-right sidenote note"><span class="footnote-p">If we assume that this article is well written, that is. </span>
</span>.</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Lemma</span> sum_assoc {α β γ} : α + β + γ == α + (β + γ).
<span class="hljs-keyword">Proof</span>.
  equiv <span class="hljs-built_in">with</span> (<span class="hljs-keyword">fun</span> x =&gt;
                <span class="hljs-keyword">match</span> x <span class="hljs-built_in">with</span>
                | <span class="hljs-type">inl</span> (inl x) =&gt; inl x
                | <span class="hljs-type">inl</span> (inr x) =&gt; inr (inl x)
                | <span class="hljs-type">inr</span> x =&gt; inr (inr x)
                <span class="hljs-keyword">end</span>)
         and (<span class="hljs-keyword">fun</span> x =&gt;
                <span class="hljs-keyword">match</span> x <span class="hljs-built_in">with</span>
                | <span class="hljs-type">inl</span> x =&gt; inl (inl x)
                | <span class="hljs-type">inr</span> (inl x) =&gt; inl (inr x)
                | <span class="hljs-type">inr</span> (inr x) =&gt; inr x
                <span class="hljs-keyword">end</span>).
  + now <span class="hljs-built_in">intros</span> [[x|<span class="hljs-type">x</span>]|<span class="hljs-type">x</span>].
  + now <span class="hljs-built_in">intros</span> [x|<span class="hljs-type">[x</span>|<span class="hljs-type">x</span>]].
<span class="hljs-keyword">Qed</span>.
</code></pre>
<h3><code class="hljs language-coq"><span class="hljs-built_in">sum</span></code> Has A Neutral Element</h3>
<p>We need to find a type <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>e</mi></mrow><annotation encoding="application/x-tex">e</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.4306em;"></span><span class="mord mathnormal">e</span></span></span></span> such that <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>α</mi><mo>+</mo><mi>e</mi><mo>=</mo><mi>α</mi></mrow><annotation encoding="application/x-tex">\alpha + e = \alpha</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6667em;vertical-align:-0.0833em;"></span><span class="mord mathnormal" style="margin-right:0.0037em;">α</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">+</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:0.4306em;"></span><span class="mord mathnormal">e</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.4306em;"></span><span class="mord mathnormal" style="margin-right:0.0037em;">α</span></span></span></span> for any type
<span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>α</mi></mrow><annotation encoding="application/x-tex">\alpha</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.4306em;"></span><span class="mord mathnormal" style="margin-right:0.0037em;">α</span></span></span></span> (similarly to <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>x</mi><mo>+</mo><mn>0</mn><mo>=</mo><mi>x</mi></mrow><annotation encoding="application/x-tex">x + 0 = x</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6667em;vertical-align:-0.0833em;"></span><span class="mord mathnormal">x</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">+</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:0.6444em;"></span><span class="mord">0</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.4306em;"></span><span class="mord mathnormal">x</span></span></span></span> for any natural number <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>x</mi></mrow><annotation encoding="application/x-tex">x</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.4306em;"></span><span class="mord mathnormal">x</span></span></span></span>).</p>
<p>Any empty type (that is, a type with no term such as <code class="hljs language-coq">False</code>) can act as
the natural element of <code class="hljs language-coq"><span class="hljs-keyword">Type</span></code>. As a reminder, empty types in Coq are
defined with the following syntax<label for="fn2" class="sidenote-number margin-toggle"></label><input type="checkbox" class="margin-toggle"><span class="note-left sidenote note"><span class="footnote-p">Note that <code class="hljs language-coq"><span class="hljs-keyword">Inductive</span> empty.</code> is erroneous.</span>
<span class="footnote-p">When the <code class="hljs language-coq">:=</code> is omitted, Coq defines an inductive type with one
constructor, making such a type equivalent to <code class="hljs language-coq">unit</code>, not
<code class="hljs language-coq">False</code>. </span>
</span>:</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Inductive</span> empty := .
</code></pre>
<p>From a high-level perspective, <code class="hljs language-coq">empty</code> being the neutral element of
<code class="hljs language-coq"><span class="hljs-built_in">sum</span></code> makes sense. Because we cannot construct a term of type <code class="hljs language-coq">empty</code>,
then <code class="hljs language-coq">α + empty</code> contains exactly the same numbers of terms as <code class="hljs language-coq">α</code>.
This is the intuition. Now, how can we convince Coq that our intuition is
correct? Just like before, by providing two functions of types:</p>
<ul>
<li><code class="hljs language-coq">α -&gt; α + empty</code></li>
<li><code class="hljs language-coq">α + empty -&gt; α</code></li>
</ul>
<p>The first function is <code class="hljs language-coq">inl</code>, that is one of the constructors of
<code class="hljs language-coq"><span class="hljs-built_in">sum</span></code>.</p>
<p>The second function is trickier to write in Coq, because it comes down to
writing a function of type is <code class="hljs language-coq">empty -&gt; α</code>.</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Definition</span> from_empty {α} : empty -&gt; α :=
  <span class="hljs-keyword">fun</span> x =&gt; <span class="hljs-keyword">match</span> x <span class="hljs-built_in">with</span> <span class="hljs-keyword">end</span>.
</code></pre>
<p>It is the exact same trick that allows Coq to encode proofs by
contradiction.</p>
<p>If we combine <code class="hljs language-coq">from_empty</code> with the generic function</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Definition</span> unwrap_left_or {α β}
    (f : β -&gt; α) (x : α + β)
  : α :=
  <span class="hljs-keyword">match</span> x <span class="hljs-built_in">with</span>
  | <span class="hljs-type">inl</span> x =&gt; x
  | <span class="hljs-type">inr</span> x =&gt; f x
  <span class="hljs-keyword">end</span>.
</code></pre>
<p>Then, we have everything to prove that <code class="hljs language-coq">α == α + empty</code>.</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Lemma</span> sum_neutral (α : <span class="hljs-keyword">Type</span>) : α == α + empty.
<span class="hljs-keyword">Proof</span>.
  equiv <span class="hljs-built_in">with</span> inl and (unwrap_left_or from_empty);
    <span class="hljs-built_in">auto</span>.
  now <span class="hljs-built_in">intros</span> [x|<span class="hljs-type">x</span>].
<span class="hljs-keyword">Qed</span>.
</code></pre>
<h2>The <code class="hljs language-coq">prod</code> Operator</h2>
<p>This is very similar to what we have just proven for <code class="hljs language-coq"><span class="hljs-built_in">sum</span></code>, so expect
less text for this section.</p>
<h3><code class="hljs language-coq">prod</code> Is A Morphism</h3>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Definition</span> lr_map_prod {α α' β β'}
    (f : α -&gt; α') (g : β -&gt; β')
  : α * β -&gt; α' * β' :=
  <span class="hljs-keyword">fun</span> x =&gt; <span class="hljs-keyword">match</span> x <span class="hljs-built_in">with</span> (x, y) =&gt; (f x, g y) <span class="hljs-keyword">end</span>.

<span class="hljs-keyword">Instance</span> prod_Proper
  : Proper (type_equiv ==&gt; type_equiv ==&gt; type_equiv) prod.

<span class="hljs-keyword">Proof</span>.
  add_morphism_tactic.
  <span class="hljs-built_in">intros</span> α α' [fα gα' equαα' equα'α]
         β β' [fβ gβ' equββ' equβ'β].
  equiv <span class="hljs-built_in">with</span> (lr_map_prod fα fβ)
         and (lr_map_prod gα' gβ').
  + <span class="hljs-built_in">intros</span> [x y]; <span class="hljs-built_in">cbn</span>.
    <span class="hljs-built_in">rewrite</span> &lt;- equαα'.
    now <span class="hljs-built_in">rewrite</span> &lt;- equββ'.
  + <span class="hljs-built_in">intros</span> [x y]; <span class="hljs-built_in">cbn</span>.
    <span class="hljs-built_in">rewrite</span> &lt;- equα'α.
    now <span class="hljs-built_in">rewrite</span> &lt;- equβ'β.
<span class="hljs-keyword">Qed</span>.
</code></pre>
<h3><code class="hljs language-coq">prod</code> Is Commutative</h3>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Definition</span> prod_invert {α β} (x : α * β) : β * α :=
  (snd x, fst x).

<span class="hljs-keyword">Lemma</span> prod_com {α β} : α * β == β * α.

<span class="hljs-keyword">Proof</span>.
  equiv <span class="hljs-built_in">with</span> prod_invert and prod_invert;
    now <span class="hljs-built_in">intros</span> [x y].
<span class="hljs-keyword">Qed</span>.
</code></pre>
<h3><code class="hljs language-coq">prod</code> Is Associative</h3>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Lemma</span> prod_assoc {α β γ}
  : α * β * γ == α * (β * γ).

<span class="hljs-keyword">Proof</span>.
  equiv <span class="hljs-built_in">with</span> (<span class="hljs-keyword">fun</span> x =&gt;
                <span class="hljs-keyword">match</span> x <span class="hljs-built_in">with</span>
                | <span class="hljs-type">((x</span>, y), z) =&gt; (x, (y, z))
                <span class="hljs-keyword">end</span>)
         and (<span class="hljs-keyword">fun</span> x =&gt;
                <span class="hljs-keyword">match</span> x <span class="hljs-built_in">with</span>
                | <span class="hljs-type">(x</span>, (y, z)) =&gt; ((x, y), z)
                <span class="hljs-keyword">end</span>).
  + now <span class="hljs-built_in">intros</span> [[x y] z].
  + now <span class="hljs-built_in">intros</span> [x [y z]].
<span class="hljs-keyword">Qed</span>.
</code></pre>
<h3><code class="hljs language-coq">prod</code> Has A Neutral Element</h3>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Lemma</span> prod_neutral (α : <span class="hljs-keyword">Type</span>) : α * unit == α.

<span class="hljs-keyword">Proof</span>.
  equiv <span class="hljs-built_in">with</span> fst and ((flip pair) tt).
  + now <span class="hljs-built_in">intros</span> [x []].
  + now <span class="hljs-built_in">intros</span>.
<span class="hljs-keyword">Qed</span>.
</code></pre>
<h3><code class="hljs language-coq">prod</code> Has An Absorbing Element *)</h3>
<p>And this absorbing element is <code class="hljs language-coq">empty</code>, just like the absorbing element of
the multiplication of natural numbers is <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mn>0</mn></mrow><annotation encoding="application/x-tex">0</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6444em;"></span><span class="mord">0</span></span></span></span> (that is, the neutral element of
the addition).</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Lemma</span> prod_absord (α : <span class="hljs-keyword">Type</span>) : α * empty == empty.
<span class="hljs-keyword">Proof</span>.
  equiv <span class="hljs-built_in">with</span> (snd &gt;&gt;&gt; from_empty)
         and (from_empty).
  + <span class="hljs-built_in">intros</span> [<span class="hljs-keyword">_</span> []].
  + <span class="hljs-built_in">intros</span> [].
<span class="hljs-keyword">Qed</span>.
</code></pre>
<h2><code class="hljs language-coq">prod</code> And <code class="hljs language-coq"><span class="hljs-built_in">sum</span></code> Distributivity</h2>
<p>Finally, we can prove the distributivity property of <code class="hljs language-coq">prod</code> and
<code class="hljs language-coq"><span class="hljs-built_in">sum</span></code> using a similar approach to prove the associativity of <code class="hljs language-coq">prod</code>
and <code class="hljs language-coq"><span class="hljs-built_in">sum</span></code>.</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Lemma</span> prod_sum_distr (α β γ : <span class="hljs-keyword">Type</span>)
  : α * (β + γ) == α * β + α * γ.
<span class="hljs-keyword">Proof</span>.
  equiv <span class="hljs-built_in">with</span> (<span class="hljs-keyword">fun</span> x =&gt; <span class="hljs-keyword">match</span> x <span class="hljs-built_in">with</span>
                       | <span class="hljs-type">(x</span>, inr y) =&gt; inr (x, y)
                       | <span class="hljs-type">(x</span>, inl y) =&gt; inl (x, y)
                       <span class="hljs-keyword">end</span>)
         and (<span class="hljs-keyword">fun</span> x =&gt; <span class="hljs-keyword">match</span> x <span class="hljs-built_in">with</span>
                       | <span class="hljs-type">inr</span> (x, y) =&gt; (x, inr y)
                       | <span class="hljs-type">inl</span> (x, y) =&gt; (x, inl y)
                       <span class="hljs-keyword">end</span>).
  + now <span class="hljs-built_in">intros</span> [x [y | <span class="hljs-type">y</span>]].
  + now <span class="hljs-built_in">intros</span> [[x y] | <span class="hljs-type">[x</span> y]].
<span class="hljs-keyword">Qed</span>.
</code></pre>
<h2>Bonus: Algebraic Datatypes and Metaprogramming</h2>
<p>Algebraic datatypes are very suitable for generating functions, as demonstrated
by the automatic deriving of typeclass in Haskell or trait in Rust. Because a
datatype can be expressed in terms of <code class="hljs language-coq"><span class="hljs-built_in">sum</span></code> and <code class="hljs language-coq">prod</code>, you just
have to know how to deal with these two constructions to start metaprogramming.</p>
<p>We can take the example of the <code class="hljs language-coq"><span class="hljs-built_in">fold</span></code> functions. A <code class="hljs language-coq"><span class="hljs-built_in">fold</span></code> function
is a function which takes a container as its argument, and iterates over the
values of that container in order to compute a result.</p>
<p>We introduce <code class="hljs language-coq">fold_type INPUT CANON_FORM OUTPUT</code>, a tactic to compute the
type of the fold function of the type <code class="hljs">INPUT</code>, whose “canonical form” (in terms
of <code class="hljs language-coq">prod</code> and <code class="hljs language-coq"><span class="hljs-built_in">sum</span></code>) is <code class="hljs">CANON_FORM</code> and whose result type is
<code class="hljs">OUTPUT</code>. Interested readers have to be familiar with <code class="hljs">Ltac</code>.</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Ltac</span> fold_args b a r :=
  lazymatch a <span class="hljs-built_in">with</span>
  | <span class="hljs-type">unit</span> =&gt;
    <span class="hljs-built_in">exact</span> r
  | <span class="hljs-type">b</span> =&gt;
    <span class="hljs-built_in">exact</span> (r -&gt; r)
  | <span class="hljs-type">(?c</span> + ?d)%type =&gt;
    <span class="hljs-built_in">exact</span> (ltac:(fold_args b c r) * ltac:(fold_args b d r))%type
  | <span class="hljs-type">(b</span> * ?c)%type =&gt;
    <span class="hljs-built_in">exact</span> (r -&gt; ltac:(fold_args b c r))
  | <span class="hljs-type">(?c</span> * ?d)%type =&gt;
    <span class="hljs-built_in">exact</span> (c -&gt; ltac:(fold_args b d r))
  | <span class="hljs-type">?a</span> =&gt;
    <span class="hljs-built_in">exact</span> (a -&gt; r)
  <span class="hljs-keyword">end</span>.

<span class="hljs-keyword">Ltac</span> currying a :=
  <span class="hljs-keyword">match</span> a <span class="hljs-built_in">with</span>
  | <span class="hljs-type">?a</span> * ?b -&gt; ?c =&gt; <span class="hljs-built_in">exact</span> (a -&gt; ltac:(currying (b -&gt; c)))
  | <span class="hljs-type">?a</span> =&gt; <span class="hljs-built_in">exact</span> a
  <span class="hljs-keyword">end</span>.

<span class="hljs-keyword">Ltac</span> fold_type b a r :=
  <span class="hljs-built_in">exact</span> (ltac:(currying (ltac:(fold_args b a r) -&gt; b -&gt; r))).
</code></pre>
<p>We use it to compute the type of a <code class="hljs language-coq"><span class="hljs-built_in">fold</span></code> function for <code class="hljs language-coq">list</code>.</p>
<pre><code class="hljs language-coq"><span class="hljs-keyword">Definition</span> fold_list_type (α β : <span class="hljs-keyword">Type</span>) : <span class="hljs-keyword">Type</span> :=
  ltac:(fold_type (list α) (unit + α * list α)%type β).
</code></pre>
<pre><code class="hljs language-coq">fold_list_type =
  <span class="hljs-keyword">fun</span> α β : <span class="hljs-keyword">Type</span> =&gt; β -&gt; (α -&gt; β -&gt; β) -&gt; list α -&gt; β
     : <span class="hljs-keyword">Type</span> -&gt; <span class="hljs-keyword">Type</span> -&gt; <span class="hljs-keyword">Type</span>
</code></pre>
<p>It is exactly what you could have expected (as match the type of
<code class="hljs language-coq">fold_right</code>).</p>
<p>Generating the body of the function is possible in theory, but probably not in
<code class="hljs">Ltac</code> without modifying a bit <code class="hljs language-coq">type_equiv</code>. This could be a nice
use case for <a href="https://github.com/MetaCoq/metacoq" marked="">MetaCoq&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a> though.</p>
        
      
