
type kind =
  [ `Conference
  | `Mooc
  | `Lecture
  ]

type t =
  { title : string
  ; slug : string
  ; description : string
  ; people : string list
  ; kind : kind
  ; tags : string list
  ; paper : string option
  ; link : string
  ; embed : string option
  ; year : int
  }
  
let all = 
[
  { title = {js|A Declarative Syntax Definition for OCaml|js}
  ; slug = {js|a-declarative-syntax-definition-for-ocaml|js}
  ; description = {js|In this talk, we present our work on a syntax definition for the OCaml language in the syntax definition formalism SDF3. SDF3 supports the high-level definition of concrete and abstract syntax through declarative disambiguation and definition of constructors, enabling a direct mapping to abstract syntax. Based on the SDF3 syntax definition, the Spoofax language workbench produces a complete syntax aware editor with a parser, syntax checking, parse error recovery, syntax highlighting, formatting with correct parenthesis insertion, and syntactic completion. The syntax definition should provide a good basis for experiments with the design of OCaml and the development of further tooling. In the talk, we will highlight interesting aspects of the syntax definition, discuss issues we encountered in the syntax of OCaml, and demonstrate the editor.|js}
  ; people = 
 []
  ; kind = `Conference
  ; tags = ["ocaml-workshop"]
  ; paper = Some {js|A Declarative Syntax Definition for OCaml|js}
  ; link = {js|https://watch.ocaml.org/videos/watch/a5b86864-8e43-4138-b6d6-ed48d2d4b63d|js}
  ; embed = Some {js|https://watch.ocaml.org/videos/embed/a5b86864-8e43-4138-b6d6-ed48d2d4b63d|js}
  ; year = 2020
  };
 
  { title = {js|The Final Pieces of the OCaml Documentation Puzzle|js}
  ; slug = {js|the-final-pieces-of-the-ocaml-documentation-puzzle|js}
  ; description = {js|Rendering OCaml document is widely known as a very difficult task: The ever-evolving OCaml module system is extremely rich and can include complex set of inter-dependencies that are both difficult to compute and to render in a concise document. Its tasks are even harder than the typechecker as it also needs to keep track of documentation comments precisely and efficiently. As an example, signatures such as include F(X).T and destructive substitutions were never handled properly by any documentation generator.|js}
  ; people = 
 []
  ; kind = `Conference
  ; tags = ["ocaml-workshop"]
  ; paper = Some {js|The final pieces of the OCaml documentation puzzle|js}
  ; link = {js|https://watch.ocaml.org/videos/watch/2acebff9-25fa-4733-83cc-620a65b12251|js}
  ; embed = Some {js|https://watch.ocaml.org/videos/embed/2acebff9-25fa-4733-83cc-620a65b12251|js}
  ; year = 2020
  };
 
  { title = {js|OCaml-CI: A Zero-Configuration CI|js}
  ; slug = {js|ocaml-ci-a-zero-configuration-ci|js}
  ; description = {js|OCaml-CI is a CI service for OCaml projects. It uses metadata from the project’s opam and dune files to work out what to build, and uses caching to make builds fast. It automatically tests projects against multiple OCaml versions and OS platforms. The CI has been deployed on around 50 projects so far on GitHub, and many of them see response times an order of magnitude quicker than with less integrated CI solutions. This talk will introduce the CI service and then look at some of the technologies used to build it.|js}
  ; people = 
 []
  ; kind = `Conference
  ; tags = ["ocaml-workshop"]
  ; paper = Some {js|OCaml-CI: A Zero-Configuration CI|js}
  ; link = {js|https://watch.ocaml.org/videos/watch/0fee79e8-715a-400b-bfcc-34c3610f4890|js}
  ; embed = Some {js|https://watch.ocaml.org/videos/embed/0fee79e8-715a-400b-bfcc-34c3610f4890|js}
  ; year = 2020
  };
 
  { title = {js|State of the OCaml Platform 2020|js}
  ; slug = {js|state-of-the-ocaml-platform-2020|js}
  ; description = {js|This talk covers: integrated development environments, next steps for the OCaml Platform and plans for 2020-2021|js}
  ; people = 
 []
  ; kind = `Conference
  ; tags = ["ocaml-workshop"; "ocaml-platform"]
  ; paper = None
  ; link = {js|https://watch.ocaml.org/videos/watch/0e2070fd-798b-47f7-8e69-ef75e967e516|js}
  ; embed = Some {js|https://watch.ocaml.org/videos/embed/0e2070fd-798b-47f7-8e69-ef75e967e516|js}
  ; year = 2020
  };
 
  { title = {js|Parallelising your OCaml Code with Multicore OCaml|js}
  ; slug = {js|parallelising-your-ocaml-code-with-multicore-ocaml|js}
  ; description = {js|This presentation will take the attendees through the following steps aimed at developing parallel programs with Multicore OCaml: installing the latest Multicore OCaml compiler, brief overview of the low-level API for parallel programming, a tour of domainslib – a high-level parallel programming library for Multicore OCaml, common pitfalls when parallelising and tools for diagnosing Multicore OCaml performance.|js}
  ; people = 
 []
  ; kind = `Conference
  ; tags = ["ocaml-workshop"; "multicore-ocaml"]
  ; paper = Some {js|Parallelising your OCaml Code with Multicore OCaml|js}
  ; link = {js|https://watch.ocaml.org/videos/watch/ce20839e-4bfc-4d74-925b-485a6b052ddf|js}
  ; embed = Some {js|https://watch.ocaml.org/videos/embed/ce20839e-4bfc-4d74-925b-485a6b052ddf|js}
  ; year = 2020
  };
 
  { title = {js|Types in Amber|js}
  ; slug = {js|types-in-amber|js}
  ; description = {js|Coda is a new cryptocurrency that uses zk-SNARKs to dramatically reduce the size of data needed by nodes running its protocol. Nodes communicate in a format automatically derived from type definitions in OCaml source files. As the Coda software evolves, these formats for sent data may change. We wish to allow nodes running older versions of the software to communicate with newer versions. To achieve that, we identify stable types that must not change over time, so that their serializations also do not change.|js}
  ; people = 
 []
  ; kind = `Conference
  ; tags = ["ocaml-workshop"]
  ; paper = Some {js|Types in Amber|js}
  ; link = {js|https://watch.ocaml.org/videos/watch/99b3dc75-9f93-4677-9f8b-076546725512|js}
  ; embed = Some {js|https://watch.ocaml.org/videos/embed/99b3dc75-9f93-4677-9f8b-076546725512|js}
  ; year = 2020
  };
 
  { title = {js|OCaml under the Hood: SmartPy|js}
  ; slug = {js|ocaml-under-the-hood-smartpy|js}
  ; description = {js|SmartPy is a complete system to develop smart-contracts for the Tezos blockchain. It is an embedded EDSL in python to write contracts and their test scenarios. It includes an online IDE, a chain explorer, and a command-line interface. Python is used to generate programs in an imperative, type-inferred, intermediate language called SmartML. SmartML is also the name of the OCaml library which provides an interpreter, a compiler to Michelson (the smart-contract language of Tezos), as well as a scenario “on-chain” interpreter. The IDE uses a mix of OCaml built with js_of_ocaml and pure Javascript. The command-line interface also builds with js_of_ocaml to run on Node.js.|js}
  ; people = 
 []
  ; kind = `Conference
  ; tags = ["ocaml-workshop"]
  ; paper = Some {js|OCaml Under the Hood: SmartPy|js}
  ; link = {js|https://watch.ocaml.org/videos/watch/7446ad4d-4ae2-4e1a-bc38-af8f71e8ebd8|js}
  ; embed = Some {js|https://watch.ocaml.org/videos/embed/7446ad4d-4ae2-4e1a-bc38-af8f71e8ebd8|js}
  ; year = 2020
  };
 
  { title = {js|LexiFi Runtime Types|js}
  ; slug = {js|lexifi-runtime-types|js}
  ; description = {js|OCaml programmers make deliberate use of abstract data types for composing safe and reliable software systems. The OCaml compiler relies on the invariants imposed by the type system to produce efficient and compact runtime data representations. Being no longer relevant, the type information is discarded after compilation. The resulting performance is a key feature of the OCaml language.|js}
  ; people = 
 []
  ; kind = `Conference
  ; tags = ["ocaml-workshop"]
  ; paper = Some {js|LexiFi Runtime Types|js}
  ; link = {js|https://watch.ocaml.org/videos/watch/cc7e3242-0bef-448a-aa13-8827bba933e3|js}
  ; embed = Some {js|https://watch.ocaml.org/videos/embed/cc7e3242-0bef-448a-aa13-8827bba933e3|js}
  ; year = 2020
  };
 
  { title = {js|The ImpFS Filesystem|js}
  ; slug = {js|the-impfs-filesystem|js}
  ; description = {js|This proposal describes a presentation to be given at the OCaml’20 workshop. The presentation will cover a new OCaml filesystem, ImpFS, and the related libraries. The filesystem makes use of a B-tree library presented at OCaml’17, and a key-value store presented at ML’19. In addition, there are a number of other support libraries that may be of interest to the community. ImpFS represents a single point in the filesystem design space, but we hope that the libraries we have developed will enable others to build further filesystems with novel features.|js}
  ; people = 
 []
  ; kind = `Conference
  ; tags = ["ocaml-workshop"]
  ; paper = Some {js|The ImpFS Filesystem|js}
  ; link = {js|https://watch.ocaml.org/videos/watch/28545b27-4637-47a5-8edd-6b904daef19c|js}
  ; embed = Some {js|https://watch.ocaml.org/videos/embed/28545b27-4637-47a5-8edd-6b904daef19c|js}
  ; year = 2020
  };
 
  { title = {js|Irmin v2|js}
  ; slug = {js|irmin-v2|js}
  ; description = {js|Irmin is an OCaml library for building distributed databases with the same design principles as Git. Existing Git users will find many familiar features: branching/merging, immutable causal history for all changes, and the ability to restore to any previous state. It has been extensively used by major software projects over the past few years such as Docker for Mac/Windows, and noticeably through DataKit, which powers hundreds of thousands monthly builds on the opam-repository CI contributors may be familiar with.|js}
  ; people = 
 []
  ; kind = `Conference
  ; tags = ["ocaml-workshop"; "irmin"]
  ; paper = Some {js|Irmin v2|js}
  ; link = {js|https://watch.ocaml.org/videos/watch/53e497b0-898f-4c85-8da9-39f65ef0e0b1|js}
  ; embed = Some {js|https://watch.ocaml.org/videos/embed/53e497b0-898f-4c85-8da9-39f65ef0e0b1|js}
  ; year = 2020
  };
 
  { title = {js|Why OCaml|js}
  ; slug = {js|why-ocaml|js}
  ; description = {js|A summary of why Jane Street uses OCaml, including a discussion of how OCaml fits into the broader space of programming languages. Given to our summer interns.|js}
  ; people = 
 []
  ; kind = `Lecture
  ; tags = ["jane-street"]
  ; paper = None
  ; link = {js|https://watch.ocaml.org/videos/watch/3abacf08-a3a1-405c-975b-a4efb54f0dd0|js}
  ; embed = Some {js|https://watch.ocaml.org/videos/embed/3abacf08-a3a1-405c-975b-a4efb54f0dd0|js}
  ; year = 2015
  };
 
  { title = {js|AD-OCaml: Algorithmic Differentiation for OCaml|js}
  ; slug = {js|ad-ocaml-algorithmic-differentiation-for-ocaml|js}
  ; description = {js|AD-OCaml is a library framework for calculating mathematically exact derivatives and deep power series approximations of almost arbitrary OCaml programs via algorithmic differentiation. Unlike similar frameworks, this includes programs with side effects, aliasing, and programs with nested derivative operators. The framework also offers implicit parallelization of both user programs and their transformations.

The presentation will provide a short introduction to the mathematical problem, the difficulties of implementing a solution, the design of the library, and a demonstration of its capabilities.|js}
  ; people = 
 []
  ; kind = `Conference
  ; tags = ["ocaml-workshop"]
  ; paper = Some {js|AD-OCaml: Algorithmic Differentiation for OCaml|js}
  ; link = {js|https://watch.ocaml.org/videos/watch/c9e85690-732f-4b03-836f-2ee0fd8f0658|js}
  ; embed = Some {js|https://watch.ocaml.org/videos/embed/c9e85690-732f-4b03-836f-2ee0fd8f0658|js}
  ; year = 2020
  };
 
  { title = {js|API migration: compare transformed|js}
  ; slug = {js|api-migration-compare-transformed|js}
  ; description = {js|In this talk we describe our experience in using an automatic API-migration strategy dedicated at changing the signatures of OCaml functions, using the Rotor refactoring tool for OCaml. We perform a case study on open source Jane Street libraries by using Rotor to refactor comparison functions so that they return a more precise variant type rather than an integer. We discuss the difficulties of refactoring the Jane Street code base, which makes extensive use of ppx macros, and ongoing work implementing new refactorings.|js}
  ; people = 
 []
  ; kind = `Conference
  ; tags = ["ocaml-workshop"]
  ; paper = Some {js|API migration: compare transformed|js}
  ; link = {js|https://watch.ocaml.org/videos/watch/c46b925b-bd77-404f-ac5d-5dab65047529|js}
  ; embed = Some {js|https://watch.ocaml.org/videos/embed/c46b925b-bd77-404f-ac5d-5dab65047529|js}
  ; year = 2020
  };
 
  { title = {js|A Simple State-Machine Framework for Property-Based Testing in OCaml|js}
  ; slug = {js|a-simple-state-machine-framework-for-property-based-testing-in-ocaml|js}
  ; description = {js|Since their inception, state-machine frameworks have proven their worth by finding defects in everything from the underlying AUTOSAR components of Volvo cars to digital invoicing systems. These case studies were carried out with Erlang’s commercial QuickCheck state-machine framework from Quviq, but such frameworks are now also available for Haskell, F#, Scala, Elixir, Java, etc. We present a typed state-machine framework for OCaml based on the QCheck library and illustrate a number of concepts common to all such frameworks: state modeling, commands, interpreting commands, preconditions, and agreement checking.|js}
  ; people = 
 []
  ; kind = `Conference
  ; tags = ["ocaml-workshop"]
  ; paper = Some {js|A Simple State-Machine Framework for Property-Based Testing in OCaml|js}
  ; link = {js|https://watch.ocaml.org/videos/watch/08b429ea-2eb8-427d-a625-5495f4ee0fef|js}
  ; embed = Some {js|https://watch.ocaml.org/videos/embed/08b429ea-2eb8-427d-a625-5495f4ee0fef|js}
  ; year = 2020
  }]

