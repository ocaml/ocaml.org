---
id: set-up-editor
title: エディタの設定
description: |
  このページでは、OCaml用にエディタを設定する方法を説明します。
category: "Tooling"
language: Japanese
---
トップレベルは言語を対話的に試すのに最適ですが、すぐにエディタでOCamlファイルを書く必要が出てきます。エディタのOCamlサポートを強化するために必要なツール、MerlinとOCamlサポートを提供する`ocaml-lsp-server`（LSPサーバーを通じてエディタに「定義へジャンプ」や「型の表示」などの機能を提供するサーバー）は既にインストール済みです。
OCamlには多くのエディタ用プラグインがありますが、最も活発にメンテナンスされているのはVisual Studio Code、Emacs、Vim用のものです。

## Visual Studio Code

> TL;DR
> [opamスイッチ](/docs/opam-switch-introduction?lang=ja)に`ocaml-lsp-server`と`ocamlformat`パッケージをインストールしてください。

VSCodeの場合、Visual Studio Marketplaceから[OCaml Platform Visual Studio Code拡張機能](https://marketplace.visualstudio.com/items?itemName=ocamllabs.ocaml-platform)をインストールしてください。この拡張機能はOCaml LSPとOCamlFormatに依存しています。スイッチにインストールするには、以下を実行します：

```shell
opam install ocaml-lsp-server ocamlformat
```

OCamlソースファイルを最初に読み込むと、使用するツールチェインの選択を求められる場合があります。リストから使用しているOCamlのバージョン（例：`5.1.0`）を選択してください。

### 利用できるエディタ機能

エディタが正しく設定されていれば、以下の重要な機能を活用し始めることができます：

#### 1) ホバーによる型情報の表示

![VSCode ホバー](/media/tutorials/vscode-hover.gif)

これは、OCamlの変数や関数の型情報を確認できる優れた機能です。コードの上にカーソルを置くだけで、ツールチップに型情報が表示されます。

#### 2) `Ctrl + クリック`による定義へのジャンプ

![VSCode Ctrlクリック](/media/tutorials/vscode-ctrl-click.gif)

<kbd>Ctrl</kbd>キーを押しながらホバーすると、コードがクリック可能なリンクとして表示され、クリックすると実装があるファイルに移動します。コードが内部でどのように動作するかを理解したい場合に便利です。この例では、`Queue`モジュールの`peek`メソッドにホバーして`Ctrl + クリック`すると、`peek`メソッド自体の定義とその実装に移動します。

#### 3) `Ctrl + Shift + P`によるOCamlコマンド

![VSCode OCamlコマンド](/media/tutorials/vscode-ocaml-commands.gif)

<kbd>Ctrl + Shift + P</kbd>キーの組み合わせを押すと、上部にモーダルダイアログが開きます。`ocaml`と入力すると、さまざまな目的に使用できる各種OCamlコマンドのリストが表示されます。

### Windowsユーザー

DkMLディストリビューションを使用した場合、以下の手順が必要です：
    1. `File` > `Preferences` > `Settings`ビューを開きます（または`Ctrl ,`を押します）
    2. `User` > `Extensions` > `OCaml Platform`を選択します
    3. `OCaml: Use OCaml Env`のチェックを外します。以上です！

## Emacs

EmacsでOCamlを使うには、少なくとも2つのモードが必要です：

- メジャーモード：構文ハイライトやインデントレベルの構造化などをサポートします
- マイナーモード：言語サーバー（`ocaml-lsp-server`や`merlin`など）と連携します。このチュートリアルでは、新しい`ocaml-eglot`モードと`ocaml-lsp-server`をサーバーとして使用することに焦点を当てます。

### メジャーモードの選択

OCaml専用のメジャーモードにはいくつかありますが、主な3つは以下の通りです：

- [Tuareg](https://github.com/ocaml/tuareg)：古くからある（現在も更新されている）非常に完成度の高いモードで、通常推奨されるものです
- [Caml](https://github.com/ocaml/caml-mode)：`tuareg`よりさらに古い（しかし現在も更新されている）、`tuareg`よりも軽量なモードです
- [Neocaml](https://github.com/bbatsov/neocaml)：[tree-sitter](https://tree-sitter.github.io/tree-sitter/)のような最新のツールに基づいた新しいモードです。執筆時点ではまだ実験的です。

このチュートリアルでは、メジャーモードとして`tuareg`を使用しますが、自由に実験してお好みのものを選んでください！`tuareg`を使用するには、Emacs設定に以下の行を追加してください：

```elisp
(use-package tuareg
  :ensure t
  :mode (("\\.ocamlinit\\'" . tuareg-mode)))
```


#### Melpaと`use-package`

お使いのEmacsのバージョンが`use-package`マクロをサポートしていない場合（またはMELPAパッケージを考慮するように設定されていない場合）は、更新して以下の指示に従い[`use-package`](https://github.com/jwiegley/use-package)と[MELPA](https://melpa.org/#/getting-started)をインストールしてください。

### OCaml用LSP設定

バージョン`29.1`以降、EmacsにはLSPサーバーと連携するための組み込みモード[Eglot](https://www.gnu.org/software/emacs/manual/html_mono/eglot.html)があります。それ以前のバージョンのEmacsを使用している場合は、以下の方法でインストールする必要があります：

```elisp
(use-package eglot
  :ensure t)
```

次に、メジャーモード（この場合は`tuareg`）と`eglot`の橋渡しが必要です。これは[`ocaml-eglot`](https://github.com/tarides/ocaml-eglot)パッケージを使って行います：

```elisp
(use-package ocaml-eglot
  :ensure t
  :after tuareg
  :hook
  (tuareg-mode . ocaml-eglot)
  (ocaml-eglot . eglot-ensure))
```

これだけです！あとは`ocaml-lsp-server`と`ocamlformat`を[スイッチ](/docs/opam-switch-introduction?lang=ja)にインストールするだけです：

```shell
opam install ocaml-lsp-server ocamlformat
```

これでEmacsでOCamlコードを_生産的に_編集する準備が整いました！

#### より詳細な設定

ocaml-eglotは詳細に設定でき、プロジェクトの[README](https://github.com/tarides/ocaml-eglot/blob/main/README.md)（英語）にはワークフローに完全に適合するための複数の設定パスが示されています。モードが提供するさまざまな機能の網羅的な紹介もそこにあります。


#### 型情報の取得

OCamlファイルを開くと`ocaml-lsp`サーバーが起動するはずです。例えば、`ocaml-eglot-type-enclosing`コマンド（または`C-c C-t`バインディング）を選択した式に使用することで、動作していることを確認できます：

![Emacs 型情報](/media/tutorials/emacs-type-info.gif)

ocaml-eglotの[README](https://github.com/tarides/ocaml-eglot/blob/main/README.md)（英語）には、このモードで利用可能なすべての機能の包括的な概要が掲載されています！


## Vim

Vimの場合、LSPサーバーは使用せず、Merlinと直接通信します。

```shell
opam install merlin
```

上記でMerlinをインストールした後、エディタとMerlinをリンクする方法の手順が表示されます。表示されない場合は、以下のコマンドを実行してください：

```shell
opam user-setup install
```

### Merlinとの通信

#### 型情報の取得

![Vim 型情報](/media/tutorials/vim-type-info.gif)

- Vimエディタで<kbd>Esc</kbd>を押してコマンドモードに入ります。
- 変数の上にカーソルを置きます。
- `:MerlinTypeOf`と入力して<kbd>Enter</kbd>を押します。
- コマンドバーに型情報が表示されます。
その他のVim用Merlinコマンドについては、[Merlin公式ドキュメントのVim版](https://ocaml.github.io/merlin/editor/vim/)（英語）で使い方を確認できます。

## Neovim

NeovimにはLSPクライアントが組み込まれています。

ここで注意すべき点は、`ocaml-lsp-server`はバージョンに敏感であり、人気のある言語サービスのパッケージマネージャーであるMasonの時として古いソースとうまく連携しないことが多いということです。LSPサーバーをスイッチに直接インストールし、Neovimの設定をそれを使用するように指定することをお勧めします。

LSPサーバーとフォーマッターをインストールするには、以下を実行してください。
```shell
opam install ocaml-lsp-server ocamlformat
```

LSPサーバーのインストールと管理には2つの主な方法があります。
- より新しい推奨される方法は、v0.11.0以降のバージョンで`vim.lsp`を介して新しいNeovim LSP APIを使用することです。
- より従来の方法は`nvim-lspconfig`を使用することです。詳細については、`kickstart.nvim`に優れたセットアップ例があります。

### vim.lspの使用:

トップレベルの`init.lua`に以下を追加してください。
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

設定オプションの詳細については`:h lsp-config`を参照してください。

#### runtimepathを使用したvim.lsp

`init.lua`を最小限に保ちたい場合は、`runtimepath`を介してLSP設定を別のファイルに移動することもできます。設定テーブルを`lsp/<some_name>.lua`または`after/lsp/<some_name>.lua`に配置すると、Neovimが自動的に検索します。

詳細については`:h runtimepath`を参照してください。

設定のルートで以下を実行してください。
```text
mkdir lsp
touch lsp/ocamllsp.lua
```

Neovimの設定は以下のような構造になるはずです。
```text
.
├── init.lua
├── lsp
│   └── ocamllsp.lua
└── ...
```

LSP設定を`lsp/ocamllsp.lua`に追加してください。
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

次にトップレベルの`init.lua`で有効にします。
```lua
vim.lsp.enable 'ocamllsp'
```

### nvim-lspconfigの使用

`nvim-lspconfig`のセットアップに以下を追加してください。
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

`nvim-lspconfig`が妥当なデフォルト値を提供するため、`setup`にさらに設定を渡す必要はありません。詳細は[こちら](https://github.com/neovim/nvim-lspconfig/blob/master/lsp/ocamllsp.lua)（英語）を参照してください。
