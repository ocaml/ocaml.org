---
id: "opam-path"
title: "The OCaml Development Environment"
short_title: "Development Environment"
description: |
  How opam sets up your environment, the difference between eval $(opam env) and opam exec, platform-specific setup, and configuring LLM coding agents.
category: "Projects"
prerequisite_tutorials:
  - "opam-switch-introduction"
---

## Introduction

OCaml tools — the compiler, build system, LSP server, formatter — are installed inside an [opam switch](/docs/opam-switch-introduction). Your shell needs to know where to find them. There are three ways to do this:

1. **`eval $(opam env)`** — configure your current shell session
2. **`opam exec --`** — run a single command in the switch environment
3. **direnv** — automatically configure the environment per directory

This tutorial explains how each method works, when to use which, and how to set things up on Linux, macOS, and Windows. It also covers configuring LLM coding agents like Claude Code, Cursor, or Copilot.

## What an opam Switch Sets Up

An opam switch is a self-contained OCaml installation with its own compiler, libraries, and tools. When you activate a switch, opam sets several environment variables so your shell can find everything:

| Variable | Purpose |
|----------|---------|
| `PATH` | Locates executables: `ocaml`, `dune`, `ocamlformat`, `ocaml-lsp-server`, etc. |
| `OPAM_SWITCH_PREFIX` | Root directory of the active switch |
| `CAML_LD_LIBRARY_PATH` | Locates C stub libraries (`.so` on Linux, `.dylib` on macOS, `.dll` on Windows) |
| `OCAML_TOPLEVEL_PATH` | Locates toplevel scripts so `#require` works in `utop` and `ocaml` |
| `MANPATH` | Locates man pages for installed tools |

You can see exactly what opam would set by running:

```shell
opam env
```

This prints shell commands that export these variables. The three methods below differ in *how* and *when* those exports are applied.

## Method 1: `eval $(opam env)`

This evaluates opam's output directly in your shell, setting the variables for your current session.

**Linux and macOS (bash or zsh):**
```shell
eval "$(opam env)"
```

**fish:**
```shell
eval (opam env)
```

**Windows PowerShell:**
```powershell
(& opam env) -split '\r?\n' | ForEach-Object { Invoke-Expression $_ }
```

**Windows cmd:**
```cmd
for /f "tokens=*" %i in ('opam env') do @%i
```

Most users add this to their shell profile (`~/.bashrc`, `~/.zshrc`, `config.fish`, etc.) so the environment is configured automatically on every new shell.

**When to use:** Interactive development. You open a terminal, the environment is ready.

**Caveats:**
- It mutates your shell's state. If you switch to a different opam switch with `opam switch`, you need to re-run `eval $(opam env)`.
- It only affects the current shell session. Child processes and other terminals are not affected unless they also eval.
- It does not work in non-interactive contexts where there is no shell to eval into (scripts, CI, agents).

## Method 2: `opam exec --`

This runs a single command with the switch environment set, without modifying your shell:

```shell
opam exec -- dune build
opam exec -- ocaml
opam exec -- ocamlfind list
```

The `--` separates opam's own arguments from the command to execute. Everything after `--` is run as a subprocess with the correct `PATH`, `CAML_LD_LIBRARY_PATH`, etc.

To target a specific switch:

```shell
opam exec --switch=4.14.2 -- ocaml --version
```

**When to use:** Scripts, Makefiles, CI pipelines, LLM coding agents — any context where you want a self-contained command that doesn't depend on prior shell setup.

**Why it's often the better choice:** It is stateless and idempotent. The command always runs in the correct environment regardless of what the parent shell has (or hasn't) configured. There is no risk of a stale environment.

## Method 3: direnv

