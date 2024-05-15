---
title: The latest release of Alt-Ergo version 2.5.1 is out, with improved SMT-LIB
  and bitvector support!
description: "We are happy to announce a new release of Alt\u2011Ergo (version 2.5.1).
  Alt-Ergo is a cutting-edge automated prover designed specifically for mathematical
  formulas, with a primary focus on advancing program verification.\nThis powerful
  tool is instrumental in the arsenal of static analysis solutions su..."
url: https://ocamlpro.com/blog/2023_09_18_release_of_alt_ergo_2_5_1
date: 2023-09-18T13:19:46-00:00
preview_image: URL_de_votre_image
authors:
- "\n    Pierre Villemot\n  "
source:
---

<p>

</p><div class="figure">
  <p>
    <a href="https://ocamlpro.com/blog/assets/img/ae-251-is-out.png">
      <img src="https://ocamlpro.com/blog/assets/img/ae-251-is-out.png" alt="Alt&#8209;Ergo: An Automated SMT Solver for Program Verification"/>
    </a>
    </p><div class="caption">
      Alt&#8209;Ergo: An Automated SMT Solver for Program Verification
    </div>
  
</div>

<p><strong>We are happy to announce a new release of Alt&#8209;Ergo (version 2.5.1).</strong></p>
<blockquote>
<p>Alt-Ergo is a cutting-edge automated prover designed specifically for mathematical formulas, with a primary focus on advancing program verification.</p>
<p>This powerful tool is instrumental in the arsenal of static analysis solutions such as Trust-In-Soft Analyzer and Frama-C. It accompanies other major solvers like CVC5 and Z3, and is part of the solvers used behind Why3, a platform renowned for deductive program verification.</p>
<p><strong>Find out more about Alt&#8209;Ergo and how to join the Alt-Ergo Users' Club <a href="https://alt-ergo.ocamlpro.com/#about">here</a>!</strong></p>
</blockquote>
<p>This release includes the following new features and improvements:</p>
<ul>
<li>support for bit-vectors in the SMT-LIB format;
</li>
<li>new SMT-LIB parser and typechecker;
</li>
<li>improved bit-vector reasoning;
</li>
<li>partial support for SMT-LIB commands <code>set-option</code> and <code>get-model</code>;
</li>
<li>simplified options to enable floating-point arithmetic theory;
</li>
<li>various bug fixes.
</li>
</ul>
<h3>Update for bug fixes</h3>
<p>Since writing this blog post, we have released Alt-Ergo version 2.5.2 which fixes an incorrect implementation of the <code>(distinct)</code> SMT-LIB operator when applied to more than two arguments, and a (rare) crash in model generation. We strongly advise users interested in SMT-LIB or model generation support upgrade to version 2.5.2 on OPAM.</p>
<h2>Better SMT-LIB Support</h2>
<p>This release includes a better support of the
<a href="https://smtlib.cs.uiowa.edu/papers/smt-lib-reference-v2.6-r2021-05-12.pdf">SMT-LIB standard v2.6</a>.
More precisely, the release contains:</p>
<ul>
<li>built-in primitives for the
<a href="https://smtlib.cs.uiowa.edu/theories-FixedSizeBitVectors.shtml">FixedSizeBitVectors</a>;
</li>
<li><a href="https://smtlib.cs.uiowa.edu/theories-Reals_Ints.shtml">Reals_Ints</a> theories
and the <a href="https://smtlib.cs.uiowa.edu/logics-all.shtml#QF_BV">QF_BV</a> logic;
</li>
<li>new fully-featured parsers and type-checkers for SMT-LIB and native Alt-Ergo languages;
</li>
<li>specific and meaningful messages for syntax and typing errors.
</li>
</ul>
<p>These features are powered by the
<a href="https://github.com/Gbury/dolmen">Dolmen Library</a> through
a new frontend alongside the legacy one. Dolmen, developed by our own Guillaume Bury,
is also used by the SMT community to check the conformity of the
<a href="https://smtlib.cs.uiowa.edu/benchmarks.shtml">SMT-LIB benchmarks</a>.</p>
<p><strong>Important</strong>:
In this release, the legacy frontend is still the default.
If you want to enable the new Dolmen frontend, use the option
<code>--frontend dolmen</code>. We encourage you to try it and report any bugs on our
<a href="https://github.com/OCamlPro/alt-ergo/issues">issue tracker</a>.</p>
<p><strong>Note</strong>: We plan to deprecate the legacy frontend and make Dolmen the default frontend in version <code>2.6.0</code>, and to fully remove the legacy frontend in version <code>2.7.0</code>.</p>
<h3>Support For Bit-Vectors Primitives</h3>
<p>Alt-Ergo has had support for bit-vectors in its native language for a long time,
but bit-vectors were not supported by the old SMT-LIB parser, and hence not
available in the SMT-LIB format. This has changed with the new Dolmen front-end,
and support for bit-vectors in the SMT-LIB format is now available starting with
Alt-Ergo 2.5.1!</p>
<p>The SMT-LIB theories for bit-vectors, <code>BV</code> and <code>QF_BV</code>, have more primitives than
those previously available in Alt-Ergo. Alt-Ergo 2.5.1 supports all the
primitives in the <code>BV</code> and <code>QF_BV</code> primitives when using the Dolmen frontend.
Alt-Ergo's reasoning capabilities on the new primitives are limited, and will
be gradually improved in future releases.</p>
<h3>Built-in Primitives For Mixed Integer And Real Problems</h3>
<p>In this release, we add the support for the
primitives <code>to_real</code>, <code>to_int</code> and <code>is_int</code> of the SMT-LIB theory
<a href="https://smtlib.cs.uiowa.edu/theories-Reals_Ints.shtml">Reals_Ints</a>.
Notice that the support is only avalaible through the Dolmen frontend.</p>
<h3>Example</h3>
<p>For instance, the input file <code>input.smt2</code>:</p>
<pre><code class="language-shell-session">(set-logic ALL)
(declare-const x Int)
(declare-const y Real)
(declare-fun f (Int Int) Int)
(assert (= (f x y) 0))
(check-sat)
</code></pre>
<p>with the command:</p>
<pre><code class="language-shell-session">alt-ergo --frontend dolmen input.smt2
</code></pre>
<p>produces the limpid error message:</p>
<pre><code class="language-shell-session">File &quot;input.smt2&quot;, line 5, character 11-18:
5 | (assert (= (f x y) 0))
               ^^^^^^^
