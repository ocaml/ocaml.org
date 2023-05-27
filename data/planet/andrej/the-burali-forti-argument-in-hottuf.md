---
title: The Burali-Forti argument in HoTT/UF
description:
url: http://math.andrej.com/2021/02/22/burali-forti-in-hott-uf/
date: 2021-02-22T08:00:00-00:00
preview_image:
featured:
authors:
- Martin Escardo
---

<p>This is joint work with <a href="https://www.uib.no/en/persons/Marcus.Aloysius.Bezem">Marc Bezem</a>, <a href="https://www.cse.chalmers.se/~coquand/">Thierry Coquand</a>, <a href="https://www.cse.chalmers.se/~peterd/">Peter Dybjer</a>.</p>

<p>We use the
<a href="https://en.wikipedia.org/wiki/Burali-Forti_paradox">Burali-Forti</a>
argument to show that, in <a href="https://homotopytypetheory.org/">homotopy type theory and univalent foundations</a>,
the embedding $$ \mathcal{U} \to \mathcal{U}^+$$ of a universe
$\mathcal{U}$ into its successor $\mathcal{U}^+$ is not an
equivalence.  We also establish this for the types of sets, magmas, monoids and
groups. The arguments in this post are also <a href="https://www.cs.bham.ac.uk/~mhe/TypeTopology/BuraliForti.html#Burali-Forti">written</a> in
<a href="https://agda.readthedocs.io/en/v2.6.1.3/">Agda</a>.</p>



<h4>Ordinals in univalent type theory</h4>

<p>The Burali-Forti paradox is about the collection of all ordinals. In set theory, this collection cannot be a set, because it is too big, and this is what the Burali-Forti argument shows. This collection is a <a href="https://en.wikipedia.org/wiki/Class_(set_theory)">proper class</a> in set theory.</p>

<p>In univalent type theory, we can collect all ordinals of a universe $\mathcal{U}$ in
a type $\operatorname{Ordinal}\,\mathcal{U}$ that lives in the
successor universe $\mathcal{U}^+$: $$
\operatorname{Ordinal}\,\mathcal{U} : \mathcal{U}^+.$$ See Chapter
10.3 of the <a href="https://homotopytypetheory.org/book/">HoTT book</a>, which
uses univalence to show that this type is a set in the sense of
univalent foundations (meaning that its equality is proposition valued).</p>

<p>The analogue in type theory of the notion of proper
class in set theory is that of <a href="https://www.cs.bham.ac.uk/~mhe/TypeTopology/UF-Size.html#is-large">large
type</a>,
that is, a type in a successor universe $\mathcal{U}^+$ that doesn't
have a copy in the universe $\mathcal{U}$. In this post we show that the type of ordinals is large and derive some consequences from this.</p>

<p>We have two further uses of univalence, at least:</p>

<ol>
  <li>
    <p>to adapt the Burali-Forti argument from set theory to our type theory, and</p>
  </li>
  <li>
    <p>to resize down the values of the order relation of the ordinal
of ordinals, to conclude that the ordinal of ordinals is large.</p>
  </li>
</ol>

<p>There are also a number of uses of univalence via functional and
propositional extensionality.</p>

<p><a href="https://unimath.github.io/bham2017/UniMath_origins-present-future.pdf">Propositional resizing</a>
rules or axioms are not needed, thanks to (2).</p>

<p>An ordinal in a universe $\mathcal{U}$ is a type $X : \mathcal{U}$ equipped with a relation
$$ - \prec - : X \to X \to \mathcal{U}$$</p>

<p>required to be</p>

<ol>
  <li>
    <p>proposition valued,</p>
  </li>
  <li>
    <p>transitive,</p>
  </li>
  <li>
    <p>extensional (any two points with same lower set are the same),</p>
  </li>
  <li>
    <p>well founded (every element is accessible, or, equivalently, the
principle of <a href="https://en.wikipedia.org/wiki/Transfinite_induction">transfinite
induction</a>
holds).</p>
  </li>
</ol>

