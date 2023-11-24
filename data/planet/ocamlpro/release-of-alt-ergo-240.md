---
title: Release of Alt-Ergo 2.4.0
description: 'A new release of Alt-Ergo (version 2.4.0)  is available. You can get
  it from Alt-Ergo''s website. The associated opam package will be published in the
  next few days. This release contains some major novelties: Alt-Ergo supports incremental
  commands (push/pop) from the smt-lib standard.

  We switched co...'
url: https://ocamlpro.com/blog/2021_01_22_release_of_alt_ergo_2_4_0
date: 2021-01-22T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    Albin Coquereau\n  "
source:
---

<p>A new release of Alt-Ergo (version 2.4.0)  is available.</p>
<p>You can get it from <a href="https://alt-ergo.ocamlpro.com/">Alt-Ergo's website</a>. The associated opam package will be published in the next few days.</p>
<p>This release contains some major novelties:</p>
<ul>
<li>Alt-Ergo supports incremental commands (push/pop) from the <a href="https://smtlib.cs.uiowa.edu/">smt-lib </a>standard.
</li>
<li>We switched command line parsing to use <a href="https://erratique.ch/software/cmdliner">cmdliner</a>. You will need to  use <code>--&lt;option name&gt;</code> instead of <code>-&lt;option name&gt;</code>. Some options have also been renamed, see the manpage or the documentation.
</li>
<li>We improved the online documentation of your solver, available <a href="https://ocamlpro.github.io/alt-ergo/">here</a>.
</li>
</ul>
<p>This release also contains  some minor novelties:</p>
<ul>
<li><code>.mlw</code> and <code>.why</code> extension are depreciated, the use of <code>.ae</code> extension is advised.
</li>
<li>Add <code>--input</code> (resp <code>--output</code>) option to manually set the input (resp output) file format
</li>
<li>Add <code>--pretty-output</code> option to add better debug formatting and to add colors
</li>
<li>Add exponentiation operation, <code>**</code> in native Alt-Ergo syntax. The operator is fully interpreted when applied to constants
</li>
<li>Fix <code>--steps-count</code> and improve the way steps are counted (AdaCore contribution)
</li>
<li>Add <code>--instantiation-heuristic</code> option that can enable lighter or heavier instantiation
</li>
<li>Reduce the instantiation context (considered foralls / exists) in CDCL-Tableaux to better mimic the Tableaux-like SAT solver
</li>
<li>Multiple bugfixes
</li>
</ul>
<p>The full list of changes is available <a href="https://ocamlpro.github.io/alt-ergo/About/changes.html">here</a>. As usual, do not hesitate to report bugs, to ask questions, or to give your feedback!</p>

