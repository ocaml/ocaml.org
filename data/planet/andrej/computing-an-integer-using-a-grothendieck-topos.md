---
title: Computing an integer using a Grothendieck topos
description:
url: http://math.andrej.com/2021/05/18/computing-an-integer-using-a-sheaf-topos/
date: 2021-05-18T07:00:00-00:00
preview_image:
featured:
authors:
- Martin Escardo
---

<p>A while ago, my former student <a href="https://cj-xu.github.io/">Chuangjie Xu</a> and I computed an integer using a <a href="https://ncatlab.org/nlab/show/Grothendieck+topos">sheaf topos</a>. For that purpose,</p>

<ol>
  <li>we developed our mathematics constructively,</li>
  <li>we formalized our mathematics in Martin-L&ouml;f type theory, in <a href="https://wiki.portal.chalmers.se/agda/pmwiki.php">Agda</a> notation,</li>
  <li>we pressed a button, and</li>
  <li>after a few seconds we saw the integer we expected in front of us.</li>
</ol>

<p>Well, it was a few seconds for the computer in steps (3)-(4), but three years for us in steps (1)-(2).</p>



<h4>Why formalize?</h4>

<p>Most people formalize mathematics (in Automath, NuPrl, Coq, Agda, Lean, ...) to get confidence in the correctness of mathematics - or so they claim. The reality is that formalizing mathematics is intellectually fun.</p>

<p>Entertaining considerations aside, my initial motivation for computer formalization, about 10 years ago, was to write algorithms derived from work on game theory with <a href="https://www.eecs.qmul.ac.uk/~pbo/">Paulo Oliva</a>. In particular, this had applications to proof theory, such as <a href="https://www.cs.bham.ac.uk/~mhe/pigeon/">getting programs from classical proofs</a>. Our first version of a (manually) extracted program from a classical proof was written in Haskell, in a train journey coming back from a visit to our collaborators <a href="https://www.swansea.ac.uk/staff/science/computer-science/m.seisenberger/">Monika Seisenberger</a> and <a href="http://www-compsci.swan.ac.uk/~csulrich/">Ulrich Berger</a> in Swansea. The train journey was long enough for us to be able to complete the program. But when we ran it, it didn't work. I had been learning Agda for about one year by then, and I told Paulo that it would be easier to write the mathematics in Agda, and hence be sure it will work before we ran it, than to debug the Haskell program. And that was the case.</p>

<p>Before then I was the kind of person who dismissed formalization, and would say so to people who did formalization (it is probably too late to apologize now). I trusted my own mathematics, and if I wanted to derive programs from my mathematical work, I would just write them manually. Since then, my attitude has changed considerably.</p>

<p>I now <a href="https://www.cs.bham.ac.uk/~mhe/TypeTopology/">use Agda as a &quot;blackboard&quot;</a> to develop my work. For example, the following were conceived and developed directly in Agda before they were written in mathematical vernacular: <a href="https://www.cambridge.org/core/journals/mathematical-structures-in-computer-science/article/injective-types-in-univalent-mathematics/AFCBBABE47F29ED7AFB4C262929D8810">Injective types in univalent mathematics</a>, <a href="https://www.cs.bham.ac.uk/~mhe/papers/compact-ordinals-Types-2019-abstract.pdf">Compact, totally separated and well-ordered types in univalent mathematics</a>, <a href="https://arxiv.org/abs/2002.07079">The Cantor-Schr&ouml;der-Bernstein Theorem for &infin;-groupoids</a>, <a href="http://math.andrej.com/2021/02/22/burali-forti-in-hott-uf/">The Burali-Forti argument in HoTT/UF</a> and <a href="https://www.cs.bham.ac.uk/~mhe/dialogue/dialogue.pdf">Continuity of G&ouml;del's system T functionals via effectful forcing</a>.</p>

