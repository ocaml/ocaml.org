---
title: 'Alt-Ergo: the SMT solver with model generation'
description: 'The Alt-Ergo automatic theorem prover developed at OCamlPro has just
  been released with a major update : counterexample model can now be generated. This
  is now available on the next branch, and will officially be part of the 2.5.0 release,
  coming this year ! Alt-Ergo at a Glance Alt-Ergo is an open ...'
url: https://ocamlpro.com/blog/2022_11_16_alt-ergo-models
date: 2022-11-16T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    Steven de Oliveira\n  "
source:
---

<p>The Alt-Ergo automatic theorem prover developed at OCamlPro has just been released with a major update : counterexample model can now be generated. This is now available on the next branch, and will officially be part of the 2.5.0 release, coming this year !</p>
<h3>Alt-Ergo at a Glance</h3>
<p><a href="https://alt-ergo.ocamlpro.com">Alt-Ergo</a> is an open source automatic theorem prover based on the <a href="https://en.wikipedia.org/wiki/Satisfiability_Modulo_Theories">SMT</a> technology. It was born at the <a href="https://www.lri.fr">Laboratoire de Recherche en Informatique</a>, <a href="https://www.inria.fr/centre/saclay">Inria Saclay Ile-de-France</a> and <a href="https://www.cnrs.fr/index.php">CNRS</a> in 2006 and has been maintained and developed by OCamlPro since 2013.</p>
<p></p>
<p>It is capable of reasoning in a combination of several built-in theories such as:</p>
<ul>
<li>uninterpreted equality;
</li>
<li>integer and rational arithmetic;
</li>
<li>arrays;
</li>
<li>records;
</li>
<li>algebraic data types;
</li>
<li>bit vectors.
</li>
</ul>
<p>It also is able to deal with commutative and associative operators, quantified formulas and has a polymorphic first-order native input language.
Alt-Ergo is written in <a href="https://caml.inria.fr/ocaml/index.fr.html">OCaml</a>. Its core has been formally proved in the <a href="https://coq.inria.fr">Coq proof assistant</a>.</p>
<p>Alt-Ergo has been involved in a qualification process (DO-178C) by <a href="http://www.airbus.com">Airbus Industrie</a>. During this process, a qualification kit has been produced. It was composed of a technical document with tool requirements (TR) that gives a precise description of each part of the prover, a companion document (~ 450 pages) of tests, and an instrumented version of the tool with a TR trace mechanism.</p>
<h3>Model Generation</h3>
<p>When a property is false, generating a counterexample is a key that many state-of-the-art SMT-solvers should include by default. However, this is a complex problem in the first place.</p>
<p>The first obstacle is the decidability of the theories manipulated by the SMT solvers. In general, the complexity class (i.e. the classification of algorithmic problems) is between &quot;NP-Hard&quot; (for the linear arithmetic theory on integers for example) and &quot;Undecidable&quot; (for the polynomial arithmetic on integers for example). Then comes the quantified properties, i.e. properties prefixed with <code>forall</code>s and <code>exists</code>, adding an additional layer of complexity and undecidability. Another challenge was the core algorithm behind Alt-Ergo which does not natively support model generation. At last, an implementation of the models have to take care of Alt-Ergo's support of polymorphism.</p>
<h3>How to use Model Generation in Alt-Ergo</h3>
<p>There are two ways to activate model generation on Alt-Ergo.</p>
<ul>
<li>Basic usage: simply add the option <code>--model</code> to your command (<code>$ alt-ergo file --model</code>)
</li>
<li>Advanced usage: three options mainly impact the model generation.
<ul>
<li>
<p><code>--interpretation</code>: sets the model generation strategy. It can either be
<code>none</code> for no model generation; <code>first</code> for generating the very first
interpretation computed only; <code>every</code> for generating a
model after each decision and <code>last</code> only generating a model when <code>alt-ergo</code>
concludes on the formula satisfiability.</p>
</li>
<li>
<p><code>--sat-solver</code>: only the 'Tableaux-CDCL' sat solver is compatible with the
interpretation feature</p>
</li>
<li>
<p><code>--instantiation-heuristic</code>: when set to <code>normal</code>, <code>alt-ergo</code> generates model
faster. This is an experimental feature that sometimes generates incorrect
models.</p>
<p>Example:</p>
<p><code>$ alt-ergo file --interpretation every --sat-solver Tableaux-CDCL --instantiation-heuristic auto</code></p>
</li>
</ul>
</li>
</ul>
<p><em>Warning:</em> only the linear arithmetic and the enum model generation have been
tested. Other theories are either not implemented (ADTs) or experimental (risk
of crash or unsound models). We are currently still heavily testing the
feature, so feel free to join us on
<a href="https://ocamlpro.com/blog/github.com/OcamlPro/alt-ergo">Alt-Ergo's GitHub repository</a> if you have
questions or issues with this new feature.
Note that the models generated are best-effort models; Alt-Ergo
does not answer <code>Sat</code> when it outputs a model. In a future version, we will add
a mechanism that automatically checks the model generated.</p>
<p>Godspeed!</p>
<h3>Acknowledgements</h3>
<p>We want to thank David Mentr&eacute; and Denis Cousineau at <a href="https://www.mitsubishielectric-rce.eu/merce-in-france/">Mitsubishi Electric R&amp;D Center Europe</a>
for funding the initial work on counterexample.</p>
<p>Note that MERCE has been a Member of the Alt-Ergo Users&rsquo; Club for 3 years.
This partnership allowed Alt-Ergo to evolve and we hope that more users
will join the Club on our journey to make Alt-Ergo a must-have tool.
Please do not hesitate to contact the Alt-Ergo team at OCamlPro:
<a href="mailto:alt-ergo@ocamlpro.com">alt-ergo@ocamlpro.com</a>.</p>

