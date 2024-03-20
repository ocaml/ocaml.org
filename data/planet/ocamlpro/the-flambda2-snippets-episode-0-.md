---
title: 'The Flambda2 Snippets, Episode 0 '
description: At OCamlPro, the main ongoing task on the OCaml Compiler is to improve
  the high-level optimisation. This is something that we have been doing for quite
  some time now. Indeed, we are the authors behind the Flambda optimisation pass and
  today we would like to introduce the series of blog snippets show...
url: https://ocamlpro.com/blog/2024_03_18_the_flambda2_snippets_0
date: 2024-03-18T14:46:44-00:00
preview_image: https://ocamlpro.com/assets/img/logo_ocp_icon.svg
featured:
authors:
- "\n    Pierre Chambart\n  "
source:
---

<p></p>
<blockquote>
<p>At OCamlPro, the main ongoing task on the OCaml Compiler is to improve the
high-level optimisation. This is something that we have been doing for quite
some time now. Indeed, we are the authors behind the <code>Flambda</code> optimisation
pass and today we would like to introduce the series of blog snippets
showcasing the direct successor to it, the creatively named <code>Flambda2</code>.</p>
</blockquote>
<h2>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#introduction" class="anchor-link">Introducing our Flambda2 snippets</a>
          </h2>
<p>This series of blog posts will cover everything about <code>Flambda2</code>, a
new optimising backend for the OCaml native compiler. This
introductory episode will provide you with some context and history
about <a href="https://github.com/ocaml-flambda/flambda-backend"><code>Flambda2</code></a>
but also about its predecessor <code>Flambda</code> and, of course, the OCaml
compiler!</p>
<p>This work may be considered as a completement to an on-going documentation
effort at OCamlPro as well as to the many different talks we have given last
year on the subject, two of which you can watch online: <a href="https://www.youtube.com/watch?v=eI5GBpT2Brs">OCaml Workshop</a> ( <a href="https://cambium.inria.fr/seminaires/transparents/20230626.Vincent.Laviron.pdf">slideshow</a> ), <a href="https://www.youtube.com/watch?v=PRb8tRfxX3s">ML
Workshop</a> ( <a href="https://cambium.inria.fr/seminaires/transparents/20230828.Vincent.Laviron.pdf">slideshow</a> ).</p>
<p><strong>This work was developed in collaboration with, and funded by Jane Street.
Warm thanks to Mark Shinwell for shepherding the Flambda project and to Ron
Minsky for his support.</strong></p>
<p></p><div>
<strong>Table of contents</strong>
<ul>
<li><a href="https://ocamlpro.com/blog/feed#introduction">Introduction</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#compiling">Compiling OCaml</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#roadmap">Snippets Roadmap</a>

</li>
</ul>
<h2>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#compiling" class="anchor-link">Compiling OCaml</a>
          </h2>
<p>The compiling of OCaml is done through a multitude of passes (see simplified
representation below), and the bulk of high-level optimisations happens between
the <code>Lambda</code> IR (Intermediate Representation) and <code>CMM</code> (which stands
for <em>C--</em>). This set of optimisations will be the main focus of this series of
snippets.</p>
<p>
</p><div class="figure">
  <p>
    <a href="https://ocamlpro.com/blog/assets/img/flambda2_snippets_ep0_figure3_1.png">
      <img src="https://ocamlpro.com/blog/assets/img/flambda2_snippets_ep0_figure3_1.png" alt="The different passes of the OCaml compilers, from sources to executable code, before the addition of &lt;code&gt;Flambda&lt;/code&gt;."/>
    </a>
    </p><div class="caption">
      The different passes of the OCaml compilers, from sources to executable code, before the addition of <code>Flambda</code>.
    </div>
  
</div>

