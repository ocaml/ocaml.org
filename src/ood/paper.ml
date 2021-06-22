
type t =
  { title : string
  ; slug : string
  ; publication : string
  ; authors : string list
  ; abstract : string
  ; tags : string list
  ; year : int
  ; links : string list
  }
  
let all = 
[
  { title = "A Syntactic Approach to Type Soundness"
  ; slug = "a-syntactic-approach-to-type-soundness"
  ; publication = "Information & Computation, 115(1):38\226\136\14694"
  ; authors = 
 ["Andrew K. Wright"; "Matthias Felleisen"]
  ; abstract = "This paper describes the semantics and the type system of Core ML,  and uses a simple syntactic technique to prove that well-typed programs cannot go wrong.\n"
  ; tags = 
 ["core"; "language"]
  ; year = 1994
  ; links = ["https://www.cs.rice.edu/CS/PLT/Publications/Scheme/ic94-wf.ps.gz"]
  };
 
  { title = "The Essence of ML Type Inference"
  ; slug = "the-essence-of-ml-type-inference"
  ; publication = "Benjamin C. Pierce, editor, Advanced Topics in Types and Programming Languages, MIT Press"
  ; authors = 
 ["François Pottier"; "Didier Rémy"]
  ; abstract = "This book chapter gives an in-depth abstract of the Core ML type system, with an emphasis on type inference.  The type inference algorithm is described as the composition of a constraint generator, which produces a system  of type equations, and a constraint solver, which is presented as a set of rewrite rules.\n"
  ; tags = 
 ["core"; "language"]
  ; year = 2005
  ; links = ["https://cristal.inria.fr/attapl/preversion.ps.gz"]
  };
 
  { title = "Relaxing the value restriction"
  ; slug = "relaxing-the-value-restriction"
  ; publication = "International Symposium on Functional and Logic Programming"
  ; authors = 
 ["Jacques Garrigue"]
  ; abstract = "This paper explains why it is sound to generalize certain type variables at a `let` binding, even when the expression that is being `let`-bound is not a value. This relaxed version of Wright's classic \226\128\156value restriction\226\128\157 was introduced in OCaml 3.07.\n"
  ; tags = 
 ["core"; "language"]
  ; year = 2004
  ; links = ["https://caml.inria.fr/pub/papers/garrigue-value_restriction-fiwflp04.pdf";
                                                   "https://caml.inria.fr/pub/papers/garrigue-value_restriction-fiwflp04.ps.gz"]
  };
 
  { title = "Manifest Types, Modules, and Separate Compilation"
  ; slug = "manifest-types-modules-and-separate-compilation"
  ; publication = "Principles of Programming Languages"
  ; authors = 
 ["Xavier Leroy"]
  ; abstract = "This paper presents a variant of the Standard ML module system that introduces a strict distinction between abstract  and manifest types. The latter are types whose definitions explicitly appear as part of a module interface. This proposal  is meant to retain most of the expressive power of the Standard ML module system, while providing much better support for  separate compilation. This work sets the formal bases for OCaml's module system.\n"
  ; tags = 
 ["core"; "language"; "modules"]
  ; year = 1994
  ; links = ["https://caml.inria.fr/pub/papers/xleroy-manifest_types-popl94.pdf";
                                                              "https://caml.inria.fr/pub/papers/xleroy-manifest_types-popl94.ps.gz";
                                                              "https://caml.inria.fr/pub/papers/xleroy-manifest_types-popl94.dvi.gz"]
  };
 
  { title = "Applicative Functors and Fully Transparent Higher-order Modules"
  ; slug = "applicative-functors-and-fully-transparent-higher-order-modules"
  ; publication = "Principles of Programming Languages"
  ; authors = 
 ["Xavier Leroy"]
  ; abstract = "This work extends the above paper by introducing so-called applicative functors, that is, functors that produce compatible  abstract types when applied to provably equal arguments. Applicative functors are also a feature of OCaml.\n"
  ; tags = 
 ["core"; "language"; "modules"]
  ; year = 1995
  ; links = ["https://caml.inria.fr/pub/papers/xleroy-applicative_functors-popl95.pdf";
                                                              "https://caml.inria.fr/pub/papers/xleroy-applicative_functors-popl95.ps.gz";
                                                              "https://caml.inria.fr/pub/papers/xleroy-applicative_functors-popl95.dvi.gz"]
  };
 
  { title = "A Modular Module System"
  ; slug = "a-modular-module-system"
  ; publication = "Journal of Functional Programming, 10(3):269-303"
  ; authors = 
 ["Xavier Leroy"]
  ; abstract = "This accessible paper describes a simplified implementation of the OCaml module system, emphasizing the fact that the module system  is largely independent of the underlying core language. This is a good tutorial to learn both how modules can be used and how  they are typechecked.\n"
  ; tags = 
 ["core"; "language"; "modules"]
  ; year = 2000
  ; links = ["https://caml.inria.fr/pub/papers/xleroy-modular_modules-jfp.pdf";
                                                              "https://caml.inria.fr/pub/papers/xleroy-modular_modules-jfp.ps.gz";
                                                              "https://caml.inria.fr/pub/papers/xleroy-modular_modules-jfp.dvi.gz"]
  };
 
  { title = "A Proposal for Recursive Modules in Objective Caml"
  ; slug = "a-proposal-for-recursive-modules-in-objective-caml"
  ; publication = "Unpublication"
  ; authors = 
 ["Xavier Leroy"]
  ; abstract = "This note describes the experimental recursive modules introduced in OCaml 3.07.\n"
  ; tags = 
 ["core"; "language"; "modules"]
  ; year = 2003
  ; links = ["https://caml.inria.fr/pub/papers/xleroy-recursive_modules-03.pdf";
                                                              "https://caml.inria.fr/pub/papers/xleroy-recursive_modules-03.ps.gz"]
  };
 
  { title = "Objective ML: An effective object-oriented extension to ML"
  ; slug = "objective-ml-an-effective-object-oriented-extension-to-ml"
  ; publication = "Theory And Practice of Objects Systems, 4(1):27\226\136\14650"
  ; authors = 
 ["Didier Rémy"; "Jérôme Vouillon"]
  ; abstract = "This paper provides theoretical foundations for OCaml's object-oriented layer, including dynamic and static semantics.\n"
  ; tags = 
 ["core"; "language"; "objects"]
  ; year = 1998
  ; links = ["https://caml.inria.fr/pub/papers/remy_vouillon-objective_ml-tapos98.pdf";
                                                              "https://caml.inria.fr/pub/papers/remy_vouillon-objective_ml-tapos98.ps.gz";
                                                              "https://caml.inria.fr/pub/papers/remy_vouillon-objective_ml-tapos98.dvi.gz"]
  };
 
  { title = "Extending ML with Semi-Explicit Higher-Order Polymorphism"
  ; slug = "extending-ml-with-semi-explicit-higher-order-polymorphism"
  ; publication = "Information & Computation, 155(1/2):134\226\136\146169"
  ; authors = 
 ["Jacques Garrigue"; "Didier Rémy"]
  ; abstract = "This paper proposes a device for re-introducing first-class polymorphic values into ML while preserving its type inference  mechanism. This technology underlies OCaml's polymorphic methods.\n"
  ; tags = 
 ["core"; "language"; "objects"]
  ; year = 1999
  ; links = ["https://caml.inria.fr/pub/papers/garrigue_remy-poly-ic99.pdf";
                                                              "https://caml.inria.fr/pub/papers/garrigue_remy-poly-ic99.ps.gz";
                                                              "https://caml.inria.fr/pub/papers/garrigue_remy-poly-ic99.dvi.gz"]
  };
 
  { title = "Programming with Polymorphic Variants"
  ; slug = "programming-with-polymorphic-variants"
  ; publication = "ML Workshop"
  ; authors = 
 ["Jacques Garrigue"]
  ; abstract = "This paper briefly explains what polymorphic variants are about and how they are compiled.\n"
  ; tags = 
 ["core"; "language"; "polymorphic variants"]
  ; year = 1998
  ; links = 
 ["https://caml.inria.fr/pub/papers/garrigue-polymorphic_variants-ml98.pdf";
  "https://caml.inria.fr/pub/papers/garrigue-polymorphic_variants-ml98.ps.gz"]
  };
 
  { title = "Code Reuse through Polymorphic Variants"
  ; slug = "code-reuse-through-polymorphic-variants"
  ; publication = "Workshop on Foundations of Software Engineering"
  ; authors = 
 ["Jacques Garrigue"]
  ; abstract = "This short paper explains how to design a modular, extensible interpreter using polymorphic variants.\n"
  ; tags = 
 ["core"; "language"; "polymorphic variants"]
  ; year = 2000
  ; links = 
 ["https://caml.inria.fr/pub/papers/garrigue-variant-reuse-2000.ps.gz"]
  };
 
  { title = "Simple Type Inference for Structural Polymorphism"
  ; slug = "simple-type-inference-for-structural-polymorphism"
  ; publication = "Workshop on Foundations of Object-Oriented Languages"
  ; authors = 
 ["Jacques Garrigue"]
  ; abstract = "This paper explains most of the typechecking machinery behind polymorphic variants.  At its heart is an extension of Core ML's type discipline with so-called local constraints.\n"
  ; tags = 
 ["core"; "language"; "polymorphic variants"]
  ; year = 2002
  ; links = 
 ["https://caml.inria.fr/pub/papers/garrigue-structural_poly-fool02.pdf";
  "https://caml.inria.fr/pub/papers/garrigue-structural_poly-fool02.ps.gz"]
  };
 
  { title = "Typing Deep Pattern-matching in Presence of Polymorphic Variants"
  ; slug = "typing-deep-pattern-matching-in-presence-of-polymorphic-variants"
  ; publication = "JSSST Workshop on Programming and Programming Languages"
  ; authors = 
 ["Jacques Garrigue"]
  ; abstract = "This paper provides more details about the technical machinery behind polymorphic variants, focusing  on the rules for typechecking deep pattern matching constructs.\n"
  ; tags = 
 ["core"; "language"; "polymorphic variants"]
  ; year = 2004
  ; links = 
 ["https://caml.inria.fr/pub/papers/garrigue-deep-variants-2004.pdf";
  "https://caml.inria.fr/pub/papers/garrigue-deep-variants-2004.ps.gz"]
  };
 
  { title = "Labeled and Optional Arguments for Objective Caml"
  ; slug = "labeled-and-optional-arguments-for-objective-caml"
  ; publication = "JSSST Workshop on Programming and Programming Languages"
  ; authors = 
 ["Jacques Garrigue"]
  ; abstract = "This paper offers a dynamic semantics, a static semantics, and a compilation scheme for OCaml's labeled  and optional function parameters.\n"
  ; tags = 
 ["core"; "language"]
  ; year = 2001
  ; links = ["https://caml.inria.fr/pub/papers/garrigue-labels-ppl01.pdf";
                                                   "https://caml.inria.fr/pub/papers/garrigue-labels-ppl01.ps.gz";
                                                   "https://caml.inria.fr/pub/papers/garrigue-labels-ppl01.dvi.gz"]
  };
 
  { title = "Meta-programming Tutorial with CamlP4"
  ; slug = "meta-programming-tutorial-with-camlp4"
  ; publication = "Commercial Users of Functional Programming"
  ; authors = 
 ["Jake Donham"]
  ; abstract = "Meta-programming tutorial with Camlp4"
  ; tags = 
 ["core"; "language"]
  ; year = 2010
  ; links = ["https://github.com/jaked/cufp-metaprogramming-tutorial"]
  };
 
  { title = "The ZINC experiment, an Economical Implementation of the ML language"
  ; slug = "the-zinc-experiment-an-economical-implementation-of-the-ml-language"
  ; publication = "Technical report 117, INRIA"
  ; authors = 
 ["Xavier Leroy"]
  ; abstract = "This report contains a abstract of the ZINC compiler, which later evolved into Caml Light, then into OCaml. Large parts  of this report are out of date, but it is still valuable as a abstract of the abstract machine used in Caml Light and  (with some further simplifications and speed improvements) in OCaml.\n"
  ; tags = 
 ["compiler"; "runtime"]
  ; year = 1990
  ; links = ["https://caml.inria.fr/pub/papers/xleroy-zinc.pdf";
                                                      "https://caml.inria.fr/pub/papers/xleroy-zinc.ps.gz"]
  };
 
  { title = "The Effectiveness of Type-based Unboxing"
  ; slug = "the-effectiveness-of-type-based-unboxing"
  ; publication = "Workshop on Types in Compilation"
  ; authors = 
 ["Xavier Leroy"]
  ; abstract = "This paper surveys and compares several data representation strategies, including the one used in the OCaml native-code compiler.\n"
  ; tags = 
 ["compiler"; "runtime"]
  ; year = 1997
  ; links = ["https://caml.inria.fr/pub/papers/xleroy-unboxing-tic97.pdf";
                                                      "https://caml.inria.fr/pub/papers/xleroy-unboxing-tic97.ps.gz"]
  };
 
  { title = "A Concurrent, Generational Garbage Collector for a Multithreaded Implementation of ML"
  ; slug = "a-concurrent-generational-garbage-collector-for-a-multithreaded-implementation-of-ml"
  ; publication = "Principles of Programming Languages"
  ; authors = 
 ["Damien Doligez"; "Xavier Leroy"]
  ; abstract = "Superseded by \"Portable, Unobtrusive Garbage Collection for Multiprocessor Systems\"\n"
  ; tags = 
 ["garbage collection"; "runtime"]
  ; year = 1993
  ; links = ["https://caml.inria.fr/pub/papers/doligez_xleroy-concurrent_gc-popl93.pdf";
                                                                "https://caml.inria.fr/pub/papers/doligez_xleroy-concurrent_gc-popl93.ps.gz"]
  };
 
  { title = "Portable, Unobtrusive Garbage Collection for Multiprocessor Systems"
  ; slug = "portable-unobtrusive-garbage-collection-for-multiprocessor-systems"
  ; publication = "Principles of Programming Languages"
  ; authors = 
 ["Damien Doligez"; "Georges Gonthier"]
  ; abstract = "This paper describes a concurrent version of the garbage collector found in Caml Light and OCaml's runtime system.\n"
  ; tags = 
 ["garbage collection"; "runtime"]
  ; year = 1994
  ; links = ["https://caml.inria.fr/pub/papers/doligez_gonthier-gc-popl94.pdf";
                                                                "https://caml.inria.fr/pub/papers/doligez_gonthier-gc-popl94.ps.gz"]
  };
 
  { title = "Conception, r\195\169alisation et certification d'un glaneur de cellules concurrent"
  ; slug = "conception-ralisation-et-certification-dun-glaneur-de-cellules-concurrent"
  ; publication = "Ph.D. thesis, Universit\195\169 Paris 7"
  ; authors = 
 ["Damien Doligez"; "Georges Gonthier"]
  ; abstract = "All you ever wanted to know about the garbage collector found in Caml Light and OCaml's runtime system.\n"
  ; tags = 
 ["garbage collection"; "runtime"]
  ; year = 1995
  ; links = ["https://caml.inria.fr/pub/papers/doligez-these.pdf";
                                                                "https://caml.inria.fr/pub/papers/doligez-these.ps.gz"]
  };
 
  { title = "Optimizing Pattern Matching"
  ; slug = "optimizing-pattern-matching"
  ; publication = "Proceedings of the sixth ACM SIGPLAN International Conference on Functional Programming (ICFP)"
  ; authors = 
 ["Fabrice Le Fessant"; "Luc Maranget"]
  ; abstract = "All you ever wanted to know about the garbage collector found in Caml Light and OCaml's runtime system.\n"
  ; tags = 
 ["pattern-matching"; "runtime"]
  ; year = 2001
  ; links = ["https://dl.acm.org/citation.cfm?id=507641"]
  };
 
  { title = "OCaml for the Masses"
  ; slug = "ocaml-for-the-masses"
  ; publication = "ACM Queue"
  ; authors = 
 ["Yaron Minsky"]
  ; abstract = "Why the next language you learn should be functional.\n"
  ; tags = 
 ["industrial"]
  ; year = 2011
  ; links = ["https://queue.acm.org/detail.cfm?id=2038036"]
  };
 
  { title = "Xen and the Art of OCaml"
  ; slug = "xen-and-the-art-of-ocaml"
  ; publication = "Commercial Users of Functional Programming (CUFP)"
  ; authors = 
 ["Anil Madhavapeddy"]
  ; abstract = "In this talk, we will firstly describe the architecture of XenServer and the XenAPI and discuss the challenges faced with implementing  an Objective Caml based solution. These challenges range from the low-level concerns of interfacing with Xen and the  Linux kernel, to the high-level algorithmic problems such as distributed failure planning. In addition, we will  discuss the challenges imposed by using OCaml in a commercial environment, such as supporting product upgrades,  enhancing supportability and scaling the development team.\n"
  ; tags = 
 ["industrial"; "application"]
  ; year = 2008
  ; links = ["https://cufp.org/archive/2008/slides/MadhavapeddyAnil.pdf"]
  };
 
  { title = "Chemoinformatics and Structural Bioinformatics in OCaml"
  ; slug = "chemoinformatics-and-structural-bioinformatics-in-ocaml"
  ; publication = "Journal of Cheminformatics"
  ; authors = 
 ["François Berenger"; "Kam Y. J. Zhang"; "Yoshihiro Yamanishi"]
  ; abstract = "In this article, we share our experience in prototyping chemoinformatics and structural bioinformatics software in OCaml\n"
  ; tags = 
 ["industrial"; "application"; "bioinformatics"]
  ; year = 2019
  ; links = 
 ["https://jcheminf.biomedcentral.com/articles/10.1186/s13321-019-0332-0"]
  };
 
  { title = "A Declarative Syntax Definition for OCaml"
  ; slug = "a-declarative-syntax-definition-for-ocaml"
  ; publication = "International Conference on Functional Programming (ICFP)"
  ; authors = 
 ["Luis Eduardo de Souza Amorim"; "Eelco Visser"]
  ; abstract = "In this talk we present our work on a syntax definition for the OCaml language in the syntax definition formalism SDF3.  SDF3 supports high-level definition of concrete and abstract syntax through declarative disambiguation and definition of  constructors, enabling a direct mapping to abstract syntax. Based on the SDF3 syntax definition, the Spoofax language  workbench produces a complete syntax aware editor with a parser, syntax checking, parse error recovery, syntax highlighting,  formatting with correct parenthesis insertion, and syntactic completion. The syntax definition should provide a good  basis for experiments with the design of OCaml and the development of further tooling. In the talk we will highlight  interesting aspects the syntax definition, discuss issues we encountered in the syntax of OCaml, and demonstrate the editor.\n"
  ; tags = 
 ["ocaml-workshop"]
  ; year = 2020
  ; links = ["https://eelcovisser.org/talks/2020/08/28/ocaml/"]
  };
 
  { title = "A Simple State-Machine Framework for Property-Based Testing in OCaml"
  ; slug = "a-simple-state-machine-framework-for-property-based-testing-in-ocaml"
  ; publication = "International Conference on Functional Programming (ICFP)"
  ; authors = 
 ["Jan Midtgaard"]
  ; abstract = "Since their inception state-machine frameworks have proven their worth by finding defects in everything  from the underlying AUTOSAR components of Volvo cars to digital invoicing sys- tems. These case studies were carried  out with Erlang\226\128\153s commercial QuickCheck state-machine framework from Quviq, but such frameworks are now also available  for Haskell, F#, Scala, Elixir, Java, etc. We present a typed state-machine framework for OCaml based on the QCheck  library and illustrate a number concepts common to all such frameworks: state modeling, commands, interpreting commands, preconditions, and agreement checking.\n"
  ; tags = 
 ["ocaml-workshop"]
  ; year = 2020
  ; links = ["https://janmidtgaard.dk/papers/Midtgaard%3AOCaml20.pdf"]
  };
 
  { title = "AD-OCaml: Algorithmic Differentiation for OCaml"
  ; slug = "ad-ocaml-algorithmic-differentiation-for-ocaml"
  ; publication = "International Conference on Functional Programming (ICFP)"
  ; authors = 
 ["Markus Mottl"]
  ; abstract = "AD-OCaml is a library framework for calculating mathematically exact derivatives and  deep power series approximations of almost arbitrary OCaml programs via algorithmic  differentiation. Unlike similar frameworks, this includes programs with side effects,  aliasing, and programs with nested derivative operators. The framework also offers implicit  parallelization of both user programs and their transformations. The presentation will provide  a short introduction to the mathematical problem, the difficulties of implementing a solution,  the design of the library, and a demonstration of its capabilities.\n"
  ; tags = 
 ["ocaml-workshop"]
  ; year = 2020
  ; links = ["https://icfp20.sigplan.org/details/ocaml-2020-papers/12/AD-OCaml-Algorithmic-Differentiation-for-OCaml"]
  };
 
  { title = "API migration: compare transformed"
  ; slug = "api-migration-compare-transformed"
  ; publication = "International Conference on Functional Programming (ICFP)"
  ; authors = 
 ["Joseph Harrison"; "Steven Varoumas"; "Simon Thompson"; "Reuben Rowe"]
  ; abstract = "In this talk we describe our experience in using an automatic API-migration strategy dedicated at changing  the signatures of OCaml functions, using the Rotor refactoring tool for OCaml. We perform a case study on  open source Jane Street libraries by using Rotor to refactor comparison functions so that they return a  more precise variant type rather than an integer. We discuss the difficulties of refactoring the Jane Street  code base, which makes extensive use of ppx macros, and ongoing work implementing new refactorings.\n"
  ; tags = 
 ["ocaml-workshop"]
  ; year = 2020
  ; links = ["https://icfp20.sigplan.org/details/ocaml-2020-papers/7/API-migration-compare-transformed";
                                                 "https://www.cs.kent.ac.uk/people/staff/sjt/Pubs/OCaml_workshop2020.pdf"]
  };
 
  { title = "Irmin v2"
  ; slug = "irmin-v2"
  ; publication = "International Conference on Functional Programming (ICFP)"
  ; authors = 
 ["Clément Pascutto"; "Ioana Cristescu"; "Craig Ferguson";
  "Thomas Gazagnaire"; "Romain Liautaud"]
  ; abstract = "Irmin is an OCaml library for building distributed databases with the same design principles as Git.  Existing Git users will find many familiar features: branching/merging, immutable causal history for  all changes, and the ability to restore to any previous state. Irmin v2 adds new accessibility methods  to the store: we can now use Irmin from a CLI, or in a browser using irmin-graphql. It also has a new  backend, irmin-pack, which is optimised for space usage and is used by the Tezos blockchain.\n"
  ; tags = 
 ["ocaml-workshop"]
  ; year = 2020
  ; links = ["https://icfp20.sigplan.org/details/ocaml-2020-papers/10/Irmin-v2";
                                                 "https://tarides.com/blog/2019-11-21-irmin-v2"]
  };
 
  { title = "LexiFi Runtime Types"
  ; slug = "lexifi-runtime-types"
  ; publication = "International Conference on Functional Programming (ICFP)"
  ; authors = 
 ["Patrik Keller"; "Marc Lasson"]
  ; abstract = "LexiFi maintains an OCaml compiler extension that enables introspection through runtime type representations.  Recently, we implemented a syntax extension (PPX) that enables the use of LexiFi runtime types on vanilla compilers.  We propose to present our publicly available runtime types and their features. Most notably, we want to present  a mechanism for pattern matching on runtime types with holes.\n"
  ; tags = 
 ["ocaml-workshop"]
  ; year = 2020
  ; links = ["https://icfp20.sigplan.org/details/ocaml-2020-papers/9/LexiFi-Runtime-Types";
                                                 "https://informationsecurity.uibk.ac.at/pdfs/KL2020_LexiFi_Runtime_Types_OCAML.pdf";
                                                 "https://www.lexifi.com/blog/ocaml/runtime-types/"]
  };
 
  { title = "OCaml Under the Hood: SmartPy"
  ; slug = "ocaml-under-the-hood-smartpy"
  ; publication = "International Conference on Functional Programming (ICFP)"
  ; authors = 
 ["Sebastien Mondet"]
  ; abstract = "SmartPy is a complete system to develop smart-contracts for the Tezos blockchain. It is an embedded EDSL in python  to write contracts and their tests scenarios. It includes an online IDE, a chain explorer, and a command line interface.  Python is used to generate programs in an imperative, type inferred, intermediate language called SmartML. SmartML is  also the name of the OCaml library which provides an interpreter, a compiler to Michelson (the smart-contract language of Tezos),  as well as a scenario \226\128\156on-chain\226\128\157 interpreter. The IDE uses a mix of OCaml built with js_of_ocaml and pure Javascript.  The command line interface also builds with js_of_ocaml to run on Node.js.\n"
  ; tags = 
 ["ocaml-workshop"]
  ; year = 2020
  ; links = ["https://icfp20.sigplan.org/details/ocaml-2020-papers/11/OCaml-Under-The-Hood-SmartPy";
                                                 "https://wr.mondet.org/paper/smartpy-ocaml-2020.pdf"]
  };
 
  { title = "OCaml-CI: A Zero-Configuration CI"
  ; slug = "ocaml-ci-a-zero-configuration-ci"
  ; publication = "International Conference on Functional Programming (ICFP)"
  ; authors = 
 ["Thomas Leonard"; "Craig Ferguson"; "Kate Deplaix"; "Magnus Skjegstad";
  "Anil Madhavapeddy"]
  ; abstract = "OCaml-CI is a CI service for OCaml projects. It uses metadata from the project\226\128\153s opam and dune files to work out what to build,  and uses caching to make builds fast. It automatically tests projects against multiple OCaml versions and OS platforms. The CI has been deployed on around 50 projects so far on GitHub, and many of them see response times an order of magnitude quicker than  with less integrated CI solutions. This talk will introduce the CI service and then look at some of the technologies used to build it.\n"
  ; tags = 
 ["ocaml-workshop"]
  ; year = 2020
  ; links = ["https://icfp20.sigplan.org/details/ocaml-2020-papers/6/OCaml-CI-A-Zero-Configuration-CI"]
  };
 
  { title = "Parallelising your OCaml Code with Multicore OCaml"
  ; slug = "parallelising-your-ocaml-code-with-multicore-ocaml"
  ; publication = "International Conference on Functional Programming (ICFP)"
  ; authors = 
 ["Sadiq Jaffer"; "Sudha Parimala"; "KC Sivaramarkrishnan"; "Tom Kelly";
  "Anil Madhavapeddy"]
  ; abstract = "With the availability of multicore variants of the recent OCaml versions (4.10 and 4.11) that maintain  backwards compatibility with the existing OCaml C-API, there has been increasing interest in the wider  OCaml community for parallelising existing OCaml code.\n"
  ; tags = 
 ["ocaml-workshop"]
  ; year = 2020
  ; links = ["https://github.com/ocaml-multicore/multicore-talks/blob/master/ocaml2020-workshop-parallel/multicore-ocaml20.pdf";
                                                 "https://icfp20.sigplan.org/details/ocaml-2020-papers/5/Parallelising-your-OCaml-Code-with-Multicore-OCaml"]
  };
 
  { title = "The ImpFS Filesystem"
  ; slug = "the-impfs-filesystem"
  ; publication = "International Conference on Functional Programming (ICFP)"
  ; authors = 
 ["Tom Ridge"]
  ; abstract = "This proposal describes a presentation to be given at the OCaml\226\128\15320 workshop. The presentation will cover a new OCaml filesystem,  ImpFS, and the related libraries. The filesystem makes use of a B-tree library presented at OCaml\226\128\15317, and a key-value store  presented at ML\226\128\15319. In addition, there are a number of other support libraries that may be of interest to the community. ImpFS  represents a single point in the filesystem design space, but we hope that the libraries we have developed will enable others to  build further filesystems with novel features.\n"
  ; tags = 
 ["ocaml-workshop"]
  ; year = 2020
  ; links = ["https://icfp20.sigplan.org/details/ocaml-2020-papers/8/The-ImpFS-filesystem"]
  };
 
  { title = "The final pieces of the OCaml documentation puzzle"
  ; slug = "the-final-pieces-of-the-ocaml-documentation-puzzle"
  ; publication = "International Conference on Functional Programming (ICFP)"
  ; authors = 
 ["Jonathan Ludlam"; "Gabriel Radanne"; "Leo White"]
  ; abstract = "Odoc is the latest attempt at creating a documentation tool which handles the full complexity of the OCaml language. It has been a long  time coming as tackling both the module system and rendering into rich documents makes for a difficult task. Nevertheless we believe  the two recent developments provides the final pieces of the OCaml documentation puzzle. This two improvements split odoc in two  layers: a model layer, with a deep understanding of the module system, and a document layer allowing for easy definition of new outputs.\n"
  ; tags = 
 ["ocaml-workshop"]
  ; year = 2020
  ; links = ["https://icfp20.sigplan.org/details/ocaml-2020-papers/4/The-final-pieces-of-the-OCaml-documentation-puzzle"]
  };
 
  { title = "Types in Amber"
  ; slug = "types-in-amber"
  ; publication = "International Conference on Functional Programming (ICFP)"
  ; authors = 
 ["Paul Steckler"; "Matthew Ryan"]
  ; abstract = "Coda is a new cryptocurrency that uses zk-SNARKs to dramatically reduce the size of data needed by nodes running its protocol. Nodes communicate  in a format automatically derived from type definitions in OCaml source files. As the Coda software evolves, these formats for sent data may change. We wish to allow nodes running older versions of the software to communicate with newer versions. To achieve that, we identify stable types that  must not change over time, so that their serializations also do not change.\n"
  ; tags = 
 ["ocaml-workshop"]
  ; year = 2020
  ; links = ["https://icfp20.sigplan.org/details/ocaml-2020-papers/3/Types-in-amber"]
  }]

