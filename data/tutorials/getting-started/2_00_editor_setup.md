---
id: set-up-editor
title: Configuring Your Editor
description: |
  This page will show you how to set up your editor for OCaml. 
category: "Tooling"
language: English
---
While the toplevel is great for interactively trying out the language, we will shortly need to write OCaml files in an editor. We already installed the tools required to enhance Merlin, our editor of choice with OCaml support. Merlin provides all features such as "jump to definition," "show type," and `ocaml-lsp-server`, a server that delivers those features to the editor through the LSP server.
OCaml has plugins for many editors, but the most actively maintained are for Visual Studio Code, Emacs, and Vim.

## Visual Studio Code

> TL;DR
> Install the packages `ocaml-lsp-server` and `ocamlformat` in your [opam switch](/docs/opam-switch-introduction).

For VSCode, install the [OCaml Platform Visual Studio Code extension](https://marketplace.visualstudio.com/items?itemName=ocamllabs.ocaml-platform) from the Visual Studio Marketplace. The extension depends on OCaml LSP and OCamlFormat. To install them in your switch, you can run:

```shell
opam install ocaml-lsp-server ocamlformat
```

Upon first loading an OCaml source file, you may be prompted to select the toolchain in use. Pick the version of OCaml you are using, e.g., `5.1.0` from the list.

### Editor Features at Your Disposal

If your editor is setup correctly, here are some important features you can begin using to your advantage:

#### 1) Hovering for Type Information

![VSCode Hovering](/media/tutorials/vscode-hover.gif)

This is a great feature that let's you see type information of any OCaml variable or function. All you have to do is place your cursor over the code and it will be displayed in the tooltip.

#### 2) Jump to Definitions With `Ctrl + Click`

![VSCode Ctrl click](/media/tutorials/vscode-ctrl-click.gif)

If you hold down the <kbd>Ctrl</kbd> key while hovering, the code appears as a clickable link which if clicked takes you to the file where the implementation is. This can be great if you want to understand how a piece of code works under the hood. In this example, hovering and `Ctrl + Clicking` over the `peek` method of the `Queue` module will take you to the definiton of the `peek` method itself and how it is implemented.

#### 3) OCaml Commands With `Ctrl + Shift + P`

![VSCode OCaml Commands](/media/tutorials/vscode-ocaml-commands.gif)

Pressing the key combination <kbd>Ctrl + Shift + P</kbd> opens a modal dialog at the top. If you type the word `ocaml`, you will be presented with a list of various OCaml commands at your disposal which can be used for different purposes.

### Windows Users

If you used the DkML distribution, you will need to:
    1. Go to `File` > `Preferences` > `Settings` view (or press `Ctrl ,`)
    2. Select `User` > `Extensions` > `OCaml Platform`
    3. Uncheck `OCaml: Use OCaml Env`. That's it!
    
## Emacs

Using Emacs to work with OCaml requires at least two modes:

- A major mode, which, among other things, supports syntax highlighting and the structuring of indentation levels
- A minor mode, which will interact with a language server (such as `ocaml-lsp-server` or `merlin`). In this tutorial, we will focus on using the new `ocaml-eglot` mode and `ocaml-lsp-server` as a server.

### Choosing a major mode

There are several major modes dedicated to OCaml, of which the 3 main ones are:

- [Tuareg](https://github.com/ocaml/tuareg): an old-fashioned (but still updated), very complete mode, usually the recommended one
- [Caml](https://github.com/ocaml/caml-mode): a mode even older than `tuareg` (but still updated), lighter than `tuareg`
- [Neocaml](https://github.com/bbatsov/neocaml): a brand new mode, based on modern tools (like [tree-sitter](https://tree-sitter.github.io/tree-sitter/)). Still experimental at the time of writing.

For the purposes of this tutorial, we are going to focus on the use of `tuareg` as the major mode, but you should feel free to experiment and choose your favourite one! To use `tuareg`, you can add these lines to your Emacs configuration:

```elisp
(use-package tuareg
  :ensure t
  :mode (("\\.ocamlinit\\'" . tuareg-mode)))
```


#### Melpa and `use-package`

If your version of Emacs does not support the `use-package` macro (or is not set up to take MELPA packages into account), please update it and follow these instructions to install [`use-package`](https://github.com/jwiegley/use-package) and [MELPA](https://melpa.org/#/getting-started).

### LSP setup for OCaml

Since version `29.1`, Emacs has had a built-in mode for interacting with LSP servers, [Eglot](https://www.gnu.org/software/emacs/manual/html_mono/eglot.html). If you are using an earlier version of Emacs, you will need to install it this way:

```elisp
(use-package eglot
  :ensure t)
```

Next, we need to bridge the gap between our major mode (in this case, `tuareg`) and `eglot`. This is done using the [`ocaml-eglot`](https://github.com/tarides/ocaml-eglot) package:

```elisp
(use-package ocaml-eglot
  :ensure t
  :after tuareg
  :hook
  (tuareg-mode . ocaml-eglot)
  (ocaml-eglot . eglot-ensure))
```

And that's all there is to it! Now all you need to do is install `ocaml-lsp-server` and `ocamlformat` in our [switch](/docs/opam-switch-introduction):

```shell
opam install ocaml-lsp-server ocamlformat
```

You are now ready to edit OCaml code _productively_ with Emacs!

#### Finer configuration

OCaml-eglot can be finely configured, the project [README](https://github.com/tarides/ocaml-eglot/blob/main/README.md) gives several configuration paths to adapt perfectly to your workflow. You will also find there an exhaustive presentation of the different functions offered by the mode.


#### Getting Type Information

Opening an OCaml file should launch an `ocaml-lsp` server, and you can convince yourself that it's working by using, for example, the `ocaml-eglot-type-enclosing` command (or using the `C-c C-t` binding) on an expression of your choice:

![Emacs Type information](/media/tutorials/emacs-type-info.gif)

OCaml-eglot [README](https://github.com/tarides/ocaml-eglot/blob/main/README.md) provides a comprehensive overview of all the functions available in this mode!


## Vim

For Vim, we won't use the LSP server but rather directly talk to Merlin.

```shell
opam install merlin
```

After installing Merlin above, instructions will be printed on how to link Merlin with your editor. If you do not have them visible, just run this command:

```shell
opam user-setup install
```

### Talking to Merlin

#### Getting Type Information

![Vim Type information](/media/tutorials/vim-type-info.gif)

- In the Vim editor, press the <kbd>Esc</kbd> to enter command mode.
- Place the cursor over the variable.
- Type `:MerlinTypeOf` and press <kbd>Enter</kbd>.
- The type information will be displayed in the command bar.
Other Merlin commands for Vim are available and you can checkout their usage on the [Merlin official documentation for Vim](https://ocaml.github.io/merlin/editor/vim/).

## Neovim

Neovim comes with an LSP client.

One note here is that is that `ocaml-lsp-server` is sensitive to versioning, and often does not play well with the sometimes outdated sources in Mason, a popular package manager for language services. We recommend you install the LSP server directly in the switch, and pointing your Neovim config to use that.

To install the LSP server and the formatter, run the following.
```shell
opam install ocaml-lsp-server ocamlformat
```

There are two main ways to install and manage LSP servers.
- A newer, more recommended way is to use the new Neovim LSP API for versions newer than v0.11.0 via `vim.lsp`.
- A more traditional way is to use `nvim-lspconfig`. For more info, `kickstart.nvim` has a great example setup.

### Using vim.lsp:

Add this to your toplevel `init.lua`.
```lua
vim.lsp.config['ocamllsp'] = {
  cmd = { 'ocamllsp' },
  filetypes = { 
    'ocaml',
    'ocaml.interface',
    'ocaml.menhir',
    'ocaml.ocamllex',
    'dune',
    'reason'
  },
  root_markers = {
    { 'dune-project', 'dune-workspace' },
    { "*.opam", "esy.json", "package.json" },
    '.git'
  },
  settings = {},
}

vim.lsp.enable 'ocamllsp'
```

See `:h lsp-config` for more detail on configuration options.

#### Using vim.lsp With runtimepath

You can also move your LSP config to a separate file via `runtimepath` if you'd like to keep your `init.lua` minimal. Putting your config table inside `lsp/<some_name>.lua` or `after/lsp/<some_name>.lua` will allow Neovim to search for them automatically.

See `:h runtimepath` for more detail.

Run the following at the root of your config.
```text
mkdir lsp
touch lsp/ocamllsp.lua
```

Your Neovim config should have the following structure now.
```text
.
├── init.lua
├── lsp
│   └── ocamllsp.lua
└── ...
```

Add your LSP config to `lsp/ocamllsp.lua`.
```lua
return {
  cmd = { 'ocamllsp' },
  filetypes = { 
    'ocaml',
    'ocaml.interface',
    'ocaml.menhir',
    'ocaml.ocamllex',
    'dune',
    'reason'
  },
  root_markers = {
    { 'dune-project', 'dune-workspace' },
    { "*.opam", "esy.json", "package.json" },
    '.git'
  },
  settings = {},
}
```

Then enable them in the toplevel `init.lua`.
```lua
vim.lsp.enable 'ocamllsp'
```

### Using nvim-lspconfig

Add this to your `nvim-lspconfig` setup.
```lua
{
  'neovim/nvim-lspconfig',
  config = function()
    -- rest of config...

    -- add this line specifically for OCaml
    require('lspconfig').ocamllsp.setup {}
  end,
},
```

There is no need to pass more settings to `setup` because `nvim-lspconfig` provides reasonable defaults. See [here](https://github.com/neovim/nvim-lspconfig/blob/master/lsp/ocamllsp.lua) for more info.

