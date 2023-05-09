---
id: dune
title: Juggling with Modules, Libraries and Packages
description: >
  Learn about an OCaml's most-used, built-in data types
category: "guides"
date: 2023-01-12T09:00:00-01:00
---

# Juggling with Modules, Libraries and Packages

## Prerequisites

## Introduction

OCaml is a multi-paradigm programming language, it allows writing code using several styles. Historically, it has included been mostly four paradigms:

1. Functional - At its core, and from its inception, OCaml is a functional
   programming language. By default, it is the recommended style.
1. Imperative - For performance and comfort, OCaml provides most of the
   constructs found in imperative languages. However, they come with two twists:

   - No nullable values
   - No confusion between mutable and immutable values
1. Modular - In OCaml, the premier mean of structuring sources are modules,
   which allows separate compilation and avoiding name clashes. The OCaml module
   system remains among the most advanced with “functions” from module to module (named
   _functors_ to avoid confusion with regular functions).
1. Object-Orientation - OCaml is not an object-oriented language, it provides
   means to write object-oriented software, but using that style is only an option, not a requirement of the language.

Since OCaml 5, a fifth paradigm is available: effect-handlers allow writing
software in a style which is so new it doesn't have a name yet! This will not be
discussed in this document.

The rest of this document presents the concepts and tools which are used to
structure most of the projects written in OCaml, in its functional plus
modular part.

## Minimum Dune Setup

Examples in this document are command lines supposed to be executed in order.
They have been tested in Linux using Bourne shell `sh`.

[Dune](https://dune.build/) is the main build system for OCaml. To start
working, it needs two files: a single `dune-project` which is supposed to be at
the root of the project and at least one `dune` file. Here is how to create a test
setup:

```sh
$ cd `mktemp -d -p ~`
$ echo '(lang dune 3.6)' > dune-project
$ echo '(executable (name clark))' > dune
```

Full-fledge projects will have more structure, but in order to keep this
tutorial as simple as possible we start from bare minimum. This setting allows
compiling an empty project.
```sh
$ touch clark.ml
$ dune exec --display=quiet ./clark.exe
```

Yes, the empty file is valid OCaml syntax.

## Modules Basics

This section recalls some basic concepts related to modules. Importantly, it
doesn't address functors. See [Modules](/docs) and [Functors](/functors)
tutorials for more detailed information about those concepts.

### Each `.ml` File Defines a Module

OCaml source code files are expected to have a `.ml` filename extension. The
compiler reads each of them once and conceptually produces one module per file.
For instance, the file `clark.ml` entails a module named `Clark`.

Definitions from a module can be used in other modules, they are uniquely
identified by the prefixing internal names with their module name. In the
following example, the module `Clark` is using a string defined in module
`Foo`:


```sh
$ echo 'let hello = "Hello"' > foo.ml
$ echo 'print_endline Foo.hello' > clark.ml
$ dune exec --display=quiet ./clark.exe
Hello
```

### Private Definitions and `.mli` Files

It is possible to have definitions inside a module which aren't exposed to other modules. This can be done by associating a `.mli` file to the module that needs to keep some of its definitions for itself. In this example, we add a private `world` string to the `Foo` module. The string `Foo.hello` is visible because it appears inside `foo.mli`:
```sh
$ echo 'let world = "world"' >> foo.ml
$ echo 'let hello = hello ^ " " ^ world ^ "!"' >> foo.ml
$ echo 'val hello : string' > foo.mli
$ dune exec --display=quiet ./clark.exe
Hello world
```

But the string `Foo.world` is not visible from module `Clark` since it does not
appear inside `foo.mli`:
```sh
$ echo 'print_endline Foo.world' > clark.ml
$ dune exec --display=quiet ./clark.exe
File "clark.ml", line 1, characters 14-23:
1 | print_endline Foo.world
                  ^^^^^^^^^
Error: Unbound value Foo.world
```

### Module Nesting

It is possible to define modules inside modules. Continuing with the same
example, we add a module `Baz` inside `Foo` (i.e. `foo.ml`)
```sh
$ rm foo.mli
$ echo 'module Baz = struct let n = 42 end' >> foo.ml
$ echo 'Printf.printf "%i\n" Foo.Baz.n' > clark.ml
$ dune exec --display=quiet ./clark.exe
42
```

### 