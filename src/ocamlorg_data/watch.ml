type t =
  { name : string
  ; embed_path : string
  ; thumbnail_path : string
  ; description : string option
  ; published_at : string
  ; updated_at : string
  ; language : string
  ; category : string
  }

let all =
  [ { name = {js|25 Years of OCaml: Xavier Leroy|js}
    ; embed_path = {js|/videos/embed/e1ee0fc0-50ef-4a1c-894a-17df181424cb|js}
    ; thumbnail_path =
        {js|/static/thumbnails/94ead657-79a0-4c10-8435-9e13906a6c44.jpg|js}
    ; description =
        Some
          {js|Professor Xavier Leroy -- the primary original author and leader of the OCaml project -- reflects on 25 years of the OCaml language at his OCaml Workshop 2021 keynote speech.|js}
    ; published_at = {js|2021-08-27T13:23:10.199Z|js}
    ; updated_at = {js|2021-09-08T10:02:00.187Z|js}
    ; language = {js|English|js}
    ; category = {js|Science & Technology|js}
    }
  ; { name = {js|A Declarative Syntax Definition for OCaml|js}
    ; embed_path = {js|/videos/embed/a5b86864-8e43-4138-b6d6-ed48d2d4b63d|js}
    ; thumbnail_path =
        {js|/static/thumbnails/92c0a0e3-5326-42aa-86a3-6adb3927e111.jpg|js}
    ; description =
        Some
          {js|In this talk, we present our work on a syntax definition for the OCaml language in the syntax definition formalism SDF3. SDF3 supports the high-level definition of concrete and abstract syntax through declarative disambiguation and definition of c...|js}
    ; published_at = {js|2020-08-28T00:00:00.000Z|js}
    ; updated_at = {js|2021-09-01T04:02:00.070Z|js}
    ; language = {js|Unknown|js}
    ; category = {js|Misc|js}
    }
  ; { name = {js|A Multiverse of Glorious Documentation|js}
    ; embed_path = {js|/videos/embed/9bb452d6-1829-4dac-a6a2-46b31050c931|js}
    ; thumbnail_path =
        {js|/static/thumbnails/6a0a8291-4626-4820-8071-904b3c508345.jpg|js}
    ; description =
        Some
          {js|This talk describes the process of generating documentation for every version of every package that can be built from the opam repository, and how it is presented as a single coherent website that is continuously updated as new packages are releas...|js}
    ; published_at = {js|2021-08-27T11:23:36.000Z|js}
    ; updated_at = {js|2021-09-07T21:02:00.188Z|js}
    ; language = {js|English|js}
    ; category = {js|Science & Technology|js}
    }
  ; { name =
        {js|A Simple State-Machine Framework for Property-Based Testing in OCaml|js}
    ; embed_path = {js|/videos/embed/08b429ea-2eb8-427d-a625-5495f4ee0fef|js}
    ; thumbnail_path =
        {js|/static/thumbnails/316ddad9-dbc3-4d46-9f43-5da72689e93b.jpg|js}
    ; description =
        Some
          {js|Since their inception, state-machine frameworks have proven their worth by finding defects in everything from the underlying AUTOSAR components of Volvo cars to digital invoicing systems. These case studies were carried out with Erlang’s commercia...|js}
    ; published_at = {js|2020-08-28T00:00:00.000Z|js}
    ; updated_at = {js|2021-05-21T15:08:00.099Z|js}
    ; language = {js|Unknown|js}
    ; category = {js|Misc|js}
    }
  ; { name = {js|A review of the growth of the OCaml community|js}
    ; embed_path = {js|/videos/embed/f9d0b637-8aec-4bff-8c32-cd16b58023b6|js}
    ; thumbnail_path =
        {js|/static/thumbnails/e573402b-1350-4aa7-a9ba-0e1c51198fb4.jpg|js}
    ; description = None
    ; published_at = {js|2015-09-18T00:00:00.000Z|js}
    ; updated_at = {js|2021-08-03T17:05:33.471Z|js}
    ; language = {js|Unknown|js}
    ; category = {js|Science & Technology|js}
    }
  ; { name = {js|AD-OCaml: Algorithmic Differentiation for OCaml|js}
    ; embed_path = {js|/videos/embed/c9e85690-732f-4b03-836f-2ee0fd8f0658|js}
    ; thumbnail_path =
        {js|/static/thumbnails/eb972fd2-668e-4998-a798-e9fbdcadba20.jpg|js}
    ; description =
        Some
          {js|AD-OCaml is a library framework for calculating mathematically exact derivatives and deep power series approximations of almost arbitrary OCaml programs via algorithmic differentiation. Unlike similar frameworks, this includes programs with side e...|js}
    ; published_at = {js|2020-08-28T00:00:00.000Z|js}
    ; updated_at = {js|2021-04-19T19:24:10.203Z|js}
    ; language = {js|Unknown|js}
    ; category = {js|Misc|js}
    }
  ; { name = {js|API migration: compare transformed|js}
    ; embed_path = {js|/videos/embed/c46b925b-bd77-404f-ac5d-5dab65047529|js}
    ; thumbnail_path =
        {js|/static/thumbnails/eef64419-3c34-4c15-9419-edcbc455e54d.jpg|js}
    ; description =
        Some
          {js|In this talk we describe our experience in using an automatic API-migration strategy dedicated at changing the signatures of OCaml functions, using the Rotor refactoring tool for OCaml. We perform a case study on open source Jane Street libraries ...|js}
    ; published_at = {js|2020-08-28T00:00:00.000Z|js}
    ; updated_at = {js|2021-09-01T14:02:00.083Z|js}
    ; language = {js|Unknown|js}
    ; category = {js|Misc|js}
    }
  ; { name = {js|Adapting the OCaml ecosystem for Multicore OCaml|js}
    ; embed_path = {js|/videos/embed/629b89a8-bbd5-490d-98b0-d0c740912b02|js}
    ; thumbnail_path =
        {js|/static/thumbnails/41212c84-36d6-44fa-b884-2ced79505929.jpg|js}
    ; description =
        Some
          {js|OCaml 5.0 with support for shared-memory parallelism being around the corner, there’s increasing interest in the community to port existing libraries to Multicore. This talk will take the attendees through what the arrival of Multicore means to th...|js}
    ; published_at = {js|2021-08-27T10:18:38.000Z|js}
    ; updated_at = {js|2021-09-08T10:02:00.087Z|js}
    ; language = {js|English|js}
    ; category = {js|Science & Technology|js}
    }
  ; { name = {js|Binary Analysis Platform|js}
    ; embed_path = {js|/videos/embed/8dc2d8d3-c140-4c3d-a8fe-a6fcf6fba988|js}
    ; thumbnail_path =
        {js|/static/thumbnails/390cd7dd-4578-4162-bae0-6c218cb5ebde.jpg|js}
    ; description =
        Some
          {js|We present Binary Analysis Platform (BAP), a representation-agnostic program analysis framework for binaries that can leverage existing tools, libraries, and frameworks, no matter which intermediate representation (IR) they use. In BAP, a new IR c...|js}
    ; published_at = {js|2021-08-31T08:39:55.774Z|js}
    ; updated_at = {js|2021-09-04T14:02:00.212Z|js}
    ; language = {js|English|js}
    ; category = {js|Misc|js}
    }
  ; { name = {js|Continuous Benchmarking for OCaml Projects|js}
    ; embed_path = {js|/videos/embed/1c994370-1aaa-4db6-b901-d762786e4904|js}
    ; thumbnail_path =
        {js|/static/thumbnails/33ab36c3-3650-4c13-9fea-9b5907cf8c0f.jpg|js}
    ; description =
        Some
          {js|Regular CI systems are optimised for workloads that do not require stable performance over time. This makes them unsuitable for running performance benchmarks.

current-bench provides a predictable environment for performance benchmarks and a UI...|js}
    ; published_at = {js|2021-08-27T11:20:09.000Z|js}
    ; updated_at = {js|2021-09-06T12:02:00.082Z|js}
    ; language = {js|English|js}
    ; category = {js|Science & Technology|js}
    }
  ; { name = {js|Core Time stamp counter: A fast high resolution time source|js}
    ; embed_path = {js|/videos/embed/75b4d60f-3e37-40bd-b025-f39dcce0c42c|js}
    ; thumbnail_path =
        {js|/static/thumbnails/43248673-6478-4e96-b8ac-cd415d85569b.jpg|js}
    ; description = None
    ; published_at = {js|2015-09-18T00:00:00.000Z|js}
    ; updated_at = {js|2021-08-03T16:29:56.317Z|js}
    ; language = {js|English|js}
    ; category = {js|Science & Technology|js}
    }
  ; { name = {js|Deductive Verification of Realistic OCaml Code|js}
    ; embed_path = {js|/videos/embed/92309d92-8cbf-4545-980c-209c96e42a79|js}
    ; thumbnail_path =
        {js|/static/thumbnails/db29d3bf-784c-47f1-bf90-f13fd2a9d530.jpg|js}
    ; description =
        Some
          {js|We present the formal verification of a subset of the Set module from the OCaml standard library. The proof is conducted using Cameleer, a new tool for the deductive verification of OCaml code. Cameleer takes as input an OCaml program, annotated u...|js}
    ; published_at = {js|2021-08-27T10:33:38.000Z|js}
    ; updated_at = {js|2021-09-07T04:02:00.301Z|js}
    ; language = {js|English|js}
    ; category = {js|Science & Technology|js}
    }
  ; { name = {js|Digodoc and Docs|js}
    ; embed_path = {js|/videos/embed/db6ed2c4-e940-4d5f-82ee-d3d20eb4ceb7|js}
    ; thumbnail_path =
        {js|/static/thumbnails/43a418d6-56ec-48f4-852b-0a18ec0789aa.jpg|js}
    ; description =
        Some
          {js|In this talk, we will introduce a new tool called digodoc, that builds a graph of an opam switch, associating files, libraries and opam packages into a cyclic graph of inclusions and dependencies. We will then explain how we used that tool to buil...|js}
    ; published_at = {js|2021-08-27T12:09:56.000Z|js}
    ; updated_at = {js|2021-09-07T20:02:00.180Z|js}
    ; language = {js|English|js}
    ; category = {js|Science & Technology|js}
    }
  ; { name = {js|Effective Concurrency through Algebraic Effects|js}
    ; embed_path = {js|/videos/embed/e9f6c837-1435-4349-af0f-07d22d1c11ea|js}
    ; thumbnail_path =
        {js|/static/thumbnails/1de58bd2-d2f9-428c-8b8c-97b48d6d2c7e.jpg|js}
    ; description = None
    ; published_at = {js|2015-09-18T00:00:00.000Z|js}
    ; updated_at = {js|2021-09-07T10:02:00.076Z|js}
    ; language = {js|English|js}
    ; category = {js|Science & Technology|js}
    }
  ; { name = {js|Experiences with Effects in OCaml|js}
    ; embed_path = {js|/videos/embed/74ece0a8-380f-4e2a-bef5-c6bb9092be89|js}
    ; thumbnail_path =
        {js|/static/thumbnails/d48bf7bb-8c46-4d49-a3a6-734bf339343b.jpg|js}
    ; description =
        Some
          {js|The multicore branch of OCaml adds support for effect handlers. In this talk, we report our experiences with effects, both from converting existing code, and from writing new code. Converting the Angstrom parser from a callback style to effects gr...|js}
    ; published_at = {js|2021-08-27T14:41:07.000Z|js}
    ; updated_at = {js|2021-09-08T05:02:00.187Z|js}
    ; language = {js|English|js}
    ; category = {js|Science & Technology|js}
    }
  ; { name = {js|From 2n+1 to n|js}
    ; embed_path = {js|/videos/embed/74b32dae-11c6-4713-be1b-946260196e50|js}
    ; thumbnail_path =
        {js|/static/thumbnails/a2042ab9-9025-421a-9eae-176462ac594b.jpg|js}
    ; description =
        Some
          {js|
OCaml relies on a type-agnostic object representation centred around values which unify odd integers and aligned pointers. The last bit of a value distinguishes the two variants: zero indicates a pointer on the OCaml heap, while one encodes a ta...|js}
    ; published_at = {js|2021-08-31T08:30:23.211Z|js}
    ; updated_at = {js|2021-09-06T14:02:00.190Z|js}
    ; language = {js|English|js}
    ; category = {js|Misc|js}
    }
  ; { name = {js|Global Semantic Analysis on OCaml programs|js}
    ; embed_path = {js|/videos/embed/51e4bdf0-50f7-4b13-8514-2d62b5341066|js}
    ; thumbnail_path =
        {js|/static/thumbnails/8255d370-e621-44bc-b7c3-6dd39fab4d1d.jpg|js}
    ; description = None
    ; published_at = {js|2015-09-18T00:00:00.000Z|js}
    ; updated_at = {js|2021-08-03T16:55:20.938Z|js}
    ; language = {js|English|js}
    ; category = {js|Science & Technology|js}
    }
  ; { name = {js|GopCaml: A Structural Editor for OCaml|js}
    ; embed_path = {js|/videos/embed/e0a6e6f2-0d40-4dfc-9308-001c8e0f64d6|js}
    ; thumbnail_path =
        {js|/static/thumbnails/729cda51-abb3-4c8d-9d0e-b922e81be518.jpg|js}
    ; description =
        Some
          {js|This talk presents GopCaml-mode, the first structural editing plugin for OCaml. We will give a tour of the main plugin features, discussing the plugin’s internal design and its integration with existing OCaml and GNU Emacs toolchains.

Kiran Gop...|js}
    ; published_at = {js|2021-08-27T10:12:58.000Z|js}
    ; updated_at = {js|2021-09-07T15:02:00.164Z|js}
    ; language = {js|English|js}
    ; category = {js|Science & Technology|js}
    }
  ; { name = {js|Inline Assembly in OCaml|js}
    ; embed_path = {js|/videos/embed/632f520f-8f83-4b6f-89f1-5cde088436c7|js}
    ; thumbnail_path =
        {js|/static/thumbnails/5d2f65d1-6129-4206-832b-c3d4bab410df.jpg|js}
    ; description = None
    ; published_at = {js|2015-09-18T00:00:00.000Z|js}
    ; updated_at = {js|2021-08-03T16:39:42.613Z|js}
    ; language = {js|English|js}
    ; category = {js|Science & Technology|js}
    }
  ; { name = {js|Irmin v2|js}
    ; embed_path = {js|/videos/embed/53e497b0-898f-4c85-8da9-39f65ef0e0b1|js}
    ; thumbnail_path =
        {js|/static/thumbnails/138e7c05-185b-4e54-95d0-d15018905a39.jpg|js}
    ; description =
        Some
          {js|Irmin is an OCaml library for building distributed databases with the same design principles as Git. Existing Git users will find many familiar features: branching/merging, immutable causal history for all changes, and the ability to restore to an...|js}
    ; published_at = {js|2020-08-28T00:00:00.000Z|js}
    ; updated_at = {js|2021-09-07T15:02:00.070Z|js}
    ; language = {js|Unknown|js}
    ; category = {js|Misc|js}
    }
  ; { name = {js|Ketrew and Biokepi|js}
    ; embed_path = {js|/videos/embed/f3dcee35-bc04-453a-ba35-7aec90599661|js}
    ; thumbnail_path =
        {js|/static/thumbnails/0a36e8ce-c415-4191-ad5b-6ef2eb23db4e.jpg|js}
    ; description = None
    ; published_at = {js|2015-09-18T00:00:00.000Z|js}
    ; updated_at = {js|2021-08-03T22:36:42.344Z|js}
    ; language = {js|English|js}
    ; category = {js|Science & Technology|js}
    }
  ; { name = {js|Leveraging Formal Specifications to Generate Fuzzing Suites|js}
    ; embed_path = {js|/videos/embed/d9a36c9f-1611-42f9-8854-981b1e2d7d75|js}
    ; thumbnail_path =
        {js|/static/thumbnails/e5d18bd4-b482-463c-80f8-35d9fbb46b23.jpg|js}
    ; description =
        Some
          {js|When testing a library, developers typically first have to capture the semantics they want to check. They then write the code implementing these tests and find relevant test cases that expose possible misbehaviours.

In this work, we present a t...|js}
    ; published_at = {js|2021-08-27T10:40:06.000Z|js}
    ; updated_at = {js|2021-09-07T04:02:00.442Z|js}
    ; language = {js|English|js}
    ; category = {js|Science & Technology|js}
    }
  ; { name = {js|LexiFi Runtime Types|js}
    ; embed_path = {js|/videos/embed/cc7e3242-0bef-448a-aa13-8827bba933e3|js}
    ; thumbnail_path =
        {js|/static/thumbnails/1d43d8b4-87d1-4398-b925-10a42460b8dc.jpg|js}
    ; description =
        Some
          {js|OCaml programmers make deliberate use of abstract data types for composing safe and reliable software systems. The OCaml compiler relies on the invariants imposed by the type system to produce efficient and compact runtime data representations. Be...|js}
    ; published_at = {js|2020-08-28T00:00:00.000Z|js}
    ; updated_at = {js|2021-08-29T09:02:00.090Z|js}
    ; language = {js|Unknown|js}
    ; category = {js|Science & Technology|js}
    }
  ; { name = {js|Love: a readable language interpreted by a blockchain|js}
    ; embed_path = {js|/videos/embed/d3b2b31e-1739-406e-8de7-d5f21bc01836|js}
    ; thumbnail_path =
        {js|/static/thumbnails/93a6e9ac-2266-408a-81e7-1ebf239233f8.jpg|js}
    ; description =
        Some
          {js|We present Love, a smart contract language embedded in the Dune Network blockchain. It benefits from an OCaml-like syntax and a system-F inspired type system. Love has been used for deploying complex services such as games, ERC20s, atomic swaps, e...|js}
    ; published_at = {js|2021-08-27T15:10:17.000Z|js}
    ; updated_at = {js|2021-09-02T23:02:00.323Z|js}
    ; language = {js|English|js}
    ; category = {js|Science & Technology|js}
    }
  ; { name = {js|OCaml Under The Hood: SmartPy|js}
    ; embed_path = {js|/videos/embed/7446ad4d-4ae2-4e1a-bc38-af8f71e8ebd8|js}
    ; thumbnail_path =
        {js|/static/thumbnails/e1ac5b07-3648-40c1-b62c-5e88471741dc.jpg|js}
    ; description =
        Some
          {js|SmartPy is a complete system to develop smart-contracts for the Tezos blockchain. It is an embedded EDSL in python to write contracts and their test scenarios. It includes an online IDE, a chain explorer, and a command-line interface. Python is us...|js}
    ; published_at = {js|2020-08-28T00:00:00.000Z|js}
    ; updated_at = {js|2021-05-19T17:08:00.226Z|js}
    ; language = {js|Unknown|js}
    ; category = {js|Misc|js}
    }
  ; { name = {js|OCaml and Python: Getting the Best of Both Worlds|js}
    ; embed_path = {js|/videos/embed/9eafdb1e-9be9-4a52-98b4-f4696eda4c18|js}
    ; thumbnail_path =
        {js|/static/thumbnails/53db83d1-0763-4dfa-a087-cce3cad1b581.jpg|js}
    ; description =
        Some
          {js|In this talk we present how we expose a wide variety of OCaml libraries and services so that they can be accessed from Python. Our initial use case on the Python side consisted in Jupyter notebooks used to analyse various datasets, these datasets ...|js}
    ; published_at = {js|2021-08-27T10:16:54.000Z|js}
    ; updated_at = {js|2021-09-07T15:02:00.247Z|js}
    ; language = {js|English|js}
    ; category = {js|Science & Technology|js}
    }
  ; { name = {js|OCaml-CI : A Zero-Configuration CI|js}
    ; embed_path = {js|/videos/embed/0fee79e8-715a-400b-bfcc-34c3610f4890|js}
    ; thumbnail_path =
        {js|/static/thumbnails/596f39a9-8654-4922-8bec-6e7ac5dcc319.jpg|js}
    ; description =
        Some
          {js|OCaml-CI

is a CI service for OCaml projects. It
uses metadata from the project’s opam and dune
files to work out what to build, and uses caching
to make builds fast. It automatically tests projects
against multiple OCaml versions and OS platforms...|js}
    ; published_at = {js|2020-08-28T00:00:00.000Z|js}
    ; updated_at = {js|2021-09-04T20:02:00.100Z|js}
    ; language = {js|English|js}
    ; category = {js|Misc|js}
    }
  ; { name = {js|OCaml-CI : A Zero-Configuration CI|js}
    ; embed_path = {js|/videos/embed/da88d6ac-7ba1-4261-9308-d03fe21e35b9|js}
    ; thumbnail_path =
        {js|/static/thumbnails/1c22a14e-f067-4d4e-8e26-027cc6d8a491.jpg|js}
    ; description =
        Some
          {js|OCaml-CI1 is a CI service for OCaml projects. It uses metadata from the project’s opam and dune files to work out what to build, and uses caching to make builds fast. It automatically tests projects against multiple OCaml versions and OS platforms...|js}
    ; published_at = {js|2020-08-28T00:00:00.000Z|js}
    ; updated_at = {js|2021-05-27T16:35:41.085Z|js}
    ; language = {js|English|js}
    ; category = {js|Science & Technology|js}
    }
  ; { name = {js|Opam-bin: Binary Packages with Opam|js}
    ; embed_path = {js|/videos/embed/a889e4d3-0508-4734-b667-7060b0a253cd|js}
    ; thumbnail_path =
        {js|/static/thumbnails/b2325a24-f068-473b-961e-a0b783ae5c39.jpg|js}
    ; description =
        Some
          {js|In this talk, we will present opam-bin, an Opam plugin that builds Binary Opam packages on the fly, to speed-up reinstallation of pack- ages. opam-bin also creates Opam Repositories for these binary pack- ages, to make them easy to share with othe...|js}
    ; published_at = {js|2021-08-27T15:01:40.000Z|js}
    ; updated_at = {js|2021-09-08T06:02:00.094Z|js}
    ; language = {js|English|js}
    ; category = {js|Science & Technology|js}
    }
  ; { name = {js|Operf: Benchmarking the OCaml Compiler|js}
    ; embed_path = {js|/videos/embed/5a4a6c12-3cb1-40d2-a663-25f294e12555|js}
    ; thumbnail_path =
        {js|/static/thumbnails/c2b5c90a-9c9e-4058-94a1-15525795a01a.jpg|js}
    ; description = None
    ; published_at = {js|2015-09-18T00:00:00.000Z|js}
    ; updated_at = {js|2021-08-03T16:23:23.889Z|js}
    ; language = {js|English|js}
    ; category = {js|Science & Technology|js}
    }
  ; { name =
        {js|Parafuzz: Coverage-guided Property Fuzzing for Multicore OCaml programs|js}
    ; embed_path = {js|/videos/embed/c0d591e0-91c9-4eaa-a4d7-c4f514de0a57|js}
    ; thumbnail_path =
        {js|/static/thumbnails/b1a67c0a-2eb9-4c9d-97ce-b4dc039da59b.jpg|js}
    ; description =
        Some
          {js|We develop ParaFuzz, an input and concurrency fuzzing tool for Multicore OCaml programs. ParaFuzz builds on top of Crowbar which combines AFL-based grey box fuzzing with QuickCheck and extends it to handle parallelism.

Sumit Padhiyar
Indian In...|js}
    ; published_at = {js|2021-08-27T10:36:13.000Z|js}
    ; updated_at = {js|2021-09-07T04:02:00.349Z|js}
    ; language = {js|English|js}
    ; category = {js|Science & Technology|js}
    }
  ; { name = {js|Parallelising your OCaml Code with Multicore OCaml|js}
    ; embed_path = {js|/videos/embed/ce20839e-4bfc-4d74-925b-485a6b052ddf|js}
    ; thumbnail_path =
        {js|/static/thumbnails/30bc6019-ecab-40e5-a7b6-c294ac9a7344.jpg|js}
    ; description =
        Some
          {js|Slides, speaker notes and runnable examples mentioned in this talk are available at: https://github.com/ocaml-multicore/ocaml2020-workshop-parallel

With the availability of multicore variants of the recent OCaml versions (4.10 and 4.11) that main...|js}
    ; published_at = {js|2020-08-28T00:00:00.000Z|js}
    ; updated_at = {js|2021-09-05T03:02:00.936Z|js}
    ; language = {js|Unknown|js}
    ; category = {js|Misc|js}
    }
  ; { name = {js|Persistent Networking with Irmin and MirageOS|js}
    ; embed_path = {js|/videos/embed/97dd9634-28e4-4066-96e4-9c2036ee4bb2|js}
    ; thumbnail_path =
        {js|/static/thumbnails/46ba8c5d-0f4a-427e-8e76-0c58cb0e70a7.jpg|js}
    ; description = None
    ; published_at = {js|2015-09-18T00:00:00.000Z|js}
    ; updated_at = {js|2021-08-03T17:09:03.939Z|js}
    ; language = {js|English|js}
    ; category = {js|Science & Technology|js}
    }
  ; { name = {js|Probabilistic resource limits using StatMemprof|js}
    ; embed_path = {js|/videos/embed/bc297e85-82dd-4baf-8556-4a3a934978f9|js}
    ; thumbnail_path =
        {js|/static/thumbnails/9b4dc06e-1d07-45b8-a21a-1e4f39897fef.jpg|js}
    ; description =
        Some
          {js|The goal of this talk is two-fold. First, we present memprof-limits, a probabilistic implementation of per-thread global memory limits, and per-thread allocation limits, for OCaml 4.12. Then, we will discuss the reasoning about programs in the pre...|js}
    ; published_at = {js|2021-08-27T11:08:12.000Z|js}
    ; updated_at = {js|2021-09-06T04:02:01.770Z|js}
    ; language = {js|English|js}
    ; category = {js|Science & Technology|js}
    }
  ; { name = {js|Property-Based Testing for OCaml through Coq|js}
    ; embed_path = {js|/videos/embed/9324fba4-2482-4bab-bfdd-b8881b3ed94a|js}
    ; thumbnail_path =
        {js|/static/thumbnails/d7e22bba-cda1-4c2b-9368-9b2c1643e751.jpg|js}
    ; description =
        Some
          {js|We will present a property-based testing framework for OCaml that leverages the power of QuickChick, a popular and mature testing plugin for the Coq proof assistant, by automatically constructing a extraction-based shim between OCaml and Coq. That...|js}
    ; published_at = {js|2021-08-31T08:37:00.571Z|js}
    ; updated_at = {js|2021-09-06T10:02:00.283Z|js}
    ; language = {js|English|js}
    ; category = {js|Misc|js}
    }
  ; { name = {js|Safe Protocol Updates via Propositional Logic|js}
    ; embed_path = {js|/videos/embed/c6176f51-0277-46f0-937b-1e2721044492|js}
    ; thumbnail_path =
        {js|/static/thumbnails/a89a3483-274a-44f1-9a38-c679f6b12196.jpg|js}
    ; description =
        Some
          {js|If values of a given type are stored on disk, or are sent between different executables, then changing that type or its serialization can result in versioning issues.
Often such issues are resolved by either making the deserializer more permissiv...|js}
    ; published_at = {js|2021-08-31T08:34:54.707Z|js}
    ; updated_at = {js|2021-09-04T14:02:00.088Z|js}
    ; language = {js|English|js}
    ; category = {js|Misc|js}
    }
  ; { name =
        {js|Semgrep : a fast, lightweight, polyglot static analysis tool to find bugs|js}
    ; embed_path = {js|/videos/embed/c0d07213-1426-46a1-98e0-0b0c4515c841|js}
    ; thumbnail_path =
        {js|/static/thumbnails/2ab3961f-4e66-4ec9-b20e-72e25dfbebe4.jpg|js}
    ; description =
        Some
          {js|Semgrep, which stands for “semantic grep,” is a fast, lightweight, polyglot, open source static analysis tool to find bugs and enforce code standards. It is used internally by many companies including Dropbox and Snowflake. Semgrep is also now use...|js}
    ; published_at = {js|2021-08-31T08:41:15.492Z|js}
    ; updated_at = {js|2021-09-05T16:02:01.373Z|js}
    ; language = {js|English|js}
    ; category = {js|Misc|js}
    }
  ; { name = {js|Specialization of Generic Array Accesses After Inlining|js}
    ; embed_path = {js|/videos/embed/80553916-b90a-4641-93c8-35b000df04c1|js}
    ; thumbnail_path =
        {js|/static/thumbnails/1f81fbbf-6fb0-4047-93a1-57759431166a.jpg|js}
    ; description = None
    ; published_at = {js|2015-09-18T00:00:00.000Z|js}
    ; updated_at = {js|2021-08-03T16:34:23.463Z|js}
    ; language = {js|Unknown|js}
    ; category = {js|Science & Technology|js}
    }
  ; { name = {js|State of the OCaml Platform|js}
    ; embed_path = {js|/videos/embed/390ce74c-f85f-477d-8f20-504437409add|js}
    ; thumbnail_path =
        {js|/static/thumbnails/33258292-009b-42ee-83d3-9eb4bfb4e048.jpg|js}
    ; description = None
    ; published_at = {js|2018-01-12T00:00:00.000Z|js}
    ; updated_at = {js|2021-07-27T12:08:00.264Z|js}
    ; language = {js|English|js}
    ; category = {js|Science & Technology|js}
    }
  ; { name = {js|State of the OCaml Platform 2020|js}
    ; embed_path = {js|/videos/embed/0e2070fd-798b-47f7-8e69-ef75e967e516|js}
    ; thumbnail_path =
        {js|/static/thumbnails/4fd6a51f-686c-4f6f-8026-83692304b432.jpg|js}
    ; description =
        Some
          {js|This talk covers:

- Integrated Development Environments
- Next Steps for the OCaml Platform
- Plans for 2020-2021|js}
    ; published_at = {js|2020-08-28T00:00:00.000Z|js}
    ; updated_at = {js|2021-08-30T08:02:00.086Z|js}
    ; language = {js|English|js}
    ; category = {js|Science & Technology|js}
    }
  ; { name = {js|The ImpFS filesystem|js}
    ; embed_path = {js|/videos/embed/28545b27-4637-47a5-8edd-6b904daef19c|js}
    ; thumbnail_path =
        {js|/static/thumbnails/dde19660-653d-4dc3-9e81-54b2e3ab22a2.jpg|js}
    ; description =
        Some
          {js|This proposal describes a presentation to be given at the OCaml’20 workshop. The presentation will cover a new OCaml filesystem, ImpFS, and the related libraries. The filesystem makes use of a B-tree library presented at OCaml’17, and a key-value ...|js}
    ; published_at = {js|2020-08-28T00:00:00.000Z|js}
    ; updated_at = {js|2021-09-04T20:02:00.472Z|js}
    ; language = {js|Unknown|js}
    ; category = {js|Misc|js}
    }
  ; { name = {js|The OCaml Platform 1.0 - Reason ML|js}
    ; embed_path = {js|/videos/embed/bd9a8e54-6ca5-4036-a08c-6a47cee6619e|js}
    ; thumbnail_path =
        {js|/static/thumbnails/ddc1e6fb-9999-4e79-b458-31c7e3ec1108.jpg|js}
    ; description =
        Some
          {js|Presented by Anil Madhavapeddy (@avsm)

We keep being told ReasonML can compile to native and do interop with OCaml, and that there's a wealth of existing code and tools we can draw into our applications - but how do we get there?
This video will ...|js}
    ; published_at = {js|2018-12-11T00:00:00.000Z|js}
    ; updated_at = {js|2021-09-03T14:02:00.094Z|js}
    ; language = {js|English|js}
    ; category = {js|Science & Technology|js}
    }
  ; { name = {js|The State of OCaml|js}
    ; embed_path = {js|/videos/embed/60a2ecfb-86ea-4881-a279-0a928452a3c3|js}
    ; thumbnail_path =
        {js|/static/thumbnails/a5e5f630-2df9-4691-8ddf-a8137001ab4c.jpg|js}
    ; description = None
    ; published_at = {js|2015-09-18T00:00:00.000Z|js}
    ; updated_at = {js|2021-09-02T10:02:00.083Z|js}
    ; language = {js|English|js}
    ; category = {js|Science & Technology|js}
    }
  ; { name = {js|The State of the OCaml Platform|js}
    ; embed_path = {js|/videos/embed/32475a83-b455-455b-937f-28e7185f4fc2|js}
    ; thumbnail_path =
        {js|/static/thumbnails/7eb8af05-a6d5-4a88-89f3-146673a87cf0.jpg|js}
    ; description = None
    ; published_at = {js|2015-09-18T00:00:00.000Z|js}
    ; updated_at = {js|2021-08-03T16:47:54.414Z|js}
    ; language = {js|English|js}
    ; category = {js|Science & Technology|js}
    }
  ; { name = {js|The final pieces of the OCaml documentation puzzle|js}
    ; embed_path = {js|/videos/embed/2acebff9-25fa-4733-83cc-620a65b12251|js}
    ; thumbnail_path =
        {js|/static/thumbnails/c877a501-c705-44f7-8826-e7ce846a5e42.jpg|js}
    ; description =
        Some
          {js|Rendering OCaml document is widely known as a very difficult task: The ever-evolving OCaml module system is extremely rich and can include complex set of inter-dependencies that are both difficult to compute and to render in a concise document. It...|js}
    ; published_at = {js|2020-08-28T00:00:00.000Z|js}
    ; updated_at = {js|2021-09-05T03:02:00.455Z|js}
    ; language = {js|English|js}
    ; category = {js|Misc|js}
    }
  ; { name = {js|Towards A Debugger for Native Code OCaml|js}
    ; embed_path = {js|/videos/embed/b76f3301-261d-44f3-97ec-1910b45f6969|js}
    ; thumbnail_path =
        {js|/static/thumbnails/93ea327e-5e8b-4844-b237-75719a7256b9.jpg|js}
    ; description = None
    ; published_at = {js|2015-09-18T00:00:00.000Z|js}
    ; updated_at = {js|2021-08-03T16:20:17.728Z|js}
    ; language = {js|English|js}
    ; category = {js|Science & Technology|js}
    }
  ; { name = {js|Types in Amber|js}
    ; embed_path = {js|/videos/embed/99b3dc75-9f93-4677-9f8b-076546725512|js}
    ; thumbnail_path =
        {js|/static/thumbnails/acd50ed1-43cf-45fd-a55e-9c40a6bf58ba.jpg|js}
    ; description =
        Some
          {js|Coda is a new cryptocurrency that uses zk-SNARKs to dramatically reduce the size of data needed by nodes running its protocol. Nodes communicate in a format automatically derived from type definitions in OCaml source files. As the Coda software ev...|js}
    ; published_at = {js|2020-08-28T00:00:00.000Z|js}
    ; updated_at = {js|2021-08-29T09:02:00.201Z|js}
    ; language = {js|Unknown|js}
    ; category = {js|Misc|js}
    }
  ; { name = {js|Wibbily Wobbly Timey Camly|js}
    ; embed_path = {js|/videos/embed/ec641446-823b-40ec-a207-85157a18f88e|js}
    ; thumbnail_path =
        {js|/static/thumbnails/2300474a-7615-4c92-9489-9ff5117d8bc7.jpg|js}
    ; description =
        Some
          {js|Time handling is commonly considered a difficult problem by programmers due to myriad standards and complexity of time zone definitions. This also complicates scheduling across multiple time zones especially when one takes Daylight Saving Time int...|js}
    ; published_at = {js|2021-08-27T10:37:18.000Z|js}
    ; updated_at = {js|2021-09-07T04:02:00.396Z|js}
    ; language = {js|English|js}
    ; category = {js|Science & Technology|js}
    }
  ]
