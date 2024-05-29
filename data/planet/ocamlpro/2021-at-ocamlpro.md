---
title: 2021 at OCamlPro
description: OCamlPro was created in 2011 to advocate the adoption of the OCaml language
  and Formal Methods in general in the industry. 2021 was a very special year as we
  celebrated our 10th anniversary! While building a team of highly-skilled engineers,
  we navigated through our expertise domains, programming la...
url: https://ocamlpro.com/blog/2022_01_31_2021_at_ocamlpro
date: 2022-01-31T13:19:46-00:00
preview_image: URL_de_votre_image
authors:
- "\n    Muriel\n  "
source:
---

<p>

</p><div class="figure">
  <p>
    <a href="https://ocamlpro.com/blog/assets/img/2021_ocamlpro.jpeg">
      <img src="https://ocamlpro.com/blog/assets/img/2021_ocamlpro.jpeg" alt="Passing from one year to another is a great time to have a look back!"/>
    </a>
    </p><div class="caption">
      Passing from one year to another is a great time to have a look back!
    </div>
  
</div>

<p>OCamlPro was created in 2011 to advocate the adoption of the OCaml language and Formal Methods in general in the industry. 2021 was a very special year as we celebrated our 10th anniversary! While building a team of highly-skilled engineers, we navigated through our expertise domains, programming languages design, compilation and analysis, advanced developer tooling, formal methods, blockchains and high-value software prototyping.</p>
<p>In this article, as every year (see <a href="https://ocamlpro.com/blog/2021_02_02_2020_at_ocamlpro">last year's post</a>), we review some of the work we did during 2021, in many different worlds.</p>
<p></p><div>
<strong>Table of contents</strong>
<p><a href="https://ocamlpro.com/blog/feed#people">Newcomers at OCamlPro</a></p>
<p><a href="https://ocamlpro.com/blog/feed#apps">Real Life Modern Applications</a></p>
<ul>
<li><a href="https://ocamlpro.com/blog/feed#mlang">Modernizing the French Income Tax System</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#cobol">A First Step in the COBOL Universe</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#geneweb">Auditing a High-Scale Genealogy Application</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#mosaic">Improving an ecotoxicology platform</a>
</li>
</ul>
<p><a href="https://ocamlpro.com/blog/feed#ocaml">Contributions to OCaml</a></p>
<ul>
<li><a href="https://ocamlpro.com/blog/feed#flambda">Flambda Code Optimizer</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#opam">Opam Package Manager</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#community">LearnOCaml and TryOCaml</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#tooling">OCaml Documentation Hub</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#free_software">Plugging Opam into Software Heritage</a>
</li>
</ul>
<p><a href="https://ocamlpro.com/blog/feed#formal-methods">Tooling for Formal Methods</a></p>
<ul>
<li><a href="https://ocamlpro.com/blog/feed#alt-ergo">Alt-Ergo Development</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#club">Alt-Ergo Users&rsquo; Club and R&amp;D Projects</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#dolmen">Dolmen Library for Automated Deduction Languages</a>
</li>
</ul>
<p><a href="https://ocamlpro.com/blog/feed#rust">Rust Developments</a></p>
<ul>
<li><a href="https://ocamlpro.com/blog/feed#mikino">SMT, Induction and Mikino</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#matla">Matla, a Project Manager for TLA+/TLC</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#rust-training">Rust Training at Onera</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#rust-audit">Audit of a Rust Blockchain Node</a>
</li>
</ul>
<p><a href="https://ocamlpro.com/blog/feed#blockchains">Scaling and Verifying Blockchains</a></p>
<ul>
<li><a href="https://ocamlpro.com/blog/feed#everscale">From Dune Network to FreeTON/EverScale</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#solidity">A Why3 Framework for Solidity</a>
</li>
</ul>
<p><a href="https://ocamlpro.com/blog/feed#events">Participations in Public Events</a></p>
<ul>
<li><a href="https://ocamlpro.com/blog/feed#osxp2021">Open Source Experience 2021</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#ow2021">OCaml Workshop at ICFP 2021</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#why3consortium">Joining the Why3 Consortium at the ProofInUse Seminar</a>
</li>
</ul>
<p><a href="https://ocamlpro.com/blog/feed#next">Towards 2022</a>
</p></div>
<p>As always, we warmly thank all our clients, partners, and friends, for their support and collaboration during this peculiar year!</p>
<h2>
<a class="anchor"></a>Newcomers at OCamlPro<a href="https://ocamlpro.com/blog/feed#people">&#9875;</a>
          </h2>
<p>
</p><div class="figure">
  <p>
    <a href="https://ocamlpro.com/blog/assets/img/mini-team-2022-02-14.jpg">
      <img src="https://ocamlpro.com/blog/assets/img/mini-team-2022-02-14.jpg" alt="Some of the new and old members of the team: Pierre Chambart, Dario Pinto, L&eacute;o Andr&egrave;s, Fabrice Le Fessant, Louis Gesbert, Artemiy Rozovyk, Muriel Shan Sei Fan, Nicolas Berthier, Vincent Laviron, Steven De Oliveira and Keryan Didier."/>
    </a>
    </p><div class="caption">
      Some of the new and old members of the team: Pierre Chambart, Dario Pinto, L&eacute;o Andr&egrave;s, Fabrice Le Fessant, Louis Gesbert, Artemiy Rozovyk, Muriel Shan Sei Fan, Nicolas Berthier, Vincent Laviron, Steven De Oliveira and Keryan Didier.
    </div>
  
</div>

<p>A company is nothing without its employees. This year, we have been delighted to welcome a great share of newcomers:</p>
<ul>
<li><em>Hichem Rami Ait El Hara</em> recently completed his master's degree in Computer Science. After an internship at OCamlPro, during which he developed a fuzzer for Alt-Ergo, he joined OCamlPro to work on Alt-Ergo and the verification of smart contracts. He will soon start a PhD on SMT solving.
</li>
<li><em>Nicolas Berthier</em> holds a PhD on synchronous programming for resource-constrained systems.  With many years experience on model-checking, abstract interpretation, and software analysis, he joined OCamlPro to work on programming language compilation and analysis.
</li>
<li><em>Julien Blond</em> is a senior OCaml developer with a strong experience in formal verification of security software. He joined OCamlPro as both a project manager and a Coq expert.
</li>
<li><em>Keryan Didier</em> joined the team as a R&amp;D engineer. He holds a PhD from University Pierre et Marie Curie, during which he developed an automated implementation method for hard real-time applications. Previously, he studied functional programming and language design at University Paris-Diderot. Keryan has been involved in the MLang project as well as the flambda2 project within OCamlPro's Compilation team.
</li>
<li><em>Mohamed Hernouf</em> recently completed his master's degree in Computer Science. After an internship at OCamlPro, working on the <a href="https://docs.ocaml.pro">OCaml Documentation Hub</a>, he joined OCamlPro and continues to work on the documentation hub and other OCaml applications.
</li>
<li><em>Dario Pinto</em> is a student at the <a href="https://42.fr/en/homepage/">42Paris</a> School of Computer Science. He joined OCamlPro in a work-study contract for two years.
</li>
<li><em>Artemiy Rozovyk</em> recently completed his master's degree in Computer Science. He joined OCamlPro to work on the development of applications for the EverScale and Avalanche blockchains.
</li>
</ul>
<h2>
<a class="anchor"></a>Real Life Modern Applications<a href="https://ocamlpro.com/blog/feed#apps">&#9875;</a>
          </h2>
<h3>
<a class="anchor"></a>Modernizing the French Income Tax System<a href="https://ocamlpro.com/blog/feed#mlang">&#9875;</a>
          </h3>
<p>
</p><div class="figure">
  <p>
    <a href="https://ocamlpro.com/blog/assets/img/income-tax.jpg">
      <img src="https://ocamlpro.com/blog/assets/img/income-tax.jpg" alt="The M language, designed in the 80s for the Income Tax, is now being rewritten and extended in OCaml."/>
    </a>
    </p><div class="caption">
      The M language, designed in the 80s for the Income Tax, is now being rewritten and extended in OCaml.
    </div>
  
</div>

<p>The M language is a very old programming language developed by the French tax administration to compute income taxes. Recently, Denis Merigoux and Raphael Monat have implemented a <a href="https://github.com/MLanguage/mlang">new compiler in OCaml</a> for the M language.  This new compiler shows better performance, clearer semantics, and achieves greater maintainability than the former compiler. OCamlPro is now involved in strengthening this new compiler, to put it in production and eventually compute the taxes of more than 30 million French families.</p>
<h3>
<a class="anchor"></a>A First Step in the COBOL Universe<a href="https://ocamlpro.com/blog/feed#cobol">&#9875;</a>
          </h3>
<p>
</p><div class="figure">
  <p>
    <a href="https://ocamlpro.com/blog/assets/img/cobol.jpg">
      <img src="https://ocamlpro.com/blog/assets/img/cobol.jpg" alt="Recent studies still estimate that COBOL has the highest amount of lines of code running."/>
    </a>
    </p><div class="caption">
      Recent studies still estimate that COBOL has the highest amount of lines of code running.
    </div>
  
</div>

<p>Born more than 60 years ago, <a href="https://wikipedia.org/wiki/COBOL">COBOL</a> is still said to be the most used language in the world, in terms of the number of lines running in computers, though many people forecast it would disappear at the edge of the 21st century. With more than 300 reserved keywords, it is also one of the most complex languages to parse and analyse. It's not enough to scare the developers at OCamlPro: while helping one of the biggest COBOL users in France to translate its programs into the <a href="https://gnucobol.sourceforge.io/">GNUCobol open-source compiler</a>, OCamlPro built a strong expertise of COBOL and mainframes, and developed a powerful parser of COBOL that will help us bring modern development tools to the COBOL developers.</p>
<h3>
<a class="anchor"></a>Auditing a High-Scale Genealogy Application<a href="https://ocamlpro.com/blog/feed#geneweb">&#9875;</a>
          </h3>
<p>
</p><div class="figure">
  <p>
    <a href="https://ocamlpro.com/blog/assets/img/genealogie.jpg">
      <img src="https://ocamlpro.com/blog/assets/img/genealogie.jpg" alt="Geneweb was developed in the 90s to manage family trees... and is still managing them!"/>
    </a>
    </p><div class="caption">
      Geneweb was developed in the 90s to manage family trees... and is still managing them!
    </div>
  
</div>

<p><a href="https://geneweb.tuxfamily.org/wiki/GeneWeb/fr">Geneweb</a> is one of the most powerful software to manage and share genealogical data to date. Written in OCaml more than 20 years ago, it contains a web server and complex algorithms to compute information on family trees.  It is used by <a href="https://en.geneanet.org/">Geneanet</a>, which is one of the leading companies in the genealogy field, to store more than 800,000 family trees and more than 7 billion names of ancestors.  OCamlPro is now working with Geneanet to improve Geneweb and make it scale to even larger data sets.</p>
<h3>
<a class="anchor"></a>Improving an ecotoxicology platform<a href="https://ocamlpro.com/blog/feed#mosaic">&#9875;</a>
          </h3>
<p>
</p><div class="figure">
  <p>
    <a href="https://ocamlpro.com/blog/assets/img/labo.jpg">
      <img src="https://ocamlpro.com/blog/assets/img/labo.jpg" alt="Mosaic is used by ecotoxicologists and regulators to obtain advanced and innovative methods for environmental risks assessment."/>
    </a>
    </p><div class="caption">
      Mosaic is used by ecotoxicologists and regulators to obtain advanced and innovative methods for environmental risks assessment.
    </div>
  
</div>

<p>The <a href="https://mosaic.univ-lyon1.fr/">Mosaic</a> platform helps researchers, industrials actors and regulators in the field of ecotoxicology by providing an easy way to run various statistical analyses. All the user has to do is to enter some data on the web interface, then computations are run on the server and the results are displayed. The platform is fully written in OCaml and takes care of calling the mathematical model which is written in R. OCamlPro modernised the project in order to ease maintainance and new contributions. In the process, we discovered <a href="https://github.com/pveber/morse/issues/286">bugs introduced by new R versions</a> (without any kind of warning). Then we developped a new interface for data input, it's similar to a spreadsheet and much more convenient than having to write raw CSV. During this work, we had the opportunity to contribute to some other OCaml packages such as <a href="https://github.com/mfp/ocaml-leveldb">leveldb</a> or write new ones such as <a href="https://github.com/OCamlPro/agrid">agrid</a>.</p>
<h2>
<a class="anchor"></a>Contributions to OCaml<a href="https://ocamlpro.com/blog/feed#ocaml">&#9875;</a>
          </h2>
<h3>
<a class="anchor"></a>Flambda Code Optimizer<a href="https://ocamlpro.com/blog/feed#flambda">&#9875;</a>
          </h3>
<p>
</p><div class="figure">
  <p>
    <a href="https://ocamlpro.com/blog/assets/img/flambda_2021.jpeg">
      <img src="https://ocamlpro.com/blog/assets/img/flambda_2021.jpeg" alt="Flambda2 is a powerful code optimizer for the OCaml compiler."/>
    </a>
    </p><div class="caption">
      Flambda2 is a powerful code optimizer for the OCaml compiler.
    </div>
  
</div>

<p>OCamlPro is proud to be working on Flambda2, an ambitious OCaml optimizing compiler project, initiated with Mark Shinwell from Jane Street, our long-term partner and client. Flambda focuses on reducing the runtime cost of abstractions and removing as many short-lived allocations as possible. Jane Street has launched large-scale testing of flambda2, and on our side, we have documented the design of some key algorithms. In 2021, the Flambda team grew bigger with Keryan.  Along with the considerable amount of fixes and improvements, this will allow us to publish <a href="https://github.com/ocaml-flambda/flambda-backend">Flambda2</a> in the coming months!</p>
<p>In other OCaml compiler news, 2021 saw the long-awaited merge of the multicore branch into the official development branch. This was thanks to the amazing work of many people, including our own, Damien Doligez. This is far from the end of the story though, and we're looking forward to both further contributing to the compiler (fixing bugs, re-enabling support for all platforms) and making use of the features in our own programs.</p>
<p><em>This work is allowed thanks to Jane Street&rsquo;s funding.</em></p>
<h3>
<a class="anchor"></a>Opam Package Manager<a href="https://ocamlpro.com/blog/feed#opam">&#9875;</a>
          </h3>
<p>
</p><div class="figure">
  <p>
    <a href="https://ocamlpro.com/blog/assets/img/opam_2021.jpg">
      <img src="https://ocamlpro.com/blog/assets/img/opam_2021.jpg" alt="A large set of new features have been implemented in Opam in 2021."/>
    </a>
    </p><div class="caption">
      A large set of new features have been implemented in Opam in 2021.
    </div>
  
</div>

<p><a href="https://opam.ocaml.org">Opam</a> is the OCaml source-based package manager. The first specification draft was written <a href="https://opam.ocaml.org/about.html">in early 2012</a> and went on to become OCaml&rsquo;s official package manager &mdash; though it may be used for other languages and projects, since Opam is language-agnostic! If you need to install, upgrade and manage your compiler(s), tools and libraries easily, Opam is meant for you. It supports
multiple simultaneous compiler installations, flexible package constraints, and a Git-friendly development workflow.</p>
<p>Opam development and maintenance is a collaboration between OCamlPro, with Raja &amp; Louis, and OCamlLabs, with David Allsopp &amp; Kate Deplaix.</p>
<p><a href="https://github.com/ocaml/opam/releases">Our 2021 work on opam</a> lead to the final release of the long-awaited opam 2.1, three versions of opam 2.0 and two versions of opam 2.1 with small fixes.</p>
<p>Opam 2.1 introduced several new features:</p>
<ul>
<li>Integration of system dependencies (formerly the opam-depext plugin)
</li>
<li>Creation of lock files for reproducible installations (formerly the opam-lock plugin)
</li>
<li>Switch invariants, replacing the &quot;base packages&quot; in opam 2.0 and allowing for easier compiler upgrades
</li>
<li>Improved option configurations
</li>
<li>CLI versioning, allowing cleaner deprecations for opam now and also improvements to semantics in future without breaking backwards-compatibility
</li>
<li>opam root readability by newer and older versions, even if the format changed
</li>
<li>Performance improvements to opam-update, conflict messages, and many other areas
</li>
</ul>
<p>Take a stroll through the <a href="https://opam.ocaml.org/blog//opam-2-1-0">blog post</a> for a closer look.</p>
<p>In 2021, we also prepared the soon to-be alpha release of opam 2.2 version. It will provide a better handling of the Windows ecosystem, integration of Software
Heritage <a href="https://ocamlpro.com/blog/feed#foundation">archive fallback</a>, better UI on user interactions, recursively pinning of projects, fetching optimisations, etc.</p>
<p><em>This work is greatly helped by Jane Street&rsquo;s funding and support.</em></p>
<h3>
<a class="anchor"></a>LearnOCaml and TryOCaml<a href="https://ocamlpro.com/blog/feed#community">&#9875;</a>
          </h3>
<p>We have also been active in the maintainance of <a href="https://github.com/ocaml-sf/learn-ocaml">Learn-ocaml</a>. What was originally designed as the platform for the <a href="https://www.fun-mooc.fr/en/courses/introduction-functional-programming-ocaml/">OCaml
MOOC</a> is now a tool in the hands of OCaml teachers worldwide, managed and funded by <a href="http://ocaml-sf.org/">the OCaml Foundation</a>.</p>
<p>The work included a well overdue port to OCaml 4.12; generation of portable executables (automatic through CI) for much easier deployment and use of the command-line client; as well as many quality-of-life and usability improvements following from two-way conversations with many teachers.</p>
<p>On a related matter, we also reworked our on-line OCaml editor and toplevel <a href="https://try.ocaml.pro">TryOCaml</a>, improving its design and adding features like code snippet sharing. We were glad to see that, in these difficult times, these tools proved useful to both teachers and students, and look forward to improving them further.</p>
<h3>
<a class="anchor"></a>OCaml Documentation Hub<a href="https://ocamlpro.com/blog/feed#tooling">&#9875;</a>
          </h3>
<p>
</p><div class="figure">
  <p>
    <a href="https://ocamlpro.com/blog/assets/img/ocaml_2021.jpg">
      <img src="https://ocamlpro.com/blog/assets/img/ocaml_2021.jpg" alt="The OCaml Documentation Hub includes browsable documentation and sources for more than 2000 Opam packages."/>
    </a>
    </p><div class="caption">
      The OCaml Documentation Hub includes browsable documentation and sources for more than 2000 Opam packages.
    </div>
  
</div>

<p>As one of the biggest user of OCaml, OCamlPro aims at facilitating daily use of OCaml by developing a lot of open-source tooling.</p>
<p>One of our main contributions to the OCaml ecosystem in 2021 was probably the OCaml Documentation Hub at <a href="https://docs.ocaml.pro">docs.ocaml.pro</a>.</p>
<p>The OCaml Documentation Hub is a website that provides documentation for more than 2000 OPAM packages, among which of course the most popular ones, with inter-package documentation links!  The website also contains browsable sources for all these packages, and a search engine to discover useful OCaml functions, modules, types and classes.</p>
<p>All this documentation is generated using our custom tool
<a href="https://github.com/OCamlPro/digodoc">Digodoc</a>.  Though it's not worth
a specific section, we also kept maintaining
<a href="https://github.com/OCamlPro/drom">Drom</a>, our layer on Dune and Opam
that most of our recent projects use.</p>
<h3>
<a class="anchor"></a>Pluging Opam into Software Heritage<a href="https://ocamlpro.com/blog/feed#free_software">&#9875;</a>
          </h3>
<p>
</p><div class="figure">
  <p>
    <a href="https://ocamlpro.com/blog/assets/img/Svalbard_seed_vault.jpg">
      <img src="https://ocamlpro.com/blog/assets/img/Svalbard_seed_vault.jpg" alt="Svalbard Global Seed Vault in Norway."/>
    </a>
    </p><div class="caption">
      Svalbard Global Seed Vault in Norway.
    </div>
  
</div>

<p>Last year has also seen the long awaited collaboration between Software Heritage and OCamlPro happen.</p>
<p>Thanks to a grant by the <a href="https://www.softwareheritage.org/2021/04/20/connecting-ocaml/">Alfred P. Sloan Foundation</a>, OCamlPro has been able to collaborate with our partners at Software Heritage and manage to further expand the coverage of this gargantuan endeavour of theirs by archiving 3516 opam packages.
In effect, the main benefits of this Open Source collaboration have been:</p>
<ul>
<li>The addition of several modules to the Software Heritage architecture, allowing the archiving of said opam packages;
</li>
<li>The publication of an OCaml library allowing to work with <a href="https://github.com/OCamlPro/swhid">SWHID</a>s;
</li>
<li>An implementation of a possible fallback onto Software Heritage if a given package on opam is no longer available;
</li>
<li>A fix for the official opam repository in order to identify already missing packages.
</li>
</ul>
<p>Not long after Software was at last acknowledged by Unesco as part of the World Heritage, we were thrilled to be part of this great and meaningful initiative. We could feel how true passion remained throughout our interactions and long after the work was done.</p>
<h2>
<a class="anchor"></a>Tooling for Formal Methods<a href="https://ocamlpro.com/blog/feed#formal-methods">&#9875;</a>
          </h2>
<p>
</p><div class="figure">
  <p>
    <a href="https://ocamlpro.com/blog/assets/img/pure-mathematics-formulae-blackboard.jpg">
      <img src="https://ocamlpro.com/blog/assets/img/pure-mathematics-formulae-blackboard.jpg" alt="Avionics, blockchains, cyber-security, cloud, etc... formal methods are spreading in the computer industry."/>
    </a>
    </p><div class="caption">
      Avionics, blockchains, cyber-security, cloud, etc... formal methods are spreading in the computer industry.
    </div>
  
</div>

<h3>
<a class="anchor"></a>Alt-Ergo Development<a href="https://ocamlpro.com/blog/feed#alt-ergo">&#9875;</a>
          </h3>
<p>OCamlPro develops and maintains <a href="https://alt-ergo.ocamlpro.com/">Alt-Ergo</a>, an automatic solver of mathematical formulas designed for program verification and based on Satisfiability Modulo Theories (SMT). Alt-Ergo was initially created within the <a href="https://vals.lri.fr/">VALS</a> team at <a href="https://www.universite-paris-saclay.fr/en">University of Paris-Saclay</a>.</p>
<p>In 2021, we continued to focus on the maintainability of our solver. We released versions 2.4.0 and <a href="https://github.com/OCamlPro/alt-ergo/releases/tag/2.4.1">2.4.1</a> in January and July respectively, with 2.4.1 containing a bugfix as well as some performance improvements.</p>
<p>In order to increase our test coverage, we instrumented Alt-Ergo so that we could run it using <a href="https://github.com/google/AFL">afl-fuzz</a>. Although this is a proof of concept, and has yet to be integrated into Alt-ergo's continuous integration, it has already helped us find a few bugs, such as <a href="https://github.com/OCamlPro/alt-ergo/pull/489">this</a>.</p>
<h3>
<a class="anchor"></a>Alt-Ergo Users&rsquo; Club and R&amp;D Projects<a href="https://ocamlpro.com/blog/feed#club">&#9875;</a>
          </h3>
<p>We thank our partners from the <a href="https://alt-ergo.ocamlpro.com/#club">Alt-Ergo Users&rsquo; Club</a>, Adacore, CEA List, MERCE (Mitsubishi Electric R&amp;D Centre Europe), Thal&egrave;s, and Trust-In-Soft, for their trust. Their support allows us to maintain our tool.</p>
<p>The club was launched in 2019 and the third annual meeting of the Alt-Ergo Users&rsquo; Club was held in early April 2021. Our annual meeting is the perfect place to review each partner&rsquo;s needs regarding Alt-Ergo. This year, we had the pleasure of receiving our partners to discuss the roadmap for future Alt-Ergo features and enhancements. If you want to join us for the next meeting (coming soon), contact us!</p>
<p>Finally, we will be able to merge into the main branch of Alt-Ergo some of the work we did in 2020. Thanks to our partner MERCE (Mitsubishi Electric R&amp;D Centre Europe), we worked on the SMT model generation. Alt-Ergo is now (partially) able to output a model in the smt-lib2 format. Thanks to the <a href="http://why3.lri.fr/">Why3 team</a> from University of Paris-Saclay, we hope that this work will be available in the Why3 platform to help users in their program verification efforts. OCamlPro was very happy to join the <a href="https://proofinuse.gitlabpages.inria.fr/">Why3 Consortium</a> this year, for even more collaborations to come!</p>
<p><em>This work is funded in part by the FUI R&amp;D Project LCHIP, MERCE, Adacore and with the support of the <a href="https://alt-ergo.ocamlpro.com/#club">Alt-Ergo Users&rsquo; Club</a>.</em></p>
<h3>
<a class="anchor"></a>Dolmen Library for Automated Deduction Languages<a href="https://ocamlpro.com/blog/feed#dolmen">&#9875;</a>
          </h3>
<p><a href="https://github.com/Gbury/dolmen">Dolmen</a> is a powerful library providing flexible parsers and typecheckers for many languages used in automated deduction.</p>
<p>The ongoing work on using the Dolmen library as frontend for Alt-Ergo has progressed considerably, both on the side of dolemn which has been extended to support Alt-Ergo's native language in <a href="https://github.com/Gbury/dolmen/pull/89">this PR</a>, and on Alt-Ergo's side to add dolmen as a frontend that can be chosen in <a href="https://github.com/OCamlPro/alt-ergo/pull/491">this PR</a>. Once these are merged, Alt-Ergo will be able to read input problems in new languages, such as <a href="http://www.tptp.org/">TPTP</a>!</p>
<h2>
<a class="anchor"></a>Rust Developments<a href="https://ocamlpro.com/blog/feed#rust">&#9875;</a>
          </h2>
<p>
</p><div class="figure">
  <p>
    <a href="https://ocamlpro.com/blog/assets/img/logo_rust.jpg">
      <img src="https://ocamlpro.com/blog/assets/img/logo_rust.jpg" alt="Rust is a very good complement to OCaml for performance critical applications."/>
    </a>
    </p><div class="caption">
      Rust is a very good complement to OCaml for performance critical applications.
    </div>
  
</div>

<h3>
<a class="anchor"></a>SMT, Induction and Mikino<a href="https://ocamlpro.com/blog/feed#mikino">&#9875;</a>
          </h3>
<p>A few months ago, we published a series of posts: <a href="https://ocamlpro.com/blog/2021_10_14_verification_for_dummies_smt_and_induction"><em>verification for dummies: SMT and induction</em></a>. These posts introduce and discuss SMT solvers, the notion of induction and that of invariant strengthening. They rely on <a href="https://github.com/OCamlPro/mikino_bin"><em>mikino</em></a>, a simple software we wrote that can analyze simple transition systems and perform SMT-based induction checks (as well as BMC, <em>i.e.</em> bug-finding). We wrote mikino in Rust with readability and ergonomics in mind: mikino showcases the basics of writing an SMT-based model checker performing induction. The posts are very hands-on and leverage mikino's high-quality output to discuss induction and invariant strengthening, with examples that readers can run and edit themselves.</p>
<h3>
<a class="anchor"></a>Matla, a Project Manager for TLA+/TLC<a href="https://ocamlpro.com/blog/feed#matla">&#9875;</a>
          </h3>
<p>During 2021 we ended up using the TLA+ language and its associated TLC verification engine in several completely unrelated projects. TLC is an amazing tool, but it is not suited to handle a TLA+ project with many modules (files), regression tests, <em>etc.</em> In particular, TLA+ is not a typed language. This means that TLA+ code tends to have many <em>checks</em> (dynamic assertions) checking that quantities have the expected type. This is fine, albeit a bit tedious, to some extent, but as the code grows bigger the analysis conducted by TLC can become very, very expensive. Eventually it is not reasonable to keep assert-type-checking everything since it contributes to TLC's analysis exploding.</p>
<p>As TLA+/TLC users, we are currently developing <code>matla</code> which <code>ma</code>nages <code>TLA</code>+ projects. Written in Rust, matla is heavily inspired by the Rust ecosystem, in particular <a href="https://doc.rust-lang.org/cargo">cargo</a>. Matla has not been publicly released yet as we are waiting for more feedback from early users. We do use it internally however as its various features make our TLA+ projects much simpler:</p>
<ul>
<li>handling the TLA toolchain (download, <code>PATH</code>, updates...) for the user;
</li>
<li>provide a <code>Matla</code> module with <em>&quot;debug assertions&quot;</em> helpers: these assertions are active in <em>debug</em> mode, which is the default when running <code>matla run</code>. Passing <code>--release</code> to matla's run mode however compiles all debug assertions away; this allows to type-check everything when debugging while making sure release runs do not pay the price of these checks;
</li>
<li>handle <em>integration</em> testing: matla projects have a <code>tests</code> directory where users can write tests (TLA files with a <code>.tla</code> and <code>.cfg</code> files) and specify if they are expected to be successful or to fail (and how);
</li>
<li>understand and transform TLC's output to improve user feedback, in particular when TLC yields an error (not good enough yet and is the reason we have not released yet); matla also parses and prettifies TLC's counterexample traces by formatting values, formatting states (aggregation of values), and render traces of states graphically using ASCII art.
</li>
</ul>
<h3>
<a class="anchor"></a>Rust Training at Onera<a href="https://ocamlpro.com/blog/feed#rust-training">&#9875;</a>
          </h3>
<p>The ongoing pandemic is undoubtingly impacting our professional training activities. Still, we had the opportunity to set up a Rust training session with applied researchers at ONERA during the summer. The session spanned over a week (about seven hours a day) and was our first fully remote Rust training session. We still believe on-site training (when possible) is better, full remote offers some flexibility (spreading out the training over several weeks for instance) and our experience with ONERA shows that it can work in practice with the right technology. Interestingly, it turns out that some aspects of the session actually work better with remote: hands-on exercises and projects for instance benefit from screen sharing. Discussing code with one participant is done with screen sharing, meaning all participants can follow along if they so chose.</p>
<p>Long story short, fully remote training is something we now feel confident proposing to our clients as a flexible alternative to on-site training.</p>
<h3>
<a class="anchor"></a>Audit of a Rust Blockchain Node<a href="https://ocamlpro.com/blog/feed#rust-audit">&#9875;</a>
          </h3>
<p>We participated in a contest aiming at writing a high-level specification of the (compiler for) the TON VM assembler, in particular its instructions and how they are compiled. This contest was a first step towards applying Formal Methods, and in particular formal verification, to the TON VM. We are happy to report that we finished first in this context, and are looking forward to future contests pushing Formal Methods further in the Everscale blockchain.</p>
<h2>
<a class="anchor"></a>Scaling and Verifying Blockchains<a href="https://ocamlpro.com/blog/feed#blockchains">&#9875;</a>
          </h2>
<p>
</p><div class="figure">
  <p>
    <a href="https://ocamlpro.com/blog/assets/img/chain.jpg">
      <img src="https://ocamlpro.com/blog/assets/img/chain.jpg" alt="OCamlPro is involved in several projects with high-throughput blockchains, such as EverScale and Avalanche."/>
    </a>
    </p><div class="caption">
      OCamlPro is involved in several projects with high-throughput blockchains, such as EverScale and Avalanche.
    </div>
  
</div>

<h3>
<a class="anchor"></a>From Dune Network to FreeTON/EverScale<a href="https://ocamlpro.com/blog/feed#everscale">&#9875;</a>
          </h3>
<p>In 2019-2020, we concentrated our efforts on the development of blockchains on adding new programming languages to the <a href="https://dune.network">Dune Network</a> ecosystem, in collaboration with Origin Labs. You can read more about <a href="https://ocamlpro.com/blog/2020_06_09_a_dune_love_story_from_liquidity_to_love">Love</a> and <a href="https://medium.com/dune-network/deploy-your-first-solidity-contract-on-dune-network-a96a53169a91">Solidity for Dune</a>.</p>
<p>At the end of 2020, it became clear that high-throughput was becoming a major requirement for blockchain adoption in real applications, and that the Tezos-based technology behind Dune Network could not compete with high-performance blockchains such as <a href="https://solana.com">Solana</a> or <a href="https://www.avax.network">Avalanche</a>. Following this observation, the Dune Network community decided to merge with the FreeTON community early in 2021. Initially developed by Telegram, the TON project was stopped under legal threats, but another company, <a href="https://tonlabs.io/main">TONLabs</a>, restarted the project from its open-source code under the FreeTON name, and the blockchain was launched mid-2020. FreeTON, now renamed <a href="https://everscale.network/">EverScale</a>, is today the fastest blockchain in the world, with around 55,000 transactions per second on an open network sustained during several days.</p>
<p>EverScale uses a very unique community-driven development process: contests are organized by thematic sub-governances (subgov) to improve the ecosystem, and contestants win prices in tokens to reward their high-quality work. During 2021, OCamlPro got involved in several of these sub-governances, both as a jury, in the Formal Methods subgov and the Developer Experience subgov, and a contestant winning multiple prices for the development of smart contracts (<a href="https://medium.com/ocamlpro-blockchain-fr/zk-snarks-freeton-et-ocamlpro-796adc323351">zksnarks use-cases</a>, <a href="https://github.com/OCamlPro/freeton_auctions">auctions</a> and <a href="https://github.com/OCamlPro/devex-27-recurring-payments">recurring payments</a>), the audit of several smart contracts (<a href="https://github.com/OCamlPro/formet-17-true-nft-audit">TrueNFT audit</a>, <a href="https://github.com/OCamlPro/formet-14-rsquad-smv-audit">Smart Majority Voting audit</a> and <a href="https://github.com/OCamlPro/formet-13-radiance-dex-audit">a DEX audit</a>), and the specification of some Rust components in the node (the <a href="https://formet.gov.freeton.org/submission?proposalAddress=0:91a2ecea35ee9405ccb572c577cb6ba139491b493d86191e8e46a30fdd4b01e5&amp;submissionId=5">Assembler module</a>).</p>
<p>This work in the EverScale ecosystem gave us the opportunity to develop some interesting OCaml contributions:</p>
<ul>
<li>We improved our <a href="https://github.com/OCamlPro/ocaml-solidity">ocaml-solidity</a> parser to support all the extensions of the <a href="https://solidity.readthedocs.io/en/v0.6.8/">Solidity</a> language required to parse EverScale contracts;
</li>
<li>We developed an <a href="https://github.com/OCamlPro/freeton_ocaml_sdk">OCaml binding</a> for the EverScale Rust SDK;
</li>
<li>We developed a command line <a href="https://github.com/OCamlPro/freeton_wallet">wallet called <code>ft</code></a> to help developers easily deploy the contracts and interact with them;
</li>
<li>We developed a <a href="https://gitlab.com/dune-network/ton-merge">bridge</a> between Dune Network and EverScale to swap DUN tokens into EVER tokens.
</li>
</ul>
<p><em>This work was funded by the EverScale community through contests.</em></p>
<h3>
<a class="anchor"></a>A Why3 Framework for Solidity<a href="https://ocamlpro.com/blog/feed#solidity">&#9875;</a>
          </h3>
<p>Our most recent work on the EverScale blockchain has been targetted into the development of a <a href="http://why3.lri.fr/">Why3 framework</a> to formally verify EverScale Solidity contracts. At the same time, we have been involved in the specification of several big smart contract projects, and we plan to use this framework in practice on these projects as soon as their formal verification starts.</p>
<p>We hope to be able to extend this work to EVM based Solidity contracts, as available on Ethereum and Avalanche and many other blockchains. By comparison with other frameworks that work directly on the EVM bytecode, this work focused directly on the Solidity language should make the verification much higher-level and so more straight-forward.</p>
<h2>
<a class="anchor"></a>Participations in Public Events<a href="https://ocamlpro.com/blog/feed#events">&#9875;</a>
          </h2>
<h3>
<a class="anchor"></a>Open Source Experience 2021<a href="https://ocamlpro.com/blog/feed#osxp2021">&#9875;</a>
          </h3>
<p>
</p><div class="figure">
  <p>
    <a href="https://ocamlpro.com/blog/assets/img/ospx_1.jpg">
      <img src="https://ocamlpro.com/blog/assets/img/ospx_1.jpg" alt="St&eacute;fane Fermigier (Abilian) and Pierre Baudracco (BlueMind) from Systematic Open Source Hub meet Am&eacute;lie de Montchalin (French Minister of Public Service) in front of OCamlPro's booth."/>
    </a>
    </p><div class="caption">
      St&eacute;fane Fermigier (Abilian) and Pierre Baudracco (BlueMind) from Systematic Open Source Hub meet Am&eacute;lie de Montchalin (French Minister of Public Service) in front of OCamlPro's booth.
    </div>
  
</div>

<p>We were present at the new edition of the <a href="https://www.opensource-experience.com/">Open Source Experience</a> in Paris!  Our booth welcomed our visitors to discuss tailor-made software solutions.  Fabrice had the opportunity to give a presentation on FreeTON (Now EverScale) <a href="https://www.youtube.com/watch?v=EEtE4YpWbjw">(Watch the video)</a>, the high speed blockchain he is working on. We were delighted to meet the open source community. Moreover, Am&eacute;lie de Montchalin, French Minister of Transformation and Public Service, was present to the Open Source Experience to thank all the free software actors. A very nice experience for us, we can't wait to be back in 2022!</p>
<h3>
<a class="anchor"></a>OCaml Workshop at ICFP 2021<a href="https://ocamlpro.com/blog/feed#ow2021">&#9875;</a>
          </h3>
<p>We participated in the programming competition organized by the International Conference on Functional Programming (ICFP). 3 talks we submitted to the OCaml Workshop were accepted!</p>
<ul>
<li>Fabrice, Mohamed and Louis presented <a href="https://github.com/OCamlPro/digodoc">Digodoc</a>, our new tool that builds a graph of an opam switch, associating files, libraries and opam packages into a cyclic graph of inclusions and dependencies;
</li>
<li>Fabrice spoke about <a href="https://github.com/OCamlPro/opam-bin">Opam-bin</a>, a plugin that builds binary opam packages on the fly;
</li>
<li>Lastly, Steven and David presented <strong>Love</strong>, a smart contract language embedded in the Dune Network blockchain.
It was an opportunity to present our tools and projects, and above all to discuss with the OCaml community. We're delighted to take part in this adventure every year!
</li>
</ul>
<h3>
<a class="anchor"></a>Joining the Why3 Consortium at the ProofInUse seminar<a href="https://ocamlpro.com/blog/feed#why3consortium">&#9875;</a>
          </h3>
<p>We were very happy to join the Why3 Consortium while participating the ProofinUse joint lab <a href="https://proofinuse.gitlabpages.inria.fr/meeting-2021oct21/">seminar on counterexamples</a> on October the 1st. Many thanks to Claude March&eacute; for his role as scientific shepherd.</p>
<h2>
<a class="anchor"></a>Towards 2022<a href="https://ocamlpro.com/blog/feed#next">&#9875;</a>
          </h2>
<p>
</p><div class="figure">
  <p>
    <a href="https://ocamlpro.com/blog/assets/img/towards_2022.jpeg">
      <img src="https://ocamlpro.com/blog/assets/img/towards_2022.jpeg" alt="Though 2022 is just starting, it already sounds like a great year with many new interesting and innovative projects for OCamlPro."/>
    </a>
    </p><div class="caption">
      Though 2022 is just starting, it already sounds like a great year with many new interesting and innovative projects for OCamlPro.
    </div>
  
</div>

<p>After a phase of adaptation to the health context in 2020 and a year of growth in 2021, we are motivated to start the year 2022 with new and very enriching projects, new professional encounters, leading to the growth of our teams. If you want to be part of a passionate team, we would love to hear from you! We are currently actively hiring. Check the available job positions and follow the application instructions!</p>
<p>All our amazing achievements are the result of incredible people and teamwork, kudos to Fabrice, Pierre, Louis, Vincent, Damien, Raja, Steven, Guillaume, David, Adrien, L&eacute;o, Keryan, Mohamed, Hichem, Dario, Julien, Artemiy, Nicolas, Elias, Marla, Aurore and Muriel.</p>

