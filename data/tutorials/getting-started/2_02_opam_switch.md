---
id: opam-switch-introduction
title: Introduction to opam Switches
description: |
  This page will give you a brief introduction to opam switches, what they're used for, and how to create them.
category: "Tooling"
recommended_next_tutorials:
  - "managing-dependencies"
---

## What Is an opam Switch?

An opam switch is an isolated OCaml environment. Each switch has its own OCaml compiler, installed packages, and binaries, all independent from other switches. This is similar to Python's `virtualenv` or Node's `nvm`: you can have multiple OCaml setups side by side without them interfering with each other.

After [installing OCaml](/docs/installing-ocaml), you'll have a single switch called `default`.

## Global vs. Local Switches

There are two kinds of switches:

- **Global switches** are named environments stored under `~/.opam/<switch-name>/`. They aren't tied to any project directory. Your `default` switch is a global switch.
- **Local switches** are tied to a specific project directory and stored in an `_opam/` folder inside it. When you `cd` into a directory with a local switch, opam automatically uses it.

**For project work, we recommend local switches.** They keep each project's dependencies isolated and make it easy for collaborators to reproduce your setup.

## Listing Available Compilers

Before creating a switch, you'll need to pick a compiler version:

```shell
opam switch list-available ocaml-base-compiler
```

This lists all available compiler versions. Pick the latest stable version unless you have a reason not to.

Omitting `ocaml-base-compiler` shows the full list, including compiler variants with additional options enabled (such as flambda optimisations or frame pointers). These are useful for advanced use cases but not needed to get started.

## Creating a Global Switch

To create a named global switch:

```shell
opam switch create my_switch 5.4.0
```

Then update your shell environment:

```shell
eval $(opam env)
```

This switch is now available from any directory. It lives at `~/.opam/my_switch/`.

## Creating a Local Switch

To create a switch tied to your project, run this from inside the project directory:

```shell
opam switch create . 5.4.0
```

Then update your shell environment:

```shell
eval $(opam env)
```

This creates an `_opam/` directory in your project. Whenever you `cd` into this directory, opam will automatically select this switch.

If the directory contains `.opam` files, opam will automatically install their dependencies into the new switch. You can prevent this with `opam switch create . 5.4.0 --no-install`.

## Listing Your Switches

```shell
opam switch list
```

The arrow `->` marks the currently active switch:

```shell
#   switch                      compiler      description
->  /home/user/my_project       ocaml.5.4.0   /home/user/my_project
    default                     ocaml.5.4.0   default
```

## Switching Between Switches

To manually select a global switch:

```shell
opam switch set my_switch
eval $(opam env)
```

The `eval $(opam env)` step is important — it updates your shell's `PATH` and other environment variables so that `ocaml`, `dune`, and other tools point to the right switch. Without it, your shell will still use the previously active switch.

Local switches are selected automatically when you `cd` into their directory, but you still need to run `eval $(opam env)` (or use a tool like [direnv](/docs/opam-path)) to update the shell environment.

## Removing a Switch

To delete a switch you no longer need:

```shell
opam switch remove my_switch
```

For a local switch, use the path:

```shell
opam switch remove /home/user/my_project
```

---

> Learn more about opam switches in the [opam manual](https://opam.ocaml.org/doc/Manual.html) and the [opam-switch reference](https://opam.ocaml.org/doc/man/opam-switch.html).
