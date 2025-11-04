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

### Wasocaml (Experimental)

[Wasocaml](https://github.com/OCamlPro/wasocaml) is an experimental OCaml compiler developed by OCamlPro that targets WebAssembly GC (WASM-GC). As a research project exploring direct compilation to WASM-GC, it provides:
- Direct compilation from OCaml's Flambda intermediate representation to WASM-GC
- Native WebAssembly garbage collection support
- Optimised performance through the Flambda optimiser
- Support for functional programming language features in WebAssembly
- **31-bit integers** (similar to traditional OCaml bytecode on 32-bit systems)

**Important limitations:** Wasocaml is based on OCaml 4.14 and does not currently support OCaml 5 effects or multicore features. As an experimental project, it should be considered for research and experimentation rather than for use in production.

Visit the [Wasocaml repository](https://github.com/OCamlPro/wasocaml) to learn how to install the Wasocaml compiler switch and explore its experimental features.

## Choosing a Tool

**Use wasm_of_ocaml** for most WebAssembly projects. It provides a mature toolchain for running existing OCaml bytecode in WebAssembly environments, with compatibility with Js_of_ocaml web bindings and OCaml 5 support.

**Explore Wasocaml** if you're interested in experimental approaches to WebAssembly compilation or researching direct compilation to WASM-GC, keeping in mind its current limitations and experimental status.

## Learn More

- [Dune Manual: Executable Linking Modes](https://dune.readthedocs.io/en/stable/reference/dune/executable.html#linking-modes) - How to specify native, bytecode, WebAssembly, or other compilation modes in Dune
- [ocaml-wasm Organisation](https://github.com/ocaml-wasm) - Coordination hub for OCaml WebAssembly efforts
- [WebAssembly.org](https://webassembly.org/) - WebAssembly specification and documentation
- [WASM-GC Proposal](https://github.com/WebAssembly/gc) - Garbage Collection proposal for WebAssembly

## Community

- [Discuss OCaml Forums](https://discuss.ocaml.org/) - Ask questions in the Ecosystem category
- [ocaml-wasm Updates](https://discuss.ocaml.org/tag/wasm) - Follow WebAssembly developments in OCaml