Error The term: `y` has type `real` but was expected to be of type `int`
</code></pre>
<h2>Model Generation</h2>
<p>Generating models (also known as counterexamples) is highly appreciated by
users of SMT-solvers. Indeed, most builtin theories in common SMT-solvers
are incomplete. As a consequence, solvers can fail to discharge goals and,
without models, the SMT-solver behaves as a black box by outputting laconic
answers: <code>sat</code>, <code>unsat</code> or <code>unknown</code>.</p>
<p>Providing best-effort counterexamples assists developers
to understand why the solver failed to validate goals. If the goal isn't valid,
the solver should, as much as it can, output a correct counter-example that helps
users while fixing their specifications. If the goal is actually valid, the
generated model is wrong but it can help SMT-solver's maintainers to understand
why their solver didn't manage to discharge the goal.</p>
<p>Model generation for <code>LIA</code> theory and <code>enum</code> theory is available in Alt-Ergo.
The feature for other theories is either in testing phase or being implemented.
If you run into wrong models, please report them on our
<a href="https://github.com/OCamlPro/alt-ergo/issues">Github repository</a>.</p>
<h3>Usage</h3>
<p>The present release provides convenient ways to invoking models.
Notice that we change model invocation since the post
<a href="https://ocamlpro.com/blog/2022_11_16_alt-ergo-models/">Alt-Ergo: the SMT solver with model generation</a>
about model generation on the <code>next</code> development branch.</p>
<p>Check out the <a href="https://ocamlpro.github.io/alt-ergo/Usage/index.html#generating-models">documentation</a> for more details.</p>
<h2>Floating Point Support</h2>
<p>In version 2.5.1, the options to enable support for unbounded floating-point
arithmetic have been simplified. The options <code>--use-fpa</code> and
<code>--prelude fpa-theory-2019-10-08-19h00.ae</code> are gone: floating-point arithmetic
is now treated as a built-in theory and can be enabled with
<code>--enable-theories fpa</code>. We plan on enabling support for the FPA theory by default
in a future release.</p>
<h3>Usage</h3>
<p>To turn on the <code>fpa</code> theory, use the new option <code>--enable-theory fpa</code> as follows:</p>
<pre><code class="language-shell-session">alt-ergo --enable-theory fpa input.smt2
</code></pre>
<h2>About Alt-Ergo 2.5.0</h2>
<p>Version 2.5.0 should not be used, as it contains a soundness bug with the
new <code>bvnot</code> primitive that slipped through the cracks. The bug was found
immediately after the release, and version 2.5.1 released with a fix.</p>
<h2>Acknowledgements</h2>
<p>We thank members of the <a href="https://alt-ergo.ocamlpro.com/#club">Alt-Ergo Users' Club</a>: Thales, Trust-in-Soft, AdaCore, MERCE and the CEA.</p>
<p>We specially thank David Mentr&eacute; and Denis Cousineau at Mitsubishi Electric R&amp;D
Center Europe for funding the initial work on model generation.
Note that MERCE has been a Member of the Alt-Ergo Users' Club for three years.
This partnership allowed Alt-Ergo to evolve and we hope that more users will join
the Club on our journey to make Alt-Ergo a must-have tool.</p>
<p>
</p><div class="figure">
  <p>
    <a href="https://ocamlpro.com/blog/assets/img/clubAE.png">
      <img src="https://ocamlpro.com/blog/assets/img/clubAE.png" alt="The dedicated members of our Alt-Ergo Club!"/>
    </a>
    </p><div class="caption">
      The dedicated members of our Alt-Ergo Club!
    </div>
  
</div>


