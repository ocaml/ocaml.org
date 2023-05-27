---
title: Twenty-Four Puzzle OCaml iOS App
description:
url: http://psellos.com/2016/02/2016.02.i-met-up-with-the-king.html
date: 2016-02-18T19:00:00-00:00
preview_image:
featured:
authors:
- Psellos
---

<div class="date">February 18, 2016</div>

<p>I wrote the Slide24 app a few years ago as a semi-credible example of an
iOS app coded in OCaml. It implements the 24 puzzle, a 5 &times; 5 grid of
sliding numbered tiles. I enjoyed the physical version of the puzzle
tremendously as a kid.</p>

<p>I just now updated Slide24 to build under Xcode 7.2, and tested that it
works under iOS 9.2 on every iPhone and iPad device (simulating the ones
I can&rsquo;t find in real life).</p>

<div class="flowaroundimg" style="margin-top: 0.4em;">
<a href="http://psellos.com/ocaml/example-app-slide24.html"><img src="http://psellos.com/images/slide243-160.png" alt="image of Slide24 app"/></a>
</div>

<p>Slide24 has a <em>Solve</em> button that solves the puzzle for you if you don&rsquo;t
have the inclination to do it yourself. While I was updating the rest of
the code, I rewrote the heuristic search to generate solutions that are
more interesting to watch as a spectator. The essence of the improvement
is that the search now gets a pretty good (not optimal) solution, but is
able to solve the whole puzzle at once. I&rsquo;m thankful to Dr. Wheeler Ruml
of the University of New Hampshire for suggestions along these lines.</p>

<p>The new search doesn&rsquo;t quite reach the level of unbelievable perfection
that I was seeking, but it does produce solutions that don&rsquo;t look
anything like what a person would do. When I solve the puzzle I tend to
work on one area at a time, while the heuristic solution makes small
changes all over the place. Then things come together surprisingly
quickly at the end, which is just what I was hoping to see.</p>

<p>If you just want to download Slide24 and build it in Xcode, you can get
the sources here:</p>

<blockquote>
  <p><a href="http://psellos.com/pub/slide24/slide24-3.0.4.tgz">Slide24 3.0.4, tested on iOS 9.2</a>  </p>
</blockquote>

<div style="clear: both"></div>

<p>I&rsquo;ve also written out some instructions and principles of operation
here:</p>

<blockquote>
  <p><a href="http://psellos.com/ocaml/example-app-slide24.html">Slide24: Sliding Tile Puzzle for iOS</a>  </p>
</blockquote>

<p>If you have any comments, suggestions, or encouragement, leave them
below or email me at <a href="mailto:jeffsco@psellos.com">jeffsco@psellos.com</a>.</p>

<p>Posted by: <a href="http://psellos.com/aboutus.html#jeffreya.scofieldphd">Jeffrey</a></p>

<p></p>

