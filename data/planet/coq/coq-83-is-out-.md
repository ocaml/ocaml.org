---
title: Coq 8.3 is out !
description:
url: https://coq.inria.fr/news/coq-83-is-out.html
date: 2010-10-14T16:45:00-00:00
preview_image:
featured:
authors:
- coq
---


<p>We are pleased to announce the final release of <a href="https://coq.inria.fr/download">Coq 8.3</a> which includes a new tactic (<code>nsatz</code>, standing for Hilbert's NullStellensatz, that extends <code>ring</code> to systems of polynomial equations) and a few new libraries (a certification of mergesort, a new library of finite sets with computational and logical contents separated).</p>
<p>This version also comes with many improvements of existing features, especially regarding the tactics, the module system, extraction, the type classes, the program command, libraries, coqdoc. Here is an excerpt:</p>
<ul>
<li>new operator <code>&lt;+</code> for conveniently chaining application of functors</li>
<li>new round of extension of the modular library of arithmetic</li>
<li>support for matching terms with binders in Ltac,</li>
<li>linking notations in coqdoc,</li>
<li>quote tactic now working on arbitrary expressions,</li>
<li><code>Lemma</code> and co accept parameters that are automatically introduced,</li>
<li>interactive proofs in module types,</li>
<li>a beautifying coqc option for pretty-printing files</li>
</ul>
<p>See the file <a href="https://coq.inria.fr/distrib/V8.3/CHANGES">CHANGES</a> for a full log of changes.</p>
<p>Even if we try to preserve compatibility as much as possible with Coq 8.2, we had to arbitrate for a break of behavior in some situations. The major incompatibilities can be easily treated by using the new <code>-compat 8.2</code> option or by setting/unsetting adequate options. See <a href="https://coq.inria.fr/distrib/V8.3/COMPATIBILITY">COMPATIBILITY</a> for details and migration recommendations.</p>
<p>In addition to the &quot;ssreflect&quot; plugin, extension packages we are aware about include the following (but probably there are more):</p>
<ul>
<li>the <code>Heq</code> library for smooth rewriting using heterogeneous equality by C.-K. Hur;</li>
<li>the <code>aac_tactics</code> plugin for rewriting modulo associativity and commutativity by T. Braibant and D. Pous.</li>
</ul>
<p>Note also the following user contributions submitted since 8.2 was released:</p>
<ul>
<li>Projective geometry in plane and space (N. Magaud, J. Narboux, P. Schreck)</li>
<li>Proofs of Quicksort's worst- and average-case complexity (Eelis)</li>
<li>Tactic that helps to prove inductive lemmas by fixpoint &quot;descente infinie&quot; functions (M. Li)</li>
<li>A tactic for deciding Kleene algebras (T. Braibant and D. Pous)</li>
</ul>
<p>If you want to try it, go to the <a href="https://coq.inria.fr/download">download</a> page.</p>
<p>The Coq development team</p>

 
