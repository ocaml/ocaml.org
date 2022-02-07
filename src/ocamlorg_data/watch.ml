

  type t =
  { name: string;
    embed_path : string;
    thumbnail_path : string;
    description : string option;
    published_at : string;
    updated_at : string;
    language : string;
    category : string;
  }
  
let all = 
[
  { name = {js|25 Years of OCaml: Xavier Leroy|js}
  ; embed_path = {js|/videos/embed/e1ee0fc0-50ef-4a1c-894a-17df181424cb|js}
  ; thumbnail_path = {js|/static/thumbnails/94ead657-79a0-4c10-8435-9e13906a6c44.jpg|js}
  ; description = Some {js|Professor Xavier Leroy -- the primary original author and leader of the OCaml project -- reflects on 25 years of the OCaml language at his OCaml Workshop 2021 keynote speech.|js}
  ; published_at = {js|2021-08-27T13:23:10.199Z|js}
  ; updated_at = {js|2022-02-07T09:01:00.081Z|js}
  ; language = {js|English|js}
  ; category = {js|Science & Technology|js}
  };
 
  { name = {js|A Case for Multi-Switch Constraints in OPAM|js}
  ; embed_path = {js|/videos/embed/744d4a0b-a44c-4040-853c-6be5223ec43b|js}
  ; thumbnail_path = {js|/static/thumbnails/3973b521-c198-4a18-93a1-7190f8f811da.jpg|js}
  ; description = Some {js|A Case for Multi-Switch Constraints in OPAM - by Fabrice Le Fessant (INRIA)

Package managers usually only deal with packages and their versions, and the constraints on their dependencies towards other packages’ versions. Among package managers,...|js}
  ; published_at = {js|2021-10-02T02:02:32.873Z|js}
  ; updated_at = {js|2021-10-02T02:02:54.941Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|A Declarative Syntax Definition for OCaml|js}
  ; embed_path = {js|/videos/embed/a5b86864-8e43-4138-b6d6-ed48d2d4b63d|js}
  ; thumbnail_path = {js|/static/thumbnails/92c0a0e3-5326-42aa-86a3-6adb3927e111.jpg|js}
  ; description = Some {js|In this talk, we present our work on a syntax definition for the OCaml language in the syntax definition formalism SDF3. SDF3 supports the high-level definition of concrete and abstract syntax through declarative disambiguation and definition of c...|js}
  ; published_at = {js|2020-08-28T00:00:00.000Z|js}
  ; updated_at = {js|2021-09-01T04:02:00.070Z|js}
  ; language = {js|Unknown|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|A Multiverse of Glorious Documentation|js}
  ; embed_path = {js|/videos/embed/9bb452d6-1829-4dac-a6a2-46b31050c931|js}
  ; thumbnail_path = {js|/static/thumbnails/6a0a8291-4626-4820-8071-904b3c508345.jpg|js}
  ; description = Some {js|This talk describes the process of generating documentation for every version of every package that can be built from the opam repository, and how it is presented as a single coherent website that is continuously updated as new packages are releas...|js}
  ; published_at = {js|2021-08-27T11:23:36.000Z|js}
  ; updated_at = {js|2022-01-18T10:01:00.270Z|js}
  ; language = {js|English|js}
  ; category = {js|Science & Technology|js}
  };
 
  { name = {js|A Proposal for Non-Intrusive Namespaces in OCaml|js}
  ; embed_path = {js|/videos/embed/ded6e8bb-aebd-4fd2-989f-3f0b2b8efaf3|js}
  ; thumbnail_path = {js|/static/thumbnails/cb3f10b6-c34c-4b7e-af35-a056675d8ccd.jpg|js}
  ; description = Some {js|A Proposal for Non-Intrusive Namespaces in OCaml, by Pierrick Couderc (I), Fabrice Le Fessant (I+O), Benjamin Canou (O), Pierre Chambart (O); (I = INRIA, O = OCamlPro)

We present a work-in-progress about adding namespaces to OCaml. Inspired by ...|js}
  ; published_at = {js|2021-10-02T02:04:48.044Z|js}
  ; updated_at = {js|2021-10-02T02:04:48.044Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|A Simple State-Machine Framework for Property-Based Testing in OCaml|js}
  ; embed_path = {js|/videos/embed/08b429ea-2eb8-427d-a625-5495f4ee0fef|js}
  ; thumbnail_path = {js|/static/thumbnails/316ddad9-dbc3-4d46-9f43-5da72689e93b.jpg|js}
  ; description = Some {js|Since their inception, state-machine frameworks have proven their worth by finding defects in everything from the underlying AUTOSAR components of Volvo cars to digital invoicing systems. These case studies were carried out with Erlang’s commercia...|js}
  ; published_at = {js|2020-08-28T00:00:00.000Z|js}
  ; updated_at = {js|2021-10-02T13:02:00.073Z|js}
  ; language = {js|Unknown|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|A review of the growth of the OCaml community|js}
  ; embed_path = {js|/videos/embed/f9d0b637-8aec-4bff-8c32-cd16b58023b6|js}
  ; thumbnail_path = {js|/static/thumbnails/e573402b-1350-4aa7-a9ba-0e1c51198fb4.jpg|js}
  ; description = None
  ; published_at = {js|2015-09-18T00:00:00.000Z|js}
  ; updated_at = {js|2021-08-03T17:05:33.471Z|js}
  ; language = {js|Unknown|js}
  ; category = {js|Science & Technology|js}
  };
 
  { name = {js|AD-OCaml: Algorithmic Differentiation for OCaml|js}
  ; embed_path = {js|/videos/embed/c9e85690-732f-4b03-836f-2ee0fd8f0658|js}
  ; thumbnail_path = {js|/static/thumbnails/eb972fd2-668e-4998-a798-e9fbdcadba20.jpg|js}
  ; description = Some {js|AD-OCaml is a library framework for calculating mathematically exact derivatives and deep power series approximations of almost arbitrary OCaml programs via algorithmic differentiation. Unlike similar frameworks, this includes programs with side e...|js}
  ; published_at = {js|2020-08-28T00:00:00.000Z|js}
  ; updated_at = {js|2021-12-23T08:02:00.279Z|js}
  ; language = {js|Unknown|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|API migration: compare transformed|js}
  ; embed_path = {js|/videos/embed/c46b925b-bd77-404f-ac5d-5dab65047529|js}
  ; thumbnail_path = {js|/static/thumbnails/eef64419-3c34-4c15-9419-edcbc455e54d.jpg|js}
  ; description = Some {js|In this talk we describe our experience in using an automatic API-migration strategy dedicated at changing the signatures of OCaml functions, using the Rotor refactoring tool for OCaml. We perform a case study on open source Jane Street libraries ...|js}
  ; published_at = {js|2020-08-28T00:00:00.000Z|js}
  ; updated_at = {js|2021-09-01T14:02:00.083Z|js}
  ; language = {js|Unknown|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|Adapting the OCaml ecosystem for Multicore OCaml|js}
  ; embed_path = {js|/videos/embed/629b89a8-bbd5-490d-98b0-d0c740912b02|js}
  ; thumbnail_path = {js|/static/thumbnails/41212c84-36d6-44fa-b884-2ced79505929.jpg|js}
  ; description = Some {js|OCaml 5.0 with support for shared-memory parallelism being around the corner, there’s increasing interest in the community to port existing libraries to Multicore. This talk will take the attendees through what the arrival of Multicore means to th...|js}
  ; published_at = {js|2021-08-27T10:18:38.000Z|js}
  ; updated_at = {js|2022-01-21T20:01:00.099Z|js}
  ; language = {js|English|js}
  ; category = {js|Science & Technology|js}
  };
 
  { name = {js|An LLVM backend for OCaml|js}
  ; embed_path = {js|/videos/embed/3ede0b76-e250-4a43-af42-83c394cf4497|js}
  ; thumbnail_path = {js|/static/thumbnails/4dfc2ff3-3c53-4e7c-85ed-907df5b1faff.jpg|js}
  ; description = Some {js|An LLVM backend for OCaml by Colin Benner.

As part of my bachelor thesis I have implemented a new backend for the OCaml nativecode compiler ocamlopt for the AMD64 architecture. It uses the Low Level Virtual Machine framework (LLVM, an optimisin...|js}
  ; published_at = {js|2021-10-03T22:23:18.701Z|js}
  ; updated_at = {js|2021-10-03T22:23:18.701Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|Arakoon - a distributed consistent key-value store|js}
  ; embed_path = {js|/videos/embed/5309b701-9def-47a4-8240-8a5b17a70b5a|js}
  ; thumbnail_path = {js|/static/thumbnails/5bbbdabf-622b-4496-8d43-7c2515300678.jpg|js}
  ; description = Some {js|Arakoon - a distributed consistent key-value store, by Nicolas Trangez.

Arakoon is a simple consistent distributed key value store. Technically, it’s an OCaml implementation of Multi-Paxos on top of Tokyo Cabinet, using Ocsigen’s Light Weight T...|js}
  ; published_at = {js|2021-10-03T22:38:56.202Z|js}
  ; updated_at = {js|2022-01-29T16:01:00.299Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|Async|js}
  ; embed_path = {js|/videos/embed/8f50211a-1210-4849-a940-ea6e0bd1e022|js}
  ; thumbnail_path = {js|/static/thumbnails/6850a57a-15c1-4f8c-8cdb-b0a818f0bcc4.jpg|js}
  ; description = Some {js|Mark Shinwell and David House, Jane Street Europe.

We propose to give a talk about Jane Street's Async library. This is an industrial-strength library for writing correct concurrent programs without having to think (too hard).|js}
  ; published_at = {js|2021-10-03T22:25:11.006Z|js}
  ; updated_at = {js|2021-10-03T22:25:11.006Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|Automatic analysis of industrial robot programs|js}
  ; embed_path = {js|/videos/embed/3cebba55-4032-4de5-93b5-8f3f67c04736|js}
  ; thumbnail_path = {js|/static/thumbnails/480b953a-f17e-498c-9822-c82828ca9c0c.jpg|js}
  ; description = Some {js|Automatic analysis of industrial robot programs, by Markus Weißmann|js}
  ; published_at = {js|2021-10-03T22:38:09.817Z|js}
  ; updated_at = {js|2021-10-03T22:38:09.817Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|Binary Analysis Platform|js}
  ; embed_path = {js|/videos/embed/8dc2d8d3-c140-4c3d-a8fe-a6fcf6fba988|js}
  ; thumbnail_path = {js|/static/thumbnails/390cd7dd-4578-4162-bae0-6c218cb5ebde.jpg|js}
  ; description = Some {js|We present Binary Analysis Platform (BAP), a representation-agnostic program analysis framework for binaries that can leverage existing tools, libraries, and frameworks, no matter which intermediate representation (IR) they use. In BAP, a new IR c...|js}
  ; published_at = {js|2021-08-31T08:39:55.774Z|js}
  ; updated_at = {js|2021-12-16T02:02:00.084Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|Biocaml - the OCaml bioinformatics library|js}
  ; embed_path = {js|/videos/embed/f9ce30b3-8143-4516-85f1-07c28f6337b2|js}
  ; thumbnail_path = {js|/static/thumbnails/102b2860-a3eb-4afb-adfc-16ee06418028.jpg|js}
  ; description = Some {js|Biology is an increasingly computational discipline due to rapid advances in experimental techniques, especially DNA sequencing, that are generating data at unprecedented rates. The computational techniques needed range from the complex (.e.g algo...|js}
  ; published_at = {js|2021-10-03T22:15:01.407Z|js}
  ; updated_at = {js|2021-10-20T08:02:00.263Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|Continuous Benchmarking for OCaml Projects|js}
  ; embed_path = {js|/videos/embed/1c994370-1aaa-4db6-b901-d762786e4904|js}
  ; thumbnail_path = {js|/static/thumbnails/33ab36c3-3650-4c13-9fea-9b5907cf8c0f.jpg|js}
  ; description = Some {js|Regular CI systems are optimised for workloads that do not require stable performance over time. This makes them unsuitable for running performance benchmarks.

current-bench provides a predictable environment for performance benchmarks and a UI...|js}
  ; published_at = {js|2021-08-27T11:20:09.000Z|js}
  ; updated_at = {js|2022-01-17T14:01:00.062Z|js}
  ; language = {js|English|js}
  ; category = {js|Science & Technology|js}
  };
 
  { name = {js|Coq of OCaml|js}
  ; embed_path = {js|/videos/embed/fc7201df-ec27-4735-a51d-d3170d390346|js}
  ; thumbnail_path = {js|/static/thumbnails/f355df78-a634-408c-952e-73312d8b92e3.jpg|js}
  ; description = Some {js|Coq of OCaml, by Guillaume Claret

The CoqOfOCaml project is a compiler from a subset of the OCaml language to the Coq programming language. This com- piler aims to allow reasoning about OCaml programs, or to im- port existing OCaml libraries in...|js}
  ; published_at = {js|2021-10-02T02:06:52.778Z|js}
  ; updated_at = {js|2021-10-02T04:02:00.293Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|Core Time stamp counter - A fast high resolution time source|js}
  ; embed_path = {js|/videos/embed/b6c7860d-e6eb-4404-96c3-917b81ee1f98|js}
  ; thumbnail_path = {js|/static/thumbnails/f4d75771-8394-438f-b8eb-86baff8863d6.jpg|js}
  ; description = None
  ; published_at = {js|2021-09-11T02:42:33.957Z|js}
  ; updated_at = {js|2021-09-11T02:42:33.971Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|Core Time stamp counter: A fast high resolution time source|js}
  ; embed_path = {js|/videos/embed/75b4d60f-3e37-40bd-b025-f39dcce0c42c|js}
  ; thumbnail_path = {js|/static/thumbnails/43248673-6478-4e96-b8ac-cd415d85569b.jpg|js}
  ; description = None
  ; published_at = {js|2015-09-18T00:00:00.000Z|js}
  ; updated_at = {js|2021-09-25T09:02:00.081Z|js}
  ; language = {js|English|js}
  ; category = {js|Science & Technology|js}
  };
 
  { name = {js|Deductive Verification of Realistic OCaml Code|js}
  ; embed_path = {js|/videos/embed/92309d92-8cbf-4545-980c-209c96e42a79|js}
  ; thumbnail_path = {js|/static/thumbnails/db29d3bf-784c-47f1-bf90-f13fd2a9d530.jpg|js}
  ; description = Some {js|We present the formal verification of a subset of the Set module from the OCaml standard library. The proof is conducted using Cameleer, a new tool for the deductive verification of OCaml code. Cameleer takes as input an OCaml program, annotated u...|js}
  ; published_at = {js|2021-08-27T10:33:38.000Z|js}
  ; updated_at = {js|2021-12-23T06:02:00.255Z|js}
  ; language = {js|English|js}
  ; category = {js|Science & Technology|js}
  };
 
  { name = {js|Digodoc and Docs|js}
  ; embed_path = {js|/videos/embed/db6ed2c4-e940-4d5f-82ee-d3d20eb4ceb7|js}
  ; thumbnail_path = {js|/static/thumbnails/43a418d6-56ec-48f4-852b-0a18ec0789aa.jpg|js}
  ; description = Some {js|In this talk, we will introduce a new tool called digodoc, that builds a graph of an opam switch, associating files, libraries and opam packages into a cyclic graph of inclusions and dependencies. We will then explain how we used that tool to buil...|js}
  ; published_at = {js|2021-08-27T12:09:56.000Z|js}
  ; updated_at = {js|2021-12-11T18:02:00.210Z|js}
  ; language = {js|English|js}
  ; category = {js|Science & Technology|js}
  };
 
  { name = {js|DragonKit - an extensible language oriented compiler|js}
  ; embed_path = {js|/videos/embed/8326a03e-02d5-4b32-8789-b7a76c30cf95|js}
  ; thumbnail_path = {js|/static/thumbnails/b9c74825-d374-4afb-9c5f-82cab13c1bb8.jpg|js}
  ; description = Some {js|DragonKit - an extensible language oriented compiler, by Wojciech Meyer|js}
  ; published_at = {js|2021-10-03T22:44:22.886Z|js}
  ; updated_at = {js|2021-10-03T22:44:22.886Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|Effective Concurrency through Algebraic Effects|js}
  ; embed_path = {js|/videos/embed/e9f6c837-1435-4349-af0f-07d22d1c11ea|js}
  ; thumbnail_path = {js|/static/thumbnails/1de58bd2-d2f9-428c-8b8c-97b48d6d2c7e.jpg|js}
  ; description = None
  ; published_at = {js|2015-09-18T00:00:00.000Z|js}
  ; updated_at = {js|2021-09-13T10:02:00.102Z|js}
  ; language = {js|English|js}
  ; category = {js|Science & Technology|js}
  };
 
  { name = {js|Ephemerons meet OCaml GC|js}
  ; embed_path = {js|/videos/embed/556c8f75-b456-43a3-b9cb-97ae35b82072|js}
  ; thumbnail_path = {js|/static/thumbnails/f03f27d0-ca66-40b3-938d-65230885cd85.jpg|js}
  ; description = Some {js| Ephemerons meet OCaml GC, by François Bobot

Garbage collectors (GCs) manage the memory for the programmers and help to ensure the safety of the programs by freeing memory only when it cannot be used anymore. GCs detect that a memory block can’...|js}
  ; published_at = {js|2021-10-02T02:09:19.827Z|js}
  ; updated_at = {js|2021-10-02T02:09:19.827Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|Experiences with Effects in OCaml|js}
  ; embed_path = {js|/videos/embed/74ece0a8-380f-4e2a-bef5-c6bb9092be89|js}
  ; thumbnail_path = {js|/static/thumbnails/d48bf7bb-8c46-4d49-a3a6-734bf339343b.jpg|js}
  ; description = Some {js|The multicore branch of OCaml adds support for effect handlers. In this talk, we report our experiences with effects, both from converting existing code, and from writing new code. Converting the Angstrom parser from a callback style to effects gr...|js}
  ; published_at = {js|2021-08-27T14:41:07.000Z|js}
  ; updated_at = {js|2022-02-07T15:01:00.079Z|js}
  ; language = {js|English|js}
  ; category = {js|Science & Technology|js}
  };
 
  { name = {js|Experiments in Generic Programming|js}
  ; embed_path = {js|/videos/embed/5ae26b10-9a5d-4395-89c6-a2e28e68d206|js}
  ; thumbnail_path = {js|/static/thumbnails/b1e66943-a372-4909-a8f6-70470546e69d.jpg|js}
  ; description = Some {js|Experiments in generic programming: runtime type representation and implicit values, by Pierre Chambart & Grégoire Henry|js}
  ; published_at = {js|2021-10-03T22:40:53.446Z|js}
  ; updated_at = {js|2021-10-03T22:40:53.447Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|From 2n+1 to n|js}
  ; embed_path = {js|/videos/embed/74b32dae-11c6-4713-be1b-946260196e50|js}
  ; thumbnail_path = {js|/static/thumbnails/a2042ab9-9025-421a-9eae-176462ac594b.jpg|js}
  ; description = Some {js|
OCaml relies on a type-agnostic object representation centred around values which unify odd integers and aligned pointers. The last bit of a value distinguishes the two variants: zero indicates a pointer on the OCaml heap, while one encodes a ta...|js}
  ; published_at = {js|2021-08-31T08:30:23.211Z|js}
  ; updated_at = {js|2021-11-01T14:02:00.435Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|Github Pull Requests for OCaml development - a field report|js}
  ; embed_path = {js|/videos/embed/f0021d24-9104-4672-a363-de5c1c514c2e|js}
  ; thumbnail_path = {js|/static/thumbnails/6f0ed101-6c6f-4380-8a98-118ba6783fff.jpg|js}
  ; description = Some {js|Github Pull Requests for OCaml development - a field report, by Gabriel Scherer

On 2014/01/30, we started an experiment allowing users to submit and discussion patches to the OCaml distribution on its Github mirror rather than through the exist...|js}
  ; published_at = {js|2021-10-02T02:09:58.770Z|js}
  ; updated_at = {js|2021-10-02T02:09:58.785Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|Global Semantic Analysis on OCaml programs|js}
  ; embed_path = {js|/videos/embed/51e4bdf0-50f7-4b13-8514-2d62b5341066|js}
  ; thumbnail_path = {js|/static/thumbnails/8255d370-e621-44bc-b7c3-6dd39fab4d1d.jpg|js}
  ; description = None
  ; published_at = {js|2015-09-18T00:00:00.000Z|js}
  ; updated_at = {js|2022-01-02T09:01:00.059Z|js}
  ; language = {js|English|js}
  ; category = {js|Science & Technology|js}
  };
 
  { name = {js|GopCaml: A Structural Editor for OCaml|js}
  ; embed_path = {js|/videos/embed/e0a6e6f2-0d40-4dfc-9308-001c8e0f64d6|js}
  ; thumbnail_path = {js|/static/thumbnails/729cda51-abb3-4c8d-9d0e-b922e81be518.jpg|js}
  ; description = Some {js|This talk presents GopCaml-mode, the first structural editing plugin for OCaml. We will give a tour of the main plugin features, discussing the plugin’s internal design and its integration with existing OCaml and GNU Emacs toolchains.

Kiran Gop...|js}
  ; published_at = {js|2021-08-27T10:12:58.000Z|js}
  ; updated_at = {js|2022-01-18T06:01:00.076Z|js}
  ; language = {js|English|js}
  ; category = {js|Science & Technology|js}
  };
 
  { name = {js|High Performance Client-Side Web Programming with SPOC and Js of ocaml|js}
  ; embed_path = {js|/videos/embed/9e68174a-5c92-41f1-abdf-387a6cca7cf1|js}
  ; thumbnail_path = {js|/static/thumbnails/9cdceddf-7460-4843-acdd-99bdf0315732.jpg|js}
  ; description = Some {js|High Performance Client-Side Web Programming with SPOC and Js of ocaml - by Mathias Bourgoin and Emmmanuel Chailloux (Université Pierre et Marie Curie)

We present WebSpoc, an OCaml GPGPU library targeting web applications that is built upon SPO...|js}
  ; published_at = {js|2021-10-02T02:49:14.435Z|js}
  ; updated_at = {js|2021-10-02T02:49:14.452Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|Implementing an interval computation library for OCaml|js}
  ; embed_path = {js|/videos/embed/e228951b-f544-4bd6-892a-2aca7e2065f9|js}
  ; thumbnail_path = {js|/static/thumbnails/1a0f9278-1e15-45c8-b7ae-ee882f4a3360.jpg|js}
  ; description = Some {js|Implementing an interval computation library for OCaml, by Jean-Marc Alliot, Charlie Vanaret, Jean-Baptiste Gotteland, Nicolas Durand and David Gianazza.

In this paper we present two implementation of interval arithmetics for Ocaml on x86/amd64...|js}
  ; published_at = {js|2021-10-03T22:21:59.398Z|js}
  ; updated_at = {js|2021-10-03T22:21:59.398Z|js}
  ; language = {js|Unknown|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|Improving Type Error Messages in OCaml|js}
  ; embed_path = {js|/videos/embed/9fa54aee-6b2f-492f-abbe-51affc07ec24|js}
  ; thumbnail_path = {js|/static/thumbnails/0522b690-1b00-4c83-b30a-9d7437b953f9.jpg|js}
  ; description = Some {js|Improving Type Error Messages in OCaml, by Arthur Charguéraud (INRIA & Université Paris Sud)

Cryptic type error messages are a major obstacle to learning OCaml. In many cases, error messages cannot be interpreted with- out a sufficiently-precis...|js}
  ; published_at = {js|2021-10-02T02:52:41.884Z|js}
  ; updated_at = {js|2021-10-02T02:52:41.895Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|Inline Assembly in OCaml|js}
  ; embed_path = {js|/videos/embed/736857f3-99d9-46fb-9b4a-92eba42b2672|js}
  ; thumbnail_path = {js|/static/thumbnails/db12715d-3333-4568-80f6-e41edc813e1b.jpg|js}
  ; description = Some {js|Inline Assembly in OCaml — by Vladimir Brankov|js}
  ; published_at = {js|2021-10-02T01:45:22.792Z|js}
  ; updated_at = {js|2021-10-02T01:45:22.793Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|Inline Assembly in OCaml|js}
  ; embed_path = {js|/videos/embed/632f520f-8f83-4b6f-89f1-5cde088436c7|js}
  ; thumbnail_path = {js|/static/thumbnails/5d2f65d1-6129-4206-832b-c3d4bab410df.jpg|js}
  ; description = None
  ; published_at = {js|2015-09-18T00:00:00.000Z|js}
  ; updated_at = {js|2022-02-04T21:01:00.065Z|js}
  ; language = {js|English|js}
  ; category = {js|Science & Technology|js}
  };
 
  { name = {js|Introduction to 0install|js}
  ; embed_path = {js|/videos/embed/21a21c83-a35d-4c09-b13c-8f060590c45c|js}
  ; thumbnail_path = {js|/static/thumbnails/64211d01-b071-4755-a1ba-abf86f7800c8.jpg|js}
  ; description = Some {js|Introduction to 0install by Thomas Leonard

0install (pronounced “Zero Install”) is a decentralised cross-platform package manager. “Decentralised” means that organisations and individuals can host their software in their own package repositorie...|js}
  ; published_at = {js|2021-10-02T02:54:53.718Z|js}
  ; updated_at = {js|2021-10-02T02:54:53.730Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|Irmin v2|js}
  ; embed_path = {js|/videos/embed/53e497b0-898f-4c85-8da9-39f65ef0e0b1|js}
  ; thumbnail_path = {js|/static/thumbnails/138e7c05-185b-4e54-95d0-d15018905a39.jpg|js}
  ; description = Some {js|Irmin is an OCaml library for building distributed databases with the same design principles as Git. Existing Git users will find many familiar features: branching/merging, immutable causal history for all changes, and the ability to restore to an...|js}
  ; published_at = {js|2020-08-28T00:00:00.000Z|js}
  ; updated_at = {js|2021-10-05T10:02:00.074Z|js}
  ; language = {js|Unknown|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|Irminsule - a branch-consistent distributed library database|js}
  ; embed_path = {js|/videos/embed/5546bb89-93a3-4407-a810-2d437479025f|js}
  ; thumbnail_path = {js|/static/thumbnails/bdca687f-b58e-4167-b7d3-86daacaf4395.jpg|js}
  ; description = None
  ; published_at = {js|2021-10-03T21:56:52.709Z|js}
  ; updated_at = {js|2021-10-03T21:56:52.721Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|Ketrew and Biokepi|js}
  ; embed_path = {js|/videos/embed/f3dcee35-bc04-453a-ba35-7aec90599661|js}
  ; thumbnail_path = {js|/static/thumbnails/0a36e8ce-c415-4191-ad5b-6ef2eb23db4e.jpg|js}
  ; description = None
  ; published_at = {js|2015-09-18T00:00:00.000Z|js}
  ; updated_at = {js|2021-08-03T22:36:42.344Z|js}
  ; language = {js|English|js}
  ; category = {js|Science & Technology|js}
  };
 
  { name = {js|Learning OCaml: An Online Learning Centre for OCaml|js}
  ; embed_path = {js|/videos/embed/ea643e64-2393-4c24-9ccf-7216e3ded2ce|js}
  ; thumbnail_path = {js|/static/thumbnails/c1911047-e6b0-4673-b0ed-8716533cd601.jpg|js}
  ; description = Some {js|Learn OCaml: An Online Learning Center for OCaml, by Benjamin Canou, Grégoire Henry, Çagdas Bozman and Fabrice Le Fessant.

We present Learn OCaml, a Web application that packs a set of learning activities for people who want to learn OCaml. It ...|js}
  ; published_at = {js|2021-10-09T00:16:14.033Z|js}
  ; updated_at = {js|2022-01-25T22:01:00.064Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|Leveraging Formal Specifications to Generate Fuzzing Suites|js}
  ; embed_path = {js|/videos/embed/d9a36c9f-1611-42f9-8854-981b1e2d7d75|js}
  ; thumbnail_path = {js|/static/thumbnails/e5d18bd4-b482-463c-80f8-35d9fbb46b23.jpg|js}
  ; description = Some {js|When testing a library, developers typically first have to capture the semantics they want to check. They then write the code implementing these tests and find relevant test cases that expose possible misbehaviours.

In this work, we present a t...|js}
  ; published_at = {js|2021-08-27T10:40:06.000Z|js}
  ; updated_at = {js|2021-10-02T00:02:00.093Z|js}
  ; language = {js|English|js}
  ; category = {js|Science & Technology|js}
  };
 
  { name = {js|LexiFi Runtime Types|js}
  ; embed_path = {js|/videos/embed/cc7e3242-0bef-448a-aa13-8827bba933e3|js}
  ; thumbnail_path = {js|/static/thumbnails/1d43d8b4-87d1-4398-b925-10a42460b8dc.jpg|js}
  ; description = Some {js|OCaml programmers make deliberate use of abstract data types for composing safe and reliable software systems. The OCaml compiler relies on the invariants imposed by the type system to produce efficient and compact runtime data representations. Be...|js}
  ; published_at = {js|2020-08-28T00:00:00.000Z|js}
  ; updated_at = {js|2021-12-29T15:02:00.116Z|js}
  ; language = {js|Unknown|js}
  ; category = {js|Science & Technology|js}
  };
 
  { name = {js|LibreS3 - design, challenges, and steps toward reusable libraries|js}
  ; embed_path = {js|/videos/embed/c1b00980-3a4f-4222-b539-392815f7954f|js}
  ; thumbnail_path = {js|/static/thumbnails/ee8640c9-d827-498b-8e20-bed53e7481f7.jpg|js}
  ; description = None
  ; published_at = {js|2021-10-03T21:57:39.057Z|js}
  ; updated_at = {js|2021-11-18T07:02:00.649Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|Love: a readable language interpreted by a blockchain|js}
  ; embed_path = {js|/videos/embed/d3b2b31e-1739-406e-8de7-d5f21bc01836|js}
  ; thumbnail_path = {js|/static/thumbnails/93a6e9ac-2266-408a-81e7-1ebf239233f8.jpg|js}
  ; description = Some {js|We present Love, a smart contract language embedded in the Dune Network blockchain. It benefits from an OCaml-like syntax and a system-F inspired type system. Love has been used for deploying complex services such as games, ERC20s, atomic swaps, e...|js}
  ; published_at = {js|2021-08-27T15:10:17.000Z|js}
  ; updated_at = {js|2021-12-21T13:02:00.082Z|js}
  ; language = {js|English|js}
  ; category = {js|Science & Technology|js}
  };
 
  { name = {js|Multicore OCaml|js}
  ; embed_path = {js|/videos/embed/490b5363-01b6-45d8-9b7e-c883a20026a1|js}
  ; thumbnail_path = {js|/static/thumbnails/07162af4-06f9-4d3c-954a-4c35dc87fd21.jpg|js}
  ; description = Some {js|Multicore OCaml, by Stephen Dolan, Leo White, Anil Madhavapeddy (University of Cambridge).

Currently, threading is supported in OCaml only by means of a global lock, allowing at most thread to run OCaml code at any time. We present ongo- ing wo...|js}
  ; published_at = {js|2021-10-03T21:59:49.549Z|js}
  ; updated_at = {js|2022-01-26T12:01:00.271Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|Nullable Type Inference|js}
  ; embed_path = {js|/videos/embed/380b1c2e-6298-49fc-88a1-c440ece29c76|js}
  ; thumbnail_path = {js|/static/thumbnails/460d1b9a-8dfe-477c-b8a9-9b44f9be104d.jpg|js}
  ; description = Some {js|Nullable Type Inference, by Michel Mauny and Benoît Vaugon

We present type inference algorithms for nullable types in ML-like programming languages. Starting with a sim- ple system, presented as an algorithm, whose only inter- est is to introdu...|js}
  ; published_at = {js|2021-10-03T22:00:18.779Z|js}
  ; updated_at = {js|2021-10-03T22:00:18.779Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|OCaml Companion Tools|js}
  ; embed_path = {js|/videos/embed/4583b254-82f9-4176-9f39-2bc0bb6a9c22|js}
  ; thumbnail_path = {js|/static/thumbnails/491ac4a3-8274-4f0d-9897-d88eece06dc4.jpg|js}
  ; description = Some {js|OCaml Companion Tools, by Xavier Clerc.

The objective of this talk is to present several tools that aim to ease the development of software written with the OCaml language. These tools are particularly suited to help the developer during the de...|js}
  ; published_at = {js|2021-10-03T22:45:24.958Z|js}
  ; updated_at = {js|2021-10-03T22:45:24.958Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|OCaml Under The Hood: SmartPy|js}
  ; embed_path = {js|/videos/embed/7446ad4d-4ae2-4e1a-bc38-af8f71e8ebd8|js}
  ; thumbnail_path = {js|/static/thumbnails/e1ac5b07-3648-40c1-b62c-5e88471741dc.jpg|js}
  ; description = Some {js|SmartPy is a complete system to develop smart-contracts for the Tezos blockchain. It is an embedded EDSL in python to write contracts and their test scenarios. It includes an online IDE, a chain explorer, and a command-line interface. Python is us...|js}
  ; published_at = {js|2020-08-28T00:00:00.000Z|js}
  ; updated_at = {js|2021-09-24T16:02:00.077Z|js}
  ; language = {js|Unknown|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|OCaml and Python: Getting the Best of Both Worlds|js}
  ; embed_path = {js|/videos/embed/9eafdb1e-9be9-4a52-98b4-f4696eda4c18|js}
  ; thumbnail_path = {js|/static/thumbnails/53db83d1-0763-4dfa-a087-cce3cad1b581.jpg|js}
  ; description = Some {js|In this talk we present how we expose a wide variety of OCaml libraries and services so that they can be accessed from Python. Our initial use case on the Python side consisted in Jupyter notebooks used to analyse various datasets, these datasets ...|js}
  ; published_at = {js|2021-08-27T10:16:54.000Z|js}
  ; updated_at = {js|2022-01-17T03:01:00.075Z|js}
  ; language = {js|English|js}
  ; category = {js|Science & Technology|js}
  };
 
  { name = {js|OCaml-CI : A Zero-Configuration CI|js}
  ; embed_path = {js|/videos/embed/0fee79e8-715a-400b-bfcc-34c3610f4890|js}
  ; thumbnail_path = {js|/static/thumbnails/596f39a9-8654-4922-8bec-6e7ac5dcc319.jpg|js}
  ; description = Some {js|OCaml-CI

is a CI service for OCaml projects. It
uses metadata from the project’s opam and dune
files to work out what to build, and uses caching
to make builds fast. It automatically tests projects
against multiple OCaml versions and OS platforms...|js}
  ; published_at = {js|2020-08-28T00:00:00.000Z|js}
  ; updated_at = {js|2022-02-07T11:01:00.064Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|OCaml-CI : A Zero-Configuration CI|js}
  ; embed_path = {js|/videos/embed/da88d6ac-7ba1-4261-9308-d03fe21e35b9|js}
  ; thumbnail_path = {js|/static/thumbnails/1c22a14e-f067-4d4e-8e26-027cc6d8a491.jpg|js}
  ; description = Some {js|OCaml-CI1 is a CI service for OCaml projects. It uses metadata from the project’s opam and dune files to work out what to build, and uses caching to make builds fast. It automatically tests projects against multiple OCaml versions and OS platforms...|js}
  ; published_at = {js|2020-08-28T00:00:00.000Z|js}
  ; updated_at = {js|2021-05-27T16:35:41.085Z|js}
  ; language = {js|English|js}
  ; category = {js|Science & Technology|js}
  };
 
  { name = {js|OCamlCC - raising low-level byte code to high-level C|js}
  ; embed_path = {js|/videos/embed/c31ec9fa-7c65-46f5-bbc9-77c6ac87bf0b|js}
  ; thumbnail_path = {js|/static/thumbnails/d1a815bb-e8ed-4d99-808a-a78d1f512712.jpg|js}
  ; description = Some {js|OCamlCC - raising low-level byte code to high-level C, by Michel Mauny Benoît Vaugon

We present preliminary results about OCamlCC, a compiler producing native code from OCaml bytecode executables, through the generation of C code.
|js}
  ; published_at = {js|2021-10-03T22:17:09.763Z|js}
  ; updated_at = {js|2021-10-03T22:17:09.763Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|OCamlOScope - a New OCaml API Search|js}
  ; embed_path = {js|/videos/embed/c3e3cf25-0fa7-46ad-b0bf-f313bad7142d|js}
  ; thumbnail_path = {js|/static/thumbnails/486bbc91-0e44-4024-99e1-61326e1c95af.jpg|js}
  ; description = Some {js|[OCamlOScope](http://ocamloscope.herokuapp.com) is a new search engine for OCaml programming. Tons of OCaml library packages, modules, types, constructors, functions and values can be searched via simple string queries.|js}
  ; published_at = {js|2021-10-03T22:01:54.239Z|js}
  ; updated_at = {js|2021-11-01T14:02:00.488Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|OCamlPro - promoting OCaml use in industry|js}
  ; embed_path = {js|/videos/embed/dbf5a276-460c-45f4-b488-924cec7db3aa|js}
  ; thumbnail_path = {js|/static/thumbnails/b00f092f-2b96-4623-b55b-ed5e505f4d76.jpg|js}
  ; description = Some {js|OCamlPro exists with the mission of promoting the successful use of OCaml in industry. OCamlPro builds a professional environment for the development of OCaml applications, including IDE integration, development tools and services. These include t...|js}
  ; published_at = {js|2021-10-03T22:34:20.640Z|js}
  ; updated_at = {js|2021-10-03T22:34:20.640Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|OPAM - an OCaml Package Manager|js}
  ; embed_path = {js|/videos/embed/3ff87a10-3785-41e6-ba47-acab21fcfa8a|js}
  ; thumbnail_path = {js|/static/thumbnails/c4083614-edd9-445f-85a4-e2ae470c761e.jpg|js}
  ; description = Some {js|OPAM - an OCaml Package Manager, by Thomas Gazagnaire.|js}
  ; published_at = {js|2021-10-03T22:42:00.207Z|js}
  ; updated_at = {js|2021-10-03T22:42:00.207Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|Ocsigen_Eliom - the state-of-the-art and the prospects|js}
  ; embed_path = {js|/videos/embed/d010b30f-61d5-4d70-b10a-518a7a6e1e3f|js}
  ; thumbnail_path = {js|/static/thumbnails/7b044637-259c-4b30-875b-4c4563ce23aa.jpg|js}
  ; description = Some {js|Ocsigen/Eliom: The state of the art, and the prospects, by Benedikt Becker and Vincent Balat|js}
  ; published_at = {js|2021-10-03T22:15:47.662Z|js}
  ; updated_at = {js|2022-01-14T17:01:00.081Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|Opam-bin: Binary Packages with Opam|js}
  ; embed_path = {js|/videos/embed/a889e4d3-0508-4734-b667-7060b0a253cd|js}
  ; thumbnail_path = {js|/static/thumbnails/b2325a24-f068-473b-961e-a0b783ae5c39.jpg|js}
  ; description = Some {js|In this talk, we will present opam-bin, an Opam plugin that builds Binary Opam packages on the fly, to speed-up reinstallation of pack- ages. opam-bin also creates Opam Repositories for these binary pack- ages, to make them easy to share with othe...|js}
  ; published_at = {js|2021-08-27T15:01:40.000Z|js}
  ; updated_at = {js|2022-01-08T17:01:00.244Z|js}
  ; language = {js|English|js}
  ; category = {js|Science & Technology|js}
  };
 
  { name = {js|Operf - Benchmarking the OCaml Compiler|js}
  ; embed_path = {js|/videos/embed/eb229518-1108-46bd-b8b2-3ce8b886c96f|js}
  ; thumbnail_path = {js|/static/thumbnails/6f55ff79-72d5-4492-b824-8464783f31c2.jpg|js}
  ; description = Some {js|Operf: Benchmarking the OCaml Compiler — by Pierre Chambart, Fabrice Le Fessant, Vincent Bernardoff|js}
  ; published_at = {js|2021-09-11T02:11:32.589Z|js}
  ; updated_at = {js|2021-10-02T04:02:00.208Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|Operf: Benchmarking the OCaml Compiler|js}
  ; embed_path = {js|/videos/embed/5a4a6c12-3cb1-40d2-a663-25f294e12555|js}
  ; thumbnail_path = {js|/static/thumbnails/c2b5c90a-9c9e-4058-94a1-15525795a01a.jpg|js}
  ; description = None
  ; published_at = {js|2015-09-18T00:00:00.000Z|js}
  ; updated_at = {js|2021-08-03T16:23:23.889Z|js}
  ; language = {js|English|js}
  ; category = {js|Science & Technology|js}
  };
 
  { name = {js|Parafuzz: Coverage-guided Property Fuzzing for Multicore OCaml programs|js}
  ; embed_path = {js|/videos/embed/c0d591e0-91c9-4eaa-a4d7-c4f514de0a57|js}
  ; thumbnail_path = {js|/static/thumbnails/b1a67c0a-2eb9-4c9d-97ce-b4dc039da59b.jpg|js}
  ; description = Some {js|We develop ParaFuzz, an input and concurrency fuzzing tool for Multicore OCaml programs. ParaFuzz builds on top of Crowbar which combines AFL-based grey box fuzzing with QuickCheck and extends it to handle parallelism.

Sumit Padhiyar
Indian In...|js}
  ; published_at = {js|2021-08-27T10:36:13.000Z|js}
  ; updated_at = {js|2022-01-04T09:01:00.058Z|js}
  ; language = {js|English|js}
  ; category = {js|Science & Technology|js}
  };
 
  { name = {js|Parallelising your OCaml Code with Multicore OCaml|js}
  ; embed_path = {js|/videos/embed/ce20839e-4bfc-4d74-925b-485a6b052ddf|js}
  ; thumbnail_path = {js|/static/thumbnails/30bc6019-ecab-40e5-a7b6-c294ac9a7344.jpg|js}
  ; description = Some {js|Slides, speaker notes and runnable examples mentioned in this talk are available at: https://github.com/ocaml-multicore/ocaml2020-workshop-parallel

With the availability of multicore variants of the recent OCaml versions (4.10 and 4.11) that main...|js}
  ; published_at = {js|2020-08-28T00:00:00.000Z|js}
  ; updated_at = {js|2022-01-28T15:01:00.065Z|js}
  ; language = {js|Unknown|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|Persistent Networking with Irmin and MirageOS|js}
  ; embed_path = {js|/videos/embed/97dd9634-28e4-4066-96e4-9c2036ee4bb2|js}
  ; thumbnail_path = {js|/static/thumbnails/46ba8c5d-0f4a-427e-8e76-0c58cb0e70a7.jpg|js}
  ; description = None
  ; published_at = {js|2015-09-18T00:00:00.000Z|js}
  ; updated_at = {js|2021-11-18T07:02:00.238Z|js}
  ; language = {js|English|js}
  ; category = {js|Science & Technology|js}
  };
 
  { name = {js|Presenting Core|js}
  ; embed_path = {js|/videos/embed/3159e115-948e-4f67-9d45-403bef003c35|js}
  ; thumbnail_path = {js|/static/thumbnails/61fe2572-358b-4110-9748-485a2e3ceffa.jpg|js}
  ; description = Some {js|Presenting Core, by Yaron Minsky

Core is Jane Street's alternative to the OCaml standard library. The need for
an alternative to the standard library is clear: OCaml's standard library is
well implemented, but it's narrow in scope, and somewh...|js}
  ; published_at = {js|2021-10-03T23:08:42.826Z|js}
  ; updated_at = {js|2022-02-06T20:01:00.052Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|Probabilistic resource limits using StatMemprof|js}
  ; embed_path = {js|/videos/embed/bc297e85-82dd-4baf-8556-4a3a934978f9|js}
  ; thumbnail_path = {js|/static/thumbnails/9b4dc06e-1d07-45b8-a21a-1e4f39897fef.jpg|js}
  ; description = Some {js|The goal of this talk is two-fold. First, we present memprof-limits, a probabilistic implementation of per-thread global memory limits, and per-thread allocation limits, for OCaml 4.12. Then, we will discuss the reasoning about programs in the pre...|js}
  ; published_at = {js|2021-08-27T11:08:12.000Z|js}
  ; updated_at = {js|2022-01-21T16:01:00.076Z|js}
  ; language = {js|English|js}
  ; category = {js|Science & Technology|js}
  };
 
  { name = {js|Programming the Xen cloud using OCaml|js}
  ; embed_path = {js|/videos/embed/360f8fe3-3268-44da-a0c4-b37c26aa7e36|js}
  ; thumbnail_path = {js|/static/thumbnails/90298af3-37a4-4420-9e3c-b30cb1369559.jpg|js}
  ; description = Some {js|Programming the Xen cloud using OCaml by David Scott, Anil Madhavapeddy and Richard Mortier.

The Xen Cloud Platform (XCP)1 is an open-source software distribution that converts clusters of physical computers into many virtual machines, all isol...|js}
  ; published_at = {js|2021-10-03T22:29:04.690Z|js}
  ; updated_at = {js|2021-10-03T22:29:38.263Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|Property-Based Testing for OCaml through Coq|js}
  ; embed_path = {js|/videos/embed/9324fba4-2482-4bab-bfdd-b8881b3ed94a|js}
  ; thumbnail_path = {js|/static/thumbnails/d7e22bba-cda1-4c2b-9368-9b2c1643e751.jpg|js}
  ; description = Some {js|We will present a property-based testing framework for OCaml that leverages the power of QuickChick, a popular and mature testing plugin for the Coq proof assistant, by automatically constructing a extraction-based shim between OCaml and Coq. That...|js}
  ; published_at = {js|2021-08-31T08:37:00.571Z|js}
  ; updated_at = {js|2022-01-18T12:01:00.065Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|Real-world debugging in OCaml|js}
  ; embed_path = {js|/videos/embed/a8f4cf6b-9971-484b-ab5b-34a16fde1185|js}
  ; thumbnail_path = {js|/static/thumbnails/ea912a23-6e8b-40ec-ac45-81af2d01617a.jpg|js}
  ; description = Some {js|Real-world debugging in OCaml, by Mark Shinwell|js}
  ; published_at = {js|2021-10-03T22:35:41.668Z|js}
  ; updated_at = {js|2021-10-03T22:35:41.668Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|Safe Protocol Updates via Propositional Logic|js}
  ; embed_path = {js|/videos/embed/c6176f51-0277-46f0-937b-1e2721044492|js}
  ; thumbnail_path = {js|/static/thumbnails/a89a3483-274a-44f1-9a38-c679f6b12196.jpg|js}
  ; description = Some {js|If values of a given type are stored on disk, or are sent between different executables, then changing that type or its serialization can result in versioning issues.
Often such issues are resolved by either making the deserializer more permissiv...|js}
  ; published_at = {js|2021-08-31T08:34:54.707Z|js}
  ; updated_at = {js|2021-12-23T04:02:00.398Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|Semgrep : a fast, lightweight, polyglot static analysis tool to find bugs|js}
  ; embed_path = {js|/videos/embed/c0d07213-1426-46a1-98e0-0b0c4515c841|js}
  ; thumbnail_path = {js|/static/thumbnails/2ab3961f-4e66-4ec9-b20e-72e25dfbebe4.jpg|js}
  ; description = Some {js|Semgrep, which stands for “semantic grep,” is a fast, lightweight, polyglot, open source static analysis tool to find bugs and enforce code standards. It is used internally by many companies including Dropbox and Snowflake. Semgrep is also now use...|js}
  ; published_at = {js|2021-08-31T08:41:15.492Z|js}
  ; updated_at = {js|2021-11-18T08:02:00.229Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|Simple, efficient, sound-and-complete combinator parsing|js}
  ; embed_path = {js|/videos/embed/7a0a6d3c-dad0-4fe8-9c35-78cbfbd431d9|js}
  ; thumbnail_path = {js|/static/thumbnails/fbc3103b-30f2-45d9-85ce-95732b8e7f74.jpg|js}
  ; description = Some {js|This proposal describes a parsing library that is based on current work due to be published as Simple, efficient, sound and complete combinator parsing for all context-free grammars, using an oracle.|js}
  ; published_at = {js|2021-10-03T22:03:25.164Z|js}
  ; updated_at = {js|2021-10-03T22:03:25.164Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|Specialization of Generic Array Accesses After Inlining|js}
  ; embed_path = {js|/videos/embed/515689cc-4736-4e1e-9f9f-be363b4551af|js}
  ; thumbnail_path = {js|/static/thumbnails/01724d60-213c-4570-8db2-26a555304d3d.jpg|js}
  ; description = Some {js|Specialization of Generic Array Accesses After Inlining — by Ryohei Tokuda, Eijiro Sumii, Akinori Abe|js}
  ; published_at = {js|2021-10-02T01:42:07.586Z|js}
  ; updated_at = {js|2021-10-02T01:42:07.586Z|js}
  ; language = {js|Unknown|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|Specialization of Generic Array Accesses After Inlining|js}
  ; embed_path = {js|/videos/embed/80553916-b90a-4641-93c8-35b000df04c1|js}
  ; thumbnail_path = {js|/static/thumbnails/1f81fbbf-6fb0-4047-93a1-57759431166a.jpg|js}
  ; description = None
  ; published_at = {js|2015-09-18T00:00:00.000Z|js}
  ; updated_at = {js|2021-08-03T16:34:23.463Z|js}
  ; language = {js|Unknown|js}
  ; category = {js|Science & Technology|js}
  };
 
  { name = {js|State of the OCaml Platform|js}
  ; embed_path = {js|/videos/embed/390ce74c-f85f-477d-8f20-504437409add|js}
  ; thumbnail_path = {js|/static/thumbnails/33258292-009b-42ee-83d3-9eb4bfb4e048.jpg|js}
  ; description = None
  ; published_at = {js|2018-01-12T00:00:00.000Z|js}
  ; updated_at = {js|2021-07-27T12:08:00.264Z|js}
  ; language = {js|English|js}
  ; category = {js|Science & Technology|js}
  };
 
  { name = {js|State of the OCaml Platform 2020|js}
  ; embed_path = {js|/videos/embed/0e2070fd-798b-47f7-8e69-ef75e967e516|js}
  ; thumbnail_path = {js|/static/thumbnails/4fd6a51f-686c-4f6f-8026-83692304b432.jpg|js}
  ; description = Some {js|This talk covers:

- Integrated Development Environments
- Next Steps for the OCaml Platform
- Plans for 2020-2021|js}
  ; published_at = {js|2020-08-28T00:00:00.000Z|js}
  ; updated_at = {js|2021-12-23T08:02:00.097Z|js}
  ; language = {js|English|js}
  ; category = {js|Science & Technology|js}
  };
 
  { name = {js|Study of OCaml programs' memory behaviour|js}
  ; embed_path = {js|/videos/embed/180ee1ea-6fa8-4dba-aa69-e3901cc3147f|js}
  ; thumbnail_path = {js|/static/thumbnails/09ec226c-3670-47b3-b944-94684cf86d36.jpg|js}
  ; description = Some {js|Study of OCaml programs’ memory behaviour, by Çagdas Bozman, Thomas Gazagnaire, Fabrice Le Fessant and Michel Mauny.

In this paper, we present a preliminary work on new memory profiling tool and others, to help us to understand memory behaviour.|js}
  ; published_at = {js|2021-10-03T22:19:07.925Z|js}
  ; updated_at = {js|2021-10-03T22:19:07.925Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|The ImpFS filesystem|js}
  ; embed_path = {js|/videos/embed/28545b27-4637-47a5-8edd-6b904daef19c|js}
  ; thumbnail_path = {js|/static/thumbnails/dde19660-653d-4dc3-9e81-54b2e3ab22a2.jpg|js}
  ; description = Some {js|This proposal describes a presentation to be given at the OCaml’20 workshop. The presentation will cover a new OCaml filesystem, ImpFS, and the related libraries. The filesystem makes use of a B-tree library presented at OCaml’17, and a key-value ...|js}
  ; published_at = {js|2020-08-28T00:00:00.000Z|js}
  ; updated_at = {js|2021-09-04T20:02:00.472Z|js}
  ; language = {js|Unknown|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|The OCaml Platform 1.0 - Reason ML|js}
  ; embed_path = {js|/videos/embed/bd9a8e54-6ca5-4036-a08c-6a47cee6619e|js}
  ; thumbnail_path = {js|/static/thumbnails/ddc1e6fb-9999-4e79-b458-31c7e3ec1108.jpg|js}
  ; description = Some {js|Presented by Anil Madhavapeddy (@avsm)

We keep being told ReasonML can compile to native and do interop with OCaml, and that there's a wealth of existing code and tools we can draw into our applications - but how do we get there?
This video will ...|js}
  ; published_at = {js|2018-12-11T00:00:00.000Z|js}
  ; updated_at = {js|2022-01-18T10:01:00.078Z|js}
  ; language = {js|English|js}
  ; category = {js|Science & Technology|js}
  };
 
  { name = {js|The OCaml Platform v1.0|js}
  ; embed_path = {js|/videos/embed/37eaef0e-d826-4452-bf84-f04244a85ce9|js}
  ; thumbnail_path = {js|/static/thumbnails/052d59ac-f44a-4730-aed6-47dd6a6f2405.jpg|js}
  ; description = Some {js|The OCaml Platform v1.0, by Anil Madhavapeddy

The OCaml Platform combines the OCaml compiler toolchain with a coherent set of tools for build, documen- tation, testing and IDE integration. The project is a collab- orative effort across the OCam...|js}
  ; published_at = {js|2021-10-03T22:06:15.953Z|js}
  ; updated_at = {js|2021-10-03T22:06:15.954Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|The State of OCaml|js}
  ; embed_path = {js|/videos/embed/b04b10c1-b924-4f58-8aa9-4527dcc11d8a|js}
  ; thumbnail_path = {js|/static/thumbnails/9feccd59-f677-4be6-bcf4-a07977ef5b29.jpg|js}
  ; description = Some {js|The State of OCaml, Xavier Leroy|js}
  ; published_at = {js|2021-10-03T22:49:54.276Z|js}
  ; updated_at = {js|2021-10-03T22:50:14.266Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|The State of OCaml|js}
  ; embed_path = {js|/videos/embed/69e486cd-191d-430b-8a41-0be0f806096b|js}
  ; thumbnail_path = {js|/static/thumbnails/36c5055b-7c67-4208-97cc-448f52814ab0.jpg|js}
  ; description = Some {js|The State of OCaml (invited talk) — by Xavier Leroy|js}
  ; published_at = {js|2021-10-02T01:51:45.256Z|js}
  ; updated_at = {js|2021-10-02T01:51:45.256Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|The State of OCaml|js}
  ; embed_path = {js|/videos/embed/60a2ecfb-86ea-4881-a279-0a928452a3c3|js}
  ; thumbnail_path = {js|/static/thumbnails/a5e5f630-2df9-4691-8ddf-a8137001ab4c.jpg|js}
  ; description = None
  ; published_at = {js|2015-09-18T00:00:00.000Z|js}
  ; updated_at = {js|2021-09-02T10:02:00.083Z|js}
  ; language = {js|English|js}
  ; category = {js|Science & Technology|js}
  };
 
  { name = {js|The State of OCaml (invited), Xavier Leroy|js}
  ; embed_path = {js|/videos/embed/11844424-be9b-4427-b3dd-24c3e4ff85a9|js}
  ; thumbnail_path = {js|/static/thumbnails/9b6f683f-8726-4b78-ac8b-4dae7217eace.jpg|js}
  ; description = Some {js|The State of OCaml (invited), Xavier Leroy|js}
  ; published_at = {js|2021-10-03T22:07:14.955Z|js}
  ; updated_at = {js|2021-10-03T22:07:14.955Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|The State of the OCaml Platform|js}
  ; embed_path = {js|/videos/embed/c386fc95-092e-4ea7-9317-91edf287fea6|js}
  ; thumbnail_path = {js|/static/thumbnails/9f922a48-9902-4f08-b4f7-8b6437cf47e7.jpg|js}
  ; description = Some {js|The State of the OCaml Platform: September 2016 
by Louis Gesbert, on behalf of the OCaml Platform team|js}
  ; published_at = {js|2021-10-09T00:00:01.325Z|js}
  ; updated_at = {js|2021-11-17T00:02:00.235Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|The State of the OCaml Platform|js}
  ; embed_path = {js|/videos/embed/32475a83-b455-455b-937f-28e7185f4fc2|js}
  ; thumbnail_path = {js|/static/thumbnails/7eb8af05-a6d5-4a88-89f3-146673a87cf0.jpg|js}
  ; description = None
  ; published_at = {js|2015-09-18T00:00:00.000Z|js}
  ; updated_at = {js|2021-08-03T16:47:54.414Z|js}
  ; language = {js|English|js}
  ; category = {js|Science & Technology|js}
  };
 
  { name = {js|The State of the OCaml Platform - September 2015|js}
  ; embed_path = {js|/videos/embed/0eeab9cb-8984-4323-bad7-0630192c635d|js}
  ; thumbnail_path = {js|/static/thumbnails/43586bbe-9d65-4283-88b7-3583d9ee6282.jpg|js}
  ; description = Some {js|The State of the OCaml Platform: September 2015 — by Anil Madhavapeddy, Amir Chaudhry, Thomas Gazagnaire, Jeremy Yallop, David Sheets|js}
  ; published_at = {js|2021-10-02T01:54:41.728Z|js}
  ; updated_at = {js|2021-10-02T01:54:41.728Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|The final pieces of the OCaml documentation puzzle|js}
  ; embed_path = {js|/videos/embed/2acebff9-25fa-4733-83cc-620a65b12251|js}
  ; thumbnail_path = {js|/static/thumbnails/c877a501-c705-44f7-8826-e7ce846a5e42.jpg|js}
  ; description = Some {js|Rendering OCaml document is widely known as a very difficult task: The ever-evolving OCaml module system is extremely rich and can include complex set of inter-dependencies that are both difficult to compute and to render in a concise document. It...|js}
  ; published_at = {js|2020-08-28T00:00:00.000Z|js}
  ; updated_at = {js|2021-11-01T14:02:00.085Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|Towards A Debugger for Native Code OCaml|js}
  ; embed_path = {js|/videos/embed/e1a22cf8-5522-4c05-a8d4-af445bc73556|js}
  ; thumbnail_path = {js|/static/thumbnails/5e783783-056e-46c9-b1de-60fddbd36aee.jpg|js}
  ; description = Some {js|Towards A Debugger for Native-Code OCaml — by Fabrice Le Fessant, Pierre Chambart|js}
  ; published_at = {js|2021-10-02T01:54:48.408Z|js}
  ; updated_at = {js|2021-10-02T01:54:48.408Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|Towards A Debugger for Native Code OCaml|js}
  ; embed_path = {js|/videos/embed/b76f3301-261d-44f3-97ec-1910b45f6969|js}
  ; thumbnail_path = {js|/static/thumbnails/93ea327e-5e8b-4844-b237-75719a7256b9.jpg|js}
  ; description = None
  ; published_at = {js|2015-09-18T00:00:00.000Z|js}
  ; updated_at = {js|2021-08-03T16:20:17.728Z|js}
  ; language = {js|English|js}
  ; category = {js|Science & Technology|js}
  };
 
  { name = {js|Towards an OCaml Platform|js}
  ; embed_path = {js|/videos/embed/96b1ab00-94a8-4059-aec6-a06a9c73c736|js}
  ; thumbnail_path = {js|/static/thumbnails/513c6f1c-df55-448f-a1db-2f13d430fdab.jpg|js}
  ; description = Some {js|Towards an OCaml Platform, by Yaron Minsky|js}
  ; published_at = {js|2021-10-03T23:06:53.043Z|js}
  ; updated_at = {js|2021-10-17T23:02:00.365Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|Transport Layer Security purely in OCaml|js}
  ; embed_path = {js|/videos/embed/03721258-b275-4c98-8a0b-9e4606b32fec|js}
  ; thumbnail_path = {js|/static/thumbnails/c1f04a1e-5cd8-41f5-8bef-25122319e6a5.jpg|js}
  ; description = Some {js|Transport Layer Security purely in OCaml by Hannes Mehnert and David Kaloper Meršinjak

Transport Layer Security purely in OCamlTransport Layer Security (TLS) is probably the most widely de- ployed security protocol on the Internet. It is used t...|js}
  ; published_at = {js|2021-10-03T22:08:27.076Z|js}
  ; updated_at = {js|2021-10-03T22:08:27.076Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|Types in Amber|js}
  ; embed_path = {js|/videos/embed/99b3dc75-9f93-4677-9f8b-076546725512|js}
  ; thumbnail_path = {js|/static/thumbnails/acd50ed1-43cf-45fd-a55e-9c40a6bf58ba.jpg|js}
  ; description = Some {js|Coda is a new cryptocurrency that uses zk-SNARKs to dramatically reduce the size of data needed by nodes running its protocol. Nodes communicate in a format automatically derived from type definitions in OCaml source files. As the Coda software ev...|js}
  ; published_at = {js|2020-08-28T00:00:00.000Z|js}
  ; updated_at = {js|2021-08-29T09:02:00.201Z|js}
  ; language = {js|Unknown|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|Using Preferences to Tame your Package Manager|js}
  ; embed_path = {js|/videos/embed/43536918-a6e5-4a53-a680-bed527319e31|js}
  ; thumbnail_path = {js|/static/thumbnails/23d48007-16ab-4e49-b979-0cf79fd685ce.jpg|js}
  ; description = None
  ; published_at = {js|2021-10-03T22:10:19.844Z|js}
  ; updated_at = {js|2021-10-03T22:10:19.844Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|What's new in OCamls 4.03|js}
  ; embed_path = {js|/videos/embed/b967996a-3dab-415f-8e51-d8908361b2b2|js}
  ; thumbnail_path = {js|/static/thumbnails/d7e64359-41c9-47d5-8f6d-9953db6555b3.jpg|js}
  ; description = Some {js|What is new in OCaml 4.03? by Damien Doligez|js}
  ; published_at = {js|2021-10-08T23:45:42.515Z|js}
  ; updated_at = {js|2021-10-08T23:47:55.929Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  };
 
  { name = {js|Wibbily Wobbly Timey Camly|js}
  ; embed_path = {js|/videos/embed/ec641446-823b-40ec-a207-85157a18f88e|js}
  ; thumbnail_path = {js|/static/thumbnails/2300474a-7615-4c92-9489-9ff5117d8bc7.jpg|js}
  ; description = Some {js|Time handling is commonly considered a difficult problem by programmers due to myriad standards and complexity of time zone definitions. This also complicates scheduling across multiple time zones especially when one takes Daylight Saving Time int...|js}
  ; published_at = {js|2021-08-27T10:37:18.000Z|js}
  ; updated_at = {js|2022-01-12T19:01:00.064Z|js}
  ; language = {js|English|js}
  ; category = {js|Science & Technology|js}
  };
 
  { name = {js|gloc - Metaprogramming WebGL Shaders with OCaml|js}
  ; embed_path = {js|/videos/embed/41ca2c8d-2238-44ca-8744-70f114fbd326|js}
  ; thumbnail_path = {js|/static/thumbnails/5f1f0afd-001f-4b15-976c-013a426360ac.jpg|js}
  ; description = Some {js|
gloc : Metaprogramming WebGL Shaders with OCaml, by David William Wallace Sheets and Ashima Arts.

WebGL is a new Khronos Group standard for GPU-accelerated rendering by in-browser JavaScript applications. WebGL introduces a new language, WebG...|js}
  ; published_at = {js|2021-10-03T22:33:00.872Z|js}
  ; updated_at = {js|2022-01-27T05:01:00.075Z|js}
  ; language = {js|English|js}
  ; category = {js|Misc|js}
  }]

