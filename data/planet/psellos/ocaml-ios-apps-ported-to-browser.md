---
title: OCaml iOS Apps Ported to Browser
description:
url: http://psellos.com/2020/02/2020.02.kid-charlemagne.html
date: 2020-02-24T19:00:00-00:00
preview_image:
featured:
authors:
- Psellos
---

<div class="date">February 24, 2020</div>

<p>Something like ten years ago we produced two iOS card game apps written
in OCaml, partly as a proof of concept for compiling OCaml to iOS and
partly because we enjoy card games. Unfortunately we weren&rsquo;t able to
spark a worldwide craze for writing iOS apps in OCaml or for playing
Schnapsen, as we had hoped. Consequently there was very little financial
return and we all had to move on to other projects.</p>

<p>Both apps play a very good two-player card game. The apps are
essentially a kind of solitaire where you play against the app as your
opponent. The games are:</p>

<ul>
<li><p>Cassino, a classic fishing game said without substantiation to be
of Italian origin (per Wikipedia).</p></li>
<li><p>Schnapsen, a kind of miniature Pinochle very popular in the
territories of the former Austro-Hungarian Empire (again per
Wikipedia).</p></li>
</ul>

<p>The Schnapsen app also plays a closely related game called Sixty-Six,
named after this number in many different languages.</p>

<p>The images and layout algorithms for the apps quickly fell behind the
formats and display capabilities of later iOS devices, so I was thinking
we might just as well release the apps as is, for free. However there is
a lot of rigamarole (and some cost) associated with the App Store if all
you want to do is release some free apps.</p>

<table class="morelikealist" style="margin-top: 0.4em;">
<tr><td>
<a href="http://cassino.psellos.com">
<img src="http://psellos.com/images/cassino-icon45.png"/><br/>
<strong>Cassino</strong>
</a>
</td></tr>
<tr><td>
<a href="http://schnapsen.psellos.com">
<img src="http://psellos.com/images/schnapsen-icon45.png"/><br/>
<strong>Master<br/>Schnapsen/66</strong>
</a>
</td></tr>
</table>

<p>Recently I wondered if it wouldn&rsquo;t be possible to revive the apps in a
browser environment. These days you can compile OCaml to JavaScript
using <a href="https://bucklescript.github.io/">BuckleScript</a> or
<a href="https://ocsigen.org/js_of_ocaml/3.5.1/manual/overview">Js_of_ocaml</a>.
The HTML 5 canvas element has an interface a lot like the
two-dimensional graphics used by the apps. It seems like it should be
possible.</p>

<p>So, in fact, that&rsquo;s what I did. I ported the two card game apps to run
as webapps. Visually they run in a smallish rectangle exactly the size
of the original iPhone screen. I was able to retain the iPhone behavior
almost unchanged. Computationally they run completely in the browser,
and make no further contact with psellos.com (unless you want to access
the game pages at psellos.com).</p>

<p>The OCaml code is compiled to JavaScript using the BuckleScript
compiler. Because the target language is JavaScript, there&rsquo;s no need for
any stubs or supporting code (as there was in iOS). All of the code for
the apps is in OCaml.</p>

<p>Once the basic graphics primitives were in place, a lot of the code
worked without any change. The part of the code that actually plays the
game (the &ldquo;engine&rdquo;) didn&rsquo;t change at all.</p>

<p>As an unexpected and very welcome side effect, two of the old iOS app
team members got interested in the project again. They&rsquo;re working on
making the Schnapsen app into an even better player. I added some extra
features to the Schnapsen GUI to make it easier to keep track of what&rsquo;s
happened in a hand.</p>

<p>Neither of the webapps is quite finished yet. But they both are already
playable and in fact quite enjoyable. You can try them by clicking on
the icons above. You can also read about the apps and the games they
play on their own separate pages.</p>

<ul>
<li><a href="http://psellos.com/cassino">Cassino Page</a></li>
<li><a href="http://psellos.com/schnapsen">Schnapsen Page</a></li>
</ul>

<p>If you have any comments, suggestions, or encouragement, leave them
below or email me at <a href="mailto:jeffsco@psellos.com">jeffsco@psellos.com</a>.</p>

<p>Posted by: <a href="http://psellos.com/aboutus.html#jeffreya.scofieldphd">Jeffrey</a></p>

<p></p>