<p>The HoTT book additionally requires $X$ to be a set, but this <a href="https://www.cs.bham.ac.uk/~mhe/TypeTopology/OrdinalNotions.html#extensionally-ordered-types-are-sets">follows
automatically</a> from the above requirements for the order.</p>

<p>The underlying type of an ordinal $\alpha$ is denoted by $\langle
\alpha \rangle$ and its order relation is denoted by $\prec_{\alpha}$ or simply $\prec$ when we believe the reader will be able to infer the missing subscript.</p>

<p>Equivalence of ordinals in universes $\mathcal{U}$ and $\mathcal{V}$,
$$    -\simeq_o- : \operatorname{Ordinal}\,\mathcal{U} \to \operatorname{Ordinal}\,\mathcal{V} \to \mathcal{U} \sqcup \mathcal{V},$$
means that there is an equivalence of the underlying types that
preserves and reflects order. Here we denote by $\mathcal{U} \sqcup \mathcal{V}$ the least upper bound of the two universes $\mathcal{U}$ and $\mathcal{V}$. The precise definition of the type theory we adopt here, including the handling of universes, can be found in <a href="https://www.cambridge.org/core/journals/mathematical-structures-in-computer-science/article/injective-types-in-univalent-mathematics/AFCBBABE47F29ED7AFB4C262929D8810">Section 2 of this paper</a> and also in our <a href="https://www.cs.bham.ac.uk/~mhe/HoTT-UF-in-Agda-Lecture-Notes/index.html">Midlands Graduate School 2019 lecture notes</a> in Agda form.</p>

<p>For ordinals $\alpha$ and $\beta$ in the <strong>same</strong> universe, their
identity type $\alpha = \beta$ is canonically equivalent to the
ordinal-equivalence type $\alpha \simeq_o \beta$, by univalence.</p>

<p>The lower set of a point $x : \langle \alpha \rangle$ is written
$\alpha \downarrow x$, and is itself an ordinal under the inherited
order. The ordinals in a universe $\mathcal{U}$ form an ordinal in the
successor universe $\mathcal{U}^+$, denoted by
$$ \operatorname{OO}\,\mathcal{U} : \operatorname{Ordinal}\,\mathcal{U}^+,$$
for <a href="https://www.cs.bham.ac.uk/~mhe/TypeTopology/OrdinalOfOrdinals.html#OO">ordinal of ordinals</a>.</p>

<p>Its underlying type is $\operatorname{Ordinal}\,\mathcal{U}$ and
its order relation is denoted by $-\triangleleft-$ and is defined by
$$\alpha \triangleleft \beta = \Sigma b : \langle \beta \rangle , \alpha = (\beta \downarrow b).$$</p>

<p>This order has type $$-\triangleleft- : \operatorname{Ordinal}\,\mathcal{U} \to
\operatorname{Ordinal}\,\mathcal{U} \to \mathcal{U}^+,$$ as required for it to make the
type $\operatorname{\operatorname{Ordinal}} \mathcal{U}$ into an ordinal in the next
universe.</p>

<p>By univalence, this order is equivalent to the
order defined by
$$\alpha \triangleleft^- \beta = \Sigma b : \langle \beta \rangle , \alpha \simeq_o (\beta \downarrow b).$$
This has the more general type
$$ -\triangleleft^-- : \operatorname{\operatorname{Ordinal}}\,\mathcal{U} \to \operatorname{\operatorname{Ordinal}}\,\mathcal{V} \to \mathcal{U} \sqcup \mathcal{V},$$
so that we can compare ordinals in different universes. But also when the universes $\mathcal{U}$ and $\mathcal{V}$ are the same, this order has values in $\mathcal{U}$ rather than $\mathcal{U}^+$. The existence of such a resized-down order is crucial for our
corollaries of Burali-Forti, but not for Burali-Forti itself.</p>

<p>For any $\alpha : \operatorname{Ordinal}\,\mathcal{U}$ we have
$$ \alpha \simeq_o (\operatorname{OO}\,\mathcal{U} \downarrow \alpha),$$
so that $\alpha$ is an initial segment of the ordinal of ordinals, and hence
$$ \alpha \triangleleft^- \operatorname{OO}\,\mathcal{U}.$$</p>

