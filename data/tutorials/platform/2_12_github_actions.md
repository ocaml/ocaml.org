---
id: "setup-ocaml"
title: "OCaml GitHub Action"
short_title: "GitHub Action"
description: |
  Using the setup-ocaml GitHub Action to set up CI workflows for OCaml projects
category: "Additional Tooling"
---

## `setup-ocaml`

[`setup-ocaml`](https://github.com/ocaml/setup-ocaml) is an action that provides an OS-neutral interface to `opam`, and so will not add features that only work on one operating system. It is the _de-facto_ standard for OCaml CI workflows. It is maintained by Sora Morimoto ([@smorimoto](https://github.com/smorimoto)).

### Basic Usage

Create `.github/workflows/ci.yml`:

```yaml
name: CI

on: [push, pull_request]

jobs:
  build:
    strategy:
      matrix:
        os: [ubuntu-latest, macos-latest, windows-latest]
        ocaml-compiler: [5, 4.14]
    runs-on: ${{ matrix.os }}
    steps:
      - uses: actions/checkout@v4
      - uses: ocaml/setup-ocaml@v3
        with:
          ocaml-compiler: ${{ matrix.ocaml-compiler }}
      - run: opam install . --deps-only --with-test
      - run: opam exec -- dune build
      - run: opam exec -- dune runtest
```

### Built-in Linting Extensions

The action includes several linting sub-actions:

Check source code formatting
```yaml
  lint-fmt:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: ocaml/setup-ocaml@v3
        with:
          ocaml-compiler: 5
      - uses: ocaml/setup-ocaml/lint-fmt@v3    # Check ocamlformat
```

Lint opam package files
```yaml
  lint-opam:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: ocaml/setup-ocaml@v3
        with:
          ocaml-compiler: 5
      - uses: ocaml/setup-ocaml/lint-opam@v3  # Lint opam files
```

Check documentation builds
```yaml
  lint-doc:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: ocaml/setup-ocaml@v3
        with:
          ocaml-compiler: 5
      - uses: ocaml/setup-ocaml/lint-doc@v3   # Check documentation
```

### Key Features

| Feature | Input | Description |
|---------|-------|-------------|
| Compiler version | `ocaml-compiler: 5.2` | Supports semver syntax |
| Compiler variants | `ocaml-compiler: ocaml-variants.5.2.0+options,ocaml-option-flambda` | Flambda, etc. |
| Dune cache | `dune-cache: true` | Speed up builds |
| Custom opam repo | `opam-repositories: ...` | Use custom/pinned repos |
| Disable sandbox | `opam-disable-sandboxing: true` | For Docker/containers |

### Cross-Platform Support

Works on Linux, macOS, and Windows with the same workflow file. The action handles platform-specific opam setup automatically.

## OCaml-CI _vs_ GitHub Actions

| Aspect | OCaml-CI | GitHub Actions + setup-ocaml |
|--------|----------|------------------------------|
| Configuration | Zero (reads opam/dune files) | Manual YAML workflow |
| Platforms | Linux, macOS (experimental) | Linux, macOS, Windows |
| Multi-version testing | Automatic from opam constraints | Manual matrix setup |
| Lower-bound testing | Built-in (experimental) | DIY |
| Caching | Automatic, smart | Manual with `dune-cache: true` |
| Approval needed | Yes (allowlist) | No |

Many projects use both: [OCaml-CI](/docs/ocaml-ci) for comprehensive automated testing, and GitHub Actions for quick feedback and Windows support.
