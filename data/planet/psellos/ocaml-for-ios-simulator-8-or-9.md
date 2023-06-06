---
title: OCaml for iOS Simulator 8 or 9
description:
url: http://psellos.com/2016/01/2016.01.man-made-lake.html
date: 2016-01-19T19:00:00-00:00
preview_image:
featured:
authors:
- Psellos
---

<div class="date">January 19, 2016</div>

<p>I have no fear that our universe is a simulation being run on some
gigantic machine and watched from outside by transcendant spectators. It
might be that it is&mdash;I&rsquo;m merely saying I have no fear of it. I know this
because I find the iOS Simulator to be delightful and disarming. It
doesn&rsquo;t faze me at all.</p>

<div class="flowaroundimg" style="margin-top: 1.0em;">
<a href="http://psellos.com/ocaml/compile-to-iossim.html"><img src="http://psellos.com/images/bullet-cluster.png" alt="Bullet Cluster image"/></a>
</div>

<p>In recent years I&rsquo;ve been maintaining some patches that transform the
OCaml compiler into a cross compiler for the iOS Simulator. Now there is
an active plan (with the kind help of Gerd Stolpmann) to whip the
patches into shape and to integrate them into the official INRIA OCaml
release, along with the iOS support I mentioned a few days ago.</p>

<p>I&rsquo;m not sure when the OCaml iOS support will be released. But in the
meantime the changes are available in a branch in the official OCaml
GitHub repository. I cloned the branch and built two compilers, for 32-
and 64-bit iOS Simulators.</p>

<p>These compilers are versions of OCaml 4.02.3 that generate apps to run under
the iOS Simulators in Xcode 7.2. You can download binary installers here:</p>

<ul>
<li><a href="http://psellos.com/pub/ocamlios/OCamliOSSim32-4.02.3.pkg">OCamliOS 4.02.3 for 32-bit iOS Simulator</a> (updated Jan 23, 2016)  </li>
<li><a href="http://psellos.com/pub/ocamlios/OCamliOSSim64-4.02.3.pkg">OCamliOS 4.02.3 for 64-bit iOS Simulator</a> (updated Jan 23, 2016)  </li>
</ul>

<p>A simple test of the installed compilers is given on <a href="http://psellos.com/ocaml/compile-to-iossim.html">Compile OCaml for
iOS Simulator</a>. There are also
instructions for building from source.</p>

<p>If you find problems with the compilers, I&rsquo;d be happy to hear about
them.  Or if you have any comments or encouragement, leave them below or
email me at <a href="mailto:jeffsco@psellos.com">jeffsco@psellos.com</a>.</p>

<p>Posted by: <a href="http://psellos.com/aboutus.html#jeffreya.scofieldphd">Jeffrey</a></p>

<p></p>

