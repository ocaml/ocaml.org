---
title: Begin, Again!
description: The Turtle Moves!
url: https://mort.io/blog/begin-again/
date: 2015-01-15T00:00:00-00:00
preview_image:
authors:
- Richard Mortier
source:
ignore:
keywords:
- MirageOS
- cowabloga
- crunched
- downloadable
- jekyll
- neat
- over-engineered
- parser
- self-contained
- site
---

<p>Specifically, I’ve left <a href="http://www.horizon.ac.uk" rel="external">Horizon</a> and the
<a href="http://www.cs.nott.ac.uk" rel="external">School of Computer Science</a> at the
<a href="http://www.nottingham.ac.uk" rel="external">University of Nottingham</a> to (re-)join the
<a href="http://www.cam.ac.uk" rel="external">Cambridge University</a>
<a href="http://www.cl.cam.ac.uk" rel="external">Computer Laboratory</a>. In celebration, and frankly
because it was long overdue anyway, I’ve reworked my website. What do you think?</p>
<p>For the curious, or the technically inclined, the site now uses
<a href="http://foundation.zurb.com/" rel="external">ZURB Foundation</a> 5.5.0 (the current downloadable release as of
yesterday), with some slightly customised CSS. The site itself is largely
written in <a href="http://daringfireball.net/projects/markdown/" rel="external">Markdown</a> and currently generated using
<a href="http://jekyllrb.com/" rel="external">Jekyll</a> to be hosted on <a href="http://github.com" rel="external">Github</a>.</p>
<p>It’s actually gone through an interim phase where it was parsed by the OCaml
<a href="https://github.com/pw347/omd" rel="external">OMD</a> parser before being crunched into a <a href="https://github.com/mirage/mirage-types" rel="external">Mirage KV_RO</a>
filesystem which is then compiled into a type-safe, self-contained web appliance
that serves these pages and no other using the OCaml <a href="https://github.com/mirage/cowabloga" rel="external">Cowabloga</a>, <a href="https://github.com/mirage/ocaml-cow" rel="external">COW</a> and
<a href="https://github.com/mirage/ocaml-cohttp" rel="external">CoHTTP</a> libraries. This could either be run as a <a href="https://github.com/mirage/mirage-platform/tree/master/unix" rel="external">POSIX binary</a>
or a self-contained <a href="https://github.com/mirage/mirage-platform/tree/master/xen" rel="external">Xen VM</a> depending on what I felt like. Neat eh?
(And for the sceptical among you, yes, a thing <em>can</em> be neat and yet appear
curiously over-engineered at the same time… :)</p>
<p>For the time being however, I’m using it as an excuse to think about what I
might do to better support site generation like this in <a href="https://github.com/mirage/cowabloga" rel="external">Cowabloga</a> so that I
can more seamlessly switch between <a href="http://jekyllrb.com/" rel="external">Jekyll</a> and <a href="http://openmirage.org/" rel="external">Mirage</a>.</p>
