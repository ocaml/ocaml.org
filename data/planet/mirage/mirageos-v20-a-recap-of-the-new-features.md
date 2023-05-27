---
title: 'MirageOS v2.0: a recap of the new features'
description:
url: https://mirage.io/blog/announcing-mirage-20-release
date: 2014-07-22T00:00:00-00:00
preview_image:
featured:
authors:
- Anil Madhavapeddy
---


        <small>
  This work funded in part by the EU FP7 User-Centric Networking project, Grant
  No. 611001.
</small>
<p>The <a href="https://mirage.io/blog/announcing-mirage10">first release</a> of MirageOS back in December 2013 introduced the prototype
of the <a href="http://queue.acm.org/detail.cfm?id=2566628">unikernel concept</a>, which realised the promise of a safe,
flexible mechanism to build highly optimized software stacks purpose-built for deployment in the public cloud (more <a href="https://mirage.io/docs/overview-of-mirage">background</a> on this).
Since then, we've been hard at work using and extending MirageOS for real projects and the community has been
<a href="https://mirage.io/blog/welcome-to-our-summer-hackers">steadily growing</a>.</p>
<p>We're thrilled to announce the release of MirageOS v2.0 today!  Over the past
few weeks the <a href="https://mirage.io/community">team</a> has been <a href="https://github.com/mirage/mirage/issues/257">hard at work</a> blogging about all
the new features in this latest release, coordinated by the tireless <a href="http://amirchaudhry.com">Amir Chaudhry</a>:</p>
<img src="https://mirage.io/graphics/cubieboard2.jpg" style="float:right; padding: 5px" width="250px"/>
<ul>
<li><strong>ARM device support</strong>: While the first version of MirageOS was specialised towards conventional x86 clouds, the code generation and boot libraries have now been made portable enough to operate on low-power embedded ARM devices such as the <a href="http://cubieboard.org/">Cubieboard 2</a>.  This is a key part of our efforts to build a safe, unified <a href="http://anil.recoil.org/papers/2010-bcs-visions.pdf">mutiscale programming model</a> for both cloud and mobile workloads as part of the <a href="http://nymote.org">Nymote</a> project.  We also upstreamed the changes required to the Xen Project so that other unikernel efforts such as <a href="https://github.com/GaloisInc/HaLVM">HalVM</a> or <a href="https://www.usenix.org/system/files/conference/nsdi14/nsdi14-paper-martins.pdf">ClickOS</a> can benefit.
<ul>
<li><em>&quot;<a href="https://mirage.io/blog/introducing-xen-minios-arm">Introducing an ARMy of unikernels</a>&quot;</em> by <a href="http://roscidus.com/blog/">Thomas Leonard</a> talks about the changes required and <a href="https://mirage.io/docs/xen-on-cubieboard2">instructions</a> for trying this out for yourself on your own cheap Cubieboard.
</li>
</ul>
</li>
<li><strong>Irmin distributed, branchable storage</strong>: Unikernels usually execute in a distributed, disconnection-prone environment (particularly with the new mobile ARM support).  We therefore built the <a href="https://github.com/mirage/irmin">Irmin</a> library to explicitly make synchronization easier via a Git-like persistence model that can be used to build and easily trace the operation of distributed applications across all of these diverse environments.
<ul>
<li><em>&quot;<a href="https://mirage.io/blog/introducing-irmin">Introducing Irmin: Git-like distributed, branchable storage</a>&quot;</em> by <a href="http://gazagnaire.org">Thomas Gazagnaire</a> describes the concepts and high-level architecture of the system.
</li>
<li><em>&quot;<a href="https://mirage.io/blog/introducing-irmin-in-xenstore">Using Irmin to add fault-tolerance to the Xenstore database</a>&quot;</em> by <a href="http://dave.recoil.org">Dave Scott</a> shows how Irmin is used in a real-world application: the security-critical Xen toolstack that manages hosts full of virtual machines (<a href="https://www.youtube.com/watch?v=DSzvFwIVm5s">video</a>).
</li>
</ul>
</li>
<li><strong>OCaml TLS</strong>: The philosophy of MirageOS is to construct the entire operating system in a safe programming style, from the device drivers up.  This continues in this release with a comprehensive OCaml implementation of <a href="https://en.wikipedia.org/wiki/Transport_Layer_Security">Transport Level Security</a>, the most widely deployed end-to-end encryption protocol on the Internet (and one that is very prone to <a href="https://en.wikipedia.org/wiki/Heartbleed">bad security holes</a>).  The blog series is written by <a href="https://github.com/hannesm">Hannes Mehnert</a> and <a href="https://github.com/pqwy">David Kaloper</a>.
<ul>
<li><em>&quot;<a href="https://mirage.io/blog/introducing-ocaml-tls">OCaml-TLS: Introducing transport layer security (TLS) in pure OCaml</a>&quot;</em> presents the motivation and architecture behind our clean-slate implementation of the protocol.
</li>
<li><em>&quot;<a href="https://mirage.io/blog/introducing-nocrypto">OCaml-TLS: building the nocrypto library core</a>&quot;</em> talks about the cryptographic primitives that form the heart of TLS confidentiality guarantees, and how they expose safe interfaces to the rest of the stack.
</li>
<li><em>&quot;<a href="https://mirage.io/blog/introducing-x509">OCaml-TLS: adventures in X.509 certificate parsing and validation</a>&quot;</em> explains how authentication and chain-of-trust verification is implemented in our stack.
</li>
<li><em>&quot;<a href="https://mirage.io/blog/introducing-asn1">OCaml-TLS: ASN.1 and notation embedding</a>&quot;</em> introduces the libraries needed for handling ASN.1 grammars, the wire representation of messages in TLS.
</li>
<li><em>&quot;<a href="https://mirage.io/blog/ocaml-tls-api-internals-attacks-mitigation">OCaml-TLS: the protocol implementation and mitigations to known attacks</a>&quot;</em> concludes with the implementation of the core TLS protocol logic itself.
</li>
</ul>
</li>
</ul>
<ul>
<li><strong>Modularity and communication</strong>: MirageOS is built on the concept of a <a href="http://anil.recoil.org/papers/2013-asplos-mirage.pdf">library operating system</a>, and this release provides many new libraries to flexibly extend applications with new functionality.
<ul>
<li><em>&quot;<a href="https://mirage.io/blog/intro-tcpip">Fitting the modular MirageOS TCP/IP stack together</a>&quot;</em> by <a href="http://somerandomidiot.com">Mindy Preston</a> explains the rather unique modular architecture of our TCP/IP stack that lets you swap between the conventional Unix sockets API, or a complete implementation of TCP/IP in pure OCaml.
</li>
<li><em>&quot;<a href="https://mirage.io/blog/update-on-vchan">Vchan: low-latency inter-VM communication channels</a>&quot;</em> by <a href="http://jon.recoil.org">Jon Ludlam</a> shows how unikernels can communicate efficiently with each other to form distributed clusters on a multicore Xen host, by establishing shared memory rings with each other.
</li>
<li><em>&quot;<a href="https://mirage.io/blog/modular-foreign-function-bindings">Modular foreign function bindings</a>&quot;</em> by <a href="https://github.com/yallop">Jeremy Yallop</a> continues the march towards abstraction by expaining how to interface safely with code written in C, without having to write any unsafe C bindings!  This forms the basis for allowing Xen unikernels to communicate with existing libraries that they may want to keep at arm's length for security reasons.
</li>
</ul>
</li>
</ul>
<p>All the libraries required for these new features are <a href="https://mirage.io/releases">regularly
released</a> into the <a href="http://opam.ocaml.org">OPAM</a> package manager, so
just follow the <a href="https://mirage.io/wiki/install">installation instructions</a> to give them a spin.
A release this size probably introduces minor hiccups that may cause build
failures, so we very much encourage <a href="https://github.com/mirage/mirage/issues">bug
reports</a> on our issue tracker or
<a href="https://mirage.io/community">questions</a> to our mailing lists.  Don't be shy: no question is too
basic, and we'd love to hear of any weird and wacky uses you put this new
release to!  And finally, the lifeblood of MirageOS is about sharing and
<a href="http://opam.ocaml.org/doc/Packaging.html">publishing libraries</a> that add new functionality to the framework, so do get
involved and open-source your own efforts.</p>
<p><em>Breaking news</em>: <a href="http://mort.io">Richard Mortier</a> and I will be speaking at <a href="http://www.oscon.com">OSCON</a> this week on Thursday morning about the new features <a href="http://www.oscon.com/oscon2014/public/schedule/detail/35024">in F150 in the Cloud Track</a>. Come along if you are in rainy Portland at the moment!</p>

      
