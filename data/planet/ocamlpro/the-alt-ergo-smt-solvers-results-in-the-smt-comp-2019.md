---
title: "The Alt-Ergo SMT Solver\u2019s results in the SMT-COMP 2019"
description: The results of the SMT-COMP 2019 were released a few days ago at the
  SMT whorkshop during the 22nd SAT conference. We were glad to participate in this
  competition for the second year in a row, especially as Alt-Ergo now supports the
  SMT-LIB 2 standard. Alt-Ergo is an open-source SAT-solver maintaine...
url: https://ocamlpro.com/blog/2019_07_09_alt_ergo_participation_to_the_smt_comp_2019
date: 2019-07-09T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    Albin Coquereau\n  "
source:
---

<p>The results of the SMT-COMP 2019 were released a few days ago at the SMT whorkshop during the <a href="http://smt2019.galois.com/">22nd SAT conference</a>. We were glad to participate in this competition for the second year in a row, especially as Alt-Ergo <a href="https://ocamlpro.com/blog/2019_02_11_whats-new-for-alt-ergo-in-2018-here-is-a-recap">now supports</a> the SMT-LIB 2 standard.</p>
<blockquote>
<p>Alt-Ergo is an open-source SAT-solver maintained and distributed by OCamlPro and partially funded by R&amp;D projects. If you&rsquo;re interested, please consider joining the <a href="https://alt-ergo.ocamlpro.com/#club">Alt-Ergo User&rsquo;s Club</a>! Its history goes back in 2006 from early academic researches conducted conjointly at Inria &amp; CNRS &ldquo;LRI&rdquo; lab, and the maintenance and development work by OCamlPro since September 2013 (see the <a href="https://alt-ergo.ocamlpro.com/#releases">past releases</a>).</p>
<p>If you&rsquo;re curious about OCamlPro&rsquo;s other activities in Formal Methods, see a happy client&rsquo;s <a href="https://ocamlpro.com/#mitsubishi-merce">feedback</a></p>
</blockquote>
<h2>SMT-COMP 2018</h2>
<p>Our goal last year was to challenge ourselves on the community benchmarks. We wanted to compare Alt-Ergo to state-of-the-art SMT solvers. We thus selected categories close to the &ldquo;deductive program verification&rdquo;, as Alt-Ergo is primarily tuned for formulas coming from this application domain. Specifically, we took part in four main tracks categories: ALIA, AUFLIA, AUFLIRA, AUFNIRA. These categories are a combination of theories such as Arrays, Uninterpreted Function and Linear and Non-linear arithmetic over Integers and Reals.</p>
<h3>Alt-Ergo&rsquo;s Results at SMT-COMP 2018</h3>
<p>For its first participation in SMT-COMP, Alt-Ergo showed that it was a competitive solver comparing to state of the art solvers such as CVC4, Vampire, VeriT or Z3.</p>
<figure class="wp-block-table">
  <table>
    <tbody>
      <tr>
        <td>Main Track Categories (number of participants)</td>
	<td>Sequential Perfs</td>
	<td>Parallel Perfs</td>
      </tr>
      <tr>
        <td><a href="http://smtcomp.sourceforge.net/2018/results-ALIA.shtml?v=1531410683">ALIA</a> (4)</td>
	<td><img src="https://ocamlpro.com/blog/assets/img/icon_silver.png" alt="2nd place" width="24" height="24"/></td>
	<td><img src="https://ocamlpro.com/blog/assets/img/icon_bronze.png" alt="" width="24" height="24"/></td>
      </tr>
      <tr>
        <td><a href="http://smtcomp.sourceforge.net/2018/results-AUFLIA.shtml?v=1531410683">AUFLIA</a> (4)</td>
	<td><img src="https://ocamlpro.com/blog/assets/img/icon_silver.png" alt="2nd place" width="24" height="24"/></td>
	<td><img src="https://ocamlpro.com/blog/assets/img/icon_silver.png" alt="2nd place" width="24" height="24"/></td>
      </tr>
      <tr>
        <td><a href="http://smtcomp.sourceforge.net/2018/results-AUFLIRA.shtml?v=1531410683">AUFLIRA</a> (4)</td>
	<td><img src="https://ocamlpro.com/blog/assets/img/icon_silver.png" alt="2nd place" width="24" height="24"/></td>
	<td><img src="https://ocamlpro.com/blog/assets/img/icon_bronze.png" alt="" width="24" height="24"/></td>
      </tr>
      <tr>
        <td><a href="http://smtcomp.sourceforge.net/2018/results-AUFNIRA.shtml?v=1531410683">AUFNIRA</a> (3)</td>
	<td><img src="https://ocamlpro.com/blog/assets/img/icon_bronze.png" alt="" width="24" height="24"/></td>
	<td><img src="https://ocamlpro.com/blog/assets/img/icon_bronze.png" alt="" width="24" height="24"/></td>
      </tr>
    </tbody>
  </table>
