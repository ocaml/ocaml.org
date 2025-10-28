---
id: "wasm-target"
short_title: "WebAssembly"
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

[wasm_of_ocaml](https://github.com/ocsigen/js_of_ocaml/blob/master/README_wasm_of_ocaml.md) compiles OCaml bytecode to WebAssembly. It provides:
- Full OCaml language support, including the standard library and OCaml 5 effects
- Compatibility with existing OCaml libraries
- Integration with JavaScript through Js_of_ocaml-style bindings
- Ability to run OCaml code in browsers and WASM runtimes
- Shared infrastructure with Js_of_ocaml for web development
- **31-bit integers** (similar to traditional OCaml bytecode on 32-bit systems)

**Note:** While wasm_of_ocaml supports OCaml 5 effects, it has limited support for Domains (multicore parallelism).

wasm_of_ocaml is ideal when you want to leverage existing OCaml code with WebAssembly's performance characteristics while maintaining compatibility with the OCaml ecosystem.

Visit the [wasm_of_ocaml documentation](https://github.com/ocsigen/js_of_ocaml/blob/master/README_wasm_of_ocaml.md) in the Js_of_ocaml repository to learn how to install and set up wasm_of_ocaml, compile OCaml programs to WebAssembly, interact with JavaScript APIs from WASM, and deploy WASM modules in web applications.

### Wasocaml

[Wasocaml](https://github.com/OCamlPro/wasocaml) is an OCaml compiler that targets WebAssembly GC (WASM-GC). Developed by OCamlPro, it provides:
- Direct compilation from OCaml's Flambda intermediate representation to WASM-GC
- Native WebAssembly garbage collection support
- Optimized performance through the Flambda optimizer
- Support for functional programming language features in WebAssembly
- First real-world functional language compiler targeting WASM-GC
- **31-bit integers** (similar to traditional OCaml bytecode on 32-bit systems)

**Note:** Wasocaml is based on OCaml 4.14 and does not currently support OCaml 5 effects or multicore features.

Wasocaml is ideal when you need direct compilation to WebAssembly with garbage collection support and want to benefit from Flambda optimizations.

Visit the [Wasocaml repository](https://github.com/OCamlPro/wasocaml) and [OCamlPro's blog posts](https://ocamlpro.com/blog/2022_12_14_wasm_and_ocaml/) to learn how to install the Wasocaml compiler switch, compile OCaml programs to WASM-GC, understand the compilation process and optimizations, and deploy to WebAssembly runtimes.

## Choosing a Tool

**Use wasm_of_ocaml** when you want to run existing OCaml bytecode in WebAssembly environments, need compatibility with Js_of_ocaml web bindings, or want a mature toolchain similar to Js_of_ocaml.

**Use Wasocaml** when you need direct compilation with Flambda optimizations, want to target the WebAssembly GC proposal, or are building performance-critical applications.

## Learn More

- [ocaml-wasm Organization](https://github.com/ocaml-wasm) - Coordination hub for OCaml WebAssembly efforts
- [WebAssembly.org](https://webassembly.org/) - WebAssembly specification and documentation
- [WASM-GC Proposal](https://github.com/WebAssembly/gc) - Garbage Collection proposal for WebAssembly
- [OCamlPro WASM Blog Posts](https://ocamlpro.com/blog/tags/wasm/) - Technical deep dives on Wasocaml

## Community

- [Discuss OCaml Forums](https://discuss.ocaml.org/) - Ask questions in the Ecosystem category
- [ocaml-wasm Updates](https://discuss.ocaml.org/tag/wasm) - Follow WebAssembly developments in OCaml