<h4>The Burali-Forti theorem in HoTT/UF</h4>

<p>We adapt the original formulation and argument from set theory.</p>

<blockquote>
  <p><strong>Theorem</strong>. No ordinal in a universe $\mathcal{U}$ can be equivalent to the ordinal of all ordinals in $\mathcal{U}$.</p>
</blockquote>

<p><strong>Proof.</strong> Suppose, for the <a href="http://math.andrej.com/2010/03/29/proof-of-negation-and-proof-by-contradiction/">sake of
deriving
absurdity</a>,
that there is an ordinal $\alpha \simeq_o \operatorname{OO}\,\mathcal{U}$ in the universe
$\mathcal{U}$.  By the above discussion, $\alpha \simeq_o \operatorname{OO}\,\mathcal{U} \downarrow
\alpha$, and, hence, by symmetry and transitivity, $\operatorname{OO}\,\mathcal{U} \simeq_o \operatorname{OO}\,\mathcal{U} \downarrow
\alpha$. Therefore, by univalence, $\operatorname{OO}\,\mathcal{U} = \operatorname{OO}\,\mathcal{U} \downarrow \alpha$. But this
means that $\operatorname{OO}\,\mathcal{U} \triangleleft \operatorname{OO}\,\mathcal{U}$, which is impossible as any accessible
relation is irreflexive. $\square$</p>

<p>Some corollaries follow.</p>

<h4>The type of ordinals is large</h4>

<p>We say that a type in the successor universe $\mathcal{U}^+$ is <a href="https://www.cs.bham.ac.uk/~mhe/TypeTopology/UF-Size.html#is-small"><strong>small</strong></a> if it is
equivalent to some type in the universe $\mathcal{U}$, and <a href="https://www.cs.bham.ac.uk/~mhe/TypeTopology/UF-Size.html#is-large"><strong>large</strong></a> otherwise.</p>

<blockquote>
  <p><strong>Theorem</strong>. The type of ordinals of any universe is large.</p>
</blockquote>

<p><strong>Proof.</strong> Suppose the type of ordinals in the universe $\mathcal{U}$
is small, so that there is a type $X : \mathcal{U}$ equivalent to the
type $\operatorname{Ordinal}\, \mathcal{U} : \mathcal{U}^+$. We can
then transport the ordinal structure from the type $\operatorname{Ordinal}\,
\mathcal{U}$ to $X$ along this equivalence to get an ordinal in
$\mathcal{U}$ equivalent to the ordinal of ordinals in $\mathcal{U}$,
which is impossible by the Burali-Forti theorem.</p>

<p>But the proof is not concluded yet, because we have to say how we transport the ordinal structure.  At first sight <a href="https://www.cs.bham.ac.uk/~mhe/TypeTopology/OrdinalsWellOrderTransport.html#transport-ordinal-structure">we should be able to simply apply univalence</a>. However, this is not possible because the types $X : \mathcal{U}$ and $\operatorname{Ordinal}\,\mathcal{U} :\mathcal{U}^+$ live in different universes. The problem is that only elements of the same type can be compared for equality.</p>

<ol>
  <li>
    <p>In the cumulative universe hierarchy of the HoTT book, we
automatically have that $X : \mathcal{U}^+$ and hence, being
equivalent to the type $\operatorname{Ordinal}\,\mathcal{U} :
\mathcal{U}^+$, the type $X$ is equal to the type
$\operatorname{Ordinal}\,\mathcal{U}$ by univalence. But this
equality is an element of an identity type of the universe
$\mathcal{U}^+$. Therefore when we transport the ordinal structure
on the type $\operatorname{Ordinal}\,\mathcal{U}$ to the type $X$
along this equality and equip $X$ with it, we get an ordinal in the
successor universe $\mathcal{U}^+$. But, in order to get the desired
contradiction, we need to get an ordinal in $\mathcal{U}$.</p>
  </li>
  <li>
    <p>In the non-cumulative universe hierarchy we adopt here, we face
