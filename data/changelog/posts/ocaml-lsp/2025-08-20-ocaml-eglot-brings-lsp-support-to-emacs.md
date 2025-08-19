---
title: Emacs Integration for OCaml LSP Server: Introducing ocaml-eglot
tags: [ocaml-lsp, platform]
---

# Emacs Integration for OCaml LSP Server: Introducing ocaml-eglot

## TL;DR

`ocaml-eglot` provides full OCaml language support in Emacs through the Language Server Protocol (LSP) instead of direct Merlin integration. It offers the same features as `merlin.el` with simplified setup and enhanced capabilities like project-wide search. If you're starting fresh or want a more standardized approach, try `ocaml-eglot`, which is actively maintained. If your current `merlin.el` setup works well, you can continue using it.

**Quick start**: [Install `ocaml-lsp-server`, add `ocaml-eglot` to your Emacs config](https://github.com/tarides/ocaml-eglot?tab=readme-ov-file#installation), and get the same OCaml development experience with less configuration.

## What is ocaml-eglot?

`ocaml-eglot` connects Emacs to `ocaml-lsp-server` using the Language Server Protocol, providing a standardized way to get OCaml language support.

Since the recent versions of Emacs (29), `eglot`, an LSP client, has been shipped with Emacs. However, `merlin.el` provides more features than LSP (which is designed to be generic), so relying solely on the features of LSP and `eglot` would limit functionality. Thus, we extended the LSP server to support more features, and `ocaml-eglot` allows you to benefit from these features in Emacs.

`ocaml-eglot` is a minor mode. It therefore works in conjunction with a major mode to edit Caml code. Examples of major modes include `tuareg`, `caml-mode` and the recent `neocaml`.

## Who Should Use ocaml-eglot?

**Use ocaml-eglot if you:**
- Are starting fresh with OCaml in Emacs
- Want simplified configuration with automatic setup
- Use multiple editors and want consistent OCaml support
- Want access to project-wide search and rename features
- Want to rely on an actively maintained project that evolves over time

**Stick with `merlin.el` if:**
- Your current setup is working perfectly and heavily customized
- You prefer direct Merlin communication

For the moment, we don't plan to provide any special support for `merlin.el` -- unless we receive a lot of requests.

## Key Benefits

- **Simplified setup**: Install package, add config, start coding
- **Same features**: All `merlin.el` functionality with identical keybindings
- **Enhanced capabilities**: Project-wide rename, type-based search, automatic formatting
- **Platform integration**: Works seamlessly with opam, dune, ocamlformat, and other OCaml tools

## Getting Started

Follow the [installation instructions in the ocaml-eglot README](https://github.com/tarides/ocaml-eglot?tab=readme-ov-file#installation).

## Essential Commands

| Feature | Command | Key Binding |
|---------|---------|-------------|
| Show type | `ocaml-eglot-type-enclosing` | `C-c C-t` |
| Jump to definition | `ocaml-eglot-find-definition` | `C-c C-l` |
| Jump to declaration | `ocaml-eglot-find-declaration` | `C-c C-i` |
| Generate patterns | `ocaml-eglot-destruct` | `C-c \|` |
| Fill holes | `ocaml-eglot-construct` | `C-c \` |
| Switch .ml/.mli | `ocaml-eglot-alternate-file` | `C-c C-a` |
| Show documentation | `ocaml-eglot-document` | `C-c C-d` |
| Search by type | `ocaml-eglot-search` | |
| Rename symbol | `ocaml-eglot-rename` | |

For a detailed list of features, see [the ocaml-eglot README](https://github.com/tarides/ocaml-eglot?tab=readme-ov-file#features).

## Migration from merlin.el

1. Install: `opam install ocaml-lsp-server ocamlformat`
2. Replace your Merlin configuration with the `ocaml-eglot` setup above
3. Restart Emacs

Your existing keybindings work immediately.

## Enhanced Features Examples

**Type-based search**: Find functions by signature
```
Search for: string -> int option
Result: String.to_int, Int.of_string, etc.
```

**Project-wide rename** (OCaml 5.2+):
```bash
# Build index first
dune build @ocaml-index
# Then use ocaml-eglot-rename in Emacs
```

**Type search**: Find functions by input/output types
```
Search for: -string +int
Finds functions that take strings and return ints
```

(This function is also available in `merlin.el`.)

## Next Steps

1. Try the basic setup with an existing OCaml project
2. Explore type-based search and project-wide features
3. Provide feedback at [ocaml-eglot's GitHub Issues](https://github.com/tarides/ocaml-eglot/issues)

## Documentation

- [ocaml-eglot README](https://github.com/tarides/ocaml-eglot)
- [OCaml.org editor setup tutorial](https://ocaml.org/docs/set-up-editor#emacs)

## Related Releases

On January 17, 2025, [ocaml-eglot version 1.0.0 was released](https://discuss.ocaml.org/t/ann-release-of-ocaml-eglot-1-0-0/15978/14), providing a new minor emacs mode to enable the editor features provided by **ocaml-lsp-server**. Subsequent releases [1.1.0](https://github.com/tarides/ocaml-eglot/releases/tag/1.1.0) and [1.2.0](https://discuss.ocaml.org/t/ann-release-of-ocaml-eglot-1-2-0/16515) enable support for `flycheck` as a configurable alternative to `flymake` (`1.0.0` release), Emacs `30.1` support, better user experience and error handling, as well as support for new features. 