<p>Other people will have different reasons to formalize. For example, wouldn't it be wonderful if the whole <a href="https://wwwf.imperial.ac.uk/~buzzard/xena/">undergraduate mathematical curriculum were formalized</a>? Wouldn't it be wonderful to archive all mathematical knowledge not just as text but in a more structured way, so that it can be used by both people and computers? Wouldn't it be wonderful if when we submit a paper, the referee didn't need to check correctness, but only novelty, significance and so on? Did you ever woke up in the middle of the night after you submitted a paper, with doubts about the crucial lemma? Or worse, after it was published?</p>

<p>But for the purposes of this post, I will concentrate on only one aspect of formalization: a formalized piece of constructive mathematics is automatically a computer program that you can run in practice.</p>

<h4>Constructive mathematics</h4>

<p>Constructive mathematics begins by removing the principle of excluded middle, and therefore the axiom of choice, because choice implies excluded middle.
<a href="http://math.andrej.com/2016/10/10/five-stages-of-accepting-constructive-mathematics/">But why would anybody do such an outrageous thing?</a></p>

<p>I particularly like the analogy with <a href="https://en.wikipedia.org/wiki/Euclidean_geometry">Euclidean geometry</a>. If we remove the parallel postulate, we get <a href="https://en.wikipedia.org/wiki/Absolute_geometry">absolute geometry</a>, also known as <em>neutral</em> geometry. If after we remove the parallel postulate, we add a suitable axiom, we get <a href="https://en.wikipedia.org/wiki/Hyperbolic_geometry">hyperbolic geometry</a>, but if we instead add a different suitable axiom we get <a href="https://en.wikipedia.org/wiki/Elliptic_geometry">elliptic geometry</a>. Every theorem of neutral geometry is a theorem of these three geometries, and more geometries. So a neutral proof is more general.</p>

<p>When I say that I am interested in constructive mathematics, most of the time I mean that I am interested in <a href="http://logic.math.su.se/mloc-2019/">neutral mathematics</a>, so that we simply remove excluded middle and choice, and we don't add anything to replace them. So my constructive definitions and theorems are also definitions and theorems of classical mathematics.</p>

<p>Occasionally, I flirt with axioms that <em>contradict</em> the principle of excluded middle, such as Brouwerian intuitionistic axioms that imply that &quot;all functions $(\mathbb{N} \to 2) &rarr; \mathbb{N}$ are uniformly continuous&quot;, when we equip the set $2$ with the discrete topology and $\mathbb{N} \to 2$ with the product topology, so that we get the Cantor space. The contradiction with classical logic, of course, is that using excluded middle we can define non-continuous functions by cases. Brouwerian intuitionistic mathematics is analogous to hyperbolic or elliptic geometry in this respect. The &quot;constructive&quot; mathematics I am talking about in this post is like neutral geometry, and I would rather call it &quot;neutral mathematics&quot;, but then nobody would know what I am talking about. That's not to say that the majority of mathematicians will know what I am talking about if I just say &quot;constructive mathematics&quot;.</p>

<p>But it is not (only) the generality of neutral mathematics that I find attractive. Somehow magically, constructions and proofs that don't use excluded middle or choice are <em>automatically</em> programs. The only way to define non-computable things is to use excluded middle or choice. There is no other way. At least not in the underlying type theories of proof assistants such as NuPrl, Coq, Agda and Lean. We don't need to consider Turing machines to establish computability. What is a computable sheaf, anyway? I don't want to pause to consider this question in order to use a sheaf topos to compute a number. We only need to consider sheaves in the usual mathematical sense.</p>

<p>Sometimes people ask me whether I <em>believe</em> in the principle of excluded middle. That would be like asking me whether I believe in the parallel postulate. It is clearly true in Euclidean geometry, clearly false in elliptic and in hyperbolic geometries, and deliberately undecided in neutral geometry. Not only that, in the same way as the parallel postulate <em>defines</em> Euclidean geometry, the principle of excluded middle and the axiom of choice <em>define</em> classical mathematics.</p>

