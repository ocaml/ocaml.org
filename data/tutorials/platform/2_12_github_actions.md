---
id: "setup-ocaml"
title: "OCaml GitHub Action"
short_title: "GitHub Action"
description: |
  :OCaml official docker images, what they are, what they provide, how to use them
category: "Additional Tooling"
---

## setup-ocaml — [github.com/ocaml/setup-ocaml](https://github.com/ocaml/setup-ocaml)

This action aims to provide an OS-neutral interface to `opam`, and so will not add features that only work on one operating system.

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

Check documentation
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

Check documentation
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

<table>
<thead>
  <tr>
    <th>Feature</th>
    <th>Input</th>
    <th>Description</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td>Compiler version</td>
    <td><code>ocaml-compiler: 5.2</code></td>
    <td>Supports semver syntax</td>
  </tr>
  <tr>
    <td>Compiler variants</td>
    <td><code>ocaml-compiler: ocaml-variants.5.2.0+options,ocaml-option-flambda</code></td>
    <td>Flambda, etc.</td>
  </tr>
  <tr>
    <td>Dune cache</td>
    <td><code>dune-cache: true</code></td>
    <td>Speed up builds</td>
  </tr>
  <tr>
    <td>Custom opam repo</td>
    <td><code>opam-repositories: ...</code></td>
    <td>Use custom/pinned repos</td>
  </tr>
  <tr>
    <td>Disable sandbox</td>
    <td><code>opam-disable-sandboxing: true</code></td>
    <td>For Docker/containers</td>
  </tr>
</tbody>
</table>

### Cross-Platform Support

Works on Linux, macOS, and Windows with the same workflow file. The action handles platform-specific opam setup automatically.

## OCaml-CI _vs_ GitHub Actions

<table>
<thead>
  <tr>
    <th>Aspect</th>
    <th>OCaml-CI</th>
    <th>GitHub Actions + setup-ocaml</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td>Configuration</td>
    <td>Zero (reads opam/dune files)</td>
    <td>Manual YAML workflow</td>
  </tr>
  <tr>
    <td>Platforms</td>
    <td>Linux, macOS (experimental)</td>
    <td>Linux, macOS, Windows</td>
  </tr>
  <tr>
    <td>Multi-version testing</td>
    <td>Automatic from opam constraints</td>
    <td>Manual matrix setup</td>
  </tr>
  <tr>
    <td>Lower-bound testing</td>
    <td>Built-in (experimental)</td>
    <td>DIY</td>
  </tr>
  <tr>
    <td>Caching</td>
    <td>Automatic, smart</td>
    <td>Manual with <code>dune-cache: true</code></td>
  </tr>
  <tr>
    <td>Approval needed</td>
    <td>Yes (allowlist)</td>
    <td>No</td>
  </tr>
</tbody>
</table>

Many projects use both: [OCaml-CI](/docs/ocaml-ci) for comprehensive automated testing, and GitHub Actions for quick feedback and Windows support.
