---
title: Secure and Verifiable Online Voting Platform
logo: success-stories/vcast.svg
card_logo: success-stories/white/vcast.svg
background: /success-stories/vcast-bg.jpg
theme: green
synopsis: "VCAST is a French company providing transparent and verifiable online voting solutions, built on the foundation of the open-source Belenios voting system. Their platform enables organizations to conduct secure electronic elections while ensuring complete verification and transparency of the voting process."
url: https://www.vcast.vote/
priority: 7
why_ocaml_reasons:
- Eliom Web Framework
- Type Safety
- Good Performance
- Ability to Compile to JavaScript
---

## Challenge

Our story at VCAST begins with the Belenios project at INRIA in 2012, where we developed an open-source internet voting system. As our platform gained traction, especially during the COVID-19 pandemic in 2020, our research project couldn't keep up with the growing commercial demands and professional service requirements from our users. This led to the founding of VCAST in December 2024, aiming to provide enterprise-grade support and services around the Belenios technology.

The technical challenges were significant: we needed to build a voting system that could guarantee privacy, security, and cryptographic verifiability while being accessible to non-technical users. In order to achieve our required guarantees, our system incorporates advanced cryptographic concepts such as asymmetric encryption and zero-knowledge proofs, all while maintaining high performance and reliability.

## Result

Our OCaml-based online voting platform has proven successful:
- We've organized over 7,000 elections successfully through the platform
- We've invited more than 740,000 voters to participate
- We've processed approximately 240,000 actual votes

OCaml’s performance has been particularly noteworthy. In one instance, when we developed a verifier for the French abroad voting system, our OCaml implementation significantly outperformed the existing Java-based solution, reducing verification time from several hours to less than thirty minutes.

## Why OCaml

Our journey with OCaml began during our university years, where we initially encountered it alongside the Coq proof assistant during our PhD work. When we started the Belenios project at INRIA in 2012, choosing OCaml felt natural given our background and the language's unique capabilities.

The language's strong type safety was particularly crucial for our work, as it provides essential guarantees when implementing cryptographic components. This feature became increasingly valuable as our system grew in complexity and security requirements.

Our prior experience with OCaml through work with the Coq proof assistant gave us confidence in the language's ability to handle complex mathematical and cryptographic implementations. The excellent performance characteristics we've observed have consistently validated this choice, particularly in our cryptographic operations and verification processes.

A key factor in our decision was OCaml's ability to compile to JavaScript using js_of_ocaml, which has proven invaluable in enabling sophisticated client-side functionality. This capability has allowed us to maintain type safety across our client-server boundary while building modern web interfaces, giving us the best of both worlds in terms of security and user experience.

## Solution

Our technical implementation has evolved significantly since our initial launch. We began with a foundation based on the Helios voting interface, leveraging their existing JavaScript implementation for our frontend. As our platform matured, we undertook a complete rewrite of the voting interface in OCaml for version 2, marking a significant shift in our architectural approach.

The development of our platform has been characterized by successful collaboration between OCaml and non-OCaml developers. This was particularly evident when an external contributor wrote a React interface for the voting platform, demonstrating how our architecture could accommodate different technologies and expertise levels.

For our backend infrastructure, we chose Eliom as our foundation for both the server and API layer. What started as a classic web application with HTML4 has evolved into a sophisticated client-server application, maintaining a clean separation between components.

Our technical stack includes:
- Eliom for backend and API layer
- js_of_ocaml for client-side OCaml code
- WASM integration for libsodium cryptographic functions
- React components for interface elements
- JavaScript for SJCL implementation

## Lessons Learned

Key insights from our experience with OCaml include:
- OCaml's type system provides us with crucial safety guarantees for our cryptographic implementations
- The language's interoperability capabilities, particularly through js_of_ocaml, enable our flexible architecture choices
- Non-OCaml developers can effectively contribute to the codebase, particularly in frontend components
- While we find that hiring OCaml developers can be challenging, they typically bring high skill levels to our project
- We've found that the combination of OCaml's performance characteristics and type safety makes it particularly well-suited for our security-critical applications
