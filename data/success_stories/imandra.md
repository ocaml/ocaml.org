---
title: Financial Compliance with Automated Reasoning
logo: success-stories/imandra.svg
card_logo: success-stories/white/imandra.svg
background: /success-stories/imandra-bg.jpg
theme: black
synopsis: "Imandra leverages OCaml to develop automated reasoning tools that enable financial institutions to mathematically verify their trading algorithms meet regulatory requirements."
url: https://www.imandra.ai/
priority: 7
why_ocaml_reasons:
- Expressive Type System
- High Performance
- Unified Tech Stack
- Strong Ecosystem
- Interoperability
- Community and Resources
---

## Challenge

The 2008 financial crisis fundamentally altered the regulatory landscape for financial institutions. Banks faced stringent new compliance requirements that demanded mathematical proof of algorithmic correctness—a challenge the industry was ill-equipped to handle. Trading algorithms, characterized by nonlinear mathematical behaviors and complex decision trees, were typically specified through informal PDF documentation prone to ambiguity and human error.

Grant Passmore, drawing on his doctoral research in decision procedures for nonlinear arithmetic at Edinburgh, identified a critical capability gap. While existing formal verification tools like SAT and SMT solvers could handle bounded problems, they lacked the sophistication to reason about the recursive functions, higher-order logic, and nonlinear arithmetic inherent in modern trading systems. The autonomous systems sector faced similar verification challenges, requiring tools capable of reasoning about nonlinear control flow in applications from drone controllers to analog circuits.

## Solution

Imandra developed a comprehensive automated reasoning system built entirely in OCaml. Their Imandra Modeling Language (IML), a carefully designed subset of OCaml, provides the expressiveness needed for complex specifications while maintaining decidability properties essential for automated reasoning.

The company's primary innovation lies in formalizing previously informal specification processes. Financial institutions transitioned from error-prone PDF documentation to formal IML specifications, authored using Imandra's VSCode extension. This formalization enables automated analysis, systematic edge-case discovery, and streamlined regulatory certification.

A pivotal demonstration came through their 2017 partnership with Goldman Sachs. Imandra formally modeled and verified the SIGMA X MTF Auction Book, proving key properties about fairness and correctness. These verified models were deployed to production, where they continue to validate trading operations in real-time.

Imandra's "digital twin" technology compiles formally verified models into efficient executable code that runs alongside production systems, providing continuous mathematical assurance of correct behavior.

[Watch Imandra's explainer video](https://vimeo.com/123746101) to understand Imandra's approach to automated reasoning.

## Why OCaml

While Imandra's initial prototype utilized PolyML, the team strategically migrated to OCaml based on four compelling factors:

• **Industry Credibility**: OCaml's established presence in financial institutions through Jane Street and LexiFi provided crucial market validation. LexiFi's integration within Bloomberg terminals offered immediate credibility when engaging potential clients unfamiliar with formal verification.

• **Type System Optimality**: OCaml occupies an optimal position in the type system spectrum for automated reasoning. It provides sufficient type safety for building reliable theorem provers without the implementation complexity imposed by dependently typed languages.

• **Architectural Consistency**: Unlike competitors employing C++ for reasoning engines and disparate technologies for interfaces, Imandra maintains unity through OCaml. From theorem proving kernel to Eliom-based web frontend, this consistency enables fluid knowledge transfer and reduces architectural impedance.

• **Ecosystem Maturity**: Industrial-strength tooling through opam and Dune, combined with resources like *Real World OCaml*, accelerates engineer onboarding. The robust FFI facilitates integration with existing C or Rust components, which Imandra systematically replaces with pure OCaml implementations.

## Results

**Used by Key Industry Players**: Goldman Sachs operates Imandra's verified models in production, validating trades in real-time. Citi and other major institutions have followed suit. Beyond finance, DARPA and the US Navy employ Imandra for critical infrastructure verification.

**Industry Transformation**: Financial institutions broadly adopted Imandra's formal specification approach, abandoning error-prone PDF processes for mathematically rigorous alternatives. Imandra compresses FIX protocol certification from days to hours, directly enhancing banks' ability to onboard trading partners.

**Development Flexibility**: Engineers transition seamlessly between frontend development and theorem prover implementation. The unified architecture eliminates specialization silos and maximizes knowledge utilization.

## Lessons Learned

**Architectural Uniformity**: Employing OCaml across all system layers eliminates technology boundaries. Engineers can progress from accessible frontend tasks to sophisticated theorem proving work within a single language ecosystem.

**Community Scale Matters**: OCaml's larger community relative to alternatives like PolyML provides richer tooling, comprehensive learning resources, and deeper talent pools.

**Ecosystem Investment Compounds**: Mature tooling and high-quality educational materials significantly reduce time-to-productivity for new team members.

**Type System Balance**: OCaml's type system provides strong guarantees without excessive ceremony—particularly well-suited for verification systems where both correctness and development efficiency are paramount.