essentially the same difficulty. We cannot assert that $X :
\mathcal{U}^+$ but we can promote $X$ to an equivalent type in the
universe $\mathcal{U}^+$, and from this point on we reach the same
obstacle as in the cumulative case.</p>
  </li>
</ol>

<p>So we have to transfer the ordinal structure from $\operatorname{Ordinal}\,\mathcal{U}$ to $X$ <a href="https://www.cs.bham.ac.uk/~mhe/TypeTopology/OrdinalsWellOrderTransport.html">manually</a> along the given equivalence, call it
$$f : X \to \operatorname{Ordinal}\,\mathcal{U}.$$
We define the order of $X$ from that of $\operatorname{Ordinal}\,\mathcal{U}$ by
$$
x \prec y = f(x) \triangleleft f(y).
$$
It is <a href="https://www.cs.bham.ac.uk/~mhe/TypeTopology/OrdinalsWellOrderTransport.html#transfer-structure">laborious but not hard to see</a> that this order satisfies the required axioms for making $X$ into an ordinal, except that it has values in $\mathcal{U}^+$ rather than $\mathcal{U}$. But this problem is solved by instead using the resized-down relation $\triangleleft^-$ discussed above, which is equivalent to $\triangleleft$ by univalence.
$\square$</p>

<h4>There are more types and sets in $\mathcal{U}^+$ than in $\mathcal{U}$</h4>

<p>By a <a href="https://www.cs.bham.ac.uk/~mhe/TypeTopology/UF-UniverseEmbedding.html#is-universe-embedding"><strong>universe embedding</strong></a> we mean a map
$$f : \mathcal{U} \to \mathcal{V}$$
of universes such that, for all $X : \mathcal{U}$,
$$f(X) \simeq X.$$ Of course, any two universe embeddings of $\mathcal{U}$ into $\mathcal{V}$ are equal,
by univalence, so that there is at most one universe embedding between
any two universes.  Moreover, universe embeddings <a href="https://www.cs.bham.ac.uk/~mhe/TypeTopology/UF-UniverseEmbedding.html">are automatically
type embeddings</a> (meaning that they have propositional fibers).</p>

<p>So the following says that the universe $\mathcal{U}^+$ is strictly larger than the
universe $\mathcal{U}$:</p>

<blockquote>
  <p><strong>Theorem.</strong> The universe embedding $\mathcal{U} \to \mathcal{U}^+$ doesn't have a section and therefore is not an equivalence.</p>
</blockquote>

<p><strong>Proof.</strong> A section would give a type in the universe $\mathcal{U}$ equivalent to the type of ordinals in $\mathcal{U}$, but we have seen that there is no such type. $\square$</p>

<p>(However, by Theorem 29 of <a href="https://www.cambridge.org/core/journals/mathematical-structures-in-computer-science/article/injective-types-in-univalent-mathematics/AFCBBABE47F29ED7AFB4C262929D8810">Injective types in univalent mathematics</a>, if propositional resizing holds then the universe embedding $\mathcal{U} \to \mathcal{U}^+$
<a href="https://www.cs.bham.ac.uk/~mhe/TypeTopology/UF-Size.html#Lift-is-section">is a section</a>.)</p>

<p>The same argument of the above theorem shows that there are more sets
in $\mathcal{U}^+$ than in $\mathcal{U}$, because the type of ordinals
is a set. For a universe $\mathcal{U}$ define the type
$$\operatorname{hSet}\,\mathcal{U} : \mathcal{U}^+$$
by
$$ \operatorname{hSet}\,\mathcal{U} = \Sigma A : \mathcal{U} , \text{$A$ is a set}.$$
By an <a href="https://www.cs.bham.ac.uk/~mhe/TypeTopology/UF-UniverseEmbedding.html#is-hSet-embedding"><strong>hSet embedding</strong></a> we mean a map
$$f : \operatorname{hSet}\,\mathcal{U} &rarr; \operatorname{hSet}\,\mathcal{V}$$
such that the underlying type of $f(\mathbb{X})$ is equivalent to the underlying type of $\mathbb{X}$ for every $\mathbb{X} : \operatorname{hSet}\,\mathcal{U}$, that is,
$$
\operatorname{pr_1} (f (\mathbb{X})) &#8771; \operatorname{pr_1}(\mathbb{X}).
$$
Again <a href="https://www.cs.bham.ac.uk/~mhe/TypeTopology/UF-UniverseEmbedding.html#at-most-one-hSet-embedding">there is at most one hSet-embedding</a> between any two universes, hSet-embeddings are type embeddings, and we have:</p>

