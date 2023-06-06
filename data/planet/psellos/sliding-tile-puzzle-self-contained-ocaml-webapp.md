---
title: Sliding Tile Puzzle, Self-Contained OCaml Webapp
description:
url: http://psellos.com/2020/03/2020.03.how-i-wrote-elastic-man.html
date: 2020-03-21T19:00:00-00:00
preview_image:
featured:
authors:
- Psellos
---

<div class="date">March 21, 2020</div>

<p>I just finished coding up another webapp in OCaml. I thought it would be
cool to publish the sources of a small, completely self-contained app.
It&rsquo;s a sliding tile puzzle coded entirely in OCaml, using a few of the
BuckleScript extensions. There are no dependencies on any frameworks or
the like aside from the Js modules of BuckleScript. The app itself
consists of just one JavaScript file&mdash;no images, nothing else.</p>

<table class="morelikealist" style="margin-top: 0.4em;">
<tr><td>
<a href="http://psellos.com/ocaml/example-app-slide24.html">
<img src="http://psellos.com/images/slide242-220.png"/><br/>
</a>
</td></tr>
</table>

<p>You can try out the puzzle or get the sources at the
<a href="http://psellos.com/ocaml/example-app-slide24.html">Slide24</a> page.</p>

<p>I also tried to make a clean DOM interface based on experience with the
Cassino and Schnapsen apps. I think it came out well, at least for these
self-contained webapps.</p>

<p>The idea for the DOM interface is that it should expose only abstract
types, but that there should be a subtype relation based on the
JavaScript DOM. It turns out that you can do this pretty easily using
<code>private</code> declarations. Types for contents of a document look like this:</p>

<pre><code>type node
type text = private node
type element = private node
type canvas = private element
type box = private element
type div = private box
type span = private box
type button = private box</code></pre>

<p>So, the interface reveals nothing whatsoever about the types except that
they participate in a subtype relation. <code>text</code> and <code>element</code> are
subtypes of <code>node</code>, <code>canvas</code> is a subtype of <code>element</code>, and so on.
<code>node</code> is the supertype of all the document content types.</p>

<p>What this means is that you can pass a canvas or a button to a function
that expects an element, and so on. I don&rsquo;t find the necessity to use
explicit supertype coercion to be too much trouble when working with
non-parameterized types.</p>

<pre><code>let style = Pseldom.(element_style (mybutton :&gt; element)) in
. . .</code></pre>

<p>It seems to me this captures pretty much everything that I want from the
object-oriented approach without the usual complicated baggage. I think
inheritance is more often a hindrance than a help. It&rsquo;s too dependent on
implementation details, and is associated with too many informal
(unenforceable) descriptions of how to write subclasses of each class
without messing up the semantics.</p>

<p>I&rsquo;ve never used <code>private</code> declarations before, but they seem to have
created exactly the structure I was hoping for.</p>

<p>Posted by: <a href="http://psellos.com/aboutus.html#jeffreya.scofieldphd">Jeffrey</a></p>

<p></p>

