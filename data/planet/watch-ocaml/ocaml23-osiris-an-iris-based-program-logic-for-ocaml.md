---
title: '[OCaML''23] Osiris: an Iris-based program logic for OCaml'
description: "[OCaML'23] Osiris: an Iris-based program logic for OCaml Arnaud Daby-Seesaram,
  Fran\xE7ois Pottier, Arma\xEBl Gu\xE9neau Osiris is a project that aims to help
  OCaml developers verify their code using Separa..."
url: https://watch.ocaml.org/w/1Hfi9pjTo1hz1ej2WtVGCR
date: 2024-09-29T15:27:45-00:00
preview_image: https://watch.ocaml.org/lazy-static/previews/01208c4e-6774-4946-9ff6-69e0375dc3c2.jpg
authors:
- Watch OCaml
source:
---

<p>[OCaML'23] Osiris: an Iris-based program logic for OCaml</p>
<p>Arnaud Daby-Seesaram, François Pottier, Armaël Guéneau</p>
<p>Osiris is a project that aims to help OCaml developers verify their code using Separation Logic. The project is still young: we currently only support a subset of the features of the OCaml language, including modules, mutual recursion, ADTs, tuples and records. Ultimately, we would like to extend Osiris to support most features of the OCaml language. Iris is a Coq framework for Separation Logic with support for expressive ghost states. It is often used to define program logics and can be parameterized by a programming language — usually described by its small-steps semantics. Most Iris instantiations target ML-like languages, each focusing on a specific purpose and lacking support of programming features such as records or ADTs. Osiris contains an Iris instantiation with a presentation of the semantics of OCaml, in order to reason on realistic OCaml programs. Osiris provides a translation tool to convert OCaml files to Coq files (cf. section 2). In order to verify an OCaml program with Osiris, one would use the translator on an OCaml file, seen as a module. This produces a Coq file containing a deep-embedded representation me of the module. The user would then write and prove a specification for the interpretation of me in our semantics.</p>

