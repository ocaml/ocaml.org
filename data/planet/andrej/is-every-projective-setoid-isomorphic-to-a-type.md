---
title: Is every projective setoid isomorphic to a type?
description:
url: http://math.andrej.com/2022/01/12/projective-setoids/
date: 2022-01-12T08:00:00-00:00
preview_image:
featured:
authors:
- Andrej Bauer
---

<p><a href="https://t.co/pr2rfOaFQ8">Jacques Carette</a> <a href="https://twitter.com/jjcarett2/status/1478883775555723267?s=20">asked on Twitter</a> for a refence to the fact that countable choice holds in setoids. I then spent a day formalizing <a href="https://gist.github.com/andrejbauer/65ee1ae98167e6411e512d3e5a36c086#file-setoidchoice-agda">facts about the axiom of choice in setoids</a> in Agda. I noticed something interesting that is worth blogging about.</p>



<p>We are going to work in pure Martin-L&ouml;f type theory and the straightforward propostions-as-types interpretation of logic, so no univalence, propostional truncation and other goodies are available. Our primary objects of interest are <a href="https://en.wikipedia.org/wiki/Setoid">setoids</a>, and <a href="https://agda.github.io/agda-stdlib/Relation.Binary.Bundles.html#1009">Agda's setoids</a> in particular. 
The content of the post has been formalized in <a href="https://gist.github.com/andrejbauer/65ee1ae98167e6411e512d3e5a36c086">this gist</a>. I am not going to bother to reproduce here the careful tracking of universe levels that the formalization carries out (because it must).</p>

