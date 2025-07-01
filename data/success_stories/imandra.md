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

Grant Passmore, drawing on his doctoral research in decision procedures for nonlinear arithmetic at Edinburgh, identified a critical capability gap in the market. While existing formal verification tools like SAT and SMT solvers could handle bounded problems, they lacked the sophistication to reason about the recursive functions, higher-order logic, and nonlinear arithmetic inherent in modern trading systems.

This verification challenge extended beyond finance. The autonomous systems sector—encompassing everything from drone control systems to analog circuit controllers—required similar capabilities for reasoning about nonlinear control flow and ensuring safety properties. The market demanded a solution that could bridge the gap between academic theorem provers and industrial-scale verification needs.

## Solution

Imandra developed a comprehensive automated reasoning system built entirely in OCaml, comprising both a theorem prover and a domain-specific language. Their Imandra Modeling Language (IML) represents a carefully designed subset of OCaml, providing the expressiveness needed for complex specifications while maintaining decidability properties essential for automated reasoning.

The company's primary innovation lies in formalizing previously informal specification processes. Financial institutions transitioned from error-prone PDF documentation to formal IML specifications, authored using Imandra's custom VSCode extension. This formalization enables automated analysis, systematic edge-case discovery, and streamlined regulatory certification processes.

A pivotal demonstration of Imandra's capabilities came through their 2017 partnership with Goldman Sachs. Imandra formally modeled and verified the SIGMA X MTF Auction Book, a periodic auction trading venue. The verification process involved creating mathematical models of the system's behavior, proving key properties about fairness and correctness, and generating comprehensive test suites. Significantly, these verified models were deployed to production, where they continue to validate trading operations in real-time.

Imandra's "digital twin" technology represents a substantial advancement in production verification. The system compiles formally verified models into efficient executable code that runs alongside production systems, providing continuous mathematical assurance of correct behavior. This capability transforms theoretical guarantees into operational reality.

The company's collaboration with Itiviti on FIX protocol certification demonstrates the practical impact of their technology. By enhancing their reasoning engine's performance, Imandra reduced counterparty certification timeframes from multiple days to mere hours—a transformation that directly impacts business agility in financial markets.

## Why OCaml

While Imandra's initial prototype utilized PolyML, the team strategically migrated to OCaml based on four compelling factors:

• **Industry Credibility**: OCaml's established presence in financial institutions through Jane Street and LexiFi provided crucial market validation. The integration of LexiFi's technology within Bloomberg terminals offered immediate credibility when engaging with potential clients unfamiliar with formal verification methodologies.

• **Type System Optimality**: For automated reasoning applications, OCaml occupies an optimal position in the type system spectrum. It provides sufficient type safety for building reliable theorem provers without the implementation complexity imposed by dependently typed languages. This balance proves essential for maintaining development velocity while ensuring correctness.

• **Architectural Consistency**: Unlike competitors who employ C++ for core reasoning engines and disparate technologies for user interfaces, Imandra maintains architectural unity through OCaml. From theorem proving kernels to Eliom-based web frontends, this consistency enables fluid knowledge transfer across teams and reduces architectural impedance mismatches.

• **Ecosystem Maturity**: The OCaml ecosystem provides industrial-strength tooling through OPAM and Dune, while educational resources like *Real World OCaml* accelerate engineer onboarding. The language's robust FFI facilitates initial integration with existing C or Rust components, which Imandra systematically replaces with pure OCaml implementations to maintain system coherence.

## Results

Imandra's OCaml-based platform, supporting a team of approximately 25 employees (20 engineers), has delivered measurable impact across multiple dimensions:

**Production Deployment at Scale**: Goldman Sachs operates Imandra's verified models in production environments, validating trading operations in real-time. Additional adoptions by Citi and other major financial institutions demonstrate market confidence. Beyond finance, organizations including DARPA and the US Navy employ Imandra for critical infrastructure and autonomous systems verification.

**Operational Efficiency Gains**: The Itiviti collaboration yielded dramatic improvements in FIX protocol certification, compressing multi-day processes into hours. This acceleration directly enhances banks' ability to onboard trading partners and adapt to market changes.

**Industry-Wide Methodology Shift**: Financial institutions have broadly adopted Imandra's formal specification approach, abandoning error-prone PDF-based processes. This methodological transformation facilitates more rigorous regulatory compliance and reduces operational risk.

**Development Team Scalability**: The unified OCaml architecture enables remarkable team flexibility. Engineers transition seamlessly between frontend development and theorem prover implementation, maximizing knowledge utilization and reducing specialization silos.

**Performance Evolution**: Imandra's ongoing migration from OCaml 4 to OCaml 5 leverages multicore capabilities to enhance performance for computationally intensive verification tasks, positioning the platform for continued scaling.

## Lessons Learned

Imandra's trajectory offers valuable insights for organizations evaluating OCaml for complex systems:

**Architectural Uniformity Delivers Value**: Employing OCaml across all system layers—from low-level reasoning engines to user-facing interfaces—eliminates technology boundaries and enables efficient knowledge transfer. This approach facilitates gradual skill development, allowing engineers to progress from accessible frontend tasks to sophisticated theorem proving work.

**Community Scale Influences Success**: OCaml's substantially larger community relative to alternatives like PolyML translates into tangible benefits: richer tooling ecosystems, comprehensive learning resources, and deeper talent pools for recruitment.

**Ecosystem Investment Compounds**: Mature tooling infrastructure through OPAM and Dune, combined with high-quality educational materials, significantly reduces time-to-productivity for new team members and simplifies system maintenance.

**Type System Design Matters**: OCaml's type system design—providing strong guarantees without excessive ceremony—proves particularly well-suited for verification systems where both correctness and development efficiency are paramount.

Imandra's evolution from a single-person startup to a critical infrastructure provider for major financial institutions demonstrates OCaml's capacity to support sophisticated verification systems at industrial scale. Their success validates that formal methods, when implemented with appropriate technology choices, can transition from academic curiosity to essential business infrastructure.

[Watch their explainer video](https://vimeo.com/123746101) to understand Imandra's approach to automated reasoning.