---
title: "Gospel Ecosystem: Tools Ready to Try, Language Evolving"
tags: [gospel, platform]
---

[Gospel](https://github.com/ocaml-gospel/gospel), the behavioral specification language for OCaml, is at an interesting inflection point. After years of development and research, some tools in the ecosystem—particularly Ortac/QCheck-STM—are ready for early adopters to try on real codebases. At the same time, Gospel itself is preparing a major release with breaking changes as the language design continues to evolve.

## Making Formal Methods Accessible

Traditional formal verification delivers strong correctness guarantees but requires significant expertise and resources. Gospel's vision is different: one specification language that will eventually support multiple verification strategies, from lightweight runtime testing to full mathematical proofs. While the testing tools are available today, the proof tools are still under development.

[Gospel](https://ocaml-gospel.github.io/gospel/) provides a non-invasive syntax for annotating OCaml interfaces with formal contracts in special comments beginning with `@`, describing type invariants, mutability, pre-conditions, post-conditions, and exceptions. The specifications use logical models to represent abstract types—for example, modeling a queue as a mathematical sequence to specify how operations transform its contents.

## The Verification Toolkit

Gospel's tool-agnostic design powers an ecosystem of verification tools at different maturity levels:

**[Ortac](https://github.com/ocaml-gospel/ortac)** provides dynamic verification through runtime assertion checking and automated test generation:

- **Ortac/QCheck-STM** (released, battle-tested) generates black-box state-machine tests and has found real bugs including missing bounds checks in [varray](https://github.com/art-w/varray), integer overflows causing segfaults in [bitv](https://github.com/backtracking/bitv), inconsistent behavior with zero-length vectors in bitv, and unexpected behavior in the standard library's Hashtbl.create. Supports higher-order functions like `map`.
- **Ortac/Wrapper** (released, early stage) instruments functions with runtime assertions but hasn't been extensively tested in production yet.
- **Ortac/Monolith** (experimental) provides fuzzing integration with [Monolith](https://gitlab.inria.fr/fpottier/monolith).

**[Cameleer](https://github.com/ocaml-gospel/cameleer)** (working toward first release) translates Gospel into [Why3](https://why3.lri.fr/) for deductive verification using automated theorem provers.

**[Peter](https://github.com/ocaml-gospel/peter)** (ongoing research) explores separation logic verification through [CFML](https://gitlab.inria.fr/charguer/cfml) integration with [Coq](https://coq.inria.fr/) for complex heap manipulation proofs.

**[Gospel language](https://github.com/ocaml-gospel/gospel)** (experimental, major changes coming) is preparing a release with significant breaking changes. Early adopters should expect the language to evolve and should not expect bug fixes in the current version.

## Open Source Infrastructure Strategy

Gospel development is funded by [ANR grant ANR-22-CE48-0013](https://anr.fr/Project-ANR-22-CE48-0013), executed through collaboration between [Nomadic Labs](https://www.nomadic-labs.com/), [Tarides](https://tarides.com/), [Inria](https://www.inria.fr/), and [LMF (Laboratoire Méthodes Formelles)](https://lmf.cnrs.fr/) at Université Paris-Saclay. The project demonstrates how open source can transform formal verification economics: rather than each organization independently funding expensive verification efforts, shared open tooling and verified libraries benefit the entire ecosystem.

## Current State and Integration

Ortac/QCheck-STM is released and has proven effective on real codebases, with test runs completing in hundreds of milliseconds. Gospel itself is experimental with major language changes planned, so early adopters should expect breaking changes.

The [OCaml Platform roadmap](https://ocaml.org/tools/platform-roadmap#w22-formal-verification) through 2026 includes formal verification as a workflow goal. Currently, using Ortac requires writing Dune rules manually. Integration with [Dune](https://dune.build/) as a first-class feature requires further discussion and development.

## Try Ortac/QCheck-STM Today

Install via opam:
```shell
opam install ortac-qcheck-stm
```

This installs the `ortac` command-line tool and everything needed to generate QCheck-STM tests from Gospel specifications. See the [Ortac tutorial](https://tarides.com/blog/2025-09-10-dynamic-formal-verification-in-ocaml-an-ortac-qcheck-stm-tutorial/) for a complete walkthrough, or check the [QCheck-STM plugin README](https://github.com/ocaml-gospel/ortac/blob/main/plugins/qcheck-stm/README.md) for details.

The project welcomes early adopters who want to:
- Try Ortac/QCheck-STM on production codebases and report bugs found
- Provide feedback on Gospel's evolving specification language
- Share use cases that could benefit from formal verification

The [VOCaL (Verified OCaml Library)](https://github.com/vocal-project/vocal) project demonstrates Gospel's potential with formally verified data structures.

## What to Expect

**Gospel language**: Major breaking changes coming. Not recommended for production use until the new release stabilizes. Bugs in the current version likely won't be fixed.

**Ortac/QCheck-STM**: Ready to try. Has found real bugs in established libraries. Practical for CI integration.

**Ortac/Wrapper**: Released but not yet battle-tested. Feedback welcome.

**Proof tools (Cameleer, Peter)**: Under active development, not yet released.

The verification infrastructure is already useful for testing — bugs are being found, specifications provide value as documentation. Work on establishing the path from testing to formal proofs is ongoing, but the proof tools aren't ready for general use yet.

## Learn More

The ecosystem is open source and actively developed. Explore the [Gospel GitHub organization](https://github.com/ocaml-gospel), or review research papers:
- [GOSPEL — Providing OCaml with a Formal Specification Language](https://inria.hal.science/hal-02157484/file/final.pdf) (FM 2019)
- [Static and Dynamic Verification of OCaml Programs: The Gospel Ecosystem](https://arxiv.org/pdf/2407.17289) (ISoLA 2024)
- [Dynamic Verification of OCaml Software with Gospel and Ortac/QCheck-STM](https://hal.science/hal-05073121v1/document) (TACAS 2025)

For teams interested in specification-driven testing, Ortac/QCheck-STM is ready to try. For those interested in formal proofs or stable Gospel language features, watch the project but expect it will be some time before these are production-ready.

*Contact: [@n-osborne](mailto:nicolas.osborne@tarides.com) | Get started: [Ortac Tutorial](https://tarides.com/blog/2025-09-10-dynamic-formal-verification-in-ocaml-an-ortac-qcheck-stm-tutorial/) | Documentation: [Gospel docs](https://ocaml-gospel.github.io/gospel/)*
