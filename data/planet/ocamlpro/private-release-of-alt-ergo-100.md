---
title: Private Release of Alt-Ergo 1.00
description: 'altergo logo After the public release of Alt-Ergo 0.99.1 last December,
  it''s time to announce a new major private version (1.00) of our SMT solver. As
  usual: we freely provide a JavaScript version on Alt-Ergo''s website

  we provide a private access to our internal repositories for academia users and
  o...'
url: https://ocamlpro.com/blog/2015_01_29_private_release_of_alt_ergo_1_00
date: 2015-01-29T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    Mohamed Iguernlala\n  "
source:
---

<p><img src="https://ocamlpro.com/blog/assets/img/logo_alt_ergo.png" alt="altergo logo"/></p>
<p>After the public release of Alt-Ergo 0.99.1 last December, it's time to announce a new major private version (1.00) of our SMT solver. As usual:</p>
<ul>
<li>we freely provide a JavaScript version on Alt-Ergo's website
</li>
<li>we provide a private access to our internal repositories for academia users and our clients.
</li>
</ul>
<h3>Quick Evaluation</h3>
<p>A quick comparison between this new version and the previous releases is given below. Timeout is set to 60 seconds. The benchmark is made of 19044 formulas: (a) some of these formulas are known to be invalid, and (b) some of them are out of scope of current SMT solvers. The results are obtained with Alt-Ergo's native input language.</p>
<table class="tableau" style="font-size: 90%; width: 100%;">
<thead>
<tr>
<td></td>
<th>public release<br/>
0.95.2</th>
<th>public release<br/>
0.99.1</th>
<th>private release<br/>
1.00</th>
</tr>
</thead>
<tbody>
<tr>
<th>Proved Valid</th>
<td>15980</td>
<td>16334</td>
<td>17638</td>
</tr>
<tr>
<th>Proved Valid (%)</th>
<td>84,01 %</td>
<td>85,77 %</td>
<td>92,62 %</td>
</tr>
<tr>
<th>Required time (seconds)</th>
<td>10831</td>
<td>10504</td>
<td>9767</td>
</tr>
<tr>
<th>Average speed<br/>
(valid formulas per second)</th>
<td>1,47</td>
<td>1,55</td>
<td>1,81</td>
</tr>
</tbody>
</table>
<h3>Main Novelties of Alt-Ergo 1.00</h3>
<h4>General Improvements</h4>
<ul>
<li>theories data structures: semantic values (internal theories representation of terms) are now hash-consed. This enables the use of hash-based comparison (instead of structural comparison) when possible
</li>
<li>theories combination: the dispatcher component, that sends literals assumed by the SAT solver to different theories depending on whether these literals are equalities, disequalities or inequalities, has been re-implemented. The new code is much more simpler and enables some optimizations and factorizations that could not be made before
</li>
<li>case-split analysis: we made several improvements in the heuristics of the case-split analysis mechanism over finite domains
</li>
<li>explanations propagation: we improved explanations propagation in congruence closure and linear arithmetic algorithms. This makes the proofs faster thanks to a better back-jumping in the SAT solver part
</li>
<li>linear integer arithmetic: we re-implemented several parts of linear arithmetic and introduced important improvements in the Fourier-Motzkin algorithm to make it run on smaller sub-problems and avoid some useless executions. These optimizations allowed a significant speed up on our internal benchmarks
</li>
<li>data structures: we optimized hash-consing and some functions in the &quot;formula&quot; and &quot;literal&quot; modules
</li>
<li>SAT solving: we made a lot of improvements in the default SAT-solver and in the SatML plugin. In particular, the solvers now send lists of facts (literals) to &quot;the decision procedure part&quot; instead of sending them one by one. This avoids intermediate calls to some &quot;expensive&quot; algorithms, such as Fourier-Motzkin
</li>
<li>Matching: we extended the E-matching algorithm to also perform matching modulo the theory of records. In addition, we simplified matching heuristics and optimized the E-matching process to avoid computing the same instances several times
</li>
<li>Memory management: thanks to the ocp-memprof tool (http://memprof.typerex.org/), we identified some parts of Alt-Ergo that needed some improvements in order to avoid useless memory allocations, and thus unburden the OCaml garbage collector
</li>
<li>the function that retrieves the used axioms and predicates (when option 'save-used-context' is activated) has been improved
</li>
</ul>
<h4>Bug Fixes</h4>
<ul>
<li>6 in the &quot;inequalities&quot; module of linear arithmetic
</li>
<li>4 in the &quot;formula&quot; module
</li>
<li>3 in the &quot;ty&quot; module used for types representation and manipulation
</li>
<li>2 in the &quot;theories front-end&quot; module that interacts with the SAT solvers
</li>
<li>1 in the &quot;congruence closure&quot; algorithm
</li>
<li>1 in &quot;existential quantifiers elimination&quot; module
</li>
<li>1 in the &quot;type-checker&quot;
</li>
<li>1 in the &quot;AC theory&quot; of associative and commutative function symbols
</li>
<li>1 in the &quot;union-find&quot; module
</li>
</ul>
<h4>New OCamlPro Plugins</h4>
<ul>
<li>profiling plugin: when activated, this plugin records and prints some information about the current execution of Alt-Ergo every 'x' seconds: In particular, one can observe a module being activated, a function being called, the amount of time spent in every module/function, the current decision/instantiation level, the number of decisions/instantiations that have been made so far, the number of case-splits, of boolean/theory conflicts, of assumptions in the decision procedure, of generated instances per axiom, &hellip;.
</li>
<li>fm-simplex plugin: when activated, this plugin is used instead of the Fourier-Motzkin method to infer bounds for linear integer arithmetic affine forms (which are used in the case-split analysis process). This module uses the Simplex algorithm to simulate particular runs of Fourier-Motzkin, which makes it scale better on linear integer arithmetic problems containing a lot of inequalities
</li>
</ul>
<h4>New Options</h4>
<ul>
<li>
<p>version-info: prints some information about this version of Alt-Ergo (release and compilation dates, release commit ID)</p>
</li>
<li>
<p>no-theory: deactivate theory reasoning. In this case, only the SAT-solver and the matching parts are working</p>
</li>
<li>
<p>inequalities-plugin: specify a plugin to use, instead of the &quot;default&quot; Fourier-Motzkin algorithm, to handle inequalities of linear arithmetic</p>
</li>
<li>
<p>tighten-vars: when this option is set, the Fm-Simplex plugin will try to infer bounds for integer variables as well. Note that this option may be very expensive</p>
</li>
<li>
<p>profiling-plugin: specify a profiling plugin to use to monitor an execution of Alt-Ergo</p>
</li>
<li>
<p>profiling <freq>: makes the profiling module prints its information every <freq> seconds</freq></freq></p>
</li>
<li>
<p>no-tcp: deactivate constraints propagation modulo theories</p>
</li>
</ul>
<h4>Removed Capabilities</h4>
<ul>
<li>the pruning module used in the frontend is now removed
</li>
<li>the SMT and SMT2 front-ends are removed. We plan to implement a new front-end for SMT2 in upcoming releases
</li>
</ul>

