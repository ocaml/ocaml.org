---
title: A History of OCaml
description: The origins and evolution of the OCaml programming language.
meta_title: A History of OCaml
meta_description: Learn about the history of OCaml, from its origins as Caml at INRIA in the 1980s to the modern OCaml language.
---

"Caml" was originally an acronym for _Categorical Abstract Machine Language_. It was a pun on CAM, the Categorical Abstract Machine, and ML, the family of programming languages to which Caml belongs. The name Caml has outlived the Categorical Abstract Machine, which is no longer used since the implementation called Caml Light.

## The Prehistory

The Formel team at [INRIA](http://www.inria.fr/) started to be interested in the ML language in 1980–1981. ML was the _meta-language_ of the Edinburgh version of the LCF proof assistant, both designed by [Robin Milner](http://www.cl.cam.ac.uk/archive/rm135/). It was implemented by a kind of interpreter written in Lisp by [Gérard Huet](http://cristal.inria.fr/~huet/) and [Guy Cousineau](http://www.pps.univ-paris-diderot.fr/~cousinea/) in 1981. Although this implementation was rather simple, it was difficult to adapt it to the various Lisp systems existing at that time. Hence, Ascánder Suárez rebuilt the implementation in 1984 to make it compatible with various Lisp compilers (MacLisp, FranzLisp, LeLisp, ZetaLisp). This implementation also included a compiler. Guy Cousineau added algebraic data types and pattern-matching, inspired by Robin Milner's ideas and by the Hope programming language by [Rod Burstall](https://en.wikipedia.org/wiki/Rod_Burstall) and [Dave MacQueen](https://cs.uchicago.edu/people/dave-macqueen/).

Around 1984, three events contributed to increasing the interest of the Formel team in the ML language:

1. In Edinburgh, [Luca Cardelli](http://lucacardelli.name/) developed a much faster implementation of ML using his _Functional Abstract Machine (FAM)_. The FAM was also used by Dave MacQueen for the development of Standard ML, and it was adopted by the Formel team in an attempt to write an ML compiler based on it.
2. [Pierre-Louis Curien](http://www.pps.univ-paris-diderot.fr/~curien/) developed a categorical combinatory logic-based method of compilation that could be applied to ML, leading to the _Categorical Abstract Machine (CAM)_.
3. Robin Milner proposed to the functional programming community a standard definition for ML, with the goal of ending the divergence between various implementations of the language.

## The First Caml Implementation

Between 1984 and 1987, Pierre-Louis Curien, Ascánder Suárez, and Guy Cousineau designed and implemented the first complete Caml implementation, called Caml V3.1. This implementation compiled Caml to bytecode that was then interpreted by the CAM. Ascánder Suárez developed this implementation using LeLisp, while more and more enhancements were suggested by his colleagues: a module and functor system, by Ascánder Suárez himself; symbolic handling of expressions, by Jean Vuillemin; and static type reconstruction, by [Pierre Weis](https://dblp.org/pid/90/78.html).

Caml V3.1 was distributed free of charge to the public starting in 1987. Despite its slow and resource-hungry nature, and the lack of a built-in system to handle separate compilation, it gained significant popularity.

This implementation was nicknamed "Heavy Caml" because of its high memory and CPU requirements. After Ascánder Suárez's departure in 1988, Pierre Weis and [Michel Mauny](http://cristal.inria.fr/~mauny/) continued the development, making several language extensions (records with labels, classes and objects, persistent values) and improving the implementation (separate compilation). They also wrote the first book on Caml: _The Caml Language_ (Dunod, 1993), a French version of which was published by INRIA in 1991.

## Caml Light

In 1990 and 1991, [Xavier Leroy](http://cristal.inria.fr/~xleroy/) designed a completely new implementation of Caml, called Caml Light, based on a bytecode interpreter written in C. [Damien Doligez](http://cristal.inria.fr/~doligez/) contributed his excellent memory management system. This new implementation was much more efficient than the "Heavy Caml" system, while providing nearly full backwards compatibility. Caml Light was highly portable and was able to run even on small desktop machines like the Macs and PCs of that era. It replaced "Heavy Caml" and highly increased the popularity of Caml in educational and research communities.

In 1995, Caml Light was extended with mutable data types and exception handling, and full support for separate compilation was added.

## Caml Special Light

In 1995, Xavier Leroy released Caml Special Light, a new major evolution of Caml. In addition to an optimising native-code compiler based on a novel intermediate code representation and producing code whose performance was competitive with mainstream compilers such as GCC, this system featured a high-level module system much in the spirit of Standard ML but providing better support for separate compilation.

## Objective Caml

Type-theoretic work by [Didier Rémy](http://cristal.inria.fr/~remy/) and [Jérôme Vouillon](http://www.pps.univ-paris-diderot.fr/~vouillon/) enabled full integration of object-oriented features into the type system of the language. This led to the release of Objective Caml in 1996. Objective Caml was the first language to combine the full power of object-oriented programming with an ML-style polymorphic type system and type inference.

The year 2000 saw the addition of several new features by [Jacques Garrigue](http://www.math.nagoya-u.ac.jp/~garrigue/): optional arguments and polymorphic variants, with a number of other enhancements. At that time, Objective Caml started to find industrial users in addition to its traditional academic user base.

In 2011, the official name of the language became OCaml.

## OCaml Today

OCaml continues to evolve and gain popularity in both academic and industrial settings. Some notable developments:

- The OCaml 4.0 release in 2012 added Generalized Algebraic Data Types (GADTs) and first-class modules, increasing the expressiveness of the language.
- The OCaml Platform, an integrated set of development tools, has matured over the years, making OCaml development more accessible.
- The OCaml 5.0 release in 2022 was a major milestone: a complete rewrite of the language runtime, removing the global GC lock and adding effect handlers via delimited continuations. These changes enable support for shared-memory parallelism and new approaches to concurrency.

OCaml's development continues within the [Cambium](https://cambium.inria.fr/) team at INRIA (previously known as [Cristal](http://cristal.inria.fr/), and [Gallium](http://gallium.inria.fr/)). The language has found significant adoption in industry for applications ranging from static analysis tools, compilers, financial systems, and web development.
