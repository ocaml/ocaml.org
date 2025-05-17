---
title: "Runtimes \xE0 la carte: crossloading native and bytecode OCaml"
description:
url: https://anil.recoil.org/ideas/ocaml-bytecode-native-ffi
date: 2025-04-01T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
---

<h1>Runtimes à la carte: crossloading native and bytecode OCaml</h1>
<p>This is an idea proposed in 2025 as a good starter project, and is <span class="idea-available">available</span> for being worked on. It may be co-supervised with <a href="https://github.com/dra27" class="contact">David Allsopp</a>.</p>
<p>In 1998, <a href="https://fabrice.lefessant.net/">Fabrice le Fessant</a> released Efuns ("Emacs for Functions"), an implementation of an Emacs-like editor entire in OCaml and which included a library for loading <a href="https://caml.inria.fr/pub/old_caml_site/caml-list/0780.html">bytecode within native code programs</a><sup><a href="https://anil.recoil.org/news.xml#fn-1" role="doc-noteref" class="fn-label">[1]</a></sup>.</p>
<p>This nearly a decade before OCaml 3.11 would introduce <a href="https://gallium.inria.fr/~frisch/ndl.txt">Alain Frisch's</a> native Dynlink support to OCaml. Natdynlink means that this original work has been largely forgotten, but there remain two interesting applications for being able to "cross-load" code compiled for the OCaml bytecode runtime in an OCaml native code application and vice versa:</p>
<ol>
<li>Native code OCaml applications could use OCaml as a scripting language without needing to include an assembler toolchain or solutions such as <a href="https://github.com/tarides/ocaml-jit">ocaml-jit</a>.</li>
<li>The existing bytecode REPL could use OCaml natdynlink plugins (<code>.cmxs</code> files) directly, allowing more dynamic programming and exploration of high-performance libraries with the ease of the bytecode interpreter, but retaining the runtime performance of the libraries themselves.</li>
</ol>
<p>This project aims to implement these two features directly in the OCaml distribution by:</p>
<ol>
<li>Extending the bytecode version of <code>Dynlink</code> to be able to load <code>.cmxs</code> files. This feature would be validated by extending the <code>#load</code>  directive of the bytecode toplevel <code>ocaml</code> to be able to load <code>.cmxs</code> files.</li>
<li>Extending the native version of <code>Dynlink</code> to be able to load bytecode units, both from <code>.cmo</code>/<code>.cma</code> files but also directly generated in the native code program itself. This feature would be validated by adding <code>ocaml.opt</code> to the distribution - i.e. the <em>bytecode</em> toplevel compiled in native code, acting as the bytecode toplevel today, but also capable of <code>#load</code>ing <code>.cmxs</code> files, and still converting toplevel phrases for execution by the bytecode interpreter</li>
</ol>
<p>This is a good student project for anyone seeking to gain more familiarity with a "real" compiler codebase, and to learn more about how these work towards (e.g.) hacking on <a href="https://anil.recoil.org/notes/wasm-on-exotic-targets">webassembly</a> in the future.</p>
<section role="doc-endnotes"><ol>
<li>
<p>A version can be found at <a href="https://github.com/jrrk/efuns/tree/master/dynlink">jrrk/efuns</a></p>
<span><a href="https://anil.recoil.org/news.xml#ref-1-fn-1" role="doc-backlink" class="fn-label">↩︎︎</a></span></li></ol></section>

