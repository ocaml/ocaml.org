---
title: OCamlPro at the JFLA2022 Conference
description: "In today's article, we share our contributions to the 2022 JFLAs, the
  French-Speaking annual gathering on Application Programming Languages, mainly Functional
  Languages such as OCaml (Journ\xE9es Francophones des Langages Applicatifs). This
  much awaited event is organised by Inria, the French National..."
url: https://ocamlpro.com/blog/2022_07_12_ocamlpro_at_the_jfla2022
date: 2022-07-12T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    OCamlPro\n  "
source:
---

<p></p>
<div class="figure">
  <p>
    <img src="https://ocamlpro.com/blog/assets/img/picture_jfla2022_domaine_essendieras.jpg" alt=""/>
    </p><div class="caption">
      <a href="https://www.essendieras.fr/" target="_blank">
        Domaine d'Essendi&eacute;ras
      </a>, located in French Region <em>Perigord</em>, where the JFLA2022 took place!
    </div>
  
</div>
<p>In today's article, we share our contributions to the 2022 <a href="http://jfla.inria.fr/">JFLA</a>s, the French-Speaking annual gathering on Application Programming Languages, mainly Functional Languages such as OCaml (<em>Journ&eacute;es Francophones des Langages Applicatifs</em>).</p>
<p>This much awaited event is organised by <a href="https://www.inria.fr/fr">Inria</a>, the French National Institute for Research in Science and Digital Technologies.</p>
<p>This is always the best occasion for us to directly share our latest works and contributions with this diverse community of researchers, professors, students and industrial actors alike. Moreover, it allows us to meet up with all our long known peers and get in contact with an ever changing pool of actors in the fields of functional languages in general, formal methods and everything OCaml!</p>
<p>This year the three papers we submitted were selected, and this is what this article is about!</p>
<p></p><div>
<strong>Table of contents</strong>
<p><a href="https://ocamlpro.com/blog/feed#mikino">Mikino, formal verification made accessible</a></p>
<p><a href="https://ocamlpro.com/blog/feed#SWH">Connecting Software Heritage with the OCaml ecosystem</a></p>
<p><a href="https://ocamlpro.com/blog/feed#alt-ergo">Alt-Ergo-Fuzz, hunting the bugs of the bug hunter</a>
</p></div>
<h2>
<a class="anchor"></a>Mikino, formal verification made accessible<a href="https://ocamlpro.com/blog/feed#mikino">&#9875;</a>
          </h2>
<p><em>Mikino and all correlated content mentionned in this article was made by Adrien Champion</em></p>
<p>If you follow our Blog, you may have already read our <a href="https://ocamlpro.com/blog/2021_10_14_verification_for_dummies_smt_and_induction">Mikino blogpost</a>, but if you haven't here's a quick breakdown and a few pointers... In case you wish to play around or maybe contribute to the project. ;)</p>
<p>So what is Mikino ?</p>
<blockquote>
<p>Mikino is a simple induction engine over transition systems. It is written in Rust, with a strong focus on ergonomics and user-friendliness.</p>
</blockquote>
<p>Depending on what your needs are, you could either be interested in the <a href="https://crates.io/crates/mikino_api">Mikino Api</a> or the <a href="https://crates.io/crates/mikino">Mikino Binary</a> or just, for purely theoretical reasons, want to undergo our <a href="https://ocamlpro.github.io/verification_for_dummies/">Verification for Dummies: SMT and Induction</a> tutorial which is specifically tailored to appeal to the newbies of formal verification!</p>
<p>Have a go at it, learn and have fun!</p>
<p>For further reading: <a href="https://hal.inria.fr/hal-03626850/">OCamlPro's paper for the JFLA2022 (Mikino) </a> (French-written article describing the entire project).</p>
<h2>
<a class="anchor"></a>Connecting Software Heritage with the OCaml ecosystem<a href="https://ocamlpro.com/blog/feed#SWH">&#9875;</a>
          </h2>
