---
title: Macro- and Micro-benchmarking in OCaml
description:
url: https://anil.recoil.org/ideas/macro-micro-benchmarking
date: 2012-01-01T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
---

<h1>Macro- and Micro-benchmarking in OCaml</h1>
<p>This is an idea proposed in 2012 as a Cambridge Computer Science Part II project, and has been <span class="idea-completed">completed</span> by <a href="https://anil.recoil.org/news.xml" class="contact">Sebastian Funk</a>.</p>
<p>Benchmarking involves the measurement of statistics such as run-time, memory allocations, garbage collections in a running program in order to analyze its performance and behaviour. To scientifically evaluate and understand the performance of a program, there is often a cycle of:</p>
<ol>
<li>making performance observations about the program</li>
<li>finding a potential hypothesis, i.e. a cause for this performance behaviour</li>
<li>making predictions on experiments based on this hypothesis</li>
<li>comparing the predictions against the actual benchmark results to evaluate the hypothesis.</li>
</ol>
<p>To be able to do all this, there is a need for an effective and robust
framework to continuously make these observations that is not biased by the
choice of hypothesis or the observation made.  In general, any sort of
improvement relies on robust and precise measurements.</p>
<p>Benchmarking can be split into two perspectives: micro-benchmarking, measuring
a single (small) function repeatedly to collect statistics for a regression,
and macro-benchmarking, measuring the performance of a complete program or
library, often in a single-run.  This project aims to improve the benchmarking
infrastructure in OCaml, both at micro- and macro-benchmarking.</p>
<p>The project aims to add event tracing into OCaml, via instrumentation to the
<a href="https://github.com/janestreet/core-bench">Core Bench</a> library using Camlp4.
The event-tracing tool
is then a way for macro-benchmarking together with the multivariate regression
for micro-benchmarking to analyze the performance of commonly used libraries to
exhibit and explain abnormalities and performance differences in
implementations.  On a meta-level this study will give an insight into which
predictors are useful for a multivariate regression in which circumstances to
provide interesting results and how event-tracing can be used efficiently and
compactly in large libraries.</p>
<h2>Related Reading</h2>
<ul>
<li><a href="https://anil.recoil.org/papers/rwo">Real World OCaml: Functional Programming for the Masses</a></li>
</ul>
<h2>Links</h2>
<p>The dissertation is available on request to students from <a href="https://anil.recoil.org" class="contact">Anil Madhavapeddy</a> but isn't
online anywhere. The source code (a CamlP4 event tracer) has been superceded by modern
event tracing.</p>
<p><a href="https://anil.recoil.org/news.xml" class="contact">Sebastian Funk</a> went on to work at Jane Street on OCaml after his project, and one
2019 talk on his subsequent work can be seen below.</p>
<iframe width="560" height="315" src="https://www.youtube-nocookie.com/embed/BysBMdx9w6k?si=8Ll6iVYsK2Q-DHVh" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen=""></iframe>

