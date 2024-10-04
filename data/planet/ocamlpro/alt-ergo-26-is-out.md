---
title: Alt-Ergo 2.6 is Out!
description: We are excited to announce the release of Alt-Ergo 2.6! Alt-Ergo is an
  open-source automated prover used for formal verification in software development.
  It is part of the arsenal behind static analysis frameworks such as TrustInSoft
  Analyzer and Frama-C, and is one of the solvers behind Why3, a pla...
url: https://ocamlpro.com/blog/2024_09_01_alt_ergo_2_6_0_released
date: 2024-09-30T13:48:57-00:00
preview_image: https://ocamlpro.com/blog/assets/img/alt-ergo-8-colors.png
authors:
- "\n    Basile Cl\xE9ment\n  "
source:
---

<p></p>
<p>
</p><div class="figure">
  <p>
    <a href="https://ocamlpro.com/blog/assets/img/alt-ergo-8-colors-blank-bg.png">
      <img src="https://ocamlpro.com/blog/assets/img/alt-ergo-8-colors-blank-bg.png" alt="The Alt-Ergo 2.6 release comes with many enhancements!">
    </a>
    </p><div class="caption">
      The Alt-Ergo 2.6 release comes with many enhancements!
    </div>
  <p></p>
</div>
<p></p>
<p><strong>We are excited to announce the release of Alt-Ergo 2.6!</strong></p>
<p>Alt-Ergo is an open-source automated prover used for formal verification in
software development. It is part of the arsenal behind static analysis
frameworks such as TrustInSoft Analyzer and Frama-C, and is one of the
solvers behind Why3, a platform for deductive program verification. The newly
released version 2.6 brings new features and performance improvements.</p>
<p>Development on Alt-Ergo has accelerated significantly this past year, thanks to
the launch of the <a href="https://decysif.fr/en/">DéCySif</a> joint research project (i-Démo)
with AdaCore, Inria, OCamlPro and TrustInSoft. The improvements to bit-vectors
and algebraic data types in this release are sponsored by the Décysif project.</p>
<p>The highlights of Alt-Ergo 2.6 are:</p>
<ul>
<li>Support for reasoning and model generation with bit-vectors
</li>
<li>Model generation for algebraic data types
</li>
<li>Optimization with <code>(maximize)</code> and <code>(minimize)</code>
</li>
<li>FPA support is enabled by default and available in SMT-LIB format
</li>
<li>Binary releases now on GitHub
</li>
</ul>
<p>Alt-Ergo 2.6 also includes other improvements to the user interface (notably
the <code>set-option</code> SMT-LIB command), use of Dolmen as the default frontend for
SMT-LIB and native input, and many bug fixes.</p>
<h3>Bit-vectors</h3>
<p>In Alt-Ergo 2.5, we introduced built-in functions for the bit-vector
primitives from the SMT-LIB standard, but only provided limited reasoning
support. For Alt-Ergo 2.6, we set out to improve this reasoning support, and
have developed a new and improved relational theory for bit-vectors. This new
theory is based on an also new constraint propagation core that draws heavily
on the architecture of the Colibri solver (as in <a href="https://cea.hal.science/cea-01795779">Sharpening Constraint
Programming approaches for Bit-Vector Theory</a>), integrated into Alt-Ergo's
existing normalizing Shostak solver.</p>
<p>Bit-vectors are commonly used in verification of low-level code and in
cryptography, so improved support significantly enhances Alt-Ergo’s
applicability in these domains.</p>
<p>There are still areas of improvements, so please share any issue you encounter
with the bit-vector theory (or Alt-Ergo in general) via our
<a href="https://github.com/ocamlpro/alt-ergo/issues">issue tracker</a>.</p>
<p>To showcase improvements in Alt-Ergo 2.6, we compared it against the version
2.5 and industry-leading solvers Z3 and CVC5 on a dataset of bit-vector
problems collected from our partners in the DéCySif project. The (no BV)
variants for Alt-Ergo do not use the new bit-vector theory but instead an
axiomatization of bit-vector primitives provided by Why3. The percentages
represent the proportion of bit-vector problems solved successfully in each
configuration.</p>
<table class="table">
  <thead>
    <tr class="table-light text-center">
      <th scope="col"></th>
      <th scope="col" colspan="2">AE 2.5</th>
      <th scope="col" colspan="2">AE 2.6</th>
      <th scope="col">Z3 (4.12.5)</th>
      <th scope="col">CVC5 (1.1.2)</th>
      <th scope="col">Total</th>
    </tr>
    <tr>
      <th scope="row"></th>
      <td>(BV)</td>
      <td>(no BV)</td>
      <td>(BV)</td>
      <td>(no BV)</td>
      <td></td>
      <td></td>
      <td></td>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th scope="row">#</th>
      <td>4128</td>
      <td>4870</td>
      <td>6265</td>
      <td>4940</td>
      <td>5482</td>
      <td>7415</td>
      <td>9038</td>
    </tr>
    <tr>
      <th scope="row">%</th>
      <td>46%</td>
      <td>54%</td>
      <td>69%</td>
      <td>54%</td>
      <td>61%</td>
      <td>82%</td>
      <td>100%</td>
    </tr>
  </tbody>
