---
title: Proofs (and Refutations) using Z3
description: People often think of formal methods and theorem provers as forbiddingtools,
  cool in theory but with a steep learning curve that makes themhard to use in rea...
url: https://blog.janestreet.com/proofs-and-refutations-using-z3/
date: 2018-02-15T00:00:00-00:00
preview_image: https://blog.janestreet.com/proofs-and-refutations-using-z3/proof.jpg
featured:
---

<p>People often think of formal methods and theorem provers as forbidding
tools, cool in theory but with a steep learning curve that makes them
hard to use in real life. In this post, we&rsquo;re going to describe a case
we ran into recently where we were able to leverage theorem proving
technology, Z3 in particular, to validate some real world engineering
we were doing on the OCaml compiler. This post is aimed at readers
interested in compilers, but assumes no familiarity with actual
compiler development.</p>