</figure>
<p>The global results of the competition are available <a href="http://smtcomp.sourceforge.net/2018/results-toc.shtml">here</a>.</p>
<h2>SMT-COMP 2019</h2>
<p>Since last year&rsquo;s competition, we made some improvements on Alt-Ergo, specifically over our data structures and the support of algebraic datatypes (see <a href="http://ocamlpro.com/2019/02/11/whats-new-for-alt-ergo-in-2018-here-is-a-recap">post</a>).</p>
<p>A few changes can be noted for this year&rsquo;s competition:</p>
<ul>
<li>A distinction between SAT and UNSAT in the scoring scheme allowed us to compete in more categories, as Alt-Ergo doesn&rsquo;t send back SAT.</li><li>The aim of the 24s Scoring is to reward solvers which solve problems quickly.
</li>
<li>The number of benchmarks in each category has changed. For each category, only the benchmarks which were not proven by every solver last year are used. For example: in the division AUFLIRA, 20011 benchmarks were used last year, of which 1683 remained this year.</li>

</ul>
<p>Alt-Ergo only competed in the Single Query Track. We selected the same categories as last year and added UF, UFLIA, UFLRA and UFNIA. We also decided to compete over categories supporting algebraic DataTypes to test our newly support of this theory. Alt-Ergo&rsquo;s expertise is over quantified problems, but we wanted to test our hand in the solver theories over some Quantifier-free categories.</p>
<h3>Alt-Ergo&rsquo;s Results at SMT-COMP 2019</h3>
<p>We were proud to see Alt-Ergo performs within a reasonable margin on Quantifier Free problems comparing to other solvers over the UNSAT problems, even though these problems are not our solver&rsquo;s primary goal. And we were happy with the performance of our solver in Datatype categories, as the support of this theory is new.</p>
<p>For the last categories, Alt-Ergo managed to reproduce last year&rsquo;s performance, close to CVC4 (2018 and 2019 winner) and Vampire.</p>
<figure class="wp-block-table">
  <table>
    <tbody>
      <tr>
        <td>Single Query Categories<br/>(number of participants)</td>
	<td>Sequential</td>
	<td>Parallel</td>
	<td>Unsat</td>
	<td>24s</td>
      </tr>
      <tr>
        <td><a href="https://smt-comp.github.io/2019/results/alia-single-query">ALIA</a> (8)</td>
	<td><img src="https://ocamlpro.com/blog/assets/img/icon_bronze.png" alt="" width="24" height="24"/></td>
	<td><img src="https://ocamlpro.com/blog/assets/img/icon_bronze.png" alt="" width="24" height="24"/></td>
	<td><img src="https://ocamlpro.com/blog/assets/img/icon_gold.png" alt="" width="33" height="33"/></td>
	<td><img src="https://ocamlpro.com/blog/assets/img/icon_silver.png" alt="" width="24" height="24"/></td>
      </tr>
      <tr>
        <td><a href="https://smt-comp.github.io/2019/results/auflia-single-query">AUFLIA</a> (8)</td>
      	<td><img src="https://ocamlpro.com/blog/assets/img/icon_bronze.png" alt="" width="24" height="24"/></td>
	<td><img src="https://ocamlpro.com/blog/assets/img/icon_bronze.png" alt="" width="24" height="24"/></td>
	<td><img src="https://ocamlpro.com/blog/assets/img/icon_bronze.png" alt="" width="24" height="24"/></td>
	<td><img src="https://ocamlpro.com/blog/assets/img/icon_bronze.png" alt="" width="24" height="24"/></td>
      </tr>
      <tr>
        <td><a href="https://smt-comp.github.io/2019/results/auflira-single-query">AUFLIRA</a> (8)</td>
	<td><img src="https://ocamlpro.com/blog/assets/img/icon_bronze.png" alt="" width="24" height="24"/></td>
	<td><img src="https://ocamlpro.com/blog/assets/img/icon_bronze.png" alt="" width="24" height="24"/></td>
	<td><img src="https://ocamlpro.com/blog/assets/img/icon_bronze.png" alt="" width="24" height="24"/></td>
	<td><img src="https://ocamlpro.com/blog/assets/img/icon_bronze.png" alt="" width="24" height="24"/></td>
      </tr>
      <tr>
        <td><a href="https://smt-comp.github.io/2019/results/aufnira-single-query">AUFNIRA</a> (5)</td>
	<td><img src="https://ocamlpro.com/blog/assets/img/icon_bronze.png" alt="" width="24" height="24"/></td>
	<td><img src="https://ocamlpro.com/blog/assets/img/icon_bronze.png" alt="" width="24" height="24"/></td>
	<td><img src="https://ocamlpro.com/blog/assets/img/icon_bronze.png" alt="" width="24" height="24"/></td>
	<td><img src="https://ocamlpro.com/blog/assets/img/icon_silver.png" alt="" width="24" height="24"/></td>
      </tr>
      <tr>
        <td><a href="https://smt-comp.github.io/2019/results/uf-single-query">UF</a> (8)</td>
	<td><img src="http://ocamlpro.com/wp-content/uploads/2019/07/Copper.png" alt="" width="24" height="24"/></td>
	<td><img src="http://ocamlpro.com/wp-content/uploads/2019/07/Copper.png" alt="" width="24" height="24"/></td>
	<td><img src="http://ocamlpro.com/wp-content/uploads/2019/07/Copper.png" alt="" width="24" height="24"/></td>
	<td><img src="http://ocamlpro.com/wp-content/uploads/2019/07/Copper.png" alt="" width="24" height="24"/></td>
      </tr>
      <tr>
	<td><a href="https://smt-comp.github.io/2019/results/uflia-single-query">UFLIA</a> (8)</td>
	<td><img src="http://ocamlpro.com/wp-content/uploads/2019/07/Copper.png" alt="" width="24" height="24"/></td>
	<td><img src="http://ocamlpro.com/wp-content/uploads/2019/07/Copper.png" alt="" width="24" height="24"/></td>
	<td><img src="http://ocamlpro.com/wp-content/uploads/2019/07/Copper.png" alt="" width="24" height="24"/></td>
	<td><img src="https://ocamlpro.com/blog/assets/img/icon_bronze.png" alt="" width="24" height="24"/></td>
      </tr>
      <tr>
	<td><a href="https://smt-comp.github.io/2019/results/uflra-single-query">UFLRA</a> (8)</td>
	<td><img src="https://ocamlpro.com/blog/assets/img/icon_gold.png" alt="" width="33" height="33"/></td>
	<td><img src="https://ocamlpro.com/blog/assets/img/icon_gold.png" alt="" width="33" height="33"/></td>
	<td><img src="https://ocamlpro.com/blog/assets/img/icon_bronze.png" alt="" width="24" height="24"/></td>
	<td><img src="https://ocamlpro.com/blog/assets/img/icon_gold.png" alt="" width="33" height="33"/></td>
      </tr>
      <tr>
	<td><a href="https://smt-comp.github.io/2019/results/ufnia-single-query">UFNIA</a> (8)</td>
	<td><img src="https://ocamlpro.com/blog/assets/img/icon_bronze.png" alt="" width="24" height="24"/></td>
	<td><img src="https://ocamlpro.com/blog/assets/img/icon_bronze.png" alt="" width="24" height="24"/></td>
	<td><img src="https://ocamlpro.com/blog/assets/img/icon_bronze.png" alt="" width="24" height="24"/></td>
	<td><img src="https://ocamlpro.com/blog/assets/img/icon_bronze.png" alt="" width="24" height="24"/></td>
      </tr>
    </tbody>
  </table>
</figure>
<p>This year results are available <a href="https://smt-comp.github.io/2019/results.html">here</a>. These results do not include Par4 a portfolio solver.</p>
<p>Alt-Ergo is constantly evolving, as well as our support of the SMT-LIB standard. For next year&rsquo;s participation, we will try to compete in more categories and hope to cover more tracks, such as the UNSAT-Core track.</p>
<p><img src="https://ocamlpro.com/assets/img/logo_altergo.png" alt=""/></p>

