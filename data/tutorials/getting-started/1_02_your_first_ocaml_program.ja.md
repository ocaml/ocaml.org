---
id: your-first-program
title: はじめてのOCamlプログラム
description: >
  はじめてのOCamlプログラムを書く方法を学びましょう。
category: "First Steps"
language: Japanese
recommended_next_tutorials:
  - "values-and-functions"
  - "basic-data-types"
  - "loops-recursion"
  - "lists"
---

このチュートリアルを完了するには、[OCamlをインストール](/install)している必要があります。オプションとして、[エディタの設定](/docs/set-up-editor?lang=ja)をお勧めします。

OCamlのソースコードを含むファイルを作成し、実行可能なバイナリを生成するためにコンパイルします。ただし、これはOCamlのコンパイル、プロジェクトのモジュール化、依存関係管理に関する詳細なチュートリアルではありません。それらのトピックの概要を示すだけです。目標は、詳細に迷わないように全体像を描くことです。つまり、深さ優先学習ではなく幅優先学習を行います。

前のチュートリアルでは、ほとんどのコマンドをUTopで入力しました。このチュートリアルでは、コマンドの大部分をターミナルで入力します。ドル記号`$`で始まるコード例はターミナルで入力することを意図しており、ハッシュ記号`#`で始まる行はUTopで入力することを意図しています。

このチュートリアルを完了すると、OCamlのビルドシステムであるDuneを使用してOCamlプロジェクトを作成、コンパイル、実行できるようになります。ファイルの操作、モジュール内のプライベートな定義の作成、opamパッケージのインストールと使用方法を学びます。

<!--
Once you've completed this tutorial, you should be able to:
- Create an OCaml project from scratch, using Dune
- Trigger project compilation and execution using Dune
- Delete files in an automatically created project without breaking everything
- Split code in several files, use imported definitions
- Make a definition private
- Download, install, and use a package from the open source repository

