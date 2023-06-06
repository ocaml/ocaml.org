---
title: OCaml for iOS Bug Fix Releases
description:
url: http://psellos.com/2016/01/2016.01.the-minor-drag.html
date: 2016-01-23T19:00:00-00:00
preview_image:
featured:
authors:
- Psellos
---

<div class="date">January 23, 2016</div>

<p>If you downloaded one of the OCaml compilers for iOS or the iOS
Simulator, please download a new copy. Due to an error in the
cross-compile build process, the compilers are looking for <code>ocamlrun</code> in
my development tree rather than in the install location. As a result,
they work for me but for nobody else. Unfortunately this means I didn&rsquo;t
see the problem in my testing.</p>

<div class="flowaroundimg" style="margin-top: 1.0em;">
<a href="http://psellos.com/ocaml/compile-to-iphone.html"><img src="http://psellos.com/images/voronoi-lighthouse-160.png" alt="Voronoi Image"/></a>
</div>

<p>You can download the updated compilers here:</p>

<blockquote>
  <p>&bull; <a href="http://psellos.com/pub/ocamlios/OCamliOS32-4.02.3.pkg">OCamliOS 4.02.3 for 32-bit iOS</a> (updated Jan 23, 2016)  </p>
  
  <p>&bull; <a href="http://psellos.com/pub/ocamlios/OCamliOS64-4.02.3.pkg">OCamliOS 4.02.3 for 64-bit iOS</a> (updated Jan 23, 2016)  </p>
  
  <p>&bull; <a href="http://psellos.com/pub/ocamlios/OCamliOSSim32-4.02.3.pkg">OCamliOS 4.02.3 for 32-bit iOS Simulator</a> (updated Jan 23, 2016)  </p>
  
  <p>&bull; <a href="http://psellos.com/pub/ocamlios/OCamliOSSim64-4.02.3.pkg">OCamliOS 4.02.3 for 64-bit iOS Simulator</a> (updated Jan 23, 2016)  </p>
</blockquote>

<p>In the big picture I guess this is an amusing type of bug to have. But
in the short term it&rsquo;s a bit of a drag. My apologies to anybody who was
inconvenienced.</p>

<p>Thanks to Edgar Aroutiounian for finding the problem.</p>

<p>If you find more problems with the compilers, I&rsquo;d be happy to hear about
them.  Or if you have any comments or encouragement, leave them below or
email me at <a href="mailto:jeffsco@psellos.com">jeffsco@psellos.com</a>.</p>

<p>Posted by: <a href="http://psellos.com/aboutus.html#jeffreya.scofieldphd">Jeffrey</a></p>

<p></p>

