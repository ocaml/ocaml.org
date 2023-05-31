---
title: 'FP-Syd #27.'
description:
url: http://www.mega-nerd.com/erikd/Blog/FP-Syd/fp-syd-27.html
date: 2010-08-21T13:05:00-00:00
preview_image:
featured:
authors:
- mega-nerd
---



<p>
On Thursday August 12th, we held the 27th meeting of the Sydney Functional
Programming group.
The meeting was held at Google's Sydney offices and we had about 20 people show
up to hear our two presenters.
</p>

<p>
First up we had
	<a href="http://www.cse.unsw.edu.au/~benl/">
	Ben Lippmeier</a>
presenting the Haskell library
	<a href="http://hackage.haskell.org/package/repa">REPA</a>
for doing high performance operations on regular, shape polymorphic, parallel
arrays.
Ben showed us some code for written with the REPA library.
The interesting thing about the code was that even though REPA allows parallel
execution on multiple cores, this parallel code is not vastly different from
how someone would write the code to execute on a single code.
Ben also provided some benchmarking figures comparing the multicore Haskell/REPA
code performing well against single core code written in C.
</p>

<p>
Our second presenter for the evening was Simon Winwood who presented on the
subject of the
	<a href="http://www.haskell.org/haskellwiki/Template_Haskell">
	Template Haskell</a>,
which allows type safe, compile time meta programming.
The need for templating in a powerful and flexible language like Haskell is
obviously much less than in languages like C++, but still useful for some tasks
like
	<a href="http://www.haskell.org/ghc/docs/6.12.2/html/users_guide/template-haskell.html#th-quasiquotation">
	quasi-quotation</a>.
The mechanics of TH as such that it allows conversion between Haskell's concrete
syntax and abstract syntax trees which can be manipulated by Haskell code.
One downside of TH is that code relying on regularly breaks when new versions
of the GHC compiler are released.
</p>

<p>
A big thanks to Ben and Simon for presenting and Google for providing the
meeting venue and refreshments.
</p>



