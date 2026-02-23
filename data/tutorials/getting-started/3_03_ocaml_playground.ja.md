---
id: ocaml-playground
title: OCaml Playgroundの使い方
short_title: OCaml Playground
description: |
  このページでは、OCaml Playgroundの使い方を説明します
category: "Resources"
language: Japanese
---

OCamlのブラウザ内プレイグラウンドへようこそ！

[OCaml Playground](https://ocaml.org/play)は、特に初心者がインストールを心配することなくOCamlを始められるように作られています。開いたらすぐに使用できます。

シンプルなインターフェースで、左側に_エディタパネル_、右側に_出力パネル_の2つのパネルがあります。

エディタパネルはコードを書く場所で、出力パネルは結果が表示される場所です。とても簡単です。

ある意味、プレイグラウンドは[トップレベル](https://ocaml.org/docs/toplevel-introduction)よりもずっとシンプルです。プロンプト上で1行ずつコードを入力する必要はなく、代わりにエディタパネルにコードを直接入力またはコピーします。また、式を`;;`で終わらせる必要もありません。エディタパネルのコードを実行するには、エディタパネルの下部にある「Run」ボタンをクリックしてください。

OCamlコードを書くファイルのようなものだと考えてください。出力パネルの「Clear output」ボタンをクリックすることで、いつでも出力をクリアできます。心配しないでください、エディタパネルのコードには影響しません。

エディタパネルの下部にある「Share」ボタン（「Run」ボタンの左側）をクリックすることで、書いたコードを他の人と共有することもできます。「Share」をクリックした後、URLをコピーして他の人と共有してください。

困ったときは、上部の検索バーを使って標準ライブラリを調べることもできます。

## コードを入力してみましょう

プレイグラウンドに初めて入ると、以下のような画面が表示されます。

![OCaml Playground](/media/tutorials/get-started/playground.png)

慌てないでください！エディタパネルには説明とサンプルコードが、出力パネルにはOCamlのバージョンとコンパイル情報が表示されているだけです。

Ctrl+AとBackspaceを押すだけでエディタパネルをクリアし、OCamlコードを書き始めることができます。同様に、出力パネルの「Clear output」ボタンを押すとパネルをクリアできます。

簡単なものから始めましょう。エディタパネルに以下を入力して「Run」をクリックしてください。

```
2+3
```

以下のような出力が表示されるはずです。

`- : int = 5`

次に、出力をクリアし、エディタパネルの内容も削除してください。文字列を試してみましょう。エディタパネルに以下を入力して「Run」をクリックしてください。

```
"OCaml is amazing"
```

以下のような出力が表示されるはずです。

`- : string = "OCaml is amazing"`

素晴らしいですね！順調です。では、短いプログラムを書いてみましょう。プレイグラウンドに入ったときに見たコードサンプルを使います。

```
let num_domains = 2
let n = 20

let rec fib n =
  if n < 2 then 1
  else fib (n-1) + fib (n-2)

let rec fib_par n d =
  if d <= 1 then fib n
  else
    let a = fib_par (n-1) (d-1) in
    let b = Domain.spawn (fun _ -> fib_par (n-2) (d-1)) in
    a + Domain.join b

let () =
  let res = fib_par n num_domains in
  Printf.printf "fib(%d) = %d\n" n res
```

出力は以下のようになります。

```
fib(20) = 10946

val num_domains : int = 2
val n : int = 20
val fib : int -> int = <fun>
val fib_par : int -> int -> int = <fun>
```

## オートコンプリート

プレイグラウンドはコード補完もサポートしています。コンテキストに基づいてユーザーの入力を提案・補完することで支援します。

![OCaml Playgroundのオートコンプリート](/media/tutorials/get-started/playground-autocomplete.png)

## 注意点

上のコードサンプルからわかるように、定義の末尾に`;;`を使用する必要はありません。

ここで少し注意すべき点は、プレイグラウンドはOCamlトップレベルとは異なる動作をするということです。
「Run」ボタンをクリックするたびに、すべての式と定義が順番に評価されます。
`2+3`と書いて次の行に文字列`"this is a string"`と書くと（[こちらを参照](/play#code=MiszCiJ0aGlzIGlzIGEgc3RyaW5nIg%3D%3D)）、以下のようなエラーが表示されます：

```
Line 1, characters 2-3:
Error: This expression has type int
       This is not a function; it cannot be applied.
```

一方、これらの式を`;;`で区切った場合（[このように](/play#code=MiszOzsKInRoaXMgaXMgYSBzdHJpbmci)）、またはそれらを名前にバインドした場合（[このように](/play#code=bGV0IHggPSAyKzMKbGV0IHkgPSAidGhpcyBpcyBhIHN0cmluZyI%3D)）は、1つずつ正常に評価されます。

## まとめ

おめでとうございます！最後まで読んでいただきました。これで、[OCaml Playground](/play)の使い方についてより良い理解が得られたと思います。OCamlコードの練習に活用して楽しんでください。Happy Hacking！
