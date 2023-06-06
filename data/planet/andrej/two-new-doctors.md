---
title: Two new doctors!
description:
url: http://math.andrej.com/2022/01/12/two-new-doctors/
date: 2022-01-12T08:00:00-00:00
preview_image:
featured:
authors:
- Andrej Bauer
---

<p>Within a month two of my students defended their theses: <a href="https://anjapetkovic.com">Dr. Anja Petkovi&#263; Komel</a> just before Christmas, and <a href="https://haselwarter.org">Dr. Philipp Haselwarter</a> just yesterday. I am very proud of them. Congratulations!</p>



<p>Philipp's thesis <a href="https://haselwarter.org/assets/pdfs/effective-metatheory-for-type-theory.pdf">An Effective Metatheory for Type Theory</a> has three parts:</p>

<ol>
  <li>
    <p>A formulation and a study of the notion of <strong>finitary type theories</strong> and <strong>standard type theories</strong>. These are closely related to the <a href="https://arxiv.org/abs/2009.05539">general type theories</a> that were developed with <a href="http://peterlefanulumsdaine.com">Peter Lumsdaine</a>, but are tailored for implementation.</p>
  </li>
  <li>
    <p>A formulation and the study of <strong>context-free finitary type theories</strong>, which are type theories without explicit contexts. Instead, the variables are annotated with their types. Philipp shows that one can pass between the two versions of type theory.</p>
  </li>
  <li>
    <p>A novel effectful meta-language <strong>Andromeda meta-language</strong> (AML) for proof assistants which uses algebraic effects and handlers to allow flexible interaction between a generic proof assistant and the user.</p>
  </li>
</ol>

<p>Anja's thesis <a href="https://anjapetkovic.com/img/doctoralThesis.pdf">Meta-analysis of type theories with an application to the design of formal proofs</a> also has three parts:</p>

<ol>
  <li>
    <p>A formulation and a study of <strong>transformations of finitary type theories</strong> with an associated category of finitary type theories.</p>
  </li>
  <li>
    <p>A <strong>user-extensible equality checking algorithm</strong> for standard type theories which specializes to several existing equality checking algorithms for specific type theories.</p>
  </li>
  <li>
    <p>A <strong>general elaboration theorem</strong> in which the transformation of type theories are used to prove that every finitary type theory (not necessarily fully annotated) can be elaborated to a standard type theory (fully annotated one).</p>
  </li>
</ol>

<p>In addition, Philipp has done a great amount of work on implementing context-free type theories and the effective meta-language in <a href="http://www.andromeda-prover.org">Andromeda 2</a>, and Anja implemented the generic equality checking algorithm. In the final push to get the theses out the implementation suffered a little bit and is lagging behind. I hope we can bring it up to speed and make it usable. Anja has ideas on how to implement transformations of type theories in a proof assistant.</p>

<p>Of course, I am very happy with the particular results, but I am even happier with the fact that Philipp and Anja made an important step in the development of type theory as a branch of mathematics and computer science: they did not study a <em>particular</em> type theory or a narrow family of them, as has hitherto been the norm, but <em>dependent type theories in general</em>. Their theses contain interesting non-trivial meta-theorems that apply to large classes of type theories, and can no doubt be generalized even further.
There is lots of low-hanging fruit out there.</p>
