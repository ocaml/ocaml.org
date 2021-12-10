
type role =
  [ `Chair
  | `Co_chair
  ]

type important_date = { date : string; info : string }

type committee_member = {
  name : string;
  role : role option;
  affiliation : string option;
  picture : string option;
}

type presentation = {
  title : string;
  authors : string list;
  link : string option;
  video : string option;
  slides : string option;
  poster : bool option;
  additional_links : string list option;
}

type t = {
  title : string;
  slug : string;
  location : string;
  date : string;
  important_dates : important_date list;
  presentations : presentation list;
  program_committee : committee_member list;
  organising_committee : committee_member list;
  toc_html : string;
  body_md : string;
  body_html : string;
}
  
let all = 
[
  { title = {js|OCaml Workshop 2021|js}
  ; slug = {js|ocaml-workshop-2021|js}
  ; location = {js|Virtual|js}
  ; date = {js|2021-08-27|js}
  ; important_dates = 
 [
  { date = {js|2021-05-20|js};
    info = {js|Abstract submission deadline|js};
  };
  
  { date = {js|2021-07-18|js};
    info = {js|Author notification|js};
  };
  
  { date = {js|2021-08-27|js};
    info = {js|OCaml Workshop|js};
  }]
  ; presentations = 
 [
  { title = {js|25 Years of OCaml|js};
    authors = ["Xavier Leroy"];
    link = None;
    video = Some {js|https://watch.ocaml.org/videos/watch/e1ee0fc0-50ef-4a1c-894a-17df181424cb|js};
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|A Multiverse of Glorious Documentation|js};
    authors = 
  ["Lucas Pluvinage"; "Jonathan Ludlam"];
    link = Some {js|https://icfp21.sigplan.org/details/ocaml-2021-papers/15/A-Multiverse-of-Glorious-Documentation|js};
    video = Some {js|https://watch.ocaml.org/videos/watch/9bb452d6-1829-4dac-a6a2-46b31050c931|js};
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Adapting the OCaml Ecosystem for Multicore OCaml|js};
    authors = 
  ["Sudha Parimala"; "Enguerrand Decorne"; "Sadiq Jaffer"; "Tom Kelly";
   "KC Sivaramakrishnan"];
    link = Some {js|https://icfp21.sigplan.org/details/ocaml-2021-papers/7/Adapting-the-OCaml-ecosystem-for-Multicore-OCaml|js};
    video = Some {js|https://watch.ocaml.org/videos/watch/629b89a8-bbd5-490d-98b0-d0c740912b02|js};
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Binary Analysis Platform (BAP). Using Universal Algebra and Tagless-Final Style for Developing Representation-Agnostic Frameworks|js};
    authors = 
  ["Ivan Gotovchits"; "David Brumley"];
    link = Some {js|https://icfp21.sigplan.org/details/ocaml-2021-papers/10/Binary-Analysis-Platform-BAP-Using-Universal-Algebra-and-Tagless-Final-Style-for-D|js};
    video = Some {js|https://watch.ocaml.org/videos/watch/8dc2d8d3-c140-4c3d-a8fe-a6fcf6fba988|js};
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Continuous Benchmarking for OCaml Projects|js};
    authors = 
  ["Gargi Sharma"; "Rizo Isrof"; "Magnus Skjegstad"];
    link = None;
    video = Some {js|https://watch.ocaml.org/videos/watch/1c994370-1aaa-4db6-b901-d762786e4904|js};
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Deductive Verification of Realistic OCaml Code|js};
    authors = 
  ["Carlos Pinto"; "Mário Pereira"; "Simão Melo de Sousa"];
    link = None;
    video = Some {js|https://watch.ocaml.org/videos/watch/92309d92-8cbf-4545-980c-209c96e42a79|js};
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Digodoc and Docs|js};
    authors = ["Mohamed Hernouf";
                                                        "Fabrice Le Fessant";
                                                        "Thomas Blanc";
                                                        "Louis Gesbert"];
    link = None;
    video = Some {js|https://watch.ocaml.org/videos/watch/db6ed2c4-e940-4d5f-82ee-d3d20eb4ceb7|js};
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Experiences with Effects|js};
    authors = ["Thomas Leonard";
                                                                "Craig Ferguson";
                                                                "Patrick Ferris";
                                                                "Sadiq Jaffer";
                                                                "Tom Kelly";
                                                                "KC Sivaramakrishnan";
                                                                "Anil Madhavapeddy"];
    link = Some {js|https://icfp21.sigplan.org/details/ocaml-2021-papers/16/Experiences-with-Effects|js};
    video = Some {js|https://watch.ocaml.org/videos/watch/74ece0a8-380f-4e2a-bef5-c6bb9092be89|js};
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|From 2n+1 to n|js};
    authors = ["Nandor Licker";
                                                      "Timothy M. Jones"];
    link = Some {js|https://icfp21.sigplan.org/details/ocaml-2021-papers/14/From-2n-1-to-n|js};
    video = Some {js|https://watch.ocaml.org/videos/watch/74b32dae-11c6-4713-be1b-946260196e50|js};
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|GopCaml: A Structural Editor for OCaml|js};
    authors = 
  ["Kiran Gopinathan"];
    link = Some {js|https://icfp21.sigplan.org/details/ocaml-2021-papers/11/GopCaml-A-Structural-Editor-for-OCaml|js};
    video = Some {js|https://watch.ocaml.org/videos/watch/e0a6e6f2-0d40-4dfc-9308-001c8e0f64d6|js};
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Leveraging Formal Specifications to Generate Fuzzing Suites|js};
    authors = 
  ["Nicolas Osborne"; "Clément Pascutto"];
    link = None;
    video = Some {js|https://watch.ocaml.org/videos/watch/d9a36c9f-1611-42f9-8854-981b1e2d7d75|js};
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Love: a readable language interpreted by a blockchain|js};
    authors = 
  ["Steven de Oliveira"; "David Declerck"];
    link = None;
    video = Some {js|https://watch.ocaml.org/videos/watch/d3b2b31e-1739-406e-8de7-d5f21bc01836|js};
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|OCaml and Python: Getting the Best of Both Worlds|js};
    authors = 
  ["Laurent Mazare"];
    link = None;
    video = Some {js|https://watch.ocaml.org/videos/watch/9eafdb1e-9be9-4a52-98b4-f4696eda4c18|js};
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Opam-bin: Binary Packages with Opam|js};
    authors = 
  ["Fabrice Le Fessant"];
    link = Some {js|https://icfp21.sigplan.org/details/ocaml-2021-papers/5/Opam-bin-Binary-Packages-with-Opam|js};
    video = Some {js|https://watch.ocaml.org/videos/watch/a889e4d3-0508-4734-b667-7060b0a253cd|js};
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Parafuzz: Coverage-guided Property Fuzzing for Multicore OCaml programs|js};
    authors = 
  ["Sumit Padhiyar"; "Adharsh Kamath"; "KC Sivaramakrishnan"];
    link = Some {js|https://icfp21.sigplan.org/details/ocaml-2021-papers/9/Parafuzz-Coverage-guided-Property-Fuzzing-for-Multicore-OCaml-programs|js};
    video = Some {js|https://watch.ocaml.org/videos/watch/c0d591e0-91c9-4eaa-a4d7-c4f514de0a57|js};
    slides = Some {js|https://speakerdeck.com/kayceesrk/parafuzz-fuzzing-multicore-ocaml-programs|js};
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Probabilistic resource limits, or: Programming with interrupts in OCaml|js};
    authors = 
  ["Guillaume Munch-Maccagnoni"];
    link = None;
    video = Some {js|https://watch.ocaml.org/videos/watch/bc297e85-82dd-4baf-8556-4a3a934978f9|js};
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Property-Based Testing for OCaml through Coq|js};
    authors = 
  ["Paaras Bhandari"; "Leonidas Lampropoulos"];
    link = None;
    video = Some {js|https://watch.ocaml.org/videos/watch/9324fba4-2482-4bab-bfdd-b8881b3ed94a|js};
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Safe Protocol Updates via Propositional Logic|js};
    authors = 
  ["Michael O'Connor"];
    link = None;
    video = Some {js|https://watch.ocaml.org/videos/watch/c6176f51-0277-46f0-937b-1e2721044492|js};
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Semgrep, a fast, lightweight, polyglot, static analysis tool to find bugs|js};
    authors = 
  ["Yoann Padioleau"];
    link = Some {js|https://icfp21.sigplan.org/details/ocaml-2021-papers/18/Semgrep-a-fast-lightweight-polyglot-static-analysis-tool-to-find-bugs|js};
    video = Some {js|https://watch.ocaml.org/videos/watch/c0d07213-1426-46a1-98e0-0b0c4515c841|js};
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Wibbily Wobbly Timey Camly|js};
    authors = ["Di Long Li";
                                                                  "Gabriel Radanne"];
    link = None;
    video = Some {js|https://watch.ocaml.org/videos/watch/ec641446-823b-40ec-a207-85157a18f88e|js};
    slides = None;
    poster = None;
    additional_links = None;
  }]
  ; program_committee = 
 [
  { name = {js|Frédéric Bour|js};
    role = Some `Chair;
    affiliation = Some {js|Tarides, France|js};
    picture = Some {js|https://tarides.com/static/2c582dcc5c8b277d0d949513f005db49/5ff57/fred.webp|js};
  };
  
  { name = {js|Mehdi Bouaziz|js};
    role = None;
    affiliation = Some {js|Nomadic Labs, France|js};
    picture = None;
  };
  
  { name = {js|Simon Castellan|js};
    role = None;
    affiliation = Some {js|INRIA, France|js};
    picture = None;
  };
  
  { name = {js|Youyou Cong|js};
    role = None;
    affiliation = Some {js|Tokyo Institute of Technology, Japan|js};
    picture = None;
  };
  
  { name = {js|Kate Deplaix|js};
    role = None;
    affiliation = Some {js|OCaml Labs, UK|js};
    picture = None;
  };
  
  { name = {js|Jun Furuse|js};
    role = None;
    affiliation = Some {js|DaiLambda, Japan|js};
    picture = None;
  };
  
  { name = {js|Joris Giovannangeli|js};
    role = None;
    affiliation = Some {js|Ahrefs Research|js};
    picture = Some {js|https://static.ahrefs.com/images/team/joris-g.jpg|js};
  };
  
  { name = {js|Kihong Heo|js};
    role = None;
    affiliation = Some {js|KAIST, South Korea|js};
    picture = None;
  };
  
  { name = {js|Hugo Heuzard|js};
    role = None;
    affiliation = Some {js|Jane Street|js};
    picture = None;
  };
  
  { name = {js|Vaivaswatha Nagaraj|js};
    role = None;
    affiliation = Some {js|Zilliqa Research, India|js};
    picture = None;
  };
  
  { name = {js|Hakjoo Oh|js};
    role = None;
    affiliation = Some {js|Korea University|js};
    picture = None;
  };
  
  { name = {js|Jonathan Protzenko|js};
    role = None;
    affiliation = Some {js|Microsoft Research Redmond, USA|js};
    picture = None;
  };
  
  { name = {js|Cristina Rosu|js};
    role = None;
    affiliation = Some {js|Jane Street|js};
    picture = None;
  };
  
  { name = {js|Jeffrey A. Scofield|js};
    role = None;
    affiliation = Some {js|Psellos|js};
    picture = None;
  };
  
  { name = {js|Ryohei Tokuda|js};
    role = None;
    affiliation = Some {js|Idein|js};
    picture = None;
  }]
  ; organising_committee = 
 [
  { name = {js|Frédéric Bour|js};
    role = Some `Chair;
    affiliation = Some {js|Tarides, France|js};
    picture = Some {js|https://tarides.com/static/2c582dcc5c8b277d0d949513f005db49/5ff57/fred.webp|js};
  }]
  ; body_md = {js|
The OCaml Users and Developers Workshop brings together the OCaml community, including users of OCaml in industry, academia, hobbyists and the free software community.

OCaml 2021 will be a virtual workshop, co-located with ICFP 2021.
|js}
  ; toc_html = {js||js}
  ; body_html = {js|<p>The OCaml Users and Developers Workshop brings together the OCaml community, including users of OCaml in industry, academia, hobbyists and the free software community.</p>
<p>OCaml 2021 will be a virtual workshop, co-located with ICFP 2021.</p>
|js}
  };
 
  { title = {js|OCaml Workshop 2020|js}
  ; slug = {js|ocaml-workshop-2020|js}
  ; location = {js|Virtual|js}
  ; date = {js|2020-08-28|js}
  ; important_dates = 
 [
  { date = {js|2020-03-30|js};
    info = {js|Workshop Announcement|js};
  };
  
  { date = {js|2020-05-29|js};
    info = {js|Abstract submission deadline (any timezone)|js};
  };
  
  { date = {js|2020-07-17|js};
    info = {js|Author notification|js};
  };
  
  { date = {js|2020-08-14|js};
    info = {js|Camera-ready Deadline|js};
  };
  
  { date = {js|2020-08-28|js};
    info = {js|OCaml Workshop|js};
  }]
  ; presentations = 
 [
  { title = {js|A Declarative Syntax Definition for OCaml|js};
    authors = 
  ["Luis Eduardo de Souza Amorim"; "Eelco Visser"];
    link = None;
    video = Some {js|https://watch.ocaml.org/videos/watch/a5b86864-8e43-4138-b6d6-ed48d2d4b63d|js};
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|A Simple State-Machine Framework for Property-Based Testing in OCaml|js};
    authors = 
  ["Jan Midtgaard"];
    link = None;
    video = Some {js|https://watch.ocaml.org/videos/watch/08b429ea-2eb8-427d-a625-5495f4ee0fef|js};
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|AD-OCaml: Algorithmic Differentiation for OCaml|js};
    authors = 
  ["Markus Mottl"];
    link = None;
    video = Some {js|https://watch.ocaml.org/videos/watch/c9e85690-732f-4b03-836f-2ee0fd8f0658|js};
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|API Migration: compare transformed|js};
    authors = 
  ["Joseph Harrison"; "Steven Varoumas"; "Simon Thompson"; "Reuben Rowe"];
    link = None;
    video = Some {js|https://watch.ocaml.org/videos/watch/c46b925b-bd77-404f-ac5d-5dab65047529|js};
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Irmin v2|js};
    authors = ["Clément Pascutto";
                                                "Ioana Cristescu";
                                                "Craig Ferguson";
                                                "Thomas Gazagnaire";
                                                "Romain Liautaud"];
    link = None;
    video = Some {js|https://watch.ocaml.org/videos/watch/53e497b0-898f-4c85-8da9-39f65ef0e0b1|js};
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|LexiFi Runtime Types|js};
    authors = ["Patrik Keller";
                                                            "Marc Lasson"];
    link = None;
    video = Some {js|https://watch.ocaml.org/videos/watch/cc7e3242-0bef-448a-aa13-8827bba933e3|js};
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|OCaml Under The Hood: SmartPy|js};
    authors = ["Sebastien Mondet"];
    link = None;
    video = Some {js|https://watch.ocaml.org/videos/watch/7446ad4d-4ae2-4e1a-bc38-af8f71e8ebd8|js};
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|OCaml-CI: A Zero-Configuration CI|js};
    authors = 
  ["Thomas Leonard"; "Craig Ferguson"; "Kate Deplaix"; "Magnus Skjegstad";
   "Anil Madhavapeddy"];
    link = None;
    video = Some {js|https://watch.ocaml.org/videos/watch/da88d6ac-7ba1-4261-9308-d03fe21e35b9|js};
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Parallelising your OCaml Code with Multicore OCaml|js};
    authors = 
  ["Sadiq Jaffer"; "Sudha Parimala"; "KC Sivaramakrishnan"; "Tom Kelly";
   "Anil Madhavapeddy"];
    link = Some {js|https://github.com/ocaml-multicore/multicore-talks/tree/master/ocaml2020-workshop-parallel|js};
    video = Some {js|https://watch.ocaml.org/videos/watch/ce20839e-4bfc-4d74-925b-485a6b052ddf|js};
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|The ImpFS filesystem|js};
    authors = ["Tom Ridge"];
    link = None;
    video = Some {js|https://watch.ocaml.org/videos/watch/28545b27-4637-47a5-8edd-6b904daef19c|js};
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|The Final Pieces of the OCaml Documentation Puzzle|js};
    authors = 
  ["Jonathan Ludlam"; "Gabriel Radanne"; "Leo White"];
    link = None;
    video = Some {js|https://watch.ocaml.org/videos/watch/2acebff9-25fa-4733-83cc-620a65b12251|js};
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Types in amber|js};
    authors = ["Paul Steckler";
                                                      "Matthew Ryan"];
    link = None;
    video = Some {js|https://watch.ocaml.org/videos/watch/99b3dc75-9f93-4677-9f8b-076546725512|js};
    slides = None;
    poster = None;
    additional_links = None;
  }]
  ; program_committee = 
 [
  { name = {js|Ivan Gotovchits|js};
    role = Some `Chair;
    affiliation = Some {js|CMU, USA|js};
    picture = None;
  };
  
  { name = {js|Florian Angeletti|js};
    role = None;
    affiliation = Some {js|INRIA, France|js};
    picture = None;
  };
  
  { name = {js|Chris Casinghino|js};
    role = None;
    affiliation = Some {js|Draper Laboratory, USA|js};
    picture = None;
  };
  
  { name = {js|Catherine Gasnier|js};
    role = None;
    affiliation = Some {js|Facebook, USA|js};
    picture = None;
  };
  
  { name = {js|Rudi Grinberg|js};
    role = None;
    affiliation = Some {js|OCaml Labs, UK|js};
    picture = None;
  };
  
  { name = {js|Oleg Kiselyov|js};
    role = None;
    affiliation = Some {js|Tohoku University, Japan|js};
    picture = None;
  };
  
  { name = {js|Andreas Rossberg|js};
    role = None;
    affiliation = Some {js|Dfinity Stiftung, Germany|js};
    picture = None;
  };
  
  { name = {js|Marcello Seri|js};
    role = None;
    affiliation = Some {js|University of Groningen, Netherlands|js};
    picture = None;
  };
  
  { name = {js|Edwin Torok|js};
    role = None;
    affiliation = Some {js|Citrix, UK|js};
    picture = None;
  };
  
  { name = {js|Leo White|js};
    role = None;
    affiliation = Some {js|Jane Street, USA|js};
    picture = None;
  };
  
  { name = {js|Greta Yorsh|js};
    role = None;
    affiliation = Some {js|Jane Street, USA|js};
    picture = None;
  };
  
  { name = {js|Sarah Zennou|js};
    role = None;
    affiliation = Some {js|Airbus, France|js};
    picture = None;
  }]
  ; organising_committee = 
 [
  { name = {js|Ivan Gotovchits|js};
    role = Some `Chair;
    affiliation = None;
    picture = None;
  };
  
  { name = {js|Gemma Gordon|js};
    role = Some `Co_chair;
    affiliation = None;
    picture = None;
  };
  
  { name = {js|Anil Madhavapeddy|js};
    role = Some `Co_chair;
    affiliation = None;
    picture = None;
  };
  
  { name = {js|Frédéric Bour|js};
    role = None;
    affiliation = None;
    picture = None;
  };
  
  { name = {js|Enzo Crance|js};
    role = None;
    affiliation = None;
    picture = None;
  };
  
  { name = {js|Shon Feder|js};
    role = None;
    affiliation = None;
    picture = None;
  };
  
  { name = {js|Sonja Heinze|js};
    role = None;
    affiliation = None;
    picture = None;
  };
  
  { name = {js|Shakthi Kannan|js};
    role = None;
    affiliation = None;
    picture = None;
  };
  
  { name = {js|Flynn Ludlam|js};
    role = None;
    affiliation = None;
    picture = None;
  };
  
  { name = {js|Tim McGilchrist|js};
    role = None;
    affiliation = None;
    picture = None;
  };
  
  { name = {js|Sebastien Mondet|js};
    role = None;
    affiliation = None;
    picture = None;
  };
  
  { name = {js|Sudha Parimala|js};
    role = None;
    affiliation = None;
    picture = None;
  };
  
  { name = {js|Tom Ridge|js};
    role = None;
    affiliation = None;
    picture = None;
  };
  
  { name = {js|Marcello Seri|js};
    role = None;
    affiliation = None;
    picture = None;
  };
  
  { name = {js|Daniel Tornabene|js};
    role = None;
    affiliation = None;
    picture = None;
  };
  
  { name = {js|Shiwei Weng|js};
    role = None;
    affiliation = None;
    picture = None;
  }]
  ; body_md = {js|
The OCaml Users and Developers Workshop brings together the OCaml
community, including users of OCaml in industry, academia, hobbyists,
and the free software community.

The meeting is an informal community gathering of users of the language,
library authors, and developers, using and extending OCaml in new ways.
The meeting will be held online this year.

This workshop was originally planned to take place in Jersey City, New Jersey, USA and was later changed to be held virtually.
|js}
  ; toc_html = {js||js}
  ; body_html = {js|<p>The OCaml Users and Developers Workshop brings together the OCaml
community, including users of OCaml in industry, academia, hobbyists,
and the free software community.</p>
<p>The meeting is an informal community gathering of users of the language,
library authors, and developers, using and extending OCaml in new ways.
The meeting will be held online this year.</p>
<p>This workshop was originally planned to take place in Jersey City, New Jersey, USA and was later changed to be held virtually.</p>
|js}
  };
 
  { title = {js|OCaml Workshop 2019|js}
  ; slug = {js|ocaml-workshop-2019|js}
  ; location = {js|Berlin, Germany|js}
  ; date = {js|2019-08-23|js}
  ; important_dates = 
 [
  { date = {js|2019-05-17|js};
    info = {js|Abstract submission deadline (any timezone)|js};
  };
  
  { date = {js|2019-06-30|js};
    info = {js|Author notification|js};
  };
  
  { date = {js|2019-08-23|js};
    info = {js|OCaml Workshop|js};
  }]
  ; presentations = 
 [
  { title = {js|Codept, a whole-project dependency analyzer for OCaml|js};
    authors = 
  ["Florian Angeletti"];
    link = None;
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|MirageOS 4: the dawn of practical build systems for exotic targets|js};
    authors = 
  ["Lucas Pluvinage"; "Romain Calascibetta"; "Rudi Grinberg";
   "Anil Madhavapeddy"];
    link = None;
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Makecloud: Simple, Fast, Robust CI/CD for the modern era|js};
    authors = 
  ["Adam Ringwood"; "Hezekiah Carty"];
    link = None;
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|The future of OCaml PPX: towards a unified and more robust ecosystem|js};
    authors = 
  ["Nathan Rebours"; "Jeremie Dimino"; "Xavier Clerc"; "Carl Eastlund"];
    link = None;
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|CausalRPC: traceable distributed computation|js};
    authors = 
  ["Craig Ferguson"];
    link = None;
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|The OCaml Platform in 2019|js};
    authors = ["Anil Madhavapeddy";
                                                                  "Gemma Gordon"];
    link = None;
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Lessons from building a succinct blockchain with OCaml|js};
    authors = 
  ["Nathan Holland"];
    link = None;
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|OwlDE: making ODEs first-class Owl citizens|js};
    authors = 
  ["Marcello Seri"; "Ta-Chu Kao"];
    link = None;
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Benchmarking the OCaml compiler: our experience|js};
    authors = 
  ["Tom Kelly"];
    link = None;
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Executing Owl Computation on GPU and TPU|js};
    authors = 
  ["Jianxin Zhao"];
    link = None;
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  }]
  ; program_committee = 
 [
  { name = {js|David Allsopp|js};
    role = Some `Chair;
    affiliation = Some {js|University of Cambridge, UK|js};
    picture = None;
  };
  
  { name = {js|Raja Boujbel|js};
    role = None;
    affiliation = Some {js|OCamlPro, France|js};
    picture = None;
  };
  
  { name = {js|Timothy Bourke|js};
    role = None;
    affiliation = Some {js|INRIA, France|js};
    picture = None;
  };
  
  { name = {js|Simon Cruanes|js};
    role = None;
    affiliation = Some {js|Imandra, USA|js};
    picture = None;
  };
  
  { name = {js|Emilio Jésus Gallego Arias|js};
    role = None;
    affiliation = Some {js|MINES ParisTech, France|js};
    picture = None;
  };
  
  { name = {js|Thomas Gazagnaire|js};
    role = None;
    affiliation = Some {js|Tarides, France|js};
    picture = None;
  };
  
  { name = {js|Ivan Gotovchits|js};
    role = None;
    affiliation = Some {js|CMU, USA|js};
    picture = None;
  };
  
  { name = {js|Hannes Mehnert|js};
    role = None;
    affiliation = Some {js|robur.io, Germany|js};
    picture = None;
  };
  
  { name = {js|Igor Pikovets|js};
    role = None;
    affiliation = Some {js|Ahrefs, Singapore|js};
    picture = None;
  };
  
  { name = {js|Thomas Refis|js};
    role = None;
    affiliation = Some {js|Jane Street Europe, UK|js};
    picture = None;
  };
  
  { name = {js|KC Sivaramakrishan|js};
    role = None;
    affiliation = Some {js|IIT Madras, India|js};
    picture = None;
  }]
  ; organising_committee = 
 []
  ; body_md = {js|
The OCaml Users and Developers Workshop brings together the OCaml community, including users of OCaml in industry, academia, hobbyists and the free software community.

The meeting is an informal community gathering of users of the language, library authors, and developers, using and extending OCaml in new ways.
|js}
  ; toc_html = {js||js}
  ; body_html = {js|<p>The OCaml Users and Developers Workshop brings together the OCaml community, including users of OCaml in industry, academia, hobbyists and the free software community.</p>
<p>The meeting is an informal community gathering of users of the language, library authors, and developers, using and extending OCaml in new ways.</p>
|js}
  };
 
  { title = {js|OCaml Users and Developers Workshop 2018|js}
  ; slug = {js|ocaml-users-and-developers-workshop-2018|js}
  ; location = {js|St. Louis, Missouri, USA|js}
  ; date = {js|2018-08-23|js}
  ; important_dates = 
 [
  { date = {js|2018-05-31|js};
    info = {js|Abstract submission deadline (any timezone)|js};
  };
  
  { date = {js|2018-09-27|js};
    info = {js|OCaml Workshop|js};
  }]
  ; presentations = 
 [
  { title = {js|Abusing Format for fun and profits|js};
    authors = 
  ["Gabriel Radanne"; "Frédéric Bour"];
    link = None;
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|MLExplain|js};
    authors = ["Kévin Le Bon";
                                                 "Alan Schmitt"];
    link = None;
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|OCaml on the ESP32 chip: Well-Typed Lightbulbs Await|js};
    authors = 
  ["Lucas Pluvinage"; "Sadiq Jaffer"; "Anil Madhavapeddy"];
    link = None;
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|R&B: Towards bringing functional programming to everyday's web programmer|js};
    authors = 
  ["Hongbo Zhang"; "Cristiano Calcagno"; "Jordan Walke"; "Cheng Lou";
   "Rick Vetter"];
    link = None;
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|RFCs, all the way down!|js};
    authors = ["Romain Calascibetta"];
    link = None;
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Relit: Implementing Typed Literal Macros in Reason|js};
    authors = 
  ["Charles Chamberlain"; "Cyrus Omar"];
    link = None;
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|The OCaml Platform 1.0|js};
    authors = ["Anil Madhavapeddy";
                                                              "Gemma Gordon"];
    link = None;
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|The OCaml Software Foundation|js};
    authors = ["Michel Mauny";
                                                                    "Yann Régis-Gianas"];
    link = None;
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|The Vecosek Ecosystem|js};
    authors = ["Sebastien Mondet"];
    link = None;
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|This PDF is an OCaml bytecode|js};
    authors = ["Gabriel Radanne"];
    link = None;
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Wall: rendering vector graphics with OCaml and OpenGL|js};
    authors = 
  ["Frédéric Bour"];
    link = None;
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Winning on Windows: porting the OCaml Platform|js};
    authors = 
  ["David Allsopp"];
    link = None;
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  }]
  ; program_committee = 
 [
  { name = {js|Andrew Kennedy|js};
    role = Some `Chair;
    affiliation = Some {js|Facebook, London|js};
    picture = None;
  };
  
  { name = {js|Stephen Dolan|js};
    role = None;
    affiliation = Some {js|University of Cambridge, UK|js};
    picture = None;
  };
  
  { name = {js|Clark Gaebel|js};
    role = None;
    affiliation = Some {js|Jane Street|js};
    picture = None;
  };
  
  { name = {js|Nicolás Ojeda Bär|js};
    role = None;
    affiliation = Some {js|LexiFi|js};
    picture = None;
  };
  
  { name = {js|Jonathan Protzenko|js};
    role = None;
    affiliation = Some {js|Microsoft Research Redmond, USA|js};
    picture = None;
  };
  
  { name = {js|Gabriel Scherer|js};
    role = None;
    affiliation = Some {js|INRIA Saclay, France|js};
    picture = None;
  };
  
  { name = {js|Kanae Tsushima|js};
    role = None;
    affiliation = Some {js|National Institute of Informatics, Japan|js};
    picture = None;
  };
  
  { name = {js|John Whitington|js};
    role = None;
    affiliation = Some {js|University of Leicester, UK|js};
    picture = None;
  }]
  ; organising_committee = 
 []
  ; body_md = {js|
OCaml 2018 will be held on September 27th, 2018 in St. Louis, Missouri, USA, colocated with ICFP 2018.
|js}
  ; toc_html = {js||js}
  ; body_html = {js|<p>OCaml 2018 will be held on September 27th, 2018 in St. Louis, Missouri, USA, colocated with ICFP 2018.</p>
|js}
  };
 
  { title = {js|OCaml Users and Developers Workshop 2017|js}
  ; slug = {js|ocaml-users-and-developers-workshop-2017|js}
  ; location = {js|Oxford, UK|js}
  ; date = {js|2017-09-08|js}
  ; important_dates = 
 [
  { date = {js|2017-05-31|js};
    info = {js|Abstract submission deadline (any timezone)|js};
  };
  
  { date = {js|2017-06-28|js};
    info = {js|Author notification|js};
  };
  
  { date = {js|2017-09-08|js};
    info = {js|OCaml Workshop|js};
  }]
  ; presentations = 
 [
  { title = {js|A B-tree library for OCaml|js};
    authors = ["Tom Ridge"];
    link = Some {js|workshop/2017/extended-abstract__2017__tom-ridge__a-b-tree-library-for-ocaml.pdf|js};
    video = None;
    slides = Some {js|workshop/2017/slides__2017__tom-ridge__a-b-tree-library-for-ocaml.pdf|js};
    poster = None;
    additional_links = None;
  };
  
  { title = {js|A memory model for multicore OCaml|js};
    authors = 
  ["Stephen Dolan"; "KC Sivaramakrishnan"];
    link = Some {js|https://github.com/ocaml/ocaml.org-media/blob/master/meetings/ocaml/2017/extended-abstract__2017__stephen-dolan_kc-sivaramakrishnan__a-memory-model-for-multicore-ocaml.pdf|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Component-based Program Synthesis in OCaml|js};
    authors = 
  ["Zhanpeng Liang"; "Kanae Tsushima"];
    link = Some {js|https://github.com/ocaml/ocaml.org-media/blob/master/meetings/ocaml/2017/extended-abstract__2017__zhanpeng-liang_kanae-tsushima__component-based-program-synthesis-in-ocaml.pdf|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Extending OCaml's open|js};
    authors = ["Runhang Li";
                                                              "Jeremy Yallop"];
    link = Some {js|https://github.com/ocaml/ocaml.org-media/blob/master/meetings/ocaml/2017/extended-abstract__2017__runhang-li_jeremy-yallop__extending-ocaml-s-open.pdf|js};
    video = Some {js|https://www.youtube.com/watch?v=rxCMop-dTuc&index=4&list=TLGGpj_CrU7rr7MxMjAxMjAxOA|js};
    slides = None;
    poster = None;
    additional_links = Some 
  ["https://github.com/objmagic/ocaml-workshop-17-open-ext-talk"];
  };
  
  { title = {js|Genspio: Generating Shell Phrases In OCaml|js};
    authors = 
  ["Sebastien Mondet"];
    link = Some {js|https://github.com/ocaml/ocaml.org-media/blob/master/meetings/ocaml/2017/extended-abstract__2017__sebastien-mondet__genspio-generating-shell-phrases-in-ocaml.pdf|js};
    video = Some {js|https://www.youtube.com/watch?v=prwLcBUoYiA&index=3&list=TLGGpj_CrU7rr7MxMjAxMjAxOA|js};
    slides = Some {js|http://wr.mondet.org/slides/OCaml2017-Genspio/|js};
    poster = None;
    additional_links = Some 
  ["https://github.com/hammerlab/genspio"];
  };
  
  { title = {js|Owl: A General-Purpose Numerical Library in OCaml|js};
    authors = 
  ["Liang Wang"];
    link = Some {js|https://arxiv.org/abs/1707.09616|js};
    video = Some {js|https://www.youtube.com/watch?v=Jyv3tJD1N3o&index=7&list=TLGGpj_CrU7rr7MxMjAxMjAxOA|js};
    slides = Some {js|https://github.com/ocaml/ocaml.org-media/blob/master/meetings/ocaml/2017/slides__2017__liang_wang__owl-a-general-purpose-numerical-library-in-ocaml.pdf|js};
    poster = None;
    additional_links = None;
  };
  
  { title = {js|ROTOR: First Steps Towards a Refactoring Tool for OCaml|js};
    authors = 
  ["Reuben N. S. Rowe"; "Simon Thompson"];
    link = Some {js|https://github.com/ocaml/ocaml.org-media/blob/master/meetings/ocaml/2017/extended-abstract__2017__reuben-rowe_simon-thompson__rotor-first-steps-towards-a-refactoring-tool-for-ocaml.pdf|js};
    video = None;
    slides = Some {js|https://github.com/ocaml/ocaml.org-media/blob/master/meetings/ocaml/2017/slides__2017__reuben-rowe_simon-thompson__rotor-first-steps-towards-a-refactoring-tool-for-ocaml.pdf|js};
    poster = None;
    additional_links = Some 
  ["https://gitlab.com/trustworthy-refactoring/";
   "https://hub.docker.com/r/reubenrowe/ocaml-rotor"];
  };
  
  { title = {js|Testing with Crowbar|js};
    authors = ["Stephen Dolan";
                                                            "Mindy Preston"];
    link = Some {js|https://github.com/ocaml/ocaml.org-media/blob/master/meetings/ocaml/2017/extended-abstract__2017__stephen-dolan_mindy-preston__testing-with-crowbar.pdf|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Tezos: the OCaml Crypto-Ledger|js};
    authors = 
  ["Benjamin Canou"; "Grégoire Henry"; "Pierre Chambart";
   "Fabrice Le Fessant"; "Arthur Breitman"];
    link = Some {js|https://github.com/ocaml/ocaml.org-media/blob/master/meetings/ocaml/2017/extended-abstract__2017__benjamin-canou_gregoire-henry_pierre-chambart_fabrice-le-fessant_arthur-breitman__tezos-the-ocaml-crypto-ledger.pdf|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|The State of the OCaml Platform: September 2017|js};
    authors = 
  ["Anil Madhavapeddy"];
    link = Some {js|https://github.com/ocaml/ocaml.org-media/blob/master/meetings/ocaml/2017/slides__2017__anil-madhavapeddy__the-state-of-the-ocaml-platform-september-2017.pdf|js};
    video = Some {js|https://www.youtube.com/watch?v=y-1Zrzdd9KM&index=6&list=TLGGpj_CrU7rr7MxMjAxMjAxOA|js};
    slides = Some {js|https://speakerdeck.com/avsm/ocaml-platform-2017|js};
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Wodan: a pure OCaml, flash-aware filesystem library|js};
    authors = 
  ["Gabriel de Perthuis"];
    link = Some {js|https://github.com/ocaml/ocaml.org-media/blob/master/meetings/ocaml/2017/extended-abstract__2017__gabriel-de-perthuis__wodan-a-pure-ocaml-flash-aware-filesystem-library.pdf|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|ocamli: interpreted OCaml|js};
    authors = ["John Whitington"];
    link = Some {js|http://www.cs.le.ac.uk/people/jw642/ocamlworkshop.pdf extended-abstract__2017__john_whitington__ocamli-interpreted-ocaml.pdf|js};
    video = None;
    slides = None;
    poster = Some true;
    additional_links = None;
  };
  
  { title = {js|mSAT: An OCaml SAT Solver|js};
    authors = ["Bury Guillaume"];
    link = Some {js|https://gbury.eu/public/papers/icfp2017_msat.pdf|js};
    video = None;
    slides = None;
    poster = Some true;
    additional_links = None;
  };
  
  { title = {js|Tyre – Typed Regular Expressions|js};
    authors = 
  ["Gabriel Radanne"];
    link = Some {js|https://www.irif.fr/~gradanne/papers/tyre/abstract.pdf|js};
    video = None;
    slides = None;
    poster = Some true;
    additional_links = None;
  };
  
  { title = {js|Jbuilder: a modern approach to OCaml development|js};
    authors = 
  ["Jeremie Dimino"; "Mark Shinwell"];
    link = None;
    video = None;
    slides = None;
    poster = Some true;
    additional_links = None;
  }]
  ; program_committee = 
 [
  { name = {js|Ashish Agarwal|js};
    role = None;
    affiliation = Some {js|Solvuu, USA|js};
    picture = None;
  };
  
  { name = {js|François Bobot|js};
    role = None;
    affiliation = Some {js|CEA, France|js};
    picture = None;
  };
  
  { name = {js|Frédéric Bour|js};
    role = None;
    affiliation = Some {js|OCaml Labs, France|js};
    picture = None;
  };
  
  { name = {js|Cristiano Calcagno|js};
    role = None;
    affiliation = Some {js|Facebook, UK|js};
    picture = None;
  };
  
  { name = {js|Louis Gesbert|js};
    role = None;
    affiliation = Some {js|OcamlPro, France|js};
    picture = None;
  };
  
  { name = {js|Sébastien Hinderer|js};
    role = None;
    affiliation = Some {js|INRIA, France|js};
    picture = None;
  };
  
  { name = {js|Atsushi Igarashi|js};
    role = None;
    affiliation = Some {js|Kyoto University, Japan|js};
    picture = None;
  };
  
  { name = {js|Oleg Kiselyov|js};
    role = None;
    affiliation = Some {js|Tohoku University, Japan|js};
    picture = None;
  };
  
  { name = {js|Julia Lawall|js};
    role = None;
    affiliation = Some {js|INRIA/LIP6, France|js};
    picture = None;
  };
  
  { name = {js|Sam Lindley|js};
    role = None;
    affiliation = Some {js|The University of Edinburgh, UK|js};
    picture = None;
  };
  
  { name = {js|Louis Mandel|js};
    role = None;
    affiliation = Some {js|IBM Research, USA|js};
    picture = None;
  };
  
  { name = {js|Zoe Paraskevopoulou|js};
    role = None;
    affiliation = Some {js|Princeton University, USA|js};
    picture = None;
  };
  
  { name = {js|Gabriel Scherer|js};
    role = None;
    affiliation = Some {js|Northeastern University, USA|js};
    picture = None;
  }]
  ; organising_committee = 
 []
  ; body_md = {js|
OCaml 2017 will open with an invited talk by three frequent
contributors that recently became maintainers of the OCaml
implementation: David Allsopp
([video](https://www.youtube.com/watch?v=10OQHsnyg64&index=2&list=TLGGpj_CrU7rr7MxMjAxMjAxOA)),
Florian Angeletti
([video](https://www.youtube.com/watch?v=HOfdGDSypP4&list=TLGGpj_CrU7rr7MxMjAxMjAxOA&index=5)),
and Sébastien Hinderer
([video](https://www.youtube.com/watch?v=SvnyQWZkHS8&list=TLGGpj_CrU7rr7MxMjAxMjAxOA&index=1)).

Due to the high number of high-quality submissions, we had to have
more posters than in previous editions to fit a one-day
schedule. 

## Call for presentations (past)

### Scope

Presentations and discussions will focus on the OCaml
programming language and its community. We aim to solicit talks
on all aspects related to improving the use or development of
the language and its programming environment, including, for
example (but not limited to):

- compiler developments, new backends, runtime and architectures

- practical type system improvements, such as (but not
  limited to) GADTs, first-class modules, generic programming,
  or dependent types

- new library or application releases, and their design
  rationales

- tools and infrastructure services, and their enhancements

- prominent industrial or experimental uses of OCaml, or
  deployments in unusual situations.

### Presentations

It will be an informal meeting with no formal proceedings. The
presentation material will be available online from the workshop
homepage. The presentations may be recorded, and made available
at a later time.

The main presentation format is a workshop talk, traditionally
around 20 minutes in length, plus question time, but we also
have a poster session during the workshop -- this allows to
present more diverse work, and gives time for discussion. The
program committee will decide which presentations should be
delivered as posters or talks.

### Submission

To submit a presentation, please register a description of the
talk (about 2 pages long) at <https://icfp-ocaml17.hotcrp.com/>
providing a clear statement of what will be provided by the
presentation: the problems that are addressed, the solutions or
methods that are proposed.

LaTeX-produced PDFs are a common and welcome submission
format. For accessibility purposes, we ask PDF submitters to
also provide the sources of their submission in a textual
format, such as .tex sources. Reviewers may read either the
submitted PDF or the text version.

### ML family workshop and post-proceedings

The ML family workshop, held on the previous day, deals with
general issues of the ML-style programming and type systems,
focuses on more research-oriented work that is less specific to
a language in particular (OCaml). There is an overlap between
the two workshops, and we have occasionally transferred
presentations from one to the other in the past. The authors who
feel their submission fits both workshops are encouraged to
mention it at submission time and/or contact the Program Chairs.

We are planning to publish combined post-proceedings and to
invite interested authors of selected presentations to expand
their abstracts for inclusion.


### Questions and contact

Please send any questions to the chair:
`Gabriel Scherer <gabriel.scherer@gmail.com>`|js}
  ; toc_html = {js|<ul>
<li><ul>
<li>Call for presentations (past)
<ul>
<li>Scope
</li>
<li>Presentations
</li>
<li>Submission
</li>
<li>ML family workshop and post-proceedings
</li>
<li>Questions and contact
</li>
</ul>
</li>
</ul>
</li>
</ul>
|js}
  ; body_html = {js|<p>OCaml 2017 will open with an invited talk by three frequent
contributors that recently became maintainers of the OCaml
implementation: David Allsopp
(<a href="https://www.youtube.com/watch?v=10OQHsnyg64&amp;index=2&amp;list=TLGGpj_CrU7rr7MxMjAxMjAxOA">video</a>),
Florian Angeletti
(<a href="https://www.youtube.com/watch?v=HOfdGDSypP4&amp;list=TLGGpj_CrU7rr7MxMjAxMjAxOA&amp;index=5">video</a>),
and Sébastien Hinderer
(<a href="https://www.youtube.com/watch?v=SvnyQWZkHS8&amp;list=TLGGpj_CrU7rr7MxMjAxMjAxOA&amp;index=1">video</a>).</p>
<p>Due to the high number of high-quality submissions, we had to have
more posters than in previous editions to fit a one-day
schedule.</p>
<h2>Call for presentations (past)</h2>
<h3>Scope</h3>
<p>Presentations and discussions will focus on the OCaml
programming language and its community. We aim to solicit talks
on all aspects related to improving the use or development of
the language and its programming environment, including, for
example (but not limited to):</p>
<ul>
<li>
<p>compiler developments, new backends, runtime and architectures</p>
</li>
<li>
<p>practical type system improvements, such as (but not
limited to) GADTs, first-class modules, generic programming,
or dependent types</p>
</li>
<li>
<p>new library or application releases, and their design
rationales</p>
</li>
<li>
<p>tools and infrastructure services, and their enhancements</p>
</li>
<li>
<p>prominent industrial or experimental uses of OCaml, or
deployments in unusual situations.</p>
</li>
</ul>
<h3>Presentations</h3>
<p>It will be an informal meeting with no formal proceedings. The
presentation material will be available online from the workshop
homepage. The presentations may be recorded, and made available
at a later time.</p>
<p>The main presentation format is a workshop talk, traditionally
around 20 minutes in length, plus question time, but we also
have a poster session during the workshop -- this allows to
present more diverse work, and gives time for discussion. The
program committee will decide which presentations should be
delivered as posters or talks.</p>
<h3>Submission</h3>
<p>To submit a presentation, please register a description of the
talk (about 2 pages long) at <a href="https://icfp-ocaml17.hotcrp.com/">https://icfp-ocaml17.hotcrp.com/</a>
providing a clear statement of what will be provided by the
presentation: the problems that are addressed, the solutions or
methods that are proposed.</p>
<p>LaTeX-produced PDFs are a common and welcome submission
format. For accessibility purposes, we ask PDF submitters to
also provide the sources of their submission in a textual
format, such as .tex sources. Reviewers may read either the
submitted PDF or the text version.</p>
<h3>ML family workshop and post-proceedings</h3>
<p>The ML family workshop, held on the previous day, deals with
general issues of the ML-style programming and type systems,
focuses on more research-oriented work that is less specific to
a language in particular (OCaml). There is an overlap between
the two workshops, and we have occasionally transferred
presentations from one to the other in the past. The authors who
feel their submission fits both workshops are encouraged to
mention it at submission time and/or contact the Program Chairs.</p>
<p>We are planning to publish combined post-proceedings and to
invite interested authors of selected presentations to expand
their abstracts for inclusion.</p>
<h3>Questions and contact</h3>
<p>Please send any questions to the chair:
<code>Gabriel Scherer &lt;gabriel.scherer@gmail.com&gt;</code></p>
|js}
  };
 
  { title = {js|OCaml Users and Developers Workshop 2016|js}
  ; slug = {js|ocaml-users-and-developers-workshop-2016|js}
  ; location = {js|Nara, Japan|js}
  ; date = {js|2016-09-08|js}
  ; important_dates = 
 [
  { date = {js|2016-06-20|js};
    info = {js|Talk proposal submission deadline|js};
  };
  
  { date = {js|2016-07-18|js};
    info = {js|Author notification|js};
  };
  
  { date = {js|2016-09-23|js};
    info = {js|OCaml workshop|js};
  }]
  ; presentations = 
 [
  { title = {js|Conex - establishing trust into data repositories|js};
    authors = 
  ["Hannes Mehnert"; "Louis Gesbert"];
    link = None;
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Generic Programming in OCaml|js};
    authors = ["Florent Balestrieri";
                                                                    "Michel Mauny"];
    link = None;
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Improving the OCaml Web Stack: Motivations and Progress|js};
    authors = 
  ["Spiridon Eliopoulos"];
    link = None;
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Learn OCaml: An Online Learning Center for OCaml|js};
    authors = 
  ["Benjamin Canou"; "Grégoire Henry"; "Çagdas Bozman";
   "Fabrice Le Fessant"];
    link = None;
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Lock-free programming for the masses|js};
    authors = 
  ["Kc Sivaramakrishnan"; "Theo Laurent"];
    link = None;
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|OCaml inside: a drop-in replacement for libtls|js};
    authors = 
  ["Enguerrand Decorne"; "Jeremy Yallop"; "David Kaloper Meršinjak"];
    link = None;
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|OPAM-builder: Continuous Monitoring of OPAM Repositories|js};
    authors = 
  ["Fabrice Le Fessant"];
    link = None;
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Semantics of the Lambda intermediate language|js};
    authors = 
  ["Pierre Chambart"];
    link = None;
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Statistically profiling memory in OCaml|js};
    authors = 
  ["Jacques-Henri Jourdan"];
    link = None;
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Sundials/ML: interfacing with numerical solvers|js};
    authors = 
  ["Timothy Bourke"; "Jun Inoue"; "Marc Pouzet"];
    link = None;
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|The State of the OCaml Platform: September 2016|js};
    authors = 
  ["Louis Gesbert, on behalf of the OCaml Platform team"];
    link = None;
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Who's got your Mail? Mr. Mime|js};
    authors = ["Romain Calascibetta"];
    link = None;
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Inuit library: from printf to interactive user-interfaces|js};
    authors = 
  ["Frédéric Bour"];
    link = None;
    video = None;
    slides = None;
    poster = Some true;
    additional_links = None;
  };
  
  { title = {js|ocp-lint, A Plugin-based Style-Checker with Semantic Patches|js};
    authors = 
  ["Çagdas Bozman"; "Théophane Hufschmitt"; "Michael Laporte";
   "Fabrice Le Fessant"];
    link = None;
    video = None;
    slides = None;
    poster = Some true;
    additional_links = None;
  };
  
  { title = {js|Partial evaluation and metaprogramming|js};
    authors = 
  ["Pierre Chambart"];
    link = None;
    video = None;
    slides = None;
    poster = Some true;
    additional_links = None;
  }]
  ; program_committee = 
 [
  { name = {js|Kenichi Asai|js};
    role = None;
    affiliation = Some {js|Ochanomizu University, Japan|js};
    picture = None;
  };
  
  { name = {js|Oleg Kiselyov|js};
    role = None;
    affiliation = Some {js|Tohoku University, Japan|js};
    picture = None;
  };
  
  { name = {js|Igor Pikovets|js};
    role = None;
    affiliation = Some {js|Ahrefs Research, USA|js};
    picture = None;
  };
  
  { name = {js|Mindy Preston|js};
    role = None;
    affiliation = Some {js|Docker, UK|js};
    picture = None;
  };
  
  { name = {js|Gabriel Scherer|js};
    role = None;
    affiliation = Some {js|Northeastern University, USA|js};
    picture = None;
  };
  
  { name = {js|Mark Shinwell|js};
    role = None;
    affiliation = Some {js|Jane Street Europe, UK (chair)|js};
    picture = None;
  };
  
  { name = {js|KC Sivaramakrishnan|js};
    role = None;
    affiliation = Some {js|University of Cambridge, UK|js};
    picture = None;
  };
  
  { name = {js|Jerome Vouillon|js};
    role = None;
    affiliation = Some {js|PPS, France|js};
    picture = None;
  };
  
  { name = {js|Jordan Walke|js};
    role = None;
    affiliation = Some {js|Facebook, USA|js};
    picture = None;
  }]
  ; organising_committee = 
 [
  { name = {js|Mark Shinwell|js};
    role = None;
    affiliation = Some {js|Jane Street Europe, UK (chair)|js};
    picture = None;
  }]
  ; body_md = {js|

### Scope

Presentations and discussions will focus on the OCaml
programming language and its community. We aim to solicit talks
on all aspects related to improving the use or development of
the language and its programming environment, including, for
example (but not limited to):

- compiler developments, new backends, runtime and architectures

- practical type system improvements, such as (but not
  limited to) GADTs, first-class modules, generic programming,
  or dependent types

- new library or application releases, and their design
  rationales

- tools and infrastructure services, and their enhancements

- prominent industrial or experimental uses of OCaml, or
  deployments in unusual situations.

### Presentations

It will be an informal meeting with no formal proceedings. The
presentation material will be available online from the workshop
homepage. The presentations may be recorded, and made available
at a later time.

The main presentation format is a workshop talk, traditionally
around 20 minutes in length, plus question time, but we also
have a poster session during the workshop -- this allows to
present more diverse work, and gives time for discussion. The
program committee will decide which presentations should be
delivered as posters or talks.

### Submission

To submit a presentation, please register a description of the
talk (about 2 pages long) at <https://icfp-ocaml17.hotcrp.com/>
providing a clear statement of what will be provided by the
presentation: the problems that are addressed, the solutions or
methods that are proposed. If you wish to perform a demo or require any special setup, we will do our best to accommodate you.

LaTeX-produced PDFs are a common and welcome submission
format. For accessibility purposes, we ask PDF submitters to
also provide the sources of their submission in a textual
format, such as .tex sources. Reviewers may read either the
submitted PDF or the text version.

### ML family workshop and post-proceedings

The ML family workshop, held on the previous day, deals with general issues of the ML-style programming and  poster systems, and is seen as more research-oriented. Yet there is an overlap with the OCaml workshop, which we are keen to explore, for instance by having a common session. The authors who feel their submission fits both workshops are encouraged to mention it at submission time and/or contact the Program Chairs.

There may be a combined post-conference proceedings of selected papers from the two workshops.


### Questions and contact

Please send any questions to the chair:
mshinwell -at- janestreet.com|js}
  ; toc_html = {js|<ul>
<li><ul>
<li><ul>
<li>Scope
</li>
<li>Presentations
</li>
<li>Submission
</li>
<li>ML family workshop and post-proceedings
</li>
<li>Questions and contact
</li>
</ul>
</li>
</ul>
</li>
</ul>
|js}
  ; body_html = {js|<h3>Scope</h3>
<p>Presentations and discussions will focus on the OCaml
programming language and its community. We aim to solicit talks
on all aspects related to improving the use or development of
the language and its programming environment, including, for
example (but not limited to):</p>
<ul>
<li>
<p>compiler developments, new backends, runtime and architectures</p>
</li>
<li>
<p>practical type system improvements, such as (but not
limited to) GADTs, first-class modules, generic programming,
or dependent types</p>
</li>
<li>
<p>new library or application releases, and their design
rationales</p>
</li>
<li>
<p>tools and infrastructure services, and their enhancements</p>
</li>
<li>
<p>prominent industrial or experimental uses of OCaml, or
deployments in unusual situations.</p>
</li>
</ul>
<h3>Presentations</h3>
<p>It will be an informal meeting with no formal proceedings. The
presentation material will be available online from the workshop
homepage. The presentations may be recorded, and made available
at a later time.</p>
<p>The main presentation format is a workshop talk, traditionally
around 20 minutes in length, plus question time, but we also
have a poster session during the workshop -- this allows to
present more diverse work, and gives time for discussion. The
program committee will decide which presentations should be
delivered as posters or talks.</p>
<h3>Submission</h3>
<p>To submit a presentation, please register a description of the
talk (about 2 pages long) at <a href="https://icfp-ocaml17.hotcrp.com/">https://icfp-ocaml17.hotcrp.com/</a>
providing a clear statement of what will be provided by the
presentation: the problems that are addressed, the solutions or
methods that are proposed. If you wish to perform a demo or require any special setup, we will do our best to accommodate you.</p>
<p>LaTeX-produced PDFs are a common and welcome submission
format. For accessibility purposes, we ask PDF submitters to
also provide the sources of their submission in a textual
format, such as .tex sources. Reviewers may read either the
submitted PDF or the text version.</p>
<h3>ML family workshop and post-proceedings</h3>
<p>The ML family workshop, held on the previous day, deals with general issues of the ML-style programming and  poster systems, and is seen as more research-oriented. Yet there is an overlap with the OCaml workshop, which we are keen to explore, for instance by having a common session. The authors who feel their submission fits both workshops are encouraged to mention it at submission time and/or contact the Program Chairs.</p>
<p>There may be a combined post-conference proceedings of selected papers from the two workshops.</p>
<h3>Questions and contact</h3>
<p>Please send any questions to the chair:
mshinwell -at- janestreet.com</p>
|js}
  };
 
  { title = {js|OCaml Users and Developers Workshop 2015|js}
  ; slug = {js|ocaml-users-and-developers-workshop-2015|js}
  ; location = {js|Vancouver, British Columbia, Canada|js}
  ; date = {js|2015-09-08|js}
  ; important_dates = 
 [
  { date = {js|2015-09-19|js};
    info = {js|Videos of the talks are online|js};
  };
  
  { date = {js|2015-07-31|js};
    info = {js|programme and call for participation|js};
  }]
  ; presentations = 
 [
  { title = {js|Towards A Debugger for Native-Code OCaml|js};
    authors = 
  ["Fabrice Le Fessant"; "Pierre Chambart"];
    link = Some {js|https://www.youtube.com/watch?v=VJJBSE5DzkQ&list=PLnqUlCo055hU46uoONmhYGUbYAK27Y6rS&index=2|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Operf: Benchmarking the OCaml Compiler|js};
    authors = 
  ["Pierre Chambart"; "Fabrice Le Fessant"; "Vincent Bernardoff"];
    link = Some {js|https://www.youtube.com/watch?v=U5hWHTBIRh0&index=2&list=PLnqUlCo055hU46uoONmhYGUbYAK27Y6rS|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Core.Time_stamp_counter: A fast high resolution time source|js};
    authors = 
  ["Roshan James"; "Christopher Hardin"];
    link = Some {js|https://www.youtube.com/watch?v=pEO1GgO-D3I&index=3&list=PLnqUlCo055hU46uoONmhYGUbYAK27Y6rS|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Specialization of Generic Array Accesses After Inlining|js};
    authors = 
  ["Ryohei Tokuda"; "Eijiro Sumii"; "Akinori Abe"];
    link = Some {js|https://www.youtube.com/watch?v=CAHAQLEtklM&index=4&list=PLnqUlCo055hU46uoONmhYGUbYAK27Y6rS|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Inline Assembly in OCaml|js};
    authors = ["Vladimir Brankov"];
    link = Some {js|https://www.youtube.com/watch?v=9BklvtQjZzY&index=5&list=PLnqUlCo055hU46uoONmhYGUbYAK27Y6rS|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|The State of OCaml (invited talk)|js};
    authors = 
  ["Xavier Leroy"];
    link = Some {js|https://www.youtube.com/watch?v=dEUMNuE4rxc&index=7&list=PLnqUlCo055hU46uoONmhYGUbYAK27Y6rS|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|The State of the OCaml Platform: September 2015|js};
    authors = 
  ["Anil Madhavapeddy"; "Amir Chaudhry"; "Thomas Gazagnaire";
   "Jeremy Yallop"; "David Sheets"];
    link = Some {js|https://www.youtube.com/watch?v=dEUMNuE4rxc&index=7&list=PLnqUlCo055hU46uoONmhYGUbYAK27Y6rS|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Modular macros|js};
    authors = ["Jeremy Yallop";
                                                      "Leo White"];
    link = None;
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Typeful PPX and Value Implicits|js};
    authors = 
  ["Jun Furuse"];
    link = Some {js|https://www.youtube.com/watch?v=QMh7Kz8VOMU&index=8&list=PLnqUlCo055hU46uoONmhYGUbYAK27Y6rS|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Global Semantic Analysis on OCaml programs|js};
    authors = 
  ["Thomas Blanc"; "Pierre Chambart"; "Michel Mauny"; "Fabrice Le Fessant"];
    link = Some {js|https://www.youtube.com/watch?v=wkaLd4wWZdo&index=9&list=PLnqUlCo055hU46uoONmhYGUbYAK27Y6rS|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Effective Concurrency through Algebraic Effects|js};
    authors = 
  ["Stephen Dolan"; "Leo White"; "Kc Sivaramakrishnan"; "Jeremy Yallop";
   "Anil Madhavapeddy"];
    link = Some {js|https://www.youtube.com/watch?v=jZB8CZRRuEo&index=10&list=PLnqUlCo055hU46uoONmhYGUbYAK27Y6rS|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|A review of the growth of the OCaml community|js};
    authors = 
  ["Amir Chaudhry"];
    link = Some {js|https://www.youtube.com/watch?v=L4bRNN-HEIU&index=11&list=PLnqUlCo055hU46uoONmhYGUbYAK27Y6rS|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Persistent Networking with Irmin and MirageOS|js};
    authors = 
  ["Mindy Preston"; "Magnus Skjegstad"; "Thomas Gazagnaire";
   "Richard Mortier"; "Anil Madhavapeddy"];
    link = Some {js|https://www.youtube.com/watch?v=nUJYGFJDVVo&index=12&list=PLnqUlCo055hU46uoONmhYGUbYAK27Y6rS|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Ketrew and Biokepi|js};
    authors = ["Sebastien Mondet"];
    link = Some {js|https://www.youtube.com/watch?v=ef2CFHLDelI&index=13&list=PLnqUlCo055hU46uoONmhYGUbYAK27Y6rS|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Four years of OCaml in production|js};
    authors = 
  ["Anders Fugmann"; "Jonas B. Jensen"; "Mads Hartmann Jensen"];
    link = None;
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  }]
  ; program_committee = 
 [
  { name = {js|Ashish AGARWAL|js};
    role = None;
    affiliation = Some {js|Solvuu, USA|js};
    picture = None;
  };
  
  { name = {js|Sandrine BLAZY|js};
    role = None;
    affiliation = Some {js|U. Rennes 1, France|js};
    picture = None;
  };
  
  { name = {js|Cristiano CALCAGNO|js};
    role = None;
    affiliation = Some {js|Facebook, USA|js};
    picture = None;
  };
  
  { name = {js|Emmanuel CHAILLOUX|js};
    role = None;
    affiliation = Some {js|U. Paris 6, France|js};
    picture = None;
  };
  
  { name = {js|Pierre CHAMBART|js};
    role = None;
    affiliation = Some {js|OCamlPro, France|js};
    picture = None;
  };
  
  { name = {js|Damien DOLIGEZ|js};
    role = None;
    affiliation = Some {js|Jane Street, USA and Inria, France (chair)|js};
    picture = None;
  };
  
  { name = {js|Martin JAMBON|js};
    role = None;
    affiliation = Some {js|Esper, USA|js};
    picture = None;
  };
  
  { name = {js|Keigo IMAI|js};
    role = None;
    affiliation = Some {js|Kyoto University, Japan|js};
    picture = None;
  };
  
  { name = {js|Julien VERLAGUET|js};
    role = None;
    affiliation = Some {js|Facebook, USA|js};
    picture = None;
  };
  
  { name = {js|Markus WEISSMAN|js};
    role = None;
    affiliation = Some {js|TU. Muenchen, Germany|js};
    picture = None;
  };
  
  { name = {js|Jeremy YALLOP|js};
    role = None;
    affiliation = Some {js|OCaml Labs, UK|js};
    picture = None;
  }]
  ; organising_committee = 
 [
  { name = {js|Mark Shinwell|js};
    role = None;
    affiliation = Some {js|Jane Street Europe, UK (chair)|js};
    picture = None;
  }]
  ; body_md = {js|


## Call for presentations (past)

### Scope

Discussions will focus on the practical aspects of OCaml programming and the nitty gritty of the tool-chain and upcoming improvements and changes. Thus, we aim to solicit talks on all aspects related to improving the use or development of the language and of its programming environment, including, for example:

- compiler developments, new backends, runtime and architectures

- practical type system improvements, such as (but not
  limited to) GADTs, first-class modules, generic programming,
  or dependent types

- new library or application releases, and their design
  rationales

- tools and infrastructure services, and their enhancements

- prominent industrial or experimental uses of OCaml, or
  deployments in unusual situations.

### Submission

It will be an informal meeting, with an online scribe report of the meeting, but no formal proceedings. Slides of presentations will be available online from the workshop homepage. The presentations will likely be recorded, and made available at a later time.

To submit a talk, please register a description of the talk (about 2 pages long) at https://easychair.org/conferences/?conf=ocaml2015, providing a clear statement of what will be brought by the talk: the problems that are addressed, the technical solutions or methods that are proposed. If you wish to perform a demo or require any special setup, we will do our best to accommodate you.

### ML family workshop and post-proceedings

The ML family workshop, held on the previous day, deals with general issues of the ML-style programming and type systems, and is seen as more research-oriented. Yet there is an overlap with the OCaml workshop, which we are keen to explore, for instance by having a common session. The authors who feel their submission fits both workshops are encouraged to mention it at submission time and/or contact the Program Chairs.


### Questions and contact

If you have any questions, please e-mail: Damien Doligez <ocaml2015 AT easychair DOT org>|js}
  ; toc_html = {js|<ul>
<li><ul>
<li>Call for presentations (past)
<ul>
<li>Scope
</li>
<li>Submission
</li>
<li>ML family workshop and post-proceedings
</li>
<li>Questions and contact
</li>
</ul>
</li>
</ul>
</li>
</ul>
|js}
  ; body_html = {js|<h2>Call for presentations (past)</h2>
<h3>Scope</h3>
<p>Discussions will focus on the practical aspects of OCaml programming and the nitty gritty of the tool-chain and upcoming improvements and changes. Thus, we aim to solicit talks on all aspects related to improving the use or development of the language and of its programming environment, including, for example:</p>
<ul>
<li>
<p>compiler developments, new backends, runtime and architectures</p>
</li>
<li>
<p>practical type system improvements, such as (but not
limited to) GADTs, first-class modules, generic programming,
or dependent types</p>
</li>
<li>
<p>new library or application releases, and their design
rationales</p>
</li>
<li>
<p>tools and infrastructure services, and their enhancements</p>
</li>
<li>
<p>prominent industrial or experimental uses of OCaml, or
deployments in unusual situations.</p>
</li>
</ul>
<h3>Submission</h3>
<p>It will be an informal meeting, with an online scribe report of the meeting, but no formal proceedings. Slides of presentations will be available online from the workshop homepage. The presentations will likely be recorded, and made available at a later time.</p>
<p>To submit a talk, please register a description of the talk (about 2 pages long) at https://easychair.org/conferences/?conf=ocaml2015, providing a clear statement of what will be brought by the talk: the problems that are addressed, the technical solutions or methods that are proposed. If you wish to perform a demo or require any special setup, we will do our best to accommodate you.</p>
<h3>ML family workshop and post-proceedings</h3>
<p>The ML family workshop, held on the previous day, deals with general issues of the ML-style programming and type systems, and is seen as more research-oriented. Yet there is an overlap with the OCaml workshop, which we are keen to explore, for instance by having a common session. The authors who feel their submission fits both workshops are encouraged to mention it at submission time and/or contact the Program Chairs.</p>
<h3>Questions and contact</h3>
<p>If you have any questions, please e-mail: Damien Doligez <ocaml2015 AT easychair DOT org></p>
|js}
  };
 
  { title = {js|OCaml Users and Developers Workshop 2014|js}
  ; slug = {js|ocaml-users-and-developers-workshop-2014|js}
  ; location = {js|Gothenburg, Sweden|js}
  ; date = {js|2014-09-05|js}
  ; important_dates = 
 [
  { date = {js|2014-09-09|js};
    info = {js|Add links to slides|js};
  };
  
  { date = {js|2014-09-07|js};
    info = {js|Links to videos of the talks added to the program|js};
  };
  
  { date = {js|2014-08-24|js};
    info = {js|Add abstracts to the program|js};
  };
  
  { date = {js|2014-07-04|js};
    info = {js|preliminary program|js};
  };
  
  { date = {js|2014-05-20|js};
    info = {js|Extended deadline is Friday May 23, 23:59 UTC-11|js};
  };
  
  { date = {js|2014-05-16|js};
    info = {js|Precise deadline is May 19, 23:59 UTC-11 (i.e. May 20 10:59 UTC)|js};
  };
  
  { date = {js|2014-05-07|js};
    info = {js|Sent the last CFP. Deadline is May 19|js};
  };
  
  { date = {js|2014-04-24|js};
    info = {js|The submission site is now open|js};
  };
  
  { date = {js|2014-02-10|js};
    info = {js|workshop announcement|js};
  };
  
  { date = {js|2014-09-05|js};
    info = {js|Workshop|js};
  }]
  ; presentations = 
 [
  { title = {js|Multicore OCaml|js};
    authors = ["Stephen Dolan";
                                                       "Leo White";
                                                       "Anil Madhavapeddy"];
    link = Some {js|https://www.youtube.com/watch?v=FzmQTC_X5R4&list=UUP9g4dLR7xt6KzCYntNqYcw|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Ephemerons meet OCaml GC|js};
    authors = ["François Bobot"];
    link = Some {js|https://www.youtube.com/watch?v=2fzjoxLMOXA&list=UUP9g4dLR7xt6KzCYntNqYcw|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Introduction to 0install|js};
    authors = ["Thomas Leonard"];
    link = Some {js|https://www.youtube.com/watch?v=dYRT6z0NGII&list=UUP9g4dLR7xt6KzCYntNqYcw|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Transport Layer Security purely in OCaml|js};
    authors = 
  ["Hannes Mehnert"; "David Kaloper Meršinjak"];
    link = Some {js|https://www.youtube.com/watch?v=hJk2lQXbkNk&list=UUP9g4dLR7xt6KzCYntNqYcw|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|OCamlOScope: a New OCaml API Search|js};
    authors = 
  ["Jun Furuse"];
    link = Some {js|https://www.youtube.com/watch?v=zRwXIGs42iY&list=UUP9g4dLR7xt6KzCYntNqYcw|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|The State of OCaml (invited)|js};
    authors = ["Xavier Leroy"];
    link = Some {js|https://www.youtube.com/watch?v=DMzZy1bqj6Q&list=UUP9g4dLR7xt6KzCYntNqYcw|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|The OCaml Platform v1.0|js};
    authors = ["Anil Madhavapeddy";
                                                               "Amir Chaudhry";
                                                               "Jeremie Diminio";
                                                               "Thomas Gazagnaire";
                                                               "Louis Gesbert";
                                                               "Thomas Leonard";
                                                               "David Sheets";
                                                               "Mark Shinwell";
                                                               "Leo White";
                                                               "Jeremy Yallop"];
    link = Some {js|https://www.youtube.com/watch?v=jxhtpQ5nJHg&list=UUP9g4dLR7xt6KzCYntNqYcw|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|A Proposal for Non-Intrusive Namespaces in OCaml|js};
    authors = 
  ["Pierrick Couderc"; "Fabrice Le Fessant"; "Benjamin Canou";
   "Pierre Chambart"];
    link = Some {js|https://www.youtube.com/watch?v=ltkBqVMVQeo&list=UUP9g4dLR7xt6KzCYntNqYcw|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Improving Type Error Messages in OCaml|js};
    authors = 
  ["Arthur Charguéraud"];
    link = Some {js|https://www.youtube.com/watch?v=V_ipQZeBueg&list=UUP9g4dLR7xt6KzCYntNqYcw|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Github Pull Requests for OCaml development: a field report|js};
    authors = 
  ["Gabriel Scherer"];
    link = Some {js|https://www.youtube.com/watch?v=PGgAsnxlt4U&list=UUP9g4dLR7xt6KzCYntNqYcw|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Irminsule; a branch-consistent distributed library database|js};
    authors = 
  ["Thomas Gazagnaire"; "Amir Chaudhry"; "Anil Madhavapeddy";
   "Richard Mortier"; "David Scott"; "David Sheets"; "Gregory Tsipenyuk";
   "Jon Crowcroft"];
    link = Some {js|https://www.youtube.com/watch?v=_RzF1mAHUAA&list=UUP9g4dLR7xt6KzCYntNqYcw|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|A Case for Multi-Switch Constraints in OPAM|js};
    authors = 
  ["Fabrice Le Fessant"];
    link = Some {js|https://www.youtube.com/watch?v=uMCnThFtDA4&list=UUP9g4dLR7xt6KzCYntNqYcw|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|LibreS3: design, challenges, and steps toward reusable libraries|js};
    authors = 
  ["Edwin Török"];
    link = Some {js|https://www.youtube.com/watch?v=vedtdREomTw&list=UUP9g4dLR7xt6KzCYntNqYcw|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Nullable Type Inference|js};
    authors = ["Michel Mauny";
                                                               "Benoit Vaugon"];
    link = Some {js|https://www.youtube.com/watch?v=0xOQTv88v5o&list=UUP9g4dLR7xt6KzCYntNqYcw|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Coq of OCaml|js};
    authors = ["Guillaume Claret"];
    link = Some {js|https://www.youtube.com/watch?v=2t9-ZtYTu1Q&list=UUP9g4dLR7xt6KzCYntNqYcw|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|High Performance Client-Side Web Programming with SPOC and Js of ocaml|js};
    authors = 
  ["Mathias Bourgoin"; "Emmmanuel Chailloux"];
    link = Some {js|https://www.youtube.com/watch?v=xRw2m5V1avI&list=UUP9g4dLR7xt6KzCYntNqYcw|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Using Preferences to Tame your Package Manager|js};
    authors = 
  ["Roberto Di Cosmo"; "Pietro Abate"; "Stefano Zacchiroli";
   "Fabrice Le Fessant"; "Louis Gesbert"];
    link = Some {js|https://www.youtube.com/watch?v=E-gtFnbHcv0&list=UUP9g4dLR7xt6KzCYntNqYcw|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Simple, efficient, sound-and-complete combinator parsing for all context-free grammars, using an oracle|js};
    authors = 
  ["Tom Ridge"];
    link = Some {js|https://www.youtube.com/watch?v=qEqB755feLY&list=UUP9g4dLR7xt6KzCYntNqYcw|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  }]
  ; program_committee = 
 [
  { name = {js|Esther Baruk|js};
    role = None;
    affiliation = Some {js|LexiFi, France|js};
    picture = None;
  };
  
  { name = {js|Jacques Garrigue|js};
    role = None;
    affiliation = Some {js|Nagoya University, Japan (chair)|js};
    picture = None;
  };
  
  { name = {js|Oleg Kiselyov|js};
    role = None;
    affiliation = Some {js|Monterey, CA, USA|js};
    picture = None;
  };
  
  { name = {js|Pierre Letouzey|js};
    role = None;
    affiliation = Some {js|Universite Paris 7, France|js};
    picture = None;
  };
  
  { name = {js|Luc Maranget|js};
    role = None;
    affiliation = Some {js|INRIA Paris-Rocquencourt, France|js};
    picture = None;
  };
  
  { name = {js|Keisuke Nakano|js};
    role = None;
    affiliation = Some {js|University of Electro-Communications, Japan|js};
    picture = None;
  };
  
  { name = {js|Yoann Padioleau|js};
    role = None;
    affiliation = Some {js|Facebook, USA|js};
    picture = None;
  };
  
  { name = {js|Andreas Rossberg|js};
    role = None;
    affiliation = Some {js|Google, Germany|js};
    picture = None;
  };
  
  { name = {js|Julien Signoles|js};
    role = None;
    affiliation = Some {js|CEA LIST, France|js};
    picture = None;
  };
  
  { name = {js|Leo White|js};
    role = None;
    affiliation = Some {js|University of Cambridge, UK|js};
    picture = None;
  }]
  ; organising_committee = 
 []
  ; body_md = {js|


## Call for presentations (past)

### Scope

Presentations and discussions will focus on the OCaml
programming language and its community. We aim to solicit talks
on all aspects related to improving the use or development of
the language and its programming environment, including, for
example (but not limited to):

- compiler developments, new backends, runtime and architectures

- practical type system improvements, such as (but not
  limited to) GADTs, first-class modules, generic programming,
  or dependent types

- new library or application releases, and their design
  rationales

- tools and infrastructure services, and their enhancements

- prominent industrial or experimental uses of OCaml, or
  deployments in unusual situations.

### Presentations

It will be an informal meeting with no formal proceedings. The
presentation material will be available online from the workshop
homepage. The presentations may be recorded, and made available
at a later time.

The main presentation format is a workshop talk, traditionally
around 20 minutes in length, plus question time, but we also
have a poster session during the workshop -- this allows to
present more diverse work, and gives time for discussion. The
program committee will decide which presentations should be
delivered as posters or talks.

### Submission

To submit a presentation, please register a description of the
talk (about 2 pages long) at <https://icfp-ocaml17.hotcrp.com/>
providing a clear statement of what will be provided by the
presentation: the problems that are addressed, the solutions or
methods that are proposed. If you wish to perform a demo or require any special setup, we will do our best to accommodate you.

LaTeX-produced PDFs are a common and welcome submission
format. For accessibility purposes, we ask PDF submitters to
also provide the sources of their submission in a textual
format, such as .tex sources. Reviewers may read either the
submitted PDF or the text version.

### ML family workshop and post-proceedings

The ML family workshop, held on the previous day, deals with general issues of the ML-style programming and type systems, and is seen as more research-oriented. Yet there is an overlap with the OCaml workshop, which we are keen to explore, for instance by having a common session. The authors who feel their submission fits both workshops are encouraged to mention it at submission time and/or contact the Program Chairs.

As another form of cooperation, combined post-proceedings of selected papers from the two workshops will be published in the Electronic Proceedings in Theoretical Computer Science series. The Program Committees shall invite interested authors of selected presentations to expand their abstract for inclusion in the proceedings. The submissions would be reviewed according to the standards of the publication.

### Questions and contact

If you have any questions, please e-mail: Jacques Garrigue|js}
  ; toc_html = {js|<ul>
<li><ul>
<li>Call for presentations (past)
<ul>
<li>Scope
</li>
<li>Presentations
</li>
<li>Submission
</li>
<li>ML family workshop and post-proceedings
</li>
<li>Questions and contact
</li>
</ul>
</li>
</ul>
</li>
</ul>
|js}
  ; body_html = {js|<h2>Call for presentations (past)</h2>
<h3>Scope</h3>
<p>Presentations and discussions will focus on the OCaml
programming language and its community. We aim to solicit talks
on all aspects related to improving the use or development of
the language and its programming environment, including, for
example (but not limited to):</p>
<ul>
<li>
<p>compiler developments, new backends, runtime and architectures</p>
</li>
<li>
<p>practical type system improvements, such as (but not
limited to) GADTs, first-class modules, generic programming,
or dependent types</p>
</li>
<li>
<p>new library or application releases, and their design
rationales</p>
</li>
<li>
<p>tools and infrastructure services, and their enhancements</p>
</li>
<li>
<p>prominent industrial or experimental uses of OCaml, or
deployments in unusual situations.</p>
</li>
</ul>
<h3>Presentations</h3>
<p>It will be an informal meeting with no formal proceedings. The
presentation material will be available online from the workshop
homepage. The presentations may be recorded, and made available
at a later time.</p>
<p>The main presentation format is a workshop talk, traditionally
around 20 minutes in length, plus question time, but we also
have a poster session during the workshop -- this allows to
present more diverse work, and gives time for discussion. The
program committee will decide which presentations should be
delivered as posters or talks.</p>
<h3>Submission</h3>
<p>To submit a presentation, please register a description of the
talk (about 2 pages long) at <a href="https://icfp-ocaml17.hotcrp.com/">https://icfp-ocaml17.hotcrp.com/</a>
providing a clear statement of what will be provided by the
presentation: the problems that are addressed, the solutions or
methods that are proposed. If you wish to perform a demo or require any special setup, we will do our best to accommodate you.</p>
<p>LaTeX-produced PDFs are a common and welcome submission
format. For accessibility purposes, we ask PDF submitters to
also provide the sources of their submission in a textual
format, such as .tex sources. Reviewers may read either the
submitted PDF or the text version.</p>
<h3>ML family workshop and post-proceedings</h3>
<p>The ML family workshop, held on the previous day, deals with general issues of the ML-style programming and type systems, and is seen as more research-oriented. Yet there is an overlap with the OCaml workshop, which we are keen to explore, for instance by having a common session. The authors who feel their submission fits both workshops are encouraged to mention it at submission time and/or contact the Program Chairs.</p>
<p>As another form of cooperation, combined post-proceedings of selected papers from the two workshops will be published in the Electronic Proceedings in Theoretical Computer Science series. The Program Committees shall invite interested authors of selected presentations to expand their abstract for inclusion in the proceedings. The submissions would be reviewed according to the standards of the publication.</p>
<h3>Questions and contact</h3>
<p>If you have any questions, please e-mail: Jacques Garrigue</p>
|js}
  };
 
  { title = {js|OCaml Users and Developers Workshop 2013|js}
  ; slug = {js|ocaml-users-and-developers-workshop-2013|js}
  ; location = {js|Boston, Massachusetts, USA|js}
  ; date = {js|2013-09-24|js}
  ; important_dates = 
 [
  { date = {js|2013-06-18|js};
    info = {js|Extended deadline for submissions|js};
  };
  
  { date = {js|2013-07-07|js};
    info = {js|Notification to speakers|js};
  };
  
  { date = {js|2013-09-24|js};
    info = {js|Workshop|js};
  }]
  ; presentations = 
 [
  { title = {js|Accessing and using weather-related data in OCaml|js};
    authors = 
  ["Hezekiah Carty"];
    link = Some {js|https://github.com/ocaml/ocaml.org/blob/master/site/meetings/ocaml/2013/proposals/weather-related-data.pdf|js};
    video = None;
    slides = Some {js|https://github.com/ocaml/ocaml.org/blob/master/site/meetings/ocaml/2013/slides/guha.pdf|js};
    poster = None;
    additional_links = None;
  };
  
  { title = {js|The Frenetic Network Controller|js};
    authors = 
  ["Nate Foster"; "Arjun Guha"; "Frenetic Contributors"];
    link = Some {js|https://github.com/ocaml/ocaml.org/blob/master/site/meetings/ocaml/2013/proposals/frenetic.pdf|js};
    video = None;
    slides = Some {js|https://github.com/ocaml/ocaml.org/blob/master/site/meetings/ocaml/2013/slides/guha.pdf|js};
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Pfff: PHP Program analysis at Facebook|js};
    authors = 
  ["Yoann Padioleau"];
    link = Some {js|https://github.com/facebook/pfff/wiki/Main|js};
    video = None;
    slides = Some {js|https://github.com/ocaml/ocaml.org/blob/master/site/meetings/ocaml/2013/slides/padioleau.pdf|js};
    poster = None;
    additional_links = None;
  };
  
  { title = {js|The design of the wxOCaml library|js};
    authors = 
  ["Fabrice Le Fessant"];
    link = None;
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Goji: an Automated Tool for Building High Level OCaml-JavaScript Interfaces|js};
    authors = 
  ["Benjamin Canou"];
    link = Some {js|https://github.com/ocaml/ocaml.org/blob/master/site/meetings/ocaml/2013/proposals/wxocaml.pdf|js};
    video = None;
    slides = Some {js|https://github.com/ocaml/ocaml.org/blob/master/site/meetings/ocaml/2013/slides/lefessant.pdf|js};
    poster = None;
    additional_links = None;
  };
  
  { title = {js|ctypes: foreign calls in your native language|js};
    authors = 
  ["Jeremy Yallop"];
    link = Some {js|https://github.com/ocaml/ocaml.org/blob/master/site/meetings/ocaml/2013/proposals/ctypes.pdf|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|The State of OCaml|js};
    authors = ["Xavier Leroy"];
    link = None;
    video = None;
    slides = Some {js|https://github.com/ocaml/ocaml.org/blob/master/site/meetings/ocaml/2013/slides/leroy.pdf|js};
    poster = None;
    additional_links = None;
  };
  
  { title = {js|The OCaml Platform v0.1|js};
    authors = ["Anil Madhavapeddy";
                                                               "Amir Chaudhry";
                                                               "Thomas Gazagnaire";
                                                               "David Sheets";
                                                               "Philippe Wang";
                                                               "Leo White";
                                                               "Jeremy Yallop"];
    link = Some {js|https://github.com/ocaml/ocaml.org/blob/master/site/meetings/ocaml/2013/proposals/platform.pdf|js};
    video = None;
    slides = Some {js|https://github.com/ocaml/ocaml.org/blob/master/site/meetings/ocaml/2013/slides/madhavapeddy.pdf|js};
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Extensions points for OCaml|js};
    authors = ["Leo White"];
    link = None;
    video = None;
    slides = Some {js|https://github.com/ocaml/ocaml.org/blob/master/site/meetings/ocaml/2013/slides/white.pdf|js};
    poster = None;
    additional_links = None;
  };
  
  { title = {js|High-Performance GPGPU Programming with OCaml|js};
    authors = 
  ["Mathias Bourgoin"; "Emmmanuel Chailloux"; "Jean-Luc Lamotte"];
    link = Some {js|https://github.com/ocaml/ocaml.org/blob/master/site/meetings/ocaml/2013/proposals/gpgpu.pdf|js};
    video = None;
    slides = Some {js|https://github.com/ocaml/ocaml.org/blob/master/site/meetings/ocaml/2013/slides/bourgoin.pdf|js};
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Improving OCaml high level optimisations|js};
    authors = 
  ["Pierre Chambart"];
    link = Some {js|https://github.com/ocaml/ocaml.org/blob/master/site/meetings/ocaml/2013/proposals/optimizations.pdf|js};
    video = None;
    slides = Some {js|https://github.com/ocaml/ocaml.org/blob/master/site/meetings/ocaml/2013/slides/chambart.pdf|js};
    poster = None;
    additional_links = None;
  };
  
  { title = {js|A new implementation of OCaml formats based on GADTs|js};
    authors = 
  ["Benoît Vaugon"];
    link = Some {js|https://github.com/ocaml/ocaml.org/blob/master/site/meetings/ocaml/2013/proposals/formats-as-gadts.pdf https://github.com/ocaml/ocaml.org/blob/master/site/meetings/ocaml/2013/slides/vaugon.pdf|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Runtime types in OCaml|js};
    authors = ["Grégoire Henry";
                                                              "Jacques Garrigue"];
    link = Some {js|https://github.com/ocaml/ocaml.org/blob/master/site/meetings/ocaml/2013/proposals/runtime-types.pdf|js};
    video = None;
    slides = Some {js|https://github.com/ocaml/ocaml.org/blob/master/site/meetings/ocaml/2013/slides/henry.pdf|js};
    poster = None;
    additional_links = None;
  };
  
  { title = {js|On variance, injectivity, and abstraction|js};
    authors = 
  ["Jacques Garrigue"];
    link = Some {js|https://github.com/ocaml/ocaml.org/blob/master/site/meetings/ocaml/2013/proposals/injectivity.pdf|js};
    video = None;
    slides = Some {js|https://github.com/ocaml/ocaml.org/blob/master/site/meetings/ocaml/2013/slides/garrigue.pdf|js};
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Ocamlot: OCaml Online Testing|js};
    authors = ["David Sheets";
                                                                    "Anil Madhavapeddy";
                                                                    "Amir Chaudhry";
                                                                    "Thomas Gazagnaire"];
    link = Some {js|https://github.com/ocaml/ocaml.org/blob/master/site/meetings/ocaml/2013/proposals/ocamlot.pdf|js};
    video = None;
    slides = Some {js|https://github.com/ocaml/ocaml.org/blob/master/site/meetings/ocaml/2013/slides/sheets.pdf|js};
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Merlin, an assistant for editing OCaml code|js};
    authors = 
  ["Frédéric Bour"; "Thomas Refis"; "Simon Castellan"];
    link = Some {js|https://github.com/ocaml/ocaml.org/blob/master/site/meetings/ocaml/2013/proposals/merlin.pdf|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Profiling the Memory Usage of OCaml Applications without Changing their Behavior|js};
    authors = 
  ["Çagdas Bozman"; "Michel Mauny"; "Fabrice Le Fessant";
   "Thomas Gazagnaire"];
    link = Some {js|https://github.com/ocaml/ocaml.org/blob/master/site/meetings/ocaml/2013/proposals/profiling-memory.pdf|js};
    video = None;
    slides = Some {js|https://github.com/ocaml/ocaml.org/blob/master/site/meetings/ocaml/2013/slides/bozman.pdf|js};
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Core bench: micro-benchmarking for OCaml|js};
    authors = 
  ["Christopher Hardin"; "James Roshan"];
    link = Some {js|https://github.com/ocaml/ocaml.org/blob/master/site/meetings/ocaml/2013/proposals/core-bench.pdf|js};
    video = None;
    slides = Some {js|https://github.com/ocaml/ocaml.org/blob/master/site/meetings/ocaml/2013/slides/james.pdf|js};
    poster = None;
    additional_links = None;
  }]
  ; program_committee = 
 [
  { name = {js|Mark Shinwell|js};
    role = None;
    affiliation = Some {js|Jane Street Europe, UK|js};
    picture = None;
  };
  
  { name = {js|Damien Doligez|js};
    role = None;
    affiliation = Some {js|INRIA Paris-Rocquencourt, France|js};
    picture = None;
  };
  
  { name = {js|Jun Furuse|js};
    role = None;
    affiliation = Some {js|Standard Chartered Bank, Singapore|js};
    picture = None;
  };
  
  { name = {js|Jacques Le Normand|js};
    role = None;
    affiliation = Some {js|Google, USA|js};
    picture = None;
  };
  
  { name = {js|Michel Mauny|js};
    role = None;
    affiliation = Some {js|ENSTA-ParisTech, France (chair)|js};
    picture = None;
  };
  
  { name = {js|David Walker|js};
    role = None;
    affiliation = Some {js|Princeton University, USA|js};
    picture = None;
  };
  
  { name = {js|Jeremy Yallop|js};
    role = None;
    affiliation = Some {js|University of Cambridge, UK|js};
    picture = None;
  };
  
  { name = {js|Sarah Zennou|js};
    role = None;
    affiliation = Some {js|EADS IW, France|js};
    picture = None;
  }]
  ; organising_committee = 
 []
  ; body_md = {js|
### Call for Presentations

Please consider submitting a presentation, and/or join us in Boston! See here the call for presentations.

### Submission

If you have any questions, please e-mail:
Michel Mauny <michel.mauny AT ensta-paristech DOT fr>


|js}
  ; toc_html = {js|<ul>
<li><ul>
<li><ul>
<li>Call for Presentations
</li>
<li>Submission
</li>
</ul>
</li>
</ul>
</li>
</ul>
|js}
  ; body_html = {js|<h3>Call for Presentations</h3>
<p>Please consider submitting a presentation, and/or join us in Boston! See here the call for presentations.</p>
<h3>Submission</h3>
<p>If you have any questions, please e-mail:
Michel Mauny &lt;michel.mauny AT ensta-paristech DOT fr&gt;</p>
|js}
  };
 
  { title = {js|OCaml Users and Developers Workshop 2012|js}
  ; slug = {js|ocaml-users-and-developers-workshop-2012|js}
  ; location = {js|Copenhagen, Denmark|js}
  ; date = {js|2012-09-14|js}
  ; important_dates = 
 [
  { date = {js|2012-07-08|js};
    info = {js|Abstract Submission Deadline|js};
  };
  
  { date = {js|2012-07-06|js};
    info = {js|Notification to Speakers|js};
  };
  
  { date = {js|2012-08-09|js};
    info = {js|Early Registration Deadline|js};
  };
  
  { date = {js|2012-07-14|js};
    info = {js|Workshop Date|js};
  }]
  ; presentations = 
 [
  { title = {js|Welcome|js};
    authors = ["Didier Remy";
                                               "Anil Madhavapeddy"];
    link = None;
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Presenting Core|js};
    authors = ["Yaron Minsky"];
    link = Some {js|http://www.youtube.com/watch?v=qFfS6-XKp9A&feature=plcp|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Ocsigen/Eliom: The state of the art, and the prospects|js};
    authors = 
  ["Benedikt Becker"; "Vincent Balat"];
    link = Some {js|http://www.youtube.com/watch?v=kk_o1QV9tQc&feature=plcp|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Experiments in Generic Programming|js};
    authors = 
  ["Pierre Chambart"; "Grégoire Henry"];
    link = Some {js|http://www.youtube.com/watch?v=2EcucepyIyw&feature=plcp|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Async|js};
    authors = ["Mark Shinwell"; "David House"];
    link = Some {js|http://www.youtube.com/watch?v=XhNBp46CpOk&feature=plcp|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|OCamlCC -- Raising Low-Level Bytecode to High-Level C|js};
    authors = 
  ["Michel Mauny"; "Benoit Vaugon"];
    link = Some {js|http://www.youtube.com/watch?v=aHHKeWA88Xo&feature=plcp|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|The State of OCaml|js};
    authors = ["Xavier Leroy"];
    link = Some {js|http://www.youtube.com/watch?v=ANwpbkSxHZs&feature=plcp|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|OCamlPro: promoting OCaml use in industry|js};
    authors = 
  ["Fabrice le Fessant"];
    link = Some {js|http://www.youtube.com/watch?v=DXr8Lr3z7wY&feature=plcp|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Towards an OCaml Platform|js};
    authors = ["Yaron Minsky"];
    link = Some {js|http://www.youtube.com/watch?v=ZosM-KFOZ9s&feature=plcp|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|OPAM: an OCaml Package Manager|js};
    authors = 
  ["Frederic Tuong"; "Fabrice le Fessant"; "Thomas Gazagnaire"];
    link = Some {js|http://www.youtube.com/watch?v=ivLqeRZJTGs&feature=plcp|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|An LLVM Backend for OCaml|js};
    authors = ["Colin Benner"];
    link = Some {js|http://www.youtube.com/watch?v=wFsgHH297JE&feature=plcp|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|DragonKit: an extensible language oriented compiler|js};
    authors = 
  ["Wojciech Meyer"];
    link = None;
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Programming the Xen cloud using OCaml|js};
    authors = 
  ["David Scott"; "Richard Mortier"; "Anil Madhavapeddy"];
    link = Some {js|http://www.youtube.com/watch?v=dJlHBS7sP_c&feature=plcp|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Arakoon: a consistent distributed key value store|js};
    authors = 
  ["Romain Slootmaekers"; "Nicolas Trangez"];
    link = Some {js|http://www.youtube.com/watch?v=9PFXV9OAN-s&feature=plcp|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|gloc: Metaprogramming WebGL Shaders with OCaml|js};
    authors = 
  ["David Sheets"];
    link = Some {js|http://www.youtube.com/watch?v=ll9z1ULtgqo&feature=plcp|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Real-world debugging in OCaml|js};
    authors = ["Mark Shinwell"];
    link = Some {js|http://www.youtube.com/watch?v=NF2WpWnB-nk&feature=plcp|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|OCaml Companion Tools|js};
    authors = ["Xavier Clerc"];
    link = Some {js|http://www.youtube.com/watch?v=V5MLwkrLfs8&feature=plcp|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Study of OCaml programs' memory behavior|js};
    authors = 
  ["Çagdas Bozman"; "Thomas Gazagnaire"; "Fabrice Le Fessant";
   "Michel Mauny"];
    link = Some {js|http://www.youtube.com/watch?v=C2bZa6EYRyk&feature=plcp|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Implementing an interval computation library for OCaml|js};
    authors = 
  ["Jean-Marc Alliot"; "Charlie Vanaret"; "Jean-Baptiste Gotteland";
   "Nicolas Durand"; "David Gianazza"];
    link = Some {js|http://www.youtube.com/watch?v=Bn0xSTmzZLA&feature=plcp|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Automatic Analysis of Industrial Robot Programs|js};
    authors = 
  ["Markus Weißmann"];
    link = Some {js|http://www.youtube.com/watch?v=2bURV8fh_v8&feature=plcp|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Biocaml: The OCaml Bioinformatics Library|js};
    authors = 
  ["Ashish Agarwal"; "Sebastien Mondet"; "Philippe Veber";
   "Christophe Troestler"; "Francois Berenger"];
    link = Some {js|http://www.youtube.com/watch?v=rzrqcTWc2V8&feature=plcp|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  }]
  ; program_committee = 
 [
  { name = {js|Didier Remy (co-chair)|js};
    role = None;
    affiliation = None;
    picture = None;
  };
  
  { name = {js|Anil Madhavapeddy (co-chair)|js};
    role = None;
    affiliation = None;
    picture = None;
  };
  
  { name = {js|Alain Frisch|js};
    role = None;
    affiliation = None;
    picture = None;
  };
  
  { name = {js|Jacques Garrigue|js};
    role = None;
    affiliation = None;
    picture = None;
  };
  
  { name = {js|Richard Jones|js};
    role = None;
    affiliation = None;
    picture = None;
  };
  
  { name = {js|Thomas Gazagnaire|js};
    role = None;
    affiliation = None;
    picture = None;
  };
  
  { name = {js|Martin Jambon|js};
    role = None;
    affiliation = None;
    picture = None;
  }]
  ; organising_committee = 
 []
  ; body_md = {js|
### Scope

The OCaml Users and Developers Workshop will bring together industrial users of OCaml with academics and hackers who are working on extending the language, type system and tools. Discussion will focus on the practical aspects of OCaml programming and the nitty gritty of the tool-chain and upcoming improvements and changes. Thus, we aim to solicit talks on all aspects related to improving the use or development of the language, including, for example:

- compiler developments; new backends, runtime and architectures.

- practical type system improvements, such as (but not exhaustively) GADTs, first-class modules, generic programming, or dependent types.

- new library or application releases, and their design rationales.

- tool enhancements by commercial consultants.

- prominent industrial uses of OCaml, or deployments in unusual situations.

It will be an informal meeting, with an online scribe report of the meeting, but no formal proceedings for this year. Slides of presentations will be available online from the workshop homepage.

### Questions and contact

If you have any queries or suggestions for the workshop, please contact Didier Remy (first.last@inria.fr) or Anil Madhavapeddy (first.last@cl.cam.ac.uk).

There is also an ASCII version of this information available, suitable for dissemination on mailing lists. Please help spread the word about this meeting!

|js}
  ; toc_html = {js|<ul>
<li><ul>
<li><ul>
<li>Scope
</li>
<li>Questions and contact
</li>
</ul>
</li>
</ul>
</li>
</ul>
|js}
  ; body_html = {js|<h3>Scope</h3>
<p>The OCaml Users and Developers Workshop will bring together industrial users of OCaml with academics and hackers who are working on extending the language, type system and tools. Discussion will focus on the practical aspects of OCaml programming and the nitty gritty of the tool-chain and upcoming improvements and changes. Thus, we aim to solicit talks on all aspects related to improving the use or development of the language, including, for example:</p>
<ul>
<li>
<p>compiler developments; new backends, runtime and architectures.</p>
</li>
<li>
<p>practical type system improvements, such as (but not exhaustively) GADTs, first-class modules, generic programming, or dependent types.</p>
</li>
<li>
<p>new library or application releases, and their design rationales.</p>
</li>
<li>
<p>tool enhancements by commercial consultants.</p>
</li>
<li>
<p>prominent industrial uses of OCaml, or deployments in unusual situations.</p>
</li>
</ul>
<p>It will be an informal meeting, with an online scribe report of the meeting, but no formal proceedings for this year. Slides of presentations will be available online from the workshop homepage.</p>
<h3>Questions and contact</h3>
<p>If you have any queries or suggestions for the workshop, please contact Didier Remy (first.last@inria.fr) or Anil Madhavapeddy (first.last@cl.cam.ac.uk).</p>
<p>There is also an ASCII version of this information available, suitable for dissemination on mailing lists. Please help spread the word about this meeting!</p>
|js}
  };
 
  { title = {js|OCaml Users and Developers Workshop 2011|js}
  ; slug = {js|ocaml-users-and-developers-workshop-2011|js}
  ; location = {js|Paris, France|js}
  ; date = {js|2011-04-15|js}
  ; important_dates = 
 [
  { date = {js|2011-04-15|js};
    info = {js|Workshop Date|js};
  }]
  ; presentations = 
 [
  { title = {js|OCamlCore.org news and projects|js};
    authors = 
  ["Sylvain Le Gall"];
    link = None;
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Compiling Ocaml bytecode to Javascript|js};
    authors = 
  ["Jérôme Vouillon"];
    link = Some {js|https://youtu.be/rJNCUFZokNI|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|OCAPIC: programming PIC microcontrollers with Objective Caml|js};
    authors = 
  ["Benoît Vaugon"; "Philippe Wang"];
    link = Some {js|http://www.algo-prog.info/ocaml_for_pic/ https://youtu.be/ZLTWLrTCd4s|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Developing Frama-C Plug-ins in OCaml|js};
    authors = 
  ["Julien Signoles"];
    link = Some {js|https://youtu.be/TgaWYzHW33s|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Client/server Web applications with Eliom|js};
    authors = 
  ["Vincent Balat"];
    link = None;
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|MirageOS|js};
    authors = ["Anil Madhavapeddy"];
    link = Some {js|https://youtu.be/GEkxyA2FwW0|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Using OCaml to generate 198,278 lines of C|js};
    authors = 
  ["Richard Jones"];
    link = Some {js|https://youtu.be/FbgRsFpfHJI|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|OCaml annual report|js};
    authors = ["Xavier Leroy"];
    link = None;
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|JoCaml|js};
    authors = ["Luc Maranget"];
    link = Some {js|https://youtu.be/dQl0BUE1WGw|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|The Eternal Solution for Memoisation: Ephemerons|js};
    authors = 
  ["François Bobot"];
    link = Some {js|https://youtu.be/i8U3Y7C6eIs|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|OASIS-DB: a CPAN for OCaml|js};
    authors = ["Sylvain Le Gall"];
    link = Some {js|https://github.com/ocaml/oasis https://youtu.be/njkP5EZ8uAo|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
  
  { title = {js|Ideas for a Modern OCaml Web Portal|js};
    authors = 
  ["Ashish Agarwal"];
    link = Some {js|https://youtu.be/W7_wIjvg_is|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  }]
  ; program_committee = 
 []
  ; organising_committee = [
  { name = {js|Sylvain Le Gall|js};
    role = None;
    affiliation = None;
    picture = None;
  };
                                
  { name = {js|Dario Teixeira|js};
    role = None;
    affiliation = None;
    picture = None;
  };
                                
  { name = {js|Pierre Chambart (chambart AT crans.org)|js};
    role = None;
    affiliation = None;
    picture = None;
  };
                                
  { name = {js|Paolo Herms|js};
    role = None;
    affiliation = None;
    picture = None;
  }]
  ; body_md = {js|
This event will take place in Paris. The venue is in Telecom ParisTech (former ENST, the place of the first OCaml Meeting).

### Questions and contact

If you have any queries or suggestions for the workshop, please contact Didier Remy (first.last@inria.fr) or Anil Madhavapeddy (first.last@cl.cam.ac.uk).


|js}
  ; toc_html = {js|<ul>
<li><ul>
<li><ul>
<li>Questions and contact
</li>
</ul>
</li>
</ul>
</li>
</ul>
|js}
  ; body_html = {js|<p>This event will take place in Paris. The venue is in Telecom ParisTech (former ENST, the place of the first OCaml Meeting).</p>
<h3>Questions and contact</h3>
<p>If you have any queries or suggestions for the workshop, please contact Didier Remy (first.last@inria.fr) or Anil Madhavapeddy (first.last@cl.cam.ac.uk).</p>
|js}
  };
 
  { title = {js|OCaml Users and Developers Workshop 2010|js}
  ; slug = {js|ocaml-users-and-developers-workshop-2010|js}
  ; location = {js|Paris, France|js}
  ; date = {js|2010-04-23|js}
  ; important_dates = 
 []
  ; presentations = [
  { title = {js|Foreword|js};
    authors = 
                         ["Xavier Leroy"];
    link = Some {js|https://youtu.be/2_eVOy8w1tc|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
                         
  { title = {js|OCamlCore.org news and projects|js};
    authors = 
                         ["Sylvain Le Gall"];
    link = Some {js|https://youtu.be/jGkBLivoML0|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
                         
  { title = {js|Enforcing Type-Safe Linking using Inter-Package Relationships for OCaml Debian packages|js};
    authors = 
                         ["Stefano Zacchiroli"];
    link = Some {js|https://youtu.be/9WOyYrMz3F0|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
                         
  { title = {js|OASIS, a Cabal like system for OCaml|js};
    authors = 
                         ["Sylvain Le Gall"];
    link = Some {js|https://youtu.be/VHmMD2u9iRU|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
                         
  { title = {js|Cluster computing in Ocaml|js};
    authors = 
                         ["Gerd Stolpmann"];
    link = Some {js|https://youtu.be/XkBFZ1W89fs|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
                         
  { title = {js|Ocaml in a web startup|js};
    authors = 
                         ["Dario Teixeira"];
    link = Some {js|https://youtu.be/0r6Y-38lh1s|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
                         
  { title = {js|React, functional reactive programming for OCaml|js};
    authors = 
                         ["Daniel Bünzli"];
    link = Some {js|https://youtu.be/0-tVf9BFTMY|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
                         
  { title = {js|Ocamlviz|js};
    authors = 
                         ["Sylvain Conchon"; "Julien Robert";
                          "Guillaume Von Tokarski";
                          "Jean-Christophe Filliâtre"; "Fabrice Le Fessant"];
    link = Some {js|https://youtu.be/NOY5CyTteFc|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
                         
  { title = {js|OC4MC : Objective Caml for MultiCore|js};
    authors = 
                         ["Benjamin Canou"];
    link = Some {js|https://youtu.be/soOaUFzbXyQ|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
                         
  { title = {js|Cooperative Light-Weight Threads|js};
    authors = 
                         ["Jérémie Dimino"];
    link = Some {js|https://youtu.be/C7Z0HduWGx8|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
                         
  { title = {js|The collaborative rendering farm: a JoCaml-powered desktop grid|js};
    authors = 
                         ["William Le Ferrand"];
    link = Some {js|https://youtu.be/Iae81LS8sWY|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
                         
  { title = {js|OCaml in the clouds|js};
    authors = 
                         ["Anil Madhavapeddy"];
    link = None;
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  }]
  ; program_committee = 
 []
  ; organising_committee = []
  ; body_md = {js|
### Call for Presentations

Please consider submitting a presentation! See here the call for presentations.



|js}
  ; toc_html = {js|<ul>
<li><ul>
<li><ul>
<li>Call for Presentations
</li>
</ul>
</li>
</ul>
</li>
</ul>
|js}
  ; body_html = {js|<h3>Call for Presentations</h3>
<p>Please consider submitting a presentation! See here the call for presentations.</p>
|js}
  };
 
  { title = {js|OCaml Users and Developers Workshop 2009|js}
  ; slug = {js|ocaml-users-and-developers-workshop-2009|js}
  ; location = {js|Grenoble, France|js}
  ; date = {js|2009-09-23|js}
  ; important_dates = 
 []
  ; presentations = [
  { title = {js|OCamlCore.org news and projects|js};
    authors = 
                         ["Stefano Zacchiroli"; "Sylvain Le Gall"];
    link = Some {js|http://www.ocamlcore.org/|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
                         
  { title = {js|OCaml Batteries Included|js};
    authors = 
                         ["David Teller"];
    link = Some {js|http://batteries.forge.ocamlcore.org/|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
                         
  { title = {js|Cameleon/Chamo|js};
    authors = 
                         ["Maxence Guesdon"];
    link = Some {js|http://home.gna.org/cameleon/chamo.en.html|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
                         
  { title = {js|Delimited overloading|js};
    authors = 
                         ["Christophe Troestler"];
    link = Some {js|http://pa-do.forge.ocamlcore.org/|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
                         
  { title = {js|OCaml as fast as C!|js};
    authors = 
                         ["Sylvain Le Gall"];
    link = Some {js|https://github.com/ocaml/ocaml.org/blob/master/site/meetings/ocaml/2009/slides/OCamlAsFastAsC.pdf|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
                         
  { title = {js|VHDL symbolic simulation in OCaml|js};
    authors = 
                         ["Florent Ouchet"];
    link = None;
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
                         
  { title = {js|Parsing technology for OCaml: from stream matching to dypgen|js};
    authors = 
                         ["Christophe Raffalli"];
    link = Some {js|http://dypgen.free.fr/|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  }]
  ; program_committee = 
 []
  ; organising_committee = [
  { name = {js|Sylvain Le Gall|js};
    role = None;
    affiliation = None;
    picture = None;
  };
                                
  { name = {js|Alan Schmitt|js};
    role = None;
    affiliation = None;
    picture = None;
  };
                                
  { name = {js|Serge Leblanc|js};
    role = None;
    affiliation = None;
    picture = None;
  }]
  ; body_md = {js|
### Call for Presentations

Please consider submitting a presentation! See here the call for presentations.



|js}
  ; toc_html = {js|<ul>
<li><ul>
<li><ul>
<li>Call for Presentations
</li>
</ul>
</li>
</ul>
</li>
</ul>
|js}
  ; body_html = {js|<h3>Call for Presentations</h3>
<p>Please consider submitting a presentation! See here the call for presentations.</p>
|js}
  };
 
  { title = {js|OCaml Users and Developers Workshop 2008|js}
  ; slug = {js|ocaml-users-and-developers-workshop-2008|js}
  ; location = {js|Paris, France|js}
  ; date = {js|2008-01-26|js}
  ; important_dates = 
 []
  ; presentations = [
  { title = {js|The core Caml system: status report and challenges|js};
    authors = 
                         ["Xavier Leroy"];
    link = Some {js|https://www.youtube.com/watch?v=YdAcmMLwd_U|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
                         
  { title = {js|Ocsigen: Exploiting the full power of OCaml in Web Programming|js};
    authors = 
                         ["Vincent Balat"];
    link = Some {js|https://www.youtube.com/watch?v=WnGbGq4ETj0 http://www.ocsigen.org/|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
                         
  { title = {js|GODI|js};
    authors = ["Gerd Stolpmann"];
    link = Some {js|https://www.youtube.com/watch?v=SiF9CD5CK_k|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
                         
  { title = {js|ocamlbuild|js};
    authors = 
                         ["Nicolas Pouillard"];
    link = Some {js|https://www.youtube.com/watch?v=4HPlX6wdmTI|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
                         
  { title = {js|OCaml in Debian|js};
    authors = 
                         ["Sylvain Le Gall"];
    link = Some {js|https://www.youtube.com/watch?v=-kBprJFFfsc|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  };
                         
  { title = {js|OCaml on a JVM using OCaml-Java|js};
    authors = 
                         ["Xavier Clerc"];
    link = Some {js|https://www.youtube.com/watch?v=v0zBMVABYXo|js};
    video = None;
    slides = None;
    poster = None;
    additional_links = None;
  }]
  ; program_committee = 
 []
  ; organising_committee = [
  { name = {js|Sylvain Le Gall|js};
    role = None;
    affiliation = None;
    picture = None;
  };
                                
  { name = {js|Vincent Balat|js};
    role = None;
    affiliation = None;
    picture = None;
  };
                                
  { name = {js|Gabriel Kerneis|js};
    role = None;
    affiliation = None;
    picture = None;
  }]
  ; body_md = {js|
### Call for Presentations

Please consider submitting a presentation! See here the call for presentations.



|js}
  ; toc_html = {js|<ul>
<li><ul>
<li><ul>
<li>Call for Presentations
</li>
</ul>
</li>
</ul>
</li>
</ul>
|js}
  ; body_html = {js|<h3>Call for Presentations</h3>
<p>Please consider submitting a presentation! See here the call for presentations.</p>
|js}
  }]

