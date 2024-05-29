---
title: 2017 at OCamlPro
description: "Since 2017 is just over, now is probably the best time to review what
  happened during this hectic year at OCamlPro\u2026 Here are our big 2017 achievements,
  in the world of blockchains (the Liquidity smart contract language, Tezos and the
  Tezos ICO etc.), of OCaml (with OPAM 2, flambda 2 etc.), and of ..."
url: https://ocamlpro.com/blog/2018_01_15_2017_at_ocamlpro
date: 2018-01-15T13:19:46-00:00
preview_image: URL_de_votre_image
authors:
- "\n    Muriel\n  "
source:
---

<p>Since 2017 is just over, now is probably the best time to review what happened during this hectic year at OCamlPro&hellip; Here are our big 2017 achievements, in the world of <a href="https://ocamlpro.com/blog/feed#blockchain"><strong>blockchains</strong></a> <em>(the <a href="https://ocamlpro.com/blog/feed#liquidity">Liquidity</a> smart contract language, <a href="https://ocamlpro.com/blog/feed#tezos">Tezos</a> and the Tezos ICO etc.)</em>, of <strong>OCaml</strong> (with <em><a href="https://ocamlpro.com/blog/feed#opam">OPAM</a> 2</em>, <a href="https://ocamlpro.com/blog/feed#flambda"><em>flambda</em></a> 2 etc.), and of <a href="https://ocamlpro.com/blog/feed#formalmethods"><strong>formal methods</strong></a> (<a href="https://ocamlpro.com/blog/feed#altergo"><em>Alt-Ergo</em></a> etc.)</p>
<h2>In the World of Blockchains</h2>
<h3>The Liquidity Language for smart contracts</h3>
<p><em>Work of Alain Mebsout, Fabrice Le Fessant, &Ccedil;agdas Bozman, Micha&euml;l Laporte</em></p>
<p><img src="https://ocamlpro.com/blog/assets/img/logo_liquidity_small.png" alt="Liquidity"/></p>
<p>OCamlPro develops <a href="https://www.liquidity-lang.org/">Liquidity</a>, a high level smart contract language for Tezos. <a></a>Liquidity is a human-readable language, purely functional, statically-typed, whose syntax is very close to the OCaml syntax. Programs can be compiled to the stack-based language (Michelson) of the Tezos blockchain.</p>
<p>To garner interest and adoption, we developed an online editor called &quot;<a href="https://www.liquidity-lang.org/edit">Try Liquidity</a>&quot;. Smart-contract developers can design contracts interactively,  directly in the browser, compile them to Michelson, run them and deploy them on the alphanet network of Tezos.</p>
<p>Future plans include a full-fledged web-based IDE for Liquidity. Worth mentioning is a neat feature of Liquidity: decompiling a Michelson program back to its Liquidity version, whether it was generated from Liquidity code or not. In practice, this allows to easily read somewhat obfuscated contracts already deployed on the blockchain.</p>
<h3>Tezos and the Tezos ICO</h3>
<p><em>Work of Gr&eacute;goire Henry, Benjamin Canou, &Ccedil;agdas Bozman, Alain Mebsout, Michael Laporte, Mohamed Iguernlala, Guillem Rieu, Vincent Bernardoff (for DLS) and at times all the OCamlPro team in animated and joyful brainstorms.</em></p>
<p><img src="https://ocamlpro.com/blog/assets/img/logo_tezos_tz.png" alt="tezos"/></p>
<p>Since 2014, the OCamlPro team had been co-designing the Tezos prototype with Arthur Breitman based on Arthur's <a href="https://www.tezos.com/static/papers/white_paper.pdf">White Paper</a>, and had undertaken the implementation of the Tezos node and client. A technical prowess and design achievement we have been proud of. In 2017, we developed the infrastructure for the Tezos ICO (Initial Coin Offering) from the ground up, encompassing the web app (back-end and front-end), the Ethereum and Bitcoin (p2sh) multi-signature contracts, as well as the hardware Ledger based process for transferring funds. The ICO, conducted in collaboration with Arthur, was a resounding success &mdash; the equivalent of 230 million dollars (in ETH and BTC) at the time were raised for the Tezos Foundation!</p>
<p><a></a><em>This work was allowed thanks to Arthur Breitman and DLS's funding.</em></p>
<h2>In the World of OCaml</h2>
<h3>Towards OPAM 2.0, the OCaml Package manager</h3>
<p><img src="https://ocamlpro.com/blog/assets/img/logo_opam_300_261.png" alt="opam"/></p>
<p><a href="https://opam.ocaml.org/blog/opam-2-0-beta5/">OPAM</a> was born at Inria/OCamlPro with Frederic, Thomas and Louis, and is still maintained here at OCamlPro. Now thanks to Louis Gesbert's thorough efforts and the OCaml Labs contribution, OPAM 2.0 is coming !</p>
<ul>
<li>opam is now compiled with a built-in solver, improving the portability, ease of access and user experience (<code>aspcud</code> no longer a requirement)
</li>
<li>new workflows for developers have been designed, including convenient ways to test and install local sources, more reliable ways to share development setups
</li>
<li>the general system has seen a large number of robustness and expressivity improvements, like <a href="https://opam.ocaml.org/blog/opam-extended-dependencies/">extended dependencies</a>
</li>
<li>it also provides better caching, and many hooks enabling, among others, setups with sandboxed builds, binary artifacts caching, or end-to-end package signature verification.
</li>
</ul>
<p><a></a>More details: on <a href="https://opam.ocaml.org/blog">https://opam.ocaml.org/blog</a> and releases on <a href="https://github.com/ocaml/opam/releases">https://github.com/ocaml/opam/releases</a></p>
<p><em>This work is allowed thanks to JaneStreet's funding.</em></p>
<h3>Flambda Compilation</h3>
<p><em>Work of Pierre Chambart, Vincent Laviron</em></p>
<p><img src="https://ocamlpro.com/blog/assets/img/logo_ocaml.png" alt="flambda"/></p>
<p>Pierre and Vincent's considerable work on Flambda 2 (the optimizing intermediate representation of the OCaml compiler &ndash; on which inlining occurs), in close cooperation with JaneStreet's team (Mark, Leo and Xavier) aims at overcoming some of flambda's limitations. This huge refactoring will help make OCaml code more maintainable, improving its theoretical grounds. Internal types are clearer, more concise, and possible control flow transformations are more flexible. Overall a precious outcome for industrial users.</p>
<p><a></a><em>This work is allowed thanks to JaneStreet's funding.</em></p>
<h3>OCaml for ia64-HPUX</h3>
<p>In 2017, OCamlPro also worked on porting OCaml on HPUX-ia64. This came from a request of CryptoSense, a French startup working on an OCaml tool to secure cryptographic protocols. OCaml had a port on Linux-ia64, that was deprecated before 4.00.0 and even before, a port on HPUX, but not ia64. So, we expected the easiest part would be to get the bytecode version running, and the hardest part to get access to an HPUX-ia64 computer: it was quite the opposite, HPUX is an awkward system where most tools (shell, make, etc.) have uncommon behaviors, which made even compiling a bytecode version difficult. On the contrary, it was actually easy to get access to a low-power virtual machine of HPUX-ia64 on a monthly basis. Also, we found a few bugs in the former OCaml ia64 backend, mostly caused by the scheduler, since ia64 uses explicit instruction parallelism. Debugging such code was quite a challenge, as instructions were often re-ordered and interleaved. Finally, after a few weeks of work, we got both the bytecode and native code versions running, with only a few limitations.</p>
<p><em>This work was mandated by CryptoSense.</em></p>
<h3>The style-checker Typerex-lint</h3>
<p><em>Work of &Ccedil;agdas Bozman, Michael Laporte and Cl&eacute;ment Dluzniewski.</em></p>
<p>In 2017, typerex-lint has been improved and extended. Typerex-lint is a style-checker to analyze the sources of OCaml programs, and can be extended using plugins. It allows to automatically check the conformance of a code base to some coding rules. We added some analysis to look for code that doesn't comply with the recommendations made by the SecurOCaml project members. We also made an interactive web output that provides an easy way to navigate in typerex-lint results.</p>
<h3>Build systems and tools</h3>
<p><em>Work of Fabrice Le Fessant</em></p>
<p>Every year in the OCaml world, a new build tool appears. 2017 was not different, with the rise of jbuild/dune. jbuild came with some very nice features, some of which were already in our home-made build tool, ocp-build, like the ability to build multiple packages at once in a composable way, some other ones were new, like the ability to build multiple versions of the package in one run or the wrapping of libraries using module aliases. We have started to incorporate some of these features in ocp-build. Nevertheless, from our point of view, the two tools belong to two different families: jbuild/dune belongs to the &quot;implicit&quot; family, like ocamlbuild and oasis, with minimal project description; ocp-build belongs to the &quot;explicit&quot; family, like make and omake. We prefer the explicit family, because the build file acts as a description of the project, an entry point to understand the project and the modules. Also, we have kept working on improving the project description language for ocp-build, something that we think is of utmost importance. Latest release: ocp-build 1.99.20-beta.</p>
<h3><a></a><a></a>Other contributions and softwares</h3>
<ul>
<li>OCaml bugfixes by Pierre Chambart, Vincent Laviron, and other members of the team.
</li>
<li>The ocp-analyzer prototype by Vincent Laviron
</li>
</ul>
<h2>In the World of Formal Methods</h2>
<h3>Alt-Ergo</h3>
<p><em>By Mohamed Iguernlala</em></p>
<p><img src="https://ocamlpro.com/blog/assets/img/logo_alt_ergo.png" alt="alt-ergo"/></p>
<p>For <a href="https://alt-ergo.ocamlpro.com/">Alt-Ergo</a>, 2017 was the year of floating-point arithmetic reasoning. Indeed, in addition to the publication of our <a href="https://hal.inria.fr/hal-01522770/document">results</a> at the 29th International Conference on Computer Aided Verification (CAV), Jul 2017, we polished the prototype we started in 2016 and integrated it in the main branch. This is a joint work with Sylvain Conchon (Paris-Saclay University) and Guillaume Melquiond (Inria Lab) in the context of the <a href="https://soprano-project.fr/index.html">SOPRANO ANR Project</a>. Another big piece of work in 2017 consisted in investigating a better integration of an efficient CDCL-based SAT solver in Alt-Ergo. In fact, although modern CDCL SAT solvers are very fast, their interaction with the decision procedures and quantifiers instantiation should be finely tuned to get good results in the context of Satisfiability Modulo Theories. This new solver should be integrated into Alt-Ergo in the next few weeks. This work has been done in the context of the <a href="https://www.clearsy.com/projet-lchip-architecture-double-processeur-premier-starter-kit/">LCHIP FUI Project</a>.</p>
<p>We also released a new major version of Alt-Ergo (2.0.0) with a modification in the licensing scheme. Alt-Ergo@OCamlPro's development repository is now made public. This will allow users to get updates and bugfixes as soon as possible.</p>
<h3>Towards a formalized type system for OCaml</h3>
<ul>
<li><em>Work of Pierrick Couderc, Gr&eacute;goire Henry, Fabrice Le Fessant and Michel Mauny (Inria Paris)</em>
</li>
</ul>
<p>OCaml is known for its rich type system and strong type inference, unfortunately such complex type engine is prone to errors, and it can be hard to come up with clear idea of how typing works for some features of the language. For 3 years now, OCamlPro has been working on formalizing a subset of this type system and implementing a <a href="https://github.com/OCamlPro/ocp-typechecker">type checker</a> derived from this formalization. The idea behind this work is to help the compiler developers ensure some form of correctness of the inference. This type checker takes a Typedtree, the intermediate representation resulting from the inference, and checks its consistency. Put differently, this tool checks that each annotated node from the Typedtree can be indeed given such a type according to the context, its form and its sub-expressions. In practice, we could check and catch some known bugs resulting from unsound programs that were accepted by the compiler.</p>
<p>This type checker is only available for OCaml 4.02 for the moment, and the document describing this formalized type system will be available shortly in a PhD thesis, by Pierrick Couderc.</p>
<h2>Around the World</h2>
<p>OCamlPro's team members attended many events throughout the world:</p>
<ul>
<li>The <a href="https://conf.researchr.org/home/icfp-2017">ICFP'2017</a> (Oxford)
</li>
<li>The <a href="https://jfla.inria.fr/2017/">JFLA'2017</a> (Gourette, Pyr&eacute;n&eacute;es)
</li>
<li>The <a href="https://cavconference.org/2017/">CAV'2017</a> (29th International Conference on Computer Aided Verification, Heidelberg)
</li>
<li>The <a href="https://www.opensourcesummit.paris/Bienvenue_150.html">POSS'2017</a> (Paris)
</li>
</ul>
<p>As a member committed to the OCaml ecosystem's animation, we've organized OCaml meetups too (see the famous <a href="https://www.meetup.com/fr-FR/ocaml-paris/">OUPS</a> meetups in Paris!).</p>
<h2>A few hints about what's ahead for OCamlPro</h2>
<p>Let's keep up the good work!</p>

