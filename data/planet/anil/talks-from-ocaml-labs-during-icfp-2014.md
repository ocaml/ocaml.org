---
title: Talks from OCaml Labs during ICFP 2014
description: OCaml Labs talks at ICFP 2014, covering language improvements & MirageOS
url: https://anil.recoil.org/notes/ocaml-labs-at-icfp-2014
date: 2014-08-31T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
---

<p>It's the ever-exciting week of the <a href="https://icfpconference.org/">International Conference on
Functional Programming</a> again in Sweden,
and this time <a href="http://ocaml.io">OCaml Labs</a> has a variety of talks,
tutorials and keynotes to deliver throughout the week. This post
summarises all them so you can navigate your way to the right session.
Remember that once you register for a particular day at ICFP, you can
move between workshops and tutorials as you please.</p>
<p></p><figure class="image-right"><img src="https://anil.recoil.org/images/gothenburg.webp" loading="lazy" class="content-image" alt="Gothenburg, the location of this year's ICFP conference." srcset="/images/gothenburg.320.webp 320w,/images/gothenburg.480.webp 480w" title="Gothenburg, the location of this year's ICFP conference." sizes="(max-width: 768px) 100vw, 33vw"><figcaption>Gothenburg, the location of this year's ICFP conference.</figcaption></figure>

