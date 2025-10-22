---
id: "bytecode-target"
short_title: "Compilation Targets: Bytecode"
title: "Compilation Targets: Bytecode"
description: "Compile OCaml to portable bytecode with ocamlc. Fast compilation, excellent portability, and easy debugging for OCaml development and production."
category: "Compilation Targets"
---

OCaml can compile to bytecode, providing fast compilation, excellent portability, and predictable execution across different platforms.

## What is OCaml Bytecode?

OCaml bytecode is a portable intermediate representation of OCaml programs that is executed by the OCaml bytecode interpreter. The bytecode system consists of:

- **ocamlc** - The bytecode compiler that compiles OCaml source files to bytecode
- **ocamlrun** - The bytecode interpreter that executes bytecode programs
- **Runtime system** - Includes the bytecode interpreter, garbage collector, and C primitive operations

Bytecode provides several advantages over native compilation:
- Fast compilation speed
- Portability across all platforms where OCaml is installed
- Smaller compiler footprint
- Predictable and consistent execution behavior
- Easier debugging with built-in tools

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

## Getting Started

To get started with OCaml bytecode compilation, visit the [OCaml Manual: Batch Compilation (ocamlc)](https://ocaml.org/manual/latest/comp.html). This comprehensive guide covers:

- Compiling OCaml source files to bytecode
- Linking bytecode object files into executables
- Creating and using bytecode libraries
- Compiler command-line options and flags
- Separate compilation for larger projects

For information on running bytecode programs and configuring the runtime system, see the [OCaml Manual: Runtime System (ocamlrun)](https://ocaml.org/manual/latest/runtime.html).

## Debugging

The bytecode compiler includes excellent debugging support. Compile with the `-g` flag to include debugging information, which enables:
- Stack backtraces for uncaught exceptions
- Use of the OCaml debugger (ocamldebug)
- Better error reporting

Learn more in the [OCaml Manual: The Debugger](https://ocaml.org/manual/latest/debugger.html).

## Custom Runtime Mode

For standalone executables that don't require ocamlrun to be installed separately, OCaml supports custom runtime mode. This bundles the runtime system with your bytecode in a single executable file.

Details can be found in the [OCaml Manual: Batch Compilation](https://ocaml.org/manual/latest/comp.html) under the `-custom` flag documentation.

## Learn More

- [OCaml Manual: Batch Compilation](https://ocaml.org/manual/latest/comp.html) - Complete reference for ocamlc
- [OCaml Manual: Runtime System](https://ocaml.org/manual/latest/runtime.html) - Details on ocamlrun and bytecode execution
- [Compiler Backend Documentation](https://ocaml.org/docs/compiler-backend) - How the OCaml compiler works
- [Compiling OCaml Projects](https://ocaml.org/docs/compiling-ocaml-projects) - Getting started guide
