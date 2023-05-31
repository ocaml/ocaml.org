---
title: Real World OCaml
description: "In the course of my work with OCaml I have traditionally resisted using
  anything other than \u201Cpure\u201D OCaml, and the facilities of the underlying
  OS. So rather than OMake or OASIS I just u\u2026"
url: https://gaius.tech/2013/08/30/real-world-ocaml/
date: 2013-08-30T15:26:15-00:00
preview_image: https://gaiustech.files.wordpress.com/2018/07/cropped-lynx.jpg?w=180
featured:
authors:
- gaius
---

<p>In the course of my work with OCaml I have traditionally resisted using anything other than &ldquo;pure&rdquo; OCaml, and the facilities of the underlying OS. So rather than <a href="http://omake.metaprl.org/index.html">OMake</a> or <a href="http://oasis.forge.ocamlcore.org">OASIS</a> I just used plain, old-fashioned Makefiles. For package management, I relied on <a href="https://wiki.debian.org/Apt">APT</a> on Debian and <a href="http://www.macports.org">MacPorts</a> on OSX. And I avoided both <a href="http://batteries.forge.ocamlcore.org">Batteries</a> and <a href="http://janestreet.github.io">Core</a>. No so much out of a fear of &ldquo;backing the wrong horse&rdquo; but just to make whatever I did as portable and easy to adopt as possible. And also, in the early days, I didn&rsquo;t really <a href="http://stackoverflow.com/q/3889117/447514">know</a> enough to choose anyway, and I wanted to work with the raw language rather than a high-level framework. Sort of like you can <a href="https://gaiustech.wordpress.com/2011/08/03/ocaml-bindings-for-coherence-with-swig/">learn to program MFC without ever really learning C++</a>. </p>
<p>But now <a href="https://realworldocaml.org/">Real World OCaml</a> (which I have on <a href="http://www.amazon.co.uk/Real-World-OCaml-Functional-programming/dp/144932391X">pre-order</a>) is in final draft, and spent some of yesterday getting my Debian and OSX environments <a href="https://realworldocaml.org/beta3/en/html/installation.html">set up for it</a>&dagger;. One quirk I quickly found is that both have <code>pkgconfig</code> as a prereq, which for whatever reason, neither system had already, and that&rsquo;s not mentioned on the page, maybe everyone else has it by default. I have a bunch of OCaml stuff in-flight at the moment &ndash; OCI*ML test suite and new features, some playing with <a href="http://projecteuler.net">Project Euler</a> (solved <del>15</del>16 problems at time of writing) and now working my way through this (trying not to skip to <a href="https://realworldocaml.org/beta3/en/html/foreign-function-interface.html">FFI</a> which is a keen interest of mine, obviously!). That&rsquo;s on top of playing with Oracle 12c, and I have barely started properly playing with C++11 new features yet! </p>
<p>&dagger; Links to the draft of the book will stop working at some point I expect&hellip;</p>

