---
title: OCaml on iOS 7 Simulator Released
description:
url: http://psellos.com/2014/09/2014.09.ocamlxsim-401.html
date: 2014-09-08T19:00:00-00:00
preview_image:
featured:
authors:
- Psellos
---

<div class="date">September 8, 2014</div>

<p>Today I&rsquo;m releasing an OCaml compiler for the iOS 7.1 Simulator. It&rsquo;s just a small modification of the standard 32-bit Intel OCaml compiler, but I&rsquo;ve found it helpful and even delightful for developing iOS apps in OCaml.</p>

<p>I affect a bantering tone, but secretly I&rsquo;m honored that the companion <a href="http://psellos.com/2014/08/2014.08.ocamlxarm-402.html">compiler for OCaml on iOS devices</a> recently enjoyed a brief episode of mini-fame in the hacker community. (True meaning of hacker: someone who codes passionately if unwisely.) I hope this effort is also interesting to my hacker brethren and sistren.</p>

<p>OCamlXSim 4.0.1 is a cross-compiling version of OCaml 4.01.0. I&rsquo;m running it under Xcode 5.1.1 on OS X 10.9.4. You can download a binary installer here:</p>

<div class="flowaroundimg" style="margin-top: 1.0em;">
<a href="http://psellos.com/ocaml/compile-to-iossim.html"><img src="http://psellos.com/images/voronoi-lighthouse-p3.png" alt="Voronoi lighthouse looking screen"/></a>
</div>

<blockquote>
  <p><a href="http://psellos.com/pub/ocamlxsim/ocaml-4.01.0+xsim-4.0.1.dmg">OCamlXSim 4.0.1 Installer for OS X 10.9</a></p>
</blockquote>

<p>You can get sources from the Subversion repository here:</p>

<blockquote>
  <p>svn://svn.psellos.com/tags/ocamlxsim-4.0.1</p>
</blockquote>

<p>If you just want to see the differences from the base OCaml 4.01.0 release, the diffs are available here:</p>

<blockquote>
  <p><a href="http://psellos.com/pub/ocamlxsim/ocamlxsim-4.0.1.diff">OCamlXSim 4.0.1 diffs from OCaml 4.01.0</a></p>
</blockquote>

<p>The changes to the compiler itself are quite small; most of the difficulty is in making it into a cross compiler from OS X to the Simulator environment.</p>

<p>A simple test of the installed compiler is given on <a href="http://psellos.com/ocaml/compile-to-iossim.html">Compile OCaml for iOS Simulator</a>. There are also instructions for building from source.</p>

<p>The image above shows the <a href="http://psellos.com/ocaml/example-app-voronoi.html">Voronoi</a> app running in the iOS 7.1 Simulator. Perhaps it&rsquo;s a Pygmalion kind of thing, but I&rsquo;m always shocked how many beautiful images you can create with this app. I&rsquo;ll rewrite the Voronoi app for the latest iOS, and I hope at least one other person will have as much fun with it as I do.</p>

<p>A new revision of OCaml (4.02.0) has just come out, and of course there will always be new revisions of everything. I&rsquo;ll be working on updating everything, but I&rsquo;d also be happy to farm out work to you, reader, or to any interested parties you might know of.</p>

<p>If you find problems with the compiler, I&rsquo;d be glad to hear about them. Or if you have any comments or encouragement, leave them below or email me at <a href="mailto:jeffsco@psellos.com">jeffsco@psellos.com</a>.</p>

<p>Posted by: <a href="http://psellos.com/aboutus.html#jeffreya.scofieldphd">Jeffrey</a></p>

<p></p>

