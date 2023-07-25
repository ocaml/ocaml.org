---
title: Continuity principles and the KLST theorem
description:
url: http://math.andrej.com/2023/07/19/continuity-principles-and-the-klst-theorem/
date: 2023-07-18T22:00:00-00:00
preview_image:
featured:
authors:
- Andrej Bauer
source:
---

<p>On the occasion of Dieter Spreen's 75th birthday there will be a Festschrift in the <a href="http://logicandanalysis.org/index.php/jla">Journal of Logic and Analysis</a>. I have submitted a paper <em>&ldquo;Spreen spaces and the synthetic Kreisel-Lacombe-Shoenfield-Tseitin theorem&rdquo;</em>, available as a preprint <a href="https://arxiv.org/abs/2307.07830">arXiv:2307.07830</a>,  that develops a constructive account of Dieter's generalization of a famous theorem about continuity of computable functions. In this post I explain how the paper fits into the more general topic of continuity principles.</p>



<p>A <strong>continuity principle</strong> is a statement claiming that all functions from a given class are continuous. A silly example is the statement</p>

<blockquote>
  <p><em>Every map $f : X \to Y$ from a discrete space $X$ is continuous.</em></p>
</blockquote>

<p>The dual</p>

<blockquote>
  <p><em>Every map $f : X \to Y$ to an indiscrete space $Y$ is continuous.</em></p>
</blockquote>

<p>is equally silly, but these two demonstrate what we mean.</p>

<p>In order to find more interesting continuity principles, we have to look outside classical mathematics.
A famous continuity principle was championed by Brouwer:</p>

<blockquote>
  <p><strong>Brouwer's continuity principle:</strong> <em>Every $f : \mathbb{N}^\mathbb{N}\to \mathbb{N}$ is continuous.</em></p>
</blockquote>

<p>Here continuity is taken with respect to the discrete metric on $\mathbb{N}$ and the complete metric on $\mathbb{N}^\mathbb{N}$ defined by</p>

<p>$$\textstyle d(\alpha, \beta) = \lim_n 2^{-\min \lbrace k \in \mathbb{N} \,\mid\, k = n \lor \alpha_k \neq \beta_k\rbrace}.$$</p>

<p>The formula says that the distance between $\alpha$ and $\beta$ is $2^{-k}$ if $k \in \mathbb{N}$ is the least number such that $\alpha_k \neq \beta_k$. (The limit is there so that the definition works constructively as well.) Brouwer's continuity principle is valid in the <a href="https://ncatlab.org/nlab/show/function+realizability">Kleene-Vesley topos</a>.</p>

<p>In the <a href="https://ncatlab.org/nlab/show/effective+topos">effective topos</a> we have the following continuity principle:</p>

<blockquote>
  <p><strong>KLST continuity principle:</strong> <em>Every map $f : X \to Y$ from a complete separable metric space $X$ to a metric space
$Y$ is continuous.</em></p>
</blockquote>

