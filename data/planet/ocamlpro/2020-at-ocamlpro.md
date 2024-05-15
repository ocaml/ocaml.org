---
title: 2020 at OCamlPro
description: 2020 at OCamlPro OCamlPro was created in 2011 to advocate the adoption
  of the OCaml language and formal methods in general in the industry. While building
  a team of highly-skilled engineers, we navigated through our expertise domains,
  delivering works on the OCaml language and tooling, training comp...
url: https://ocamlpro.com/blog/2021_02_02_2020_at_ocamlpro
date: 2021-02-02T13:19:46-00:00
preview_image: URL_de_votre_image
authors:
- "\n    Muriel\n  "
source:
---

<p><img src="https://ocamlpro.com/blog/assets/img/logo_2020_at_ocamlpro.png" alt="2020 at OCamlPro"/></p>
<p>OCamlPro was created in 2011 to advocate the adoption of the OCaml language and formal methods in general in the industry. While building a team of highly-skilled engineers, we navigated through our expertise domains, delivering works on the OCaml language and tooling, training companies to the use of strongly-typed languages like OCaml but also Rust, tackling formal verification challenges with formal methods, maintaining <a href="https://alt-ergo.ocamlpro.com">the SMT solver Alt-Ergo</a>, designing languages and tools for smart contracts and blockchains, and more!</p>
<p>In this article, as every year (see <a href="https://ocamlpro.com/blog/2020_02_04_2019_at_ocamlpro">2019 at OCamlPro</a> for last year's post), we review some of the work we did during 2020, in many different worlds.</p>
<p></p><div>
<strong>Table of contents</strong>
<p> <a href="https://ocamlpro.com/blog/feed#ocaml">In the World of OCaml</a></p>
<ul>
<li><a href="https://ocamlpro.com/blog/feed#flambda">Flambda &amp; Compilation Team</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#opam">Opam, the OCaml Package Manager</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#community">Encouraging OCaml Adoption: Trainings and Resources for OCaml</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#tooling">Open Source Tooling and Libraries for OCaml</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#foundation">Supporting the OCaml Software Foundation</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#events">Events</a>
</li>
</ul>
<p><a href="https://ocamlpro.com/blog/feed#formal-methods">In the World of Formal Methods</a></p>
<ul>
<li><a href="https://ocamlpro.com/blog/feed#alt-ergo">Alt-Ergo Development</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#club">Alt-Ergo Users&rsquo; Club and R&amp;D Projects</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#roadmap">Alt-Ergo&rsquo;s Roadmap</a>
</li>
</ul>
<p><a href="https://ocamlpro.com/blog/feed#rust">In the World of Rust</a></p>
<p><a href="https://ocamlpro.com/blog/feed#blockchains">In the World of Blockchain Languages</a>
</p></div>
<p>We warmly thank all our partners, clients and friends for their support and collaboration during this peculiar year!</p>
<p>The first lockdown was a surprise and we took advantage of this special moment to go over our past contributions and sum it up in a timeline that gives an overview of the key events that made OCamlPro over the years. The <a href="https://timeline.ocamlpro.com">timeline format</a> is amazing to reconnect with our history and to take stock in our accomplishments.</p>
<p>Now this will turn into a generic timeline edition tool on the Web, stay tuned if you are interested in our internal project to be available to the general public! If you think that a timeline would fit your needs and audience, <a href="https://timelines.cc/">we designed a simplistic tool</a>, tailored for users who want complete control over their data.</p>
<h2>
<a class="anchor"></a>In the World of OCaml<a href="https://ocamlpro.com/blog/feed#ocaml">&#9875;</a>
          </h2>
<h3>
<a class="anchor"></a>Flambda &amp; Compilation Team<a href="https://ocamlpro.com/blog/feed#flambda">&#9875;</a>
          </h3>
<p><em>Work by Pierre Chambart, Vincent Laviron, Guillaume Bury, Pierrick Couderc and Louis Gesbert</em></p>
<p><img src="https://ocamlpro.com/blog/assets/img/picture_cpu.jpg" alt="flambda"/></p>
<p>OCamlPro is proud to be working on Flambda2, an ambitious work on an OCaml optimizing compiler, in close collaboration with Mark Shinwell from our long-term partner and client Jane Street. Flambda focuses on reducing the runtime cost of abstractions and removing as many short-lived allocations as possible. In 2020, the Flambda team worked on a considerable number of fixes and improvements, transforming Flambda2 from an experimental prototype to a version ready for testing in production!</p>
<p>This year also marked the conclusion of our work on the pack rehabilitation (see our two recent posts <a href="https://ocamlpro.com/blog/2020_09_24_rehabilitating_packs_using_functors_and_recursivity_part_1">Part 1</a> and <a href="https://ocamlpro.com/blog/2020_09_30_rehabilitating_packs_using_functors_and_recursivity_part_2">Part 2</a>, and a much simpler <a href="https://ocamlpro.com/blog/2011_08_10_packing_and_functors">Version</a> in 2011). Our work aimed to give them a new youth and utility by adding the possibility to generate functors or recursive packs. This improvement allows programmers to define big functors, functors that are split among multiple files, resulting in what we can view as a way to implement some form of parameterized libraries.</p>
<p><em>This work is allowed thanks to Jane Street&rsquo;s funding.</em></p>
<h3>
<a class="anchor"></a>Opam, the OCaml Package Manager<a href="https://ocamlpro.com/blog/feed#opam">&#9875;</a>
          </h3>
<p><em>Work by Raja Boujbel, Louis Gesbert and Thomas Blanc</em></p>
<p><img src="https://ocamlpro.com/blog/assets/img/picture_containers.jpg" alt="opam"/></p>
<p><a href="https://opam.ocaml.org/">Opam</a> is the OCaml source-based package manager. The first specification draft was written <a href="https://opam.ocaml.org/about.html">in early 2012</a> and went on to become OCaml&rsquo;s official package manager &mdash; though it may be used for other languages and projects, since Opam is language-agnostic! If you need to install, upgrade and manage your compiler(s), tools and libraries easily, Opam is meant for you. It supports multiple simultaneous compiler installations, flexible package constraints, and a Git-friendly development workflow.</p>
<p><a href="https://github.com/ocaml/opam/releases">Our 2020 work on Opam</a> led to the release of two versions of opam 2.0 with small fixes, and the release of three alphas and two betas of Opam 2.1!</p>
<p>Opam 2.1.0 will soon go to release candidate and will introduce a seamless integration of depexts (system dependencies handling), dependency locking, pinning sub-directories, invariant-based definition for Opam switches, the configuration of Opam from the command-line without the need for a manual edition of the configuration files, and the CLI versioning for better handling of CLI evolutions.</p>
<p><em>This work is greatly helped by Jane Street&rsquo;s funding and support.</em></p>
<h3>
<a class="anchor"></a>Encouraging OCaml Adoption: Trainings and Resources for OCaml<a href="https://ocamlpro.com/blog/feed#community">&#9875;</a>
          </h3>
<p><em>Work by Pierre Chambart, Vincent Laviron, Adrien Champion, Mattias, Louis Gesbert and Thomas Blanc</em></p>
<p><img src="https://ocamlpro.com/blog/assets/img/picture_ocaml_library.jpg" alt="trainings"/></p>
<p>OCamlPro is also a training centre. We organise yearly training sessions for programmers from multiple companies in our offices: from OCaml to OCaml tooling to Rust! We can also design custom and on-site trainings to meet specific needs.</p>
<p>We released a brand new version of TryOCaml, a tool born from our work on <a href="https://ocaml-sf.org/learn-ocaml/">Learn-OCaml</a>!
<a href="https://try.ocamlpro.com">Try OCaml</a> has been highly praised by professors at the beginning of the Covid lockdown. Even if it can be used as a personal sandbox, it&rsquo;s also possible to adapt its usage for classes. TryOCaml is a hassle-free tool that lowers significantly the barriers to start coding in OCaml, as no installation is required.</p>
<p>We regularly release cheat sheets for developers: in 2020, we shared <a href="https://ocamlpro.com/blog/2020_01_10_opam_2.0_cheat_sheet">the long-awaited Opam 2.0 cheat sheet</a>, with a new theme! In just two pages, you&rsquo;ll have in one place the everyday commands you need as an Opam user. We also shine some light on unsung features which may just change your coding life.</p>
<p>2020 was also an important year for the OCaml language itself: we were pleased to welcome <a href="https://ocaml.org/releases/4.10.0.html">OCaml 4.10</a>! One of the highlights of the release was the &ldquo;Best-fit&rdquo; Garbage Collector Strategy. We had <a href="https://ocamlpro.com/blog/2020_03_23_in_depth_look_at_best_fit_gc">an in-depth look</a> at this exciting change.</p>
<p><em>This work is self-funded by OCamlPro as part of its effort to ease the adoption of OCaml.</em></p>
<h3>
<a class="anchor"></a>Open Source Tooling and Libraries for OCaml<a href="https://ocamlpro.com/blog/feed#tooling">&#9875;</a>
          </h3>
<p><em>Work by Fabrice Le Fessant, L&eacute;o Andr&egrave;s and David Declerck</em></p>
<p><img src="https://ocamlpro.com/blog/assets/img/picture_tools.jpg" alt="tooling"/></p>
<p>OCamlPro has a long history of developing open source tooling and libraries for the community. 2020 was no exception!</p>
<p><a href="https://github.com/OCamlPro/drom">drom</a> is a simple tool to create new OCaml projects that will use best OCaml practices, i.e. Opam, Dune and tests. Its goal is to provide a cargo-like user experience and helps onboarding new developers in the community. drom is available in the official opam repository.</p>
<p><a href="https://github.com/OCamlPro/directories">directories</a> is a new OCaml Library that provides configuration, cache and data paths (and more!). The library follows the suitable conventions on Linux, MacOS and Windows.</p>
<p><a href="https://ocamlpro.github.io/opam-bin/">opam-bin</a> is a framework to create and use binary packages with Opam. It enables you to create, use and share binary packages easily with opam, and to create as many local switches as you want spending no time, no disk space! If you often use Opam, opam-bin is a must-have!</p>
<p>We also released a number of libraries, focused on making things easy for developers&hellip; so we named them with an <code>ez_</code> prefix: <a href="https://github.com/OCamlPro/ez_cmdliner">ez_cmdliner</a> provides an Arg-like interface for cmdliner,  <a href="https://github.com/OCamlPro/ez_file">ez_file</a> provides simple functions to read and write files, <a href="https://github.com/OCamlPro/ez_subst">ez_subst</a> provides easily configurable string substitutions for shell-like variable syntax, <a href="https://github.com/OCamlPro/ez_config">ez_config</a> provides abstract options stored in configuration files with an OCaml syntax. There are also a lot of <a href="https://github.com/OCamlPro?q=ezjs">ezjs-*</a> libraries, that are bindings to Javascript libraries that we used in some of our js_of_ocaml projects.</p>
<p>*This work was self-funded by OCamlPro as part of its effort to improve the OCaml ecosystem.*</p>
<h3>
<a class="anchor"></a>Supporting the OCaml Software Foundation<a href="https://ocamlpro.com/blog/feed#foundation">&#9875;</a>
          </h3>
<p>OCamlPro was proud and happy to initiate the <a href="https://www.dropbox.com/s/omba1d8vhljnrcn/OCaml-user-survey-2020.pdf?dl=0">OCaml User Survey 2020</a> as part of the mission of the [OCaml Software Foundation]. The goal of the survey was to better understand the community and its needs. The final results have not yet been published by the Foundation, we are looking forward to reading them soon!</p>
<h3>
<a class="anchor"></a>Events<a href="https://ocamlpro.com/blog/feed#events">&#9875;</a>
          </h3>
<p>Though the year took its toll on our usual tour of the world conferences and events, OCamlPro members still took part in the annual 72-hour team programming competition organised by the International Conference on Functional Programming (ICFP). Our joint team &ldquo;crapo on acid&rdquo; went <a href="https://icfpcontest2020.github.io/#/scoreboard%23final">through the final</a>!</p>
<h2>
<a class="anchor"></a>In the World of Formal Methods<a href="https://ocamlpro.com/blog/feed#formal-methods">&#9875;</a>
          </h2>
<ul>
<li><em>Work by Albin Coquereau, Mattias, Sylvain Conchon, Guillaume Bury and Louis Rustenholz</em>
</li>
</ul>
<p><img src="https://ocamlpro.com/blog/assets/img/altergo-meeting.jpeg" alt="formal methods"/></p>
<p><a href="https://ocamlpro.com/blog/2020_06_05_interview_sylvain_conchon_joins_ocamlpro">Sylvain Conchon joined OCamlPro</a> as Formal Methods Chief Scientific Officer in 2020!</p>
<h3>
<a class="anchor"></a>Alt-Ergo Development<a href="https://ocamlpro.com/blog/feed#alt-ergo">&#9875;</a>
          </h3>
<p>OCamlPro develops and maintains <a href="https://alt-ergo.ocamlpro.com/">Alt-Ergo</a>, an automatic solver of mathematical formulas designed for program verification and based on Satisfiability Modulo Theories (SMT). Alt-Ergo was initially created within the <a href="https://vals.lri.fr/">VALS</a> team at <a href="https://www.universite-paris-saclay.fr/en">University of Paris-Saclay</a>.</p>
<p>In 2020, we focused on the maintainability of our solver. The first part of this work was to maintain and fix issues within the already released version. The 2.3.0 (released in 2019) had some issues that needed to be fixed <a href="https://ocamlpro.github.io/alt-ergo/About/changes.html#version-2-3-2-march-23-2020">minor releases</a>.</p>
<p>The second part of the maintainability work on Alt-Ergo contains more major features. All these features were released in the new <a href="https://alt-ergo.ocamlpro.com/#releases">version 2.4.0</a> of Alt-Ergo. The main goal of this release was to focus on the user experience and the documentation. This release also contains bug fixes and many other improvements. Alt-Ergo is on its way towards a new <a href="https://ocamlpro.github.io/alt-ergo/index.html">documentation</a> and in particular a new documentation on its <a href="https://ocamlpro.github.io/alt-ergo/Input_file_formats/Native/index.html">native syntax</a>.</p>
<p>We also tried to improve the command line experience of our tools with the use of the <a href="https://erratique.ch/software/cmdliner">cmdliner library</a> to parse Alt-Ergo options. This library allows us to improve the manpage of our tool. We tried to harmonise the debug messages and to improve all of Alt-Ergo&rsquo;s outputs to make it clearer for the users.</p>
<h3>
<a class="anchor"></a>Alt-Ergo Users&rsquo; Club and R&amp;D Projects<a href="https://ocamlpro.com/blog/feed#club">&#9875;</a>
          </h3>
<p>We thank our partners from the <a href="https://alt-ergo.ocamlpro.com/#club">Alt-Ergo Users&rsquo; Club</a>, Adacore, CEA List, MERCE (Mitsubishi Electric R&amp;D Centre Europe) and Trust-In-Soft, for their trust. Their support allows us to maintain our tool.</p>
<p>The club was launched in 2019 and the second annual meeting of the Alt-Ergo Users&rsquo; Club was held in mid-February 2020. Our annual meeting is the perfect place to review each partner&rsquo;s needs regarding Alt-Ergo. This year, we had the pleasure of receiving our partners to discuss the roadmap for future Alt-Ergo developments and enhancements. If you want to join us for the next meeting (coming soon), contact us!</p>
<p>We also want to thank our partners from the FUI R&amp;D Project LCHIP. Thanks to this project, we were able to add a new major feature in Alt-Ergo: the support for incremental commands (<code>push</code>, <code>pop</code> and <code>check-sat-assuming</code>) from the <a href="https://alt-ergo.ocamlpro.com/#releases">smt-lib2 standard</a>.</p>
<h3>
<a class="anchor"></a>Alt-Ergo&rsquo;s Roadmap<a href="https://ocamlpro.com/blog/feed#roadmap">&#9875;</a>
          </h3>
<p>Some of the work we did in 2020 is not yet available. Thanks to our partner MERCE (Mitsubishi Electric R&amp;D Centre Europe), we worked on the SMT model generation. Alt-Ergo is now (partially) able to output a model in the smt-lib2 format. Thanks to the <a href="http://why3.lri.fr/">Why3 team</a> from University of Paris-Saclay, we hope that this work will be available in the Why3 platform to help users in their program verification efforts.</p>
<p>Another project was launched in 2020 but is still in early development: the complete rework of our Try-Alt-Ergo website with new features such as model generation. Try Alt-Ergo <a href="https://alt-ergo.ocamlpro.com/try.html">current version</a> allows users to use Alt-Ergo directly from their browsers (Firefox, Chromium) without the need of a server for computations.</p>
<p>This work needed a JavaScript compatible version of Alt-Ergo. We have made some work to build our solver in two versions, one compatible with Node.js and another as a webworker. We hope that this work can make it easier to use our SMT solver in web applications.</p>
<p><em>This work is funded in part by the FUI R&amp;D Project LCHIP, MERCE, Adacore and with the support of the <a href="https://alt-ergo.ocamlpro.com/#club">Alt-Ergo Users&rsquo; Club</a>.</em></p>
<h2>
<a class="anchor"></a>In the World of Rust<a href="https://ocamlpro.com/blog/feed#rust">&#9875;</a>
          </h2>
<p><em>Work by Adrien Champion</em></p>
<p><img src="https://ocamlpro.com/blog/assets/img/logo_rust.jpg" alt="rust"/></p>
<p>As OCaml-ians, we naturally saw in the Rust language a beautiful complement to our approach. One opportunity to explore this state-of-the art language has been to pursue our work on ocp-memprof and build <a href="https://github.com/OCamlPro/memthol">Memthol</a>, a visualizer and analyzer to profile OCaml programs. It works on memory dumps containing information about the size and (de)allocation date of part of the allocations performed by some execution of a program.</p>
<p>Between lockdowns, we&rsquo;ve also been able to hold <a href="https://training.ocamlpro.com/">our Rust training</a>. It&rsquo;s designed as a highly-modular vocational course, from 1 to 4 days. The training covers a beginner introduction to Rust&rsquo;s basics features, crucial features and libraries for real-life development and advanced features, all through complex use-cases one would find in real life.</p>
<p><em>This work was self-funded by OCamlPro as part of our exploration of other statically and strongly typed functional languages.</em></p>
<h2>
<a class="anchor"></a>In the World of Blockchain Languages<a href="https://ocamlpro.com/blog/feed#blockchains">&#9875;</a>
          </h2>
<p><em>Work by David Declerck and Steven de Oliveira</em></p>
<p><img src="https://ocamlpro.com/blog/assets/img/logo_blockchain.jpg" alt="Blockchain languages"/></p>
<p>One of our favourite activities is to develop new programming languages, specialized for specific domains, but with nice properties like clear semantics, strong typing, static typing and functional features. In 2020, we applied our skills in the domain of blockchains and smart contracts, with the creation of a new language, Love, and work on a well-known language, Solidity.</p>
<p>In 2020, our blockchain experts released <a href="https://dune.network/docs/dune-node-next/love-doc/introduction.html">Love</a>, a type-safe language with an ML syntax and suited for formal verification. In a few words, Love is designed to be expressive for fast development, efficient in execution time and cheap in storage, and readable in terms of smart contracts auditability. Yet, it has a clear and formal semantics and a strong type system to detect bugs. It allows contracts to use other contracts as libraries, and to call viewers on other contracts. Contracts developed in Love can also be formally verified.</p>
<p>We also released a <a href="https://solidity.readthedocs.io/en/v0.6.8/">Solidity</a> parser and printer written in OCaml using Menhir, and used it to implement a full interpreter directly in a blockchain. Solidity is probably the most used language for smart contracts, it was first born on Ethereum but many other blockchains provide it as a way to easily onboard new developers coming from the Ethereum ecosystem. In the future, we plan to extend this work with formal verification of Solidity smart contracts.</p>
<p><em>This is a joint effort with <a href="https://www.origin-labs.com/">Origin Labs</a>, the company created to tackle  blockchain-related challenges.</em></p>
<p>##Towards 2021##</p>
<p><img src="https://ocamlpro.com/blog/assets/img/picture_towards.jpg" alt="towards"/></p>
<p>Adaptability and continuous improvement, that&rsquo;s what 2020 brought to OCamlPro!</p>
<p>We will remember 2020 as a complicated year, but one that allowed us to surpass ourselves and challenge our projects. We are very proud of our team who all continued to grow, learn, and develop our projects in this particular context. We are more motivated than ever for the coming year, which marks our tenth year anniversary! We&rsquo;re excited to continue sharing our knowledge of the OCaml world and to accompany you in your own projects.</p>

