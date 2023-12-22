---
title: 2019 at OCamlPro
description: 2019 at OCamlPro OCamlPro was created to help OCaml and formal methods
  spread into the industry. We grew from 1 to 21 engineers, still strongly sharing
  this ambitious goal! The year 2019 at OCamlPro was very lively, with fantastic accomplishments
  all along! Let's quickly review the past years' works...
url: https://ocamlpro.com/blog/2020_02_04_2019_at_ocamlpro
date: 2020-02-04T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    Muriel\n  "
source:
---

<p><img src="https://ocamlpro.com/blog/assets/img/logo_ocp_2019.png" alt="2019 at OCamlPro"/></p>
<p>OCamlPro was created to help OCaml and formal methods spread into the industry. We grew from 1 to 21 engineers, still strongly sharing this ambitious goal! The year 2019 at OCamlPro was very lively, with fantastic accomplishments all along!</p>
<p>Let's quickly review the past years' works, first in the world of <a href="https://ocamlpro.com/blog/feed#ocaml">OCaml</a> (<a href="https://ocamlpro.com/blog/feed#compilation">flambda2</a> &amp; compiler optimisations, <a href="https://ocamlpro.com/blog/feed#opam">opam</a> 2, our <a href="https://ocamlpro.com/blog/feed#rust">Rust-based</a> UI for <a href="https://ocamlpro.com/blog/feed#memthol">memprof</a>, tools like tryOCaml, ocp-indent, and supporting the <a href="https://ocamlpro.com/blog/feed#ocsf">OCaml Software Foundation</a>), then in the world of <a href="https://ocamlpro.com/blog/feed#formalmethods">formal methods</a> (new versions of our SMT Solver <a href="https://ocamlpro.com/blog/feed#altergo">Alt-Ergo</a>, launch of the <a href="https://ocamlpro.com/blog/feed#altergoclub">Alt-Ergo Users' Club</a>, the <a href="https://ocamlpro.com/blog/feed#love">Love language</a>, etc.).</p>
<h2>In the World of OCaml</h2>
<p><img src="https://ocamlpro.com/blog/assets/img/logo_ocaml.png" alt="ocaml"/></p>
<h3>Flambda/Compilation Team</h3>
<p><em>Work by Pierre Chambart, Vincent Laviron, Guillaume Bury and Pierrick Couderc</em></p>
<p>Pierre and Vincent's considerable work on Flambda 2 (the optimizing intermediate representation of the OCaml compiler &ndash; on which inlining occurs), in close cooperation with Jane Street (Mark Shinwell, Leo White and their team) aims at overcoming some of flambda's limitations. We have continued our work on making OCaml programs always faster: internal types are clearer, more concise, and possible control flow transformations are more flexible. Overall a precious outcome for industrial users. In 2019, the major breakthrough was to go from the initial prototype to a complete compiler, which allowed us to compile simple examples first and then to bootstrap it.</p>
<p>On the OCaml compiler side, we also worked with Leo on two new features: functorized compilation units and functorized packs, and recursive packs. The former will allow any developer to implement <code>.ml</code> files as if they were functors and not simply modules, and more importantly generate packs that are real functors. As such, this allows to split big functors into several files or to parameterize libraries on other modules. The latter allows two distinct usages: recursive interfaces, to implement recursive types into distinct <code>.mlis</code> as long as they do not need any implementation; and recursive packs, whose components are typed and compiled as recursive modules.</p>
<ul>
<li>These new features are described on the new <a href="https://github.com/ocaml/RFCs/pull/11">RFC repository</a> for OCaml (a <a href="https://github.com/ocaml/ocaml/issues/5283">similar idea</a> was suggested and implemented in 2011 by Fabrice Le Fessant).
</li>
<li>The implementation is available on GitHub for both <a href="https://github.com/OCamlPro-Couderc/ocaml/tree/functorized-packs">functorized packs</a> and <a href="https://github.com/OCamlPro-Couderc/ocaml/tree/recursive-units+pack-cleanup">recursive packs</a>. Be aware that both are based on an old version of OCaml for now, but should be in sync with the current trunk in the near future.
</li>
<li>See also Vincent's <a href="https://ocamlpro.com/blog/2019_08_30_ocamlpros_compiler_team_work_update">OCamlPro&rsquo;s compiler team work update</a> of August 2019.
</li>
</ul>
<p><em>This work is allowed thanks to Jane Street's funding.</em></p>
<h3>Work on a formalized type system for OCaml</h3>
<p><em>Work of Pierrick Couderc</em></p>
<p>At the end of 2018, Pierrick defended his PhD on &quot;<a href="https://pastel.archives-ouvertes.fr/tel-02100717/">Checking type inference results of the OCaml language</a>&quot;, leading to a formalized type systems and semantics for a large subset of OCaml, or at least its unique typed intermediate language: the Typedtree. This work led us to work on new aspects of the OCaml compiler as recursive and functorized packs described earlier, and we hope this proves useful in the future for the evolution of the language.</p>
<h3>The OPAM package manager</h3>
<p><em>Work of Raja Boujbel and Louis Gesbert</em></p>
<p><img src="https://ocamlpro.com/blog/assets/img/logo_opam_300_261.png" alt="opam"/></p>
<p><a href="https://opam.ocaml.org">OPAM</a> is maintained and developed at OCamlPro by Louis and Raja. Thanks to their thorough efforts the opam 2.1 first release candidate is soon to be published!</p>
<p>Back in 2018, the long-awaited opam 2.0 version was finally released. It embedded many changes, in opam itself as well as for the community. The opam file format was redefined to simplify and add new features. With the close collaboration of OCamlLabs and opam repository maintainers, we were able to manage a smooth transition of the repository and whole ecosystem from opam 1.2 format to the new &ndash; and richer &ndash; opam 2.0 format. Other emblematic features are e.g. for practically integrated mccs solver, sandboxing builds, for security issues (we care about your filesystem!), for usability reworking of the pin' command, etc.</p>
<p>While the 2.1.0 version is in preparation, the 2.0.0 version is still updated with minor releases to fix issues. The lastest 2.0.6 release is fresh from January.</p>
<p>In the meantime, we continued to improve opam by integrating some opam plugins (opam lock, opam depext), recursively discover opam files in the file tree when pinning, new definition of a switch compiler, the possibility to use z3 backend instead of mccs, etc.</p>
<p>All these new features &ndash; among others &ndash; will be integrated in the 2.1.0 release, that is betaplanned for February. The best is yet to come!</p>
<ul>
<li>More details: on <a href="https://opam.ocaml.org">https://opam.ocaml.org</a>
</li>
<li>Releases on Releases on <a href="https://github.com/ocaml/opam/releases">https://github.com/ocaml/opam/releases</a> &amp; <a href="https://opam.ocaml.org/blog/opam-2-0-6/">our blog</a>
</li>
</ul>
<p><em>This work is allowed thanks to Jane Street's funding.</em></p>
<h3>Encouraging OCaml adoption</h3>
<h4>OCaml Expert trainings for professional programmers</h4>
<p>We proposed in 2019 some <a href="https://ocamlpro.com/course_ocaml_expert">OCaml expert training</a> specially designed for developers who want to use advanced features and master all the open-source tools and libraries of OCaml.</p>
<blockquote>
<p>The &quot;Expert&quot; OCaml course is for already experienced OCaml programmers to better understand advanced type system possibilities (objects, GADTs), discover GC internals, write &quot;compiler-optimizable&quot; code. These sessions are also an opportunity to come discuss with our OPAM &amp; Flambda lead developers and core contributors in Paris.</p>
</blockquote>
<p>Next session: 3-4 March 2020, Paris <a href="https://www.ocamlpro.com/pre-inscription-a-une-session-de-formation-inter-entreprises/">(registration)</a></p>
<h4>Our cheat-sheets on OCaml, the stdlib and opam</h4>
<p><em>Work of Thomas Blanc, Raja Boujbel and Louis Gesbert</em></p>
<p>Thomas announced the release of our up-to-date cheat-sheets for the <a href="https://ocamlpro.com/blog/2019_09_13_updated_cheat_sheets_language_stdlib_2">OCaml language, standard library</a> and <a href="https://ocamlpro.github.io/ocaml-cheat-sheets/ocaml-opam.pdf">opam</a>. Our original cheat-sheets were dating back to 2011. This was an opportunity to update them after the <a href="https://ocamlpro.com/blog/2019_09_13_updated_cheat_sheets_language_stdlib_2">many changes</a> in the language, library and ecosystem overall.</p>
<blockquote>
<p>Cheat-sheets are helpful to refer to, as an overview of the documentation when you are programming, especially when you&rsquo;re starting in a new language. They are meant to be printed and pinned on your wall, or to be kept in handy on a spare screen. <em>They come in handy when your <a href="https://rubberduckdebugging.com/">rubber duck</a> is rubbish at debugging your code!</em></p>
</blockquote>
<p>More details on <a href="https://ocamlpro.com/blog/2019_09_13_updated_cheat_sheets_language_stdlib_2">Thomas' blog post</a></p>
<h4>Open Source Tooling and Web IDEs</h4>
<p>And let's not forget the other tools we develop and maintain! We have tools for education such as our interactive editor OCaml-top and <a href="https://try.ocamlpro.com/new.html">Try-OCaml</a> (from the previous work on the learn-OCaml platform for the OCaml Fun MOOC) which you can use to code in your browser. Developers will appreciate tools like our indentation tool ocp-indent, and ocp-index which gives you easy access to the interface information of installed OCaml libraries for editors like Emacs and Vim.</p>
<h3>Supporting the OCaml Software Foundation</h3>
<p>OCamlPro was proud to be one of the first supporters of the new Inria's <a href="https://ocaml-sf.org/">OCaml Software Foundation.</a> We keep committed to the adoption of OCaml as an industrial language:</p>
<blockquote>
<p>&quot;[&hellip;] As a long-standing supporter of the OCaml language, we have always been committed to helping spread OCaml's adoption and increase the accessibility of OCaml to beginners and students. [&hellip;] We value close and friendly collaboration with the main actors of the OCaml community, and are proud to be contributing to the OCaml language and tooling.&quot; (August 2019, Advisory Board of the OCSF, ICFP Berlin)</p>
</blockquote>
<p>More information on the <a href="https://ocaml-sf.org/">OCaml Software Foundation</a></p>
<h2>In the World of Formal Methods</h2>
<p><em>By Mohamed Iguernlala, Albin Coquereau, Guillaume Bury</em></p>
<p>In 2018, we welcomed five new engineers with a background in formal methods. They consolidate the department of formal methods at OCamlPro, in particular help develop and maintain our SMT solver Alt-Ergo.</p>
<h3>Release of Alt-Ergo 2.3.0, and version 2.0.0 (free)</h3>
<p>After the release of <a href="https://ocamlpro.com/blog/2018_04_23_release_of_alt_ergo_2_2_0">Alt-Ergo 2.2.0</a> (with a new front-end that supports the SMT-LIB 2 language, extended prenex polymorphism, implemented as a standalone library) came the version 2.3.0 in 2019 with new features : dune support, ADT / algebraic datatypes, improvement of the if-then-else and let-in support, improvement of the data types.</p>
<ul>
<li>More information on the <a href="https://alt-ergo.ocamlpro.com/">Alt-Ergo SMT Solver</a>
</li>
<li>Albin Coquereau defended his PhD thesis in Decembre 2019 &quot;Improving performance of the SMT solver Alt-Ergo with a better integration of efficient SAT solver&quot;
</li>
<li>We participated in the SMT-COMP 2019 during the 22nd SAT conference. The results of the competition are detailed <a href="https://ocamlpro.com/blog/2019_07_09_alt_ergo_participation_to_the_smt_comp_2019">here.</a>
</li>
</ul>
<h3>The launch of the Alt-Ergo Users' Club</h3>
<p>Getting closer to our users, gathering industrial and academic supporters, collecting their needs into the Alt-Ergo roadmap is key to Alt-Ergo's development and sustainability.</p>
<p>The <a href="https://alt-ergo.ocamlpro.com/#club">Alt-Ergo Users' Club</a> was officially launched beginning of 2019. The first yearly meeting took place in February 2019. We were happy to welcome our first members <a href="https://www.adacore.com">Adacore</a>, <a href="https://www-list.cea.fr/en/">CEA List</a>, <a href="https://trust-in-soft.com">Trust-In-Soft</a>, and now Mitsubishi MERCE.</p>
<p>More information on the <a href="https://alt-ergo.ocamlpro.com/#club">Alt-Ergo Users' Club</a></p>
<p><img src="https://ocamlpro.com/blog/assets/img/logo_love_couleur.png" alt="Love-language"/></p>
<h2>Harnessing our language-design expertise: Love</h2>
<p><em>Work by David Declerck &amp; Steven de Oliveira</em></p>
<p>Following the launch of Dune network, the Love language for smart-contracts was born from the collaboration of OCamlPro and Origin Labs. This new language, whose syntax is inspired from OCaml and Liquidity, is an alternative to the Dune native smart contract language Michelson. Love is based on system-F, a type system requiring no type inference and allowing polymorphism. The language has successfully been integrated on the network and the first smart contracts are being written.</p>
<p><a href="https://medium.com/dune-network/love-a-new-smart-contract-language-for-the-dune-network-a217ab2255be">LOVE: a New Smart Contract Language for the Dune Network</a>
<a href="https://medium.com/dune-network/the-love-smart-contract-language-introduction-key-features-part-i-949d8a4e73c3">The Love Smart Contract Language: Introduction &amp; Key Features &mdash; Part I</a></p>
<h2>Rust-related activities</h2>
<p>The OCaml &amp; Rust combo <em>should</em> be a candidate for any ambitious software project!</p>
<ul>
<li>A Rust-based UI for memprof: we started in 2019 to work in collaboration with the memprof developer team on a Rust based UI for memprof. See Pierre and Albin's expos&eacute; at the <a href="https://jfla.inria.fr/jfla2020.html">JFLA2020</a>'s &quot;Gardez votre m&eacute;moire fraiche avec Memthol&quot; (Pierre Chambart , Albin Coquereau and Jacques-Henri Jourdan)
</li>
<li><a href="https://ocamlpro.com/course_rust_vocational_training">Rust training</a> : <em>Rust borrows heavily from functional programming languages to provide very expressive abstraction mechanisms. Because it is a systems language, these mechanisms are almost always zero-cost. For instance, polymorphic code has no runtime cost compared to a monomorphic version.This concern for efficiency also means that Rust lets developers keep a very high level of control and freedom for optimizations. Rust has no Garbage Collection or any form of runtime memory inspection to decide when to free, allocate or re-use memory. But because manual memory management is almost universally regarded as dangerous, or at least very difficult to maintain, the Rust compiler has a borrow-checker which is responsible for i) proving that the input program is memory-safe (and thread-safe), and ii) generating a safe and &ldquo;optimal&rdquo; allocation/deallocation strategy. All of this is done at compile-time.</em>
</li>
<li>Next sessions: April 20-24th 2020 <a href="https://www.ocamlpro.com/pre-inscription-a-une-session-de-formation-inter-entreprises/">(registration)</a>
</li>
</ul>
<h2>OCamlPro around the world</h2>
<p>OCamlPro's team members attended many events throughout the world:</p>
<ul>
<li><a href="https://icfp19.sigplan.org/">ICFP 2019</a> (Berlin)
</li>
<li>The <a href="https://dpt-info.u-strasbg.fr/~magaud/JFLA2019/lieu.html">JFLA&rsquo;2019</a> (Les Rousses, Haut-Jura)
</li>
<li>The<a href="https://www.opensourcesummit.paris/"> POSS'2019 </a>(Paris)
</li>
<li><a href="https://retreat.mirage.io/">MirageOS Retreat</a> (Marrakech)
</li>
</ul>
<p>As a committed member of the OCaml ecosystem's animation, we've organized OCaml meetups too (see the famous <a href="https://www.meetup.com/fr-FR/ocaml-paris/">OUPS</a> meetups in Paris!).</p>
<p>Now let's jump into the new year 2020, with a team keeping expanding, and new projects ahead: keep posted!</p>
<h3>Past projects: blockchain-related achievements (2018-beginning of 2019)</h3>
<p>Many people ask us about what happened in 2018! That was an incredibly active year on blockchain-related achievements, and at that time we were hoping to attract clients that would be interested in our blockchain expertise.</p>
<p>But that is <a href="https://files.ocamlpro.com/Flyer_Blockchains_OSIS2017ok.pdf">history</a> now! Still interested? Check the <a href="https://www.origin-labs.com/">Origin Labs</a> team and their partner <a href="https://www.thegara.ge/">The Garage</a> on <a href="https://dune.network">Dune Network</a>!</p>
<p>For the <a href="https://ocamlpro.com/blog/2019_04_29_blockchains_at_ocamlpro_an_overview">record</a>:</p>
<ul>
<li>(April 2019) We had started Techelson: a testing framework for Michelson and Liquidity
</li>
<li>(Nov 2018) <a href="https://ocamlpro.com/blog/2018_11_21_an_introduction_to_tezos_rpcs_signing_operations">An Introduction to Tezos RPCs: Signing Operations</a> / <a href="https://ocamlpro.com/blog/2018_11_15_an-introduction_to_tezos_rpcs_a_basic_wallet">An Introduction to Tezos RPCs: a Basic Wallet</a> / <a href="https://ocamlpro.com/blog/2018_11_06_liquidity_tutorial_a_game_with_an_oracle_for_random_numbers">Liquidity Tutorial: A Game with an Oracle for Random Numbers</a> / <a href="https://ocamlpro.com/blog/2018_11_08_first_open_source_release_of_tzscan">First Open-Source Release of TzScan</a>
</li>
<li>(Oct 2018) <a href="https://ocamlpro.com/blog/2018_10_17_ocamlpros_tzscan_grant_proposal_accepted_by_the_tezos_foundation_joint_press_release">OCamlPro&rsquo;s TZScan grant proposal accepted by the Tezos Foundation &ndash; joint press release</a>
</li>
<li>(Jul 2018) <a href="https://ocamlpro.com/blog/2018_07_20_new_updates_on_tzscan_2">OCamlPro&rsquo;s Tezos block explorer TzScan&rsquo;s last updates</a>
</li>
<li>(Feb 2018) <a href="https://ocamlpro.com/blog/2018_02_14_release_of_a_first_version_of_tzscan_io_a_tezos_block_explorer">Release of a first version of TzScan.io, a Tezos block explorer</a> / <a href="https://ocamlpro.com/blog/2018_11_06_liquidity_tutorial_a_game_with_an_oracle_for_random_numbers">OCamlPro&rsquo;s Liquidity-lang demo at JFLA2018 &ndash; a smart-contract design language</a> . We were developing <a href="https://www.liquidity-lang.org/">Liquidity</a>, a high level smart contract language, human-readable, purely functional, statically-typed, which syntax was very close to the OCaml syntax.
</li>
<li>To garner interest and adoption, we also developed the online editor <a href="https://www.liquidity-lang.org/edit">Try Liquidity</a>. Smart-contract developers could design contracts interactively, directly in the browser, compile them to Michelson, run them and deploy them on the alphanet network of Tezos. Future plans included a full-fledged web-based IDE for Liquidity. Worth mentioning was a neat feature: decompiling a Michelson program back to its Liquidity version, whether it was generated from Liquidity code or not.
</li>
</ul>

