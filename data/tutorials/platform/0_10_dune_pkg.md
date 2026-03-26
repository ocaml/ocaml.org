---
id: "dune-pkg"
title: "Managing Dependencies with Dune"
short_title: "Dune Dependencies"
description: |
  How to use Dune's built-in package management with lock files for reproducible builds.
category: "Projects"
prerequisite_tutorials:
  - "managing-dependencies"
  - "opam-path"
---

## Introduction

Dune has built-in package management that can handle your project's dependencies directly, without a separate `opam install` step. Instead of installing packages into an opam switch, dune solves dependencies, writes a **lock directory** to your project, and builds everything — including dependencies — when you run `dune build`.

This approach offers:

- **Reproducibility**: lock files pin exact versions and go into version control
- **Simplicity**: one tool (`dune`) handles both building and dependency management
- **Agent-friendliness**: no environment setup needed beyond having `dune` and a compiler on `PATH`

Dune package management uses the same [opam repository](https://opam.ocaml.org/packages/) as the source for available packages.

> **Note**: Dune package management is a recent feature. Check the [dune documentation](https://dune.readthedocs.io/) for the latest status and supported features.

## Prerequisites

- **Dune 3.17** or later (check with `dune --version`)
- An **opam repository** configured. Dune reads repository information from your opam configuration, so `opam init` must have been run at least once.
- A `dune-project` file with a `(depends ...)` field listing your dependencies

## Setting Up a Project

If your `dune-project` already declares dependencies, you are ready to go. For example:

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

To create the lock directory:

```shell
$ dune pkg lock
Solution for dune.lock:
- alcotest.1.8.0
- dream.1.0.0~alpha8
- ...
```

This creates a `dune.lock/` directory in your project root. **Add it to version control:**

```shell
$ git add dune.lock/
$ git commit -m "Add dependency lock files"
```

## The Lock Directory

The `dune.lock/` directory contains one `.pkg` file per locked dependency. Each file records the package version, source location (URL and checksum), and build instructions. For example, `dune.lock/dream.pkg` might contain:

```
(version 1.0.0~alpha8)
(source (fetch (url https://...) (checksum sha256=...)))
(build ...)
```

The lock directory is a snapshot of your resolved dependency tree. Anyone who clones your repository gets the exact same versions without running a solver.

## Building With Locked Dependencies

Once the lock directory exists, `dune build` handles everything:

```shell
$ dune build
```

Dune automatically fetches source archives, builds dependencies, and then builds your project. There is no need for `opam install . --deps-only`.

Fetched sources and build artifacts are stored under `_build/` alongside your project's own build output.

## Updating Dependencies

To update all dependencies to their latest compatible versions:

```shell
$ dune pkg lock
```

This re-runs the solver and updates `dune.lock/`. Review the changes with `git diff dune.lock/` before committing.

To see what changed:

```shell
$ git diff dune.lock/
```

## Adding and Removing Dependencies

Edit the `(depends ...)` field in your `dune-project` file, then re-lock:

```shell
$ dune pkg lock
```

For example, to add `yojson`:

1. Add `yojson` to the `(depends ...)` list in `dune-project`
2. Run `dune pkg lock`
3. Commit the updated `dune-project` and `dune.lock/`

Removing a dependency is the reverse: remove it from `(depends ...)` and re-lock.

## Using dune pkg With opam Switches

Dune package management replaces `opam install` for your project's dependencies, but you may still use an opam switch for the **compiler** and **development tools** (like `ocaml-lsp-server`, `ocamlformat`, `utop`).

A minimal setup:

```shell
$ opam switch create . ocaml-base-compiler.5.2.1 --deps-only
$ opam install ocaml-lsp-server ocamlformat utop
```

Here opam provides the compiler and editor tools, while dune handles all library dependencies. This keeps your switch lightweight.

Alternatively, if you have a system-installed OCaml compiler, you can skip opam switches entirely and let dune manage everything.

## LLM Coding Agents

Dune package management is particularly well-suited for LLM coding agents (Claude Code, Cursor, Copilot, etc.) because the build workflow is a single command:

```shell
$ dune build
```

There is no need for `eval $(opam env)` or `opam exec --`. As long as `dune` and `ocaml` are on the `PATH`, the agent can build and test without any environment setup. The lock directory ensures every build resolves to the same dependency versions, regardless of when or where the agent runs.

A typical agent configuration (`CLAUDE.md`):

```markdown
## Build commands

  dune build
  dune runtest
```

For more on configuring agents with opam-based workflows, see [The OCaml Development Environment](/docs/opam-path).

## dune pkg vs opam: Choosing Your Workflow

| | **opam** | **dune pkg** |
|---|---|---|
| **Maturity** | Stable, battle-tested | Recent, actively developed |
| **Dependency solving** | At install time | At lock time (offline builds after) |
| **Reproducibility** | Via `opam lock` (optional) | Built-in (lock directory) |
| **Environment setup** | `eval $(opam env)` or `opam exec --` | None (dune handles it) |
| **Pin/overlay support** | Full (`opam pin`) | Supported |
| **Plugin/depext support** | Full (`opam depext`) | Partial |
| **CI / agents** | Requires environment setup | Just `dune build` |
| **Switch management** | Full (global/local switches) | Uses switch for compiler only |

The two approaches can coexist. You can use opam for some projects and dune pkg for others, or use opam for the compiler and dune pkg for libraries within the same project.

## Troubleshooting

**"No opam-repository configured"**

Dune reads repository information from opam. Make sure you have run `opam init` at least once and have a repository configured:

```shell
$ opam repo list
```

**"Version conflict during locking"**

If `dune pkg lock` fails with a conflict, check your version constraints in `(depends ...)`. You may need to relax a bound or remove a conflicting dependency.

**"Stale lock file"**

If you edited `dune-project` but forgot to re-lock, `dune build` may fail because the lock directory does not match the declared dependencies. Run `dune pkg lock` to update.

**"Package not found"**

The package may not be in the opam repository, or your repository index may be outdated. Update with:

```shell
$ opam update
$ dune pkg lock
```
