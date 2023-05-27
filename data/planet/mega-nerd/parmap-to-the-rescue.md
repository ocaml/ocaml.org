---
title: parMap to the Rescue.
description:
url: http://www.mega-nerd.com/erikd/Blog/CodeHacking/Haskell/parMap.html
date: 2013-01-22T11:08:00-00:00
preview_image:
featured:
authors:
- mega-nerd
---



<p>
I had a long running, CPU intensive Haskell program that I wanted to speed up.
The program was basically a loop consisting of a a small sequential part
followed by a <tt>map</tt> of a CPU intensive pure function over a list of 1500
elements.
</p>

<p>
Obviously I needed some sort of parallel map function and I had a faint
recollection of a function called <tt>parMap</tt>.
The wonderful
	<a href="http://www.haskell.org/hoogle/">
	Hoogle search engine</a>
pointed me to the
	<a href="http://hackage.haskell.org/packages/archive/parallel/latest/doc/html/Control-Parallel-Strategies.html#v:parMap">
	<tt>parMap</tt> documentation</a>.
</p>

<p>
Changing the existing sequential <tt>map</tt> operation into a parallel map
required a 3 line change (one of them to import the required module).
I then added &quot;<tt>-threaded</tt>&quot; to the compile command line to enable the
threaded runtime system in the generated executable and &quot;<tt>+RTS -N6</tt>&quot; to
the executable's command line.
The resulting program went from using 100% of 1 CPU to using 560% of 1 CPU on an
8 CPU box.
Win!
</p>

<p>
I wish all code was this easy to parallelize.
</p>


