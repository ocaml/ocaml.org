---
title: Not-quite-so-broken TLS in OCaml
description:
url: https://anil.recoil.org/ideas/nqsb-tls
date: 2014-01-01T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
---

<h1>Not-quite-so-broken TLS in OCaml</h1>
<p>This is an idea proposed in 2014 as a good starter project, and has been <span class="idea-completed">completed</span> by <a href="https://github.com/hannesm" class="contact">Hannes Mehnert</a> and <a href="https://github.com/pqwy" class="contact">David Kaloper-Mersinjak</a>. It was co-supervised with <a href="https://www.cl.cam.ac.uk/~pes20/" class="contact">Peter Sewell</a>.</p>
<p>Transport Layer Security (TLS) implementations have a history of security flaws. The immediate causes of these are often programming errors, e.g. in memory manage- ment, but the root causes are more fundamental: the challenges of interpreting the ambiguous prose specification, the complexities inherent in large APIs and code bases, inherently unsafe programming choices, and the impossibility of directly testing conformance between implementations and the specification.</p>
<p>This internship was to work on nqsb-TLS, our re-engineered approach to security protocol specification and implementation that addresses the above root causes. The same source code serves two roles: it is both a specification of TLS, executable as a test oracle to check conformance of traces from arbitrary implementations, and a usable implementation of TLS; a modular and declarative programming style provides clean separation between its components. Many security flaws are thus excluded by construction.</p>
<p>nqsb-TLS can be used in standalone Unix applications, which we demonstrate with a messaging client, and can also be compiled into Xen unikernels (see <a href="https://anil.recoil.org/projects/unikernels">Unikernels</a>) with a trusted computing base (TCB) that is 4% of a standalone system running a standard Linux/OpenSSL stack, with all network traffic being handled in a memory-safe language; this supports applications including HTTPS, IMAP, Git, and Websocket clients and servers. Despite the dual-role design, the high-level implementation style, and the functional programming language we still achieved reasonable performance, with the same handshake performance as OpenSSL and 73%–84% for bulk throughput.</p>
<h2>Links</h2>
<ul>
<li><a href="https://github.com/hannesm" class="contact">Hannes Mehnert</a> and <a href="https://github.com/pqwy" class="contact">David Kaloper-Mersinjak</a> worked on this in an internship after discovering the MirageOS project online, and came over in the summer of 2014. The results have been hguely successful within the OCaml community, as the <a href="https://github.com/mirleft/ocaml-tls">ocaml-tls</a> is still widely used as the defacto TLS stack in many popular OCaml applications.</li>
<li>The paper was published in USENIX Security; see <a href="https://anil.recoil.org/papers/2015-usenixsec-nqsb">Not-Quite-So-Broken TLS</a>.</li>
<li>For other stuff that happened during that internship period, see <a href="https://anil.recoil.org/notes/ocamllabs-2014-review">Reviewing the second year of OCaml Labs in 2014</a>.</li>
</ul>

