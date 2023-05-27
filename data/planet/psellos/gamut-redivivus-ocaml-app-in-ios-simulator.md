---
title: 'Gamut Redivivus: OCaml App in iOS Simulator'
description:
url: http://psellos.com/2015/04/2015.04.example-app-gamut.html
date: 2015-04-29T19:00:00-00:00
preview_image:
featured:
authors:
- Psellos
---

<div class="date">April 29, 2015</div>

<div class="screenminiature" style="margin-top: 1.4em;">
<a href="http://psellos.com/ocaml/example-app-gamut.html"><img src="http://psellos.com/images/gamut2-sky-blue-150.png"/></a>
</div>

<p>I recently revitalized an OCaml app from a few years ago, one that runs
in the iOS simulator. Instructions for downloading, building, and
running the app are here:</p>

<blockquote>
  <p><a href="http://psellos.com/ocaml/example-app-gamut.html">Gamut: Explore Colors in iOS Simulator</a></p>
</blockquote>

<p>You can download the sources directly here:</p>

<blockquote>
  <p><a href="http://psellos.com/pub/gamut/gamut-sim-2.0.3.tgz">Gamut 2.0.3, OCaml app for iOS Simulator 8.2 (32 KB)</a></p>
</blockquote>

<p>Although the app doesn&rsquo;t do anything particularly impressive, I still
find it mesmerizing and fun. But mostly it just shows how to get an
OCaml app running in the iOS Simulator.</p>

<p>Here are some insights I had while revitalizing the app:</p>

<ul>
<li><p>When calling OCaml from the Objective C world, don&rsquo;t pass expressions
as parameters if they cause allocation in OCaml. I wrote about this in
<a href="http://psellos.com/2015/01/2015.01.gc-disharmony-bis.html">Further OCaml GC Disharmony</a>.</p></li>
<li><p>The geometry of an iOS app needs to be a lot more fluid than it used
to be. Statically, there are many different device sizes. But also the
shape of the screen changes dynamically at times. Believe it or not, I
recoded Gamut so the display continues to look good when you receive a
simulated incoming call. (A small change in such a simple app.)</p></li>
<li><p>It would be frightening to receive a simulated incoming call and find
that it was a simulated version of your mother calling from your
childhood to say that dinner is ready.</p></li>
<li><p>You can re-use the drawing code of your app to draw an icon with a
more squarish shape.</p></li>
</ul>

<p>Now, reader, I have to rush off to my desk in an arcane underground DNA
lab to learn about general-purpose GPU-based processing. It would be a
blast to see it work in an iOS app someday. If you have any trouble (or
success) getting Gamut to work for you, leave a comment below or email
me at <a href="mailto:jeffsco@psellos.com">jeffsco@psellos.com</a>.</p>

<p>Posted by: <a href="http://psellos.com/aboutus.html#jeffreya.scofieldphd">Jeffrey</a></p>

<p></p>

