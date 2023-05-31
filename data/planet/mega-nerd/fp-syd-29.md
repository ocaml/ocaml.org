---
title: 'FP-Syd #29.'
description:
url: http://www.mega-nerd.com/erikd/Blog/FP-Syd/fp-syd-29.html
date: 2010-11-16T11:12:00-00:00
preview_image:
featured:
authors:
- mega-nerd
---



<p>
On Thursday October 21st, we held the 29th meeting of the Sydney Functional
Programming group.
The meeting was held at Google's Sydney offices and we had about 22 people show
up to hear our two presenters.
</p>

<p>
First up we had
	<a href="http://benjaminjohnston.com.au/">
	Benjamin Johnston</a>
with a presentation titled <i>&quot;How to Dance the Robot&quot;</i>.
As part of his work an University of Technology here in Sydney, Ben gets to
program robots.
One of the results, is robots that dance (thanks to Mark Wotton for capturing
this video on his iPhone):
</p>

<br/><br/>

<center>
<object type="application/x-shockwave-flash" width="480" height="385" data="http://www.youtube.com/v/PhlN_o2CrA0?fs=1&amp;hl=en_US">
	<param name="movie" value="http://www.youtube.com/v/PhlN_o2CrA0?fs=1&amp;hl=en_US"/>
	<param name="wmode" value="transparent"/>
</object>
</center>

<br/><br/>

<p>
Ben's language of choice is Prolog (not functional but definitely
	<a href="http://c2.com/cgi/wiki?DeclarativeProgramming">
	declarative</a>)
and he used Prolog to tackle the problem of making the programming of a
robot dance easier.
A complete dance might last 3 minutes or more, the music is likely to have a
tempo of around 100 beats per minute and the dance moves are usually timed down
to the half beat.
That means some 600 odd half beat events for a 3 minute dance.
Entering 600 odd events manually would be somewhat tedious.
</p>

<p>
Ben's solution to this problem was a compiler for a domain specific language
(DSL) which allowed easier specification of the dance in terms of musical
sections, repeated moves etc.
Writing the compiler was made easier by making good use of Prolog's search and
backtracking capabilities and the compiler generated Python output code that
was uploaded to the robot.
</p>

<p>
Our second presenter for the evening was
	<a href="http://seanseefried.com/">
	Sean Seefried</a>
on the subject of the <i>&quot;The Expression Problem&quot;</i>, in Haskell.
In Sean's paper (with Manuel M. T. Chakravarty),
	<a href="http://www.cse.unsw.edu.au/~chak/papers/exp-problem.pdf">
	<i>&quot;Solving the expression problem with true separate compilation&quot;</i></a>
he describes the expression problem as:
</p>

<blockquote><i>
&quot;the difficulty of extending the variants and methods on a data type without
modifying existing code and while respecting separate compilation&quot;
</i></blockquote>

<p>
There are a number of other languages which have solutions to the expression
problem, but Sean's work was the first real Haskell solution.
With the use of multi-parameter type classes, scoped type variables, kind
annotations, zero constructor data types and recursive dictionaries, Sean was
able to make it work with GHC 6.4 and later.
At the end, Sean also presented some ideas to make the solution of this problem
easier and more practical.
</p>

<p>
A big thanks to Ben and Sean for presenting and Google for providing the
meeting venue and refreshments.
</p>



