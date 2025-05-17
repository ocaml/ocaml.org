---
title: Exploring Concurrency in Agent-Based Modelling with Multicore OCaml
description:
url: https://anil.recoil.org/ideas/ocaml-forest-sim
date: 2021-01-01T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
---

<h1>Exploring Concurrency in Agent-Based Modelling with Multicore OCaml</h1>
<p>This is an idea proposed in 2021 as a Cambridge Computer Science Part II project, and has been <span class="idea-completed">completed</span> by <a href="https://anil.recoil.org/news.xml" class="contact">Martynas Sinkievič</a>.</p>
<p>Computational modelling techniques such as ABMs are used to understand the
dynamics of ecosystems and predict their behaviour in response to climate
change and ecological disturbances, while also searching for optimal paths
towards solutions to these problems. Terrestrial biosphere models are one such
model which simulate the vegetation and soil life cycle. There have been two
approaches taken with such modelling:</p>
<ul>
<li>The top-down approach take coarse-grained dynamic models that simulate environments in large chunks and scale to large areas as needed, but with a lack of accuracy in the simulated environment that only captures summarised features.</li>
<li>Bottom-up fine-grained agent-based models (ABMs) which provide a more accurate description of the modelled domain.</li>
</ul>
<p>This project investigates ABMs that simulate all relevant parameters of a local
environment and can capture the lifetime of agents, and thus can achieve
accurate summaries as observed emergent behaviour. These models are
computationally intensive, and so we need multi-processor hardware to be
utilised fully. While common performant languages for computational science
include C++ and Java, their semantics can be unforgiving in the face of complex
code, with data-races causing potentially causing non-sequential behaviour in
both languages. This makes debugging and developing such applications with
parallelism in mind very difficult, especially so for those without deep
background knowledge of the respective compilers and runtimes.  It is also
common practise in the aforementioned languages to introduce global state,
which can lead to difficult to interpret data relationships and makes
parallelism much more difficult to apply.</p>
<p>This project ported a particular example of the leading agent-based forest
simulator created by Marechaux and Chave, TROLL, and migrated it to OCaml while
applying a more functional style, and then introduced concurrency. This gave
insight into the difficulties of refactoring and maintaining modern scientific
computing codebases, as well as the new parallelisation mechanisms of Multicore
OCaml.</p>
<h2>Related reading</h2>
<ul>
<li>Isabelle Marechaux and Jerome Chave. An individual-based forest model to jointly simulate carbon and tree diversity in Amazonia: description and applications. Ecological Monographs, 87(4):632–664, 2017.</li>
</ul>
<h2>Links</h2>
<ul>
<li>The source code is on a <a href="https://github.com/mSinkievic/troll-ocaml">private repository on GitHub</a>. Please contact <a href="https://anil.recoil.org/news.xml" class="contact">Martynas Sinkievič</a> to request access.</li>
<li>The dissertation is available on request for interested students from <a href="https://anil.recoil.org" class="contact">Anil Madhavapeddy</a> but has not otherwise been made public.</li>
</ul>

