---
id: "setting-up-vscode"
title: "Setting up VSCode"
description: |
  How to set up Editor support for OCaml on VSCode
category: "Best Practices"
---

# Setting up Editor support for OCaml on VSCode

> **TL;DR**
> 
> Install the VSCode extension `ocamllabs.ocaml-platform` and the packages `ocaml-lsp-server ocamlformat` in your opam switch.

The official OCaml extension for VSCode is https://marketplace.visualstudio.com/items?itemName=ocamllabs.ocaml-platform.

To get started, you can install it with the following command:

```
ext install ocamllabs.ocaml-platform
```

The extension depends on OCaml LSP and ocamlformat. To install them in your switch, you can run:

```
opam install ocaml-lsp-server ocamlformat
```

When running `vscode` from the terminal, the extension should pick up your current opam switch. If you need to change it, you can click on the package icon in the status bar to select your switch.