<p>In general, a type, set, or an object $X$ of some sort is said to <strong>satisfy choice</strong> when every total relation $R \subseteq X \times Y$ has a choice function:
$$(\forall x \in X . \exists y \in Y . R(x,y)) \Rightarrow \exists f : X \to Y . \forall x \in X . R(x, f\,x). \tag{AC}$$
In Agda this is transliterated for a setoid $A$ as follows:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>satisfies-choice : &forall; c' &#8467;' r &rarr; Set (c &#8852; &#8467; &#8852; suc c' &#8852; suc &#8467;' &#8852; suc r)
satisfies-choice c' &#8467;' r = &forall; (B : Setoid c' &#8467;') (R : SetoidRelation r A B) &rarr;
                             (&forall; x &rarr; &Sigma; (Setoid.Carrier B) (rel R x)) &rarr; &Sigma; (A &#10230; B) (&lambda; f &rarr; &forall; x &rarr; rel R x (f &#10216;$&#10217; x))
</code></pre></div></div>

<p>Note the long arrow in <code class="language-plaintext highlighter-rouge">A &#10230; B</code> which denotes <strong>setoid maps</strong>, i.e., the choice map $f$ must respect the setoid equivalence relations $\sim_A$ and $\sim_B$.</p>

<p>A category theorist would instead prefer to say that $A$ satisfies choice if every epi $e : B \to A$ splits:
$$(\forall B . \forall e : B \to A . \text{$e$ epi} \Rightarrow \exists s : A \to B . e \circ s = \mathrm{id}_A. \tag{PR}.$$
Such objects are known as <em>projective</em>. The Agda code for this is</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>surjective : &forall; {c&#8321; &#8467;&#8321; c&#8322; &#8467;&#8322;} {A : Setoid c&#8321; &#8467;&#8321;} {B : Setoid c&#8322; &#8467;&#8322;} &rarr; A &#10230; B &rarr; Set (c&#8321; &#8852; c&#8322; &#8852; &#8467;&#8322;)
surjective {B = B} f = &forall; y &rarr; &Sigma; _ (&lambda; x &rarr; Setoid._&asymp;_ B (f &#10216;$&#10217; x) y)

split : &forall; {c&#8321; &#8467;&#8321; c&#8322; &#8467;&#8322;} {A : Setoid c&#8321; &#8467;&#8321;} {B : Setoid c&#8322; &#8467;&#8322;} &rarr; A &#10230; B &rarr; Set (c&#8321; &#8852; &#8467;&#8321; &#8852; c&#8322; &#8852; &#8467;&#8322;)
split {A = A} {B = B} f = &Sigma; (B &#10230; A) (&lambda; g &rarr; &forall; y &rarr; Setoid._&asymp;_ B (f &#10216;$&#10217; (g &#10216;$&#10217; y)) y)

projective : &forall; c' &#8467;' &rarr; Set (c &#8852; &#8467; &#8852; suc c' &#8852; suc &#8467;')
projective c' &#8467;' = &forall; (B : Setoid c' &#8467;') (f : B &#10230; A) &rarr; surjective f &rarr; split f
</code></pre></div></div>

<p>(If anyone can advise me how to to avoid the ugly <code class="language-plaintext highlighter-rouge">Setoid._&asymp;_ B</code> above using just what is available in the standard library, please do. I know how to introduce my own notation, but why should I?)</p>

<p>Actually, the above code uses surjectivity in place of being epimorphic, so we should verify that the two notions coincide in setoids, which is done in <a href="https://gist.github.com/andrejbauer/65ee1ae98167e6411e512d3e5a36c086#file-epimorphism-agda"><code class="language-plaintext highlighter-rouge">Epimorphism.agda</code></a>. The human proof goes as follows, where we write $=_A$ or just $=$ for the equivalence relation on a setoid $A$.</p>

<p><strong>Theorem:</strong> <em>A setoid morphism $f : A \to B$ is epi if, and only if, $\Pi (y : B) . \Sigma (x : A) . f \, x =_B y$.</em></p>

<p><em>Proof.</em> (&rArr;) I <a href="https://mathoverflow.net/a/178804/1176">wrote up the proof on MathOverflow</a>. That one works for toposes, but is easy to transliterate to setoids, just replace the subobject classifier $\Omega$ with the setoid of propositions $(\mathrm{Type}, {\leftrightarrow})$.</p>

<p>(&lArr;) Suppose $\sigma : \Pi (y : B) . \Sigma (x : A) . f \, x =_B y$ and $g \circ f = h \circ f$ for some $g, h : B \to C$. Given any $y : B$ we have
$$g(y) =_C g(f(\mathrm{fst}(\sigma\, y))) =_C h(f(\mathrm{fst}(\sigma\, y))) =_C h(y).$$
QED.</p>

<p>Every type $T$ may be construed as a setoid $\Delta T = (T, \mathrm{Id}_T)$, which is <a href="https://agda.github.io/agda-stdlib/Relation.Binary.Bundles.html#1615"><code class="language-plaintext highlighter-rouge">setoid</code></a> in Agda.</p>

<p>Say that a setoid $A$ has <strong>canonical elements</strong> when there is a map $c : A \to A$ such that $x =_A y$ implies $\mathrm{Id}_A(c\,x , c\,y)$, and $c\, x =_A x$ for all $x : A$. In other words, the map $c$ takes each element to a canonical representative of its equivalence class. In Agda:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>record canonical-elements : Set (c &#8852; &#8467;) where
  field
    canon : Carrier &rarr; Carrier
    canon-&asymp; : &forall; x &rarr; canon x &asymp; x
    canon-&equiv; : &forall; x y &rarr; x &asymp; y &rarr; canon x &equiv; canon y
</code></pre></div></div>

<p>Based on my experience with realizability models, I always thought that the following were equivalent:</p>

<ol>
  <li>$A$ satisfies choice (AC)</li>
  <li>$A$ is projective (PR)</li>
  <li>$A$ is isomorphic to a some $\Delta T$</li>
  <li>$A$ has canonical elements.</li>
</ol>

<p>But there is a snag! The implication (2 &rArr; 3) seemingly requires extra conditions that I do not know how to get rid of. Before discussing these, let me just point out that <a href="https://gist.github.com/andrejbauer/65ee1ae98167e6411e512d3e5a36c086#file-setoidchoice-agda"><code class="language-plaintext highlighter-rouge">SetoidChoice.agda</code></a> formalizes (1 &hArr; 2) and (3 &rArr; 4 &rArr; 1) unconditionally. In particular any $\Delta T$ is projective.</p>

<p>The implication (2 &rArr; 3) I could prove under the additional assumption that the underlying type of $A$ is an h-set. Let us take a closer look.
Suppose $(A, {=_A})$ is a projective setoid. How could we get a type $T$ such that $A \cong \Delta T$? The following construction suggests itself. The setoid map</p>

<p>\begin{align}
  r &amp;: (A, \mathrm{Id}_A) \to (A, {=_A})  \notag \\\<br/>
  r &amp;: x \mapsto x \notag
\end{align}</p>

<p>is surjective, therefore epi. Because $A$ is projective, the map splits, so we have a setoid morphism $s : (A, {=_A}) \to (A, \mathrm{Id}_A)$ such that $r \circ s = \mathrm{id}$. The endomap $s \circ r : A \to A$ is a choice of canonical representatives of equivalence classes of $(A, {=_A})$, so we expect $(A, {=_A})$ to be isomorphic to $\Delta T$ where
$$T = \Sigma (x : A) . \mathrm{Id}_A(s (r \, x), x).$$
The mediating isomorphisms are</p>

<p>\begin{align}
  i &amp;: A \to T                              &amp;   j &amp;: T \to A \notag \\\<br/>
  i &amp;: x \mapsto (s (r \, x), \zeta \, x)   &amp;   j &amp;: (x, \xi) \mapsto x \notag
\end{align}</p>

<p>where $\zeta \, x : \mathrm{Id}(s (r (s (r \, x))), s (r \, x)))$ is constructed from the proof that $s$ splits $r$. This <em>almost</em> works! It is easy to verify that $j (i \, x) =_A x$, but then I got stuck on showing that $\mathrm{Id}_T(i (j (x, \xi), (x, \xi))$, which amounts to inhabiting
$$
  \mathrm{Id}_T((x, \zeta x), (x, \xi)). \tag{1}
$$
There is no a priori reason why $\zeta x$ and $\xi$ would be equal.
If $A$ is an h-set then we are done because they will be equal by fiat. But what do to in general? I do not know and I leave you with an open problem:</p>

<center>
<b>Is every projective setoids isomorphic to a type?</b>
</center>

<p>Egbert Rijke and I spent one tea-time thinking about producing a counter-example by using circles and other HoTT gadgets, but we failed. Just a word of warning: in HoTT/UF the map $1 \to S^1$ from the unit type to the circle is onto (in the HoTT sense) <em>but</em> $\Delta 1 \to \Delta S^1$ is <em>not</em> epi in setoids, because that would split $1 \to S^1$.</p>

<p>Here is an obvious try: use the propositional truncation and define
$$
T = \Sigma (x : A) . \|\mathrm{Id}_A(s (r \, x), x) \|.
$$
Now (1) does not pose a problem anymore. However, in order for $\Delta T$ to be isomorphic to $(A, {=_A})$ we will need to know that $x =_A y$ is an h-proposition for all $x, y : A$.</p>

<p>This is as far as I wish to descend into the setoid hell.</p>
