---
title: "Backstage OCaml: ocaml.nvim - A Neovim Plugin for OCaml
"
tags: [experimental, ocaml-lsp, platform, editors]
---

Discuss this post on [discuss](https://discuss.ocaml.org/TODO-insert-link)!

We're excited to announce **ocaml.nvim**, a new Neovim plugin actively being developed by Tarides that brings advanced OCaml development features to Neovim users. Think of it as the Neovim sibling of [ocaml-eglot](https://github.com/tarides/ocaml-eglot), which we released earlier this year for Emacs users.

## What is ocaml.nvim?

Modern code editors communicate with programming languages through the Language Server Protocol (LSP), which provides essential features like syntax checking, code navigation, and auto-completion. However, OCaml's language server exposes powerful custom commands beyond what generic LSP clients can access.

ocaml.nvim works alongside generic Neovim LSP plugins like `nvim-lspconfig`, providing direct access to advanced ocamllsp features without requiring complex editor-side logic. The plugin gives you access to all the advanced Merlin commands not supported by generic LSP clients.

## Key Features

**Typed Holes Navigation** - Navigate between typed holes (`_`) and interactively substitute them with the Construct command.

**Semantic Navigation** - Move through your code semantically: jump between expressions, parent `let` bindings, modules, functions, and `match` expressions.

**Phrase Navigation** - Move between OCaml phrases (top-level definitions) in your buffer.

Many more features are in development, including alternating between `.ml` and `.mli` files, type enclosing, and pattern matching generation.

## Getting Started

Installation is straightforward with lazy.nvim:

```lua
require("lazy").setup({
  { "tarides/ocaml.nvim",
    config = function()
      require("ocaml").setup()
    end
  }
})
```

The plugin complements your existing LSP setup—you'll continue to use Neovim's built-in LSP for standard features while ocaml.nvim adds OCaml-specific capabilities.

## Project Status

The ocaml.nvim repository is now public on [GitHub](https://github.com/tarides/ocaml.nvim), with comprehensive documentation, a feature table, and screencast demonstrations. We're working towards a stable 1.0 release and welcome feedback from the community.

Try out `ocaml.nvim` and let us know what you think! For questions or feedback, reach out to Charlène Gros at charlene@tarides.com, join the discussion on the [OCaml Discuss forum](https://discuss.ocaml.org), or post an issue on the [ocaml.nvim GitHub repository](https://github.com/tarides/ocaml.nvim).