<p>Indeed, that part of the compiler is quite crowded. Originally, after
the frontend has type-checked the sources, the <code>Closure</code> pass was in
charge of transforming the <code>Lambda</code> IR <a href="https://github.com/ocaml/ocaml/blob/34cf5aafcedc2f7895c7f5f0ac27c7e58e4f4adf/lambda/lambda.mli#L279">(see source
code)</a>
into the <code>Clambda</code> IR <a href="https://github.com/ocaml/ocaml/blob/cce52acc7c7903e92078e9fe40745e11a1b944f0/middle_end/clambda.mli#L57">(see source
code)</a>.
This transformation handles <a href="https://en.wikipedia.org/wiki/Constant_folding"><em>Constant
Propagation</em></a>, some
<a href="https://en.wikipedia.org/wiki/Inline_expansion"><em>inlining</em></a>, and some
<em>Constant Lifting</em> (moving constant structures to static
allocation). Then, a subsequent pass (called <code>Cmmgen</code>) transforms the
<code>Clambda</code> IR into the <code>CMM</code> ID <a href="https://github.com/ocaml/ocaml/blob/cce52acc7c7903e92078e9fe40745e11a1b944f0/asmcomp/cmm.mli#L168">(see source
code)</a>
and handles some <a href="https://en.wikipedia.org/wiki/Peephole_optimization">peep-hole
optimisations</a> and
<a href="https://en.wikipedia.org/wiki/Boxing_(computer_science)"><em>unboxing</em></a>. This final representation will be used by architecture-specific
backends to produce assembler code.</p>
<p>Before we get any further into the <strong>hairy</strong> details of <code>Flambda2</code> in the
upcoming snippets, it is important that we address some context.</p>
<p>We introduced the <code>Flambda</code> framework which was <a href="https://blog.janestreet.com/flambda/">released with <code>OCaml 4.03</code></a>. This was a success in improving
<em>inlining</em> and related optimisations, and has been stable ever since,
with very few bug reports.</p>
<p>We kept both <code>Closure</code> and <code>Flambda</code> alive together because some users cared a
lot about the compilation speed of OCaml - <code>Flambda</code> is indeed a bit slower
than <code>Closure</code>.</p>
<p>
</p><div class="figure">
  <p>
    <a href="https://ocamlpro.com/blog/assets/img/flambda2_snippets_ep0_figure3_2.png">
      <img src="https://ocamlpro.com/blog/assets/img/flambda2_snippets_ep0_figure3_2.png" alt="&lt;code&gt;Flambda&lt;/code&gt; provides an alternative to the classic &lt;code&gt;Closure&lt;/code&gt; transformation, with additionnal optimizations."/>
    </a>
    </p><div class="caption">
      <code>Flambda</code> provides an alternative to the classic <code>Closure</code> transformation, with additionnal optimizations.
    </div>
  
</div>

<p>Now is time to introduce another choice to both <code>Flambda</code> and <code>Closure</code>:
<code>Flambda2</code>, which is meant to eventually replace <code>Flambda</code> and potentially
<code>Closure</code> as well. In fact, Janestreet has been gradually moving from <code>Closure</code>
and <code>Flambda</code> to <code>Flambda2</code> during the past year and has to this day no more
systems relying on <code>Closure</code> or <code>Flambda</code>.</p>
<blockquote>
<p>You can read more about the transition from staging to production-level
workloads of <code>Flambda2</code> right <a href="https://ocamlpro.com/blog/2023_06_30_2022_at_ocamlpro/#flambda">here</a>.</p>
</blockquote>
<p><code>Flambda</code> is still maintained and will be for the forseeable future. However,
we have noticed some limitations that prevented us from doing some kinds of
optimisations and on which we will elaborate in the following episodes of <em>The
Flambda2 Snippets</em> series.</p>
<p>
</p><div class="figure">
  <p>
    <a href="https://ocamlpro.com/blog/assets/img/flambda2_snippets_ep0_figure3.png">
      <img src="https://ocamlpro.com/blog/assets/img/flambda2_snippets_ep0_figure3.png" alt="&lt;code&gt;Flambda2&lt;/code&gt; provides a much extended alternative to Flambda, from &lt;code&gt;Lambda&lt;/code&gt; IR to &lt;code&gt;CMM&lt;/code&gt;."/>
    </a>
    </p><div class="caption">
      <code>Flambda2</code> provides a much extended alternative to Flambda, from <code>Lambda</code> IR to <code>CMM</code>.
    </div>
  
</div>

<p>One obvious difference to notice is that <code>Flambda2</code> translates directly to <code>CMM</code>,
circumventing the <code>Clambda</code> IR, allowing us to lift some limitations inherent
to <code>Clambda</code> itself.</p>
<p>Furthermore, we experimented after releasing <code>Flambda</code> with the aim to
incrementally improve and add new optimisations. We tried to improve its
internal representation and noticed that we could gain a lot by doing so, but
also that it required deeper changes and that is what led us to <code>Flambda2</code>.</p>
<h2>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#roadmap" class="anchor-link">Snippets Roadmap</a>
          </h2>
<p>This is but the zeroth snippet of the series. It aims at providing you with
history and context for <code>Flambda2</code>.</p>
<p>You can expect the rest of the snippets to alternate between deep dives into the
technical aspects of <code>Flambda2</code>, and user-facing descriptions of the new
optimisations that we enable.</p>
<h2>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#listing" class="anchor-link">The F2S Series!</a>
          </h2>
<ul>
<li>
<p><a href="https://ocamlpro.com/blog/2024_01_31_the_flambda2_snippets_1">Episode 1: CPS Representation and Foundational Design Decisions in Flambda2</a></p>
<p>The first snippet covers the characteristics and benefits of a CPS-based
internal representation for the optimisation of the OCaml language. It was
already covered in part <a href="https://icfp23.sigplan.org/details/ocaml-2023-papers/8/Efficient-OCaml-compilation-with-Flambda-2">at the OCaml
Workshop</a>
in 2023 we try to go deeper into the subject in these blog posts.</p>
</li>
<li>
<p>Episode 2: Loopifying Tail-Recursive Functions</p>
<blockquote>
<p>Coming soon...</p>
</blockquote>
</li>
</ul>
<p>Stay tuned, and thank you for reading!</p>
</div>
