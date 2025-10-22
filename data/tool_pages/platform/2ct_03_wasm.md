---
id: "wasm-target"
short_title: "Compilation Targets: WASM"
title: "Compilation Targets: WebAssembly"
description: "Compile OCaml to WebAssembly with wasm_of_ocaml and Wasocaml. Build high-performance applications for browsers, servers, and edge computing with Wasm."
category: "Compilation Targets"
---

OCaml can compile to WebAssembly (WASM), enabling you to run high-performance OCaml code in web browsers, on the server, and in embedded environments with near-native speed.

## What is WebAssembly?

WebAssembly is a binary instruction format designed as a portable compilation target for programming languages. It provides:

- Near-native performance in web browsers and standalone runtimes
- Sandboxed execution environment for security
- Broad platform support across browsers, servers, and edge computing
- Compact binary format for fast loading and parsing

## Available Tools

### wasm_of_ocaml

[wasm_of_ocaml](https://github.com/ocaml-wasm/wasm_of_ocaml) compiles OCaml bytecode to WebAssembly. It provides:

- Full OCaml language support, including the standard library
- Compatibility with existing OCaml libraries
- Integration with JavaScript through Js_of_ocaml-style bindings
- Ability to run OCaml code in browsers and WASM runtimes
- Shared infrastructure with Js_of_ocaml for web development

wasm_of_ocaml is ideal when you want to leverage existing OCaml code with WebAssembly's performance characteristics while maintaining compatibility with the OCaml ecosystem.

### Wasocaml

[Wasocaml](https://github.com/OCamlPro/wasocaml) is an OCaml compiler that targets WebAssembly GC (WASM-GC). Developed by OCamlPro, it provides:

- Direct compilation from OCaml's Flambda intermediate representation to WASM-GC
- Native WebAssembly garbage collection support
- Optimized performance through the Flambda optimizer
- Support for functional programming language features in WebAssembly
- First real-world functional language compiler targeting WASM-GC

Wasocaml is ideal when you need direct compilation to WebAssembly with garbage collection support and want to benefit from Flambda optimizations.

## Choosing a Tool

**Use wasm_of_ocaml** when you want to run existing OCaml bytecode in WebAssembly environments, need compatibility with Js_of_ocaml web bindings, or want a mature toolchain similar to Js_of_ocaml.

**Use Wasocaml** when you need direct compilation with Flambda optimizations, want to target the WebAssembly GC proposal, or are building performance-critical applications.

## Getting Started

### wasm_of_ocaml

Visit the [wasm_of_ocaml repository](https://github.com/ocaml-wasm/wasm_of_ocaml) to learn how to:

- Install and set up wasm_of_ocaml
- Compile OCaml programs to WebAssembly
- Interact with JavaScript APIs from WASM
- Deploy WASM modules in web applications

### Wasocaml

Visit the [Wasocaml repository](https://github.com/OCamlPro/wasocaml) and [OCamlPro's blog posts](https://ocamlpro.com/blog/2022_12_14_wasm_and_ocaml/) to learn how to:

- Install the Wasocaml compiler switch
- Compile OCaml programs to WASM-GC
- Understand the compilation process and optimizations
- Deploy to WebAssembly runtimes

## Learn More

- [ocaml-wasm Organization](https://github.com/ocaml-wasm) - Coordination hub for OCaml WebAssembly efforts
- [WebAssembly.org](https://webassembly.org/) - WebAssembly specification and documentation
- [WASM-GC Proposal](https://github.com/WebAssembly/gc) - Garbage Collection proposal for WebAssembly
- [OCamlPro WASM Blog Posts](https://ocamlpro.com/blog/tags/wasm/) - Technical deep dives on Wasocaml

## Community

- [Discuss OCaml Forums](https://discuss.ocaml.org/) - Ask questions in the Ecosystem category
- [ocaml-wasm Updates](https://discuss.ocaml.org/tag/wasm) - Follow WebAssembly developments in OCaml