[direnv](https://direnv.net/) automatically loads and unloads environment variables when you `cd` into a directory. It is especially useful with [local opam switches](/docs/opam-switch-introduction).

**1. Install direnv** using your system package manager.

**2. Hook direnv into your shell.** Add to your shell profile:

```shell
# bash (~/.bashrc)
eval "$(direnv hook bash)"

# zsh (~/.zshrc)
eval "$(direnv hook zsh)"

# fish (~/.config/fish/config.fish)
direnv hook fish | source
```

**3. Create a `.envrc` file** in your project directory:

```shell
eval $(opam env)
```

**4. Allow direnv** to load it:

```shell
direnv allow
```

Now, whenever you enter the project directory, direnv automatically sets up the switch environment:

```text
direnv: loading ~/my-project/.envrc
direnv: export ~CAML_LD_LIBRARY_PATH ~MANPATH ~OCAML_TOPLEVEL_PATH ~OPAM_SWITCH_PREFIX ~PATH
```

And when you leave:

```text
direnv: unloading
direnv: export ~PATH
```

## Choosing a Method

These methods are not mutually exclusive. A common setup:

- **Shell profile:** `eval $(opam env)` for your default switch
- **Per-project:** direnv with a local switch
- **Makefile / CI:** `opam exec -- dune build`
- **LLM coding agents:** `opam exec -- dune build` (agents run each command in a fresh shell)

As a rule of thumb:

| Context | Recommended method |
|---------|-------------------|
| Interactive terminal (daily use) | `eval $(opam env)` in shell profile, or direnv |
| Scripts and Makefiles | `opam exec -- <cmd>` |
| CI pipelines | `opam exec -- <cmd>` |
| LLM coding agents | `opam exec -- <cmd>` |

## LLM Coding Agents

LLM coding agents (Claude Code, Cursor, GitHub Copilot, etc.) run shell commands on your behalf, but each command typically runs in a **fresh shell** — the effect of `eval $(opam env)` does not persist between commands. This means agents must use `opam exec --` for every OCaml-related command.

Most agents read a project-level configuration file to learn how to build and test. Create one at the root of your project:

**CLAUDE.md** (for Claude Code):
```markdown
## Build commands

  opam exec -- dune build
  opam exec -- dune runtest
  opam exec -- dune fmt
```

**Similar files** exist for other agents (`.cursorrules`, `.github/copilot-instructions.md`, etc.). The key content is the same: always prefix OCaml tool commands with `opam exec --`.

If you find this repetitive, consider using [dune's built-in package management](/docs/dune-pkg), which reduces the need for opam environment setup at build time.

## Other OCaml Environment Variables

Beyond what opam sets, several environment variables control OCaml tools directly:

| Variable | Purpose | Example |
|----------|---------|---------|
| `OCAMLRUNPARAM` | Runtime behaviour: enable backtraces (`b`), tune GC (`s`, `a`) | `OCAMLRUNPARAM=b ./my_program` |
| `OCAML_COLOR` | Compiler diagnostic colours: `auto`, `always`, `never` | `OCAML_COLOR=always` |
| `OCAMLLIB` | Standard library directory (set by opam, rarely changed manually) | — |
| `OCAMLPATH` | Additional search paths for `ocamlfind` / findlib | `OCAMLPATH=/extra/lib` |
| `DUNE_BUILD_DIR` | Override where dune puts `_build` | `DUNE_BUILD_DIR=/tmp/build` |
| `DUNE_CACHE` | Enable the shared build cache | `DUNE_CACHE=enabled` |
| `DUNE_WORKSPACE` | Override the workspace file | `DUNE_WORKSPACE=dune-workspace.dev` |

For `OCAMLRUNPARAM` details, see the [debugging](/docs/debugging) and [garbage collector](/docs/garbage-collector) tutorials. The full list is in the [OCaml manual's runtime section](https://ocaml.org/manual/runtime.html).

## Platform Notes

### Linux

Standard setup. When running inside **Docker containers**, opam requires sandboxing to be disabled:

```shell
opam init --disable-sandboxing
```

### macOS

On **Apple Silicon** (M1/M2/M3/M4), Homebrew installs to `/opt/homebrew`. Opam picks this up automatically, but if you install system C libraries via Homebrew (e.g., `libev`, `gmp`), they are found through `pkg-config`. Ensure `pkg-config` is installed:

```shell
brew install pkg-config
```

If you encounter issues with C library detection, see the [ARM64 fix](/docs/arm64-fix) page.

### Windows

OCaml on Windows works through one of:

- **[DkML](https://diskuv.com/dkml/)** — a native Windows OCaml distribution using MSVC
- **WSL2** — run Linux OCaml inside Windows Subsystem for Linux
- **Cygwin** — POSIX compatibility layer

See [OCaml on Windows](/docs/ocaml-on-windows) for detailed setup instructions.

Note that on Windows, opam disables sandboxing by default, and path separators differ (`;` instead of `:` in `PATH`, `\` in file paths).

## Troubleshooting

### "Command not found" after installing a package

You installed a package with `opam install` but the command is not found. Either:
- Run `eval "$(opam env)"` to refresh your shell environment, or
- Use `opam exec -- <command>` to run it directly

### "Wrong compiler version"

Your shell has a stale environment from a different switch. Run `eval "$(opam env)"` again, or use `opam exec --` which always uses the correct switch.

### "Cannot load shared library" / dynamic linking errors

The `CAML_LD_LIBRARY_PATH` variable may not be set correctly. This happens when `eval $(opam env)` was not run after installing a package with C stubs. Run `eval "$(opam env)"` or use `opam exec --`.
