---
title: 'CausalRPC: a traceable distributed computation framework'
description:
url: https://anil.recoil.org/ideas/causal-rpc
date: 2018-01-01T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
---

<h1>CausalRPC: a traceable distributed computation framework</h1>
<p>This is an idea proposed in 2018 as a Cambridge Computer Science Part II project, and has been <span class="idea-completed">completed</span> by <a href="https://craigfe.io" class="contact">Craig Ferguson</a>.</p>
<p>The project aims to implement an RPC framework in OCaml using the <a href="https://github.com/mirage/irmin">Irmin</a> distributed database library as a network substrate. It will explore the trade-offs of a novel data-oriented approach to RPC in which race conditions between clients are resolved automatically by the middleware layer. The core deliverable is a demonstration of an RPC client remotely executing functions with Irmin-serialisable parameters on a server capable of handling concurrent client requests.</p>
<p>The project was completed successfully, with an implementation of <a href="https://github.com/craigfe/causal-rpc">CausalRPC</a>, a distributed computation framework satisfying the above criteria.  The approach of making the statefulness of RPC explicit was surprisingly effective, allowing CausalRPC to provide stronger consistency and traceability guarantees than conventional RPC systems. This broadened the scope of the project considerably, allowing for a variety of extensions to explore the inherent trade-offs of the approach. The final version of CausalRPC supported fault-tolerant worker clusters and is compatible with <a href="https://mirageos.org">MirageOS</a>.</p>
<h2>Related reading</h2>
<ul>
<li><a href="https://anil.recoil.org/papers/2015-jfla-irmin">Mergeable persistent data structures</a></li>
</ul>
<h2>Links</h2>
<p>The project PDF writeup is publically <a href="https://www.craigfe.io/causalrpc.pdf">available</a>, and <a href="https://craigfe.io" class="contact">Craig Ferguson</a> won the G-Research Prize for Best Individual Project 2018 departmental prize.</p>
<p><a href="https://craigfe.io" class="contact">Craig Ferguson</a> also gave a <a href="https://ocaml.org/workshops/ocaml-workshop-2019">talk about CausalRPC</a> at the 2019 OCaml Workshop. Unfortunately the videos of that year's ICFP don't seem to have made it online, but the <a href="https://github.com/CraigFe/causal-rpc-talk">slides are available</a>.</p>
<p><a href="https://craigfe.io" class="contact">Craig Ferguson</a> followed up with a podcast where he discussed his subsequent work on Irmin in 2022:</p>
<iframe title="Casually talking with Craig Ferguson about OCaml, Mirage, Irmin and more" width="560" height="315" src="https://watch.ocaml.org/videos/embed/f3aa87e9-67a1-4569-b154-67d2d185152b" frameborder="0" allowfullscreen="" sandbox="allow-same-origin allow-scripts allow-popups allow-forms"></iframe>

