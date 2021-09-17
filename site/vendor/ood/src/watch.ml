

  type t =
  { name: string;
    embedPath : string;
    thumbnailPath : string;
    description : string;
    year : int;
    language : string;
    category : string;
  }
  
let all = 
[
  { name = {js|State of the OCaml Platform 2020|js}
  ; embedPath = {js|/videos/embed/0e2070fd-798b-47f7-8e69-ef75e967e516|js}
  ; thumbnailPath = {js|/static/thumbnails/4fd6a51f-686c-4f6f-8026-83692304b432.jpg|js}
  ; description = {js|This talk covers: - Integrated Development Environments - Next Steps for the OCaml Platform - Plans for 2020-2021|js}
  ; year = 2020
  ; language = {js|English|js}
  ; category = {js|Science & Technology|js}
  };
 
  { name = {js|OCaml-CI : A Zero-Configuration CI|js}
  ; embedPath = {js|/videos/embed/0fee79e8-715a-400b-bfcc-34c3610f4890|js}
  ; thumbnailPath = {js|/static/thumbnails/596f39a9-8654-4922-8bec-6e7ac5dcc319.jpg|js}
  ; description = {js|OCaml-CI

is a CI service for OCaml projects. It
uses metadata from the project’s opam and dune
files to work out what to build, and uses caching
to make builds fast. It automatically tests projects
against multiple OCaml versions and OS platforms...|js}
  ; year = 2020
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|The final pieces of the OCaml documentation puzzle|js}
  ; embedPath = {js|/videos/embed/2acebff9-25fa-4733-83cc-620a65b12251|js}
  ; thumbnailPath = {js|/static/thumbnails/c877a501-c705-44f7-8826-e7ce846a5e42.jpg|js}
  ; description = {js|Rendering OCaml document is widely known as a very difficult task: The ever-evolving OCaml module system is extremely rich and can include complex set of inter-dependencies that are both difficult to compute and to render in a concise document. It...|js}
  ; year = 2020
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|API migration: compare transformed|js}
  ; embedPath = {js|/videos/embed/c46b925b-bd77-404f-ac5d-5dab65047529|js}
  ; thumbnailPath = {js|/static/thumbnails/eef64419-3c34-4c15-9419-edcbc455e54d.jpg|js}
  ; description = {js|In this talk we describe our experience in using an automatic API-migration strategy dedicated at changing the signatures of OCaml functions, using the Rotor refactoring tool for OCaml. We perform a case study on open source Jane Street libraries ...|js}
  ; year = 2020
  ; language = {js|Unknown|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|Parallelising your OCaml Code with Multicore OCaml|js}
  ; embedPath = {js|/videos/embed/ce20839e-4bfc-4d74-925b-485a6b052ddf|js}
  ; thumbnailPath = {js|/static/thumbnails/30bc6019-ecab-40e5-a7b6-c294ac9a7344.jpg|js}
  ; description = {js|Slides, speaker notes and runnable examples mentioned in this talk are available at: https://github.com/ocaml-multicore/ocaml2020-workshop-parallel With the availability of multicore variants of the recent OCaml versions (4.10 and 4.11) that main...|js}
  ; year = 2020
  ; language = {js|Unknown|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|A Simple State-Machine Framework for Property-Based Testing in OCaml|js}
  ; embedPath = {js|/videos/embed/08b429ea-2eb8-427d-a625-5495f4ee0fef|js}
  ; thumbnailPath = {js|/static/thumbnails/316ddad9-dbc3-4d46-9f43-5da72689e93b.jpg|js}
  ; description = {js|Since their inception, state-machine frameworks have proven their worth by finding defects in everything from the underlying AUTOSAR components of Volvo cars to digital invoicing systems. These case studies were carried out with Erlang’s commercia...|js}
  ; year = 2020
  ; language = {js|Unknown|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|The ImpFS filesystem|js}
  ; embedPath = {js|/videos/embed/28545b27-4637-47a5-8edd-6b904daef19c|js}
  ; thumbnailPath = {js|/static/thumbnails/dde19660-653d-4dc3-9e81-54b2e3ab22a2.jpg|js}
  ; description = {js|This proposal describes a presentation to be given at the OCaml’20 workshop. The presentation will cover a new OCaml filesystem, ImpFS, and the related libraries. The filesystem makes use of a B-tree library presented at OCaml’17, and a key-value ...|js}
  ; year = 2020
  ; language = {js|Unknown|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|Irmin v2|js}
  ; embedPath = {js|/videos/embed/53e497b0-898f-4c85-8da9-39f65ef0e0b1|js}
  ; thumbnailPath = {js|/static/thumbnails/138e7c05-185b-4e54-95d0-d15018905a39.jpg|js}
  ; description = {js|Irmin is an OCaml library for building distributed databases with the same design principles as Git. Existing Git users will find many familiar features: branching/merging, immutable causal history for all changes, and the ability to restore to an...|js}
  ; year = 2020
  ; language = {js|Unknown|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|AD-OCaml: Algorithmic Differentiation for OCaml|js}
  ; embedPath = {js|/videos/embed/c9e85690-732f-4b03-836f-2ee0fd8f0658|js}
  ; thumbnailPath = {js|/static/thumbnails/eb972fd2-668e-4998-a798-e9fbdcadba20.jpg|js}
  ; description = {js|AD-OCaml is a library framework for calculating mathematically exact derivatives and deep power series approximations of almost arbitrary OCaml programs via algorithmic differentiation. Unlike similar frameworks, this includes programs with side e...|js}
  ; year = 2020
  ; language = {js|Unknown|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|OCaml Under The Hood: SmartPy|js}
  ; embedPath = {js|/videos/embed/7446ad4d-4ae2-4e1a-bc38-af8f71e8ebd8|js}
  ; thumbnailPath = {js|/static/thumbnails/e1ac5b07-3648-40c1-b62c-5e88471741dc.jpg|js}
  ; description = {js|SmartPy is a complete system to develop smart-contracts for the Tezos blockchain. It is an embedded EDSL in python to write contracts and their test scenarios. It includes an online IDE, a chain explorer, and a command-line interface. Python is us...|js}
  ; year = 2020
  ; language = {js|Unknown|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|A Declarative Syntax Definition for OCaml|js}
  ; embedPath = {js|/videos/embed/a5b86864-8e43-4138-b6d6-ed48d2d4b63d|js}
  ; thumbnailPath = {js|/static/thumbnails/92c0a0e3-5326-42aa-86a3-6adb3927e111.jpg|js}
  ; description = {js|In this talk, we present our work on a syntax definition for the OCaml language in the syntax definition formalism SDF3. SDF3 supports the high-level definition of concrete and abstract syntax through declarative disambiguation and definition of c...|js}
  ; year = 2020
  ; language = {js|Unknown|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|LexiFi Runtime Types|js}
  ; embedPath = {js|/videos/embed/cc7e3242-0bef-448a-aa13-8827bba933e3|js}
  ; thumbnailPath = {js|/static/thumbnails/1d43d8b4-87d1-4398-b925-10a42460b8dc.jpg|js}
  ; description = {js|OCaml programmers make deliberate use of abstract data types for composing safe and reliable software systems. The OCaml compiler relies on the invariants imposed by the type system to produce efficient and compact runtime data representations. Be...|js}
  ; year = 2020
  ; language = {js|Unknown|js}
  ; category = {js|Science & Technology|js}
  };
 
  { name = {js|Types in Amber|js}
  ; embedPath = {js|/videos/embed/99b3dc75-9f93-4677-9f8b-076546725512|js}
  ; thumbnailPath = {js|/static/thumbnails/acd50ed1-43cf-45fd-a55e-9c40a6bf58ba.jpg|js}
  ; description = {js|Coda is a new cryptocurrency that uses zk-SNARKs to dramatically reduce the size of data needed by nodes running its protocol. Nodes communicate in a format automatically derived from type definitions in OCaml source files. As the Coda software ev...|js}
  ; year = 2020
  ; language = {js|Unknown|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|OCaml-CI : A Zero-Configuration CI|js}
  ; embedPath = {js|/videos/embed/da88d6ac-7ba1-4261-9308-d03fe21e35b9|js}
  ; thumbnailPath = {js|/static/thumbnails/1c22a14e-f067-4d4e-8e26-027cc6d8a491.jpg|js}
  ; description = {js|OCaml-CI1 is a CI service for OCaml projects. It uses metadata from the project’s opam and dune files to work out what to build, and uses caching to make builds fast. It automatically tests projects against multiple OCaml versions and OS platforms...|js}
  ; year = 2020
  ; language = {js|English|js}
  ; category = {js|Science & Technology|js}
  };
 
  { name = {js|History and key features of OCaml Language|js}
  ; embedPath = {js|/videos/embed/64da4a9f-777e-478a-bd94-94ea8b57e570|js}
  ; thumbnailPath = {js|/static/thumbnails/878b7470-9eea-4321-9276-3f888571c4e4.jpg|js}
  ; description = {js|The OCaml programming language is a member of the ML language family pioneered by Robin Milner. An important feature of OCaml is that it reconciles the conciseness and flexibility of untyped programming languages (like Python, for example) with th...|js}
  ; year = 2020
  ; language = {js|English|js}
  ; category = {js|Education|js}
  }]

