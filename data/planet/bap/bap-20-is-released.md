---
title: BAP 2.0 is released
description: The Binary Analysis Platform Blog
url: http://binaryanalysisplatform.github.io/bap-2-release
date: 2019-11-19T00:00:00-00:00
preview_image:
featured:
authors:
- bap
---

<p>The Carnegie Mellon University <a href="https://github.com/BinaryAnalysisPlatform/bap">Binary Analysis Platform (CMU BAP)</a> is a suite of utilities and libraries that enables analysis of programs in their machine representation. BAP is written in OCaml, relies on dynamically loaded plugins for extensibility, and is widely used for security analysis, program verification, and reverse engineering.</p>

<p>This is a major update that includes lots of new features, libraries, and tools, as well as improvements and bug fixes to the existing code. The following small <a href="https://t.co/ylzub6LBRq?amp=1">demo</a> showcases the modern BAP look and feel.
In this announcement we would like to focus on two very important features of BAP 2.0:</p>

<ul>
  <li><a href="http://binaryanalysisplatform.github.io/bap/api/odoc/bap-knowledge/Bap_knowledge/Knowledge/index.html">knowledge representation and reasoning system</a>;</li>
  <li><a href="http://binaryanalysisplatform.github.io/bap/api/master/bap-core-theory/Bap_core_theory/index.html">the tagless final representation of program semantics</a>.</li>
</ul>

<h2>The Knowledge Base</h2>

<p>The Knowledge Representation and Reasoning System, or the Knowledge Base (KB) for short, is the central part of our new architecture. The KB is a step forward from the conventional approach to staging multiple analyses in which dependent analyses (aka passes) are ordered topologically, based on their dependencies. The KB is inspired by logic programming and enables an optimal and seamless staging of mutually dependent analyses. Mutually dependent analyses are also present in the source-based program analysis but are much more evident in the field of binary analysis and reverse engineering, where even such basic artifacts as control flow graph and call graph are not available as ground truth (and in general are not even computable).</p>

<p>Object properties in the KB are represented with directed-complete partially ordered sets.  The KB also imposes the monotonicity restriction that requires that all updates to the property are monotonic, i.e., each consequent value of the same property is a refinement of the previous value. These restrictions enable the KB to compute the least fixed point of any property,  is computed. A property representation could be optionally refined into a complete lattice, which gives the KB users extra control on how properties are computed.</p>

<p>By storing all information in an external location the KB addresses the scalability issue so relevant to binary analysis and reverse engineering. In the future, we plan to implement a distributed storage for our Knowledge Base as well as experiment with other inference engines. Soon, it should also possible to work with the knowledge base in non-OCaml programs, including our BAP Lisp dialect. That, practically, turns the knowledge base into a common runtime for binary analysis. In the current version of BAP, the Knowledge Base state is fully serializable and portable between different versions of BAP, OCaml, and even between native and bytecode runtimes. The Knowledge Base state could be imported into an application and is integrated with the BAP caching system.</p>

<h2>New Program Representation</h2>

<p>Employing the tagless final embedding together with our new Knowledge Base we were able to achieve our main goal - to switch to an extensible program representation without compromising any existing code that uses the current, non-extensible, BAP Intermediate Language (BIL). The new representation allows us to add new language features (like floating-point operations or superscalar pipeline manipulations) without breaking (or even recompiling) the existing analyses. The new representation also facilitates creation of new intermediate languages which all can coexist with each other, making it easier to write formally verified analyses.</p>

<h1>Links</h1>
<ul>
  <li><a href="https://github.com/BinaryAnalysisPlatform/bap">The Main Page</a></li>
  <li><a href="http://binaryanalysisplatform.github.io/bap/api/odoc/index.html">Documentation</a></li>
  <li><a href="https://github.com/BinaryAnalysisPlatform/bap-tutorial">The tutorial</a></li>
  <li><a href="http://binaryanalysisplatform.github.io/bap/api/lisp/index.html">Primus Lisp Documentation</a></li>
  <li><a href="https://gitter.im/BinaryAnalysisPlatform/bap">Our Chat</a></li>
  <li><a href="https://binaryanalysisplatform.github.io/">Our Blog</a></li>
  <li><a href="https://discuss.ocaml.org/t/ann-bap-2-0-release/4719">Discuss the news</a></li>
</ul>


