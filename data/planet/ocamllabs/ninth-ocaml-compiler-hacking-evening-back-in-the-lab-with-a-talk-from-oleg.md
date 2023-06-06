---
title: Ninth OCaml compiler hacking evening (back in the lab, with a talk from Oleg)
description:
url: http://ocamllabs.github.com/compiler-hacking/2015/02/05/back-in-the-lab
date: 2015-02-05T12:00:00-00:00
preview_image:
featured:
authors:
- ocamllabs
---

<p>We'll be meeting in the Computer Lab next Tuesday (10th February 2015) for another evening of compiler hacking.  All welcome!  Please <strong><a href="http://doodle.com/zxmeyn2ih92mke85">add yourself to the Doodle poll</a></strong> if you're planning to come along, and sign up to the <a href="http://lists.ocaml.org/listinfo/cam-compiler-hacking">mailing list</a> to receive updates.</p>

<h3>Talk: Generating code with polymorphic let (Oleg Kiselyov)</h3>

<p>This time we'll be starting with a talk from <a href="http://okmij.org/ftp">Oleg Kiselyov</a>:</p>

<blockquote>
<h4>Generating code with polymorphic let</h4>

<p>One of the simplest ways of implementing staging is source-to-source
translation from the quotation-unquotation code to code-generating
combinators. For example, MetaOCaml could be implemented as a
pre-processor to the ordinary OCaml. However simple, the approach is
surprising productive and extensible, as Lightweight Modular Staging
(LMS) in Scala has demonstrated. However, there is a fatal flaw:
handling quotations that contain polymorphic let. The translation to
code-generating combinators represents a future-stage let-binding with
the present-staging lambda-binding, which is monomorphic. Even if
polymorphic lambda-bindings are allowed, they require type
annotations, which precludes the source-to-source translation.</p>

<p>We show the solution to the problem, using a different translation. It
works with the current OCaml. It also almost works in theory,
requiring a small extension to the relaxed value
restriction. Surprisingly, this extension seems to be exactly the one
needed to make the value restriction sound in a staged language with
reference cells and cross-stage-persistence.</p>

<p>The old, seems completely settled question of value restriction is
thrown deep-open in staged languages. We gain a profound problem to
work on.</p>
</blockquote>

<h3>(Approximate) schedule</h3>

<p><strong>6pm</strong> Start, set up<br/>
<strong>6.30pm</strong> Talk<br/>
<strong>7pm</strong> Pizza<br/>
<strong>7.30pm-10pm</strong> Compiler hacking  </p>

<h3>Further details</h3>

<p><strong>Where</strong>:
  Room <a href="http://www.cl.cam.ac.uk/research/dtg/openroommap/static/?s=FW11&amp;labels=1">FW11</a>, <a href="http://www.cl.cam.ac.uk/directions/">Computer Laboratory, Madingley Road</a></p>

<p><strong>When</strong>: 6pm, Tuesday 10th February</p>

<p><strong>Who</strong>: anyone interested in improving OCaml. Knowledge of OCaml programming will obviously be helpful, but prior experience of working on OCaml internals isn't necessary.</p>

<p><strong>What</strong>: fixing bugs, implementing new features, learning about OCaml internals.</p>

<p><strong>Wiki</strong>: <a href="https://github.com/ocamllabs/compiler-hacking/wiki">https://github.com/ocamllabs/compiler-hacking/wiki</a></p>

<p>We're defining &quot;compiler&quot; pretty broadly, to include anything that's part of the standard distribution, which means at least the <a href="http://caml.inria.fr/pub/docs/manual-ocaml-4.01/libref/index.html">standard library</a>, <a href="http://caml.inria.fr/pub/docs/manual-ocaml-4.00/manual024.html">runtime</a>, tools (<a href="http://caml.inria.fr/pub/docs/manual-ocaml-4.01/depend.html">ocamldep</a>, <a href="http://caml.inria.fr/pub/docs/manual-ocaml-4.00/manual026.html#toc105">ocamllex</a>, <a href="http://caml.inria.fr/pub/docs/manual-ocaml-4.00/manual026.html#toc107">ocamlyacc</a>, etc.), <a href="http://caml.inria.fr/pub/docs/manual-ocaml-4.00/manual032.html">ocamlbuild</a>, the <a href="http://caml.inria.fr/resources/doc/index.en.html">documentation</a>, and the compiler itself. We'll have suggestions for <a href="https://github.com/ocamllabs/compiler-hacking/wiki/Things-to-work-on">mini-projects</a> for various levels of experience (see also some <a href="https://github.com/ocamllabs/compiler-hacking/wiki/Things-previously-worked-on">things we've done on previous evenings</a>), but feel free to come along and work on whatever you fancy.</p>

<p>We'll be ordering pizza, so if you want to be counted for food you should aim to arrive by 6pm.</p>