<p>The letters K, L, S, and T are the initials of
<a href="https://en.wikipedia.org/wiki/Georg_Kreisel">Georg Kreisel</a>,
<a href="https://mathgenealogy.org/id.php?id=290439">Daniel Lacombe</a>,
<a href="https://en.wikipedia.org/wiki/Joseph_R._Shoenfield">Joseph R. Shoenfield</a>, and
<a href="https://en.wikipedia.org/wiki/Grigori_Tseitin">Grigori Tseitin</a>,
who proved various variants of this theorem in the context of computability theory (the above version is closest to Tseitin's).</p>

<p>A third topos with good continuity principles is Johnstone's <a href="https://doi.org/10.1112/plms/s3-38.2.237 - [403 Forbidden]">topological topos</a>, see Section 5.4 of Davorin Le&scaron;nik's <a href="https://arxiv.org/abs/2104.10399">PhD dissertaton</a> for details.</p>

<p>There is a systematic way of organizing such continuity principles with <a href="https://ncatlab.org/nlab/show/synthetic+topology">synthetic topology</a>. Recall that in synthetic topology we start by axiomatizing an object $\Sigma \subseteq \Omega$ of &ldquo;open truth values&rdquo;, called a <a href="https://ncatlab.org/nlab/show/dominance">dominance</a>, and define the <strong>intrinsic topology</strong> of $X$ to be the exponential $\Sigma^X$. This idea is based on an observation from traditional topology: the topology a space $X$ is in bijective correspondence with continuous maps $\mathcal{C}(X, \mathbb{S})$, where $\mathbb{S}$ is the <a href="https://en.wikipedia.org/wiki/Sierpi%C5%84ski_space">Sierpinski space</a>.</p>

<p>Say that a map $f : X \to Y$ is <strong>intrinsically continuous</strong> when the invese image map $f^\star$ maps intrinsically open sets to intrinsically open sets.</p>

<blockquote>
  <p><strong>Intrinsic continuity principle:</strong> <em>Every map $f : X \to Y$ is intrinsically continuous.</em></p>
</blockquote>

<p><em>Proof.</em> The inverse image $f^\star(U)$ of $U \in \Sigma^Y$ is $U \circ f \in \Sigma^X$. &#9633;</p>

<p>Given how trivial the proof is, we cannot expect to squeeze much from the intrinsic continuity principle. In classical mathematics the principle is trivial because there $\Sigma = \Omega$, so all intrinsic topologies are discrete.</p>

<p>But suppose we knew that the intrinsic topologies of $X$ and $Y$ were <strong>metrized</strong>, i.e., they coincided with metric topologies induces by some metrics $d_X : X \times X \to \mathbb{R}$ and $d_Y : Y \times Y \to \mathbb{R}$. Then the intrinsic continuity principle would imply that every map $f : X \to Y$ is continuous  with respect to the metrics. But can this happen? In &ldquo;<a href="https://doi.org/10.1016/j.apal.2011.06.017">Metric spaces in synthetic topology</a>&rdquo; by Davorin Le&scaron;nik and myself we showed that in the Kleene-Vesley topos the intrinsic topology of a complete separable metric space is indeed metrized. Consequently, we may factor Brouwer's continuity principles into two facts:</p>

<ol>
  <li>Easy general fact: the intrinsic continuity principle.</li>
  <li>Hard specific fact: in the Kleene-Vesley topos the intrinsic topology of a complete separable metric space are metrized.</li>
</ol>

<p>Can we similarly factor the KLST continuity principle? I give an affirmative answer in the <a href="https://arxiv.org/abs/2307.07830">submitted
paper</a>, by translating Dieter Spreen's &ldquo;<a href="https://doi.org/10.2307/2586596">On Effective Topological
Spaces</a>&rdquo; from computability theory and numbered sets to synthetic topology. What comes
out is a new topological separation property:</p>

<blockquote>
  <p><strong>Definition:</strong> A <strong>Spreen space</strong> is a topological space $(X, \mathcal{T})$ with the following separation property:
if $x \in X$ is separated from an overt $T \subseteq X$ by an intrinsically open subset, then it is already separated
from it by a $\mathcal{T}$-open subset.</p>
</blockquote>

<p>Precisely, a Spreen space $(X, \mathcal{T})$ satisfies: if $x \in S \in \Sigma^X$ and $S$ is disjoint from an overt $T \subseteq X$, then there is an open $U \in \mathcal{T}$ such that $x \in U$ and $U \cap T = \emptyset$. The synthetic KLST states:</p>

<blockquote>
  <p><strong>Synthetic KLST continuity principle:</strong> <em>Every map from an overt Spreen space to a pointwise regular space is pointwise continuous.</em></p>
</blockquote>

<p>The proof is short enough to be reproduced here. (I am skipping over some details, the important one being that we require
open sets to be intrinsically open.)</p>

<p><em>Proof.</em> Consider a map $f : X \to Y$ from an overt Spreen space $(X, \mathcal{T}_X)$ to a regular space $(Y, \mathcal{T}_Y)$. Given any $x \in X$ and $V \in \mathcal{T}_Y$ such that $f(x) \in V$, we seek $U \in \mathcal{T}_X$ such that $x \in U \subseteq f^\star(V)$. Because $Y$ is regular, there exist disjoint $W_1, W_2 \in \mathcal{T}_Y$ such that $x \in W_1 \subseteq V$ and $V \cup W_2 = Y$. The inverse image $f^\star(W_1)$ contains $x$ and is intrinsically open. It is also disjoint from $f^\star(W_2)$, which is overt because it is an intrinsically open subset of an overt space. As $X$ is a Spreen space, there exists $U \in \mathcal{T}_X$ such that $x \in U$ and $U \cap f{*}(W_2) = \emptyset$, from which $U \subseteq V$ follows. &#9633;</p>

<p>Are there any non-trivial Spreen spaces? In classical mathematics every Spreen space is discrete, so we have to look elsewhere. I show that they are plentiful in synthetic computability:</p>

<blockquote>
  <p><strong>Theorem (synthetic computability):</strong> <em>Countably based sober spaces are Spreen spaces.</em></p>
</blockquote>

<p>Please consult the paper for the proof.</p>

<p>There is an emergent pattern here: take a theorem that holds under very special circumstances, for instance in a specific topos or in the presence of anti-classical axioms, and reformulate it so that it becomes generally true, has a simple proof, but in order to exhibit some interesting instances of the theorem, we have to work hard. What are some other examples of such theorems? I know of one, namely <a href="https://ncatlab.org/nlab/show/Lawvere's+fixed+point+theorem">Lawvere's fixed point theorem</a>. It took some effort to produce non-trivial examples of it, once again in synthetic computability, see <a href="https://math.andrej.co/2019/11/07/on-fixed-point-theorems-in-synthetic-computability/ - [1 Client error: Couldn't resolve host name]">On fixed-point theorems in synthetic computability</a>.</p>

<p><strong>A note about comments:</strong> I disabled my rudimentary blog commenting system, as it was not working very well and it suffered from bit rot. You are kindly invited to discuss this blog post in this <a href="https://mathstodon.xyz/@andrejbauer/110743580760940344">Mastodon thread</a>.</p>
