---
id: "configuring-your-editor"
title: "Configuring Your Editor"
description: |
  How to set up Editor support for OCaml on VSCode, Vim and Emacs
category: "Best Practices"
---

OCaml has plugins for many editors, but the most actively maintained are for Visual Studio Code, Emacs, and Vim.

## Visual Studio Code

> **TL;DR**
> 
> Install the VSCode extension `ocamllabs.ocaml-platform` and the packages `ocaml-lsp-server` and `ocamlformat` in your [opam switch](/docs/opam-switch-introduction).

Install the [OCaml Platform Visual Studio Code extension](https://marketplace.visualstudio.com/items?itemName=ocamllabs.ocaml-platform) from the Visual Studio Marketplace. 

The extension depends on OCaml LSP and ocamlformat. To install them in your switch, you can run:

```shell
$ opam install ocaml-lsp-server ocamlformat
```

Upon first loading an OCaml source file, you may be prompted to select the toolchain in use. Pick the version of OCaml you are using, e.g., 4.14.0, from the list. 

### Editor Features at Your Disposal
If your editor is setup correctly, here are some important features you can begin using to your advantage:
#### 1) Hovering for Type Information: 

![VSCode Hovering](/media/tutorials/vscode-hover.gif)

This is a great feature that let's you see type information of any OCaml variable or function. All you have to do is place your cursor over the code and it will be displayed in the tooltip.

#### 2) Jump to Definitions With `Ctrl + Click`:

![VSCode Ctrl click](/media/tutorials/vscode-ctrl-click.gif)

If you hold down the <kbd>Ctrl</kbd> key while hovering, the code appears as a clickable link which if clicked takes you to the file where the implementation is. This can be great if you want to understand how a piece of code works under the hood. In this example, hovering and `Ctrl + Clicking` over the `peek` method of the `Queue` module will take you to the definiton of the `peek` method itself and how it is implemented.

#### 3) OCaml Commands With `Ctrl + Shift + P`:

![VSCode OCaml Commands](/media/tutorials/vscode-ocaml-commands.gif)

Pressing the key combination <kbd>Ctrl + Shift + P</kbd> opens a modal dialog at the top. If you type the word `ocaml`, you will be presented with a list of various OCaml commands at your disposal which can be used for different purposes.

### Windows Users

If you used the Diskuv OCaml (DKML) installer, you will need to:
    1. Go to `File` > `Preferences` > `Settings` view (or press `Ctrl ,`)
    2. Select `User` > `Extensions` > `OCaml Platform`
    3. Uncheck `OCaml: Use OCaml Env`. That's it!

## Vim and Emacs

**For Vim and Emacs**, we won't use the LSP server but rather directly talk to Merlin.

```shell
$ opam install merlin
```

After installing Merlin above, instructions will be printed on how to link Merlin with your editor. If you do not have them visible, just run this command:

```shell
$ opam user-setup install
```

### Talking to Merlin

#### Getting Type Information

**Vim**

![Vim Type information](/media/tutorials/vim-type-info.gif)

- In the Vim editor, press the <kbd>Esc</kbd> to enter command mode.
- Place the cursor over the variable.
- Type `:MerlinTypeOf` and press <kbd>Enter</kbd>.
- The type information will be displayed in the command bar.
Other Merlin commands for Vim are available and you can checkout their usage on the [Merlin official documentation for Vim](https://ocaml.github.io/merlin/editor/vim/).

**Emacs**

![Emacs Type information](/media/tutorials/emacs-type-info.gif)

- In the Emacs editor, place you cursor over the variable.
- Use the keyboard shortcut <kbd>Alt + x</kbd> followed by `merlin-type-enclosing`
- The type information will be displayed in the mini-buffer.
Other Merlin commands for Emacs are available and you can checkout their usage on the [Merlin Official documentation for Emacs](https://ocaml.github.io/merlin/editor/emacs/).
