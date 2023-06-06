---
title: Announcing LNgen
description:
url: https://coq.inria.fr/news/announcing-lngen.html
date: 2009-03-11T20:00:00-00:00
preview_image:
featured:
authors:
- coq
---


<p>Stephanie Weirich and Brian Aydemir are pleased to announce 
<a href="http://web.archive.org/web/20100716005113/http://www.cis.upenn.edu/~baydemir/papers/lngen/">LNgen</a>, 
a prototype tool for generating Coq code for the infrastructure associated with a
locally nameless representation. This work builds upon their work with
Chargu&eacute;raud, Pierce, and Pollack on Engineering Formal Metatheory,
where they described a locally nameless strategy for representing
languages with binding.</p>
<p><a href="http://web.archive.org/web/20100716005113/http://www.cis.upenn.edu/~baydemir/papers/lngen/">LNgen</a> uses a subset of the <a href="http://www.cl.cam.ac.uk/~pes20/ott/">Ott specification language</a> as its input
language. Currently, it supports the definition of syntax with single
binders. Compared to the recently announced <a href="http://www.di.ens.fr/~zappa/projects/ln_ott/">locally nameless backend
for Ott</a>, LNgen does not handle the definition of relations, but it
does generate a large collection of &quot;infrastructure&quot; lemmas and their
proofs, e.g., facts about substitution.</p>

 
