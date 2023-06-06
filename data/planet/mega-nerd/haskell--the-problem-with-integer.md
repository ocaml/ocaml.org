---
title: 'Haskell : The Problem with Integer.'
description:
url: http://www.mega-nerd.com/erikd/Blog/CodeHacking/Haskell/integer_pt1.html
date: 2013-12-28T23:08:00-00:00
preview_image:
featured:
authors:
- mega-nerd
---



<p>
Haskellers may or not be aware that there are two libraries in the GHC sources
for implementing the <tt>Integer</tt> data type.
</p>

<p>
The first,
	<a href="http://git.haskell.org/packages/integer-gmp.git"><tt>integer-gmp</tt></a>
links to the
	<a href="https://gmplib.org/">GNU Multiple Precision Arithmetic Library</a>
which is licensed under the GNU LGPL.
On most systems, libgmp is dynamically linked and all is fine.
However, if you want to create statically linked binaries from Haskell source code
you end up with your executable statically linking libgmp which means your binary
needs to be under an LGPL compatible license if you want to release it.
This is especially a problem on iOS which doesn't allow dynamic linking anyway.
</p>

<p>
The second <tt>Integer</tt> implementation is
	<a href="http://git.haskell.org/packages/integer-simple.git"><tt>integer-simple</tt></a>
which is implemented purely in Haskell (using a number of GHC extension) and is
BSD licensed.
</p>

<p>
So why doesn't everyone just the the BSD licensed one?
Well, <tt>integer-simple</tt> has a reputation for being slow.
Even more intriguingly, I seem to remember Duncan Coutts telling me a couple of
years ago that <tt>integer-simple</tt> was a little faster than <tt>integer-gmp</tt>
when the <tt>Integer</tt> was small enough to fit in a single machine <tt>Word</tt>,
but much slower when that was not the case.
At the time I heard this, I decided to look into it at some time.
That time has come.
</p>

<p>
A couple of weeks ago I put together some scripts and code to allow me to compile
the two <tt>Integer</tt> implementations into a single program and benchmark them
against each other.
My initial results looked like this:
</p>

<img src="http://www.mega-nerd.com/erikd/Img/integer-gmp-simple.png" border="0" alt="Integer performance (GMP vs Simple)"/>

<p>
That confirmed the slowness for multiplication and division if nothing else.
</p>

<p>
Taking a look at the code to <tt>integer-simple</tt> I found that it was storing
<tt>Word#</tt>s (unboxed machine sized words) in a Haskell list.
As convenient as lists are they are not an optimal data structure for a something
like the <tt>Integer</tt> library.
</p>

<p>
I have already started work on replacement for both versions of the current
<tt>Integer</tt> library with the following properties:
</p>

<ul>
	<li> BSD licensed.</li>
	<li> Implemented in Haskell (with GHC extensions) so there are no issues
			with linking to external C libraries.</li>
	<li> Fast. I'm aiming to outperform both <tt>integer-simple</tt> and
			<tt>integer-gmp</tt> on as many benchmarks as possible.</li>
	<li> Few dependencies so it can easily replace the existing versions.
			Currently my code only depends on <tt>ghc-prim</tt> and
			<tt>primitive</tt>.</li>
</ul>

<p>
So far the results are looking encouraging.
For <tt>Integer</tt> values smaller than a machine word, addition with my prototype
code is faster than both existing libraries and for adding large integers its
currently half the speed of <tt>integer-gmp</tt>, but I have an idea which will
likely make the new library match the speed of <tt>integer-gmp</tt>.
</p>


