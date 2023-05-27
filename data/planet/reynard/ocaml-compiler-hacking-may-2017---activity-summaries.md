---
title: OCaml Compiler Hacking May 2017 - Activity Summaries
description:
url: http://reynard.io/2017/05/19/CompHackingRoundup.html
date: 2017-05-19T00:00:00-00:00
preview_image:
featured:
authors:
- reynard
---

<p>Thanks to everyone who joined us for OCaml Compiler Hacking in the (incredibly warm!) Old Library at Pembroke College this week.</p>

<p>Prior to the event, we attempted a temporary update of the <a href="https://github.com/ocamllabs/compiler-hacking/wiki/Things-to-work-on">&ldquo;Things to Work On&rdquo;</a> wiki page, and added some projects needing attention (thank you to Mark Shinwell, David Allsopp and Anil Madhavapeddy). We will go through the list in more detail this month and update the remaining items. If you have any suggestions for compiler projects, please join the discussion on the <a href="http://lists.ocaml.org/listinfo/cam-compiler-hacking">mailing list</a>, or in the <a href="https://discuss.ocaml.org/t/ocaml-compiler-hacking-event/140">OCaml Discourse Forum</a>.</p>

<p>
<img src="http://reynard.io/images/CompHackMay17.jpg" alt="Stage 1" width="200"/>
</p>

<h3>Newcomers</h3>

<p>Christian Lindig brought some of his team from Citrix to discuss OCaml and Opam with the compiler developers from OCaml Labs and Jane Street. XenServer is Citrix&rsquo;s virtualisation platform based on Xen and CentOS. Christian described how their internal set-up at Citrix means they still need to rely on RPM in some areas, but how switching some projects over to Opam has improved their workflow, and overall has been a huge success. The toolstack layer of the XenServer platform is implemented in OCaml, with code available as Opam packages in their <a href="https://github.com/xapi-project/xs-opam">own Opam repository</a>. Other code is available as RPM packages which are released as open source, but are not part of the repository.</p>

<p>Fred is new to OCaml, and spent time reading through the <a href="https://github.com/ocamllabs/compiler-hacking/wiki/Getting-started">&ldquo;Getting Started&rdquo;</a> page, and started looking at the <a href="https://caml.inria.fr/mantis/view.php?id=6504">CAML-DEBUG-SOCKET documentation</a> item in the Mantis <a href="https://caml.inria.fr/mantis/view_all_bug_page.php">Junior Jobs</a> list. It&rsquo;s always a great opportunity to work with newcomers to the language, and Fred commented, &ldquo;The atmosphere there made it a great learning environment for a beginner like me, and so I&rsquo;m afraid I was getting constantly distracted by new topics I was hearing about and asking questions and pretty much going on every possible tangent that my curiosity led me&rdquo;.</p>

<p>Gabor and Marcello started working on cleaning up their <a href="https://github.com/xapi-project/xs-opam">own Opam packages</a> in the <a href="https://github.com/ocaml/opam">main Opam repository</a> and <a href="https://github.com/ocaml/opam-repository/pull/9206">submitted a PR</a> to remove the relevant outdated packages. Another PR is likely to follow, to update packages used by other members of the OCaml community to their most recent versions.</p>

<p>Edwin isn&rsquo;t new to the OCaml compiler - last year he wrote a <a href="https://github.com/ocaml/ocaml/pull/916">tool</a> to update the compiler documentation - but decided to dive into OCaml Multicore by tackling an issue to enable the <code class="highlighter-rouge">Domain.join</code> primitive, and submitted a <a href="https://github.com/ocamllabs/ocaml-multicore/pull/130">PR</a> for the implementation.</p>

<h3>Compiler Projects</h3>

<p>KC and Mark spent some time working on DWARF support for handlers in Multicore, an issue which is scheduled for <a href="https://github.com/ocamllabs/ocaml-multicore/projects/1#card-2897910">Multicore Alpha</a>. They had some initial success and have a prototype implementation which backtraces through the handler stack. This builds on <a href="http://ocamllabs.io/doc/dwarf-debugging.html">previous work</a> that enabled the native-code OCaml compiler to emit DWARF debugging information.</p>

<p>Stephen and Jeremy spent most of the evening discussing a workshop submission based on subtyping witnesses, and the &ldquo;hairy bits of OCaml typechecking&rdquo; related to <a href="https://github.com/ocaml/ocaml/pull/556">PR#556</a> and <a href="https://github.com/ocaml/ocaml/pull/1142">#1142</a>.</p>

<h3>Bug Fixing</h3>

<p>David and Mark worked on closing PRs, including one to tidy up and fix parsing by <a href="https://github.com/ocaml/ocaml/pull/1012">ocamlyacc code</a> - In David&rsquo;s words &ldquo;ocamlyacc is due to be retired soon in favour of using Menhir directly in the compiler codebase, but it&rsquo;s still nice for the old dear to get a little love before put out to pasture&rdquo;. Some of the GitHub PRs merged that evening had subsequent issues with Inria&rsquo;s CI, so David followed them up on Wednesday morning.</p>

<p>Mark also started looking at <a href="https://github.com/ocaml/ocaml/pull/1063">PR#1063</a> to fix dynlinking, but it looks like it will require further investigation since an important part of functionality is currently missing.</p>

<h3>Other projects</h3>

<p>Liang continued to increase the flexibility of the OCaml numerical library, <a href="https://github.com/ryanrhymes/owl">Owl</a>, by extending the Algorithmic Differentiation module (<a href="https://github.com/ryanrhymes/owl/wiki/Tutorial:-Algorithmic-Differentiation">Algodiff</a>) to support N-dimensional array. The AD module calculates the exact derivative of a given function, and is especially useful for fast prototyping in machine learning research. Owl has quite a few users now, and it&rsquo;s great to see contributions from them, and see development influenced by them.</p>

<p>Taka continued work on benchmarking MirageOS performance by writing a script to deploy multiple pairs of unikernels to conduct parallel throughput measurements using <a href="https://github.com/TImada/mirage_iperf">iperf</a> automatically. He and KC also discussed the idea of doing batched I/O operations using effect handlers to minimise the context switching between VM and Dom0.</p>

