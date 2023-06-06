---
title: Functional Big-Data Genomics
description: Abstract High-throughput genomic sequencing is characterized by large
  diverse datasets and numerous analysis methods. It is normal for an individual bioinformatician
  to work with thousands of data ...
url: http://ashishagarwal.org/2012/09/11/functional-big-data-genomics/
date: 2012-09-11T20:11:51-00:00
preview_image: https://s0.wp.com/i/blank.jpg
featured:
authors:
- ashishagarwal
---

<p><strong>Abstract</strong><br/>
High-throughput genomic sequencing is characterized by large diverse datasets and numerous analysis methods. It is normal for an individual bioinformatician to work with thousands of data files and employ hundreds of distinct computations during the course of a single project. This problem is magnified in &ldquo;core facilities&rdquo;, which support multiple researchers working on diverse projects. Most investigators use ad hoc methods to manage this complexity with dire consequences: analyses frequently fail to meet the scientific mandate of reproducibility; improved analysis methods are often not considered because recomputing all downstream steps would be overwhelming; hard drives and CPUs are used sub-optimally; and, in some cases, raw data is lost.</p>
<p>We describe HITSCORE, an OCaml software stack that operates all computational aspects of the Genomics Core Facility at New York University&rsquo;s Center for Genomics and Systems Biology. HITSCORE has been in production use for one year, and was implemented quickly by less than two programmers following design advice from several biologists. A simple domain specific language (DSL) enables generating type safe database bindings and GUI components, and greatly eases updates and migration of our data model. We found a multi-lingual stack too burdensome in a small team setting, and credit OCaml for fulfilling the needs of our full application stack. It has good database bindings, excels at encoding complex domain logic, and now allows construction of rich websites due to the Ocsigen web programming framework. Higher level libraries for distributed computing would be a welcome improvement.</p>
<p>The opportunity to build this system did not stem directly from any strength of functional programming or OCaml. It was necessary for a person with credibility amongst biologists to champion its development, and this credibility took several years to build. Rapid development appears to be the single most important factor in allaying doubts about using a lesser known language, and we will briefly describe our experiences in bringing OCaml to several high profile projects.</p>
<p><a href="http://ashishagarwal.org/wp-content/uploads/2012/09/Functional-Big-Data-Genomics-CUFP2012.pdf" class="pdf">Download slides</a><br/>
<a href="http://www.youtube.com/watch?feature=plcp&amp;v=02YykaSMP0I" class="television">Video</a></p>
<p><strong>Citation</strong><br/>
Ashish Agarwal, Sebastien Mondet, Paul Scheid, Aviv Madar, Richard Bonneau, Jane Carlton, Kristin C. Gunsalus. Functional Big-Data Genomics. <em><a href="http://cufp.org/conference/2012">Commercial Users of Functional Programming 2012</a></em>, Copenhagen, Denmark, Sep 15, 2012.</p>

