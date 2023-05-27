---
title: New draft on Normalization by Evaluation using GADTs
description: "There is a new draft on my web page! It is called Tagless and Typeful
  Normalization by Evaluation using Generalized Algebraic Data Types, which is a mouthful,
  but only describes accurately the cool\u2026"
url: https://syntaxexclamation.wordpress.com/2013/10/29/new-draft-on-normalization-by-evaluation-using-gadts/
date: 2013-10-29T13:10:26-00:00
preview_image: https://s0.wp.com/i/blank.jpg
featured:
authors:
- syntaxexclamation
---

<p>There is a <a href="http://cs.au.dk/~mpuech/typeful.pdf" title="Tagless and Typeful Normalization by Evaluation using Generalized Algebraic Data Types">new draft</a> on my web page! It is called <em>Tagless and Typeful Normalization by Evaluation using Generalized Algebraic Data Types</em>, which is a mouthful, but only describes accurately the cool new OCaml development we elaborated together with <a href="http://www.cs.au.dk/~danvy/" title="Olivier Danvy">Olivier</a> and <a href="http://cs.au.dk/~chkeller" title="Chantal Keller">Chantal</a>. The world of Normalization by Evaluation (NbE) is still relatively new to me, but its wonders keep amazing me. It&rsquo;s a program specialization algorithm&hellip; no, it&rsquo;s a completeness proof for first-order logic&hellip; wait, it&rsquo;s a technique to turn an interpreter into a compiler! Definitely, Aarhus University, my new home, is not the worst place to learn about it.</p>
<p>Since the introduction of GADTs in OCaml, a whole new realm of applications emerged, the most well-known being to faithfully represent typed languages: it allows to define compact and correct interpreters, and type-preserving program transformations. Ok, if you never saw this, here is a small snippet that should be self-explanatory:</p>
<pre class="brush: fsharp; title: ; notranslate">
type _ exp =
  | Val : 'a -&gt; 'a exp
  | Eq : 'a exp * 'a exp -&gt; bool exp
  | Add : int exp * int exp -&gt; int exp

let rec eval : type a. a exp -&gt; a = function
  | Val x -&gt; x
  | Eq (e1, e2) -&gt; eval e1 = eval e2
  | Add (e1, e2) -&gt; eval e1 + eval e2
;;
assert (eval (Eq (Add (Val 2, Val 2), Val 4)))
</pre>
<p>Nice, isn&rsquo;t it? Our question was: if we can so beautifully go from typed syntax (expressions) to typed semantics (OCaml values), can we do the converse, i.e., go from an OCaml value back to a (normal) expression of the same type? In other words, can we implement NbE in a typeful manner, using GADTs?</p>
<p>The answer is a proud &ldquo;yes&rdquo;, but more interestingly, we all learned some interesting GADT techniques and puzzling logical interpretations on the way. Read on to know more!</p>
<blockquote><p><a href="http://cs.au.dk/~mpuech/typeful.pdf"><strong>Tagless and Typeful Normalization by Evaluation using Generalized Algebraic Data Types</strong></a></p>
<p>We present the first tagless and typeful implementation of normalization by evaluation for the simply typed &lambda;-calculus in OCaml, using Generalized Algebraic Data Types (GADTs). In contrast to normalization by reduction, which is operationally carried out by repeated instances of one-step reduction, normalization by evaluation uses a non-standard model to internalize intermediate results: it is defined by composing a non-standard evaluation function with a reification function that maps the denotation of a term into the normal form of this term. So far, normalization by evaluation has been implemented either in dependently-typed languages such as Coq or Agda, or in general-purpose languages such as Scheme, ML or Haskell. In the latter case, denotations are either tagged or Church-encoded. Tagging means injecting denotations, either implicitly or explicitly, into a universal domain of values; Church encoding is based on the impredicativity of the metalanguage. Here, we show how to obtain not only tagless values, making evaluation efficient, but also typeful reification, guaranteeing type preservation and &eta;-long, &beta;-normal forms. To this end, we put OCaml&rsquo;s GADTs to work. Furthermore, our implementation does not depend on any particular representation of binders (HOAS, de Bruijn levels or indices) nor on the style (direct style, continuation-passing style, etc.) of the non-standard evaluation function.</p></blockquote>
<p>PS: My previous draft, <a href="https://syntaxexclamation.wordpress.com/2013/06/17/new-draft-proofs-upside-down/" title="New draft: Proofs, upside&nbsp;down">Proofs, upside down</a> was accepted for presentation at <a href="http://aplas2013.soic.indiana.edu/" title="APLAS 2013">APLAS 2013</a>. See you in Melbourne!</p>

