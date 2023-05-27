---
title: OCaml for iOS 9.2
description:
url: http://psellos.com/2016/01/2016.01.man-out-of-time.html
date: 2016-01-15T19:00:00-00:00
preview_image:
featured:
authors:
- Psellos
---

<div class="date">January 15, 2016</div>

<p>If the universe has extra dimensions, perhaps we can have experiences in
some orthogonal kind of time without leaving the present moment.
Something like that happened over the holidays, and I was able to put
together binary releases of the most recent OCaml compiler for iOS.</p>

<div class="flowaroundimg" style="margin-top: 1.0em;">
<a href="http://psellos.com/ocaml/compile-to-iphone.html"><img src="http://psellos.com/images/vorobeacon-s35.png" alt="Spacy Voronoi image"/></a>
</div>

<p>For quite a few years I&rsquo;ve been maintaining a set of patches that
transform the OCaml compiler into a cross compiler for iOS. Recently
there has been some work (with the kind help of Gerd Stolpmann) to
improve these patches and incorporate them into the official INRIA OCaml
release.</p>

<p>There&rsquo;s a lot of awesome stuff going on with OCaml these days, so I&rsquo;m
not sure when the iOS support will be released. But in the meantime the
changes are available in a branch of the official OCaml repository. I
checked out the branch and built two compilers, for 32- and 64-bit iOS.</p>

<p>These compilers are versions of OCaml 4.02.3 that run under OS X 10.11
and Xcode 7.2, producing executables for iOS 9.2. You can download
binary installers here:</p>

<ul>
<li><a href="http://psellos.com/pub/ocamlios/OCamliOS32-4.02.3.pkg">OCamliOS 4.02.3 for 32-bit iOS</a> (updated Jan 23, 2016)  </li>
<li><a href="http://psellos.com/pub/ocamlios/OCamliOS64-4.02.3.pkg">OCamliOS 4.02.3 for 64-bit iOS</a> (updated Jan 23, 2016)  </li>
</ul>

<p>A simple test of the installed compiler is given on <a href="http://psellos.com/ocaml/compile-to-iphone.html">Compile OCaml for
iOS</a>. There are also instructions for
building from source.</p>

<p>I hope to find enough fifth dimensional time soon to update the test
apps and the compilers for the iOS Simulator.</p>

<p>If you find problems with the compilers, I&rsquo;d be happy to hear about
them.  Or if you have any comments or encouragement, leave them below or
email me at <a href="mailto:jeffsco@psellos.com">jeffsco@psellos.com</a>.</p>

<p>Posted by: <a href="http://psellos.com/aboutus.html#jeffreya.scofieldphd">Jeffrey</a></p>

<p></p>

