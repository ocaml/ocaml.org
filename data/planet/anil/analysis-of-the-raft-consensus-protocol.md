---
title: Analysis of the Raft Consensus Protocol
description:
url: https://anil.recoil.org/ideas/raft-consensus
date: 2012-01-01T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
ignore: true
---

<h1>Analysis of the Raft Consensus Protocol</h1>
<p>This is an idea proposed in 2012 as a Cambridge Computer Science Part II project, and has been <span class="idea-completed">completed</span> by <a href="https://anil.recoil.org/news.xml" class="contact">Heidi Howard</a>.</p>
<p>The Paxos algorithm, despite being synonymous with distributed consensus for
a decade, is famously difficult to reason about and implement due to its
non-intuitive approach and underspecification. In response, this project
aimed to implement and evaluate a framework for constructing fault-tolerant
applications, utilising the recently proposed Raft algorithm for distributed
consensus. Constructing a simulation framework for our implementation would
enable us to evaluate the protocol on everything from understandability and
efficiency to correctness and performance in diverse network environments.</p>
<p>In retrospect, the complexity of the project far exceeded initial expectations:
reproducing research from a paper that was still under submission and was
modified regularly proved a big challenge alongside Raft's many subtleties.
Nevertheless, the project achieved optoinal extensions by using our work to
propose a range of optimisations to the Raft protocol. The project successfully
conducted a thorough analysis of the protocol and released to the community a
testbed for developing further optimisations and investigating optimal protocol
parameters for real-world deployments.</p>
<h2>Related Reading</h2>
<ul>
<li><a href="https://raft.github.io/raft.pdf">In Search of an Understandable Consensus Algorithm</a>, Diego Ongaro and John Ousterhout</li>
<li><a href="https://anil.recoil.org/papers/rwo">Real World OCaml: Functional Programming for the Masses</a></li>
</ul>
<h2>Links</h2>
<p>The dissertation is available as <a href="https://www.cl.cam.ac.uk/techreports/UCAM-CL-TR-857.html">UCAM-CL-TR-857</a> in the Cambridge Computer Laboratory technical report series.  <a href="https://anil.recoil.org/news.xml" class="contact">Heidi Howard</a> continued work on Raft subsequent to submitting this project and published it later in the year as <a href="https://anil.recoil.org/papers/2014-sigops-raft">Raft Refloated: Do We Have Consensus?</a>.</p>
<p>You can watch <a href="https://anil.recoil.org/news.xml" class="contact">Heidi Howard</a> talk about her work in a Computerphile video from 2016:</p>
<iframe width="560" height="315" src="https://www.youtube-nocookie.com/embed/jn3DBzr--Ok?si=D0rbJYdhqMX37pBw" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen=""></iframe>
<p><a href="https://anil.recoil.org/news.xml" class="contact">Heidi Howard</a> also continued to work on Raft and distributed consensus later:</p>
<iframe width="560" height="315" src="https://www.youtube-nocookie.com/embed/Pqc6X3sj6q8?si=HuYcxC1crauL422C" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen=""></iframe>

