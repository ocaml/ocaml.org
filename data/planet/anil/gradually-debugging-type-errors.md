---
title: Gradually debugging type errors
description:
url: https://anil.recoil.org/ideas/gradual-type-error-debugging
date: 2024-09-01T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
---

<h1>Gradually debugging type errors</h1>
<p>This is an idea proposed in 2024 as a Cambridge Computer Science Part II project, and is currently <span class="idea-ongoing">being worked on</span> by <a href="mailto:mc2372@cam.ac.uk" class="contact">Max Carroll</a>. It is co-supervised with <a href="https://patrick.sirref.org" class="contact">Patrick Ferris</a>.</p>
<p>Reasoning about type errors is very difficult, and requires shifting between
static and dynamic types. In OCaml, the type checker asserts ill-typedness but
provides little in the way of understanding why the type checker inferred such
types. These direct error messages are difficult to understand even for
experienced programmers working on larger codebases.</p>
<p>This project will explore how to use gradual types to reason more effectively
about such ill-typed programs, by introducing more dynamic types to help some
users build an intuition about the problem in their code. The intention is to
enable a more exploratory approach to constructing well-typed programs.</p>
<p>Some relevant reading:</p>
<ul>
<li><a href="https://drops.dagstuhl.de/entities/document/10.4230/LIPIcs.SNAPL.2015.274">Refined Criteria for Gradual Typing</a></li>
<li><a href="https://arxiv.org/abs/1810.12619">Dynamic Type Inference for Gradual Hindley-Milner Typing</a></li>
<li><a href="https://arxiv.org/abs/1606.07557">Dynamic Witnesses for Static Type Errors (or, Ill-Typed Programs Usually Go Wrong)</a></li>
</ul>

