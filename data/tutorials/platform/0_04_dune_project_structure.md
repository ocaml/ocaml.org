---
id: "dune-project-structure"
title: "Dune Project Structure"
short_title: "Project Structure"
description: |
  How files, modules, and dune stanzas fit together in an OCaml project.
category: "Projects"
prerequisite_tutorials:
  - "bootstrapping-a-dune-project"
recommended_next_tutorials:
  - "libraries-dune"
  - "creating-libraries"
---

## Introduction

A dune project is a directory tree with a `dune-project` file at the root and `dune` files in subdirectories. Each `dune` file tells dune what to build from the source files in that directory.

This tutorial explains how OCaml files map to modules, how the main dune stanzas work, and how to perform common tasks like adding modules, dependencies, and libraries. If you haven't created a project yet, start with [Bootstrapping a Project with Dune](/docs/bootstrapping-a-dune-project).

## Files and Modules

In OCaml, each source file defines a module automatically:

- `foo.ml` defines module `Foo` (the name is capitalised)
- `foo.mli` defines the **signature** (interface) for module `Foo`

There is no `import` statement or module declaration needed — the file *is* the module. If both `foo.ml` and `foo.mli` exist, the `.mli` controls what is visible to other modules. Anything not listed in the `.mli` is private.

```text
lib/
  parser.ml      → module Parser (implementation)
  parser.mli     → module Parser (interface — restricts what's visible)
  utils.ml       → module Utils
```

This is the foundation: everything else in dune builds on this file-to-module mapping.

## The `dune-project` File

Every project has exactly one `dune-project` at its root. It declares the dune language version and, optionally, package metadata:

```dune
(lang dune 3.17)
(name my_project)

(package
 (name my_project)
 (depends
  (ocaml (>= 5.2))
  dune
  dream
  (alcotest :with-test)))
```

**Key distinction**: `(depends ...)` here declares what the package manager installs (opam or dune pkg). It does not affect compilation directly. For that, you use `(libraries ...)` in `dune` files. When adding a new dependency, you must update **both**.

## Library Stanzas

A `dune` file with a `(library ...)` stanza turns a directory into a library:

```dune
(library
 (name mylib)
 (libraries dream yojson))
```

All `.ml` files in the directory become modules in the library. Dune **wraps** them by default: if the library is named `mylib`, then `foo.ml` becomes `Mylib.Foo` and `bar.ml` becomes `Mylib.Bar`. This namespacing prevents conflicts — two libraries can each have a `utils.ml` without clashing.

### Public vs internal libraries

- `(name mylib)` alone creates an **internal** library, usable only within the project
- Adding `(public_name mylib)` makes it installable and available to other projects

### Wrapping

Wrapping is on by default and is almost always what you want. If you write a manual wrapper file (`mylib.ml`), it takes precedence over the auto-generated one, letting you control which modules are exposed and under what names:

```ocaml
(* mylib.ml — manual wrapper *)
module Parser = Parser
module Utils = Utils
(* Internal_helper is not listed, so it's hidden *)
```

`(wrapped false)` disables wrapping, exposing all modules at the top level. Avoid this in libraries — it causes hard-to-debug errors when two libraries define modules with the same name:

```text
Error: The files foo/.foo.objs/byte/utils.cmi
       and bar/.bar.objs/byte/utils.cmi
       make inconsistent assumptions over interface Utils
```

The fix is always wrapping (the default).

## Executable Stanzas

A `dune` file with an `(executable ...)` stanza builds a program:

```dune
(executable
 (name main)
 (libraries mylib))
```

The entry point is `main.ml`. To use modules from `mylib`:

```ocaml
(* main.ml *)
let () =
  let result = Mylib.Parser.parse input in
  print_endline (Mylib.Utils.to_string result)
```

Or with `open`:

```ocaml
open Mylib

let () =
  let result = Parser.parse input in
  print_endline (Utils.to_string result)
```

Adding `(public_name my_program)` installs the binary.

