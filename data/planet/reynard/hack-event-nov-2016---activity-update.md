---
title: Hack Event Nov 2016 - Activity Update
description:
url: http://reynard.io/2016/11/16/CompHack.html
date: 2016-11-16T00:00:00-00:00
preview_image:
featured:
authors:
- reynard
---

<p>Thank you to everyone who attended the <a href="http://reynard.io/2016/11/02/CompilerHack.html">hack event</a> last night! We had over 20 attendees who came to work on issues related to the <a href="http://ocaml.org/">OCaml</a> compiler or <a href="https://mirage.io/">MirageOS</a>, from varied organisations including the <a href="https://www.cl.cam.ac.uk/">University of Cambridge</a>, <a href="https://www.docker.com/">Docker</a>, <a href="https://www.janestreet.com/technology/">Jane Street</a>, <a href="https://www.citrix.co.uk/">Citrix</a>, <a href="https://www.uber.com/en-GB/cities/london/">Uber</a> and <a href="http://www.hitachi.com/">Hitachi</a>.</p>

<p>
<img src="http://reynard.io/images/CompHack9:11:16.JPG" alt="Pembroke Hack Event" width="200"/>
<img src="http://reynard.io/images/2CompHack9:11:16.JPG" alt="Pembroke College" width="200"/>
</p>

<p>Friendly conversation, wine and one eye on the <a href="http://www.bbc.co.uk/news/election-us-2016-37932231">political</a> <a href="http://www.databoxproject.uk/">news</a> of the day led to a productive evening of PRs, merges, documentation and project discussion.</p>

<p>Join us for our next hack event at Pembroke College on 7th February 2017, more details to follow.</p>

<h3>First commits</h3>

<ul>
  <li>Joel Jakubovic <a href="https://github.com/ocaml/opam-repository/pulls/7789">published</a> his first OPAM package to finish his summer internship work. The <code class="highlighter-rouge">ansi-parse</code> library converts ANSI escape sequences into human-readable HTML.</li>
  <li>Liang Wang released a new version of his numerical library <a href="https://github.com/ryanrhymes/owl">Owl</a> into OPAM.  It supports sparse matrix operations, linear algebra and other statistical functions such as Markov chain Monte Carlo methods.  He also submitted his <a href="https://github.com/mirage/mirage/pulls/662">first PR</a> to <a href="https://mirage.io">MirageOS</a>.</li>
  <li>Dhruv Makwana took on the <a href="https://caml.inria.fr/mantis/view.php?id=6975">Buffer.truncate</a> junior_job tagged bug in Mantis and submitted his <a href="https://github.com/ocaml/ocaml/pull/902">first PR</a> to OCaml.</li>
  <li>Tadeu Zagallo took a look at the Mantis list and found a fix for <a href="https://caml.inria.fr/mantis/view.php?id=6608">functional record updates</a> and submitted his <a href="https://github.com/ocaml/ocaml/pull/901">first PR</a>.</li>
</ul>

<h3>MirageOS and OPAM</h3>

<ul>
  <li>Thomas Gazagnaire and Hannes Mehnert took the <a href="https://github.com/avsm/mirage-ci">mirage-ci</a> and made it work on a local machine without needing a GitHub bridge.  Hannes also got it building locally on FreeBSD!</li>
  <li>Takayuki Imada worked through the <a href="https://github.com/mirage/mirage-tcpip">Mirage TCP/IP</a> stack and started reading papers on <a href="http://info.iet.unipi.it/~luigi/netmap/">Netmap</a> to build a pure OCaml version for Mirage networking.</li>
  <li>David Scott worked on a first OPAM release of the <a href="https://github.com/docker/vpnkit">VPNKit</a>. This requires upstreaming some patches to related repositories so that there can be a stable release.</li>
  <li>Marcin Wojcik looked at the onboarding process of Mirage with Gemma and proposed a project on latency optimisation of running <a href="https://www.torproject.org">TOR</a> protocol using MirageOS and NetFPGA for Tor nodes.</li>
  <li>Matt Harrison worked on some documentation and tweaking of the build setup for his dissertation project on personal data silos using MirageOS and updated a post on setting up Travis for an OCaml project.</li>
  <li>Jon Ludlam and Christian Lindig who visited from Citrix introduced us to Marcello Seri and talked about plans to use OPAM in the build process at Citrix and possible internship subjects that overlap with Jane Street and <a href="http://reynard.io/ocaml.io">OCaml Labs</a>.</li>
</ul>

<h3>OCaml</h3>

<ul>
  <li>Maxime Lesourd and Olivier Nicole found a junior job to work on <a href="https://github.com/ocamllabs/compiler-hacking/wiki/Things-to-work-on#signatured-open-command">signatured open command</a> and got about halfway through the process.</li>
  <li>Dave Tucker started using <a href="https://github.com/ocamllabs/ocaml-ctypes">ocaml-ctypes</a> to build inverted stubs for MacOS X libraries for remote forwarding.</li>
  <li>Magnus Sjekgstad started work on OCaml bindings to the <a href="https://github.com/MagnusS/ocaml-utun">utun</a> device.</li>
  <li>Gemma Gordon worked on the Merlin editor <a href="https://github.com/the-lambda-church/merlin/projects/1">project roadmap</a> and <a href="https://github.com/the-lambda-church/merlin/issues">issue labelling</a> workflow.</li>
  <li>David Allsopp reviewed and merged the <a href="https://github.com/ocaml/ocaml/pull/866">PR</a> related to merging build systems in the stdlib directory.</li>
</ul>

<p><em>Thanks to the people who provided updates on their work, and to Anil Madhavapeddy for co-authoring this article.</em></p>

