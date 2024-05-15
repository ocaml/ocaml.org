---
title: What's new for Alt-Ergo in 2018? Here is a recap!
description: "After the hard work done on the integration of floating-point arithmetic
  reasoning two years ago, 2018 is the year of polymorphic SMT2 support and efficient
  SAT solving for Alt-Ergo. In this post, we recap the main novelties last year, and
  we announce the first Alt-Ergo Users\u2019 Club meeting. An SMT..."
url: https://ocamlpro.com/blog/2019_02_11_whats_new_for_alt_ergo_in_2018_here_is_a_recap
date: 2019-02-11T13:19:46-00:00
preview_image: URL_de_votre_image
authors:
- "\n    Mohamed Iguernlala\n  "
source:
---

<p>After the hard work done on the integration of floating-point arithmetic reasoning two years ago, 2018 is the year of polymorphic SMT2 support and efficient SAT solving for Alt-Ergo. In this post, we recap the main novelties last year, and we announce the first Alt-Ergo Users&rsquo; Club meeting.</p>
<h2>An SMT2 front-end with prenex polymorphism</h2>
<p>As you may know, Alt-Ergo&rsquo;s native input language is not compliant with the SMT-LIB 2 input language standard, and translating formulas from SMT-LIB 2 to Alt-Ergo&rsquo; syntax (or vice-versa) is not immediate. Besides its extension with polymorphism, this native language diverges from SMT-LIB&rsquo;s by distinguishing terms of type <code>boolean</code> from formulas (that are <code>propositions</code>). This distinction makes it hard, for instance, to efficiently translate <code>let-in</code> and <code>if-then-else</code> constructs that are ubiquitous in SMT-LIB 2 benchmarks.</p>
<p>In order to work closely with the SMT community, we designed a conservative extension of the SMT-LIB 2 standard with <code>prenex polymorphism</code> and implemented it as a new frontend in Alt-Ergo 2.2. This work has been published in the 2018 edition of the SMT-Workshop. An online version of the paper is <a href="https://hal.inria.fr/hal-01960203">available here</a>. Experimental results showed that polymorphism is really important for Alt-Ergo, as it allows to improve both resolution rate and resolution time (see Figure 5 in the paper for more details).</p>
<h2>Improved SAT solvers</h2>
<p>We also worked on improving SAT-solving in Alt-Ergo last year. The main direction towards this goal was to extend our CDCL-based SAT solver to mimic some desired behaviors of the native Tableaux-like SAT engine. Generally speaking, this allows a better management of the context during proof search, which prevents from overwhelming theories and instantiation engines with useless facts. A comparison of this solver with Alt-Ergo&rsquo;s old Tableaux-like solver is also done in our SMT-Workshop paper.</p>
<h2>SMT-Comp and SMT-Workshop 2018</h2>
<p>As emphasized above, we published our work regarding polymorphic SMT2 and SAT solving in SMT-Workshop 2018. More generally, this was an occasion for us to write the first tool paper about Alt-Ergo, and to highlight the main features that make it different from other state-of-the-art SMT solvers like CVC4, Z3 or Yices.</p>
<p>Thanks to our new SMT2 frontend, we were able to participate to the SMT-Competition last year. Naturally, we selected categories that are close to &ldquo;deductive program verification&rdquo;, as Alt-Ergo is primarily tuned for formulas coming from this application domain.</p>
<p>Although Alt-Ergo <a href="http://smtcomp.sourceforge.net/2018/results-summary.shtml?v=1531410683">did not rank first</a>, it was a positive experience and this encourages us to go ahead. Note that Alt-Ergo&rsquo;s brother, Ctrl-Ergo, was not far from winning <a href="http://smtcomp.sourceforge.net/2018/results-QF_LIA.shtml">the QF-LIA category</a> of the competition. This performance is partly due to the improvements in the CDCL SAT solver that were also integrated in Ctrl-Ergo.</p>
<h2>Alt-Ergo for Atelier-B</h2>
<p><a href="https://www.atelierb.eu/en/">Atelier-B</a> is a framework that allows to develop formally verified software using <a href="https://www.methode-b.com/en/b-method/">the B Method</a>. The framework rests on an automatic reasoner that allows to discharges thousands of mathematical formulas extracted from B models. If a formula is not discharged automatically, it is proved interactively. <a href="https://www.clearsy.com/en/">ClearSy</a> (the company behind development of Atelier-B) has recently added a new backend to produce verification conditions in Why3&rsquo;s logic, in order to target more automatic provers and increase automation rate. For certifiability reasons, we extended Alt-Ergo with a new frontend that is able to directly parse these verification conditions without relying on Why3.</p>
<h2>Improved hash-consed data-structures</h2>
<p>As said above, Alt-Ergo makes a clear distinction between Boolean terms and Propositions. This distinction prevents us from doing some rewriting and simplifications, in particular on expressions involving <code>let-in</code> and <code>if-then-else</code> constructs. This is why we decided to merge <code>Term</code>, <code>Literal</code>, and <code>Formula</code> in a new <code>Expr</code> data-structure, and remove this distinction. This allowed us to implement some additional simplification steps, and we immediately noticed performance improvements, in particular on SMT2 benchmarks. For instance, Alt-Ergo 2.3 proves 19548 formulas of AUFLIRA category in ~350 minutes, while version 2.2 proves 19535 formulas in ~1450 minutes (time limit was set to 20 minutes per formula).</p>
<h2>Towards the integration of algebraic datatypes</h2>
<p>Last Autumn, we also started working on the integration of algebraic datatypes reasoning in Alt-Ergo. In this first iteration, we extended Alt-Ergo&rsquo;s native language to be able to declare (mutually recursive) algebraic datatypes, to write expressions with patterns matching, to handle selectors, &hellip; We then extended the typechecker accordingly and implemented a (not that) basic theory reasoner. Of course, we also handle SMT2&rsquo;s algebraic datatypes. Here is an example in Alt-Ergo&rsquo;s native syntax:</p>
<pre><code class="language-OCaml">type ('a, 'b) t = A of {a_1 : 'a} | B of {b_11 : 'a ; b12 : 'b} | C | D | E

logic e : (int, real) t
logic n : int

axiom ax_n : n &amp;gt;= 9

axiom ax_e:
  e = A(n) or e = B(n*n, 0.) or e = E

goal g:
  match e with
   | A(u) -&gt; u &gt;= 8
   | B (u,v) -&gt; u &gt;= 80 and v = 0.
   | E -&gt; true
   | _ -&gt; false
  end
  and 3 &lt;= 2+2
</code></pre>
<h2>What is planned in 2019 and beyond: the Alt-Ergo&rsquo;s Users&rsquo; Club is born!</h2>
<p>In 2018, we welcomed a lot of new engineers with a background in formal methods: Steven (De Oliveira) holds a PhD in formal verification from the Paris-Saclay University and the French Atomic Energy Commission (CEA). He has a master in cryptography and worked in the Frama-C team, developing open-source tools for verifying C programs. David (Declerck) obtained a PhD from Universit&eacute; Paris-Saclay in 2018, during which he extended the Cubicle model checker to support weak memory models and wrote a compiler from a subset of the x86 assembly language to Cubicle. Guillaume (Bury) holds a PhD from Universit&eacute; Sorbonne Paris Cit&eacute;. He studied the integration of rewriting techniques inside SMT solvers. Albin (Coquereau) is working as a PhD student between OCamlPro, LRI and ENSTA, focusing on improving the Alt-Ergo SMT solver. Adrien is interested in verification of safety properties over software and embedded systems. He worked on higher-order functional program verification at the University of Tokyo, and on the Kind 2 model checker at the University of Iowa. All these people will consolidate the department of formal methods at OCamlPro, which will be beneficial for Alt-Ergo.</p>
<p>In 2019 we just launched the Alt-Ergo Users&rsquo; Club, in order to get closer to our users, collect their needs, and integrate them into the Alt-Ergo roadmap, but also to ensure sustainable funding for the development of the project. We are happy to announce the very first member of the Club is <a href="https://www.adacore.com">Adacore</a>, very soon to be followed by <a href="https://trust-in-soft.com">Trust-In-Soft</a> and <a href="http://www-list.cea.fr/en/">CEA List</a>. Thanks for your early support!</p>
<blockquote>
<p>Interested to join? Contact us: contact@ocamlpro.com</p>
</blockquote>

