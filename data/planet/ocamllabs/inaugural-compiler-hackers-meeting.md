---
title: Inaugural compiler hackers meeting
description:
url: http://ocamllabs.github.com/compiler-hacking/2013/09/17/compiler-hacking-july-2013
date: 2013-09-17T12:49:04-00:00
preview_image:
featured:
authors:
- ocamllabs
---

<p><img src="http://ocamllabs.io/compiler-hacking/imgs/2013-09-17.jpg" alt="Compiler Hacking"/></p>

<p>The first OCaml Labs compiler hacking session brought together around twenty people from <a href="http://www.cl.cam.ac.uk/projects/ocamllabs/">OCaml Labs</a>, the wider <a href="http://www.cl.cam.ac.uk">Computer Lab</a>, and <a href="http://www.citrix.com/">various</a> <a href="http://www.arm.com/">companies</a> around Cambridge for an enjoyable few hours learning about and improving the OCaml compiler toolchain, fuelled by <a href="http://www.cherryboxpizza.co.uk">pizza</a> and home-made ice cream (thanks, <a href="http://philippewang.info/CL/">Philippe</a>!).</p>

<p>We benefited from the presence of a few <a href="http://www.x9c.fr/">experienced</a> <a href="http://danmey.org/">compiler</a> <a href="http://lpw25.net/">hackers</a>, but for most of us it was the first attempt to modify the OCaml compiler internals.</p>

<p>The first surprise of the day was the discovery that work on the <a href="https://github.com/ocamllabs/compiler-hacking/wiki/Things-to-work-on">list of projects</a> was underway before we even arrived!  Keen collaborators from The Internet had apparently spotted our triaged bug reports and <a href="http://caml.inria.fr/mantis/view.php?id=4323">submitted</a> <a href="http://caml.inria.fr/mantis/view.php?id=4737">patches</a> to Mantis.</p>

<h3>Standard library and runtime</h3>

<p>There was an exciting moment early on when it emerged that two teams had been working independently on the same issue!  When <a href="https://github.com/jonludlam">Jon Ludlam</a> and <a href="http://www.cl.cam.ac.uk/projects/ocamllabs/people/euan.html">Euan Harris</a> submitted a patch to add a <code>get_extension</code> function to the <a href="http://caml.inria.fr/pub/docs/manual-ocaml/libref/Filename.html"><code>Filename</code></a> module they found that they had been pipped to the post by <a href="https://github.com/mcclurmc/">Mike McClurg</a>.  There's still the judging stage to go, though, as the patches wait <a href="http://caml.inria.fr/mantis/view.php?id=5807">on Mantis</a> for official pronouncement from the Inria team. </p>

<p><a href="http://github.com/vbmithr">Vincent Bernardoff</a> also spent some time improving the standard library, <a href="http://caml.inria.fr/mantis/view.php?id=4919">fleshing out the interface for translating between OCaml and C error codes</a>, starting from a patch by Goswin von Brederlow.</p>

<p><a href="https://github.com/stedolan">Stephen Dolan</a> looked at a <a href="http://caml.inria.fr/mantis/view.php?id=1956">long-standing issue</a> with names exported by the OCaml runtime that can clash with other libraries, and submitted a patch which hides the sole remaining offender for the runtime library.  As he noted in the comments, there are still a <a href="https://gist.github.com/stedolan/6115403">couple of hundred</a> global names without the <code>caml_</code> prefix in the <code>otherlibs</code> section of the standard library.</p>

<h3>Tools</h3>

<p>There was a little flurry of work on new command-line options for the standard toolchain.</p>

<p>A <a href="http://caml.inria.fr/mantis/view.php?id=6102">Mantis issue</a> submitted by <a href="http://gallium.inria.fr/~scherer/">Gabriel Scherer</a> suggests adding options to stop the compiler at certain stages, to better support tools such as <a href="http://projects.camlcity.org/projects/findlib.html">OCamlfind</a> and to make it easier to debug the compiler itself.  The Ludlam / Harris team looked at this, and submitted a patch which provoked further thoughts from Gabriel.</p>

