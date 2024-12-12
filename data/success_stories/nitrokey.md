---
title: Open Hardware Security Module Built on MirageOS
logo: success-stories/nitrokey.svg
card_logo: success-stories/white/nitrokey.svg
background: /success-stories/nitrokey-bg.jpg
theme: black
synopsis: "NetHSM is a secure, open-source software-based Hardware Security Module (HSM) built on OCaml and MirageOS, providing transparent, customizable cryptographic key management for applications like TLS, DNSSEC, and blockchain."
url: https://www.nitrokey.com/products/nethsm
priority: 6
why_ocaml_reasons:
- Strong Type System
- Memory Safety
- Unikernel Support
- Reliability
---

## Challenge

We were facing the challenge of developing a highly secure system, one that didn't yet exist in the way we envisioned. Specifically, we wanted to create a system based on a formally-verified, unikernel architecture. Our aim was to build the very first Open Source HSM (Hardware Security Module) in an industry traditionally dominated by proprietary solutions. The goal was to develop something that was extremely secure and trustworthy, essentially building "a HSM but purely in software." Given our stringent requirements, MirageOS was the only solution that met our security criteria at that time.

The resulting product, NetHSM, is a secure, open-source store for cryptographic keys used for applications such as TLS, DNSSEC, PKI, Certificate Authorities (CA), and blockchain. The open-source nature of NetHSM allows users to verify that there are no hidden backdoors, and it’s also user-friendly, featuring a modern REST interface. Additionally, it is developed in Germany, which further bolsters its trustworthiness.

Our key technical requirements included the need for a memory-safe language that was more abstract and less prone to errors. This was essential for security reasons. We also needed a unikernel—a highly-condensed operating system that contains only the necessary parts—to ensure a minimal attack vector. Back then, MirageOS was the only viable option that supported these features and ran on ordinary x86 hardware, compatible with different hypervisors.

## Result

After implementing the OCaml solution, we saw several benefits, particularly in the ease of integrating new cryptographic algorithms compared to hardware-based approaches. Hardware HSMs are often limited in terms of flexibility, but with NetHSM, we gained the ability to build and customise the firmware ourselves, ensuring that no hidden backdoors exist. This flexibility is a significant security advantage and has allowed us to offer consulting services based on customization.

NetHSM has become one of Nitrokey’s flagship products, marking us as a first-mover in the niche of Open Hardware providers with open-source firmware. This strategic advantage has positioned us well within the market.

## Why OCaml

Our decision to use OCaml was driven by its performance, reliability, and its alignment with our need for a unikernel solution. MirageOS, built on OCaml, was the best solution for unikernels at the time, and its type safety meant that once the system was up and running, it was highly reliable. This was something we had not experienced with other languages.

Though OCaml is a niche language, we found it invaluable for its rigorous type system, which helps in avoiding bugs and keeping the codebase consistent. The language allows concise expression of complex logic and also provides the flexibility to write performance-critical sections, such as for-loops, when needed.

If we were to start over today, we would consider other modern options such as using a hypervisor in Rust and building a unikernel framework in Go. Go is simple to teach, widely battle-tested, and has a large pool of available developers. However, when OCaml’s ecosystem matures further, we would still prefer it due to its robust type system and reliability.

## Solution

OCaml helped us address our challenges primarily through its strong type system, which allowed us to encode complex logic into types and catch potential issues early in development. This approach leads to consistency across the codebase. The language is both pragmatic and powerful, giving us the flexibility to maintain performance where needed without compromising the integrity of the code.

We integrated OCaml into our tech stack using the MirageOS unikernel and the Muen SK hypervisor. This combination allowed us to build a secure and flexible solution that met our stringent security requirements.

## Lessons Learned

For companies considering OCaml, it’s crucial to ensure that you have adequate resources, both in terms of developers and the necessary infrastructure. Before committing to OCaml, verify that the hardware and software support you need is available, and make sure to build a robust developer team, especially as OCaml is a niche language. We’ve found it helpful to work with specialised partners, such as Tarides, to overcome bottlenecks.

One of the unexpected benefits of using OCaml has been its reliability; once the system is running, it rarely encounters bugs.
