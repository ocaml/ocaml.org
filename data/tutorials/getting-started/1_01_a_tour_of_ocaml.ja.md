---
id: tour-of-ocaml
title: OCamlツアー
description: >
  OCaml観光バスに乗りましょう。この初心者向けチュートリアルでは、OCamlの素晴らしい機能を巡ります。最もよく使われる言語機能を見ていきます。
category: "First Steps"
language: Japanese
recommended_next_tutorials:
  - "values-and-functions"
  - "basic-data-types"
  - "loops-recursion"
  - "lists"
---

このチュートリアルでは、OCamlの基本的な機能（値、式、リスト、関数、パターンマッチングなど）を紹介します。

OCamlや関数型プログラミングの知識は必要ありませんが、基本的なソフトウェア開発の知識があることを前提としています。
[OCamlのインストール](/docs/installing-ocaml?lang=ja)ページの説明に従って、OCamlをインストールし、環境を設定しておいてください。

提供する例を実行し、それらを使って実験することをお勧めします。OCamlでのコーディングの感覚をつかむためです。
これには、UTop（ユニバーサルトップレベル）を使用できます。

UTopでは、OCamlのフレーズ（式や値の定義など）を読み込み、評価し、結果を画面に表示することで、ユーザーがOCamlと対話できます。`utop`コマンドを使用してUTopを起動します。`Ctrl+D`を押して終了します。詳細については、[OCamlトップレベル入門](/docs/toplevel-introduction?lang=ja)を参照してください。

このツアーの例にはコメントが含まれているものがあります。OCamlのコメントは`(*`で始まり`*)`で終わり、ネストすることができます。OCamlはコメントを無視するため、空白が許可されている場所であればどこでも使用できます。以下のコードをUTopに入力する際、コメントは省略しても構いません。以下にいくつかの例を示します：

```ocaml
(* Here is a comment *)
(* Outside of the nested comment is still a comment. (* Here is a nested comment *) Outside of the nested comment again. *)
# 50 + (* A comment in between parts of an expression *) 50;;
- : int = 100
```

<!--
The goal of this tutorial is to provide the following capabilities:
- Use UTop to evaluate OCaml expressions interactively
- Trigger evaluation of expressions, understand the output displayed, values and typing
- Write definitions of values and functions
- Write list literals, use basic list operation, pattern match on list values
- Write simple float expressions without typing errors
- Write and patch-match pair and tuples values
- Define a variant types, create and pattern match on values
- Define an immutable record type, create a values, access the fields
- Raise and catch an exception
- Return an error-as-data result, process it using pattern matching
- Declare and update a mutable basic mutable values: references and arrays
- Call functions defined in modules of the OCaml standard library
-->

## 式と定義

簡単な式から始めましょう：

```ocaml
# 50 * 50;;
- : int = 2500
```

OCamlでは、すべてに値があり、すべての値には型があります。上の例は、「`50 * 50`は`int`（整数）型の式で、`2500`に評価される」ことを示しています。名前のない式であるため、名前の代わりに文字`-`が表示されます。

末尾のダブルセミコロン`;;`は、与えられたフレーズを評価して結果を表示するようにトップレベルに指示します。

以下は、他のプリミティブ値と型の例です：

```ocaml
# 6.28;;
- : float = 6.28

# "This is really disco!";;
- : string = "This is really disco!"

# 'a';; (* Note the single quotes *)
- : char = 'a'

# true;;
- : bool = true
```

OCamlには_型推論_があります。プログラマーからの指示をほとんど必要とせずに、式の型を自動的に決定します。_リスト_には[専用のチュートリアル](/docs/lists)があります。当面は、以下の2つの式はどちらもリストです。前者は整数を含み、後者は文字列を含みます。

```ocaml
# let u = [1; 2; 3; 4];;
val u : int list = [1; 2; 3; 4]

# ["this"; "is"; "mambo"];;
- : string list = ["this"; "is"; "mambo"]
```

リストの型`int list`と`string list`は、要素の型から推論されています。リストは空`[]`（「ニル」と読みます）にすることができます。最初のリストには、以下で詳しく説明する`let … = …`構文を使用して名前が付けられていることに注意してください。リストに対する最も基本的な操作は、既存のリストの先頭に新しい要素を追加することです。これは「cons」演算子、ダブルコロン演算子`::`を使って行います。