<p>Vincent looked at extending <a href="http://caml.inria.fr/pub/docs/manual-ocaml/depend.html">ocamldep</a> with support for suffixes other than <code>.ml</code> and <code>.mli</code>.  Since <a href="http://caml.inria.fr/mantis/view.php?id=3725">the issue</a> was originally submitted, <code>ocamldep</code> has acquired <a href="http://caml.inria.fr/pub/docs/manual-ocaml/depend.html#sec288"><code>-ml-synonym</code> and <code>-mli-synonym</code> options</a> that serve this purpose, so Vincent looked at supporting other suffixes in the compiler, and submitted a patch as a <a href="http://caml.inria.fr/mantis/view.php?id=6110">new issue</a>.</p>

<p>The OCaml top level has a simple feature for setting up the environment &mdash;  when it starts up it looks for the file <code>.ocamlinit</code>, and executes its contents.  It's sometimes useful to skip this stage and run the top level in a vanilla environment, so <a href="https://github.com/dsheets">David Sheets</a> submitted a <a href="http://caml.inria.fr/mantis/view.php?id=6071">patch</a> that adds a <code>-no-init</code> option, <a href="https://github.com/ocaml/ocaml/blob/fadcc73c50b89ca80ecc11131c9a23dbd2c1e67a/Changes#L35">due for inclusion</a> in the next release.</p>

<h3>Error-handling/reporting</h3>

<p>Error handling issues saw a good deal of activity.  <a href="http://www.cl.cam.ac.uk/~rp452/">Rapha&euml;l Proust</a> submitted a patch to improve the <a href="http://caml.inria.fr/mantis/view.php?id=6112">reporting of error-enabled warnings</a>; David investigated <a href="http://caml.inria.fr/mantis/view.php?id=3582">handling out-of-range integer literals</a> and <a href="http://caml.inria.fr/mantis/view.php?id=5350">return-code checking of C functions in the runtime</a>, leading to some discussions on Mantis.  Stephen submitted a patch to improve the <a href="http://caml.inria.fr/mantis/view.php?id=6182">diagnostics for misuses of <code>virtual</code></a>.  <a href="http://www.cl.cam.ac.uk/~gk338/">Gabriel Kerneis</a> and Wojciech looked at some <a href="http://caml.inria.fr/mantis/view.php?id=6109">typos in ocamlbuild error messages</a>, and Mike opened an <a href="http://caml.inria.fr/mantis/view.php?id=6108">issue to clarify the appropriate use of the <code>compiler-libs</code> package</a>.</p>

<h3>Language</h3>

<p>The <code>open</code> operation on modules can make it difficult for readers of a program to see where particular names are introduced, so its use is sometimes discouraged.  The basic feature of making names available without a module prefix is rather useful, though, so various new features (including <a href="http://caml.inria.fr/pub/docs/manual-ocaml-4.00/manual021.html#toc77">local opens</a>, <a href="https://github.com/ocaml/ocaml/commit/f51bc04b55fbe22533f1075193dd3b2e52721f15">warnings for shadowing</a>, and <a href="https://github.com/ocaml/ocaml/commit/a3b1c67fffd7de640ee9a0791f1fd0fad965b867">explicit shadowing</a>) have been introduced to tame its power. Stephen looked at adding a further feature, making it possible to open modules under a particular signature, so that <code>open M : S</code> will introduce only those names in <code>M</code> that are specified with <code>S</code>.  There's an <a href="https://github.com/lpw25/ocaml/tree/signatured-open">initial prototype</a> already, and we're looking forward to seeing the final results.</p>

<p>The second language feature of the evening was support for infix operators (such as the List constructor, <code>::</code>) for user-defined types, a feature that is definitely not in any way motivated by envy of Haskell.  Mike's <a href="https://github.com/mcclurmc/ocaml/tree/infix-constructors">prototype implementation</a> is available, and there's an <a href="https://github.com/mcclurmc/ocaml/pull/1">additional patch</a> that brings it closer to completion.</p>

<h3>Next session</h3>

<p>The next session is planned for 6pm on Wednesday 18th September 2013 at
<a href="http://makespace.org/">Makespace, Cambridge</a>.  If you're planning to come along it'd be
helpful if you could add yourself to the <a href="http://doodle.com/k6y2tiihkrb5vuw4">Doodle Poll</a>.  Hope to see
you there!</p>

