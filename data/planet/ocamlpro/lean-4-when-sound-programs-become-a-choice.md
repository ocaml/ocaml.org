---
title: 'Lean 4: When Sound Programs become a Choice'
description: Monitoring Edge Technical Endeavours As a company specialized in strongly-typed
  programming languages with strong static guarantees, OCamlPro closely monitors the
  ongoing trend of bringing more and more of these elements into mainstream programming
  languages. Rust is a relatively recent example of t...
url: https://ocamlpro.com/blog/2024_03_07_lean4_when_sound_programs_become_a_choice
date: 2024-03-07T10:00:20-00:00
preview_image: https://ocamlpro.com/assets/img/logo_ocp_icon.svg
featured:
authors:
- "\n    Adrien Champion\n  "
source:
---

<h2>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#watch" class="anchor-link">Monitoring Edge Technical Endeavours</a>
          </h2>
<p>As a company specialized in strongly-typed programming languages with strong
static guarantees, OCamlPro closely monitors the ongoing trend of bringing more
and more of these elements into mainstream programming languages. Rust is a
relatively recent example of this trend; another one is the very recent <a href="https://leanprover-community.github.io/index.html">Lean 4
language</a>.</p>
<p></p><div>
<strong>Table of contents</strong>
<ul>
<li><a href="https://ocamlpro.com/blog/feed#watch">Monitoring Edge Technical Software</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#lean4">Lean 4, the Promise of Proven Software</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#leanpro">OCamlPro for a Future of Trustworthy Software</a>

</li>
</ul>
<h3>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#lean4" class="anchor-link">Lean 4, the Promising Future of Proven Software</a>
          </h3>
<p>Lean 4 builds on the shoulders of giants like the Coq proof assistant, and
languages such as OCaml and Haskell, to put programmers in a world where they
can write elegant programs, express their specification with the full power of
modern logics, and prove that these programs are correct with respect to their
specification. Doing all this in the same language is crucial as it can
streamline the certification process: once Lean 4 is trusted (audits,
certification...), then programs, specifications, and proofs are also trusted.
This contrasts with having a programming language, a specification language,
and a separate verification/certification tool, and then having to argue about
the trustworthiness of each of them, and that the glue linking all of them
together makes sense. This is extremely interesting in the context of critical
embedded systems in particular, and in qualified/certified &quot;high-trust&quot;
development in general.</p>
<p>While admittedly not as mainstream as Rust, Lean 4 has recently seen an
explosion in interest from the media, developers, mathematicians, and (some)
industrials. Quanta now <a href="https://www.quantamagazine.org/tag/computer-assisted-proofs">routinely publishes articles about/mentioning Lean
4</a>; Fields medalist Terry Tao is increasingly vocal about (and
productive with) its use of Lean 4, see <a href="https://terrytao.wordpress.com/2023/11/18/formalizing-the-proof-of-pfr-in-lean4-using-blueprint-a-short-tour">here</a> and <a href="https://terrytao.wordpress.com/2023/12/05/a-slightly-longer-lean-4-proof-tour">here</a> for (very
technical) example(s). On the industrial side, Leonardo de Moura (Lean 4's lead
designer) recently went from a position at Microsoft Research to Amazon Web
Service, which was followed by a fast and still ongoing expansion of the
infrastructure around Lean 4.</p>
<h3>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#leanpro" class="anchor-link">Pushing for a Future of Trustworthy Software</a>
          </h3>
<p>OCamlPro has been closely monitoring Lean 4's progress by regularly developing
in-house prototypes in Lean 4. Getting involved in the community and Lean 4's
development effort is also part of our culture. This is to give back to the
community, but also to closely follow the evolution of Lean 4 and sharpen our
skills.</p>
<p>There are a few notable and public examples of our involvement. As part of our
in-house prototyping, we discovered a <a href="https://leanprover.zulipchat.com/#narrow/stream/270676-lean4/topic/case.20in.20dependent.20match.20not.20triggering.20.28.3F.29/near/288328239">&quot;major bug&quot; in Lean 4's dependent
pattern-matching</a>; later, we contributed on <a href="https://github.com/leanprover/lean4/pull/1811">improving aspects of the
by notation</a> (used to construct proofs), which then ricocheted into
<a href="https://github.com/leanprover/lean4/pull/1844">fixing problems into the calc tactic</a>. More recently, we contributed
on various fronts such as <a href="https://github.com/leanprover/lean4/issues/2988">improving the ecosystem's ergonomics</a>,
<a href="https://github.com/leanprover/std4/pull/233">adding useful lemmas to Lean 4's standard library</a>, <a href="https://github.com/leanprover/lean4/pull/2167">contributing to
the documentation effort</a>...</p>
<p>Lean 4 is not of industrial-strength yet, but it gets closer and closer.
Quickly enough for us to think that now's a reasonable time to spend some time
exploring it.</p>
</div>
