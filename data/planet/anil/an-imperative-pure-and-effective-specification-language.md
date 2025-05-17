---
title: An imperative, pure and effective specification language
description:
url: https://anil.recoil.org/ideas/effective-specification-languages
date: 2024-08-01T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
---

<h1>An imperative, pure and effective specification language</h1>
<p>This is an idea proposed in 2024 as a Cambridge Computer Science Part II project, and is currently <span class="idea-ongoing">being worked on</span> by <a href="mailto:ms2922@cam.ac.uk" class="contact">Max Smith</a>. It is co-supervised with <a href="https://patrick.sirref.org" class="contact">Patrick Ferris</a>.</p>
<p>Formal specification languages are conventionally rather functional looking,
and not hugely amenable to iterative development. In contrast, real world
specifications for geospatial algorithms tend to developed with "holes" in the
logic which is then filled in by a domain expert as they explore the datasets
through small pieces of exploratory code and visualisations.</p>
<p>This project seeks to investigate the design of a specification language that
<em>looks and feels</em> like Python, but that supports typed holes and the robust
semantic foundations of a typed functional language behind the hood. The
langage would have a Python syntax, with the familiar imperative core, but
translate it into <a href="https://hazel.org">Hazel</a> code behind the scenes.</p>
<p>Another direction to investigate is also translating the same code into OCaml 5,
and use the new effect system to handle IO and mutability in the source language
code. This would allow for multiple interpretations of the program to execute
depending on the context:</p>
<ul>
<li>an interative JavaScript-compiled (or wasm-compiled) tracing version that records variable updates</li>
<li>a high performance version that batches and checkpoints variable updates and deploys parallel execution</li>
</ul>
<h2>Background Reading</h2>
<ul>
<li><a href="https://hazel.org/papers/propl24.pdf">Toward a Live, Rich, Composable, and Collaborative Planetary Compute Engine</a>, PROPL 2024.</li>
<li><a href="https://patrick.sirref.org" class="contact">Patrick Ferris</a>'s first year PhD report (available on request to students interested in this idea).</li>
<li><a href="https://anil.recoil.org/papers/2021-pldi-retroeff">Retrofitting effect handlers onto OCaml</a></li>
</ul>
<h2>Links</h2>
<ul>
<li><a href="https://hazel.org">Hazel</a></li>
</ul>

