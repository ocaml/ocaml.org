---
title: MirageOS Spring 2019 hack retreat roundup
description:
url: https://mirage.io/blog/2019-spring-retreat-roundup
date: 2019-04-03T00:00:00-00:00
preview_image:
featured:
authors:
- Hannes Mehnert
---


        <p>Early March 2019, 31 MirageOS hackers gathered again in Marrakesh for our bi-annual hack retreat. We'd like to thank our amazing hosts, and everyone who participated on-site or remotely, and especially those who wrote up their experiences.
<img src="https://mirage.io/graphics/spring2019.jpg" style="glot:right; padding: 15px"/></p>
<p>On this retreat, we ate our own dogfood, and used our MirageOS <a href="https://github.com/mirage/mirage-skeleton/tree/master/applications/dhcp">DHCP</a>, <a href="https://github.com/roburio/unikernels/tree/master/resolver">recursive DNS resolver</a>, and <a href="https://github.com/roburio/caldav">CalDAV</a> unikernels as isolated virtual machines running on a <a href="https://pcengines.ch/apu2c4.htm">PC Engines APU</a> with <a href="https://freebsd.org">FreeBSD</a> as host system. The CalDAV server persisted its data in a git repository on the host system, using the raw git protocol for communication, the smart HTTP protocol could have been used as well. Lynxis wrote a <a href="https://lunarius.fe80.eu/blog/mirageos-2019.html">detailed blog post about our uplink situation</a>.</p>
<p>Lots of interesting discussions took place, code was developed, knowledge was exchanged, and issues were solved while we enjoyed the sun and the Moroccan food. The following list is not exhaustive, but gives an overview what was pushed forward.</p>
<h2><a href="https://github.com/rlepigre/ocaml-imagelib">Imagelib</a></h2>
<p>Imagelib is a library that can parse several image formats, and <a href="https://github.com/cfcs/eye-of-mirage">eye-of-mirage</a> uses it to display those images in a <a href="https://github.com/cfcs/mirage-framebuffer/">framebuffer</a>.</p>
<p>During the retreat, imagelib was extended with <a href="https://github.com/rlepigre/ocaml-imagelib/pull/22">support for the BMP format</a>, it's <a href="https://github.com/rlepigre/ocaml-imagelib/pull/23">build system was revised to split off Unix-dependent functionality</a>, and preliminary support for the GIF format was implemented.</p>
<h2><a href="https://github.com/kit-ty-kate/ocaml-activitypub">ActivityPub</a></h2>
<p>ActivityPub is an open, decentralized social networking protocol, as used by <a href="https://mastodon.social">mastodon</a>. It provides a client/server API for creating, updating, and deleting content, and a federated server-to-server API for notifications and content delivery. During the retreat, an initial prototype of a protocol implementation was drafted.</p>
<h2><a href="https://github.com/ocaml/opam">opam</a></h2>
<p>Opam, the OCaml package manager, was extended in several directions:</p>
<ul>
<li><a href="https://github.com/rjbou/opam/tree/depext">External (OS package system) dependency integration</a>
</li>
<li><a href="https://github.com/ocaml/opam/pull/3777">Interleaving download with build/install actions</a>
</li>
<li><a href="https://github.com/ocaml/opam/pull/3778">Generalisation of the job scheduler</a>
</li>
<li><a href="https://github.com/ocaml/opam/pull/3776">JSON serialisation, including crowbar round-trip tests</a>
</li>
<li>Plugin evaluating (binary) <a href="https://reproducible-builds.org/">reproducibility</a> of opam packages
</li>
<li>some smaller cleanup PRs (<a href="https://github.com/ocaml/opam/pull/3781">return values</a>, <a href="https://github.com/ocaml/opam/pull/3783">locking code</a>)
</li>
</ul>
<h2><a href="https://github.com/Armael/marracheck/">marracheck</a></h2>
<p>Work was started on a new utility to install as many opam packages as possible on a machine (there just wasn't enough choice with <a href="https://github.com/OCamlPro/opam-builder">opam-builder</a>, <a href="https://github.com/damiendoligez/opamcheck">opamcheck</a> and <a href="https://github.com/kit-ty-kate/opam-check-all">opam-check-all</a>). It uses opam-lib and Z3 to accomplish this.</p>
<h2><a href="https://github.com/hannesm/conex">Conex</a></h2>
<p>Conex is used for signing community repositories, esp. the opam-repository. Any opam package author can cryptographically sign their package releases, and users can verify that the downloaded tarball and build instructions are identical to what the author intended.</p>
<p>Conex has been developed since 2015, but is not yet widely deployed. We extended <a href="https://github.com/ocaml/opam-publish">opam-publish</a> to invoke the <code>conex_targets</code> utility and sign before opening a pull request on the opam-repository.</p>
<h2><a href="https://github.com/clecat/colombe">SMTP</a></h2>
<p>The simple mail transfer protocol is an Internet standard for sending and receiving eMail. Our OCaml implementation has been improved, and it is possible to send eMails from OCaml code now.</p>
<h2><a href="https://github.com/anmonteiro/ocaml-h2">HTTP2</a></h2>
<p>The hypertext transfer protocol is an Internet standard widely used for browsing the world wide web. HTTP 1.1 is a line-based protocol which was specified 20 years ago. HTTP2 is an attempt to fix various shortcomings, and uses a binary protocol with multiplexing, priorities, etc. An OCaml implementation of HTTP2 has been actively worked on in Marrakesh.</p>
<h2><a href="https://github.com/mirage/irmin">Irmin</a></h2>
<p>Irmin is a distributed database that follows the same design principles as git. Soon, Irmin 2.0 will be released, which includes GraphQL, HTTP, chunk support, and can use the git protocol for interoperability. Irmin provides a key-value interface for MirageOS.</p>
<h2>OCaml compiler</h2>
<p>Some hints on type errors for <a href="https://github.com/ocaml/ocaml/pull/2301">int literals</a> and <a href="https://github.com/ocaml/ocaml/pull/2307">int operators</a> were developed and merged to the OCaml compiler.</p>
<pre><code># 1.5 +. 2;;
         ^
Error: This expression has type int but an expression was expected of type
         float
       Hint: Did you mean `2.'?

# 1.5 + 2.;;
  ^^^ ^
Error: This expression has type float but an expression was expected of type
         int
Line 1, characters 4-5:
  Hint: Did you mean to use `+.'?
</code></pre>
<p>Also, the <a href="https://github.com/ocaml/ocaml/pull/608">whole program dead code elimination</a> PR was rebased onto trunk.</p>
<h2>BGP / lazy trie</h2>
<p>The <a href="https://github.com/mor1/mrt-format">mrt-format</a> library which can parse multi-threaded routing toolkit traces, has been adapted to the modern OCaml ecosystem. The <a href="https://github.com/jimyuan1995/Mirage-BGP">border gateway protocol (BGP)</a> library was slightly updated, one of its dependencies, <a href="https://github.com/mirage/ocaml-lazy-trie">lazy-trie</a> was adapted to the modern ecosystem as well.</p>
<h2>Xen PVH</h2>
<p>Xen provides several modes for virtualization.  MirageOS's first non-Unix target was the para-virtualized (PV) mode for Xen, which does not require hardware support from the hypervisor's host operating system but has a weak security profile (static mapping of addresses, large attack surface).  However, PV mode provides an attractive target for unikernels because it provides a simple software-based abstraction for dealing with drivers and a simple memory model; this is in contrast to hardware-virtualization mode, which provides greater security but requires more work from the guest OS.</p>
<p>A more modern virtualization mode combining the virtues of both approaches is PVH (formerly referred to as HVMLite), which is not yet supported by MirageOS.  Marek Marczykowski-G&oacute;recki from the <a href="https://qubes-os.org">QubesOS</a> project visited to help us bring PVH support to the <a href="https://xenproject.org/developers/teams/unikraft/">unikraft project</a>, a common platform for building unikernels which we hope to use for MirageOS's Xen support in the future.</p>
<p>During the retreat, lots of bugs porting MirageOS to PVH were solved. It boots and crashes now!</p>
<h2>Learn OCaml as a unikernel</h2>
<p>The platform learn OCaml embeds an editor, top-level, and exercises into a HTTP server, and allows students to learn OCaml, and submit solutions via the web interface, where an automated grader runs unit tests etc. to evaluate the submitted solutions. Teachers can assign mandatory exercises, and have an overview how the students are doing. Learn OCaml used to be executable only on a Unix host, but is now beeing ported into a MirageOS unikernel, executable as a standalone virtual machine.</p>
<h2>Network device driver (ixy)</h2>
<p>The ixy network driver supports Intel 82599 network interface cards, and <a href="https://github.com/ixy-languages/ixy.ml">is implemented in OCaml</a>. Its performance has been improved, including several failing attempts which degraded its performance. Also, <a href="https://github.com/mirage/mirage/pull/977">it has been integrated into the mirage tool</a> and is usable as a <a href="https://github.com/mirage/mirage-net">mirage-net</a> implementation.</p>
<h2>DNS client API</h2>
<p>Our proposed API is <a href="https://github.com/roburio/udns/blob/09c5e3c74c92505ec97f2a16818cc8a030e2868f/client/udns_client_flow.mli#L53-L80">described here</a>. Unix, Lwt, and MirageOS implementations are already available.</p>
<h2><a href="https://github.com/mirage/mirage-http">mirage-http</a> unified HTTP API</h2>
<p>Since we now have two HTTP servers, <a href="https://github.com/mirage/ocaml-cohttp">cohttp</a> and <a href="https://github.com/inhabitedtype/httpaf">httpaf</a>, in OCaml and MirageOS available, the new interface <a href="https://github.com/mirage/mirage-http">mirage-http</a> provides a unified interface, and also supports connection upgrades to websockets.</p>
<h2><a href="https://github.com/mirage/ocaml-cstruct">cstruct</a> capabilities</h2>
<p>We use cstruct, a wrapper around OCaml's <a href="http://caml.inria.fr/pub/docs/manual-ocaml/libref/Bigarray.html">Bigarray</a>, quite a lot in MirageOS. Until now, cstruct is a readable and writable byte array. We used phantom types to <a href="https://github.com/mirage/ocaml-cstruct/pull/237">add capabilities</a> to the interface to distinct read-only and write-only buffers.</p>
<h2><a href="https://github.com/hannesm/patch">patch</a></h2>
<p>An OCaml implementation to apply unified diffs. This code has been extracted from conex (since we found some issues in it), and still needs to be fixed.</p>
<h2>Statistical memory profiler</h2>
<p>Since 2016, Jacques-Henri Jourdan has been working on a <a href="https://github.com/ocaml/ocaml/pull/847">statistical memory profiler for OCaml</a> (read the <a href="https://jhjourdan.mketjh.fr/pdf/jourdan2016statistically.pdf">OCaml 2016 paper</a>). An <a href="https://github.com/jhjourdan/statmemprof-emacs/">Emacs user interface</a> is available since some years. We integrated statmemprof into MirageOS unikernels <a href="https://github.com/hannesm/statmemprof-mirage">using the statmemprof-mirage library</a>, marshal the data via TCP, and provide a proxy that communicates with Emacs over a Unix domain socket, and the unikernel.</p>
<h2><a href="https://github.com/p2pcollab">P2Pcollab</a></h2>
<p>P2Pcollab is a collection of composable libraries implementing protocols for P2P collaboration.
So far various P2P gossip protocols has been implemented.
At this retreat the focus was on a gossip-based publish-subscribe dissemination protocol.
Future plans include building P2P unikernels and adding P2P pub/sub sync functionality to Irmin.</p>

      