Quick links to the below in date order:<p></p>
<ul>
<li>Talk on <a href="https://anil.recoil.org/news.xml#coeffects">Coeffects, a Calculus of Context-dependent
Computation</a>, Monday 1st September, 16:30-17:20, ICFP
Day 1.</li>
<li>Talk on <a href="https://anil.recoil.org/news.xml#implicits">Modular Implicits</a>, Thu 4th September,
14:25-14:50, ML Workshop.</li>
<li>Talk on <a href="https://anil.recoil.org/news.xml#modulealiases">Module Aliases</a>, Thu 4th September,
09:35-10:00, ML Workshop.</li>
<li>Talk on <a href="https://anil.recoil.org/news.xml#metamirage">Metaprogramming in the Mirage OS</a>, Thu 4th
September, 14:50-15:10, ML Workshop.</li>
<li>Keynote talk on <a href="https://anil.recoil.org/news.xml#unikernels">Unikernels</a>, Fri 5th September,
09:00-10:00, Haskell Symposium.</li>
<li>Talk on <a href="https://anil.recoil.org/news.xml#multicore">Multicore OCaml</a>, Fri 5th September,
09:10-10:00, OCaml Workshop.</li>
<li>Tutorial on <a href="https://anil.recoil.org/news.xml#cufptutorial">OCaml and JavaScript Programming</a>, Fri
5th September, 09:00-12:00, CUFP Tutorial Day 2.</li>
<li>Talk on <a href="https://anil.recoil.org/news.xml#zeroinstall">0install binary distribution</a>, Fri 5th
September, 10:25-10:50, OCaml Workshop.</li>
<li>Talk on <a href="https://anil.recoil.org/news.xml#tls">Transport Layer Security in OCaml</a>, Fri 5th
September, 10:50-11:20, OCaml Workshop.</li>
<li>Talk/Demo on the <a href="https://anil.recoil.org/news.xml#platform">OCaml Platform</a>, Fri 5th September,
12:00-12:30, OCaml Workshop.</li>
<li>Poster and Demo of the <a href="https://anil.recoil.org/news.xml#irmin">Irmin branch-consistent store</a>, Fri
5th September, 15:10-16:30, OCaml/ML Workshop.</li>
<li><a href="https://anil.recoil.org/news.xml#social">Social Events</a></li>
</ul>
<h2>Language and Compiler Improvements</h2>
<p>The first round of talks are about improvements to the core OCaml
language and runtime.</p>
<h3>» Modular implicits</h3>
<p>Leo White and Frederic Bour have been taking inspiration from Scala
implicits and <a href="https://www.mpi-sws.org/~dreyer/papers/mtc/main-short.pdf">Modular Type
Classes</a> by
Dreyer <em>et al</em>, and will describe the design and implementation of a
system for ad-hoc polymorphism in OCaml based on passing implicit module
parameters to functions based on their module type.</p>
<p>This provides a concise way to write functions to print or manipulate
values generically, while maintaining the ML spirit of explicit
modularity. You can actually get get a taste of this new feature ahead
of the talk, thanks to a new facility in OCaml: we can compile any OPAM
switch directly into an interactive JavaScript notebook thanks to
<a href="https://github.com/andrewray/iocamljs">iocamljs</a> by <a href="http://ujamjar.github.io/">Andy
Ray</a>.</p>
<ul>
<li><a href="http://www.lpw25.net/ml2014.pdf">Abstract</a></li>
<li><a href="http://andrewray.github.io/iocamljs/modimp_show.html">Interactive
Compiler</a></li>
</ul>
<h3>Multicore OCaml</h3>
<p>Currently, threading in OCaml is only supported by means of a global
lock, allowing at most one thread to run OCaml code at any time. Stephen
Dolan, Leo White and Anil Madhavapeddy have been building on the <a href="http://www.cl.cam.ac.uk/~sd601/multicore.md">early
design</a> of a multicore
OCaml runtime that they started in January, and now have a (early)
prototype of a runtime design that is capable of shared memory
parallelism.</p>
<ul>
<li><a href="http://ocaml.org/meetings/ocaml/2014/ocaml2014_1.pdf">Abstract</a></li>
<li>Date: 09:10-10:00, OCaml Workshop, Fri Sept 5th</li>
</ul>
<h3>Type-level Module Aliases</h3>
<p>Leo White has been working with <a href="http://www.math.nagoya-u.ac.jp/~garrigue/">Jacques
Garrigue</a> on adding support
for module aliases into OCaml. This significantly improves the
compilation speed and executable binary sizes when using large libraries
such as
<a href="https://realworldocaml.org/v1/en/html/concurrent-programming-with-async.html">Core/Async</a>.</p>
<ul>
<li><a href="https://sites.google.com/site/mlworkshoppe/modalias.pdf?attredirects=0">Abstract</a></li>
<li><a href="https://blogs.janestreet.com/better-namespaces-through-module-aliases">Better Namespaces through Module
Aliases</a></li>
<li>Date: 0935-1000, ML Workshop, Thu Sep 4th.</li>
</ul>
<h3>Coeffects: A Calculus of Context-dependent Computation</h3>
<p>Alan Mycroft has been working with Tomas Petricek and Dominic Orchard on
defining a broader notion of context than just variables in scope. Tomas
will be presenting a research paper on developing a generalized coeffect
system with annotations indexed by a correct shape.</p>
<ul>
<li><a href="http://www.cl.cam.ac.uk/~dao29/publ/coeffects-icfp14.pdf">Paper</a></li>
<li>Date: 16:30-17:20, ICFP Day 1, Mon Sep 1st.</li>
</ul>
<h2>Mirage OS 2.0</h2>
<p>We <a href="http://openmirage.org/blog/announcing-mirage-20-release">released Mirage OS
2.0</a> in July,
and there will be several talks diving into some of the new features you
may have read on the blog.</p>
<h3>Unikernels Keynote at Haskell Symposium</h3>
<p>Since MirageOS is a
<a href="https://anil.recoil.org/papers/2013-asplos-mirage.pdf">unikernel</a>
written entirely in OCaml, it makes perfect sense to describe it in
detail to our friends over at the <a href="http://www.haskell.org/haskell-symposium/">Haskell
Symposium</a> and reflect on
some of the design implications between Haskell type-classes and OCaml
functors and metaprogramming. Anil Madhavapeddy will be doing just that
in a Friday morning keynote at the Haskell Symposium.</p>
<ul>
<li>Haskell Symposium
<a href="http://www.haskell.org/haskell-symposium/2014/index.html">Program</a></li>
<li>Date: 0900-1000, Haskell Symposium, Fri Sep 5th.</li>
</ul>
<h3>Transport Layer Security in OCaml</h3>
<p>Hannes Menhert and David Kaloper have been <a href="http://openmirage.org/blog/introducing-ocaml-tls">working
hard</a> on integrating a
pure OCaml Transport Layer Security stack into Mirage OS. They’ll talk
about the design principles underlying the library, and reflect on the
next steps to build a TLS stack that we can rely on not to been more
insecure than telnet.</p>
<ul>
<li><a href="http://ocaml.org/meetings/ocaml/2014/ocaml2014_4.pdf">Abstract</a></li>
<li>Date: 10:25-11:20, OCaml Workshop, Fri Sep 5th.</li>
</ul>
<p>Hannes will also continue his travels and deliver a couple of talks the
week after ICFP on the same topic in Denmark, so you can still see it if
you happen to miss this week’s presentation:</p>
<ul>
<li>9th Sep at 15:00, IT University of Copenhagen (2A08),
<a href="http://list.ku.dk/pipermail/sci-diku-prog-lang/2014-August/000244.html">details</a></li>
<li>11th Sep Aarhus University, same talk (time and room TBA)</li>
</ul>
<h3>Irmin: a Branch-consistent Distributed Library Database</h3>
<p>Irmin is an <a href="https://github.com/mirage/irmin">OCaml library</a> to persist
and synchronize distributed data structures both on-disk and in-memory.
It enables a style of programming very similar to the Git workflow,
where distributed nodes fork, fetch, merge and push data between each
other. The general idea is that you want every active node to get a
local (partial) copy of a global database and always be very explicit
about how and when data is shared and migrated.</p>
<p>This has been a big collaborative effort lead by Thomas Gazagnaire, and
includes contributions from Amir Chaudhry, Anil Madhavapeddy, Richard
Mortier, David Scott, David Sheets, Gregory Tsipenyuk, Jon Crowcroft.
We’ll be demonstrating Irmin <a href="https://www.youtube.com/watch?v=DSzvFwIVm5s">in
action</a>, so please come
along if you’ve got any interesting applications you would like to talk
to us about.</p>
<ul>
<li><a href="http://ocaml.org/meetings/ocaml/2014/ocaml2014_11.pdf">Abstract</a></li>
<li><a href="http://openmirage.org/blog/introducing-irmin">Blog Post</a></li>
<li>Date: 15:10-16:30, Joint Poster Session for OCaml/ML Workshop, Fri
Sep 5th 2014.</li>
</ul>
<h3>Metaprogramming with ML modules in the MirageOS</h3>
<p>Mirage OS lets the programmer build modular operating system components
using a combination of OCaml functors and generative metaprogramming.
This ensures portability across both Unix binaries and Xen unikernels,
while preserving a usable developer workflow.</p>
<p>The core Mirage OS team of Anil Madhavapeddy, Thomas Gazagnaire, David
Scott and Richard Mortier will be talking about the details of the
functor combinators that make all this possible, and doing a live
demonstration of it running on a tiny <a href="http://openmirage.org/blog/introducing-xen-minios-arm">ARM
board</a>!</p>
<ul>
<li><a href="https://sites.google.com/site/mlworkshoppe/Gazagnaire-abstract.pdf?attredirects=0">Abstract</a></li>
<li>Date: 14:50-15:10, ML Workshop, Thu Sep 4th 2014.</li>
</ul>
<h3>CUFP OCaml Language Tutorial</h3>
<p>Leo White and Jeremy Yallop (with much helpful assistance from Daniel
Buenzli) will be giving a rather different OCaml tutorial from the usual
fare: they are taking you on a journey of building a variant of the
popular <a href="http://gabrielecirulli.github.io/2048/">2048</a> game in pure
OCaml, and compiling it to JavaScript using the
<a href="http://ocsigen.org/js_of_ocaml/">js_of_ocaml</a> compiler. This is a
very pragmatic introduction to using statically typed functional
programming combined with efficient compilation to JavaScript.</p>
<blockquote>
<p>In this tutorial, we will first introduce the basics of OCaml using an
interactive environment running in a web browser, as well as a local
install of OCaml using the OPAM package manager. We will also explore
how to compile OCaml to JavaScript using the js_of_ocaml tool.</p>
</blockquote>
<p>The tutorial is focused around writing the 2048 logic, which will then
be compiled with js_of_ocaml and linked together with a frontend based
on (a pre-release version of) Useri, React, Gg and Vg, thanks to Daniel
Buenzli. There’ll also be appearances from OPAM, IOCaml, Qcheck and
OUnit.</p>
<ul>
<li><a href="https://github.com/ocamllabs/cufp-tutorial/">Tutorial Code</a></li>
<li><a href="https://github.com/ocamllabs/cufp-tutorial/blob/master/task.md">Task
Sheet</a></li>
<li>Date: 09:00-12:00, CUFP Tutorial Day 2, Fri Sep 5th 2014.</li>
</ul>
<p>There will also be a limited supply of special edition OCaml-branded USB
sticks for the first tutorial attendees, so get here early for your
exclusive swag!</p>
<h2>The OCaml Platform</h2>
<p>The group here has been working hard all summer to pull together an
integrated demonstration of the new generation of OCaml tools being
built around the increasingly popular <a href="https://opam.ocaml.org">OPAM</a>
package manager. Anil Madhavapeddy will demonstrate all of these pieces
in the OCaml Workshop, with guest appearances of work from Amir
Chaudhry, Daniel Buenzli, Jeremie Diminio, Thomas Gazagnaire, Louis
Gesbert, Thomas Leonard, David Sheets, Mark Shinwell, Christophe
Troestler, Leo White and Jeremy Yallop.</p>
<blockquote>
<p>The OCaml Platform combines the OCaml compiler toolchain with a
coherent set of tools for build, documentation, testing and IDE
integration. The project is a collaborative effort across the OCaml
community, tied together by the OCaml Labs group in Cambridge and with
other major contributors.</p>
</blockquote>
<ul>
<li><a href="http://ocaml.org/meetings/ocaml/2014/ocaml2014_7.pdf">Abstract</a></li>
<li><a href="https://opam.ocaml.org/blog">Platform Blog</a></li>
<li>Date: 12:00-12:30, OCaml Workshop, Fri Sep 5th 2014.</li>
</ul>
<h3>The 0install Binary Installation System</h3>
<p>Thomas Leonard will also be delivering a separate talk about
cross-platform binary installation via his
<a href="http://zero-install.sourceforge.net/">0install</a> library, which works on
a variety of platforms ranging from Windows, Linux and MacOS X. He
recently rewrote it in <a href="http://roscidus.com/blog/blog/2014/06/06/python-to-ocaml-retrospective/">OCaml from
Python</a>,
and will be sharing his experiences on how this went as a new OCaml
user, as well as deliver an introduction to 0install.</p>
<ul>
<li><a href="http://ocaml.org/meetings/ocaml/2014/ocaml2014_3.pdf">Abstract</a></li>
<li>Date: 10:25-10:50, OCaml Workshop, Fri Sep 5th 2014.</li>
</ul>
<h2>Service and Socialising</h2>
<p>Heidi Howard and Leonhard Markert are acting as student volunteers at
this years ICFP, and assisting with videoing various workshops such as
CUFP Tutorials, Haskell Symposium, the Workshop on Functional
High-Performance Computing and the ML Family Workshop. Follow their live
blogging on the <a href="http://www.syslog.cl.cam.ac.uk/">Systems Research Group
SysBlog</a> and leave comments about any
sessions you’d like to know more about!</p>
<p>Anil Madhavapeddy is the ICFP industrial relations chair and will be
hosting an Industrial Reception on Thursday 4th September in the <a href="http://www.varldskulturmuseerna.se/varldskulturmuseet/">Museum
of World
Culture</a>
starting from 7pm. There will be wine, food and some inspirational talks from the ICFP
sponsors that not only make the conference possible, but provide an
avenue for the academic work to make its way out into industry (grad
students that are job hunting: this is where you get to chat to folk
hiring FP talent).</p>
<p>This list hasn’t been exhaustive, and only covers the activities of my
group in <a href="http://ocaml.io">OCaml Labs</a> and the <a href="http://www.cl.cam.ac.uk/research/srg/">Systems Research
Group</a> at Cambridge. There are
numerous other talks from the Cambridge Computer Lab during the week,
but the artistic highlight will be on Saturday evening following the
<a href="http://cufp.org/2014/">CUFP talks</a>: <a href="http://sam.aaron.name/">Sam Aaron</a>
will be doing a <a href="https://twitter.com/samaaron/status/505081137660981248">live musical
performance</a>
sometime after 8pm at <a href="http://www.3vaningen.se/">3vaningen</a>. Sounds like
a perfect way to wind down after what’s gearing to up to be an intense
ICFP 2014. I look forward to seeing old friends and making new ones in
Gothenburg soon!</p>

