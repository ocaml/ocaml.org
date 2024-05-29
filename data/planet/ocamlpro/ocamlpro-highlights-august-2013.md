---
title: OCamlPro Highlights, August 2013
description: Here is a short report on the different projects we have been working
  on in August. News from OCamlPro Compiler Optimizations After our reports on better
  inlining have raised big expectations, we have been working hard on fixing the few
  remaining bugs. An enhanced alias/constant analysis was added, ...
url: https://ocamlpro.com/blog/2013_09_04_ocamlpro_highlights_august_2013
date: 2013-09-04T13:19:46-00:00
preview_image: URL_de_votre_image
authors:
- "\n    \xC7agdas Bozman\n  "
source:
---

<p>Here is a short report on the different projects we have been working on in August.</p>
<h3>News from OCamlPro</h3>
<h4>Compiler Optimizations</h4>
<p>After our reports on <a href="https://ocamlpro.com/blog/2013_07_11_better_inlining_progress_report">better inlining</a>
have raised big expectations, we have been working hard on fixing the
few remaining bugs. An enhanced alias/constant analysis was added, to
provide the information needed to lift some constraints on the
maintained invariants, and simplifying some other passes quite a lot in
the process. We are now working on reestablishing cross-module inlining,
by exporting the new information between compilation units.</p>
<h4>Memory Profiling</h4>
<p>On the memory profiling front, now that the compiler patch is well
tested and quite stable, we started some cleanup to make it more
modular, easier to understand and extend. We also worked on improving
the performance of the profiler (the tool that analyzes the heap
snapshots), by caching some expensive computations, such as extracting
type information from &lsquo;cmt&rsquo; files associated with each location, in
files that are shared between executions. We have started testing the
profiler on <a href="https://why3.lri.fr/">the Why3 verification platform</a>, and these optimizations proved very useful to analyze longer traces.</p>
<h4>OPAM Package Manager</h4>
<p>On OPAM, we are still preparing the release of version 1.1. The
release date has shifted a little bit &mdash; it is now planned to happen
mid-September, before the <a href="https://ocaml.org/meetings/ocaml/2013/">OCaml&rsquo;2013 meeting</a> &mdash; because we are focusing on getting speed and stability improvements in a very good shape. We are now relying on <a href="https://github.com/OCamlPro/opam-rt">opam-rt</a>, our new regression testing infrastructure, to be sure to get the best level of quality for the release.</p>
<p>Regarding the package and compiler <a href="https://github.com/OCamlPro/opam-repository">metadata</a>,
we are very proud to announce that our community has crossed an
important line, with more than 100 contributors and 500 different
packages ! In order to ensure that these hours of packaging efforts
continue to benefit everyone in the OCaml community in the future, we
are (i) clarifying the license for all the metadata in the package
repository to use <a href="https://github.com/OCamlPro/opam-repository/issues/955">CC0</a> and (ii) discussing with <a href="https://www.cl.cam.ac.uk/projects/ocamllabs/">OCamlLabs</a> and the different stakeholders to migrate all the metadata to the <a href="https://ocaml.org/">ocaml.org</a> infrastructure.</p>
<h4>Simple Build Manager</h4>
<p>We also made progress on the design of our simple build-manager for OCaml, <a href="https://www.typerex.org/ocp-build.html">ocp-build</a>. The <a href="https://github.com/OCamlPro/ocp-build/tree/next">next branch in the GIT repository</a>
features a new, much more expressive package description language :
ocp-build can now be used to build arbitrary files, for example to
generate new source files, or to compile files in other languages than
OCaml. We successfully used the new language to build <a href="https://try.ocamlpro.com/">Try-ocaml</a> and <a href="https://www.typerex.org/ocplib-wxOCaml.html">wxOCaml</a>, completely avoiding the use of &ldquo;make&rdquo;.</p>
<p>It can also automatically generate <a href="https://www.typerex.org/ocplib-wxOCaml/doc.0.1/index.html">basic HTML documentation</a>
for libraries using ocamldoc with &ldquo;ocp-build make -doc&rdquo;. There are
still some improvements on our TODO list before an official release, for
example improving the support of META files, but we are getting very
close ! ocp-build is very efficient: compiling <a href="https://www.typerex.org/ocp-build/merlin.ocp">Merlin with ocp-build</a> takes only 4s on a quad-core while ocamlbuild needs 13s in similar conditions and with the same parallelisation settings.</p>
<h4>Graphics on Try-OCaml</h4>
<p><a href="https://try.ocamlpro.com/">Try-OCaml</a> has been improved
with a dedicated implementation of the Graphics module: type &ldquo;lesson
19&rdquo;, and you will get some fun examples, including a simple game by
Sylvain Conchon.</p>
<h4>Alt-Ergo Theorem Prover</h4>
<p>We are also happy to welcome Mohamed Iguernelala in the team,
starting at the beginning of September. Mohamed is a great OCaml
programmer, and he will be working on the Alt-Ergo theorem prover, an
SMT-solver in OCaml developed by Sylvain Conchon, and heavily used in
the industry for safety-critical software (aircrafts, trains, etc.).</p>
<h3>News from the INRIA-OCamlPro Lab</h3>
<h4>Multi-runtime OCaml</h4>
<p>After thorough testing, the <a href="https://github.com/lucasaiu/ocaml">multi-runtime branch</a>
is getting stable enough for being submitted upstream. The build system
has been fixed to enable the modified OCaml to run, in single-runtime
mode, on architectures for which no multi-runtime port exists yet, while
maintaining API compatibility with mainline OCaml. Thanks to some
clever preprocessor hacks, the performance impact in single-runtime mode
will be negligible.</p>
<h4>Whole-Program Analysis</h4>
<p>Our work on <a href="https://github.com/thomasblanc/ocaml-data-analysis/">whole program analysis</a>,
while still in the early stages, is quickly getting forward, and we
managed to generate well-formed graphs representing a whole OCaml
program. The tool can be fed sources and .cmt files, and at each point
of the program, will compute all of the plausible values every variable
can take, plus the calculations that allowed to get those values. We
hope to have it ready for testing the detection of uncaught exceptions
soon.</p>
<h4>Editing OCaml Online</h4>
<p>We also made a lot of progress in our Online IDE for OCaml, with code
generation within the browser. The prototype is now quite robust, and
some tricky bugs with the representation of integers and floats in
Javascript have been fixed, so that the generated code is always the
same as the one generated by a standalone compiler. Also, the interface
now allows the user to have a full hierarchy of files and projects in
his workspace. There is still some work to be done on improving the
design, but we are very exited with the possibility to develop in OCaml
without installing anything on the computer !</p>
<h4>Scilab Code Analysis</h4>
<p>For the <a href="https://www.richelieu.pro/">Richelieu</a> project,
after testing some type inference analysis on Scilab code in the last
months, we have now started to implement a new tool, <a href="https://github.com/OCamlPro/scilint">Scilint</a>,
to perform some of this analysis on whole Scilab projects and report
warnings on suspect code. We hope this tool will soon be used by every
Scilab user, to avoid wasting hours of computation before reaching an
easy-to-catch error, such as a misspelled &mdash; thus undefined &mdash; variable.</p>
<h3>Meeting with the Community</h3>
<p>Some of us are going to present part of this work at <a href="https://ocaml.org/meetings/ocaml/2013/program.html">OCaml&rsquo;2013</a>,
the OCaml Users and Developers Workshop in Boston. We expect it to be a
good opportunity to get some feedback on these projects from the
community!</p>

