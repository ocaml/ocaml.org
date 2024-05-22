---
id: "install-a-specific-ocaml-compiler-version"
title: "Installing a Specific OCaml Compiler Version"
short_title: "Installing a Specific Compiler Version"
description: |
  How to install a specific version of OCaml
category: "Projects"
---

> **TL;DR**
> 
> Use `opam switch set` to manually select the switch to use and use `dune-workspace` to automatically run commands in different environment.

Compilation environments are managed with opam switches. The typical workflow is to have a local opam switch for the project, but you may need to select a different compilation environment (i.e. a different compiler version) sometimes. For instance, to run unit tests on an older/newer version of OCaml.

To do this, you'll need to create global opam switches. To create an opam switch with a given version of the compiler, you can use:

```
opam switch create 4.14.0 ocaml-base-compiler.4.14.0
```

This will create a new switch called `4.14.0` with the compiler version `4.14.0`.

The list of available compiler version can be retrieved with:

```
opam switch list-available
```

This will list the available compiler version for all of the configured Opam repositories.

Once you've created a switch (or you already have a switch you'd like to use), you can run:

```
opam switch set <switch_name>
eval $(opam env)
```

to configure the current environment with this switch.

If it is a new switch, you will need to reinstall your dependencies (see "Installing dependencies") with `opam install . --deps-only`.

Alternatively, you may want to automatically run commands in a given set of compilation environments. To do this, you can create a file `dune-workspace` at the root of your project and list the opam switches you'd like to use there:


```
(lang dune 2.0)
(context (opam (switch 4.11.0)))
(context (opam (switch 4.12.0)))
(context (opam (switch 4.13.0)))
```

All the Dune commands you will run, will be run on all of the switches listed. For instance with the definition above:

```
dune runtest --workspace dune-workspace
```

Dune will run the tests for OCaml `4.11.0`, `4.12.0` and `4.13.0`.