<p>The undecidedness of excluded middle in my neutral mathematics allows me to prove, for example, &quot;if excluded middle holds, then the Cantor-Schr&ouml;der-Bernstein Theorem for &infin;-groupoids <a href="https://arxiv.org/abs/2002.07079">holds</a>&quot;. If excluded middle were false, I would be proving a counter-factual - I would be proving that an implication is true simply because its premise is false. But this is not what I am doing. What I am really proving is that the CSB theorem holds for the objects of <em>boolean</em> &infin;-toposes.
And why did I use excluded middle? Because somebody else showed that <a href="https://arxiv.org/abs/1904.09193">there is no other way</a>. But also sometimes I use excluded middle or choice when <em>I don't know</em> whether there is another way (in fact, I believe that more than half of my publications use classical logic).</p>

<p>So, am I a constructivist? There is only one mathematics, of which classical and constructive mathematics are particular branches. I enjoy exploring the whole landscape. I am particularly fond of constructive mathematics, and I wouldn't practice it, however useful it may be for applications, if I didn't enjoy it. But this is probably my bad taste.</p>

<h4>Toposes as provinces of the mathematical world</h4>

<p>Toposes are generalized (sober) spaces. But also toposes can be considered as provinces of the mathematical world.</p>

<p>Hyland's <a href="https://ncatlab.org/nlab/show/effective+topos">effective topos</a> is a province where &quot;everything is computable&quot;.
This is an elementary topos, which is not a Grothendieck topos, built from <em>classical</em> ingredients: we use excluded middle and choice, with Turing machines to talk about computability. But, as it turns out, although everybody agrees which functions $\mathbb{N} \to \mathbb{N}$ are computable and which ones aren't, there is disagreement among classical mathematicians working on computability theory about
<a href="https://www.springer.com/gp/book/9783662479919">what counts as &quot;computable&quot; for more general mathematical objects</a>, such as functions $(\mathbb{N} \to \mathbb{N}) \to \mathbb{N}$. No problem. Just consider other provinces, called <a href="https://ncatlab.org/nlab/show/realizability+topos">realizability toposes</a>, which include the effective topos as an example.</p>

<p>Johnstone's <a href="https://ncatlab.org/nlab/show/Johnstone's+topological+topos">topological topos</a> is a topos <em>of</em> spaces. It fully embeds a large category of topological spaces, where the objects outside the image of the embedding can be considered as generalized spaces (which include the <a href="https://ncatlab.org/nlab/show/subsequential+space">Kuratowski limit spaces</a> and more). In this province of the mathematical world, &quot;all functions are continuous&quot;.</p>

<p>There are also provinces where <a href="https://ncatlab.org/nlab/show/synthetic+differential+geometry">there are infinitesimals</a> and &quot;all functions are smooth&quot;.</p>

<p>A more boring, but important, province, is the topos of classical sets. This is where classical mathematics takes place.</p>

<p>These provinces of mathematics have an <em>internal language</em>. We use a certain <a href="https://ncatlab.org/nlab/show/subobject+classifier">subobject classifier</a> to collect the things that count as truth values in the province, and we devise a kind of type theory whose types are interpreted as objects and whose mathematical statements are interpreted as truth values in the province. Then a mathematical statement in this type theory is true in some toposes, false in other toposes, and undecided in yet other toposes. This internal language, or type theory, is very rich. Starting from natural numbers we can construct the integers, the rationals, the real numbers, free groups etc., and then do e.g. analysis and group theory and so on. The internal language of the <a href="https://ncatlab.org/nlab/show/free+topos">free topos</a> can be considered as a type theory for neutral mathematics: whatever we prove in the free type theory is true in all mathematical provinces, including classical set theory.</p>

<p>In the above first three provinces, the principle of excluded middle fails, but for different reasons, with respectively computability, continuity and infinitesimals to blame.</p>

<h4>Our topos</h4>

<p>Now our plot has a twist: we work within <em>neutral</em> mathematics to build a province of &quot;biased&quot; constructive mathematics where Brouwerian principles hold, such as &quot;all functions $(\mathbb{N} \to 2) &rarr; \mathbb{N}$ are uniformly continuous&quot;.</p>

