---
title: OCamlPro Highlights, Sept-Oct 2013
description: "Here is a short report of our activities in September-October 2013.
  OCamlPro at OCaml\u20192013 in Boston We were very happy to participate to OCaml\u20192013,
  in Boston. The event was a great success, with a lot of interesting talks and many
  participants. It was a nice opportunity for us to present some ..."
url: https://ocamlpro.com/blog/2013_11_01_ocamlpro_highlights_sept_oct_2013
date: 2013-11-01T13:19:46-00:00
preview_image: URL_de_votre_image
authors:
- "\n    \xC7agdas Bozman\n  "
source:
---

<p>Here is a short report of our activities in September-October 2013.</p>
<h3>OCamlPro at OCaml&rsquo;2013 in Boston</h3>
<p>We were very happy to participate to OCaml&rsquo;2013, in Boston. The event
was a great success, with a lot of interesting talks and many
participants. It was a nice opportunity for us to present some of our
recent work:</p>
<ul>
<li>Fabrice presented his work on <a href="https://ocaml.org/meetings/ocaml/2013/proposals/wxocaml.pdf">the design of the wxOCaml library</a>. Although the <a href="https://github.com/OCamlPro/ocplib-wxOCaml/">wxOCaml library</a>
itself is an interesting project, the goal of his talk was to show that
binding thousands of functions from a C++ library can be automated very
easily in OCaml, and make the bindings easy to maintain and to improve.
</li>
<li>The work of Thomas and Louis on OPAM was presented in a talk by Anil on the <a href="https://ocaml.org/meetings/ocaml/2013/proposals/platform.pdf">OCaml Platform v0.1</a>.
The OCaml Platform is a set of tools, including OPAM, to provide an
ever increasing set of packages for OCaml developers, including
high-quality documentation and broad portability. Some statistics showed
how OPAM, in less than a year, grew from 200 packages to more than 1400
packages, and from 2-3 contributors to about 130 contributors in
September. Another talk, <a href="https://ocaml.org/meetings/ocaml/2013/proposals/ocamlot.pdf">Ocamlot: OCaml Online Testing</a>
presented how sets of packages will now be automatically tested, to
give immediate feedback to contributors, and an evaluation of packages
quality to users.
</li>
<li>Pierre presented his work on <a href="https://ocaml.org/meetings/ocaml/2013/slides/chambart.pdf">Improving OCaml high level optimisations</a> that he also presented in a recent <a href="https://ocamlpro.com/blog/2013_05_24_optimisations_you_shouldnt_do">blog post</a>.
</li>
<li>Gr&eacute;goire presented his work with Jacques Garrigue on <a href="https://ocaml.org/meetings/ocaml/2013/proposals/runtime-types.pdf">Runtime types in OCaml</a>.
In particular, he showed how abstraction is hard to deal with, as there
is a dilemma between the ability to write powerful polytipic functions
and the preservation of the abstraction wanted by the developer for code
modularity.
</li>
<li>Finally, &Ccedil;agdas presented his work on <a href="https://ocaml.org/meetings/ocaml/2013/slides/bozman.pdf">Profiling the Memory Usage of OCaml Applications without Changing their Behavior</a>.
This new profiler will be able to provide precise memory information on
production OCaml software, by snapshoting the memory and recovering
type information. It is currently being tested on several projects, such
as the <a href="https://why3.lri.fr/">Why3 verification tool</a>.
</li>
</ul>
<p>Of course, the day was full of interesting talks, and we can only advise to see all of them on the <a href="https://ocaml.org/meetings/ocaml/2013/program.html">complete program</a> that is now online.</p>
<p><a href="http://cufp.org/conference/schedule/2013">CUFP&rsquo;2013 Program</a>
was also very dense. For OCaml users, Dave Thomas, first keynote,
reminded us how important it is to build two-way bridges between OCaml
and other languages: we have the bad habit to only build one-way bridges
to just use other languages from OCaml, and forget that new users will
have to start by using small OCaml components from their existing
software written in another language. Then, Julien Verlaguet <a href="https://www.youtube.com/watch?v=gKWNjFagR9k">presented</a>
the use of OCaml at Facebook to type-check and compile a typed version
of PhP, HipHop, that is now used for a large part of the code at
Facebook.</p>
<h3>Software Projects</h3>
<p>The period of September-October was also very busy trying to find
some funding for our projects. Fortunately, we still managed to make a
lot of progress in the development of these projects:</p>
<h4>OPAM</h4>
<p>Lots has been going on regarding OPAM, as the 1.1 release is being
pushed forward, with a beta and a RC available already. This release
focuses on stability improvements and bug-fixes, but is nonetheless a
large step from 1.0, with an enhanced update mechanism, extended
metadata, an enhanced &lsquo;pin&rsquo; workflow for developers, and much more.</p>
<p>We are delighted by the success met by OPAM, which was mentioned
again and again at the OCaml&rsquo;2013 workshop, where we got a warming lot
of positive feedback. To be sure that this belongs to the community,
after licensing all metadata of the repository under CC0 (as close to
public domain as legally possible), we have worked hand in hand with
OCamlLabs to migrate it to <a href="https://opam.ocaml.org/">opam.ocaml.org</a>. External repositories for <a href="https://github.com/vouillon/opam-windows-repository">Windows</a>, <a href="https://github.com/vouillon/opam-android-repository">Android</a> <a href="https://github.com/search?q=opam-repo&amp;type=Repositories&amp;ref=searchresults">and so on</a> are appearing, which is a really good thing, too.</p>
<h4>The Alt-Ergo SMT Solver</h4>
<p>In September, we officially announced the distribution and the support of <a href="https://alt-ergo.lri.fr/">Alt-Ergo</a> by OCamlPro and launched its <a href="https://alt-ergo.ocamlpro.com/">new website</a>.
This site allows to download public releases and to discover available
support offerings. We have also published a new public release (version
0.95.2) of the prover. The main changes in this minor release are:
source code reorganization, simplification of quantifier instantiation
heuristics, GUI improvement to reduce latency when opening large files,
as well as various bug fixes.</p>
<p>During September, we also re-implemented and simplified other parts
of Alt-Ergo. In addition, we started the integration of a new SAT-solver
based on miniSAT (implemented as a plug-in) and the development of a
new tool, called Ctrl-Alt-Ergo, that automates the most interesting
strategies of Alt-Ergo. The experiments we made during October are very
encouraging as shown by <a href="https://ocamlpro.com/blog/2013_10_02_alt_ergo_ocamlpro_two_months_later">our previous blog post</a>.</p>
<h4>Multi-runtime</h4>
<p>Luca Saiu completed his work at Inria and on the multi-runtime
branch, fixing the last bugs and leaving the code in a shape not too far
removed from permitting its eventual integration into the OCaml
mainline.</p>
<p>Now, the code has a clean configuration-time facility for disabling
the multi-runtime system, and compatibility is restored with
architectures not including the required assembly support to at least
compile and work using a single runtime. A crucial optimization permits
to work in this mode with extremely little overhead with respect to
stock OCaml. Testing on an old PowerPC 32-bit machine revealed a few
minor portability problems related to word size and endianness.</p>
<h4>Compiler optimisations</h4>
<p>We have been working on allowing cross module inlining. We wanted to
be able to show a version generating strictly better code than the
current compiler. This milestone being reached, we are now preparing a
patch series for upstreaming the base parts. We are also working on
polishing the remaining problems: the passes were written in an as
simple as possible way, so compilation time is still a bit high. And
there are a few difficulties remaining with cross module inlining and
packs.</p>
<h3>The INRIA-OCamlPro Lab Team</h3>
<p>The team is also evolving, and some of us are now leaving the team to join other projects:</p>
<ul>
<li>After two years with us, Thomas Gazagnaire has left OCamlPro in October to work most of his time on <a href="http://www.openmirage.org/">Mirage</a>
in Cambridge (UK). Thomas was OCamlPro&rsquo;s first employee, and OCamlPro
probably wouldn&rsquo;t exist without him. Thomas has also been the main
architect of OPAM, and was involved in the design of many of our
projects. Louis Gesbert will continue his work on developing and
maintaining OPAM.
</li>
<li>After one year with us, Luca Saiu has left Inria in October. Luca
has made a tremendous work on the implementation of a multicore-OCaml,
where every runtime runs in a different memory space with its own
garbage collector. We hope to be able to upstream his work soon to the
official OCaml distribution.
</li>
<li>After an internship with us, Pierrick Couderc, Souhire Kenawi and
David Maison are back to their masters&rsquo; studies since September. Souhire
worked on testing the development of iOS applications on Linux with
OCaml, a very challenging task ! Pierrick and David developed an online
editor for OCaml that we are going to release very soon.
</li>
</ul>
<p>This blog post was about departures, but stay connected, next month,
we are going to announce some newcomers who decided to join the team for
the winter !</p>

