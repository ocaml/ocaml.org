---
title: Retrofitting a build system into a compiler
description: "Over the summer, Lucas Ma has been investigating ideas surrounding using
  effects in the OCaml compiler itself. He\u2019s blogged some of his discoveries
  and adventures. The technical core of this work leads towards being able to use
  the OCaml compiler as a library on-demand to create a longer-lived \u201Ccompiler
  service\u201D. Of itself, that\u2019s not at all revolutionary, but it is quite
  hard to do that with a 30 year old codebase that really was designed for single-shot
  separate compilation."
url: https://www.dra27.uk/blog/platform/2025/09/25/building-with-effects.html
date: 2025-09-25T00:00:00-00:00
preview_image:
authors:
- ""
source:
ignore:
---

<p>Over the summer, <a href="https://github.com/lucasma8795">Lucas Ma</a> has been
investigating ideas surrounding using effects <a href="https://anil.recoil.org/ideas/effects-scheduling-ocaml-compiler">in the OCaml compiler itself</a>.
He’s <a href="https://lucasma8795.github.io/blog/">blogged some of his discoveries and adventures</a>.
The technical core of this work leads towards being able to use the OCaml
compiler as a library on-demand to create a longer-lived “compiler service”. Of
itself, that’s not at all revolutionary, but it is quite hard to do that with a
30 year old codebase that really was designed for single-shot separate
compilation.</p>

<p>Lucas got to grips pretty swiftly with OCaml’s build system, and initially
looked at generalising a core internal part of the compiler called the
<code class="language-plaintext highlighter-rouge">Load_path</code>. This is used by the compiler for scanning the various “include”
directories for files, principally typing information. For example, if your code
contains a call to <code class="language-plaintext highlighter-rouge">Unix.stat</code>, then the type checker needs the typing
information for a module called <code class="language-plaintext highlighter-rouge">Unix</code> which will cause it to request <code class="language-plaintext highlighter-rouge">unix.cmi</code>
from the <code class="language-plaintext highlighter-rouge">Load_path</code> and which will then hopefully resolve that to, say,
<code class="language-plaintext highlighter-rouge">~/.opam/switch/lib/ocaml/unix/unix.cmi</code>.</p>

<p>Effects provide an elegant way of inverting the control for this lookup, as the
program <em>calling</em> the compiler can then change the way these files are looked
up. It also provides the opportunity to “lie” to the compiler about the files
which are actually present, and this was the first thing Lucas started to do
with this change. In particular, it allows us to ignore the dependency graph.
When compiling a module, OCaml requires all the type information that a module
refers to have been compiled beforehand. If you have a module in <code class="language-plaintext highlighter-rouge">bar.ml</code> with
interface in <code class="language-plaintext highlighter-rouge">bar.mli</code> and where the code refers to <code class="language-plaintext highlighter-rouge">Foo.value</code>, then OCaml
requires <code class="language-plaintext highlighter-rouge">foo.mli</code> and <code class="language-plaintext highlighter-rouge">bar.mli</code> both to have been compiled before <code class="language-plaintext highlighter-rouge">bar.ml</code> is
compiled. However, thanks to this effectful trick, Lucas could instead allow the
compiler to start with <em>just</em> <code class="language-plaintext highlighter-rouge">bar.ml</code>. When <code class="language-plaintext highlighter-rouge">Foo.value</code> is encountered, there’s
a request made for <code class="language-plaintext highlighter-rouge">foo.cmi</code>, at which point, in the first prototype, the
compiler then quickly spawned another instance of itself to compile <code class="language-plaintext highlighter-rouge">foo.mli</code>
and <em>then</em> resumed compilation for <code class="language-plaintext highlighter-rouge">bar.ml</code>, with the same trick then happening
at the end of the compilation with <code class="language-plaintext highlighter-rouge">bar.cmi</code>. i.e. three files (<code class="language-plaintext highlighter-rouge">foo.mli</code>,
<code class="language-plaintext highlighter-rouge">bar.mli</code> and <code class="language-plaintext highlighter-rouge">bar.ml</code>) all compiled just from <code class="language-plaintext highlighter-rouge">ocamlc -c bar.ml</code>.</p>

