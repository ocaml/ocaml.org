---
title: Formal proof and analysis of an incremental cycle detection algorithm
description:
url: http://gallium.inria.fr/blog/incremental-cycle-detection
date: 2019-02-12T08:00:00-00:00
preview_image:
featured:
authors:
- gallium
---



<p>As part of my PhD at Gallium, I have been working on formally proving
OCaml programs using Coq. More precisely, the focus has been on proving
not only that a program is functionally correct (always compute the
right result), but also does so in the expected <em>amount of time</em>.
In other words, we are interested in formally verifying the asymptotic
complexity of OCaml programs.</p>
<p>In this blog-post, I&rsquo;m happy to report on our latest endeavour: the
verification of the correctness and (amortized) complexity of a
state-of-the art incremental cycle detection algorithm.</p>




<p>This is joint work with Jacques-Henri Jourdan and my advisors
Fran&ccedil;ois Pottier and Arthur Chargu&eacute;raud.</p>
<p>The initial motivation for this work comes from the implementation of
Coq itself! More specifically, efficiently checking the consistency of
universe constraints that result from the type-checking phase is a
difficult problem, that can be seen as an incremental cycle detection
problem. A few years ago, Jacques-Henri reimplemented the part of Coq
responsible for this, following a state-of-the-art algorithm <a href="https://dl.acm.org/citation.cfm?doid=2846106.2756553">published by
Bender, Fineman, Gilbert and Tarjan</a>. They prove that using their
algorithm, adding an edge in a graph with <span class="math inline"><em>m</em></span> edges and <span class="math inline"><em>n</em></span> nodes <em>while ensuring that
after each addition the graph remains acyclic</em> has amortized
asymptotic complexity <span class="math inline"><em>O</em>(min(<em>m</em><sup>1/2</sup>,<em>n</em><sup>2/3</sup>))</span>.
In the common case where the graph is sparse enough, this is equivalent
to <span class="math inline"><em>O</em>(&radic;<em>m</em>)</span>.</p>
<p>Jacques-Henri&rsquo;s implementation resulted in a nice speedup in
practice, but it is not so easy to convince oneself that it indeed has
the right asymptotic complexity in all cases (in other words, that it
does not have a &ldquo;complexity bug&rdquo;). The amortized analysis required to
establish the <span class="math inline"><em>O</em>()</span> bound on
paper is quite subtle, and for instance relies on a parameter <span class="math inline"><em>&Delta;</em></span> computed at runtime that looks
quite magical at first glance.</p>
<p>In the work I&rsquo;m presenting here, we try to untangle this mystery. We
give a formally verified OCaml implemention for a (slightly modified)
incremental cycle detection algorithm from Bender et al.&nbsp;We prove that
it is not only correct, but also satisfies the expected complexity
bound.</p>
<p>Note that this is not yet the exact algorithm that is currently part
of Coq&rsquo;s implementation, but still an important milestone on the way
there! (Coq implements the variant by Bender et al.&nbsp;that additionally
maintains &ldquo;strong components&rdquo;. We believe it could be implemented and
verified in a modular fashion, by combining the algorithm we present
here and a <a href="http://gallium.inria.fr/~fpottier/publis/chargueraud-pottier-uf-sltc.pdf">union-find
data structure</a>.)</p>
<p>Here&rsquo;s the draft (currently under submission), and a link to the
OCaml code and Coq proofs:</p>
<p><a href="http://gallium.inria.fr/~fpottier/publis/gueneau-jourdan-chargueraud-pottier-2019.pdf" class="uri">http://gallium.inria.fr/~fpottier/publis/gueneau-jourdan-chargueraud-pottier-2019.pdf</a></p>
<p><a href="https://gitlab.inria.fr/agueneau/incremental-cycles" class="uri">https://gitlab.inria.fr/agueneau/incremental-cycles</a></p>
<blockquote>
<p>We exploit Separation Logic with Time Credits to verify the
correctness and worst-case amortized asymptotic complexity of a
state-of-the-art incremental cycle detection algorithm.</p>
</blockquote>
<p>Happy reading!</p>



