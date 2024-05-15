---
title: On indefinite truth values
description:
url: http://math.andrej.com/2023/08/13/on-indenfinite-truth-values/
date: 2023-08-12T22:00:00-00:00
preview_image:
authors:
- Andrej Bauer
source:
---

<p>In a discussion following a <a href="https://mathoverflow.net/a/452512/1176">MathOverflow answer</a> by <a href="https://jdh.hamkins.org">Joel Hamkins</a>, <a href="http://timothychow.net">Timothy Chow</a> and I got into a chat about what it means for a statement to &ldquo;not have a definite truth value&rdquo;. I need a break from writing the paper on countable reals (coming soon in a journal near you), so I thought it would be worth writing up my view of the matter in a blog post.</p>



<p>How are we to understand the statement &ldquo;the Riemann hypothesis (RH) does not have a definite truth value&rdquo;?</p>

<p>Let me first address two possible explanations that in my view have no merit.</p>

<p>First, one might suggest that &ldquo;RH does not have a definite truth value&rdquo; is the same as &ldquo;RH is neither true nor false&rdquo;.
This is nonsense, because &ldquo;RH is neither true nor false&rdquo; is the statement $\neg \mathrm{RH} \land \neg\neg\mathrm{RH}$, which is just false by <a href="https://en.wikipedia.org/wiki/Law_of_noncontradiction">the law of non-contradiction</a>. No discussion here, I hope. Anyone claiming &ldquo;RH is neither true nor false&rdquo; must therefore mean that they found a paradox.</p>

<p>Second, it is confusing and even harmful to drag into this discussion syntactically invalid, ill-formed, or otherwise corrupted statements. To say something like &ldquo;$(x + ( - \leq 7$ has no definite truth value&rdquo; is meaningless. The notion of truth value does not apply to arbitrary syntactic garbage. And even if one thinks this is a good idea, it does not apply to RH, which is a well-formed formula that can be assigned meaning.</p>

<p>Having disposed of ill-fated attempts, let us ask what the precise mathematical meaning of the statement might be. It is important to note that we are discussing semantics. The <em>truth value</em> of a sentence $P$ is an element $I(P) \in B$ of some Boolean algebra $(B, 0, 1, {\land}, {\lor}, {\lnot})$, assigned by an interpretation function $I$. (I am assuming classical logic, but nothing really changes if we switch to intuitionistic logic, just replace Boolean algebras with Heyting algebras.) Taking this into account, I can think of three ways of explaining &ldquo;RH does not have a definite truth value&rdquo;:</p>

<ol>
  <li>
    <p>The truth value $I(\mathrm{RH})$ is neither $0$ nor $1$. (Do not confuse this meta-statement with the object-statement $\neg \mathrm{RH} \land \neg\neg\mathrm{RH}$.) Of course, for this to happen one has to use a Boolean algebra that contains something other than $0$ and $1$.</p>
  </li>
  <li>
    <p>The truth value of $I(\mathrm{RH})$ varies, depending on the model and the interpretation function. An example of this phenomenon is the <a href="https://en.wikipedia.org/wiki/Continuum_hypothesis">continuum hypothesis</a>, which is true in some set-theoretic models and false in others.</p>
  </li>
  <li>
    <p>The interpretation function $I$ fails to assign a truth value to $\mathrm{RH}$.</p>
  </li>
</ol>

<p>Assuming we have set up sound and complete semantics, the first and the second reading above both amount to undecidability of RH. Indeed, if the truth value of RH is not $1$ across all models then RH is not provable, and if it is not fixed at $0$ then it is not refutable, hence it is undecidable. Conversely, if RH is undecidable then its truth value in the <a href="https://en.wikipedia.org/wiki/Lindenbaum%E2%80%93Tarski_algebra">Lindenbaum-Tarski algebra</a> is neither $0$ nor $1$. We may quotient the algebra so that the value becomes true or false, as we wish.</p>

<p>The third option says that one has got a lousy interpretation function and should return to the drawing board.</p>

<p>In some discussions &ldquo;RH does not have a definite truth value&rdquo; seems to take on an anthropocentric component. The truth value is indefinite because knowledge of it is lacking, or because there is a cognitive barrier to comprehending the statement, etc. I find these just as unappealing as the <a href="https://en.wikipedia.org/wiki/Constructive_proof#Brouwerian_counterexamples">Brouwerian counterexamples</a> arguing in favor of intuitionistic logic.</p>

<p>The only realm in which I reasonably comprehend &ldquo;$P$ does not have a definite truth value&rdquo; is pre-mathematical, or even philosophical. It may be the case that $P$ refers to pre-mathematical concepts lacking precise formal description, or whose existing formal descriptions are considered problematic. This situation is similar to the third one above, but cannot be just dismissed as technical deficiency. An illustrative example is Solomon Feferman's <a href="https://doi.org/10.1080/00029890.1999.12005017">Does mathematics need new axioms?</a> and the discussion found therein on the meaningfulness and the truth value of the continuum hypothesis. (However, I am not aware of anyone seriously arguing that the mathematical meaning of Riemann hypothesis is contentious.)</p>

<p>So, what do I mean by &ldquo;RH does not have a definite truth value&rdquo;? Nothing, I would never say that and I do not understand what it is supposed to mean. RH clearly has a definite truth value, in each model, and with some luck we are going to find out which one. (To preempt a counter-argument: the notion of &ldquo;standard model&rdquo; is a mystical concept, while those stuck in an &ldquo;intended model&rdquo; suffer from lack of imagination.)</p>
