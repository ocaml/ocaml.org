---
title: Simulating XMPP Group Communication
description:
url: https://anil.recoil.org/ideas/xmpp-group-comms
date: 2011-01-01T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
---

<h1>Simulating XMPP Group Communication</h1>
<p>This is an idea proposed in 2011 as a Cambridge Computer Science Part II project, and has been <span class="idea-completed">completed</span> by <a href="https://farhanmannan.com" class="contact">Farhān Mannān</a>.</p>
<p>The problem of getting a digital message from one place to another has a staggering range of possible scenarios, constraints and applications. Humans and devices are in constant dialogue, with various constraints and contracts being invisibly maintained. Even the most flippant instant message sets layers of protocols in motion, all straining to resolve identities and propagate information transparently across disparate physical components that must present a logically unified front to users. Subtleties like authentication, encryption and anonymity abound.</p>
<p>This project aims to build an OCaml-based simulator (using the <code>ocamlgraph</code> library) to build an XMPP protocol simulator that can model the networks, agents and protocols involved in XMPP-based group communication. The project is twofold and modular: the core is a simulator which is used to investigate the properties of gossip protocols acting on different graph topologies. The simulator can be parameterised on an RPC implementation so that rather than using simulated graphs, it can monitor the performance of the algorithms on real networks as well. An attempted extension is implementation of a functional OCaml RPC abstraction over XMPP which would be compatible with the simulator and be usable with <a href="https://mirageos.org">MirageOS</a>.</p>
<h2>Related Reading</h2>
<ul>
<li><a href="https://xmpp.org/extensions/xep-0045.html">XEP-0045</a> XMPP multiuser chat spec.</li>
<li>An OCaml <a href="https://github.com/ermine/xmpp">XMPP implementation</a></li>
<li><a href="https://anil.recoil.org/papers/rwo">Real World OCaml: Functional Programming for the Masses</a></li>
</ul>
<h2>Links</h2>
<p>The source code to the <a href="https://github.com/f6m6/gossip">OCaml XMPP simulator</a>
is available publically.  The dissertation PDF isn't available publically but
should be in the Cambridge Computer Lab archives somewhere.</p>

