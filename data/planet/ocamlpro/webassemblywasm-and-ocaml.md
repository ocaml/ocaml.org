---
title: WebAssembly/Wasm and OCaml
description: In this first post about WebAssembly (Wasm) and OCaml, we introduce the
  work we have been doing for quite some time now, though without publicity, about
  our participation in the Garbage-Collection (GC) Working Group for Wasm, and two
  related development projects in OCaml. WebAssembly, a fast and por...
url: https://ocamlpro.com/blog/2022_12_14_wasm_and_ocaml
date: 2022-12-14T13:19:46-00:00
preview_image: URL_de_votre_image
authors:
- "\n    L\xE9o Andr\xE8s\n  "
source:
---

<p></p>
<div class="figure">
  <p>
    <img src="https://ocamlpro.com/blog/assets/img/dalle_dragon_camel.png" alt=""/>
    </p><div class="caption">
      The Dragon-Camel is raging at the sight of all the challenges we overcome!
    </div>
  
</div>
<p>In this first post about <a href="https://webassembly.org/">WebAssembly</a> (Wasm) and OCaml, we introduce
the work we have been doing for quite some time now, though without
publicity, about our participation in the Garbage-Collection (GC)
Working Group for Wasm, and two related development projects in OCaml.</p>
<h2>WebAssembly, a fast and portable bytecode</h2>
<blockquote>
<p>WebAssembly is a low-level, binary format that allows compiled code
to run efficiently in the browser. Its roadmap is decided by Working
Groups from multiple organizations and companies, including
Microsoft, Google, and Mozilla. These groups meet regularly to
discuss and plan the development of WebAssembly, with the broader
community of developers, academics, and other interested parties to
gather feedback and ideas for the future of WebAssembly.</p>
</blockquote>
<p>There are multiple projects in OCaml related to Wasm, notably
<a href="https://github.com/remixlabs/wasicaml">Wasicaml</a>, a production-ready port of the OCaml bytecode interpreter
to Wasm . However, these projects don't tackle the domain we would
like to address, and for good reasons: they target the <strong>existing</strong>
version of Wasm, which is basically a very simple programming language
with no data structures, but with an access to a large memory
array. Almost anything can of course be compiled to something like
that, but there is a big restriction: the resulting program can
interact with the outside world only through the aforementioned memory buffer.
This is perfectly fine if you write Command-Line Interface (CLI) tools,
or workers to be deployed in a Content Delivery Network (CDN). However,
this kind of interaction can become quite tedious if you need to deal
with abstract objects provided by your environment, for example DOM
objects in a browser to manipulate webpages. In such cases, you will
need to write some wrapper access functions in JavaScript (or OCaml
with <code>js_of_ocaml</code> of course), and you will have to be very careful
about the lifetime of those objects to avoid memory leaks.</p>
<p>Hence the shiny new proposals to extend Wasm with various useful
features that can be very convenient for OCaml. In particular, three
extensions crucially matter to us, functional programmers: the
<a href="https://github.com/WebAssembly/gc/blob/main/proposals/gc/MVP.md">Garbage Collection</a>, <a href="https://github.com/WebAssembly/exception-handling/blob/main/proposals/exception-handling/Exceptions.md">Exceptions</a> and <a href="https://github.com/WebAssembly/tail-call/blob/main/proposals/tail-call/Overview.md">Tail-Call</a> proposals.</p>
<h2>Our involvement in the GC-related Working Group</h2>
<p>The Wasm committee has already worked on these proposals for a few
years, and the Exceptions and Tail-Call proposals are now quite
satisfying. However, this is not yet the case for the GC proposal. Indeed,
finding a good API for a GC that is compatible with all the languages
in the wild, that can be implemented efficiently, and can be used to
run a program you don't trust, is all but an easy task.
Multiple attempts by strong teams, for different virtual machines, have
exposed limitations of past proposals. But, we must now admit that the
current proposal has reached a state where it is quite impressive,
being both simple <strong>and</strong> generic.</p>
<p>The proposal is now getting close to a feature freeze status. Thanks
to the hard work of many people on the committee, including us, the
particularities of functional typed languages were not forgotten in
the design, and we are convinced that there should be no problem for
OCaml. Now is the time to test it for real!</p>
<h2>Targetting Wasm from the OCaml Compiler</h2>
<p>Adding a brand new backend to a compiler to target something that is
quite different from your usual assembly can be a huge work, and only
a few language developers actively work on making a prototype for
Wasm+GC. Yet, we think that it is important for the committee, to have
as many examples as possible to validate the proposal and move it to
the next step.</p>
<p>That's the reason why we decided to contribute to the proposal, by
prototyping a backend for Wasm to the OCaml compiler.</p>
<h2>Our experimental Wasm interpreter in OCaml</h2>
<p>In parallel, we are also working on the development of our own Wasm
Virtual Machine in OCaml, to be able to easily experiment both on the
OCaml side and Wasm side, while waiting for most official Wasm VM to
fully implement the new proposals.</p>
<p>These experimental projects and related discussions are very important
design steps, although obviously far from production-ready status.</p>
<p>As our current work focuses on OCaml 4.14, effect handlers are left for
future work. The current <a href="https://github.com/WebAssembly/stack-switching/blob/main/proposals/stack-switching/Overview.md">proposal</a> that would make it possible to
compile effect handlers to Wasm nicely is still in its earlier stages.
We hope to be able to prototype it too on our Wasm VM.</p>
<p>Note that we are looking for sponsors to fund this work. If supporting
Wasm in OCaml may impact your business, you can contact us to discuss
how we can use your help!</p>
<p>Our next blog post in January will provide more technical details on
our two prototyping efforts.</p>