## Test Stanzas

```dune
(test
 (name test_main)
 (libraries mylib alcotest))
```

The entry point is `test_main.ml`. Run all tests with:

```shell
dune runtest
```

Use `(tests (names test_a test_b) (libraries ...))` for multiple test executables sharing the same configuration.

## Typical Project Layout

Here is a small but complete project:

```text
my_project/
  dune-project
  bin/
    dune              (executable (name main) (libraries my_project))
    main.ml
  lib/
    dune              (library (name my_project) (libraries dream))
    server.ml
    handler.ml
    handler.mli
  test/
    dune              (test (name test_handler) (libraries my_project alcotest))
    test_handler.ml
```

How everything connects:

| File | Module | Accessible as |
|------|--------|---------------|
| `lib/server.ml` | `Server` | `My_project.Server` |
| `lib/handler.ml` | `Handler` | `My_project.Handler` |
| `lib/handler.mli` | (interface) | restricts `Handler`'s public API |
| `bin/main.ml` | `Main` | entry point — uses `open My_project` |
| `test/test_handler.ml` | `Test_handler` | test entry point |

## How Dune Builds

A few useful details about dune's build model:

- **Content hashes, not timestamps**: dune tracks whether a file's content has changed, not when it was last saved. Saving a file without changes does not trigger a rebuild. This is how `dune build --watch` stays efficient.

- **Automatic dependency inference**: for OCaml files, dune infers which modules depend on which. You don't need to list individual modules — just declare the libraries.

- **Rule scoping**: build targets must be in the current directory or below. Dependencies can reference files anywhere in the project. Circular dependencies are forbidden.

## Common Tasks

### Adding a new module

Create `new_module.ml` (and optionally `new_module.mli`) in the library's directory. Dune discovers it automatically on the next build. It becomes `Mylib.New_module`.

### Adding a dependency

Two places must be updated:

1. `(libraries ...)` in the `dune` file where the dependency is used — this tells the compiler
2. `(depends ...)` in `dune-project` — this tells the package manager

For example, to add `yojson`:

```dune
; In lib/dune, add yojson to libraries:
(library
 (name my_project)
 (libraries dream yojson))
```

```dune
; In dune-project, add yojson to depends:
(package
 (name my_project)
 (depends
  (ocaml (>= 5.2))
  dune
  dream
  yojson))
```

Then install it: `opam install yojson` (or re-lock with `dune pkg lock` if using dune package management).

### Creating a new library

Create a new directory with a `dune` file:

```text
lib/
  utils/
    dune              (library (name utils) (libraries ...))
    string_ext.ml
    list_ext.ml
```

Then add `utils` to `(libraries ...)` wherever it's needed.

### Adding a preprocessor (PPX)

Add a `(preprocess ...)` field to the stanza:

```dune
(library
 (name my_project)
 (libraries dream yojson)
 (preprocess (pps ppx_deriving.show ppx_sexp_conv)))
```

Common PPXs: `ppx_deriving` (show, eq, ord, etc.), `ppx_sexp_conv` (S-expression serialisation), `ppx_inline_test` and `ppx_expect` (inline tests).

## Troubleshooting

### "Unbound module Foo"

This almost always means `(libraries ...)` in the `dune` file is missing the library that provides `Foo`. It is a dune configuration issue, not a code error. Check what library provides the module (e.g., `yojson` provides `Yojson`) and add it.

### "Module X is listed in more than one stanza"

Two stanzas in the same directory both claim the same `.ml` file. Use the `(modules ...)` field to split files between stanzas, or move one stanza to a subdirectory.

### "Inconsistent assumptions over interface X"

Two unwrapped libraries both define a module with the same name. Use wrapped libraries (the default) to avoid this.

### Build doesn't pick up a new file

Dune auto-discovers `.ml` files. If a new file isn't picked up, check that it's in a directory with a `dune` file containing a `library`, `executable`, or `test` stanza.
