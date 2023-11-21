---
title: Release of ocplib-simplex, version 0.5
description: 'On last November, we released version 0.5 of ocplib-simplex, a generic
  library implementing the Simplex Algorithm in OCaml. It is a key component of the
  Alt-Ergo automatic theorem prover that we keep developing at OCamlPro. ** The Simplex
  Algorithm

  What Changed in 0.5 ? ] The simplex algorithm The S...'
url: https://ocamlpro.com/blog/2022_11_25_ocplib-simplex-0.5
date: 2023-01-05T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    Steven de Oliveira\n  "
source:
---

<p></p>
<p>On last November, we released <a href="https://opam.ocaml.org/packages/ocplib-simplex/">version
0.5</a> of
<a href="https://github.com/OCamlPro/ocplib-simplex">ocplib-simplex</a>, a generic library implementing the <a href="https://en.wikipedia.org/wiki/Simplex_algorithm">Simplex
Algorithm</a> in OCaml. It is a key component of the <a href="https://alt-ergo.ocamlpro.com">Alt-Ergo</a> automatic
theorem prover that we keep developing at OCamlPro.</p>
<p></p><div>
<strong>Table of contents</strong>
<ul>
<li><a href="https://ocamlpro.com/blog/feed#simplex">The Simplex Algorithm</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#changes">What Changed in 0.5 ?</a>

</li>
</ul>
<p>
</p><div class="figure">
  <p>
    <a href="https://ocamlpro.com/blog/assets/img/ocplib-simplex.jpg">
      <img src="https://ocamlpro.com/blog/assets/img/ocplib-simplex.jpg" alt="Try ocplib-simplex before implementing
your own library !"/>
    </a>
    </p><div class="caption">
      Try ocplib-simplex before implementing
your own library !
    </div>
  
</div>

<h2>
<a class="anchor"></a>The simplex algorithm<a href="https://ocamlpro.com/blog/feed#simplex">&#9875;</a>
          </h2>
<p>The <a href="https://en.wikipedia.org/wiki/Simplex_algorithm">Simplex Algorithm</a> is well known among linear optimization
enthusiasts. Let's say you own a manufacture producing two kinds of
chairs: the first is cheap, you make a small profit out of them but
they are quick to produce; the second one is a bit more fancy, you
make a bigger profit but they need a lot of time to build. You have a
limited amount of wood and time. How many cheap and fancy chairs
should you produce to optimize your profits?</p>
<p>You can represent this problem with a set of mathematical constraints (more
precisely, linear inequalities) which is precisely the scope of the simplex
algorithm. Given a set of linear inequalities, it computes a solution maximizing
a given value (in our example, the total profit).
If you are interested in the detail of the algorithm, you shoud definitely watch
<a href="https://www.youtube.com/watch?v=jh_kkR6m8H8">this video</a>.</p>
<p>The simplex algorithm is known to be a difficult problem in terms of
<a href="https://en.wikipedia.org/wiki/Computational_complexity">complexity</a>.
While the base algorithm is EXP-time, it is generally very efficient in
practice.</p>
<h2>
<a class="anchor"></a>What Changed in 0.5 ?<a href="https://ocamlpro.com/blog/feed#changes">&#9875;</a>
          </h2>
<p>Among the main changes in this new version of <a href="https://github.com/OCamlPro/ocplib-simplex">ocplib-simplex</a>:</p>
<ul>
<li>
<p>Make the library's API more generic and easier to use (see the <a href="https://github.com/OCamlPro/ocplib-simplex/blob/v0.5/tests/standalone_minimal.ml">System Solving Example</a> or the <a href="https://github.com/OCamlPro/ocplib-simplex/blob/v0.5/tests/standalone_minimal_maximization.ml">Linear Optimization Example</a>);</p>
</li>
<li>
<p>All the modules are better documentated in their <code>.mli</code> interfaces
(see
<a href="https://github.com/OCamlPro/ocplib-simplex/blob/v0.5/src/coreSig.mli">coreSig.mli</a>
for example);</p>
</li>
<li>
<p>the build system has been switched to <code>dune</code></p>
</li>
</ul>
<p>We hope that this work of simplification will help you to integrate
this library more easily in your projects!</p>
<p>If you want to follow this project, report an issue or contribute, you
can find it on <a href="https://github.com/OCamlPro/ocplib-simplex">GitHub</a>.</p>
<p>Please do not hesitate to contact us at OCamlPro:
<a href="mailto:alt-ergo@ocamlpro.com">alt-ergo@ocamlpro.com</a>.</p>
</div>
