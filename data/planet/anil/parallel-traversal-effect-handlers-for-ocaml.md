---
title: Parallel traversal effect handlers for OCaml
description:
url: https://anil.recoil.org/ideas/effect-parallel-strategies
date: 2024-09-01T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
---

<h1>Parallel traversal effect handlers for OCaml</h1>
<p>This is an idea proposed in 2024 as a Cambridge Computer Science Part II project, and is currently <span class="idea-ongoing">being worked on</span> by <a href="mailto:sb2634@cam.ac.uk" class="contact">Sky Batchelor</a>. It is co-supervised with <a href="https://patrick.sirref.org" class="contact">Patrick Ferris</a>.</p>
<p>Most existing uses of effect handlers perform synchronous execution of handled
effects. Xie <em>et al</em> proposed a <code>traverse</code> handler for parallelisation of
independent effectful computations whose effect handlers are outside the
parallel part of the program. The paper <sup><a href="https://anil.recoil.org/news.xml#fn-1" role="doc-noteref" class="fn-label">[1]</a></sup> gives a sample implementation as a
Haskell library with an associated λp calculus that formalises the parallel
handlers.</p>
<p>This project aims to:</p>
<ul>
<li>implement the <code>traverse</code> handler in OCaml 5, using single-shot handlers <sup><a href="https://anil.recoil.org/news.xml#fn-2" role="doc-noteref" class="fn-label">[2]</a></sup></li>
<li>identify a selection of parallel-friendly data structures that might benefit from such parallel traversals</li>
<li>investigate handlers for alternative traversal strategies beyond the folds support by <code>traverse</code></li>
<li>evaluate the performance of such parallel handlers, for instance using Eio's <code>Domain_pool</code> <sup><a href="https://anil.recoil.org/news.xml#fn-3" role="doc-noteref" class="fn-label">[3]</a></sup> on a many core machine (ranging from 8--128 cores)</li>
</ul>
<h2>Related reading</h2>
<section role="doc-endnotes"><ol>
<li>
<p><a href="https://dl.acm.org/doi/abs/10.1145/3674651">Parallel Algebraic Effect Handlers</a> describes the <code>traverse</code> effect</p>
<span><a href="https://anil.recoil.org/news.xml#ref-1-fn-1" role="doc-backlink" class="fn-label">↩︎︎</a></span></li><li>
<p><a href="https://anil.recoil.org/papers/2021-pldi-retroeff">Retrofitting effect handlers onto OCaml</a>, PLDI 2021 describes how the effect system in OCaml works.</p>
<span><a href="https://anil.recoil.org/news.xml#ref-1-fn-2" role="doc-backlink" class="fn-label">↩︎︎</a></span></li><li>
<p><a href="https://github.com/ocaml-multicore/eio">EIO</a> is a high-performance direct-style IO library we have been developing for OCaml.</p>
<span><a href="https://anil.recoil.org/news.xml#ref-1-fn-3" role="doc-backlink" class="fn-label">↩︎︎</a></span></li></ol></section>