<blockquote>
  <p><strong>Theorem.</strong> The hSet-embedding $\operatorname{hSet}\,\mathcal{U} \to \operatorname{hSet}\,\mathcal{U}^+$ doesn't have a section and therefore is not an equivalence.</p>
</blockquote>

<h4>There are more magmas and monoids in $\mathcal{U}^+$ than in $\mathcal{U}$</h4>

<p>This is because the type of ordinals is a monoid under
addition with the ordinal zero as its neutral element, and hence also a magma.  If the
inclusion of the type of magmas (respectively monoids) of one universe into that of the
next were an equivalence, then we would have a small copy of the type of ordinals.</p>

<blockquote>
  <p><a href="https://www.cs.bham.ac.uk/~mhe/TypeTopology/BuraliForti.html"><strong>Theorem.</strong></a> The canonical embeddings $\operatorname{Magma}\,\mathcal{U} &rarr; \operatorname{Magma}\,\mathcal{U}^+$ and $\operatorname{Monoid}\,\mathcal{U} &rarr; \operatorname{Monoid}\,\mathcal{U}^+$ don't have sections and hence are not equivalences.</p>
</blockquote>

<h4>There are more groups in $\mathcal{U}^+$ than in $\mathcal{U}$</h4>

<p>This case is more interesting.</p>

<p>The axiom of choice is equivalent to the statement that <a href="https://en.wikipedia.org/wiki/Group_structure_and_the_axiom_of_choice">any non-empty set can
be given the structure of a
group</a>. So
if we assumed the axiom of choice we would be done. But we are brave
and work without assuming excluded middle, and hence without choice, so that our results <a href="https://arxiv.org/abs/1904.07004">hold in any $\infty$-topos</a>.</p>

<p>It is also  the case that <a href="https://homotopytypetheory.org/2021/01/23/can-the-type-of-truth-values-be-given-the-structure-of-a-group/">the type of propositions can be given the structure of a group</a> if and only if the principle of excluded middle holds. And <a href="https://www.cs.bham.ac.uk/~mhe/TypeTopology/OrdinalArithmetic-Properties.html#retract-%CE%A9-of-Ordinal">the type of propositions is a retract of the type of ordinals</a>, which makes it unlikely that the type of ordinals can be given the structure of a group without excluded middle.</p>

<p>So our strategy is to embed the type of ordinals into a group, and the free group does the job.</p>

<ol>
  <li>
    <p>First we need to show that the inclusion of generators, or the
universal map into the free group, <a href="https://www.cs.bham.ac.uk/~mhe/TypeTopology/FreeGroup.html">is an
embedding</a>.</p>
  </li>
  <li>
    <p>But having a large type $X$ embedded into a type $Y$ is not enough
to conclude that $Y$ is also large. For example, if $P$ is a
proposition then the unique map $P \to \mathbb{1}$ is an embedding,
and the unit type $\mathbb{1}$ is small but $P$ may be large.</p>
  </li>
  <li>
    <p>So more work is needed to show that the group freely generated by
