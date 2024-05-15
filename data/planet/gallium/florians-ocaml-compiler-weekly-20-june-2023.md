---
title: Florian's OCaml compiler weekly, 20 June 2023
description:
url: http://cambium.inria.fr/blog/florian-compiler-weekly-2023-06-20
date: 2023-06-20T08:00:00-00:00
preview_image:
authors:
- GaGallium
source:
---




<p>This series of blog posts aims to give a short weekly glimpse into my
(Florian Angeletti) daily work on the OCaml compiler. This quiet week
was focused on finishing ongoing tasks and discussing future
collaborations.</p>


  

<h3>A few finished tasks</h3>
<p>Last week was a quiet week, in term of new activities. However, I was
able to push few of my ongoing tasks over the finish line:</p>
<h4><a href="https://github.com/ocaml/ocaml/pull/12210">Semantic tag for inline
code in the compiler</a></h4>
<p>I have at last finalized this pull request that introduces an uniform
quoting style for inline code inside all the messages across the
compilers. With more than 300 hundred source files (fortunately mostly
tests) changed, this is the kind of Pull Request that one is glad to see
merged. At the very least, because this means no more lengthy
rebasing.</p>
<h4><a href="https://github.com/ocaml/ocaml/pull/12031">A type for symbol
identifiers in the bytecode</a></h4>
<p>Working with S&eacute;bastien Hinderer, I have completed a final review on
his work on switching to a narrower type for global symbols in the
bytecode backend. His PR has been merged on last Friday. Hopefully, it
shall make further work in this area of the compiler simpler by making
it clearer when global symbols are compilation unit names, or when they
might be predefined exceptions.</p>
<h4><a href="https://github.com/ocaml/opam-repository/pull/23965">ppxlib 0.30
ready to be</a></h4>
<p>In the beginning of the week, I have spent some time with the ppxlib
team to check that the new version of ppxlib (with the compatibility fix
for the second alpha release of OCaml 5.1.0) is ready.</p>
<p>Once this new version of ppxlib is out-of-the-door, I will restart my
survey of the state of the opam ecosystem before the release of the
first beta for OCaml 5.1.0</p>
<h3>Discussing future
collaborations with Tarides</h3>
<p>In parallel, I have been discussing with the benchmarking team and
odoc team at Tarides on collaborating on two subjects in the medium term
future:</p>
<h4>Continuous benchmarks
for the compiler</h4>
<p>A common subject of interest with Tarides benchmarking team is to try
to set us a pipeline for continuously monitoring the performance of the
OCaml compiler.</p>
<p>Having such continuous monitoring would bring two major advantages
from my perspective:</p>
<ul>
<li><p>monitoring long term trends: a 0.1% weekly slowdown of the
compiler speed might not be worth worrying. One year of accumulated 0.1%
weekly slowdowns <em>is</em> worrying.</p></li>
<li><p>catching performance accident early: conversely, a significant
unexpected drop or increase in a Pull Request is a worrying concern that
we want to detect as early to possible to investigate (and possibly) the
cause of this change</p></li>
</ul>
<h4>Better
integration of the OCaml manual with <a href="https://ocaml.org">ocaml.org</a></h4>
<p>Currently, the integration of the OCaml manual and API documentation
within the <a href="https://ocaml.org">ocaml.org</a> is very barebone:
The main <code>ocaml.org</code> site links towards the old
<code>v2.ocaml.org</code> website where the manual is still hosted
through redirection.</p>
<p>This setup was supposed to be temporary, but I have not yet found the
time to improve this integration. I hope to fix this in time for the
release of OCaml 5.1.0 in July. In particular, this would be a good time
for transitioning the <code>ocaml.org</code> hosted API reference to the
odoc version which has been dormant hidden with the compiler repository
for few years now.</p>


