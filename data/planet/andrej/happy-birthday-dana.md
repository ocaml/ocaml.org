---
title: Happy birthday, Dana!
description:
url: http://math.andrej.com/2022/10/11/happy-birthday-dana/
date: 2022-10-11T07:00:00-00:00
preview_image:
featured:
authors:
- Andrej Bauer
---

<p>Today <a href="https://www.cmu.edu/math/people/faculty/scott.html">Dana Scott</a> is celebrating the 90th birthday today. <strong>Happy birthday, Dana!</strong> I am forever grateful for your kindness and the knowledge that I received from you. I hope to pass at least a part of it onto my students.</p>

<p>On the occasion <a href="https://awodey.github.io">Steve Awodey</a> assembled selected works by Dana Scott at <a href="https://github.com/CMU-HoTT/scott"><code class="language-plaintext highlighter-rouge">CMU-HoTT/scott</code></a> repository. It is an amazing collection of papers that had deep impact on logic, set theory, computation, and programming languages. I hope in the future we can extend it and possibly present it in better format.</p>

<p>As a special treat, I recount here the story the invention of the famous $D_\infty$ model of the untyped $\lambda$-calculus.
I heard it first when I was Dana's student. In 2008 I asked Dana to recount it in the form of a short interview.</p>



<p><strong>These days domain theory is a mature branch of mathematics. It has had profound influence on the theory and practice of programming languages. When did you start working on it and why?</strong></p>

<p><strong>Dana Scott:</strong> I was in Amsterdam in 1968/69 with my family. I met Strachey at IFIP WG2.2 in summer of 1969. I arranged leave from Princeton to work with him in the fall of 1969 in Oxford. I was trying to convince Strachey to use a type theory based on domains.</p>

<p><strong>One of your famous results is the construction of a domain $D_\infty$ which is isomorphic to its own continuous function space $D_\infty \to D_\infty$. How did you invent it?</strong></p>

<p><strong>D. S.:</strong> $D_\infty$ did not come until later. I remember it was a quiet Saturday in November 1969 at home. I had proved that if domains $D$ and $E$ have a countable basis of finite elements, then so does the continuous function space $D \to E$. In understanding how often the basis for $D \to E$ was more complicated than the bases for $D$ and $E$, I then thought, &ldquo;Oh, no, there must exist a bad $D$ with a basis so 'dense' that the basis for $D \to D$ is just as complicated &ndash; in fact, isomorphic.&rdquo; But I never proved the existence of models exactly that way because I soon saw that the iteration of $X \mapsto (X \to X)$ constructed a suitable basis in the limit. That was the actual $D_\infty$ construction.</p>

<p><strong>Why do you say &ldquo;oh no&rdquo;? It was an important discovery!</strong></p>

<p><strong>D. S.:</strong> Since, I had claimed for years that the type-free $\lambda$-calculus has no &ldquo;mathematical&rdquo; models (as distinguished from term models), I said to myself, &ldquo;Oh, no, now I will have to eat my own words!&rdquo;</p>

<p><strong>The existence of term models is guaranteed by the Church-Rosser theorem from 1936 which implies that the untyped lambda calculus is consistent?</strong></p>

<p><strong>D. S.:</strong> Yes.</p>

<p><strong>The domain $D_\infty$ is an involved construction which gives a model for the calculus with both $\beta$- and $\eta$-rules. Is it easier to give a model which satisfies the $\beta$-rule only?</strong></p>

<p><strong>D. S.:</strong> Since the powerset of natural numbers $P\omega$ (with suitable topology) is universal for countably-based $T_0$-spaces, and since a continuous lattice is a retract of every superspace, it follows that $P\omega \to P\omega$ is a retract of $P\omega$. This gives a non-$\eta$ model without any infinity-limit constructions. But continuous lattices had not yet been invented in 1969 &ndash; that I knew of.</p>

<p><strong>Where can the interested readers read more about this topic?</strong></p>

<p><strong>D.S.:</strong> I would recommend these two:</p>

<ul>
  <li>Scott, D. <a href="https://github.com/CMU-HoTT/scott/blob/main/pdfs/1993-a-type-theoretical-aternative-to-ISWIM-CUCH-OWHY.pdf">A type-theoretical alternative to ISWIM, CUCH, OWHY</a>. Theoretical Computer Science, vol. 121 (1993), pp. 411-440.</li>
  <li>Scott, D. <a href="https://doi.org/10.1023/A:1010018211714">Some Reflections on Strachey and his Work</a>. A Special Issue Dedicated to Christopher Strachey, edited by O. Danvy and C. Talcott. Higer-Order and Symbolic Computation, vol. 13 (2000), pp. 103-114.</li>
</ul>

<p><strong>Thank you very much!</strong></p>

<p><strong>Dana Scott:</strong> You are welcome.</p>
