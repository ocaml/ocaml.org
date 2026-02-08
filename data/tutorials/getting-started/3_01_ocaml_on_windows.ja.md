---
id: ocaml-on-windows
title: Windows上のOCaml
description: >
  Windows上のOCamlの現状と、Windowsサポートを改善するためのロードマップについてお読みください。
category: "Resources"
language: Japanese
---

新規ユーザーには[opam](https://opam.ocaml.org/)のインストールをお勧めします。OCamlパッケージマネージャーであるopamはバージョン2.2以降でWindowsを完全にサポートしており、最新のOCaml環境を提供します。

[Docker](#dockerイメージ)や[WSL2](#wsl2)を使用することもできます。

推奨事項は以下の利用可能状況表に基づいています：

* Tier 1は最新のコンパイラで完全にサポートされています。
* Tier 2はサポートされていますが、可能な場合にメンテナンスされます。
* Tier 3はユーザーサポートです。

```text
╭──────────────────────────────────────────────────────────────────────────╮
│ Tier   │ OCaml Version and Environment   │ Support                       │
│ ------ │ ------------------------------- │ ----------------------------- │
│ Tier 1 │ OCaml 5.x with Opam 2.2+        │ Full support.                 │
│ Tier 3 │ 5.x with WSL2                   │ User supported.               │
│ Tier 3 │ 5.x with Docker                 │ User supported.               │
╰──────────────────────────────────────────────────────────────────────────╯
```

## WindowsへのOpamのインストール

OpamはWindows向けにwingetで配布されています。インストールするには、ターミナルで以下のコマンドを実行してください：

```shell-session
> winget install Git.Git OCaml.opam
```

`winget`からGitをインストールすることをお勧めしますが、必要に応じてこの手順を省略してお好みの方法でGitをインストールしても構いません。
Opamは互換性のあるGitを探し、見つからない場合はインストールするためのオプションを提示します。

インストール後、opamバイナリにアクセスするために新しいシェルを起動してください。

```shell-session
$ opam --version
2.2.1
```

opamがインストールされたら、`opam init`コマンドを実行してopam環境をセットアップします。

リポジトリ情報の取得段階に時間がかかることに気づくでしょう。
これは（現時点では）正常なことなので、実行中はお気に入りの温かい飲み物を
ご用意することをお勧めします。

opamはUnixライクな環境を必要とします。デフォルトで、
opamはCygwinに依存し、MSYS2とも互換性があります。

*初期化時*に、opamはマシン上で利用可能なUnix環境をスキャンし、
お好みのオプションを選択するよう促します。opamが管理する
独自の内部Cygwinインストールを作成させることをお勧めします。これにより、
そのような環境と連携する他のツールからの干渉の可能性を減らすことができます。
サンドボックス環境と考えてください。

Opamの初期化時のデフォルトの動作は、新しい`switch`と
バージョン`> 4.05`のOCamlコンパイラをインストールすることです。デフォルトで、opamはスイッチ作成時にCコンパイラとして`mingw`を選択しますが、以下のコマンドで`msvc`のような代替をインストールすることも可能です：

```sh
opam install system-msvc
```

`opam init`が完了したら、以下のコマンドを実行して環境を更新してください：

CMDの場合：

```dosbatch
> for /f "tokens=*" %i in ('opam env --switch=default') do @%i
```

PowerShellの場合：

```powershell
> (& opam env --switch=default) -split '\\r?\\n' | ForEach-Object { Invoke-Expression $_ }
```

[Nushell](https://www.nushell.sh/)の場合：

```nushell
> opam env --shell=powershell | parse "$env:{key} = '{val}'" | transpose -rd | load-env
```

Opamは必要な場合にシェル更新コマンドを表示します。

以下でインストールを確認できます

```text
> ocaml --version
The OCaml toplevel, version 5.2.0

> ocaml
OCaml version 5.2.0
Enter #help;; for help.

# print_endline "Hello OCamleers!!";;
Hello OCamleers!!
- : unit = ()
#
```

これで開発の準備ができたOCaml環境が整いました。問題が発生した場合やさらなる支援が必要な場合は、遠慮なく[OCamlコミュニティ](https://ocaml.org/community)にご相談ください。

## その他のインストール環境

### WSL2

WindowsマシンでOCamlプログラムを*実行*するだけでよい場合、最も簡単な方法はWindows Subsystem for Linux 2（WSL2）を使用することです。WSL2はLinuxプログラムをWindows上で直接実行できる機能です。WSL2はWSL1よりも大幅に使いやすく高速です。Microsoftは[WSL2のセットアップ](https://docs.microsoft.com/en-us/windows/wsl/install-win10)（英語）に関する包括的なインストール手順を提供しています。

WSL2をインストールして1つのLinuxディストリビューション（[Ubuntu LTS](https://apps.microsoft.com/store/detail/ubuntu/9PDXGNCFSCZV?hl=en-us&gl=US)をお勧めします）を選択したら、[OCamlのインストール：LinuxとmacOSでのインストール](/docs/installing-ocaml?lang=ja)の手順に従うことができます。

### Dockerイメージ

[`ocaml/opam`](https://hub.docker.com/r/ocaml/opam) Docker Hubリポジトリには、定期的に更新されるWindowsイメージが含まれています。これには`msvc`と`mingw`を使用したイメージが含まれます。Dockerに慣れている場合は、マシン上で動作するWindows環境を手に入れるより簡単な方法かもしれません。

## Windows上のOCamlのエディタのサポート

### Visual Studio Code（VSCode）

**opamインストールを使用する場合**、VSCodeを実行するパスにopamスイッチプレフィックスを追加する必要があります。

**WSL2を使用する場合**は、VSCodeからWSL2インスタンスにリモート接続します。Microsoftには、WSL2とVisual Studio Codeの接続について説明した[有用なブログ記事](https://code.visualstudio.com/blogs/2019/09/03/wsl2)（英語）があります。

### VimとEmacs

**VimとEmacs**の場合、opamを使用して[Merlin](https://github.com/ocaml/merlin)システムをインストールしてください：

```console
opam install merlin
```

インストール手順では、Merlinとエディタのリンク方法が表示されます。

**Vimを使用する場合**、デフォルトのCygwin Vimは
Merlinでは動作しません。Vimを別途インストールする必要があります。Merlinインストール時に表示される通常の手順に加えて、VimでPATHを設定する必要がある場合があります：

```vim
let $PATH .= ";".substitute(system('opam config var bin'),'\n$','','''')
```
