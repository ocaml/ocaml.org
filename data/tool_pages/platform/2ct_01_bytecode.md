---
id: "bytecode-target"
short_title: "Bytecode"
title: "Compilation Targets: Bytecode"
description: "Compile OCaml to portable bytecode with ocamlc. Fast compilation, excellent portability, and easy debugging for OCaml development and production."
category: "Compilation Targets"
---

OCaml can compile to bytecode, providing fast compilation, excellent portability, and predictable execution across different platforms.

## What is OCaml Bytecode?

OCaml bytecode is a portable intermediate representation of OCaml programs that is executed by the OCaml bytecode interpreter. The bytecode system consists of:

- **ocamlc** - The bytecode compiler that compiles OCaml source files to bytecode
- **ocamlrun** - The bytecode interpreter that executes bytecode programs
- **Runtime system** - Includes the bytecode interpreter, garbage collector, and primitive C operations

Bytecode provides several advantages over native compilation:
- Fast compilation speed
- Portability across all platforms where OCaml is installed
- Smaller compiler footprint
- Predictable and consistent execution behaviour
- Easier debugging with built-in tools

The bytecode compiler can be built in either 32-bit or 64-bit mode, resulting in **31-bit or 63-bit integers**, respectively (with 1 bit reserved for the garbage collector tag).

## When to Use Bytecode

**Use bytecode** when you want fast compilation during development, need maximum portability, or are targeting platforms without a native code compiler.

**Use native code** (ocamlopt) when you need maximum runtime performance in production deployments.

Many OCaml developers use bytecode during development for its fast compile times, then switch to native code for production releases.

## File Extensions

The bytecode compiler produces several types of files:

- **.cmo** - Compiled module object (bytecode)
- **.cmi** - Compiled module interface
- **.cma** - Bytecode library archive (collection of .cmo files)
- **executable** - Bytecode executable (often with no extension or .byte extension)

## Learn More

- [Dune Manual: Executable Linking Modes](https://dune.readthedocs.io/en/stable/reference/dune/executable.html#linking-modes) - How to specify native, bytecode, or other compilation modes in Dune
- [OCaml Manual: Batch Compilation](https://ocaml.org/manual/latest/comp.html) - Complete reference for ocamlc
- [OCaml Manual: Runtime System](https://ocaml.org/manual/latest/runtime.html) - Details on ocamlrun and bytecode execution
- [Compiler Backend Documentation](https://ocaml.org/docs/compiler-backend) - How the OCaml compiler works
- [Compiling OCaml Projects](https://ocaml.org/docs/compiling-ocaml-projects) - Getting started guide
