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

This tutorial was written with AI assistance and reviewed by the OCaml.org team.

## Introduction

Dune has built-in package management that can handle your project's dependencies directly, without a separate `opam install` step. Instead of installing packages into an opam switch, dune solves dependencies, writes a **lock directory** to your project, and builds everything — including dependencies — when you run `dune build`.

This approach offers:

- **Reproducibility**: lock files pin exact versions and go into version control
- **Simplicity**: one tool (`dune`) handles both building and dependency management
- **No environment setup**: builds need only `dune` and a compiler on `PATH`

Dune package management uses the same [opam repository](https://opam.ocaml.org/packages/) as the source for available packages.

> **Note**: Dune package management is a recent feature. Check the [dune documentation](https://dune.readthedocs.io/) for the latest status and supported features.

## Prerequisites

- **Dune 3.20** or later (check with `dune --version`); this tutorial uses 3.21
- A `dune-project` file with a `(package ...)` stanza declaring your dependencies

Dune package management does not require opam to be initialised. By default, Dune fetches packages directly from the community [`ocaml/opam-repository`](https://github.com/ocaml/opam-repository) (plus the [`ocaml-dune/opam-overlays`](https://github.com/ocaml-dune/opam-overlays) repository, which carries dune-compatible builds of some packages) on GitHub.

## Setting Up a Project

Package management is enabled per workspace. Create a `dune-workspace` file at your project root containing:

```dune
(lang dune 3.21)
(pkg enabled)
```

Then declare your dependencies in `dune-project` with a `(package ...)` stanza. For example:

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
dune pkg lock
Solution for dune.lock:
- alcotest.1.8.0
- dream.1.0.0~alpha8
- ...
```

This creates a `dune.lock/` directory in your project root. **Add it to version control:**

```shell
git add dune.lock/
git commit -m "Add dependency lock files"
```

## The Lock Directory

The `dune.lock/` directory contains one `.pkg` file per locked dependency. Each file records the package version, source location (URL and checksum), and build instructions. For example, `dune.lock/dream.pkg` might contain:

```dune
(version 1.0.0~alpha8)
(source (fetch (url https://...) (checksum sha256=...)))
(build ...)
```

The lock directory is a snapshot of your resolved dependency tree. Anyone who clones your repository gets the exact same versions without running a solver.

## Building With Locked Dependencies

Once the lock directory exists, `dune build` handles everything:

```shell
dune build
```

Dune automatically fetches source archives, builds dependencies, and then builds your project. There is no need for `opam install . --deps-only`.

Fetched sources and build artifacts are stored under `_build/` alongside your project's own build output.

## Updating Dependencies

To update all dependencies to their latest compatible versions:

```shell
dune pkg lock
```

This re-runs the solver and updates `dune.lock/`. Review the changes with `git diff dune.lock/` before committing.

To see what changed:

```shell
git diff dune.lock/
```

## Adding and Removing Dependencies

Edit the `(depends ...)` field in your `dune-project` file, then re-lock:

```shell
dune pkg lock
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
opam switch create . ocaml-base-compiler.5.2.1 --no-install
opam install ocaml-lsp-server ocamlformat utop
```

`--no-install` creates the local switch with just the compiler, without installing the project's dependencies into it (dune handles those). opam then provides the editor tools, keeping the switch lightweight.

Alternatively, if you already have a compiler available — from a system package, or provisioned by dune itself — you can skip opam switches entirely and let dune manage everything.

## LLM Coding Agents

Because the entire build workflow is a single command with no environment setup, dune package management works well in automated environments such as CI and LLM coding agents:

```shell
dune build
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

### Repository or "package not found while locking" errors

By default Dune fetches packages from `ocaml/opam-repository` and `ocaml-dune/opam-overlays` on GitHub — it does not use your opam configuration. If locking cannot reach a repository, check your network access to GitHub, or your custom repository settings if you overrode the defaults in `dune-workspace`.

### "Version conflict during locking"

If `dune pkg lock` fails with a conflict, check your version constraints in `(depends ...)`. You may need to relax a bound or remove a conflicting dependency.

### "Stale lock file"

If you edited `dune-project` but forgot to re-lock, `dune build` may fail because the lock directory does not match the declared dependencies. Run `dune pkg lock` to update.

### "Package not found"

The package may not exist in `ocaml/opam-repository` (or the overlays), or it may be published under a different name. Dune fetches the latest repository state each time you lock, so re-running the lock picks up newly published packages:

```shell
dune pkg lock
```
