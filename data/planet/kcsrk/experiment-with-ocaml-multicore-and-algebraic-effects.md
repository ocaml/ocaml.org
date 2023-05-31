---
title: Experiment with OCaml Multicore and Algebraic Effects
description:
url: https://kcsrk.info/multicore/opam/ocaml/2015/09/10/ocaml-experimental-compilers/
date: 2015-09-10T13:11:00-00:00
preview_image:
featured:
authors:
- KC Sivaramakrishnan
---

<p>I recently gave a talk on Algebraic Effects in OCaml at the <a href="https://ocaml.org/meetings/ocaml/2015/">OCaml Workshop
2015</a>. The extended abstract and the
slides from the talk are available <a href="http://kcsrk.info/#ocaml15">here</a>. The slides
should provide a gentle introduction to programming with algebraic effects and
handlers in OCaml. The examples from the talk (and many more!) are available
<a href="https://github.com/kayceesrk/ocaml-eff-example">here</a>.</p>



<p>Algebraic effects in OCaml are available as a part of the multicore OCaml. The
experimental compiler could easily be installed using the OCaml Labs opam
development repo.</p>

<figure class="highlight"><pre><code class="language-bash" data-lang="bash"><span class="nv">$ </span>opam remote add ocamllabs <span class="nt">-k</span> git https://github.com/ocamllabs/opam-repo-dev
<span class="nv">$ </span>opam switch 4.02.2+multicore</code></pre></figure>

<p>If you are interested in contributing, please do experiment with algebraic
effects, and report any inevitable bugs or feature requests to the multicore
OCaml <a href="https://github.com/ocamllabs/ocaml-multicore/issues">issue tracker</a>.</p>

<p>We are also quite interested in hearing interesting applications of algebraic
effects such as the encoding of <a href="https://github.com/kayceesrk/ocaml-eff-example/blob/master/reify_reflect.ml">monadic
reflection</a>
and <a href="https://github.com/kayceesrk/ocaml-eff-example/blob/master/delimcc.ml">one-shot multi-prompt delimited
control</a>.
Feel free to submit pull requests with your examples.</p>

