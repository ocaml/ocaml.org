---
title: Archimedean Solids in OCaml
description:
url: http://psellos.com/2012/10/2012.10.eurekaslam-1.html
date: 2012-10-13T19:00:00-00:00
preview_image:
featured:
authors:
- Psellos
---

<div class="date">October 13, 2012</div>

<p>One of the many ideas I have on the back burner is to apply
&ldquo;crowdsourcing&rdquo; to the age-old question of whether the Platonic solids
or the Archimedean solids are cooler.  One day I&rsquo;d like to make an OCaml
iOS app that shows a pair of the different masters&rsquo; polyhedra and lets
you vote on which is cooler.</p>

<div class="flowaroundimg" style="margin-top: 1.0em;">
<a href="https://forge.ocamlcore.org/projects/polydroml/"><img src="http://psellos.com/images/girco-waikawa-p3.png"/></a>
</div>

<p>Recently I was delighted to find that there&rsquo;s a little OCaml library
called <a href="https://forge.ocamlcore.org/projects/polydroml/">Polydroml</a> that calculates geometric information for
nearly all the uniform polyhedra.  It&rsquo;s based on the <a href="http://en.wikipedia.org/wiki/Wythoff_construction">Wythoff
construction</a>, which unifies all the different polyhedra
through the single idea of tiling the surface of the sphere with
spherical triangles.</p>

<p>Polydroml is the work of Fabian Pijcke and Pierre Hauweele.  The current
Polydroml code supports all but four of the Archimedean solids.  I&rsquo;m the
kind of guy who likes to collect the whole set, so I spent a couple days
adding support for two more polyhedra to the library.</p>

<p>The two I added are the <a href="http://en.wikipedia.org/wiki/Truncated_cuboctahedron">great rhombicuboctahedron</a> (shown in the
figure) and the <a href="http://en.wikipedia.org/wiki/Truncated_icosidodecahedron">great rhombicosidodecahedron</a>.  They&rsquo;re
characterized by the fact that their vertices are located <em>inside</em> the
spherical triangles of the Wythoff construction&mdash;not on their edges.  As
a result, they have more faces than the simpler polyhedra and hence are
cooler.  (But don&rsquo;t let me influence your vote when the app comes out.)</p>

<p>I fear there aren&rsquo;t many people working with polyhedra in OCaml, but
maybe I&rsquo;ll be pleasantly surprised.  If you&rsquo;re interested you can get
Polydroml itself, my patch to Polydroml, or a version of Polydroml with
my patch already applied, at the following links:</p>

<ul>
<li><a href="http://psellos.com/pub/eurekaslam/polydroml-0.1.0.zip">Polydroml 0.1.0, repackaged as a zipfile</a></li>
<li><a href="http://psellos.com/pub/eurekaslam/incenter-1.0.0.diff">Incenter 1.0.0, extra polyhedra patch for Polydroml</a></li>
<li><a href="http://psellos.com/pub/eurekaslam/polydromlp-0.1.0.zip">Polydroml 0.1.0, with extra polyhedra patch</a></li>
</ul>

<p>(For convenience I&rsquo;ve repackaged Polydroml as a zipfile&mdash;see the library
link above for information on the official release.  I have no
relationship to the authors of Polydroml, other than that I think they
must be pretty cool.)</p>

<p>The final two unimplemented Archimedean solids are so-called &ldquo;snub&rdquo;
forms, which are possibly the coolest of all the convex uniform
polyhedra (just my opinion&mdash;not an official endorsement).  I&rsquo;m hoping to
add support for them pretty soon, after some further study of the
Wythoff construction.</p>

<p>I enjoyed learning some spherical geometry while working on this:</p>

<ul>
<li><p>A spherical triangle is determined by its three angles (no similar
triangles on the sphere).</p></li>
<li><p>Spherical lines (great circles) intersect in two points!</p></li>
<li><p>Need to do constructions on the surface of the sphere, not in the
plane of your triangle!</p></li>
</ul>

<p>It gives me newfound respect for Archimedes, who somehow figured it all
out while relaxing in the bath.</p>

<p>If you have comments or questions, please leave them below, or email me
at <a href="mailto:jeffsco@psellos.com">jeffsco@psellos.com</a>.</p>

<p>Posted by: <a href="http://psellos.com/aboutus.html#jeffreya.scofieldphd">Jeffrey</a></p>

<p></p>

