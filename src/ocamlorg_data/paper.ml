
  type link = { description : string; uri : string }

type t =
  { title : string
  ; slug : string
  ; publication : string
  ; authors : string list
  ; abstract : string
  ; tags : string list
  ; year : int
  ; links : link list
  ; featured : bool
  }
  
let all = 
[
  { title = {js|The ZINC experiment, an Economical Implementation of the ML language|js}
  ; slug = {js|the-zinc-experiment-an-economical-implementation-of-the-ml-language|js}
  ; publication = {js|Technical report 117, INRIA|js}
  ; authors = 
 [{js|Xavier Leroy|js}]
  ; abstract = {js|This report contains a abstract of the ZINC compiler, which later evolved into Caml Light, then into OCaml. Large parts  of this report are out of date, but it is still valuable as a abstract of the abstract machine used in Caml Light and  (with some further simplifications and speed improvements) in OCaml.
|js}
  ; tags = 
 [{js|compiler|js}; {js|runtime|js}]
  ; year = 1990
  ; links = [
        { description = {js|Download PDF|js}
        ; uri = {js|https://caml.inria.fr/pub/papers/xleroy-zinc.pdf|js}
        };
                                                                  
        { description = {js|Download PostScript|js}
        ; uri = {js|https://caml.inria.fr/pub/papers/xleroy-zinc.ps.gz|js}
        }]
  ; featured = false
  };
 
  { title = {js|A Concurrent, Generational Garbage Collector for a Multithreaded Implementation of ML|js}
  ; slug = {js|a-concurrent-generational-garbage-collector-for-a-multithreaded-implementation-of-ml|js}
  ; publication = {js|Principles of Programming Languages|js}
  ; authors = 
 [{js|Damien Doligez|js}; {js|Xavier Leroy|js}]
  ; abstract = {js|Superseded by "Portable, Unobtrusive Garbage Collection for Multiprocessor Systems"
|js}
  ; tags = 
 [{js|garbage collection|js}; {js|runtime|js}]
  ; year = 1993
  ; links = 
 [
        { description = {js|Download PDF|js}
        ; uri = {js|https://caml.inria.fr/pub/papers/doligez_xleroy-concurrent_gc-popl93.pdf|js}
        };
  
        { description = {js|Download PostScript|js}
        ; uri = {js|https://caml.inria.fr/pub/papers/doligez_xleroy-concurrent_gc-popl93.ps.gz|js}
        }]
  ; featured = false
  };
 
  { title = {js|A Syntactic Approach to Type Soundness|js}
  ; slug = {js|a-syntactic-approach-to-type-soundness|js}
  ; publication = {js|Information & Computation, 115(1):38−94|js}
  ; authors = 
 [{js|Andrew K. Wright|js}; {js|Matthias Felleisen|js}]
  ; abstract = {js|This paper describes the semantics and the type system of Core ML,  and uses a simple syntactic technique to prove that well-typed programs cannot go wrong.
|js}
  ; tags = 
 [{js|core|js}; {js|language|js}]
  ; year = 1994
  ; links = [
        { description = {js|Download PostScript|js}
        ; uri = {js|https://www.cs.rice.edu/CS/PLT/Publications/Scheme/ic94-wf.ps.gz|js}
        }]
  ; featured = false
  };
 
  { title = {js|Manifest Types, Modules, and Separate Compilation|js}
  ; slug = {js|manifest-types-modules-and-separate-compilation|js}
  ; publication = {js|Principles of Programming Languages|js}
  ; authors = 
 [{js|Xavier Leroy|js}]
  ; abstract = {js|This paper presents a variant of the Standard ML module system that introduces a strict distinction between abstract  and manifest types. The latter are types whose definitions explicitly appear as part of a module interface. This proposal  is meant to retain most of the expressive power of the Standard ML module system, while providing much better support for  separate compilation. This work sets the formal bases for OCaml's module system.
|js}
  ; tags = 
 [{js|core|js}; {js|language|js}; {js|modules|js}]
  ; year = 1994
  ; links = 
 [
        { description = {js|Download PDF|js}
        ; uri = {js|https://caml.inria.fr/pub/papers/xleroy-manifest_types-popl94.pdf|js}
        };
  
        { description = {js|Download PostScript|js}
        ; uri = {js|https://caml.inria.fr/pub/papers/xleroy-manifest_types-popl94.ps.gz|js}
        };
  
        { description = {js|Download DVI|js}
        ; uri = {js|https://caml.inria.fr/pub/papers/xleroy-manifest_types-popl94.dvi.gz|js}
        }]
  ; featured = false
  };
 
  { title = {js|Portable, Unobtrusive Garbage Collection for Multiprocessor Systems|js}
  ; slug = {js|portable-unobtrusive-garbage-collection-for-multiprocessor-systems|js}
  ; publication = {js|Principles of Programming Languages|js}
  ; authors = 
 [{js|Damien Doligez|js}; {js|Georges Gonthier|js}]
  ; abstract = {js|This paper describes a concurrent version of the garbage collector found in Caml Light and OCaml's runtime system.
|js}
  ; tags = 
 [{js|garbage collection|js}; {js|runtime|js}]
  ; year = 1994
  ; links = 
 [
        { description = {js|Download PDF|js}
        ; uri = {js|https://caml.inria.fr/pub/papers/doligez_gonthier-gc-popl94.pdf|js}
        };
  
        { description = {js|Download PostScript|js}
        ; uri = {js|https://caml.inria.fr/pub/papers/doligez_gonthier-gc-popl94.ps.gz|js}
        }]
  ; featured = false
  };
 
  { title = {js|Applicative Functors and Fully Transparent Higher-order Modules|js}
  ; slug = {js|applicative-functors-and-fully-transparent-higher-order-modules|js}
  ; publication = {js|Principles of Programming Languages|js}
  ; authors = 
 [{js|Xavier Leroy|js}]
  ; abstract = {js|This work extends the above paper by introducing so-called applicative functors, that is, functors that produce compatible  abstract types when applied to provably equal arguments. Applicative functors are also a feature of OCaml.
|js}
  ; tags = 
 [{js|core|js}; {js|language|js}; {js|modules|js}]
  ; year = 1995
  ; links = 
 [
        { description = {js|Download PDF|js}
        ; uri = {js|https://caml.inria.fr/pub/papers/xleroy-applicative_functors-popl95.pdf|js}
        };
  
        { description = {js|Download PostScript|js}
        ; uri = {js|https://caml.inria.fr/pub/papers/xleroy-applicative_functors-popl95.ps.gz|js}
        };
  
        { description = {js|Download DVI|js}
        ; uri = {js|https://caml.inria.fr/pub/papers/xleroy-applicative_functors-popl95.dvi.gz|js}
        }]
  ; featured = false
  };
 
  { title = {js|Conception, réalisation et certification d'un glaneur de cellules concurrent|js}
  ; slug = {js|conception-ralisation-et-certification-dun-glaneur-de-cellules-concurrent|js}
  ; publication = {js|Ph.D. thesis, Université Paris 7|js}
  ; authors = 
 [{js|Damien Doligez|js}; {js|Georges Gonthier|js}]
  ; abstract = {js|All you ever wanted to know about the garbage collector found in Caml Light and OCaml's runtime system.
|js}
  ; tags = 
 [{js|garbage collection|js}; {js|runtime|js}]
  ; year = 1995
  ; links = 
 [
        { description = {js|Download PDF|js}
        ; uri = {js|https://caml.inria.fr/pub/papers/doligez-these.pdf|js}
        };
  
        { description = {js|Download PostScript|js}
        ; uri = {js|https://caml.inria.fr/pub/papers/doligez-these.ps.gz|js}
        }]
  ; featured = false
  };
 
  { title = {js|The Effectiveness of Type-based Unboxing|js}
  ; slug = {js|the-effectiveness-of-type-based-unboxing|js}
  ; publication = {js|Workshop on Types in Compilation|js}
  ; authors = 
 [{js|Xavier Leroy|js}]
  ; abstract = {js|This paper surveys and compares several data representation strategies, including the one used in the OCaml native-code compiler.
|js}
  ; tags = 
 [{js|compiler|js}; {js|runtime|js}]
  ; year = 1997
  ; links = [
        { description = {js|Download PDF|js}
        ; uri = {js|https://caml.inria.fr/pub/papers/xleroy-unboxing-tic97.pdf|js}
        };
                                                                  
        { description = {js|Download PostScript|js}
        ; uri = {js|https://caml.inria.fr/pub/papers/xleroy-unboxing-tic97.ps.gz|js}
        }]
  ; featured = false
  };
 
  { title = {js|Objective ML: An effective object-oriented extension to ML|js}
  ; slug = {js|objective-ml-an-effective-object-oriented-extension-to-ml|js}
  ; publication = {js|Theory And Practice of Objects Systems, 4(1):27−50|js}
  ; authors = 
 [{js|Didier Rémy|js}; {js|Jérôme Vouillon|js}]
  ; abstract = {js|This paper provides theoretical foundations for OCaml's object-oriented layer, including dynamic and static semantics.
|js}
  ; tags = 
 [{js|core|js}; {js|language|js}; {js|objects|js}]
  ; year = 1998
  ; links = 
 [
        { description = {js|Download PDF|js}
        ; uri = {js|https://caml.inria.fr/pub/papers/remy_vouillon-objective_ml-tapos98.pdf|js}
        };
  
        { description = {js|Download PostScript|js}
        ; uri = {js|https://caml.inria.fr/pub/papers/remy_vouillon-objective_ml-tapos98.ps.gz|js}
        };
  
        { description = {js|Download DVI|js}
        ; uri = {js|https://caml.inria.fr/pub/papers/remy_vouillon-objective_ml-tapos98.dvi.gz|js}
        }]
  ; featured = false
  };
 
  { title = {js|Programming with Polymorphic Variants|js}
  ; slug = {js|programming-with-polymorphic-variants|js}
  ; publication = {js|ML Workshop|js}
  ; authors = 
 [{js|Jacques Garrigue|js}]
  ; abstract = {js|This paper briefly explains what polymorphic variants are about and how they are compiled.
|js}
  ; tags = 
 [{js|core|js}; {js|language|js}; {js|polymorphic variants|js}]
  ; year = 1998
  ; links = 
 [
        { description = {js|Download PDF|js}
        ; uri = {js|https://caml.inria.fr/pub/papers/garrigue-polymorphic_variants-ml98.pdf|js}
        };
  
        { description = {js|Download PostScript|js}
        ; uri = {js|https://caml.inria.fr/pub/papers/garrigue-polymorphic_variants-ml98.ps.gz|js}
        }]
  ; featured = false
  };
 
  { title = {js|Extending ML with Semi-Explicit Higher-Order Polymorphism|js}
  ; slug = {js|extending-ml-with-semi-explicit-higher-order-polymorphism|js}
  ; publication = {js|Information & Computation, 155(1/2):134−169|js}
  ; authors = 
 [{js|Jacques Garrigue|js}; {js|Didier Rémy|js}]
  ; abstract = {js|This paper proposes a device for re-introducing first-class polymorphic values into ML while preserving its type inference  mechanism. This technology underlies OCaml's polymorphic methods.
|js}
  ; tags = 
 [{js|core|js}; {js|language|js}; {js|objects|js}]
  ; year = 1999
  ; links = 
 [
        { description = {js|Download PDF|js}
        ; uri = {js|https://caml.inria.fr/pub/papers/garrigue_remy-poly-ic99.pdf|js}
        };
  
        { description = {js|Download PostScript|js}
        ; uri = {js|https://caml.inria.fr/pub/papers/garrigue_remy-poly-ic99.ps.gz|js}
        };
  
        { description = {js|Download DVI|js}
        ; uri = {js|https://caml.inria.fr/pub/papers/garrigue_remy-poly-ic99.dvi.gz|js}
        }]
  ; featured = false
  };
 
  { title = {js|A Modular Module System|js}
  ; slug = {js|a-modular-module-system|js}
  ; publication = {js|Journal of Functional Programming, 10(3):269-303|js}
  ; authors = 
 [{js|Xavier Leroy|js}]
  ; abstract = {js|This accessible paper describes a simplified implementation of the OCaml module system, emphasizing the fact that the module system  is largely independent of the underlying core language. This is a good tutorial to learn both how modules can be used and how  they are typechecked.
|js}
  ; tags = 
 [{js|core|js}; {js|language|js}; {js|modules|js}]
  ; year = 2000
  ; links = 
 [
        { description = {js|Download PDF|js}
        ; uri = {js|https://caml.inria.fr/pub/papers/xleroy-modular_modules-jfp.pdf|js}
        };
  
        { description = {js|Download PostScript|js}
        ; uri = {js|https://caml.inria.fr/pub/papers/xleroy-modular_modules-jfp.ps.gz|js}
        };
  
        { description = {js|Download DVI|js}
        ; uri = {js|https://caml.inria.fr/pub/papers/xleroy-modular_modules-jfp.dvi.gz|js}
        }]
  ; featured = false
  };
 
  { title = {js|Code Reuse through Polymorphic Variants|js}
  ; slug = {js|code-reuse-through-polymorphic-variants|js}
  ; publication = {js|Workshop on Foundations of Software Engineering|js}
  ; authors = 
 [{js|Jacques Garrigue|js}]
  ; abstract = {js|This short paper explains how to design a modular, extensible interpreter using polymorphic variants.
|js}
  ; tags = 
 [{js|core|js}; {js|language|js}; {js|polymorphic variants|js}]
  ; year = 2000
  ; links = 
 [
        { description = {js|Download PostScript|js}
        ; uri = {js|https://caml.inria.fr/pub/papers/garrigue-variant-reuse-2000.ps.gz|js}
        }]
  ; featured = false
  };
 
  { title = {js|Labeled and Optional Arguments for Objective Caml|js}
  ; slug = {js|labeled-and-optional-arguments-for-objective-caml|js}
  ; publication = {js|JSSST Workshop on Programming and Programming Languages|js}
  ; authors = 
 [{js|Jacques Garrigue|js}]
  ; abstract = {js|This paper offers a dynamic semantics, a static semantics, and a compilation scheme for OCaml's labeled  and optional function parameters.
|js}
  ; tags = 
 [{js|core|js}; {js|language|js}]
  ; year = 2001
  ; links = [
        { description = {js|Download PDF|js}
        ; uri = {js|https://caml.inria.fr/pub/papers/garrigue-labels-ppl01.pdf|js}
        };
                                                               
        { description = {js|Download PostScript|js}
        ; uri = {js|https://caml.inria.fr/pub/papers/garrigue-labels-ppl01.ps.gz|js}
        };
                                                               
        { description = {js|Download DVI|js}
        ; uri = {js|https://caml.inria.fr/pub/papers/garrigue-labels-ppl01.dvi.gz|js}
        }]
  ; featured = false
  };
 
  { title = {js|Optimizing Pattern Matching|js}
  ; slug = {js|optimizing-pattern-matching|js}
  ; publication = {js|Proceedings of the sixth ACM SIGPLAN International Conference on Functional Programming (ICFP)|js}
  ; authors = 
 [{js|Fabrice Le Fessant|js}; {js|Luc Maranget|js}]
  ; abstract = {js|All you ever wanted to know about the garbage collector found in Caml Light and OCaml's runtime system.
|js}
  ; tags = 
 [{js|pattern-matching|js}; {js|runtime|js}]
  ; year = 2001
  ; links = 
 [
        { description = {js|View Online|js}
        ; uri = {js|https://dl.acm.org/citation.cfm?id=507641|js}
        }]
  ; featured = false
  };
 
  { title = {js|Simple Type Inference for Structural Polymorphism|js}
  ; slug = {js|simple-type-inference-for-structural-polymorphism|js}
  ; publication = {js|Workshop on Foundations of Object-Oriented Languages|js}
  ; authors = 
 [{js|Jacques Garrigue|js}]
  ; abstract = {js|This paper explains most of the typechecking machinery behind polymorphic variants.  At its heart is an extension of Core ML's type discipline with so-called local constraints.
|js}
  ; tags = 
 [{js|core|js}; {js|language|js}; {js|polymorphic variants|js}]
  ; year = 2002
  ; links = 
 [
        { description = {js|Download PDF|js}
        ; uri = {js|https://caml.inria.fr/pub/papers/garrigue-structural_poly-fool02.pdf|js}
        };
  
        { description = {js|Download PostScript|js}
        ; uri = {js|https://caml.inria.fr/pub/papers/garrigue-structural_poly-fool02.ps.gz|js}
        }]
  ; featured = false
  };
 
  { title = {js|A Proposal for Recursive Modules in Objective Caml|js}
  ; slug = {js|a-proposal-for-recursive-modules-in-objective-caml|js}
  ; publication = {js|Unpublication|js}
  ; authors = 
 [{js|Xavier Leroy|js}]
  ; abstract = {js|This note describes the experimental recursive modules introduced in OCaml 3.07.
|js}
  ; tags = 
 [{js|core|js}; {js|language|js}; {js|modules|js}]
  ; year = 2003
  ; links = 
 [
        { description = {js|Download PDF|js}
        ; uri = {js|https://caml.inria.fr/pub/papers/xleroy-recursive_modules-03.pdf|js}
        };
  
        { description = {js|Download PostScript|js}
        ; uri = {js|https://caml.inria.fr/pub/papers/xleroy-recursive_modules-03.ps.gz|js}
        }]
  ; featured = false
  };
 
  { title = {js|Relaxing the value restriction|js}
  ; slug = {js|relaxing-the-value-restriction|js}
  ; publication = {js|International Symposium on Functional and Logic Programming|js}
  ; authors = 
 [{js|Jacques Garrigue|js}]
  ; abstract = {js|This paper explains why it is sound to generalize certain type variables at a `let` binding, even when the expression that is being `let`-bound is not a value. This relaxed version of Wright's classic “value restriction” was introduced in OCaml 3.07.
|js}
  ; tags = 
 [{js|core|js}; {js|language|js}]
  ; year = 2004
  ; links = [
        { description = {js|Download PDF|js}
        ; uri = {js|https://caml.inria.fr/pub/papers/garrigue-value_restriction-fiwflp04.pdf|js}
        };
                                                               
        { description = {js|Download PostScript|js}
        ; uri = {js|https://caml.inria.fr/pub/papers/garrigue-value_restriction-fiwflp04.ps.gz|js}
        }]
  ; featured = false
  };
 
  { title = {js|Typing Deep Pattern-matching in Presence of Polymorphic Variants|js}
  ; slug = {js|typing-deep-pattern-matching-in-presence-of-polymorphic-variants|js}
  ; publication = {js|JSSST Workshop on Programming and Programming Languages|js}
  ; authors = 
 [{js|Jacques Garrigue|js}]
  ; abstract = {js|This paper provides more details about the technical machinery behind polymorphic variants, focusing  on the rules for typechecking deep pattern matching constructs.
|js}
  ; tags = 
 [{js|core|js}; {js|language|js}; {js|polymorphic variants|js}]
  ; year = 2004
  ; links = 
 [
        { description = {js|Download PDF|js}
        ; uri = {js|https://caml.inria.fr/pub/papers/garrigue-deep-variants-2004.pdf|js}
        };
  
        { description = {js|Download PostScript|js}
        ; uri = {js|https://caml.inria.fr/pub/papers/garrigue-deep-variants-2004.ps.gz|js}
        }]
  ; featured = false
  };
 
  { title = {js|The Essence of ML Type Inference|js}
  ; slug = {js|the-essence-of-ml-type-inference|js}
  ; publication = {js|Benjamin C. Pierce, editor, Advanced Topics in Types and Programming Languages, MIT Press|js}
  ; authors = 
 [{js|François Pottier|js}; {js|Didier Rémy|js}]
  ; abstract = {js|This book chapter gives an in-depth abstract of the Core ML type system, with an emphasis on type inference.  The type inference algorithm is described as the composition of a constraint generator, which produces a system  of type equations, and a constraint solver, which is presented as a set of rewrite rules.
|js}
  ; tags = 
 [{js|core|js}; {js|language|js}]
  ; year = 2005
  ; links = [
        { description = {js|Download PostScript|js}
        ; uri = {js|https://cristal.inria.fr/attapl/preversion.ps.gz|js}
        }]
  ; featured = false
  };
 
  { title = {js|Xen and the Art of OCaml|js}
  ; slug = {js|xen-and-the-art-of-ocaml|js}
  ; publication = {js|Commercial Users of Functional Programming (CUFP)|js}
  ; authors = 
 [{js|Anil Madhavapeddy|js}]
  ; abstract = {js|In this talk, we will firstly describe the architecture of XenServer and the XenAPI and discuss the challenges faced with implementing  an Objective Caml based solution. These challenges range from the low-level concerns of interfacing with Xen and the  Linux kernel, to the high-level algorithmic problems such as distributed failure planning. In addition, we will  discuss the challenges imposed by using OCaml in a commercial environment, such as supporting product upgrades,  enhancing supportability and scaling the development team.
|js}
  ; tags = 
 [{js|industrial|js}; {js|application|js}]
  ; year = 2008
  ; links = 
 [
        { description = {js|Download PDF|js}
        ; uri = {js|https://cufp.org/archive/2008/slides/MadhavapeddyAnil.pdf|js}
        }]
  ; featured = false
  };
 
  { title = {js|Meta-programming Tutorial with CamlP4|js}
  ; slug = {js|meta-programming-tutorial-with-camlp4|js}
  ; publication = {js|Commercial Users of Functional Programming|js}
  ; authors = 
 [{js|Jake Donham|js}]
  ; abstract = {js|Meta-programming tutorial with Camlp4|js}
  ; tags = 
 [{js|core|js}; {js|language|js}]
  ; year = 2010
  ; links = [
        { description = {js|View Online|js}
        ; uri = {js|https://github.com/jaked/cufp-metaprogramming-tutorial|js}
        }]
  ; featured = false
  };
 
  { title = {js|OCaml for the Masses|js}
  ; slug = {js|ocaml-for-the-masses|js}
  ; publication = {js|ACM Queue|js}
  ; authors = 
 [{js|Yaron Minsky|js}]
  ; abstract = {js|Why the next language you learn should be functional.
|js}
  ; tags = 
 [{js|industrial|js}]
  ; year = 2011
  ; links = [
        { description = {js|View Online|js}
        ; uri = {js|https://queue.acm.org/detail.cfm?id=2038036|js}
        }]
  ; featured = false
  };
 
  { title = {js|Eff Directly in OCaml|js}
  ; slug = {js|eff-directly-in-ocaml|js}
  ; publication = {js|Open Publishing Association|js}
  ; authors = 
 [{js|Oleg Kiselyov|js}; {js|KC Sivaramakrishnan|js}]
  ; abstract = {js|The language Eff is an OCaml-like language serving as a prototype implementation of the theory of algebraic effects, intended for experimentation with algebraic effects on a large scale. We present the embedding of Eff into OCaml, using the library of delimited continuations or the multicore OCaml branch. We demonstrate the correctness of the embedding denotationally, relying on the tagless-final-style interpreter-based denotational semantics, including the novel, direct denotational semantics of multi-prompt delimited control. The embedding is systematic, lightweight, performant and supports even higher-order, 'dynamic' effects with their polymorphism. OCaml thus may be regarded as another implementation of Eff, broadening the scope and appeal of that language.
|js}
  ; tags = 
 [{js|ocaml-workshop|js}; {js|core|js}; {js|language|js}]
  ; year = 2016
  ; links = 
 [
        { description = {js|Download PDF|js}
        ; uri = {js|https://arxiv.org/pdf/1812.11664.pdf|js}
        }]
  ; featured = true
  };
 
  { title = {js|A memory model for multicore OCaml|js}
  ; slug = {js|a-memory-model-for-multicore-ocaml|js}
  ; publication = {js|International Conference on Functional Programming (ICFP)|js}
  ; authors = 
 [{js|Stephen Dolan|js}; {js|KC Sivaramakrishnan|js}]
  ; abstract = {js|We propose a memory model for OCaml, broadly following the design of axiomatic memory models for languages such as C++ and Java, but with a number of differences to provide stronger guarantees and easier reasoning to the programmer, at the expense of not admitting every possible optimisation.
|js}
  ; tags = 
 [{js|ocaml-workshop|js}; {js|multicore|js}]
  ; year = 2017
  ; links = 
 [
        { description = {js|Download PDF|js}
        ; uri = {js|https://kcsrk.info/papers/memory_model_ocaml17.pdf|js}
        }]
  ; featured = true
  };
 
  { title = {js|Chemoinformatics and Structural Bioinformatics in OCaml|js}
  ; slug = {js|chemoinformatics-and-structural-bioinformatics-in-ocaml|js}
  ; publication = {js|Journal of Cheminformatics|js}
  ; authors = 
 [{js|François Berenger|js}; {js|Kam Y. J. Zhang|js};
  {js|Yoshihiro Yamanishi|js}]
  ; abstract = {js|In this article, we share our experience in prototyping chemoinformatics and structural bioinformatics software in OCaml
|js}
  ; tags = 
 [{js|industrial|js}; {js|application|js}; {js|bioinformatics|js}]
  ; year = 2019
  ; links = 
 [
        { description = {js|View Online|js}
        ; uri = {js|https://jcheminf.biomedcentral.com/articles/10.1186/s13321-019-0332-0|js}
        }]
  ; featured = false
  };
 
  { title = {js|Extending OCaml's 'open'|js}
  ; slug = {js|extending-ocamls-open|js}
  ; publication = {js|Open Publishing Association|js}
  ; authors = 
 [{js|Runhang Li|js}; {js|Jeremy Yallop|js}]
  ; abstract = {js|We propose a harmonious extension of OCaml's 'open' construct. OCaml's existing construct 'open M' imports the names exported by the module 'M' into the current scope. At present 'M' is required to be the path to a module. We propose extending 'open' to instead accept an arbitrary module expression, making it possible to succinctly address a number of existing scope-related difficulties that arise when writing OCaml programs.
|js}
  ; tags = 
 [{js|ocaml-workshop|js}; {js|core|js}; {js|language|js}]
  ; year = 2019
  ; links = 
 [
        { description = {js|Download PDF|js}
        ; uri = {js|https://arxiv.org/pdf/1905.06543.pdf|js}
        }]
  ; featured = true
  };
 
  { title = {js|A Declarative Syntax Definition for OCaml|js}
  ; slug = {js|a-declarative-syntax-definition-for-ocaml|js}
  ; publication = {js|International Conference on Functional Programming (ICFP)|js}
  ; authors = 
 [{js|Luis Eduardo de Souza Amorim|js}; {js|Eelco Visser|js}]
  ; abstract = {js|In this talk we present our work on a syntax definition for the OCaml language in the syntax definition formalism SDF3.  SDF3 supports high-level definition of concrete and abstract syntax through declarative disambiguation and definition of  constructors, enabling a direct mapping to abstract syntax. Based on the SDF3 syntax definition, the Spoofax language  workbench produces a complete syntax aware editor with a parser, syntax checking, parse error recovery, syntax highlighting,  formatting with correct parenthesis insertion, and syntactic completion. The syntax definition should provide a good  basis for experiments with the design of OCaml and the development of further tooling. In the talk we will highlight  interesting aspects the syntax definition, discuss issues we encountered in the syntax of OCaml, and demonstrate the editor.
|js}
  ; tags = 
 [{js|ocaml-workshop|js}]
  ; year = 2020
  ; links = [
        { description = {js|View Online|js}
        ; uri = {js|https://eelcovisser.org/talks/2020/08/28/ocaml/|js}
        }]
  ; featured = false
  };
 
  { title = {js|A Simple State-Machine Framework for Property-Based Testing in OCaml|js}
  ; slug = {js|a-simple-state-machine-framework-for-property-based-testing-in-ocaml|js}
  ; publication = {js|International Conference on Functional Programming (ICFP)|js}
  ; authors = 
 [{js|Jan Midtgaard|js}]
  ; abstract = {js|Since their inception state-machine frameworks have proven their worth by finding defects in everything  from the underlying AUTOSAR components of Volvo cars to digital invoicing sys- tems. These case studies were carried  out with Erlang’s commercial QuickCheck state-machine framework from Quviq, but such frameworks are now also available  for Haskell, F#, Scala, Elixir, Java, etc. We present a typed state-machine framework for OCaml based on the QCheck  library and illustrate a number concepts common to all such frameworks: state modeling, commands, interpreting commands, preconditions, and agreement checking.
|js}
  ; tags = 
 [{js|ocaml-workshop|js}]
  ; year = 2020
  ; links = [
        { description = {js|Download PDF|js}
        ; uri = {js|https://janmidtgaard.dk/papers/Midtgaard%3AOCaml20.pdf|js}
        }]
  ; featured = false
  };
 
  { title = {js|AD-OCaml: Algorithmic Differentiation for OCaml|js}
  ; slug = {js|ad-ocaml-algorithmic-differentiation-for-ocaml|js}
  ; publication = {js|International Conference on Functional Programming (ICFP)|js}
  ; authors = 
 [{js|Markus Mottl|js}]
  ; abstract = {js|AD-OCaml is a library framework for calculating mathematically exact derivatives and  deep power series approximations of almost arbitrary OCaml programs via algorithmic  differentiation. Unlike similar frameworks, this includes programs with side effects,  aliasing, and programs with nested derivative operators. The framework also offers implicit  parallelization of both user programs and their transformations. The presentation will provide  a short introduction to the mathematical problem, the difficulties of implementing a solution,  the design of the library, and a demonstration of its capabilities.
|js}
  ; tags = 
 [{js|ocaml-workshop|js}]
  ; year = 2020
  ; links = [
        { description = {js|View Online|js}
        ; uri = {js|https://icfp20.sigplan.org/details/ocaml-2020-papers/12/AD-OCaml-Algorithmic-Differentiation-for-OCaml|js}
        }]
  ; featured = false
  };
 
  { title = {js|API migration: compare transformed|js}
  ; slug = {js|api-migration-compare-transformed|js}
  ; publication = {js|International Conference on Functional Programming (ICFP)|js}
  ; authors = 
 [{js|Joseph Harrison|js}; {js|Steven Varoumas|js}; {js|Simon Thompson|js};
  {js|Reuben Rowe|js}]
  ; abstract = {js|In this talk we describe our experience in using an automatic API-migration strategy dedicated at changing  the signatures of OCaml functions, using the Rotor refactoring tool for OCaml. We perform a case study on  open source Jane Street libraries by using Rotor to refactor comparison functions so that they return a  more precise variant type rather than an integer. We discuss the difficulties of refactoring the Jane Street  code base, which makes extensive use of ppx macros, and ongoing work implementing new refactorings.
|js}
  ; tags = 
 [{js|ocaml-workshop|js}]
  ; year = 2020
  ; links = [
        { description = {js|View Online|js}
        ; uri = {js|https://icfp20.sigplan.org/details/ocaml-2020-papers/7/API-migration-compare-transformed|js}
        };
                                                       
        { description = {js|Download PDF|js}
        ; uri = {js|https://www.cs.kent.ac.uk/people/staff/sjt/Pubs/OCaml_workshop2020.pdf|js}
        }]
  ; featured = false
  };
 
  { title = {js|Irmin v2|js}
  ; slug = {js|irmin-v2|js}
  ; publication = {js|International Conference on Functional Programming (ICFP)|js}
  ; authors = 
 [{js|Clément Pascutto|js}; {js|Ioana Cristescu|js}; {js|Craig Ferguson|js};
  {js|Thomas Gazagnaire|js}; {js|Romain Liautaud|js}]
  ; abstract = {js|Irmin is an OCaml library for building distributed databases with the same design principles as Git.  Existing Git users will find many familiar features: branching/merging, immutable causal history for  all changes, and the ability to restore to any previous state. Irmin v2 adds new accessibility methods  to the store: we can now use Irmin from a CLI, or in a browser using irmin-graphql. It also has a new  backend, irmin-pack, which is optimised for space usage and is used by the Tezos blockchain.
|js}
  ; tags = 
 [{js|ocaml-workshop|js}]
  ; year = 2020
  ; links = [
        { description = {js|View Online|js}
        ; uri = {js|https://icfp20.sigplan.org/details/ocaml-2020-papers/10/Irmin-v2|js}
        };
                                                       
        { description = {js|View Online|js}
        ; uri = {js|https://tarides.com/blog/2019-11-21-irmin-v2|js}
        }]
  ; featured = false
  };
 
  { title = {js|LexiFi Runtime Types|js}
  ; slug = {js|lexifi-runtime-types|js}
  ; publication = {js|International Conference on Functional Programming (ICFP)|js}
  ; authors = 
 [{js|Patrik Keller|js}; {js|Marc Lasson|js}]
  ; abstract = {js|LexiFi maintains an OCaml compiler extension that enables introspection through runtime type representations.  Recently, we implemented a syntax extension (PPX) that enables the use of LexiFi runtime types on vanilla compilers.  We propose to present our publicly available runtime types and their features. Most notably, we want to present  a mechanism for pattern matching on runtime types with holes.
|js}
  ; tags = 
 [{js|ocaml-workshop|js}]
  ; year = 2020
  ; links = [
        { description = {js|View Online|js}
        ; uri = {js|https://icfp20.sigplan.org/details/ocaml-2020-papers/9/LexiFi-Runtime-Types|js}
        };
                                                       
        { description = {js|Download PDF|js}
        ; uri = {js|https://informationsecurity.uibk.ac.at/pdfs/KL2020_LexiFi_Runtime_Types_OCAML.pdf|js}
        };
                                                       
        { description = {js|View Online|js}
        ; uri = {js|https://www.lexifi.com/blog/ocaml/runtime-types/|js}
        }]
  ; featured = false
  };
 
  { title = {js|OCaml Under the Hood: SmartPy|js}
  ; slug = {js|ocaml-under-the-hood-smartpy|js}
  ; publication = {js|International Conference on Functional Programming (ICFP)|js}
  ; authors = 
 [{js|Sebastien Mondet|js}]
  ; abstract = {js|SmartPy is a complete system to develop smart-contracts for the Tezos blockchain. It is an embedded EDSL in python  to write contracts and their tests scenarios. It includes an online IDE, a chain explorer, and a command line interface.  Python is used to generate programs in an imperative, type inferred, intermediate language called SmartML. SmartML is  also the name of the OCaml library which provides an interpreter, a compiler to Michelson (the smart-contract language of Tezos),  as well as a scenario “on-chain” interpreter. The IDE uses a mix of OCaml built with js_of_ocaml and pure Javascript.  The command line interface also builds with js_of_ocaml to run on Node.js.
|js}
  ; tags = 
 [{js|ocaml-workshop|js}]
  ; year = 2020
  ; links = [
        { description = {js|View Online|js}
        ; uri = {js|https://icfp20.sigplan.org/details/ocaml-2020-papers/11/OCaml-Under-The-Hood-SmartPy|js}
        };
                                                       
        { description = {js|Download PDF|js}
        ; uri = {js|https://wr.mondet.org/paper/smartpy-ocaml-2020.pdf|js}
        }]
  ; featured = false
  };
 
  { title = {js|OCaml-CI: A Zero-Configuration CI|js}
  ; slug = {js|ocaml-ci-a-zero-configuration-ci|js}
  ; publication = {js|International Conference on Functional Programming (ICFP)|js}
  ; authors = 
 [{js|Thomas Leonard|js}; {js|Craig Ferguson|js}; {js|Kate Deplaix|js};
  {js|Magnus Skjegstad|js}; {js|Anil Madhavapeddy|js}]
  ; abstract = {js|OCaml-CI is a CI service for OCaml projects. It uses metadata from the project’s opam and dune files to work out what to build,  and uses caching to make builds fast. It automatically tests projects against multiple OCaml versions and OS platforms. The CI has been deployed on around 50 projects so far on GitHub, and many of them see response times an order of magnitude quicker than  with less integrated CI solutions. This talk will introduce the CI service and then look at some of the technologies used to build it.
|js}
  ; tags = 
 [{js|ocaml-workshop|js}]
  ; year = 2020
  ; links = [
        { description = {js|View Online|js}
        ; uri = {js|https://icfp20.sigplan.org/details/ocaml-2020-papers/6/OCaml-CI-A-Zero-Configuration-CI|js}
        }]
  ; featured = false
  };
 
  { title = {js|Parallelising your OCaml Code with Multicore OCaml|js}
  ; slug = {js|parallelising-your-ocaml-code-with-multicore-ocaml|js}
  ; publication = {js|International Conference on Functional Programming (ICFP)|js}
  ; authors = 
 [{js|Sadiq Jaffer|js}; {js|Sudha Parimala|js}; {js|KC Sivaramarkrishnan|js};
  {js|Tom Kelly|js}; {js|Anil Madhavapeddy|js}]
  ; abstract = {js|With the availability of multicore variants of the recent OCaml versions (4.10 and 4.11) that maintain  backwards compatibility with the existing OCaml C-API, there has been increasing interest in the wider  OCaml community for parallelising existing OCaml code.
|js}
  ; tags = 
 [{js|ocaml-workshop|js}]
  ; year = 2020
  ; links = [
        { description = {js|Download PDF|js}
        ; uri = {js|https://github.com/ocaml-multicore/multicore-talks/blob/master/ocaml2020-workshop-parallel/multicore-ocaml20.pdf|js}
        };
                                                       
        { description = {js|View Online|js}
        ; uri = {js|https://icfp20.sigplan.org/details/ocaml-2020-papers/5/Parallelising-your-OCaml-Code-with-Multicore-OCaml|js}
        }]
  ; featured = false
  };
 
  { title = {js|The ImpFS Filesystem|js}
  ; slug = {js|the-impfs-filesystem|js}
  ; publication = {js|International Conference on Functional Programming (ICFP)|js}
  ; authors = 
 [{js|Tom Ridge|js}]
  ; abstract = {js|This proposal describes a presentation to be given at the OCaml’20 workshop. The presentation will cover a new OCaml filesystem,  ImpFS, and the related libraries. The filesystem makes use of a B-tree library presented at OCaml’17, and a key-value store  presented at ML’19. In addition, there are a number of other support libraries that may be of interest to the community. ImpFS  represents a single point in the filesystem design space, but we hope that the libraries we have developed will enable others to  build further filesystems with novel features.
|js}
  ; tags = 
 [{js|ocaml-workshop|js}]
  ; year = 2020
  ; links = [
        { description = {js|View Online|js}
        ; uri = {js|https://icfp20.sigplan.org/details/ocaml-2020-papers/8/The-ImpFS-filesystem|js}
        }]
  ; featured = false
  };
 
  { title = {js|The final pieces of the OCaml documentation puzzle|js}
  ; slug = {js|the-final-pieces-of-the-ocaml-documentation-puzzle|js}
  ; publication = {js|International Conference on Functional Programming (ICFP)|js}
  ; authors = 
 [{js|Jonathan Ludlam|js}; {js|Gabriel Radanne|js}; {js|Leo White|js}]
  ; abstract = {js|Odoc is the latest attempt at creating a documentation tool which handles the full complexity of the OCaml language. It has been a long  time coming as tackling both the module system and rendering into rich documents makes for a difficult task. Nevertheless we believe  the two recent developments provides the final pieces of the OCaml documentation puzzle. This two improvements split odoc in two  layers: a model layer, with a deep understanding of the module system, and a document layer allowing for easy definition of new outputs.
|js}
  ; tags = 
 [{js|ocaml-workshop|js}]
  ; year = 2020
  ; links = [
        { description = {js|View Online|js}
        ; uri = {js|https://icfp20.sigplan.org/details/ocaml-2020-papers/4/The-final-pieces-of-the-OCaml-documentation-puzzle|js}
        }]
  ; featured = false
  };
 
  { title = {js|Types in Amber|js}
  ; slug = {js|types-in-amber|js}
  ; publication = {js|International Conference on Functional Programming (ICFP)|js}
  ; authors = 
 [{js|Paul Steckler|js}; {js|Matthew Ryan|js}]
  ; abstract = {js|Coda is a new cryptocurrency that uses zk-SNARKs to dramatically reduce the size of data needed by nodes running its protocol. Nodes communicate  in a format automatically derived from type definitions in OCaml source files. As the Coda software evolves, these formats for sent data may change. We wish to allow nodes running older versions of the software to communicate with newer versions. To achieve that, we identify stable types that  must not change over time, so that their serializations also do not change.
|js}
  ; tags = 
 [{js|ocaml-workshop|js}]
  ; year = 2020
  ; links = [
        { description = {js|View Online|js}
        ; uri = {js|https://icfp20.sigplan.org/details/ocaml-2020-papers/3/Types-in-amber|js}
        }]
  ; featured = false
  }]

