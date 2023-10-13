---
id: set-up-editor
title: Configuring Your Editor
description: |
  This page will show you how to set up your editor for OCaml. 
category: "Tooling"
---

# Configuring Your Editor

While the toplevel is great for interactively trying out the language, we will shortly need to write OCaml files in an editor. We already installed the tools required to enhance Merlin, our editor of choice with OCaml support. Merlin provides all features such as "jump to definition," "show type," and `ocaml-lsp-server`, a server delivers those features to the editor through the LSP server.

OCaml has plugins for many editors, but the most actively maintained are for Visual Studio Code, Emacs, and Vim.

## VSCode

>TL;DR
>Install the VSCode extension `ocamllabs.ocaml-platform` and the packages `ocaml-lsp-server` and `ocamlformat` in your [opam switch](/docs/opam-switch-introduction).

For Visual Studio Code, install the [OCaml Platform Visual Studio Code extension](https://marketplace.visualstudio.com/items?itemName=ocamllabs.ocaml-platform) from the Visual Studio Marketplace. The extension depends on OCaml LSP and OCamlFormat. To install them in your switch, you can run:

```
$ opam install ocaml-lsp-server ocamlformat
```

Upon first loading an OCaml source file, you may be prompted to select the toolchain in use. Pick the version of OCaml you are using, e.g., 5.1.0 from the list. Additional information is available by hovering over symbols in your program:

![VSCode](https://ocaml.org/media/tutorials/vscode.png)

For Windows

If you used the **Diskuv OCaml (DKML) installer** you will need to:
    1. Go to **File > Preferences > Settings** view (or press **Ctrl**)
    2. Select **User > Extensions > OCaml Platform**
    3. **Uncheck OCaml: Use OCaml Env.** That's it!

## Vim and Emacs

**For Vim and Emacs**, we won't use the LSP server but rather directly talk to Merlin.

```
$ opam install merlin
```

After installing Merlin above, instructions were printed on how to link Merlin with your editor. If you do not have them visible, just run this command:

```
$ opam user-setup install
```
