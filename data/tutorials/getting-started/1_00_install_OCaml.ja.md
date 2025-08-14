---
id: installing-ocaml
title: OCamlのインストール
description: |
  このページでは、OCamlとOCaml Platformツールのインストール方法を説明します。 |
  この手順は、Windows、およびLinuxやmacOSのようなUnix系システムで動作します。
category: "First Steps"
language: Japanese
---

このガイドでは、OCamlの最小限のインストールについて説明します。これには、パッケージマネージャーと[コンパイラ](#installation-on-unix-and-macos)自体のインストールが含まれます。また、ビルドシステム、エディタのサポート、その他いくつかの重要なプラットフォームツールもインストールします。

このページでは、Linux、macOS、Windows、および\*BSD向けの最近のOCamlバージョンのインストール手順を説明します。Dockerについては、opamの設定時を除き、Linuxの手順が適用されます。

**注**: OCamlとそのツールは、[コマンドラインインターフェース（CLI）またはシェル](https://www.youtube.com/watch?v=0PxTAn4g20U)を介してインストールします。

## opamのインストール

OCamlには公式のパッケージマネージャー [opam](https://opam.ocaml.org/) があり、ユーザーはOCamlのツールやライブラリをダウンロードしてインストールできます。opamはまた、異なるバージョンのOCamlを必要とする様々なプロジェクトを扱うことを容易にします。

opamはOCamlコンパイラもインストールします。他の選択肢も存在しますが、OCamlをインストールする最良の方法はopamです。OCamlはほとんどのLinuxディストリビューションでパッケージとして利用可能ですが、しばしばバージョンが古いことがあります。

opamをインストールするには、[システムのパッケージマネージャーを使用する](https://opam.ocaml.org/doc/Install.html#Using-your-distribution-39-s-package-system)か、[バイナリディストリビューション](https://opam.ocaml.org/doc/Install.html#Binary-distribution)をダウンロードします。詳細はこれらのリンクにありますが、便宜上、ここではパッケージディストリビューションを使用します。

**macOSの場合**

[Homebrew](https://brew.sh/) を使ってインストールする場合:

```shell
brew install opam
```

または[MacPorts](https://www.macports.org/) を使っている場合:

```shell
port install opam
```

**注**: macOSでopamをインストールするのはかなり簡単ですが、Homebrewのインストールの仕組みが変更されたため、後で問題が発生する可能性があります。新しいMacで使われているM1プロセッサーなどのARM64環境では、実行ファイルが見つからない場合があります。これに対処するのはかなり複雑な手順になる可能性があるため、このインストールガイドの妨げにならないように、[短いARM64修正ドキュメント](/docs/arm64-fix)（英語）を作成しました。

**Linuxの場合**

Linuxでは、システムのパッケージマネージャーを使用してスーパーユーザーとしてopamをインストールすることが望ましいです。opamのサイトで、[すべてのインストール方法の詳細](https://opam.ocaml.org/doc/Install.html)を確認できます。opamのバージョン2.0以上が、サポートされているすべてのLinuxディストリビューションでパッケージ化されています。サポートされていないLinuxディストリビューションを使用している場合は、コンパイル済みのバイナリをダウンロードするか、ソースからopamをビルドしてください。

DebianまたはUbuntuにインストールする場合:

```shell
sudo apt-get install opam
```

Arch Linuxにインストールする場合:

```shell
sudo pacman -S opam
```

**注**: Ubuntuでも使用されているDebianのopamパッケージは、OCamlコンパイラを推奨依存関係としています。デフォルトでは、そのような依存関係はインストールされます。OCamlなしでopamのみをインストールしたい場合は、次のようなコマンドを実行する必要があります:

```shell
sudo apt-get install --no-install-recommends opam
```

**Windowsの場合**

[WinGet](https://github.com/microsoft/winget-cli) を使ってopamをインストールするのが最も簡単です:

```shell
PS C:\> winget install Git.Git OCaml.opam
```

**バイナリディストリビューション**

opamの最新リリースが必要な場合は、バイナリディストリビューションを介してインストールしてください。UnixやmacOSでは、まず `gcc`、`build-essential`、`curl`、`bubblewrap`、`unzip` といったシステムパッケージをインストールする必要があります。これらのパッケージ名は、お使いのオペレーティングシステムやディストリビューションによって異なる場合があることに注意してください。また、このスクリプトは内部で `sudo` を呼び出すことにも注意してください。

次のコマンドは、お使いのシステムに適用される最新バージョンのopamをインストールします:

```shell
bash -c "sh <(curl -fsSL https://opam.ocaml.org/install.sh)"
```

Windowsでは、wingetパッケージはopamの開発者によってメンテナンスされており、[GitHubでリリースされているバイナリ](https://github.com/ocaml/opam/releases)を使用しますが、同等のPowerShellスクリプトを使用してインストールすることもできます:

```powershell
Invoke-Expression "& { $(Invoke-RestMethod https://opam.ocaml.org/install.ps1) }"
```

**上級のWindowsユーザー向け**: CygwinやWSL2に詳しい場合は、[OCaml on Windows](/docs/ocaml-on-windows)（英語）ページに記載されている他のインストール方法があります。

## opamの初期化

opamをインストールしたら、初期化する必要があります。そのためには、一般ユーザーとして次のコマンドを実行してください。完了するまでに数分かかることがあります。

```shell
opam init -y
```

**注**: Dockerコンテナ内で `opam init` を実行している場合は、サンドボックス機能を無効にする必要があります。これは `opam init --disable-sandboxing -y` を実行することで行えます。特権付きDockerコンテナを実行しない限り、これが必要です。

`opam init` の出力の最後に表示される指示に従って、初期化を完了させてください。通常、これは以下のようになります:

Unixの場合:
```
eval $(opam env)
```

Windowsのコマンドプロンプトの場合:
```
for /f "tokens=*" %i in ('opam env') do @%i
```

PowerShellの場合:
```powershell
(& opam env) -split '\r?\n' | ForEach-Object { Invoke-Expression $_ }
```

opamの初期化には数分かかることがあります。インストールと設定が完了するのを待つ間、[A Tour of OCaml](/docs/tour-of-ocaml)（英語）を読み始めてください。

**注**: opamは_スイッチ_と呼ばれるものを管理できます。これは複数のOCamlプロジェクトを切り替える際に重要です。しかし、この「はじめの一歩」シリーズのチュートリアルでは、スイッチは必要ありません。興味があれば、[opamスイッチの紹介](/docs/opam-switch-introduction)（英語）を読むことができます。

**インストールで問題がありましたか？** 必ず[最新のリリースノート](https://opam.ocaml.org/blog/opam-2-2-0/)（英語）を読んでください。問題は <https://github.com/ocaml/opam/issues> または <https://github.com/ocaml-windows/papercuts/issues> で報告できます。

## Platformツールのインストール

OCamlコンパイラとopamパッケージマネージャーのインストールに成功したので、次はOCamlでの完全な開発体験を得るために必要な[OCaml Platformツール](https://ocaml.org/docs/platform)（英語）をいくつかインストールしましょう。

- [UTop](https://github.com/ocaml-community/utop): モダンな対話的トップレベル (REPL: Read-Eval-Print Loop)
- [Dune](https://dune.build): 高速で多機能なビルドシステム
- [`ocaml-lsp-server`](https://github.com/ocaml/ocaml-lsp): Language Server Protocolを実装し、VS Code、Vim、EmacsなどでOCamlのエディタサポートを可能にします。
- [`odoc`](https://github.com/ocaml/odoc): OCamlコードからドキュメントを生成します。
- [OCamlFormat](https://opam.ocaml.org/packages/ocamlformat/): OCamlコードを自動的にフォーマットします。

これらのツールはすべて、単一のコマンドでインストールできます:

```shell
opam install ocaml-lsp-server odoc ocamlformat utop
```

これで準備は万端、コーディングを始める準備ができました。

## インストールの確認

すべてが正しく動作しているか確認するために、UTopトップレベルを起動してみましょう:

```shell
$ utop
────────┬─────────────────────────────────────────────────────────────┬─────────
        │ Welcome to utop version 2.13.1 (using OCaml version 5.1.0)! │
        └─────────────────────────────────────────────────────────────┘

Type #utop_help for help about using utop.

─( 00:00:00 )─< command 0 >──────────────────────────────────────{ counter: 0 }─
utop #
```

これでOCamlのトップレベルに入りました。OCamlの式を入力し始めることができます。例えば、`#` プロンプトで `21 * 2;;` と入力し、`Enter`キーを押してみてください。次のように表示されます:

```ocaml
# 21 * 2;;
- : int = 42
```

**おめでとうございます**！ OCamlのインストールが完了しました！ 🎉

UTopを終了するには、`#quit;;`（ここでの`#`はプロンプトではなく、入力する必要があります）と入力するか、`Ctrl+D`を押してください。

## コミュニティに参加する

ぜひ[OCamlコミュニティ](/community)に参加してください。[Discuss](https://discuss.ocaml.org/)や[Discord](https://discord.com/invite/cCYQbqN)で多くのコミュニティメンバーを見つけることができます。これらは何か問題があった場合に助けを求めるのに最適な場所です。