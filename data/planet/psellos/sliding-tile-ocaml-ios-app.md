---
title: Sliding Tile OCaml iOS App
description:
url: http://psellos.com/2015/05/2015.05.example-app-slide24.html
date: 2015-05-18T19:00:00-00:00
preview_image:
featured:
authors:
- Psellos
---

<div class="date">May 18, 2015</div>

<div class="screenminiature" style="margin-top: 1.4em;">
<a href="http://psellos.com/ocaml/example-app-slide24.html"><img src="http://psellos.com/images/slide242-220.png"/></a>
</div>

<p>I revamped another OCaml iOS app from a few years ago to make it run
under iOS 8.3. It implements a sliding tile puzzle that was a fad in the
1880s and was also popular in my childhood a few years after that.</p>

<p>Instructions for downloading, building, and running the app are here:</p>

<blockquote>
  <p><a href="http://psellos.com/ocaml/example-app-slide24.html">Slide24: Sliding Tile Puzzle for iOS</a></p>
</blockquote>

<p>You can download the sources directly here:</p>

<blockquote>
  <p><a href="http://psellos.com/pub/slide24/slide24-ios-2.0.2.tgz">Slide24 2.0.2, OCaml app for iOS 8.3 (111 KB)</a></p>
</blockquote>

<p>I had a lot of fun with this puzzle as a kid, and I still find it
enjoyable to play with though it&rsquo;s not particularly challenging to
solve. To make the app more interesting, I coded up a heuristic search
that solves the puzzle.</p>

<p>Here are some insights I had while revamping the app:</p>

<ul>
<li><p>iOS devices have gotten tremendously faster since I wrote the code. I
should rewrite it to solve with fewer moves. I&rsquo;d really love to see
what an extremely short solution looks like. I&rsquo;ll bet it looks
impossibly wise, like those Swedish girls in First Aid Kit.</p></li>
<li><p>It&rsquo;s a little strange for a puzzle to solve itself. Like what if there
was a button on the jigsaw puzzle box that made the pieces crawl
themselves on the table into the solution. It would be fun to watch,
but would it be a puzzle any more? More like a garden I guess.</p></li>
</ul>

<p>Now, reader, it&rsquo;s late at night and I have to rest up. There are
exciting new developments in the OCaml-on-iOS world to talk about in the
coming weeks. A version of the the iOS cross compiler, much improved
with help from the truly knowledgeable, and with support for 64-bit ARM,
will soon be available through OPAM. I&rsquo;m really looking forward to this,
and indeed this is why I&rsquo;m working through these apps as fast as I can.
I&rsquo;m testing them against the new compiler.</p>

<p>If you have any trouble (or success) getting Slide24 to work for you,
leave a comment below or email me at <a href="mailto:jeffsco@psellos.com">jeffsco@psellos.com</a>.</p>

<p>Posted by: <a href="http://psellos.com/aboutus.html#jeffreya.scofieldphd">Jeffrey</a></p>

<p></p>

