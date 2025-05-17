---
title: A hardware description language using OCaml effects
description:
url: https://anil.recoil.org/ideas/tracing-hdl-with-effects
date: 2025-03-01T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
---

<h1>A hardware description language using OCaml effects</h1>
<p>This is an idea proposed in 2025 as a Cambridge Computer Science Part III or MPhil project, and is <span class="idea-available">available</span> for being worked on. It may be co-supervised with <a href="https://kcsrk.info" class="contact">KC Sivaramakrishnan</a> and <a href="https://github.com/andrewray" class="contact">Andy Ray</a>.</p>
<p>Programming FPGAs using functional programming languages is a very good fit for
the problem domain. OCaml has the <a href="https://anil.recoil.org/notes/fpgas-hardcaml">HardCaml ecosystem</a> to
express hardware designs in OCaml, make generic designs using the power of the
language, then simulate designs and convert them to Verilog or VHDL.</p>
<p>HardCaml is very successfully used in production at places like <a href="https://janestreet.com">Jane
Street</a>, but needs quite a lot of prerequisite knowledge
about the full OCaml language. In particular, it makes very heavy use of the <a href="https://github.com/janestreet/hardcaml/blob/master/docs/hardcaml_interfaces.md">module
system</a> in
order to build up the circuit description as an OCaml data structure.</p>
<p>Instead of building up a circuit as the output of the OCaml program, it would
be very cool if we could <em>directly</em> implement the circuit as OCaml code by
evaluating it.  This is an approach that works very successfully in the <a href="https://github.com/clash-lang/clash-compiler">Clash
Haskell HDL</a>, as described in this
<a href="https://essay.utwente.nl/59482/1/scriptie_C_Baaij.pdf">thesis</a>. Clash uses a
number of advanced Haskell type-level features to encode fixed-length vectors
(very convenient for hardware description) and has an interactive REPL that
allows for exploration without requiring a separate test bench.</p>
<p>The question for this project is whether the new <a href="https://anil.recoil.org/papers/2021-pldi-retroeff">effect handlers</a>
in OCaml 5.0 might be suitable for using OCaml as a host language for a tracing-style
hardware description language.  We would explore several elements using OCaml 5:</p>
<ul>
<li>using effects for control-flow memoisation (see <a href="https://github.com/ocaml-multicore/effects-examples/blob/master/multishot/memo.ml">the example</a>)</li>
<li>restricting arbitrary recursion using effect handlers</li>
<li>ergonomic ways of encoding fixed-length vectors</li>
</ul>
<p>This project will require a deep interest in programming language design and implementation,
and an enthusiasm for learning more about digital hardware. There are quite a few good
<a href="https://anil.recoil.org/ideas/computational-storage-for-vector-dbs">usecases</a> for using heterogenous hardware like FPGAs these days.
There's a great <a href="https://signalsandthreads.com/programmable-hardware/">Signals and Threads episode</a> on
programmable hardware with <a href="https://github.com/andrewray" class="contact">Andy Ray</a> that should give you more useful background knowledge as well.</p>

