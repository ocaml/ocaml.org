---
title: 'Release of Alt-Ergo 1.30 with experimental support for models generation '
description: "We have recently released a new (public up-to-date) version of Alt-Ergo.
  We focus in this article on its main new feature: experimental support for models
  generation. This work has been done with Fr\xE9d\xE9ric Lang, an intern at OCamlPro
  from February to July 2016. The idea behind models generation The..."
url: https://ocamlpro.com/blog/2016_11_21_release_of_alt_ergo_1_30_with_experimental_support_for_models_generation
date: 2016-11-21T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    Mohamed Iguernlala\n  "
source:
---

<p>We have recently released a new (public up-to-date) version of Alt-Ergo. We focus in this article on its main new feature: experimental support for models generation. This work has been done with <em>Fr&eacute;d&eacute;ric Lang</em>, an intern at OCamlPro from February to July 2016.</p>
<h3>The idea behind models generation</h3>
<p>The idea behind this feature is the following: when Alt-Ergo fails to prove the validity of a given formula <code>F</code>, it tries to compute and exhibit values for the terms of the problem that make the negation of <code>F</code> satisfiable. For instance, for the following example, written in Alt-Ergo's syntax,</p>
<pre><code class="language-ocaml">logic f : int -&gt; int
logic a, b : int
goal g:
(a &lt;&gt; b and f(a) &lt;= f(b) + 2*a) -&gt;
false
</code></pre>
<p>a possible (counter) model is <code>a = 1</code>, <code>b = 3</code>, <code>f(a) = 0</code>, and <code>f(b) = 0</code>. The solution is called a <code>candidate</code> model because universally quantified formulas are, in general, not taken into account. We talk about <code>counter example</code> or <code>counter model</code> because the solution falsifies (i.e. satisfies the negation of) <code>F</code>.</p>
<h3>Basic usage</h3>
<p>Models generation in Alt-Ergo is non-intrusive. It is controlled via a new option called <code>-interpretation</code>. This option requires an integer argument. The default value <code>0</code> disables the feature, and:</p>
<ul>
<li><code>-interpretation 1</code> triggers a model computation and display at the end of Alt-Ergo's execution (i.e. just before returning <code>I don't know</code>),
</li>
<li><code>-interpretation 2</code> triggers a model computation before each axioms instantiation round,
</li>
<li><code>-interpretation 3</code> is the most aggressive. It triggers a model computation before each Boolean decision in the SAT.
</li>
</ul>
<p>For the two latest strategies, the model will be displayed at the end of the execution if the given formula is not proved. Note that a negative argument (-1, -2, or -3) will enable model computation as explained above, but the result will not be displayed (useful for automatic testing). In addition, if Alt-Ergo timeouts, the latest computed model, if any, will be shown.</p>
<h3>Advanced usage</h3>
<p>If you are not on Windows, you will also be able to use option <code>-interpretation-timelimit</code> to try to get a candidate model even when Alt-Ergo hits a given time limit (set with option <code>-timelimit</code>). The idea is simple: if Alt-Ergo fails to prove validity during the time allocated for &quot;proof search&quot;, it will activate models generation and tries to get a counter example during the time allocated for that.</p>
<h3>Form of produced models</h3>
<p>Currently, models are printed in a syntax similar to SMT2's. We made this choice because Why3 already parses models in this format. For instance, Alt-Ergo outputs the following model for the example above:</p>
<pre><code class="language-ocaml">(
(a 1)
(b 3)
((f 3) 0)
((f 1) 0)
)
</code></pre>
<h3>Some known issues and limitations</h3>
<ul>
<li>
<p>For the moment, arrays are interpreted in term of the accesses that appear in the input formula, or that have been added internally by the decision procedure. In particular, a non-constrained array <code>arr</code> will probably be uninterpreted in the model (which would mean that it can have any well-typed value at any well-typed index).</p>
</li>
<li>
<p>Model generation may not terminate in presence of non-linear arithmetic. This is actually the case for the example
below (Alt-Ergo handles rationals, and there is no rational <code>x</code> such that <code>x * x = 2</code>). We plan to implement a <code>delta-completeness</code> like approach to stop splitting when intervals become really too small.
<code>goal g: forall x : real. x * x = 2. -&gt; false</code>.</p>
</li>
<li>
<p>Currently, we generate a model for the content of the decision procedures part. Since the SAT's model is (in general) partial in Alt-Ergo, some ground terms may be missing. Moreover, no filtering with labels mechanism is done for the moment.</p>
</li>
</ul>
<h3>Alt-Ergo 1.30 vs 1.20 vs 1.01 releases</h3>
<p>A quick comparison between this new version, the latest private release (1.20), and the latest public release (1.01) on our internal benchmarks is shown below. You notice that this version is faster and discharges more formulas.</p>
<table style="width: 746px; height: 359px;">
<tbody>
<tr>
<td style="width: 186px; text-align: center;"></td>
<td style="width: 175px; text-align: center;">Alt-Ergo 1.01</td>
<td style="width: 176.317px; text-align: center;">Alt-Ergo 1.20</td>
<td style="width: 170.683px; text-align: center;">Alt-Ergo 1.30</td>
</tr>
<tr>
<td style="width: 186px; text-align: center;">Why3 benchmarks
(9752 VCs)</td>
<td style="width: 175px; text-align: center;">88.36%
7310 seconds</td>
<td style="width: 176.317px; text-align: center;">89.23%
7155 seconds</td>
<td style="width: 170.683px; text-align: center;">89.57%
4553 seconds</td>
</tr>
<tr>
<td style="width: 186px; text-align: center;">SPARK benchmarks
(14442 VCs)</td>
<td style="width: 175px; text-align: center;">78.05%
3872 seconds</td>
<td style="width: 176.317px; text-align: center;">78.42%
3042 seconds</td>
<td style="width: 170.683px; text-align: center;">78.56%
2909  seconds</td>
</tr>
<tr>
<td style="width: 186px; text-align: center;"> BWare benchmarks
(12828 VCs)</td>
<td style="width: 175px; text-align: center;">97.38%
6373 seconds</td>
<td style="width: 176.317px; text-align: center;">98.02%
6907 seconds</td>
<td style="width: 170.683px; text-align: center;">98.31%
4231  seconds</td>
</tr>
</tbody>
</table>
<h3>Download, install and bugs report</h3>
<p>You can learn more about Alt-Ergo and download the latest version on <a href="https://alt-ergo.ocamlpro.com/">the solver's website</a>. You can also install it <a href="https://opam.ocaml.org/packages/alt-ergo/alt-ergo.1.30">via the OPAM package manager</a>. For bugs report, we recommend <a href="https://github.com/OCamlPro/alt-ergo/issues">Alt-Ergo's issues tracker on Github</a>.</p>
<p>Don't hesitate to give your feedback to help us improving Alt-Ergo. You can also contribute with benchmarks to diversify and enrich our internal test-suite.</p>

