---
id: "configuring-your-editor"
title: "Configuring Your Editor"
short_title: "Configuring Your Editor"
description: |
  How to set up Editor support for OCaml on VSCode, Vim and Emacs
category: "Best Practices"
---

# Configuring Your Editor

OCaml has plugins for many editors, but the most actively maintained are for Visual Studio Code, Emacs, and Vim.

## Visual Studio Code

> **TL;DR**
> 
> Install the VSCode extension `ocamllabs.ocaml-platform` and the packages `ocaml-lsp-server ocamlformat` in your opam switch.

Install the [OCaml Platform Visual Studio Code extension](https://marketplace.visualstudio.com/items?itemName=ocamllabs.ocaml-platform) from the Visual
Studio Marketplace.

The extension depends on OCaml LSP and ocamlformat. To install them in your switch, you can run:

```shell
$ opam install ocaml-lsp-server ocamlformat
```

Upon first loading an OCaml source file, you may be prompted to select the
toolchain in use. Pick the version of OCaml you are using, e.g., 4.14.0
from the list. Additional information is available by hovering over symbols in your program:

![Visual Studio Code](/media/tutorials/vscode.png)

**For Windows**
1. If you used the Diskuv OCaml (DKML) installer you will need to:
   1. Go to `File` > `Preferences` > `Settings` view (or press `Ctrl ,`)
   2. Select `User` > `Extensions` > `OCaml Platform`
   3. **Uncheck** `OCaml: Use OCaml Env`. That's it!

## Vim or Emacs

Instead of using the LSP server, we can use Merlin directly.

```shell
$ opam install merlin
```

When we installed Merlin above, instructions were printed on how to link Merlin with your editor. If you do not have them visible, just run this command:

```shell
$ opam user-setup install
```