</table>
<p>As the table shows, Alt-Ergo 2.6 significantly outperforms version 2.5, and the
new built-in bit-vector theory outperforms Why3's axiomatization. We even
surpass Z3 on this benchmark, a testament to the new bit-vector theory in
Alt-Ergo 2.6.</p>
<h3>Model Generation</h3>
<p>Bit-vector is not the only theory Alt-Ergo 2.6 improves upon. Model generation
was introduced in Alt-Ergo 2.5 with support for booleans, integers, reals,
arrays, enumerated types, and records. Alt-Ergo 2.6 extends this support to
bit-vector and arbitrary algebraic data types, which means that model
generation is now enabled for all the theories supported by Alt-Ergo.</p>
<p>Model generation allows users to extract concrete examples or counterexamples,
aiding in debugging and verification of their systems.</p>
<p>Model generation is also more robust in Alt-Ergo 2.6, with numerous bug fixes
and improvements for edge cases.</p>
<h3>Optimization</h3>
<p>Alt-Ergo 2.6 introduces optimization capabilities, available via SMT-LIB input
using OptiSMT primitives such as <code>(minimize)</code> and <code>(maximize)</code> and compatible
with Z3 and OptiMathSat. Optimization allows guiding the solver towards simpler
and smaller counterexamples, helping users find more concrete and realistic
scenarios to trigger a bug.</p>
<p>See some
<a href="https://ocamlpro.github.io/alt-ergo/latest/Optimization.html">examples</a> in the
documentation.</p>
<h3>SMT-LIB command support</h3>
<p>Alt-Ergo 2.6 supports more SMT-LIB syntax and commands, such as:</p>
<ul>
<li>The <code>(get-info :all-statistics)</code> command to obtain information about the
solver's statistics
</li>
<li>The <code>(reset)</code>, <code>(exit)</code> and <code>(echo)</code> commands
</li>
<li>The <code>(get-assignment)</code> command, as well as the <code>:named</code> attribute and
<code>:produce-assignments</code> option
</li>
</ul>
<p>See the <a href="https://smt-lib.org">SMT-LIB standard</a> for more details about these
commands.</p>
<h3>Floating-point theory</h3>
<p>In this release, we have made Alt-Ergo's <a href="https://ocamlpro.github.io/alt-ergo/next/Alt_ergo_native/05_theories.html#floating-point-arithmetic">floating-point
theory</a>
enabled by default: there is no need to provide the <code>--enable-theories fpa</code>
flag anymore.  The theory can be disabled with <code>--disable-theories fpa,nra,ria</code>
(the <code>nra</code> and <code>ria</code> theories were automatically enabled along with the <code>fpa</code>
theory in Alt-Ergo 2.5).</p>
<p>We have also made the floating-point primitives available in the SMT-LIB
format as the indexed constant <code>ae.round</code> and the convenience <code>ae.float16</code>,
<code>ae.float32</code>, <code>ae.float64</code> and <code>ae.float128</code> functions; see the
<a href="https://ocamlpro.github.io/alt-ergo/v2.6.0/SMT-LIB_language/index.html#floating-point-arithmetic">documentation</a>.</p>
<h3>Dolmen is the new default frontend</h3>
<p>Introduced in Alt-Ergo 2.5, the Dolmen frontend has been rigorously tested for
regressions and is now the default for both <code>.smt2</code> and <code>.ae</code> files; the
<code>--frontend dolmen</code> flag that was introduced in Alt-Ergo 2.5 is no longer
necessary.</p>
<p>The Dolmen frontend is based on the <a href="https://github.com/gbury/dolmen">Dolmen</a>
library developed by Guillaume Bury at OCamlPro. It provides excellent support
for the SMT-LIB standard and is used to check validity of all new problems in
the SMT-LIB benchmark collection, as well as the results of the annual SMT-LIB
affiliated solver competition SMT-COMP.</p>
<p>The preferred input format for Alt-Ergo is now the SMT-LIB format. The legacy
<code>.ae</code> format is still supported, but is now deprecated and users are
encouraged to migrate to the SMT-LIB format if possible. Please <a href="mailto:alt-ergo@ocamlpro.com">reach
out</a> if you find any issue while migrating to
the SMT-LIB format.</p>
<p>As we announced when releasing Alt-Ergo 2.5, the legacy frontend (supports
<code>.ae</code> files only) is deprecated in Alt-Ergo 2.6, but it can still be
enabled with the <code>--frontend legacy</code> option. It will be removed entirely from
Alt-Ergo 2.7.</p>
<p>Parser extensions, such as the built-in AB-Why3 plugin, only work with the
legacy frontend, and will no longer work with Alt-Ergo 2.7. We are not
aware of any current users of either parser extensions or the AB-Why3 plugin:
if you need these features, please reach out to us on
<a href="https://github.com/ocamlpro/alt-ergo/issues">GitHub</a> or by
<a href="mailto:alt-ergo@ocamlpro.com">email</a> so that we can figure out a path
forward.</p>
<h3>Use of <code>dune-site</code> for plugins</h3>
<p>Starting with Alt-Ergo 2.6, we are using the plugin mechanism from
<code>dune-site</code> to replace the custom plugin loading <code>Dynlink</code>. Plugins now need
to be registered in the <code>(alt-ergo plugins)</code> site with the
<a href="https://dune.readthedocs.io/en/stable/reference/dune/plugin.html"><code>plugin</code> stanza</a>.</p>
<p>This does not impact users, but only impacts developers of Alt-Ergo plugins. See the
<a href="https://github.com/OCamlPro/alt-ergo/blob/next/src/plugins/fm-simplex/dune">dune file</a>
for Alt-Ergo's built-in FM-Simplex plugin for reference.</p>
<h3>Binary releases on GitHub</h3>
<p>Starting with Alt-Ergo 2.6, we will be providing binary releases on the
<a href="https://github.com/ocamlpro/alt-ergo/releases">GitHub Releases</a> page for
Linux (x86_64) and macOS (x86_64 and arm). These are released under the
same <a href="https://ocamlpro.github.io/alt-ergo/latest/About/licenses/index.html">licensing conditions</a> as the Alt-Ergo source code.</p>
<p>The binary releases are statically linked and have no dependencies, except
for system dependencies on macOS. They do not support dynamically loading
plugins.</p>
<h3>Performance</h3>
<p>For Alt-Ergo 2.6, our main focus of improvement in term of reasoning was on
bit-vectors and algebraic data types. Other theories also benefit from
broader performance improvements we made. On our internal
problem dataset, Alt-Ergo 2.6 is about 5% faster than Alt-Ergo 2.5 on the goals
they both prove.</p>
<h3>And more!</h3>
<p>This release also includes significant internal refactoring, notably
a rewrite from scratch of the interval domain. This improves the
accuracy of Alt-Ergo in handling interval arithmetic and facilitates mixed
operations involving integers and bit-vectors, resulting in shorter and more
reliable proofs.</p>
<p>See the complete changelog
<a href="https://ocamlpro.github.io/alt-ergo/v2.6.0/About/changes.html">here</a>.</p>
<p>We encourage you to try out Alt-Ergo 2.6 and share your experience or any
feedback on our <a href="https://github.com/OCamlPro/Alt-Ergo">GitHub</a> or by email at
<a href="mailto:alt-ergo@ocamlpro.com">alt-ergo@ocamlpro.com</a>. Your input will help
share future releases!</p>
<h3>Acknowledgements</h3>
<p>We thank the <a href="https://alt-ergo.ocamlpro.com/#club">Alt-Ergo Users' Club</a> members: AdaCore, the CEA, Thales,
Mitsubishi Electric R&amp;D Center Europe (MERCE) and TrustInSoft.</p>
<p>Special thanks to David Mentré and Denis Cousineau at MERCE for funding the
initial optimization work.  MERCE has been a Member of the Alt-Ergo Users'
Club for four years.  This partnership allowed Alt-Ergo to evolve and we hope
that more users will join the Club on our journey to make Alt-Ergo a must-have
tool.</p>
<div class="figure">
  <div class="card-light blog-logos">
    <img src="https://ocamlpro.com/assets/img/logo_adacore.svg" alt="AdaCore logo">
    <img src="https://ocamlpro.com/blog/assets/img/cealist.png" alt="CEA list logo">
    <img src="https://ocamlpro.com/assets/img/logo_thales.svg" alt="Thales logo" style="height: 24px;">
    <img src="https://ocamlpro.com/assets/img/logo_merce.png" alt="Mitsubishi Electric logo">
    <img src="https://ocamlpro.com/assets/img/logo_trustinsoft.svg" alt="TrustInSoft logo" style="height: 32px;">
  </div>
  <div class="caption">The dedicated members of our Alt-Ergo Club!</div>
</div>