the type of ordinals is large. We say that a map is <a href="https://www.cs.bham.ac.uk/~mhe/TypeTopology/UF-Size.html#is-small"><strong>small</strong></a> if
each of its fibers is small, and <strong>large</strong> otherwise.
<a href="https://arxiv.org/abs/2102.08812">De Jong and Escardo</a> showed that
if a map $X \to Y$ is small and the type $Y$ is small, <a href="https://www.cs.bham.ac.uk/~mhe/TypeTopology/UF-Size.html#is-small">then so is
the type
$X$</a>,
and hence if $X$ is large then so is $Y$. Therefore our approach is
to show that the universal map into the free group is small. To <a href="https://www.cs.bham.ac.uk/~mhe/TypeTopology/FreeGroupOfLargeLocallySmallSet.html">do
this</a>,
we exploit the fact that the type of ordinals is <a href="https://arxiv.org/abs/1701.07538">locally
small</a> (<a href="https://www.cs.bham.ac.uk/~mhe/TypeTopology/BuraliForti.html#the-type-of-ordinals-is-locally-small">its identity types are
all equivalent to small
types</a>).</p>
  </li>
</ol>

<p>But we want to be as general as possible, and hence work with a spartan univalent type theory which doesn't include higher inductive types other than propositional truncation. We include the empty type, the unit type, natural numbers, list types (<a href="https://www.cs.bham.ac.uk/~mhe/agda-new/Fin.html#vec">which can actually be constructed from the other type formers</a>), coproduct types, $\Sigma$-types, $\Pi$-types, identity types and a sequence of universes. We also assume the univalence axiom (from which we automatically get functional and propositional extensionality) and the axiom of existence of propositional truncations.</p>

<ol>
  <li>
    <p>We <a href="https://www.cs.bham.ac.uk/~mhe/TypeTopology/FreeGroup.html">construct the free
group</a>
as a quotient of a type of words following <a href="https://www.springer.com/gb/book/9780387966403">Mines, Richman and
Ruitenburg</a>. To
prove that the universal map is an embedding, one first proves a
Church-Rosser property for the equivalence relation on words. It is
remarkable that this can be done without assuming that the set of
generators has decidable equality.</p>
  </li>
  <li>
    <p>Quotients <a href="https://www.cs.bham.ac.uk/~mhe/agda-new/UF-Quotient.html">can be constructed from propositional
truncation</a>. This
construction increases the universe level by one, but eliminates
into any universe.</p>
  </li>
  <li>
    <p>To <a href="https://www.cs.bham.ac.uk/~mhe/TypeTopology/FreeGroupOfLargeLocallySmallSet.html#resize-free-group">resize back</a> the quotient used to construct the group freely
generated by the type of ordinals to the original universe, we
exploit the fact that the type of ordinals is locally small.</p>
  </li>
  <li>
    <p>As above, we have to transfer <a href="https://www.cs.bham.ac.uk/~mhe/TypeTopology/Groups.html#transport-Group-structure"><strong>manually</strong></a> group structures between equivalent types of different universes, because univalence can't be applied.</p>
  </li>
</ol>

<p>Putting the above together, and leaving many steps to the <a href="https://www.cs.bham.ac.uk/~mhe/TypeTopology/BuraliForti.html">Agda code</a>, we get the following in our spartan univalent type theory.</p>

<blockquote>
  <p><a href="https://www.cs.bham.ac.uk/~mhe/TypeTopology/FreeGroupOfLargeLocallySmallSet.html"><strong>Theorem.</strong></a> For any large, locally small set, the free group is also large and locally small.</p>
</blockquote>

<blockquote>
  <p><a href="https://www.cs.bham.ac.uk/~mhe/TypeTopology/BuraliForti.html"><strong>Corollary.</strong></a> In any  successor universe $\mathcal{U}^+$ there is a group which is not isomorphic to any group in the universe $\mathcal{U}$.</p>
</blockquote>

<blockquote>
  <p><a href="https://www.cs.bham.ac.uk/~mhe/TypeTopology/BuraliForti.html"><strong>Corollary.</strong></a> The canonical embedding $\operatorname{Group}\,\mathcal{U} &rarr; \operatorname{Group}\,\mathcal{U}^+$ doesn't have a section and hence is not an equivalence.</p>
</blockquote>

<p>Can we formulate and prove a general theorem of this kind that
specializes to a wide variety of mathematical structures that occur in
practice?</p>