<p><em>The archiving of OCaml packages into the SWH architecture, the release of <a href="https://github.com/OCamlPro/swhid/">swhid</a> library and the integration of SWH into opam was done by L&eacute;o Andr&egrave;s, Raja Boujbel, Louis Gesbert and Dario Pinto</em></p>
<p>Once again, if you follow our Blog, you must have seen <a href="https://www.softwareheritage.org/?lang=fr">Software Heritage</a> (SWH) mentioned in our <a href="https://ocamlpro.com/blog/2022_01_31_2021_at_ocamlpro#free_software">yearly review article</a>.</p>
<p>Now you can also look at <a href="https://hal.archives-ouvertes.fr/hal-03626845/">SWH paper by OCamlPro for the JFLA2022 (French)</a> if you are looking for a detailed explanation of how important Software Heritage is to free software as a whole, and in what manner OCamlPro contributed to this gargantuan long-term  endeavour of theirs.</p>
<p>This great collaboration was one of the highlights of last year from which arose an OCaml library called <a href="https://github.com/OCamlPro/swhid/">swhid</a> and the guaranteed perennity of all the packages found on opam.</p>
<p>The work we did to achieve this was to:</p>
<ul>
<li>add a few modules to the SWH architecture in order to store all the OCaml packages found on opam in the Library of Alexandria of open source software.
</li>
<li>release a library used for computing SWH identifiers
</li>
<li>add support in opam in order to allow a fallback on SWH architecture if a given package is missing from the <a href="https://github.com/ocaml/opam-repository">opam repository</a>
</li>
<li>patch the opam repository in order to detect already missing packages
</li>
</ul>
<h2>
<a class="anchor"></a>Alt-Ergo-Fuzz, hunting the bugs of the bug hunter<a href="https://ocamlpro.com/blog/feed#alt-ergo">&#9875;</a>
          </h2>
<p><em>The fuzzing of the SMT-Solver Alt-Ergo was done by Hichem Rami Ait El Hara, Guillaume Bury and Steven de Oliveira</em></p>
<p>As the last entry of OCamlPro's papers that have made it to this year's JFLA: a rundown of Hichem's work, guided by Guillaume and Steven, on developping a Fuzzer for <a href="https://github.com/OCamlPro/alt-ergo">Alt-Ergo</a>.</p>
<p>When it comes to critical systems, and industry-borne software, there are no limits to the requirements in safety, correctness, testing that would prove a program's reliability.</p>
<p>This is what SMT (Satisfiability Modulo Theory)-Solvers like Alt-Ergo are for: they use a complex mix of theory and implementation in order to prove, given a set of input theories, whether a program is acceptable... But SMT-Solvers, like any other program in the world, has to be searched for bugs or unwanted behaviours - this is the harsh reality of development.</p>
<p>With that in mind, Hichem sought to provide a fuzzer for Alt-Ergo to help <em>hunt the bugs of the bug hunter</em>: <a href="https://github.com/hra687261/alt-ergo-fuzz">Alt-Ergo-Fuzz</a>.</p>
<p>This tool has helped identify several bugs of unsoundness and crashes:</p>
<ul>
<li><a href="https://github.com/OCamlPro/alt-ergo/issues/474">#474</a> - Crash
</li>
<li><a href="https://github.com/OCamlPro/alt-ergo/issues/475">#475</a> - Crash
</li>
<li><a href="https://github.com/OCamlPro/alt-ergo/issues/476">#476</a> - Unsoundness
</li>
<li><a href="https://github.com/OCamlPro/alt-ergo/issues/477">#477</a> - Unsoundness
</li>
<li><a href="https://github.com/OCamlPro/alt-ergo/issues/479">#479</a> - Unsoundness
</li>
<li><a href="https://github.com/OCamlPro/alt-ergo/issues/481">#481</a> - Crash
</li>
<li><a href="https://github.com/OCamlPro/alt-ergo/issues/482">#482</a> - Crash
</li>
</ul>
<p>More details in <a href="https://hal.inria.fr/hal-03626861/">OCamlPro's paper for the JFLA2022 (Alt-Ergo-Fuzz)</a>.</p>

