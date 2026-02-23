---
id: arm64-fix
title: Apple M1でのHomebrewエラーの修正
description: |
  このページでは、新しいMacのARM64プロセッサ向けの回避策を説明します。
category: "Resources"
language: Japanese
---

[Homebrewのインストール方法が変更された](https://github.com/Homebrew/brew/issues/9177)ため、macOS ARM64 M1で実行可能ファイルが見つからないことがあります。これにより、チュートリアルを進める際にエラーが発生する可能性があります。HomebrewがデフォルトでARM64をインストールするようにしたいので、いくつかの変更が必要です。

始める前に、Homebrewがどこにインストールされているか確認しましょう。CLIで以下を実行してください：

```shell
where brew
```

応答が`/usr/local/bin/brew`の場合、変更が必要です。`/opt/homebrew/bin/brew`である必要があります。

### CLTのインストール

まず、以下を実行してCommand Line Tools（CLT）がインストールされていることを確認してください

```shell
$ ls /Library/Developer/CommandLineTools
Library SDKs usr
```

インストールされていない場合は、今すぐインストールしましょう。XCode全体をインストールする必要はありません。[Appleの開発者ページから直接ダウンロード](https://developer.apple.com/download/all/)してCLTのみをインストールできます。安定性のために「Command Line Tools for XCode 14.3.1」のようなベータ版でないものを探してください。

### Rosettaの無効化

次に、Rosettaがインストールされている場合は無効にする必要があります。この[Appleサポート記事](https://support.apple.com/en-us/HT211861)（英語）で確認方法が説明されています。インストールされている場合は、以下の手順に従ってください。

1. 以下を実行してHomebrewをアンインストールします：

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall.sh)"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
```

2. Homebrewを再インストールします：

```Shell
brew install /Users/tarides/Library/Caches/Homebrew/downloads/9e6d2a225119ad88cde6474d39696e66e4f87dc4a4d101243b91986843df691e--libev--4.33.arm64_monterey.bottle.tar.gz
```

3. Homebrewが正しい場所にあるか確認します。以下のように表示されるはずです：

```shell
$ which brew
/opt/homebrew/bin/brew
```

4. ターミナルを閉じる

正しく動作するために、現在のターミナルウィンドウを閉じて新しいものを開くことが重要です。その後、以下のコマンドを実行してください。以下のように表示されたら、brewの準備は完了です！

```shell
$ brew doctor
Your system is ready to brew.
```

### インストールチュートリアルに戻る

問題が解決したので、[OCamlのインストールチュートリアル](/docs/installing-ocaml?lang=ja)に戻ってopamのインストールと初期化を行うことができます。

これでOCamlの学習を続ける準備が整いました！
