---
title: Effects based scheduling for the OCaml compiler pipeline
description:
url: https://anil.recoil.org/ideas/effects-scheduling-ocaml-compiler
date: 2025-04-01T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
---

<h1>Effects based scheduling for the OCaml compiler pipeline</h1>
<p>This is an idea proposed in 2025 as a good starter project, and is <span class="idea-available">available</span> for being worked on. It may be co-supervised with <a href="https://github.com/dra27" class="contact">David Allsopp</a>.</p>
<p>In order to compile the OCaml program <code>foo.ml</code> containing:</p>
<pre><code>Stdlib.print_endline "Hello, world"
</code></pre>
<p>the OCaml compilers only require the compiled <code>stdlib.cmi</code> interface to exist in order to determine the type of <code>Stdlib.print_endline</code>. This separate compilation technique allows modules of code to be compiled before the <em>code</em> they depend on has necessarily been compiled. When OCaml was first written, this technique was critical to reduce recompilation times. As CPU core counts increased through the late nineties and early 2000s, separate compilation also provided a parallelisation benefit, where modules which did not depend on each other could be compiled at the same time as each other benefitting <em>compilation</em> as well as <em>recompilation</em>.</p>
<p>For OCaml, as in many programming languages, the compilation of large code bases is handled by a separate <em>build system</em> (for example, <code>dune</code>, <code>make</code> or <code>ocamlbuild</code>) with the <em>compiler driver</em> (<code>ocamlc</code> or <code>ocamlopt</code>) being invoked by that build system as required. In this project, we'll investigate how to get the OCaml compiler itself to be responsible for exploiting available parallelism.</p>
<p>Some previous work (parts of which are available on GitHub<sup><a href="https://anil.recoil.org/news.xml#fn-1" role="doc-noteref" class="fn-label">[1]</a></sup>) showed the benefits of sharing the typing information known
to the compiler between each invocation. The hypothesis was during a
<em>sequential</em> computation, a considerable amount of time is spent by the
compiler searching for and reloading typing information, as well as the
overheads of launching thousands of copies of the compiler in a given build.</p>
<p>Our test compiler with an adapted version of Dune showed as much as a halving
of compilation time in <em>sequential</em> builds. However, in <em>parallel</em> builds, the
results were not as impressive - although the many invocations of the compiler
repeat the same loading operations, much of this cost is (quite predictably)
masked by performing the work in parallel.</p>
<p>The previous investigation was carried out on OCaml 4.07. Although it shared
the typing information between "invocations" of the compiler, the compiler
pipeline itself was unaltered - a file only started to be processed when all of
its dependencies were ready. Furthermore, it remained the responsibility of a
build system to provide this dependency ordering.</p>
<p>Fast forward to the present day, and we have OCaml 5.x, with both first class
support for <a href="https://anil.recoil.org/papers/2020-icfp-retropar">parallelism</a> and <a href="https://anil.recoil.org/papers/2021-pldi-retroeff">algebraic effects</a>. Domains provide an obvious ability for a single
compiler process to compile several files simultaneously.  Effects should allow
us to break the pipeline into stages, suspending the compilation whenever new
type information is required by performing an effect.  Using this model, it
should be possible to start with the entry module for a program and allow the
type checker itself to discover the dependency graph. it should be possible to
see many files being <em>progressively</em> type-checked in
parallel.</p>
<p>The hypothesis is that this will be both faster, but also considerably simpler.
The "scheduler" required for handling the effects should be a considerably
simpler program than a full-blown separate build system. Key challenges in this
work:</p>
<ul>
<li>the compiler library functions are not parallel-safe. It will be necessary to
adapt the compiler either to work around or eliminate its global mutable
state. This was necessary in the OCaml 4.07 as well.</li>
<li>The compiler becomes a much longer-lived process, and the garbage collector
becomes more relevant. The OCaml 4.07 version required "ancient heaps" to be
used to keep the major collector under control - otherwise significant amount
of time are spent by the runtime marking major heap which will never be
collected. This technique will need revising for OCaml 5, potentially with a
direct alteration to the runtime to support stop-the-world promotion of items
from the major heap to the ancient heap.</li>
<li>It will not be possible to achieve an upstreamable change to OCaml during a
project of this length, but given that the comparison will be against a real
build system operating with the same level of parallelism, it should be
possible to perform a wide-range of measurements building existing OCaml
projects.</li>
<li>There's lots of potential for additional exploration, particularly
dispatching multiple build targets to the compiler (i.e. building multiple
libraries and executables in the one invocation) and in using reusing previous
build graph computations to inform scheduling decisions.</li>
</ul>
<section role="doc-endnotes"><ol>
<li>
<p>see <a href="https://github.com/dra27/ocaml/commits/nandor-dune-work/">dra27/ocaml#nandor-dune-work</a>, <a href="https://github.com/dra27/dune/commits/nandor-shmap">dra27/dune#nandor-shmap</a>, and <a href="https://github.com/nandor/offheap">nandor/offheap</a>.</p>
<span><a href="https://anil.recoil.org/news.xml#ref-1-fn-1" role="doc-backlink" class="fn-label">↩︎︎</a></span></li></ol></section>

