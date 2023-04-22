---
title: Tarides Engineers to Present at ICFP 2021
description: "This year marks the 25th anniversary of the OCaml Language! It's an
  exciting\ntime for OCaml programmers and enthusiasts. A fun and\u2026"
url: https://tarides.com/blog/2021-08-26-tarides-engineers-to-present-at-icfp-2021
date: 2021-08-26T00:00:00-00:00
preview_image: https://tarides.com/static/3ffd2661c6cd98ccc55ced480bc5e65a/eee8e/camel_party.jpg
featured:
---

<p>This year marks the 25th anniversary of the OCaml Language! It's an exciting
time for OCaml programmers and enthusiasts. A fun and informative way to
celebrate OCaml's birthday is to attend the <a href="https://icfp21.sigplan.org/home/ocaml-2021">26th Annual International
Conference on Functional
Programming</a> (ICFP), held online
this year due to ongoing Covid restrictions. While this is disappointing news
for so many, it's beneficial to those of you outside France because now you
can hear professionals talk about cutting edge technology from the comfort of
your own home.</p>
<p>Tarides engineers, as well as our colleagues at <a href="https://tarides.com/ocamllabs.io">OCaml Labs
Consultancy</a> and <a href="https://segfault.systems/">Segfault Systems</a>,
have some exciting presentations at this year's ICFP! Listen to talks on running
OCaml on multiple cores, generating fuzzing suites, benchmarking, and the
experimental OCaml effects.</p>
<p>You can search the [complete ICFP
Timetable](<a href="https://icfp21.sigplan.org/program/program-icfp-2021/?past=Show">https://icfp21.sigplan.org/program/program-icfp-2021/?past=Show</a>
upcoming events only&amp;date=Fri 27 Aug 2021) for other topics of interest and read
below about our engineers' projects and presentations. Times are listed both in
London (GMT +1) and Paris (GMT +2) for ease of planning. The following talks are
scheduled for Friday, 27 August 2021.</p>
<p>Grab a cup of coffee for our first morning talk at <strong>9am London / 10am Paris</strong>
and learn about <strong>Adapting the OCaml Ecosystem for Multicore OCaml.</strong> With the
soon-to-be released OCaml 5.0, there will be support for Shared-Memory
Parallelism. There&rsquo;s increasing interest in the community to port existing
libraries to Multicore, so this talk will cover the arrival of Multicore and
what that means to the OCaml ecosystem. Our engineers will highlight existing
tools and provide methods for a smooth transition, so viewers can benefit from
Multicore parallelism. They'll also share some insights from their experience
porting existing libraries to Multicore OCaml.</p>
<p>Read more about this topic on todays' post at <a href="https://segfault.systems/blog/2021/adapting-to-multicore/">Segfault
Systems</a>, written by
one of tomorrow's presenters, <a href="https://icfp21.sigplan.org/profile/sudhaparimala">Sudha
Parimala</a> of Segfault Systems.
Joining Sudha for the presentation are <a href="https://icfp21.sigplan.org/profile/enguerranddecorne1">Enguerrand
Decorne</a> (Tarides),
<a href="https://icfp21.sigplan.org/profile/sadiqjaffer">Sadiq Jaffer</a> (Opsian and OCaml
Labs Consultancy), <a href="https://icfp21.sigplan.org/profile/tomkelly">Tom Kelly</a>
(OCaml Labs Consultancy), and <a href="https://icfp21.sigplan.org/profile/kcsivaramakrishnan">KC
Sivaramakrishnan</a> of IIT
Madras.</p>
<p>Next up is <strong>Leveraging Formal Specifications to Generate Fuzzing Suites</strong> at
<strong>11:10 London / 12:10 Paris,</strong> presented by Tarides's own <a href="https://icfp21.sigplan.org/profile/nicolasosborne">Nicolas
Osborne</a> and <a href="https://icfp21.sigplan.org/profile/clementpascutto">Cl&eacute;ment
Pascutto</a>. They'll discuss
how developers typically first have to capture the semantics they want when
checking a library and then write the code implementing these tests and find
relevant test cases that expose possible misbehaviours. Through their work,
they'll present a tool that automatically takes care of those last two steps by
automatically generating fuzz testing suites from OCaml interfaces annotated
with formal behavioural specifications. They'll also show some ongoing
experiments on fuzzing capabilities and limitations applied to real-world
libraries.</p>
<p>Next up is our talk on <strong>Continuous Benchmarking for
OCaml Projects</strong> at <strong>12:30 London / 13:30 Paris</strong>. Regular CI systems are
optimised for workloads that do not require stable performance over time, which
makes them unsuitable for running performance benchmarks. Tarides engineers
<a href="https://icfp21.sigplan.org/profile/gargisharma">Gargi Sharma</a>, <a href="https://icfp21.sigplan.org/profile/rizoisrof">Rizo
Isrof</a>, and <a href="https://icfp21.sigplan.org/profile/magnusskjegstad">Magnus
Skjegstad</a> will discuss how
<code>current-bench</code> provides a predictable environment for performance benchmarks
and a UI for analysing results over time. Similar to a CI system it runs on pull
requests and branches allowing performance to be analysed and compared, and it
can currently be enabled on as an app on GitHub repositories with zero
configuration. Several public repositories already run <code>current-bench</code>,
including <a href="https://github.com/mirage/irmin">Irmin</a> and
<a href="https://github.com/ocaml/dune">Dune</a>, and they plan to enable it on more
projects in the future. <a href="https://tarides.com/blog/2021-08-26-benchmarking-ocaml-projects-with-current-bench">Read Gargi's recent blog post for more information on
benchmarking</a>.</p>
<p>In this presentation, they will give a technical overview of <code>current-bench</code>, showing how results are collected and analysed, requirements for using it, and how they built the infrastructure for stable benchmarks. They'll also cover some future work that will allow more OCaml projects to run <code>current-bench</code>.</p>
<p>Immediately after the Benchmarking talk, catch <strong>A Multiverse of Glorious Documentation</strong>
scheduled at <strong>12:50 London / 13:50 Paris.</strong> <a href="https://icfp21.sigplan.org/profile/lucaspluvinage1">Lucas
Pluvinage</a> of Tarides and
<a href="https://icfp21.sigplan.org/profile/jonathanludlam">Jonathan Ludlam</a> of OCaml
Labs Consultancy will discuss the process of generating documentation for every
version of every package that can be built from the Opam repository and present
it as a single coherent website that's continuously updated as new packages are
released and old packages are updated. They will address the challenges of
caching, handling different compiler versions, and incompatible libraries. The
process has been implemented as an OCurrent pipeline named <code>ocaml-docs-ci</code> and
is already available on Github. It has been used to produce the documentation of
more than 10,000 package versions, generating 2.5M HTML pages. That's 38GB of
artifacts!</p>
<p>After a relaxing lunch, come back for <strong>Experiences with Effects</strong> at <strong>15:30
London / 16:30 Paris</strong>. Join OCaml Labs and Tarides engineers <a href="https://icfp21.sigplan.org/profile/thomasleonard">Thomas
Leonard</a>, <a href="https://icfp21.sigplan.org/profile/craigferguson">Craig
Ferguson</a>, <a href="https://icfp21.sigplan.org/profile/patrickferris">Patrick
Ferris</a>, <a href="https://icfp21.sigplan.org/profile/sadiqjaffer">Sadiq
Jaffer</a>, <a href="https://icfp21.sigplan.org/profile/tomkelly">Tom
Kelly</a>, <a href="https://icfp21.sigplan.org/profile/kcsivaramakrishnan">KC
Sivaramakrishnan</a>, and
<a href="https://icfp21.sigplan.org/profile/anilmadhavapeddy">Anil Madhavapeddy</a> as they
talk about an exciting, experimental branch of Multicore OCaml that adds support
for effect handlers. In this presentation, they'll discuss their experiences
with effects, both from converting existing code and from writing new code. They
discovered that converting the Angstrom parser from a callback style to effects
greatly simplified the code while also improving performance and reducing
allocations. Their <a href="https://github.com/ocaml-multicore/eio">experimental Eio
library</a> uses effects that allows
writing concurrent code in direct style, without the need for monads (as found
in Lwt or Async).</p>
<p>Enjoy a full day of OCaml innovation and get to know some of our talented
engineers better by joining Tarides, OCaml Labs, and Segfault Systems at ICFP on
Friday, 27 August 2021. See you there!</p>
