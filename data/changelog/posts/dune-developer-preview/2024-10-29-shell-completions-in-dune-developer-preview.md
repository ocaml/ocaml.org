---
title: "Dune Developer Preview: Shell Completions in Dune Developer Preview"
tags: [dune, developer-preview]
---

_Discuss this post on [Discuss](https://discuss.ocaml.org/t/shell-completions-in-dune-developer-preview/15522)!_

Support for dune shell completions for bash and zsh has just landed in the
[Dune Developer Preview](https://preview.dune.build/)!

Running the [installer](https://preview.dune.build/#download) adds a snippet to
your shell config (e.g. ~/.bashrc) that installs a completion handler for `dune`.
The completion script was taken from
[here](https://github.com/gridbugs/dune-completion-scripts), and that page has
some information about how the script was generated. Once it's installed the
completions will work any time `dune` is typed at the start of a command, so
you can still use the completions when running a version of Dune installed with
Opam or your system package manager after installing the Dune Developer Preview.

Currently only command completions are supported. So you can run:
```
$ dune c<TAB>
cache  clean  coq
```
...or:
```
$ dune build -<TAB>
--action-stderr-on-success
--action-stdout-on-success
--always-show-command-line
--auto-promote
--build-dir
--build-info
--cache
...
```
But if you run `dune build <TAB>` then it will still suggest
local files rather than build targets.

## Try it out!

Getting started is easy:

```
$ curl -fsSL https://get.dune.build/install | sh
$ source ~/.bashrc  # or: source ~/.zshrc
$ dune <TAB>
build
cache
clean
coq
describe
diagnostics
exec
...
```
