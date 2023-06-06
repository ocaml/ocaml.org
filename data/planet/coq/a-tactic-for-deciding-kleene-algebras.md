---
title: A tactic for deciding Kleene algebras
description:
url: https://coq.inria.fr/news/a-tactic-for-deciding-kleene-algebras.html
date: 2009-06-09T20:58:00-00:00
preview_image:
featured:
authors:
- coq
---


<p>Thomas Braibant and Damien Pous are pleased to announce the first release of ATBR, a Coq library whose aim is to provide tools for working with various algebraic structures, including non-commutative idempotent semirings and Kleene algebras.</p>
<p>The main tactic they provide in this library is a reflexive tactic for solving (in)equations in Kleene algebras. The decision procedure goes through standard finite automata constructions, that they formalized.</p>
<p>For example, this tactic automatically solves goals of the form <code>a#*(b+a#*(1+c))# == (a+b+c)# or a*b*c*a*b*c*a# &lt;= a#*(b*c+a)#</code>, where <code>a</code>, <code>b</code>, and <code>c</code> are elements of an arbitrary Kleene algebra (binary relations, regular languages, min-max expressions...), <code>#</code> is the (postfix) star operation, <code>*</code> is the infix product or concatenation operation, <code>+</code> is the sum or union operation, and <code>1</code> is the neutral element for <code>*</code>.</p>
<p>In order to define this tactic, they had to work with matrices, so that the ATBR library also contains a new formalisation of matrices in Coq along with a set of tools (notably, &quot;ring&quot;-like tactic for matrices whose dimensions are not necessarily uniform).</p>
<p>More details can be found from <a href="https://github.com/coq-contribs/atbr"> Coq user contribution web-page</a></p>
<p>In particular, a Coq file illustrating the kind of tools we provide can be found <a href="https://github.com/coq-contribs/atbr/blob/master/Examples.v">there</a>.</p>

 
