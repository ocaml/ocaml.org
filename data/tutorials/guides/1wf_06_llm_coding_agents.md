---
id: "llm-coding-agents"
title: "OCaml for LLM Coding Agents"
short_title: "LLM Agents"
description: |
  How to configure LLM coding agents for OCaml projects, extend their knowledge, and work around their limitations.
category: "Workflow"
prerequisite_tutorials:
  - "opam-path"
---

## Introduction

LLM coding agents (Claude Code, Cursor, GitHub Copilot, etc.) can be productive with OCaml. The type system catches many agent mistakes at compile time, and the module system makes codebases navigable. But agents need specific configuration and tooling to work well — OCaml has less training data than mainstream languages, and the toolchain has conventions that agents don't always know.

This guide covers how to set up a project for agent use, write effective configuration files, extend agent knowledge with MCP servers, and work around common limitations.

## Environment Setup

Agents run each shell command in a **fresh process** — the effect of `eval $(opam env)` does not persist between commands. There are two approaches:

**opam exec** (works with any project):
```shell
opam exec -- dune build
opam exec -- dune runtest
```

Prefix every OCaml tool command with `opam exec --`. See [The OCaml Development Environment](/docs/opam-path) for details.

**dune package management** (simpler, for projects that use it):
```shell
dune build
dune runtest
```

No environment setup needed — dune handles dependencies directly. See [Managing Dependencies with Dune](/docs/dune-pkg) for details.

## Writing an Effective Configuration File

Most agents read a project-level configuration file to learn how to work with the codebase. The file name varies:

| Agent | File |
|-------|------|
| Claude Code | `CLAUDE.md` |
| Cursor | `.cursorrules` |
| GitHub Copilot | `.github/copilot-instructions.md` |

The content should be similar regardless of agent. Here's what to include:

### Build and test commands

Always list the exact commands. Agents should not have to guess:

```markdown
## Build commands

    opam exec -- dune build
    opam exec -- dune runtest
    opam exec -- dune fmt
```

### Project architecture

Describe what lives where and how the pieces connect:

```markdown
## Architecture

- `lib/` — core library (`Myapp` module namespace)
- `bin/` — entry point (`main.ml`)
- `test/` — tests using Alcotest
- `lib/parser.mli` — the key interface, read this first
```

### Libraries and conventions

List the main libraries the project uses. Agents hallucinate package names and APIs — being explicit prevents this:

```markdown
## Key libraries

- `Dream` — web framework (routing, middleware, responses)
- `Yojson` — JSON parsing and generation
- `Caqti` — database access (SQL queries)
- `Alcotest` — test framework

## Conventions

- Error handling: use `Result.t`, not exceptions
- Formatting: `ocamlformat` (run `dune fmt`)
- All public functions must have `.mli` signatures
```

### How to run specific tests

```markdown
## Testing

Run all tests:
    opam exec -- dune runtest

Run a single test file:
    opam exec -- dune exec test/test_parser.exe
```

### Example: Complete CLAUDE.md

```markdown
# CLAUDE.md

## Build commands

    opam exec -- dune build
    opam exec -- dune runtest
    opam exec -- dune fmt

## Architecture

This is a web API built with Dream. The code is structured as:
- `lib/` — library `My_api` (wrapped): models, handlers, middleware
- `bin/main.ml` — server entry point
- `test/` — Alcotest tests

## Key libraries

- Dream (web framework), Yojson (JSON), Caqti (database)
- ppx_deriving for `show` and `eq` derivations

## Conventions

- Use `Result.t` for errors, not exceptions
- All handlers return `Dream.response Lwt.t`
- Run `dune fmt` before committing
```

## Extending Agent Knowledge with MCP

Agents have limited OCaml training data. [MCP (Model Context Protocol)](https://modelcontextprotocol.io/) servers compensate by giving agents live access to documentation and package information.

### ocaml-docs MCP server

The [`ocaml-docs`](https://github.com/emillon/ocaml-docs-mcp) MCP server provides:
- **Package search**: find packages by keyword
- **Module documentation**: look up function signatures and doc comments
- **API lookup**: find what a specific function does

This lets agents answer "what function parses JSON?" by querying the actual documentation instead of guessing.

### LSP integration

Some agents can use the Language Server Protocol (via `ocaml-lsp-server`) for:
- Type information on hover
- Go-to-definition
- Autocompletion

If your agent supports LSP, ensure `ocaml-lsp-server` is installed in your switch:

```shell
opam install ocaml-lsp-server
```

### odoc Markdown output

Recent versions of `odoc` can generate Markdown instead of HTML, which is easier for agents to consume. Community projects are building on this to make OCaml documentation more accessible to LLMs.

## What Agents Are Good At

OCaml's type system is a natural fit for agents in several ways:

- **Writing new modules following existing patterns**: give the agent an example module and an `.mli` signature, and it can usually produce a correct implementation
- **Adding test cases**: especially with Alcotest, where the pattern is repetitive
- **Refactoring**: renaming, adding fields to records, updating match cases across files — the compiler catches mistakes
- **Mechanical tasks**: formatting, adding type annotations, converting between equivalent patterns
- **Fixing type errors** (when guided): the compiler's error messages give agents enough information to fix most type mismatches

The key advantage: OCaml's compiler catches agent mistakes *before* runtime. In dynamically typed languages, an agent's mistake might not surface until production.

## What Agents Struggle With

- **Interpreting complex type errors**: nested types, polymorphic variants, and GADT errors confuse agents. See [Reading OCaml Errors](/docs/reading-errors) for the method agents should follow.
- **dune file syntax**: agents often produce broken s-expressions. Include example dune stanzas in your configuration file.
- **Module/file mapping**: agents don't always understand that `Mylib.Foo` means `foo.ml` inside the `mylib` library directory. Explain your wrapping conventions in the config file.
- **Package selection**: agents hallucinate package names. List your project's libraries explicitly or use MCP servers for lookup.
- **Advanced type system features**: GADTs, first-class modules, modular implicits, and complex functor applications are beyond most agents' reliable capability.
- **PPX-generated code**: agents can't see the output of PPX transformations and may misunderstand the available API.

## Structuring Projects for Agent Success

Some project practices make agents more effective:

**Write `.mli` files**: agents read interfaces to understand what a module provides. An `.mli` is a concise summary — much better than reading the full implementation.

**Use explicit type annotations on public functions**: this helps agents understand the expected types without tracing through the code.

**Keep modules focused**: one concept per module. Agents navigate by module name, so `User.ml`, `Auth.ml`, `Handler.ml` are easier to work with than a single `Lib.ml`.

**Put tests near code**: agents look for test files to understand expected behaviour and to add new tests. A clear `test/` directory with files named after what they test (`test_parser.ml`, `test_handler.ml`) helps.

**Run `dune fmt` in CI**: agents produce inconsistently formatted code. Automated formatting on commit normalises this.

**Keep the configuration file updated**: as your project evolves, update the agent configuration. An outdated config is worse than none — it actively misleads.