<p><a href="https://academic.oup.com/plms/article-abstract/s3-38/2/237/1484548">Johnstone's topological topos (1979)</a> would do the job, except that it is built using classical ingredients. This topos has siblings by <a href="http://homepages.inf.ed.ac.uk/mfourman/research/publications/pdf/fourman82-notions-of-choice-sequence.pdf">Mike Fourman (1982)</a> and <a href="https://www.sciencedirect.com/science/article/pii/0168007284900356">van der Hoeven and Moerdijk (1984)</a> with aims similar to ours, as explained in our own <a href="https://cj-xu.github.io/papers/xu-escardo-model-uc.pdf">2013</a> and <a href="https://www.sciencedirect.com/science/article/pii/S0168007216300410">2016</a> papers, which give a third sibling.</p>

<p>Johnstone's topological topos is very easy to describe: take the monoid of continuous endomaps of the one-point compactification of the discrete natural numbers, considered as a category, then take sheaves for the canonical coverage.
Van der Hoeven and Moerdijk's topos is similar: this time take the monoid of continuous endomaps of the Baire space,
with the &quot;open-cover coverage&quot;. Fourman's topos is constructed from a site of formal spaces or locales, with a similar coverage.</p>

<p>Our topos is also similar: we take the monoid of uniformly continuous endomaps of the Cantor space.
Because it is not provable in neutral mathematics that continuous functions on the Cantor space are automatically uniformly continuous, we explicitly ask for uniform continuity rather than just continuity. As for our coverage, we initially considered coverings of finitely many jointly surjective maps. But an equivalent, smaller coverage makes the mathematics (and the formalization) simpler: for each natural number $n$ we consider a cover with $2^n$ functions, namely the concatenation maps $(\mathbb{N} \to 2) \to (\mathbb{N} \to 2)$ defined by $\alpha \mapsto s \alpha$ for each finite binary sequence $s$ of length $n$. These functions are jointly surjective, and, moreover, have disjoint images, considerably simplifying the checking of the sheaf condition. Moreover, the coverage axiom is not only satisfied, but also is equivalent to the fact that the morphisms in our site are uniformly continuous functions. So this is a sort of &quot;uniform-continuity coverage&quot;. Our <a href="https://www.cs.bham.ac.uk/~mhe/.talks/ihp2014/escardo-ihp2014.pdf">slides (2014)</a> illustrate these ideas with pictures and examples.</p>

<p>The details of the mathematics can be found in the <a href="https://www.sciencedirect.com/science/article/pii/S0168007216300410">above paper</a>, and the Agda formalization can be found at <a href="https://cj-xu.github.io/">Chuangjie's page</a>. A few years later, <a href="https://www.cs.bham.ac.uk/~mhe/chuangjie-xu-thesis-cubical/html/">we ported part of this formalization</a> to <a href="https://agda.readthedocs.io/en/v2.6.1.3/language/cubical.html">Cubical Agda</a> to deal properly with function extensionality (which we originally dealt with in <em>ad hoc</em> ways).</p>

<h4>The integer we compute</h4>

<p>After we construct the sheaf topos, we define a simple type theory and we interpret it in the topos. We define a &quot;function&quot; $(\mathbb{N} \to 2) \to \mathbb{N}$ in this type theory, without proving that it is uniformly continuous, and apply the interpretation map to get a morphism of the topos, which amounts to a uniformly continuous function. From this morphism we get the modulus of uniform continuity, which is the integer we are interested in.
The interested reader can find the details in the <a href="https://www.sciencedirect.com/science/article/pii/S0168007216300410">above paper</a> and <a href="http://www.cs.bham.ac.uk/~mhe/papers/kleene-kreisel/">Agda code for the paper</a> or the substantially more comprehensive <a href="http://cj-xu.github.io/ContinuityType/">Agda code</a> for <a href="http://cj-xu.github.io/ContinuityType/xu-thesis.pdf">Chuangjie's thesis</a>.</p>
