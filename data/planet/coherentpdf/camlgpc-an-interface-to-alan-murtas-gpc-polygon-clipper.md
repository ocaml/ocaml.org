---
title: "CamlGPC: An interface to Alan Murta\u2019s GPC Polygon Clipper"
description:
url: https://coherentpdf.com/blog/?p=60
date: 2013-08-21T14:29:53-00:00
preview_image:
featured:
authors:
- coherentpdf
---

<p>Some of our coherence 2D graphics renderer examples used to rely on being able to robustly intersect and union polygons.</p>
<p>For this, we used an interface to the <a href="http://www.cs.man.ac.uk/~toby/gpc/">General Polygon Clipper</a>, which is a fast C library for such operations. Unfortunately, it&rsquo;s only free for non-commercial use. And so, to use our OCaml interface in commercial applications, you need to obtain a license from the University of Manchester.</p>
<p>Our interface is up at <a href="https://github.com/johnwhitington/camlgpc">github</a>.</p>
<p>The easiest way to install is through OPAM:</p>
<p>opam install camlgpc</p>


