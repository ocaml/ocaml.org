---
id: "javascript-target"
short_title: "JavaScript"
title: "Compilation Targets: JavaScript"
description: "Compile OCaml to JavaScript with Js_of_ocaml and Melange. Build type-safe web applications that run in browsers and Node.js with high performance."
category: "Compilation Targets"
---

OCaml can compile to JavaScript, enabling you to write type-safe, high-performance code that runs in web browsers and Node.js environments.

## Available Tools

### Js_of_ocaml

[Js_of_ocaml](https://ocsigen.org/js_of_ocaml/) compiles OCaml bytecode to JavaScript. It provides:

- Excellent performance with compact output
- Strong integration with existing JavaScript libraries
- Access to browser APIs and DOM manipulation
- Support for the full OCaml language, including OCaml 5 effects
- Compatibility with most OCaml libraries and the standard library
- **32-bit integers** (JavaScript's bit operations are 32-bit)

**Note:** While Js_of_ocaml supports OCaml 5 effects, it has limited support for Domains (multicore parallelism).

Js_of_ocaml is ideal when you want to leverage existing OCaml code in web applications or need access to the complete OCaml ecosystem.

**Getting started:** Visit the [Js_of_ocaml documentation](https://ocsigen.org/js_of_ocaml/latest/manual/overview) to learn how to install and set up Js_of_ocaml, compile your first OCaml program to JavaScript, interact with JavaScript APIs and the DOM, and integrate with web applications.

### Melange

[Melange](https://melange.re) compiles OCaml and Reason to JavaScript with a focus on JavaScript ecosystem integration. It provides:

- Idiomatic JavaScript output designed for readability
- Deep integration with NPM packages and JavaScript tooling
- Excellent TypeScript interoperability
- Optimized bundle sizes for modern web applications
- Support for React and modern frontend frameworks

Melange is ideal when you're building JavaScript-first applications and want seamless integration with the JavaScript ecosystem.

**Getting started:** Visit the [Melange documentation](https://melange.re/v5.0.0/) to learn how to set up a Melange project, bind to JavaScript libraries, build web applications with Melange, and integrate with existing JavaScript tooling.

## Choosing a Tool

**Use Js_of_ocaml** when you have existing OCaml code you want to run in the browser, need the full OCaml standard library, or want to use OCaml-native libraries.

**Use Melange** when you're building web applications that need to integrate tightly with JavaScript libraries, want readable JavaScript output, or need excellent TypeScript compatibility.

## Learn More

- [Dune Manual: Executable Linking Modes](https://dune.readthedocs.io/en/stable/reference/dune/executable.html#linking-modes) - How to specify native, bytecode, or other compilation modes in Dune
- [Js_of_ocaml Manual](https://ocsigen.org/js_of_ocaml/latest/manual/overview) - Comprehensive guide and API reference
- [Melange Playground](https://melange.re/v5.0.0/playground/) - Try Melange in your browser
- [OCaml for Web Development](https://ocaml.org/docs/web-development) - Overview of web development with OCaml

## Community

- [Discuss OCaml Forums](https://discuss.ocaml.org/) - Ask questions in the Ecosystem category
- [Melange Discord](https://discord.gg/reasonml) - Melange and Reason community