How to work on several OCaml projects simultaneously is out of the scope of this tutorial. Currently (Summer 2023), this requires using opam local [_switches_](https://opam.ocaml.org/doc/man/opam-switch.html). This allows handling different sets of dependencies per project. Check the Best Practices document on [Dependencies](https://ocaml.org/docs/managing-dependencies) addressing that matter for detailed instructions. This document was written and tested using a global switch, which is created by default when installing opam and can be ignored in the beginning.
-->

**注意**: このチュートリアルのファイルは[Gitリポジトリ](https://github.com/ocaml-web/ocamlorg-docs-your-first-program)として公開されています。

## opamスイッチ内での作業

OCamlをインストールした際に、グローバルopamスイッチが自動的に作成されました。このチュートリアルは、このグローバルopamスイッチ内で作業しながら完了できます。

複数のOCamlプロジェクトを同時に作業する場合は、追加のopamスイッチを作成する必要があります。その方法については、[opamスイッチ入門](/docs/opam-switch-introduction?lang=ja)を参照してください。

## OCamlプログラムのコンパイル

デフォルトで、OCamlには2つのコンパイラが付属しています：ソースをネイティブバイナリに変換するコンパイラと、ソースをバイトコード形式に変換するコンパイラです。OCamlには、そのバイトコード形式のインタプリタも付属しています。このチュートリアルでは、ネイティブコンパイラを使用してOCamlプログラムを作成する方法を示します。

<!-- Other compilers exist, for instance, [js_of_ocaml](https://ocsigen.org/js_of_ocaml) generates JavaScript. The toplevel uses the bytecode compiler; expressions are read, type-checked, compiled into bytecode, and executed. The previous tutorial was interactive because we used the toplevel. -->

まず、Duneを使用して従来の「Hello, World!」プロジェクトをセットアップします。バージョン3.12以降がインストールされていることを確認してください。以下のコマンドで`hello`という名前のプロジェクトを作成します：

```shell
$ opam exec -- dune init proj hello
Success: initialized project component named hello
```

**注1**: 現在のターミナルセッションの開始時に`eval $(opam env)`を実行した場合、または`opam init`実行時の質問に「はい」と答えた場合、`dune`コマンドの先頭にある`opam exec --`を省略できます。

**注2**: このチュートリアル全体を通して、Duneによって生成される出力は、インストールされているDuneのバージョンによってわずかに異なる場合があります。このチュートリアルではDune 3.12の出力を表示しています。最新バージョンのDuneを入手したい場合は、ターミナルで`opam update; opam upgrade dune`を実行してください。

プロジェクトは`hello`という名前のディレクトリに保存され、以下の内容を含みます：

```shell
hello
├── bin
│   ├── dune
│   └── main.ml
├── _build
│   └── log
├── dune-project
├── hello.opam
├── lib
│   └── dune
└── test
    ├── dune
    └── hello.ml
```

Unixではコンパイルされたバイナリが含まれますが、`lib`と`bin`ディレクトリにはそれぞれライブラリとプログラムのソースコードファイルが含まれます。これは多くのOCamlプロジェクト（Duneで作成されたものを含む）で使用される慣例です。すべてのビルド成果物とソースのコピーは`_build`ディレクトリに保存されます。`_build`ディレクトリ内のものを編集しないでください。手動の編集は後続のビルド時に上書きされます。

OCamlソースファイルには`.ml`拡張子があり、「Meta Language」の略です。Meta Language（ML）はOCamlの先祖です。これが「OCaml」の「ml」の由来でもあります。以下は`bin/main.ml`ファイルの内容です：

```ocaml
let () = print_endline "Hello, World!"
```

プロジェクト全体のメタデータは`dune-project`ファイルにあります。プロジェクト名、依存関係、グローバルセットアップに関する情報が含まれています。

ビルドが必要なソースファイルを含む各ディレクトリには、ビルド方法を記述した`dune`ファイルが必要です。

これでプロジェクトをビルドします：

```shell
opam exec -- dune build
```

これで作成された実行可能ファイルを起動します：

```shell
$ opam exec -- dune exec hello
Hello, World!
```

`bin/main.ml`ファイルを直接編集するとどうなるか見てみましょう。エディタでファイルを開き、`World`をあなたの名前に置き換えてください。前と同じように`dune build`でプロジェクトを再コンパイルし、`dune exec hello`で再度起動してください。

これで完了です！はじめてのOCamlプログラムを書きました。

このチュートリアルの残りでは、OCamlのツールを説明するために、このプロジェクトにさらに変更を加えます。

## ウォッチモード

本題に入る前に、Duneのウォッチモードを使用して、継続的にコンパイルし、オプションでプログラムを再起動することが一般的です。これにより、言語サーバーがプロジェクトに関する最新のデータを持つことが保証され、エディタのサポートが最高の状態になります。ウォッチモードを使用するには、`-w`フラグを追加するだけです：

```shell
opam exec -- dune build -w
opam exec -- dune exec hello -w
```

## なぜmain関数がないのか？

`bin/main.ml`の名前はプロジェクトへのアプリケーションのエントリポイントを含むことを示唆していますが、専用の`main`関数は含まれておらず、実行可能ファイルを生成するためにプロジェクトにその名前のファイルが必要という要件もありません。コンパイルされたOCamlファイルは、そのファイルがトップレベルに1行ずつ入力されたかのように動作します。言い換えれば、実行可能なOCamlファイルのエントリポイントは最初の行です。

ソースファイルでは、トップレベルのようにダブルセミコロンは必要ありません。文は上から下へ順番に処理され、それぞれが持つ副作用がトリガーされます。定義は環境に追加されます。名前のない式から得られる値は無視されます。これらすべての副作用は同じ順序で発生します。これがOCamlのmainです。

ただし、すべての副作用をトリガーする値を1つ選び出し、意図されたメインエントリポイントとしてマークするのが一般的な慣行です。OCamlでは、`let () =`がその役割を果たし、名前を作成せずに右辺の式（すべての副作用を含む）を評価します。

## モジュールと標準ライブラリ（続き）

[OCamlツアー](/docs/tour-of-ocaml?lang=ja)でモジュールについて述べたことをまとめましょう：

- モジュールは名前付き値のコレクションです。
- 異なるモジュールの同名の定義は衝突しません。
- 標準ライブラリは複数のモジュールのコレクションです。

モジュールはプロジェクトの整理に役立ちます。関心事を分離したモジュールに分けることができます。これは次のセクションで概説します。自分でモジュールを作成する前に、標準ライブラリのモジュールから定義を使用する方法を示します。`bin/main.ml`ファイルの内容を次のように変更してください：

```ocaml
let () = Printf.printf "%s\n" "Hello, World!"
```

これは`print_endline`関数を標準ライブラリの`Printf`モジュールの`printf`関数に置き換えます。この変更版をビルドして実行すると、以前と同じ出力が得られるはずです。`dune exec hello`で試してみてください。

## すべてのファイルがモジュールを定義する

各OCamlファイルは、コンパイルされるとモジュールを定義します。これがOCamlの分割コンパイルの仕組みです。十分に独立した各関心事はモジュールに分離する必要があります。外部モジュールへの参照は依存関係を作成します。モジュール間の循環依存は許可されていません。

モジュールを作成するために、以下の内容を含む`lib/en.ml`という新しいファイルを作成しましょう：

```ocaml
let v = "Hello, world!"
```

以下は`bin/main.ml`ファイルの新しいバージョンです：

```ocaml
let () = Printf.printf "%s\n" Hello.En.v
```

結果のプロジェクトを実行してみましょう：

```shell
$ opam exec -- dune exec hello
Hello, world!
```

ファイル`lib/en.ml`は`En`という名前のモジュールを作成し、`v`という名前の文字列値を定義します。Duneは`En`を`Hello`と呼ばれる別のモジュールにラップします。この名前は`lib/dune`ファイルの`name hello`スタンザによって定義されています。文字列の定義は`bin/main.ml`ファイルから`Hello.En.v`としてアクセスされます。

Duneは、プロジェクトが公開するモジュールに対話的にアクセスするためにUTopを起動できます。方法は以下の通りです：

```shell
opam exec -- dune utop
```

次に、`utop`トップレベル内で`Hello.En`モジュールを調べることができます：

```ocaml
# #show Hello.En;;
module Hello : sig val v : string end
```

次のセクションに進む前に、`Ctrl-D`で`utop`を終了するか、`#quit;;`と入力してください。

**注意**: `lib`ディレクトリに`hello.ml`という名前のファイルを追加すると、Duneはそれを`Hello`モジュール全体とみなし、`En`にアクセスできなくなります。モジュール`En`を可視にしたい場合は、`hello.ml`ファイルに以下を追加する必要があります：

```ocaml
module En = En
```
<!-- FIXME refer to Dune/Library tutorial when available -->

## モジュールインターフェースの定義

UTopの`#show`コマンドは[API](https://en.wikipedia.org/wiki/API#Libraries_and_frameworks)（ソフトウェアライブラリの意味）を表示します：モジュールが提供する定義のリストです。OCamlでは、これを_モジュールインターフェース_と呼びます。`.ml`ファイルはモジュールを定義します。同様に、`.mli`ファイルはモジュールインターフェースを定義します。モジュールインターフェースファイルは、対応するモジュールファイルと同じベース名を持つ必要があります。例えば、`en.mli`はモジュール`en.ml`のモジュールインターフェースです。以下の内容で`lib/en.mli`ファイルを作成してください：

```ocaml
val v : string
```

モジュールシグネチャの宣言リスト（`#show`出力の`sig`と`end`の間にあるもの）のみがインターフェースファイル`lib/en.mli`に書かれていることに注意してください。これについては、[モジュール](/docs/modules)（英語）の専用チュートリアルでさらに詳しく説明されています。

モジュールインターフェースは_プライベート_な定義を作成するためにも使用されます。モジュールの定義が対応するモジュールインターフェースに記載されていない場合、その定義はプライベートです。モジュールインターフェースファイルが存在しない場合、すべてがパブリックです。

お好みのエディタで`lib/en.ml`ファイルを修正してください。既存の内容を以下に置き換えてください：

```ocaml
let hello = "Hello"
let v = hello ^ ", world!"
```

`bin/main.ml`ファイルも次のように編集してください：

```ocaml
let () = Printf.printf "%s\n" Hello.En.hello
```

これをコンパイルしようとすると失敗します。

```shell
$ opam exec -- dune build
File "hello/bin/main.ml", line 1, characters 30-43:
1 | let () = Printf.printf "%s\n" Hello.En.hello
                                  ^^^^^^^^^^^^^^
Error: Unbound value Hello.En.hello
```

これは`lib/en.mli`を変更していないためです。`hello`が記載されていないので、プライベートのままです。

## ライブラリ内での複数モジュールの定義

単一のライブラリ内に複数のモジュールを定義できます。これを示すために、以下の内容で`lib/es.ml`という新しいファイルを作成してください：

```ocaml
let v = "¡Hola, mundo!"
```

`bin/main.ml`で新しいモジュールを使用します：

```ocaml
let () = Printf.printf "%s\n" Hello.Es.v
let () = Printf.printf "%s\n" Hello.En.v
```

最後に、`dune build`と`dune exec hello`を実行して、`hello`ライブラリで作成したモジュールを使った新しい出力を確認してください。

```shell
$ opam exec -- dune exec hello
¡Hola, mundo!
Hello, world!
```

モジュールのより詳しい紹介は[モジュール](/docs/modules)（英語）にあります。

## パッケージからモジュールをインストールして使用する

OCamlには活発なオープンソースコントリビュータのコミュニティがあります。ほとんどのプロジェクトはopamパッケージマネージャーを使用して利用でき、[OCamlのインストール](/docs/up-and-ready)チュートリアルでインストールしました。以下のセクションでは、opamのオープンソースリポジトリからパッケージをインストールして使用する方法を示します。

これを説明するために、`hello`プロジェクトを更新して、[S式](https://en.wikipedia.org/wiki/S-expression)を含む文字列を解析し、[Sexplib](https://github.com/janestreet/sexplib)を使用して文字列に変換して表示します。まず、`opam update`を実行してopamのパッケージリストを更新してください。次に、以下のコマンドで`Sexplib`パッケージをインストールします：

```shell
opam install sexplib
```

次に、`bin/main.ml`で有効なS式を含む文字列を定義します。`Sexplib.Sexp.of_string`関数でS式に解析し、`Sexplib.Sexp.to_string`で文字列に変換して表示します。

```ocaml
(* Read in Sexp from string *)
let exp1 = Sexplib.Sexp.of_string "(This (is an) (s expression))"

(* Do something with the Sexp ... *)

(* Convert back to a string to print *)
let () = Printf.printf "%s\n" (Sexplib.Sexp.to_string exp1)
```

入力した有効なS式を表す文字列は、S式型に解析されます。S式型は`Atom`（文字列）またはS式の`List`（再帰的な型）として定義されています。詳細は[Sexplib ドキュメント](https://github.com/janestreet/sexplib)（英語）を参照してください。

この例をビルドして実行する前に、プロジェクトのコンパイルに`Sexplib`が必要であることをDuneに伝える必要があります。`bin/dune`ファイルの`library`スタンザに`Sexplib`を追加してください。完全な`bin/dune`ファイルは以下のようになります。

```lisp
(executable
 (public_name hello)
 (name main)
 (libraries hello sexplib))
```

**豆知識**: Dune設定ファイルはS式です。

最後に、前と同じように実行します：

```shell
$ opam exec -- dune exec hello
(This(is an)(s expression))
```

## プリプロセッサを使用したコード生成

<!-- https://github.com/ocaml/ocaml.org/pull/2249 -->
**注意**: この例はDkML 2.1.0を使用してWindowsでテストに成功しています。`dkml version`を実行してバージョンを確認してください。

`hello`の出力をUTopでの文字列リストのように表示したいとしましょう：`["hello"; "using"; "an"; "opam"; "library"]`。そのためには、`string list`を`string`に変換し、括弧、スペース、カンマを追加する関数が必要です。自分で定義する代わりに、パッケージを使って自動生成しましょう。[`ppx_deriving`](https://github.com/ocaml-ppx/ppx_deriving)を使用します。インストール方法は以下の通りです：

```shell
opam install ppx_deriving
```

Duneにその使い方を伝える必要があります。これは`lib/dune`ファイルで行います。これは先ほど編集した`bin/dune`ファイルとは異なることに注意してください！`lib/dune`ファイルを開き、以下のように編集してください：

```lisp
(library
 (name hello)
 (preprocess (pps ppx_deriving.show)))
```

`(preprocess (pps ppx_deriving.show))`の行は、コンパイル前にソースを`ppx_deriving`パッケージが提供する`show`プリプロセッサを使用して変換する必要があることを意味します。`(libraries ppx_deriving)`を書く必要はなく、Duneは`preprocess`スタンザからそれを推論します。

`lib/en.ml`と`lib/en.mli`ファイルも編集する必要があります：

**`lib/en.mli`**

```ocaml
val string_of_string_list : string list -> string
val v : string list
```

**`lib/en.ml`**

```ocaml
let string_of_string_list = [%show: string list]

let v = String.split_on_char ' ' "Hello using an opam library"
```

下から読んでいきましょう：

- `v`は`string list`型です。`String.split_on_char`を使用して、スペース文字で分割することで`string`を`string list`に変換しています。
- `string_of_string_list`は`string list -> string`型です。文字列のリストを、期待される書式を適用して文字列に変換します。

最後に、`bin/main.ml`も編集する必要があります

```ocaml
let () = print_endline Hello.En.(string_of_string_list v)
```

結果は以下の通りです：

```shell
$ opam exec -- dune exec hello
["Hello"; "using"; "an"; "opam"; "library"]
```

## ワンストップショップとしてのDuneを覗く

このセクションでは、`dune init proj`によって作成されたがこれまで言及されていなかったファイルとディレクトリの目的を説明します。

OCamlの歴史の中で、いくつかのビルドシステムが使用されてきました。このチュートリアルを執筆している時点（2023年夏）では、Duneが主流であり、そのためこのチュートリアルで使用しています。Duneはファイルからモジュール間の依存関係を自動的に抽出し、互換性のある順序でコンパイルします。ビルドするものがある各ディレクトリに1つの`dune`ファイルのみが必要です。`dune init proj`で作成される3つのディレクトリには以下の目的があります：

- `bin`: 実行可能プログラム
- `lib`: ライブラリ
- `test`: テスト

Dune専用のチュートリアルが用意される予定です。そのチュートリアルでは、Duneの多くの機能が紹介されますが、そのうちのいくつかをここに挙げます：

- テストの実行
- ドキュメントの生成
- パッケージングメタデータの生成（ここでは`hello.opam`）
- 汎用ルールを使用した任意のファイルの作成

`_build`ディレクトリはDuneが生成するすべてのファイルを保存する場所です。いつでも削除できますが、後続のビルドで再作成されます。

## 最小セットアップ

この最後のセクションでは、Duneが動作するために本当に必要なものを強調して、必要最小限のプロジェクトを作成しましょう。まず、新しいプロジェクトディレクトリを作成します：

```shell
cd ..
mkdir minimo
cd minimo
```

最低限、Duneには`dune-project`と1つの`dune`ファイルの2つのファイルのみが必要です。できるだけ少ないテキストで書く方法は以下の通りです：

`dune-project`

```lisp
(lang dune 3.6)
```

`dune`

```lisp
(executable (name minimo))
```

`minimo.ml`

```ocaml
let () = print_endline "My name is Minimo"
```

これだけです！これでDuneが`minimo.ml`ファイルをビルドして実行するのに十分です。

```shell
$ opam exec -- dune exec ./minimo.exe
My name is Minimo
```

**注意**: `minimo.exe`はファイル名ではありません。これは、バイトコードコンパイラの代わりにOCamlのネイティブコンパイラを使用して`minimo.ml`ファイルをコンパイルするようにDuneに指示する方法です。豆知識として、空のファイルも有効なOCaml構文であることに注意してください。これを使って`minimo`をさらに縮小できます。もちろん何も表示されませんが、有効なプロジェクトになります！

## まとめ

このチュートリアルは「はじめの一歩」シリーズの最後です。ここから先は、自分の学習パスに従って他のチュートリアルを選んで進めるのに十分な知識があります。

<!--
TODO: link Project Quickstart If you're already familiar with lists, maps, and folds, and need to be productive as fast as possible, dive into the "Project Quickstart" guide.
-->