```ocaml
# 9 :: u;;
- : int list = [9; 1; 2; 3; 4]
```

OCamlでは、`if … then … else …`は文ではなく式です。

```ocaml
# 2 * if "hello" = "world" then 3 else 5;;
- : int = 10
```

`if`で始まり`5`で終わるソースは、2で乗算される単一の整数式として解析されます。OCamlには2つの異なるテスト構文は必要ありません。[三項条件演算子](https://en.wikipedia.org/wiki/Ternary_conditional_operator)と`if … then … else …`は同じものです。また、ここでは括弧が不要であることにも注意してください。OCamlではよくあることです。

`let`キーワードを使用して、値に名前を付けることができます。これは値を名前に_バインド_するといいます。例えば：

```ocaml
# let x = 50;;
val x : int = 50

# x * x;;
- : int = 2500
```

`let x = 50;;`を入力すると、OCamlは`val x : int = 50`と応答します。これは、`x`が値`50`にバインドされた識別子であることを意味します。したがって、`x * x;;`は`50 * 50;;`と同じ結果に評価されます。

OCamlのバインディングは_不変_です。名前に割り当てられた値は変更されません。`x`はしばしば変数と呼ばれますが、実際にはそうではありません。実際には定数です。簡略化した表現ですが、OCamlではすべての変数が不変です。更新可能な値に名前を付けることは可能です。OCamlでは、これを_参照_と呼び、[ミュータブルな状態の操作](/docs/tour-of-ocaml#working-with-mutable-state)セクションで説明します。

OCamlにはオーバーロードがありません。そのため、レキシカルスコープ内では、名前は単一の値を持ち、その定義にのみ依存します。

名前にハイフンを使用しないでください。代わりにアンダースコアを使用してください。例えば、`x_plus_y`は使えますが、`x-plus-y`は使えません。

バインディングには、エディタやツールがバインディングに関連するものとして扱う特別なコメント（「docstring」と呼ばれることもあります）を付けることができます。これはコメントの開始に2番目の`*`を追加することで示されます。例えば：

```ocaml
(** Feet in a mile *)
let feet = 5280;;
val feet : int = 5280
```

これについては、[`odoc` for Authors: Special Comments](https://ocaml.github.io/odoc/odoc/odoc_for_authors.html#special_comments)（英語）でさらに詳しく説明されています。

`let … = … in …`構文を使用して、式内でローカルに名前を定義できます：

```ocaml
# let y = 50 in y * y;;
- : int = 2500

# y;;
Error: Unbound value y
```

この例では、名前`y`を定義し、値`50`にバインドしています。次に、式`y * y`で使用され、値`2500`が得られます。`y`は`in`キーワードに続く式内でのみ定義されていることに注意してください。

`let … = … in …`は式であるため、別の式内で使用して、それぞれ独自の名前を持つ複数の値を定義できます：

```ocaml
# let a = 1 in
  let b = 2 in
    a + b;;
- : int = 3
```

これは2つの名前を定義しています：値`1`の`a`と値`2`の`b`。次に、式`a + b`で使用され、値`3`が得られます。

OCamlでは、等号には2つの意味があります。定義と等価性テストに使用されます。

```ocaml
# let dummy = "hi" = "hello";;
val dummy : bool = false
```

これは「`dummy`を文字列`"hi"`と`"hello"`の構造的等価性テストの結果として定義する」と解釈されます。OCamlにはダブルイコール演算子`==`もあり、これは物理的等価性を意味しますが、このチュートリアルでは使用しません。演算子`<>`は`=`の否定であり、`!=`は`==`の否定です。

## 関数

OCamlでは、すべてが値なので、関数も値です。関数は`let`キーワードを使用して定義されます：

```ocaml
# let square x = x * x;;
val square : int -> int = <fun>

# square 50;;
- : int = 2500
```

この例では、単一のパラメータ`x`を持つ`square`という名前の関数を定義しています。その_関数本体_は式`x * x`です。OCamlには「return」キーワードはありません。

`square`を`50`に適用すると、`x * x`が`50 * 50`に評価され、`2500`になります。

REPLは`square`の型が`int -> int`であることを示しています。これは、引数（入力）として`int`を取り、結果（出力）として`int`を返す関数であることを意味します。関数の値は表示できないため、代わりに`<fun>`が表示されます。

```ocaml
# String.ends_with;;
- : suffix:string -> string -> bool = <fun>

# String.ends_with ~suffix:"less" "stateless";;
- : bool = true
```

`String.ends_with`のような一部の関数にはラベル付きパラメータがあります。ラベルは、関数が同じ型の複数のパラメータを持つ場合に役立ちます。引数に名前を付けることで、その目的を推測できます。上の例では、`~suffix:"less"`は`"less"`がラベル付き引数`suffix`として渡されることを示しています。ラベル付き引数については、[ラベル付き引数](/docs/labels)（英語）チュートリアルで詳しく説明されています。

### 無名関数

_無名_関数には名前がなく、`fun`キーワードで定義されます：

```ocaml
# fun x -> x * x;;
- : int -> int = <fun>
```

無名関数を書いて、すぐに値に適用できます：

```ocaml
# (fun x -> x * x) 50;;
- : int = 2500
```

### 複数のパラメータを持つ関数と部分適用

関数はスペースで区切られた複数のパラメータを持つことができます。

```ocaml
# let cat a b = a ^ " " ^ b;;
val cat : string -> string -> string = <fun>
```

関数`cat`は2つの`string`パラメータ`a`と`b`を持ち、`string`型の値を返します。

```ocaml
# cat "ha" "ha";;
- : string = "ha ha"
```

関数は期待するすべての引数を指定して呼び出す必要はありません。`b`を渡さずに`a`のみを`cat`に渡すことが可能です。

```ocaml
# let cat_hi = cat "hi";;
val cat_hi : string -> string = <fun>
```

これは、`cat`の定義における`b`に対応する、単一の文字列を期待する関数を返します。これを_部分適用_と呼びます。上の例では、`cat`が`"hi"`に部分適用されました。

`cat`の部分適用から得られた関数`cat_hi`は、次のように動作します：

```ocaml
# cat_hi "friend";;
- : string = "hi friend"
```

### 型パラメータと高階関数

関数はパラメータとして関数を受け取ることができます。これを_高階_関数と呼びます。高階関数のよく知られた例は`List.map`です。以下はその使い方です：

```ocaml
# List.map;;
- : ('a -> 'b) -> 'a list -> 'b list = <fun>

# List.map (fun x -> x * x);;
- : int list -> int list = <fun>

# List.map (fun x -> x * x) [0; 1; 2; 3; 4; 5];;
- : int list = [0; 1; 4; 9; 16; 25]
```

この関数の名前が`List.`で始まるのは、リストに作用する定義済みライブラリの一部だからです。この件については後ほど詳しく説明します。関数`List.map`には2つのパラメータがあります：2番目はリストで、1番目はリストの要素に適用できる関数です（要素が何であっても）。`List.map`は、引数として提供された関数を入力リストの各要素に適用して形成されたリストを返します。

関数`List.map`はあらゆる種類のリストに適用できます。ここでは整数のリストが与えられていますが、浮動小数点数、文字列、その他何でもリストにすることができます。これを_多相性_と呼びます。`List.map`関数は多相的であり、2つの暗黙の_型変数_`'a`と`'b`（「アルファ」と「ベータ」と読みます）を持ちます。どちらも何にでもなれますが、`List.map`に渡される関数に関して：

1. 入力リストの要素は、その入力と同じ型を持ちます。
2. 出力リストの要素は、その出力と同じ型を持ちます。

### 副作用と`unit`型

オペレーティングシステムレベルの入出力操作は関数を使用して行われます。以下はそれぞれの例です：

```ocaml
# read_line;;
- : unit -> string = <fun>

# read_line ();;
caramba
- : string = "caramba"

# print_endline;;
- : string -> unit = <fun>

# print_endline "¿Cuándo se come aquí?";;
¿Cuándo se come aquí?
- : unit = ()
```

関数`read_line`は標準入力から文字を読み取り、行末（EOL）に達したときに文字列として返します。関数`print_endline`は文字列を標準出力に出力し、その後にEOLを追加します。

関数`read_line`は処理に必要なデータを必要とせず、関数`print_endline`は返す意味のあるデータがありません。このデータの欠如を示すのが`unit`型の役割で、これらの関数のシグネチャに表示されます。`unit`型には`()`と書かれ「ユニット」と読む、単一の値があります。データが渡されたり返されたりしないが、処理の開始や処理の終了を示すために何らかのトークンを渡す必要がある場合のプレースホルダーとして使用されます。

入出力は、関数の実行時に発生するが関数型には現れないものの例です。これを_副作用_と呼び、I/Oに限りません。`unit`型は副作用の存在を示すためによく使用されますが、常にそうとは限りません。

### 再帰関数

再帰関数は、自身の本体内で自分自身を呼び出します。このような関数は、単なる`let`ではなく`let rec … = …`を使用して宣言する必要があります。再帰はOCamlで反復計算を実行する唯一の手段ではありません。`for`や`while`などのループが利用可能ですが、これらはミュータブルなデータと組み合わせて命令型OCamlを書く場合に使用するものです。それ以外の場合は、再帰関数を使用することが推奨されます。

以下は、2つの境界値の間の連続した整数のリストを作成する関数の例です。

```ocaml
# let rec range lo hi =
    if lo > hi then
      []
    else
      lo :: range (lo + 1) hi;;
val range : int -> int -> int list = <fun>

# range 2 5;;
- : int list = [2; 3; 4; 5]
```

型`int -> int -> int list`が示すように、関数`range`は2つの整数を引数として取り、整数のリストを結果として返します。最初の`int`パラメータ`lo`は範囲の下限、2番目の`int`パラメータ`hi`は上限です。`lo > hi`の場合、空の範囲が返されます。これは`if … then … else`式の最初の分岐です。そうでない場合、`lo`の値は`range`自身を呼び出して作成されたリストの先頭に追加されます。これが再帰です。先頭への追加はOCamlのcons演算子`::`を使用して行われます。既存のリストの先頭に要素を追加して新しいリストを構築します。各呼び出しで進行します。`lo`がリストの先頭に追加されたばかりなので、`range`は`lo + 1`で呼び出されます。これは次のように視覚化できます（これはOCaml構文ではありません）：

```
   range 2 5
=> 2 :: range 3 5
=> 2 :: 3 :: range 4 5
=> 2 :: 3 :: 4 :: range 5 5
=> 2 :: 3 :: 4 :: 5 :: range 6 5
=> 2 :: 3 :: 4 :: 5 :: []
=> [2; 3; 4; 5]
```

各`=>`記号は、最後のものを除いて再帰ステップの計算に対応します。OCamlは内部的にリストを最後から2番目の式のように処理しますが、最後の式のように表示します。これは単なる整形出力です。最後の2つのステップ間では計算は行われません。

## データと型

### 型変換と型推論

OCamlには`float`型の浮動小数点値があります。浮動小数点数を加算するには、`+`の代わりに`+.`を使用する必要があります：

```ocaml
# 2.0 +. 2.0;;
- : float = 4.
```

OCamlでは、`+.`は浮動小数点数同士の加算であり、`+`は整数同士の加算です。

多くのプログラミング言語では、値はある型から別の型に自動的に変換されます。これには_暗黙の型変換_や_昇格_が含まれます。例えば、そのような言語で`1 + 2.5`と書くと、最初の引数（整数）が浮動小数点数に昇格され、結果も浮動小数点数になります。

OCamlは値をある型から別の型に暗黙的に変換することはありません。浮動小数点数と整数の加算を行うことはできません。以下の両方の例はエラーを発生させます：

```ocaml
# 1 + 2.5;;
Error: This expression has type float but an expression was expected of type
         int

# 1 +. 2.5;;
Error: This expression has type int but an expression was expected of type
         float
  Hint: Did you mean `1.'?
```

最初の例では、`+`は整数に使用するためのものなので、`2.5`の浮動小数点数には使用できません。2番目の例では、`+.`は浮動小数点数に使用するためのものなので、`1`の整数には使用できません。

OCamlでは、`float_of_int`関数を使用して整数を浮動小数点数に明示的に変換する必要があります：

```ocaml
# float_of_int 1 +. 2.5;;
- : float = 3.5
```

OCamlが明示的な変換を必要とする理由はいくつかあります。最も重要なのは、型を自動的に推論できるようにすることです。OCamlの_型推論_アルゴリズムは各式の型を計算し、他の言語と比較して非常に少ないアノテーションしか必要としません。議論の余地はありますが、より明示的にすることで失う時間よりも多くの時間を節約できます。

### リスト

リストはOCamlで最も一般的なデータ型かもしれません。同じ型の値の順序付きコレクションです。以下にいくつかの例を示します。

```ocaml
# [];;
- : 'a list = []

# [1; 2; 3];;
- : int list = [1; 2; 3]

# [false; false; true];;
- : bool list = [false; false; true]

# [[1; 2]; [3]; [4; 5; 6]];;
- : int list list = [[1; 2]; [3]; [4; 5; 6]]
```

上の例は次のように読みます：

1. 空のリスト（nil）
1. 数値1、2、3を含むリスト
1. ブール値`false`、`false`、`true`を含むリスト。重複は許可されます。
1. リストのリスト

リストは、空`[]`であるか、要素`x`が別のリスト`u`の先頭に追加されたもの`x :: u`（ダブルコロン演算子は「cons」と読みます）のいずれかとして定義されます。

```ocaml
# 1 :: [2; 3; 4];;
- : int list = [1; 2; 3; 4]
```

OCamlでは、_パターンマッチング_は関数を除くあらゆる種類のデータを検査する手段を提供します。このセクションではリストに対して紹介し、次のセクションで他のデータ型に一般化します。以下は、整数のリストの合計を計算する再帰関数をパターンマッチングを使って定義する方法です：

```ocaml
# let rec sum u =
    match u with
    | [] -> 0
    | x :: v -> x + sum v;;
val sum : int list -> int = <fun>

# sum [1; 4; 3; 2; 5];;
- : int = 15
```
2番目のマッチング式の`x :: v`パターンは、リストを先頭`x`と残り`v`に分解するために使用されます。ここで_先頭_はリストの最初の要素、_残り_はリストの残りの部分です。

#### リストに対する多相関数

以下は、リストの長さを計算する再帰関数の書き方です：

```ocaml
# let rec length u =
    match u with
    | [] -> 0
    | _ :: v -> 1 + length v;; (* _ doesn't define a name; it can't be used in the body *)
val length : 'a list -> int = <fun>

# length [1; 2; 3; 4];;
- : int = 4

# length ["cow"; "sheep"; "cat"];;
- : int = 3

# length [[]];;
- : int = 1
```

この関数は整数のリストだけでなく、あらゆる種類のリストに対して動作します。これは多相関数です。その型は入力が`'a list`型であることを示しており、`'a`は任意の型を表す型変数です。空のリストパターン`[]`は任意の要素型を持つことができます。`_ :: v`パターンも同様で、リストの先頭の値は`_`パターンが示すように検査されないため、無関係です。両方のパターンは同じ型でなければならないため、型推論アルゴリズムは`'a list -> int`型を推論します。

#### 高階関数の定義

関数を別の関数の引数として渡すことが可能です。他の関数をパラメータとして持つ関数を_高階_関数と呼びます。これは先ほど関数`List.map`を使って説明しました。以下は、リストに対するパターンマッチングを使って`map`を書く方法です。

```ocaml
# let square x = x * x;;
val square : int -> int

# let rec map f u =
    match u with
    | [] -> []
    | x :: u -> f x :: map f u;;
val map : ('a -> 'b) -> 'a list -> 'b list = <fun>

# map square [1; 2; 3; 4;];;
- : int list = [1; 4; 9; 16]
```

### パターンマッチング（続き）

パターンマッチングはリストに限定されません。関数を除くあらゆる種類のデータをパターンマッチングで検査できます。パターンは検査される値と比較される式です。`if … then … else …`を使っても実行できますが、パターンマッチングの方が便利です。以下は、[モジュールと標準ライブラリ](#モジュールと標準ライブラリ)セクションで詳しく説明する`option`データ型を使った例です。

```ocaml
# #show option;;
type 'a option = None | Some of 'a

# let f opt = match opt with
    | None -> None
    | Some None -> None
    | Some (Some x) -> Some x;;
val f : 'a option option-> 'a option = <fun>
```

検査される値は`option`型の`opt`です。パターンと上から下に比較されます。`opt`が`None`オプションの場合、最初のパターンとマッチします。`opt`が`Some None`オプションの場合、2番目のパターンとマッチします。`opt`が値を持つ二重ラップされたオプションの場合、3番目のパターンとマッチします。パターンは`let`と同じように名前を導入できます。3番目のパターンでは、`x`は二重ラップされたオプション内のデータを指します。

パターンマッチングについては、[基本データ型](/docs/basic-data-types)（英語）チュートリアルやデータ型ごとのチュートリアルで詳しく説明されています。

この別の例では、`if … then … else …`とパターンマッチングを使って同じ比較を行っています。

```ocaml
# let g x =
  if x = "foo" then 1
  else if x = "bar" then 2
  else if x = "baz" then 3
  else if x = "qux" then 4
  else 0;;
val g : string -> int = <fun>

# let g' x = match x with
    | "foo" -> 1
    | "bar" -> 2
    | "baz" -> 3
    | "qux" -> 4
    | _ -> 0;;
val g' : string -> int = <fun>
```

アンダースコア記号はキャッチオールパターンで、何にでもマッチします。

OCamlはパターンマッチングがすべてのケースをカバーしていない場合に警告を出すことに注意してください：

```ocaml
# fun i -> match i with 0 -> 1;;
Line 1, characters 9-28:
Warning 8 [partial-match]: this pattern-matching is not exhaustive.
Here is an example of a case that is not matched:
1
- : int -> int = <fun>
```

### ペアとタプル

タプルは任意の型の要素の固定長コレクションです。ペアは2つの要素を持つタプルです。以下は3タプルとペアです：

```ocaml
# (1, "one", 'K');;
- : int * string * char = (1, "one", 'K')

# ([], false);;
- : 'a list * bool = ([], false)
```

タプルの要素へのアクセスはパターンマッチングを使って行います。例えば、定義済みの関数`snd`はペアの2番目の要素を返します：

```ocaml
# let snd p =
    match p with
    | (_, y) -> y;;
val snd : 'a * 'b -> 'b = <fun>

# snd (42, "apple");;
- : string = "apple"
```

注：関数`snd`はOCaml標準ライブラリで定義済みです。

タプルの型はコンポーネントの型の間に`*`を使って書きます。

### バリアント型

パターンマッチングが`switch`文を一般化するように、バリアント型は列挙型と共用体型を一般化します。

以下は、列挙データ型として機能するバリアント型の定義です：

```ocaml
# type primary_colour = Red | Green | Blue;;
type primary_colour = Red | Green | Blue

# [Red; Blue; Red];;
- : primary_colour list = [Red; Blue; Red]
```

以下は、共用体型として機能するバリアント型の定義です：

```ocaml
# type http_response =
    | Data of string
    | Error_code of int;;
type http_response = Data of string | Error_code of int

# Data "<!DOCTYPE html>
<html lang=\"en\">
  <head>
    <meta charset=\"utf-8\">
    <title>Dummy</title>
  </head>
  <body>
    Dummy Page
  </body>
</html>";;

- : http_response =
Data
 "<!DOCTYPE html>\n<html lang=\"en\">\n  <head>\n    <meta charset=\"utf-8\">\n    <title>Dummy</title>\n  </head>\n  <body>\n    Dummy Page\n  </body>\n</html>"

# Error_code 404;;
- : http_response = Error_code 404
```

以下はその中間的なものです：

```ocaml
# type page_range =
    | All
    | Current
    | Range of int * int;;
type page_range = All | Current | Range of int * int
```

前述の定義で、大文字で始まる識別子は_コンストラクタ_と呼ばれます。これらはバリアント値の作成を可能にします。これはオブジェクト指向プログラミングとは無関係です。

このセクションの最初の文で示唆されているように、バリアントはパターンマッチングと組み合わせて使います。以下にいくつかの例を示します：

```ocaml
# let colour_to_rgb colour =
    match colour with
    | Red -> (0xff, 0, 0)
    | Green -> (0, 0xff, 0)
    | Blue -> (0, 0, 0xff);;
val colour_to_rgb : primary_colour -> int * int * int = <fun>

# let http_status_code response =
    match response with
    | Data _ -> 200
    | Error_code code -> code;;
val http_status_code : http_response -> int = <fun>

# let is_printable page_count cur range =
    match range with
    | All -> true
    | Current -> 0 <= cur && cur < page_count
    | Range (lo, hi) -> 0 <= lo && lo <= hi && hi < page_count;;
val is_printable : int -> int -> page_range -> bool = <fun>
```

関数と同様に、バリアントも自身の定義内で自分自身を参照する場合、再帰的になれます。定義済みの型`list`はそのようなバリアントの例です：

```ocaml
# #show list;;
type 'a list = [] | (::) of 'a * 'a list
```

先ほど示したように、`sum`、`length`、`map`関数はリストバリアント型に対するパターンマッチングの例を提供しています。

### レコード

タプルと同様に、レコードも複数の型の要素をまとめます。ただし、各要素には名前が付けられます。バリアント型と同様に、レコード型は使用する前に定義する必要があります。以下は、レコード型、値、コンポーネントへのアクセス、同じレコードに対するパターンマッチングの例です。

```ocaml
# type person = {
    first_name : string;
    surname : string;
    age : int
  };;
type person = { first_name : string; surname : string; age : int; }

# let gerard = {
     first_name = "Gérard";
     surname = "Huet";
     age = 76
  };;
val gerard : person = {first_name = "Gérard"; surname = "Huet"; age = 76}
```

`gerard`を定義する際、型を宣言する必要はありません。型チェッカーは、名前と型が一致する3つのフィールドを持つレコードを検索します。レコード間に型の関係はないことに注意してください。フィールドを追加して別のレコードを拡張するレコード型を宣言することはできません。レコード型の検索は完全一致が見つかった場合に成功し、それ以外の場合は失敗します。

```ocaml
# let s = gerard.surname;;
val s : string = "Huet"

# let is_teenager person =
    match person with
    | { age = x; _ } -> 13 <= x && x <= 19;;
val is_teenager : person -> bool = <fun>

# is_teenager gerard;;
- : bool = false
```

ここで、パターン`{ age = x; _ }`は`int`型の`age`フィールドを持つ最も最近宣言されたレコード型で型付けされます。`int`型は式`13 <= x && x <= 19`から推論されます。関数`is_teenager`は、見つかったレコード型（ここでは`person`）でのみ動作します。

## エラーの処理

### 例外

計算が中断されると、例外がスローされます。例えば：

```ocaml
# 10 / 0;;
Exception: Division_by_zero.
```

例外は`raise`関数を使って発生させます。

```ocaml
# let id_42 n = if n <> 42 then raise (Failure "Sorry") else n;;
val id_42 : int -> int = <fun>

# id_42 42;;
- : int = 42

# id_42 0;;
Exception: Failure "Sorry".
```

例外は関数の型には現れないことに注意してください。

例外は`try … with …`構文を使ってキャッチします：

```ocaml
# try id_42 0 with Failure _ -> 0;;
- : int = 0
```

標準ライブラリにはいくつかの定義済み例外があります。例外を定義することも可能です。

### `result`型の使用

OCamlでエラーを処理するもう一つの方法は、`result`型の値を返すことです。
これは正しい結果またはエラーのいずれかを表すことができます。以下はその定義です：

```ocaml
# #show result;;
type ('a, 'b) result = Ok of 'a | Error of 'b
```

したがって、次のように書くことができます：

```ocaml
# let id_42_res n = if n <> 42 then Error "Sorry" else Ok n;;
val id_42_res : int -> (int, string) result = <fun>

# id_42_res 42;;
- : (int, string) result = Ok 42

# id_42_res 0;;
- : (int, string) result = Error "Sorry"

# match id_42_res 0 with
  | Ok n -> n
  | Error _ -> 0;;
- : int = 0
```

## ミュータブルな状態の操作

OCamlは命令型プログラミングをサポートしています。通常、`let … = …`構文は変数を定義するのではなく、定数を定義します。ただし、OCamlにはミュータブルな変数が存在します。それらは_参照_と呼ばれます。以下は整数への参照を作成する方法です：

```ocaml
# let r = ref 0;;
val r : int ref = {contents = 0}
```

初期化されていない参照やnull参照を作成することは構文的に不可能です。参照`r`は整数ゼロで初期化されています。参照の内容にアクセスするには、`!`逆参照演算子を使用します。

```ocaml
# !r;;
- : int = 0
```

`!r`と`r`は異なる型を持つことに注意してください：それぞれ`int`と`int ref`です。整数と浮動小数点数の乗算ができないのと同様に、整数を更新したり参照を乗算したりすることはできません。

`r`の内容を更新しましょう。ここで`:=`は代入演算子です。

```ocaml
# r := 42;;
- : unit = ()
```

参照の内容を変更することは副作用であるため、`()`が返されます。

```ocaml
# !r;;
- : int = 42
```

`;`演算子を使って式を順番に実行します。`a; b`と書くと、`a`を実行し、完了したら`b`を実行して、`b`の値のみを返します。

```ocaml
# let text = ref "hello ";;
val text : string ref = {contents = "hello "}

# print_string !text; text := "world!"; print_endline !text;;
hello world!
- : unit = ()
```

2行目で発生する副作用は以下の通りです：

1. 参照`text`の内容を標準出力に表示
1. 参照`text`の内容を更新
1. 参照`text`の内容を標準出力に表示

この動作は命令型言語と同じです。ただし、`;`は関数として定義されていませんが、`unit -> unit -> unit`型の関数であるかのように動作します。

## モジュールと標準ライブラリ

OCamlでソースコードを整理するには_モジュール_を使用します。モジュールは定義のグループです。_標準ライブラリ_はすべてのOCamlプログラムで利用可能なモジュールのセットです。以下は、標準ライブラリの`Option`モジュールに含まれる定義を一覧表示する方法です：

```ocaml
# #show Option;;
module Option :
  sig
    type 'a t = 'a option = None | Some of 'a
    val none : 'a t
    val some : 'a -> 'a t
    val value : 'a t -> default:'a -> 'a
    val get : 'a t -> 'a
    val bind : 'a t -> ('a -> 'b t) -> 'b t
    val join : 'a t t -> 'a t
    val map : ('a -> 'b) -> 'a t -> 'b t
    val fold : none:'a -> some:('b -> 'a) -> 'b t -> 'a
    val iter : ('a -> unit) -> 'a t -> unit
    val is_none : 'a t -> bool
    val is_some : 'a t -> bool
    val equal : ('a -> 'a -> bool) -> 'a t -> 'a t -> bool
    val compare : ('a -> 'a -> int) -> 'a t -> 'a t -> int
    val to_result : none:'e -> 'a t -> ('a, 'e) result
    val to_list : 'a t -> 'a list
    val to_seq : 'a t -> 'a Seq.t
  end
```

モジュールが提供する定義は、モジュール名をプレフィックスとして名前に追加することで参照されます。

```ocaml
# Option.map;;
- : ('a -> 'b) -> 'a option -> 'b option = <fun>

# Option.map (fun x -> x * x);;
- : int option -> int option = <fun>

# Option.map (fun x -> x * x) None;;
- : int option = None

# Option.map (fun x -> x * x) (Some 8);;
- : int option = Some 64
```

ここでは、関数`Option.map`の使い方をいくつかのステップで説明しています。

1. 型を表示します。2つのパラメータがあります：`'a -> 'b`型の関数と`'a option`。
1. 部分適用を使って、`fun x -> x * x`のみを渡します。結果の関数の型を確認します。
1. `None`で適用します。
1. `Some 8`で適用します。

提供されたオプション値に実際の値が含まれている場合（つまり`Some`何かの場合）、提供された関数を適用し、その結果をオプションにラップして返します。提供されたオプション値に何も含まれていない場合（つまり`None`の場合）、結果にも何も含まれません（つまり`None`も返されます）。

このセクションで先ほど使用した`List.map`関数も、`List`モジュールの一部です。

```ocaml
# List.map;;
- : ('a -> 'b) -> 'a list -> 'b list = <fun>

# List.map (fun x -> x * x);;
- : int list -> int list = <fun>
```

これはOCamlモジュールシステムの最初の特徴を示しています。名前の衝突を防ぐことで関心の分離を可能にします。異なる型を持つ2つの関数が、異なるモジュールによって提供されている場合、同じ名前を持つことができます。

モジュールは効率的な分割コンパイルも可能にします。これは次のチュートリアルで説明されます。

## まとめ

<!--
1. Values and Functions
1. Functions
1. Type-Inference
-->

このチュートリアルでは、OCamlを対話的に使用しました。次のチュートリアル「[はじめてのOCamlプログラム](/docs/your-first-program?lang=ja)」では、OCamlファイルの書き方、コンパイル方法、プロジェクトの始め方を説明します。
