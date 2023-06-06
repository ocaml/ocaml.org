---
title: MirageOS Summer 2016 hack retreat roundup
description:
url: https://mirage.io/blog/2016-summer-hackathon-roundup
date: 2016-07-18T00:00:00-00:00
preview_image:
featured:
authors:
- Gemma Gordon
---


        <p><a href="https://www.flickr.com/photos/138528518@N02/sets/72157671241464475"><img src="https://mirage.io/graphics/cambridge2016-hackathon.jpg" align="right" width="250px"/></a>
Our first Cambridge-based MirageOS hack retreat took place yesterday - and what a fantastic day it was! The torrential rain may have halted our punting plans, but it didn't stop progress in the Old Library! Darwin College was a fantastic venue, complete with private islands linked by picturesque wooden bridges and an unwavering wifi connection.</p>
<p>People naturally formed groups to work on similar projects, and we had a handful of brand new users keen to get started with OCaml and Mirage.  The major tasks that emerged were:</p>
<ul>
<li><strong>new hypervisor target</strong>: the integration of the Solo5 KVM-based hypervisor backend, bringing the number of officially supported targets up to 3 (Xen, Unix and KVM)
</li>
<li><strong>build system template</strong>: establishing a new <a href="https://erratique.ch/software/topkg">topkg</a>  template for MirageOS libraries, to prepare us for building a unified API documentation bundle that works across all the entire project.
</li>
<li><strong>CPU portability</strong>: improving ARM support via a better base OS image.
</li>
<li><strong>libraries breadth</strong>: hacking on all the things to fill in the blanks, such as btree support for bare-metal <a href="https://github.com/mirage/irmin">Irmin</a>, or a peer-to-peer layer for the <a href="https://github.com/docker/datakit">DataKit</a>.
</li>
</ul>
<p>We'll write about all of this in more detail, but for now here are the hack retreat notes hot off the press...</p>
<h3>Solo5/MirageOS integration (KVM-based backend)</h3>
<p>Progress on the Solo5 project has been steaming ahead <a href="https://mirage.io/blog/introducing-solo5">since January</a>, and this was the perfect opportunity to get everyone together to plan its integration with MirageOS. <a href="http://researcher.ibm.com/researcher/view.php?person=us-djwillia">Dan Williams</a> from IBM Research flew over to join us for the week, and <a href="https://github.com/mato">Martin Lucina</a> headed to Cambridge to prepare for the upstreaming of the recent Solo5 work. This included deciding on naming and ownership of the repositories, detailing the relationships between repositories and getting ready to publish the mirage-solo5 packages to OPAM. <a href="http://somerandomidiot.com">Mindy Preston</a>, our MirageOS 3.0 release manager, and <a href="http://anil.recoil.org">Anil Madhavapeddy</a> and <a href="http://gazagnaire.org">Thomas Gazagnaire</a> (OPAM minions) were on hand to help plan this smoothly.</p>
<p>See their updates from the day on <a href="http://canopy.mirage.io/Posts/Solo5">Canopy</a> and related blog posts:</p>
<ul>
<li><a href="https://mirage.io/blog/introducing-solo5">Introducing Solo 5</a>
</li>
<li>Unikernel Monitors HotCloud 2016 <a href="https://www.usenix.org/system/files/conference/hotcloud16/hotcloud16_williams.pdf">paper</a> and <a href="https://www.usenix.org/sites/default/files/conference/protected-files/hotcloud16_slides_williams.pdf">slides</a>
</li>
<li><a href="https://github.com/Solo5/solo5/issues/36">upstreaming GitHub issue</a> and <a href="https://github.com/Solo5/solo5/issues/61">FreeBSD support tracking issue</a> from Hannes Mehnert.
</li>
</ul>
<h3>Onboarding new MirageOS/OCaml users</h3>
<p>Our tutorials and onboarding guides <em>really</em> needed a facelift and an update, so <a href="https://ocaml.io/w/User:GemmaG">Gemma Gordon</a> spent the morning with some of our new users to observe their installation process and tried to pinpoint blockers and areas of misunderstanding. Providing the simple, concise instructions needed in a guide together with alternatives for every possible system and version requirement is a tricky combination to get right, but we made some <a href="https://github.com/mirage/mirage-www/pull/468">changes</a> to the <a href="https://mirage.io/docs/install">installation guide</a> that we hope will help. The next task is to do the same for our other popular tutorials, reconfigure the layout for easy reading and centralise the information as much as possible between the OPAM, MirageOS and OCaml guides. Thank you to Marwan Aljubeh for his insight into this process.</p>
<p>Other industrial users are also steaming ahead with their own MirageOS deployments. <a href="http://amirchaudhry.com">Amir Chaudhry</a> spent the hackathon blogging about <a href="http://unikernel.org/blog/2016/unikernel-nfv-platform">NFV Platforms with MirageOS unikernels</a>, which details how Ericsson Silicon Valley has been using MirageOS to build lightweight routing kernels.</p>
<h3>Packaging</h3>
<p>Thomas Gazagnaire was frenetically converting <code>functoria</code>, <code>mirage</code>, <code>mirage-types</code> and <code>mirage-console</code> to use <a href="https://github.com/dbuenzli/topkg">topkg</a>, and the feedback prompted fixes and a new release from Daniel Buenzli.</p>
<ul>
<li><a href="https://github.com/mirage/functoria/pull/64">Functoria #64</a>
</li>
<li><a href="https://github.com/mirage/mirage/pull/558">Mirage #558</a>
</li>
<li><a href="https://github.com/mirage/mirage-console/pull/41">Mirage-console #41</a>
</li>
</ul>
<h3>ARM and Cubieboards</h3>
<p>Ian Campbell implemented a (slightly hacky) way to get Alpine Linux onto some Cubieboard2 boxes and <a href="https://gist.github.com/ijc25/612b8b7975e9461c3584b1402df2cb34">provided notes</a> on his process, including how to tailor the base for KVM and Xen respectively.</p>
<p>Meanwhile, Qi Li worked on testing and adapting <a href="https://github.com/yomimono/simple-nat">simple-nat</a> and <a href="https://github.com/yomimono/mirage-nat">mirage-nat</a> to provide connectivity control for unikernels on ARM Cubieboards to act as network gateways.</p>
<ul>
<li><a href="https://github.com/yomimono/simple-nat/tree/ethernet-level-no-irmin">Simple-NAT ethernet branch</a>
</li>
<li><a href="https://github.com/yomimono/mirage-nat/tree/depopt_irmin">Mirage NAT with optional Irmin branch</a>
</li>
</ul>
<p><a href="https://www.cl.cam.ac.uk/~hm519/">Hannes Mehnert</a> recently published a purely functional <a href="https://github.com/hannesm/arp">ARP package</a> and continued refining it (with code coverage via <a href="https://github.com/aantron/bisect_ppx">bisect-ppx</a>) during the hackathon.</p>
<h3>MirageOS 3.0 API changes</h3>
<p>Our MirageOS release manager, Mindy Preston, was on hand to talk with everyone about their PRs in preparation for the 3.0 release along with some patches for deprecating out of date code.  There has been a lot of discussion on the <a href="https://lists.xenproject.org/archives/html/mirageos-devel/2016-07/msg00000.html">development list</a>.  One focus was to address time handling properly in the interfaces: Matthew Gray came up from London to finish up his extensive revision of the <a href="https://github.com/mirage/mirage/issues/442">CLOCK</a> interface, and Hannes developed a new <a href="https://github.com/hannesm/duration">duration</a> library to handle time unit conversions safely and get rid of the need for floating point handling.  We are aiming to minimise the dependency on floating point handling in external interfaces to simplify compilation to very embedded hardware that only has soft floats (particularly for something as ubiquitous as time handling).</p>
<h3>Error logging</h3>
<p>Thomas Leonard continued with the work he started in Marrakech by <a href="https://github.com/mirage/functoria/pull/55">updating the error reporting patches</a> (also <a href="https://github.com/mirage/mirage-dev/pull/107">here</a>) to work with the latest version of MirageOS (which has a different logging system based on Daniel Buenzlis <a href="http://erratique.ch/software/logs">Logs</a>). See the <a href="http://canopy.mirage.io/Posts/Errors">original post</a> for more details.</p>
<h3>Ctypes 0.7.0 release</h3>
<p>Jeremy released the foreign function interface library <a href="https://github.com/ocamllabs/ocaml-ctypes/releases/tag/0.7.0">Ctypes 0.7.0</a> which, along with bug fixes, adds the following features:</p>
<ul>
<li>Support for bytecode-only architectures (<a href="https://github.com/ocamllabs/ocaml-ctypes/issues/410">#410</a>)
</li>
<li>A new <code>sint</code> type corresponding to a full-range C integer and updated errno support for its use (<a href="https://github.com/ocamllabs/ocaml-ctypes/issues/411">#411</a>)
</li>
</ul>
<p>See the full changelog <a href="https://github.com/ocamllabs/ocaml-ctypes/blob/master/CHANGES.md">online</a>.</p>
<h3>P2P key-value store over DataKit</h3>
<p>KC Sivaramakrishnan and Philip Dexter took on the challenge of grabbing the Docker <a href="https://github.com/docker/datakit">DataKit</a> release and started building a distributed key-value store that features flexible JSON synching and merging.  Their raw notes are in a <a href="https://gist.github.com/kayceesrk/d3edb2da0aa9a3d40e9e3f838b67bd1a">Gist</a> -- get in touch with them if you want to help hack on the sync system backed by Git.</p>
<h3>Developer experience improvements</h3>
<p>The OCaml Labs undergraduate interns are spending their summers working on user improvements and CI logs with MirageOS, and used the time at the hackathon to focus on these issues.</p>
<p>Ciaran Lawlor is working on an editor implementation, specifically getting the <a href="https://github.com/andrewray/iocaml">IOcaml kernel</a> working with the <a href="https://github.com/nteract/hydrogen">Hydrogen</a> plugin for the Atom editor. This will allow developers to run OCaml code directly in Atom, and eventually interactively build unikernels!</p>
<p>Joel Jakubovic used <a href="https://github.com/inhabitedtype/angstrom">Angstrom</a> (a fast parser combinator library developed by Spiros Eliopoulos) to ANSI escape codes, usually displayed as colours and styles into HTML for use in viewing CI logs.</p>
<h3>Windows Support</h3>
<p>Most of the Mirage libraries already work on Windows thanks to lots of work in the wider OCaml community, but other features don't have full support yet.</p>
<p><a href="http://dave.recoil.org">Dave Scott</a> from Docker worked on <a href="https://github.com/djs55/ocaml-wpcap">ocaml-wpcap</a>: a <a href="https://github.com/ocamllabs/ocaml-ctypes">ctypes</a> binding to the Windows <a href="http://www.winpcap.org">winpcap.dll</a> which lets OCaml programs send and receive ethernet frames on Windows. The ocaml-wpcap library will hopefully let us run the Mirage TCP/IP stack and all the networking applications too.</p>
<p>David Allsopp continued his OPAM-Windows support by fine-tuning the 80 native Windows OCaml versions - these will hopefully form part of OPAM 2.0. As it turns out, he's not the only person still interested in being able to run OCaml 3.07...if you are, get in touch!</p>
<h3>General Libraries and utilities</h3>
<p><a href="https://github.com/OlivierNicole">Olivier Nicole</a> is working on an implementation of macros in OCaml and started working on the
HTML and XML templates using this system. The objective is to have the same
behaviour as the <code>Pa_tyxml</code> syntax extension, but in a type-safe and more
maintainable way without requiring PPX extensions. This project could be
contributed to the development of <a href="http://ocsigen.org">Ocsigen</a> once implemented.</p>
<p>Nick Betteridge teamed up with Dave Scott to look at using
<a href="https://github.com/djs55/ocaml-btree">ocaml-btree</a> as a backend for Irmin/xen
and spent the day looking at different approaches.</p>
<p>Anil Madhavapeddy built a Docker wrapper for the CI system and spun up a big cluster
to run OPAM bulk builds.  Several small utilities like <a href="https://github.com/avsm/jsontee">jsontee</a> and
an immutable <a href="https://github.com/avsm/opam-log-server">log collection server</a> and
<a href="https://github.com/avsm/opam-bulk-builder">bulk build scripts</a> will be released in the
next few weeks once the builds are running stably, and be re-usable by other OPAM-based
projects to use for their own tests.</p>
<p><a href="https://github.com/Chris00">Christophe Troestler</a> is spending a month at
<a href="https://ocaml.io">OCaml Labs</a> in Cambridge this summer, and spent the hack day
working on implementing a library to allow seamless application switching from
HTTP to FastCGI. Christophe has initiated work on a client and server for this
protocol using <a href="https://github.com/mirage/ocaml-cohttp">CoHTTP</a> so that it is
unikernel-friendly.</p>

      
