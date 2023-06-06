---
title: 'FP-Syd #28.'
description:
url: http://www.mega-nerd.com/erikd/Blog/FP-Syd/fp-syd-28.html
date: 2010-09-21T10:12:00-00:00
preview_image:
featured:
authors:
- mega-nerd
---



<p>
On Thursday September 16th, we held the 28th meeting of the Sydney Functional
Programming group.
The meeting was held at Google's Sydney offices and we had a bit less than 20
people show up to hear our two presenters.
</p>

<p>
First up we had Shane Stephens with a presentation titled
	<a href="https://docs.google.com/present/edit?id=0AarxCNC60L1qZGYzNHdoOXJfNDJndmtzeDhoag&amp;hl=en">
	&quot;Exploring 3D Graphics with Togra&quot;</a>.
Togra
	<a href="http://github.com/shans/togra">
	(code available here)</a>
is a library for 3D graphics that Shane has at different times tried implementing
in Python (with C for speed), Ocaml and Haskell before settling on the use of
	<a href="http://www.haskell.org/arrows/">
	Arrows</a>
in Haskell.
</p>

<p>
Shane started off showing how he used to do it in Python and C and explained
that the Python/C code was difficult to maintain and contained significant chunks
of code that implemented type checking of data objects passed from Python.
He also mentioned very briefly a failed attempt to implement the library with
Monads.
With the library is not finished, or even really ready for playing with Shane
does think that Arrows are the right solution.
</p>

<p>
Our second presenter for the evening was Anthony Sloane of Macquarie University
on the subject of the
	<a href="http://code.google.com/p/kiama/wiki/Research">
	&quot;Launchbury's Natural Semantics for Lazy Evaluation&quot;</a>
with Scala code available on the same page.
Tony set up a simple language and then walked us through the reduction rules
for the language.
This was a real nice introduction to a topic that can be daunting for people
unfamiliar with the topic.
</p>

<p>
A big thanks to Shane and Tony for presenting and Google for providing the
meeting venue and refreshments.
</p>