<p>Possibly neat for being able to remove <a href="https://github.com/ocaml/ocaml/blob/trunk/.depend">monstrosities like this</a>
from OCaml’s source tree one day, but so far not <em>so</em> exciting. However, effects
give us more than just hooks into the compiler’s operations. We’ve got an
entire suspended compilation packaged up in a continuation… which means that
that same compiler “process” can now do something else. The next trick was to
have it that instead of spawning a new compiler, the current process itself
returned back into the compiler and itself compiled the required interface file
and <em>then</em> simply resumed the continuation of the previous filke. At this point,
the 30-year-old codebase rears its head again. For reasons of speed and space,
many parts of the compiler, especially in the type checker, feature a lot of
global mutable state. In particular, the compilation pipeline is <em>not</em>
re-entrant. Luckily, thanks to the Merlin project, there is a mechanism in the
type-checker for taking snapshots of all this global state. Lucas was able to
piggy-back on this so that, just before the compiler performs an effect to
request a .cmi file (that doesn’t yet exist), it snapshots all its global state,
performs the effect and then, when resumed, restores that state again.</p>

<p>Using this to interrupt type-checking and start on something else isn’t quite
what this <a href="https://github.com/ocaml/ocaml/blob/trunk/utils/local_store.mli"><code class="language-plaintext highlighter-rouge">Local_store</code> mechanism</a>
was originally intended for, and there was a bit of debugging to find a few more
pieces global state which weren’t being “registered”, but Lucas was able to get
a means of building the OCaml bytecode compiler with nothing pre-compiled where
all the compiler had to be given was the list of .ml files required. From a
toolchain perspective, we’re essentially retiring <a href="https://ocaml.org/manual/5.3/depend.html"><code class="language-plaintext highlighter-rouge">ocamldep</code></a>.</p>

<p>So far, still mostly just so neat: one single compiler process (just about)
successfully recompiling the compiler. However, that’s equivalent to compiling
with <code class="language-plaintext highlighter-rouge">make -j1</code> - a sequential, and therefore slow, build. The awesome part came
next - Domains. In the final version Lucas was working on, multiple domains were
started up, each one beginning compilation of one of the .ml files required for
the compiler <em>in parallel</em>, with a scheduler handling effects coming from each
of these in turn when .mli files needed compiling, and despatching those. The
<code class="language-plaintext highlighter-rouge">Local_store</code> mechanism in the came in handy here - Lucas extended it to use
<a href="https://ocaml.org/manual/5.3/api/Domain.DLS.html">Domain Local Storage</a>,
combined with the snapshotting. The prototype - for simplicity - featured no
sharing between these domains.</p>

<p>By the end of the summer, this was <em>very</em> nearly working, which is a result
consiserably further than I’d expected in the time available! As is so often the
case with these investigations, Lucas’s work had revealed some new facets to
this area that weren’t clear to me before. I had previously been wondering how
we would be exposing this kind of multi-threaded compiler to the user via the
driver programs, but it became increasingly clear that this wasn’t something
that would be necessary - the program that we were working on to build the
compiler itself was of course not the compiler driver, <em>but a build system</em>. To
me, there are two particularly exciting things about that:</p>

<ol>
  <li>It’s a <em>really simple</em> build system. Hopefully when the last few kinks in the
parallel type checker are ironed out (read on…), we may be able to add that
it’s really simple <strong>and performant</strong>.</li>
  <li>It’s fundamental portable. It leads to the possibility of bootstrapping OCaml
trivially with itself. This has been done before with <code class="language-plaintext highlighter-rouge">ocamlbuild</code>, but the
result was a maintenance disaster. However, the sheer simplicity of the
multi-domain effect-scheduling approach is making this perennial build system
hacker tinker…</li>
</ol>
