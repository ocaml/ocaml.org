---
id: basic-data-types
title: Basic Data Types and Pattern Matching
description: |
  Predefined Types, Variants, Records, and Pattern Matching
category: "Introduction"
prerequisite_tutorials: 
  - "tour-of-ocaml"
  - "values-and-functions"
---

## Introduction

This document covers atomic types, such as integers and Booleans; predefined compound types, like strings and lists; and user-defined types, namely variants and records. We show how to pattern matching on those types.

In OCaml, there are no type checks at runtime, and values don't change type unless explicitly converted. This is what being statically- and strongly-typed means. This allows safe processing of structured data.

**Note**: As in previous tutorials, expressions after `#` and ending with `;;` are for the toplevel, like UTop.

<!--
The goal of this tutorial is to provide for the following capabilities:
- Handle data of all predefined types using dedicated syntax
- Write variant type definitions: simple, recursive, and polymorphic
- Write record type definitions (without mutable fields)
- Write type aliases
- Use pattern matching to define functions for all basic type
-->

## Predefined Types

### Integers, Floats, Booleans, and Characters

#### Integers

The `int` type is the default and basic integer type in OCaml. When you enter a whole number, OCaml recognises it as an integer, as shown in this example:
```ocaml
# 42;;
- : int = 42
```

The `int` type represents platform-dependent signed integers. This means `int` does not always have same the number of bits. It depends on underlying platform characteristics, such as processor architecture or operating system. Operations on `int` values are provided by the [`Stdlib`](/manual/api/Stdlib.html) and the [`Int`](/manual/api/Int.html) modules.

Usually, `int` has 31 bits in 32-bit architectures and 63 in 64-bit architectures, because one bit is reserved for OCaml's runtime operation. The standard library also provides [`Int32`](/manual/api/Int32.html) and [`Int64`](/manual/api/Int64.html) modules, which support platform-independent operations on 32- and 64-bit signed integers. These modules are not detailed in this tutorial.

There are no dedicated types for unsigned integers in OCaml. Bitwise operations on `int` treat the sign bit the same as other bits. Binary operators use standard symbols. The signed remainder operator is written `mod`. Integers in OCaml have no predefined power operator.

#### Floats and Type Conversions

Float numbers have type `float`.

OCaml does not perform any implicit type conversion between values. Therefore, arithmetic expressions can't mix integers and floats. Arguments are either all `int` or all `float`. Arithmetic operators on floats are not the same, and they are written with a dot suffix: `+.`,  `-.`, `*.`, `/.`.
```ocaml
# let pi = 3.14159;;
val pi : float = 3.14159

# let tau = 2.0 *. pi;;
val tau : float = 6.28318

# let tau = 2 *. pi;;
Error: This expression has type int but an expression was expected of type
         float

# let tau = 2 * pi;;
Error: This expression has type float but an expression was expected of type
         int
```
Operations on `float` are provided by the [`Stdlib`](/manual/api/Stdlib.html) and the [`Float`](/manual/api/Float.html) modules.

#### Booleans

Boolean values are represented by the type `bool`.
```ocaml
# true;;
- : bool = true

# false;;
- : bool = false

# false < true;;
- : bool = true
```

Operations on `bool` are provided by the [`Stdlib`](/manual/api/Stdlib.html) and the [`Bool`](/manual/api/Bool.html) modules. The conjunction “and” is written `&&` and disjunction “or” is written `||`. Both are short-circuited, meaning that they don't evaluate the argument on the right if the left one's value is sufficient to decide the whole expression's value.

In OCaml, `if … then … else …` is a _conditional expression_. It has the same type as its branches.
```ocaml
# 3 * if "foo" = "bar" then 5 else 5 + 2;;
- : int = 21
```

The test subexpression must have type `bool`. Branches subexpressions must have the same type.

Conditional expression and pattern matching on a Boolean are the same:
```ocaml
# 3 * match "foo" = "bar" with true -> 5 | false -> 5 + 2;;
- : int = 21
```

#### Characters

Values of type `char` correspond to the 256 symbols of the Latin-1 set. Character literals are surrounded by single quotes, as shown below:
```ocaml
# 'd';;
- : char = 'd'
```
Operations on `char` values are provided by the [`Stdlib`](/manual/api/Stdlib.html) and the [`Char`](/manual/api/Char.html) modules.

The module [`Uchar`](/manual/api/Uchar.html) provides support for Unicode characters.

### Strings & Byte Sequences

#### Strings

<!--ORIGINAL
Strings are finite and fixed-sized sequences of char values. Strings are immutable, meaning it is impossible to change a character's value inside a string. The string concatenation operator symbol is ^
-->

Strings are immutable, meaning it is impossible to change a character's value inside a string. 
```ocaml
# "hello" ^ " " ^ "world!";;
- : string = "hello world!"
```
Strings are finite and fixed-sized sequences of `char` values. The string concatenation operator symbol is `^`.

<!--CR
I'm not sure how to rearrange this to have the definition after the example? I've split the original paragraph to wrap around the example, but I wonder if it should be all before or after. If after, we could come up with a brief introductory sentence so the section doesn't start with an example without context. 
-->

Indexed access to string characters is possible using the following syntax:
```ocaml
# "buenos dias".[4];;
- : char : 'o'
```
Operations on `string` values are provided by the [`Stdlib`](/manual/api/Stdlib.html) and the [`String`](/manual/api/String.html) modules.

#### Byte Sequences

<!--CR
Moved intro pp to after example, as it contains the definition. Perhaps a short intro sentence here for context?
--> 

```ocaml
# String.to_bytes "hello";;
- : bytes = Bytes.of_string "hello"
```
Like strings, byte sequences are finite and fixed-sized. Each individual byte is represented by a `char` value. Like arrays, byte sequences are mutable, meaning they can't be extended or shortened, but each component byte may be updated. Essentially, a byte sequence (type `bytes`) is a mutable string that can't be printed. There is no way to write `bytes` literally, so they must be produced by a function.

Operations on `bytes` values are provided by the [`Stdlib`](/manual/api/Stdlib.html) and the [`Bytes`](/manual/api/Bytes.html) modules. Only the function `Bytes.get` allows direct access to the characters contained in a byte sequence. Unlike arrays, there is no direct access operator on byte sequences. 

The memory representation of `bytes` is four times more compact that `char array`.
### Arrays & Lists

#### Arrays

Arrays are finite and fixed-sized sequences of values of the same type. Here are a couple of examples:
```ocaml
# [| 0; 1; 2; 3; 4; 5 |];;
- : int array = [|0; 1; 2; 3; 4; 5|]

# [| 'x'; 'y'; 'z' |];;
- : char array = [|'x'; 'y'; 'z'|]

# [| "foo"; "bar"; "baz" |];;
- : string array = [|"foo"; "bar"; "baz"|]
```

Arrays may contain values of any type. Here arrays are `int array`, `char array`, and `string array`, but any type of data can be used in an array. Usually, `array` is said to be a polymorphic type. Strictly speaking, it is a type operator, and it accepts a type as argument (here `int`, `char`, and `string`) to form another type (those inferred here). This is the empty array.
```ocaml
# [||];;
- : 'a array = [||]
```
Remember, `'a` ("alpha") is a type parameter that will be replaced by another type.

Like `string` and `bytes`, arrays support direct access, but the syntax is not the same.
```ocaml
# [| 'x'; 'y'; 'z' |].(2);;
- : char = 'z'
```

Arrays are mutable, meaning they can't be extended or shortened, but each element may be updated.
```ocaml
# let letter = [| 'v'; 'x'; 'y'; 'z' |];;
val letter : char array = [|'v'; 'x'; 'y'; 'z'|]

# letter.(2) <- 'F';;
- : unit = ()

# letter;;
- : char array = [|'v'; 'x'; 'F'; 'z'|]
```

The left-arrow `<-` is the array update operator. Above, it means the cell at index 2 is set to value `'F'`. It is the same as writing `Array.set letter 2 'F'`. Array update is a side effect, and the unit value is returned.

Operations on arrays are provided by the [`Array`](/manual/api/Array.html) module. There is a dedicated tutorial on [Arrays](/docs/arrays).

#### Lists

As literals, lists are very much like arrays. Here are the same previous examples turned into lists.
```ocaml
# [ 0; 1; 2; 3; 4; 5 ];;
- : int list = [0; 1; 2; 3; 4; 5]

# [ 'x'; 'y'; 'z' ];;
- : char list = ['x'; 'y'; 'z']

# [ "foo"; "bar"; "baz" ];;
- : string list = ["foo"; "bar"; "baz"]
```

Like arrays, lists are finite sequences of values of the same type. They are polymorphic, too. However, lists are extensible, immutable, and don't support direct access to all the values they contain. Lists play a central role in functional programming, so they have a [dedicated tutorial](/docs/lists).

Operations on lists are provided by the [`List`](/manual/api/List.html) module. The `List.append` function concatenates two lists. It can be used as an operator with the symbol `@`.

There are symbols of special importance with respect to lists:
- The empty list is written `[]`, has type `'a list'`, and is pronounced “nil.”
- The list constructor operator, written `::` and pronounced “cons,” is used to add a value at the head of a list.

Together, they are the basic means to build a list and access the data it stores. For instance, here is how lists are built by successively applying the cons (`::`) operator:
```ocaml
# 3 :: [];;
- : int list = [3]

# 2 :: 3 :: [];;
- : int list = [2; 3]

# 1 :: 2 :: 3 :: [];;
- : int list = [1; 2; 3]
```

Pattern matching provides the basic means to access data stored inside a list.
```ocaml
# match [1; 2; 3] with
  | x :: u -> x
  | [] -> raise Exit;;
- : int = 1

# match [1; 2; 3] with
  | x :: y :: u -> y
  | x :: u -> x
  | [] -> raise Exit;;
- : int = 2
```

In the above expressions, `[1; 2; 3]` is the value that is matched over. Each expression between the `|` and `->` symbols is a pattern. They are expressions of type `list`, only formed using `[]`, `::`, and binding names that represent various shapes a list may have. The pattern `[]` means “if the list is empty.” The pattern `x :: u` means “if the list contains data, let `x` be the first element of the list and `u` be the rest of the list.” Expressions at the right of the `->` symbol are the results returned in each corresponding case.

### Options & Results

#### Options

The `option` type is also a polymorphic type. Option values can store any kind of data or represent the absence of any such data. Option values can only be constructed in two different ways: either `None`, when no data is available, or `Some`, otherwise.
```ocaml
# None;;
- : 'a option = None

# Some 42;;
- : int option = Some 42

# Some "hello";;
- : string option = Some "hello"
```

Here is an example of pattern matching on an option value:
```ocaml
# match Some 42 with None -> raise Exit | Some x -> x;;
- : int = 42
```

Operations on options are provided by the [`Option`](/manual/api/Option.html) module. Options are discussed in the [Error Handling](/docs/error-handling) guide.

#### Results

The `result` type can be used to express that a function's outcome can be either success or failure. There are only two ways to build a result value: either using `Ok` or `Error` with the intended meaning. Both constructors can hold any kind of data. The `result` type is polymorphic, but it has two type parameters: one for `Ok` values and another for `Error` values.
```ocaml
# Ok 42;;
- : (int, 'a) result = Ok 42

# Error "Sorry";;
- : ('a, string) result = Error "Sorry"
```

Operations on results are provided by the [`Result`](/manual/api/Result.html) module. Results are discussed in the [Error Handling](/docs/error-handling) guide.

### Tuples

Here is a tuple containing two values, also known as a pair.
```ocaml
# (3, 'K');;
- : int * char = (3, 'K')
```

That pair contains the integer `3` and the character `'K'`; its type is `int * char`. The `*` symbol stands for _product type_.

This generalises to tuples with 3 or more elements. For instance, `(6.28, true, "hello")` has type `float * bool * string`. The types `int * char` and `float * bool * string` are called _product types_. The `*` symbol is used to denote types bundled together in products.

The predefined function `fst` returns the first element of a pair, while `snd` returns the second element of a pair.
```ocaml
# fst (3, 'g');;
- : int = 3

# snd (3, 'g');;
- : char = 'g'
```

In the standard library, both are defined using pattern matching. Here is how a function extracts the third element of the product of four types:
```ocaml
# let f x = match x with (h, i, j, k) -> j;;
val f : 'a * 'b * 'c * 'd -> 'c = <fun>
```

Note that types `int * char * bool`, `int * (char * bool)`, and `(int * char) * bool` are not the same. The values `(42, 'h', true)`, `(42, ('h', true))`, and `((42, 'h'), true)` are not equal. In mathematical language, the product type operator `*` is not _associative_.

<!--FIXME :: Please ensure this is still correct. In trying to keep examples away from a, b, c (so as not to be confused with `a, `b, `c), I thought it was particularly important here because the user might need to see that any letter/value/char will result in `a, `b, `c, `d in this case. In other words, h, i, j, k won't turn into `h, `i, `j, `k. -->

### Functions

The type of functions from type `m` to type `n` is written `m -> n`. Here are a few examples:
```ocaml
# fun x -> x * x;;
- : int -> int = <fun>

# (fun x -> x * x) 9;;
- : int = 81
```

The first expression is an anonymous function of type `int -> int`. The type is inferred from the expression `x * x`, which must be of type `int` since `*` is an operator that returns an `int`. The `<fun>` printed in place of the value is a token, meaning functions don't have a value to be displayed. This is because, if they have been compiled, their code is no longer available.

The second expression is function application. The argument `9` is applied, and the result `81` is returned.

```ocaml
# fun x -> x;;
- : 'a -> 'a = <fun>

# (fun x -> x) 42;;
- : int = 42

# (fun x -> x) "This is really disco!";;
- : string = "This is really disco!"
```

The first expression is another anonymous function. It is the _identity_ function, it can be applied to anything, and it returns its argument unchanged. This means that its argument can be of any type, and its result has the same type. The same code can be applied to data of different types. This is called _polymorphism_.

Remember, the `'a` is a _type parameter_, so values of any type can be passed to the function and their type replaces the type parameter. The identity function has the same input and output type, whatever it may be.

The two following expressions show that the identity function can apply to arguments of different types:

```ocaml
# let f = fun x -> x * x;;
val f : int -> int = <fun>

# f 9;;
- : int = 81
```

Defining a function is the same as naming a value, as illustrated in the first expression:

```ocaml
# let g x = x * x;;
val g : int -> int = <fun>

# g 9;;
- : int = 81
```

Executable OCaml code consists primarily of functions, so it's beneficial to make them as concise and clear as possible. The function `g` is defined here using a shorter, more common, and maybe more intuitive syntax.

In OCaml, functions may terminate without returning the expected type value by throwing an exception (of type `exn`), which does not appear in its type. There is no way to know if a function may raise an exception without inspecting its code.
```ocaml
# raise;;
- : exn -> 'a' = <fun>
```

Exceptions are discussed in the [Error Handling](/docs/error-handling) guide.

Functions may have several parameters.
```ocaml
# fun s r -> s ^ " " ^ r;;
- : string -> string -> string = <fun>

# let mean s r = (s + r) / 2;;
val mean : int -> int -> int = <fun>
```

Like the product type symbol `*`, the function type symbol `->` is not associative. The following two types are not the same:
- `(int -> int) -> int` : This function takes a function of type `int -> int` as a parameter and returns an `int` as the result.
- `int -> (int -> int)` : This function takes an `int` as a parameter and returns a function of type `int -> int` as the result.

### Unit

Uniquely, the type `unit` has only one value. It is written `()` and pronounced “unit.”

The `unit` type has several uses. Mainly, it serves as a token when a function does not need to be passed data or doesn't have any data to return once it has completed its computation. This happens when functions have side effects such as OS-level I/O. Functions need to be applied to something for their computation to be triggered, and they also must return something. When nothing meaningful can be passed or returned, `()` should be used.
```ocaml
# read_line;;
- : unit -> string = <fun>

# print_endline;;
- : string -> unit = <fun>
```

The function `read_line` reads an end-of-line terminated sequence of characters from standard input and returns it as a string. Reading input begins when `()` is passed.
```ocaml
 # read_line ();;
foo bar
- : string = "foo bar"

# print_endline;;
- : string -> unit = <fun>
```

**Note**: Replace `foo bar` with your own text and press `Return`.

The function `print_endline` prints the string followed by a line ending on standard output. Return of the unit value means the output request has been queued by the operating system.

## User-Defined Types

User-defined types are always introduced using the `type … = …` statement. The keyword `type` must written in lowercase. The first ellipsis stands for type name and must not begin with a capital. The second ellipsis stands for the type definition. Three cases are possible:
1. Variant
1. Record
1. Aliases

These three kinds of type definitions are covered in the next three sections.

### Variants

Variants are also called [_tagged unions_](https://en.wikipedia.org/wiki/Tagged_union). They relate to the concept of [_disjoint union_](https://en.wikipedia.org/wiki/Disjoint_union).

#### Enumerated Data Types

The simplest form of a variant type corresponds to an [enumerated type](https://en.wikipedia.org/wiki/Enumerated_type). It is defined by an explicit list of named values. Defined values are called constructors and must be capitalised.

For example, here is how variant data types could be defined to represent Dungeons & Dragons character classes and alignment.
```ocaml
# type character_class =
    | Barbarian
    | Bard
    | Cleric
    | Druid
    | Fighter
    | Monk
    | Paladin
    | Ranger
    | Rogue
    | Sorcerer
    | Wizard;;
type character_class =
    Barbarian
  | Bard
  | Cleric
  | Druid
  | Fighter
  | Monk
  | Paladin
  | Ranger
  | Rogue
  | Sorcerer
  | Wizard

# type rectitude = Evil | R_Neutral | Good;;
type rectitude = Evil | R_Neutral | Good

# type firmness = Chaotic | F_Neutral | Lawful;;
type firmness = Chaotic | F_Neutral | Lawful
```

These kinds of variant types can also be used to represent weekdays, cardinal
directions, or any other fixed-sized set of values that can be given names. An
ordering is defined on values following the definition order (e.g., `Druid
< Ranger`).

Pattern matching can be performed on the types defined above:
```ocaml
# let rectitude_to_french = function
    | Evil -> "Mauvais"
    | R_Neutral -> "Neutre"
    | Good -> "Bon";;
val rectitude_to_french : rectitude -> string = <fun>
```

Note that:

- `unit` is a variant with a unique constructor, which does not carry data: `()`.
- `bool` is also a variant with two constructors that doesn't carry data: `true` and `false`.

#### Constructors With Data

It is possible to wrap data in constructors. The following type has several constructors with data (e.g., `Hash of string`) and some without (e.g., `Head`). It represents the different means to refer to a Git [revision](https://git-scm.com/docs/gitrevisions).
```ocaml
# type commit =
  | Hash of string
  | Tag of string
  | Branch of string
  | Head
  | Fetch_head
  | Orig_head
  | Merge_head;;
type commit =
    Hash of string
  | Tag of string
  | Branch of string
  | Head
  | Fetch_head
  | Orig_head
  | Merge_head

```

Here is how to convert a `commit` to a `string` using pattern matching:
```ocaml
# let commit_to_string = function
  | Hash sha -> sha
  | Tag name -> name
  | Branch name -> name
  | Head -> "HEAD"
  | Fetch_head -> "FETCH_HEAD"
  | Orig_head -> "ORIG_HEAD"
  | Merge_head -> "MERGE_HEAD";;
val commit_to_string : commit -> string = <fun>
```

Above, the `function …` construct is used instead of the `match … with …` construct used previously:
```ocaml
let commit_to_string' x = match x with
  | Hash sha -> sha
  | Tag name -> name
  | Branch name -> name
  | Head -> "HEAD"
  | Fetch_head -> "FETCH_HEAD"
  | Orig_head -> "ORIG_HEAD"
  | Merge_head -> "MERGE_HEAD";;
val commit_to_string' : commit -> string = <fun>
```
We need to pass an inspected expression to the `match … with …` construct. The `function …` is a special form of an anonymous function that takes a parameter and forwards it to a `match … with …` construct, as shown above.

**Warning**: Wrapping product types with parentheses turns them into a single parameter.
```ocaml
# type t =
  | C1 of int * bool
  | C2 of (int * bool);;
type t = C1 of int * bool | C2 of (int * bool)

# let p = (4, false);;
val p : int * bool = (4, false)

# C1 p;;
Error: The constructor C1 expects 2 argument(s),
       but is applied here to 1 argument(s)

# C2 p;;
- : t = C2 (4, false)
```

The constructor `C1` has two parameters of type `int` and `bool`, whilst the constructor `C2` has a single parameter of type `int * bool`.

#### Recursive Variants

A variant definition referring to itself is recursive. A constructor may wrap data from the type being defined.

This is the case for the following definition, which can be used to store JSON values.
```ocaml
# type json =
  | Null
  | Bool of bool
  | Int of int
  | Float of float
  | String of string
  | Array of json list
  | Object of (string * json) list;;
type json =
    Null
  | Bool of bool
  | Int of int
  | Float of float
  | String of string
  | Array of json list
  | Object of (string * json) list
```

Both constructors `Array` and `Object` contain values of type `json`.

Functions defined using pattern matching on recursive variants are often recursive too. This function checks if a name is present in a whole JSON tree:
```ocaml
# let rec has_field name = function
  | Array u ->
      List.fold_left (fun b obj -> b || has_field name obj) false u
  | Object u ->
      List.fold_left
        (fun b (key, obj) -> b || key = name || has_field name obj) false u
  | _ -> false;;
val has_field : string -> json -> bool = <fun>
```

Here, the last pattern uses the symbol `_`, which catches everything. It returns `false` on all data that is neither `Array` nor `Object`.

### Polymorphic Data Types

#### Revisiting Predefined Types

The predefined type `option` is a variant type with two constructors: `Some` and `None`. It can contain values of any type, such as `Some 42` or `Some "hola"`. In that sense, `option` is polymorphic. Here is how it is defined in the standard library:

```ocaml
# #show option;;
type 'a option = None | Some of 'a
```

The predefined type `list` is polymorphic in the same sense. It is a variant with two constructors and can hold data of any type. Here is how it is defined in the standard library:
```ocaml
# #show list;;
type 'a list = [] | (::) of 'a * 'a list
```

The only magic here is turning constructors into symbols, which we don't cover in this tutorial. The types `bool` and `unit` also are regular variants, with the same magic:
```ocaml
# #show unit;;
type unit = ()

# #show bool;;
type bool = false | true
```

Implicitly, product types also behave as variant types. For instance, pairs can be seen as inhabitants of this type:
```ocaml
# type ('a, 'b) pair = Pair of 'a * 'b;;
type ('a, 'b) pair = Pair of 'a * 'b
```

`(int, bool) pair` would be written `int * bool`, and `Pair (42, true)` would be written `(42, true)`. From the developer's perspective, everything happens as if such a type were declared for every possible product shape. This is what allows pattern matching on products.

Even integers and floats can be seen as enumerated-like variant types, with many constructors and [funky syntactic sugar](https://youtu.be/O0_H3F84Yjk), which allows pattern matching on those types.

In the end, the only type construction that does not reduce to a variant is the function arrow type. Pattern matching allows the inspection of values of any type, except functions.

#### User-Defined Polymorphic

Here is an example of a variant type that combines constructors with data, constructors without data, polymorphism, and recursion:
```ocaml
# type 'a tree =
  | Leaf
  | Node of 'a * 'a tree * 'a tree;;
type 'a tree = Leaf | Node of 'a * 'a tree * 'a tree
```

It can be used to represent arbitrarily labelled binary trees. Assuming such a tree would be labelled with integers, here is a possible way to compute the sum of its integers, using recursion and pattern matching.
```ocaml
# let rec sum = function
  | Leaf -> 0
  | Node (x, lft, rht) -> x + sum lft + sum rht;;
val sum : int tree -> int = <fun>
```

Here is how the map function can be defined in this type:
```ocaml
# let rec map f = function
  | Leaf -> Leaf
  | Node (x, lft, rht) -> Node (f x, map f lft, map f rht);;
val map : ('a -> 'b) -> 'a tree -> 'b tree = <fun>
```

In the OCaml community, as well as in the larger functional programming community, the word *polymorphism* is used loosely. It is applied to things working in a similar fashion with various types. In this broad sense, several features of OCaml are polymorphic. Each uses a particular form of polymorphism and has a name. In summary, OCaml has several forms of polymorphism. In most cases, the distinction between those concepts is blurred, but it is sometimes necessary to distinguish them.

Here are the terms applicable to data types:
1. `'a list`, `'a option`, and `'a tree` are very often said to be polymorphic types. Formally, `bool list` or `int option` are the types, whilst `list` and `option` are [type operators](https://en.wikipedia.org/wiki/Type_constructor) that take a type parameter and result in a type. This is a form of [parametric polymorphism](https://en.wikipedia.org/wiki/Parametric_polymorphism). `'a list` and `'a option` denote [type families](https://en.wikipedia.org/wiki/Type_family), which are all the types created by applying type parameters to the operators.

<!-- 

FIXME

issue - "The polymorphic variants tutorial is unreleased, so the best at this point would probably be to comment out the paragraph with a FIXME comment and add it back when the new tutorial gets released (probably in January)."

2. OCaml has something called _Polymorphic Variants_. Although the types `option`, `list`, and `tree` are variants and polymorphic, they aren't polymorphic variants. They are type-parametrised variants. We stick to this usage and say the variants in this section are polymorphic. OCaml polymorphic variants are covered in [another tutorial](docs/labels#more-variants-polymorphic-variants).
-->

### Records

Records are like tuples in that several values are bundled together. In a tuple, elements are identified by their position in the corresponding product type. They are either first, second, third, or at some other position. In a record, each element has a name and a value. This name-value pair is known as a field. That's why record types must be declared before being used.

For instance, here is the definition of a record type meant to partially represent a Dungeons & Dragons character class. Please note that the following code is dependent upon the definitions earlier in this tutorial. Ensure you have entered the definitions in the [Enumerated Data Types](/docs/basic-data-types#enumerated-data-types) section.
```ocaml
# type character = {
  name : string;
  level : int;
  race : string;
  class_type : character_class;
  alignment : firmness * rectitude;
  armor_class : int;
};;
type character = {
  name : string;
  level : int;
  race : string;
  class_type : character_class;
  alignment : firmness * rectitude;
  armor_class : int;
}
```
Values of type `character` carry the same data as inhabitants of this product: `string * int * string * character_class * character_alignment * int`.

Access the fields by using the dot notation, as shown:
```ocaml
# let ghorghor_bey = {
    name = "Ghôrghôr Bey";
    level = 17;
    race = "half-ogre";
    class_type = Fighter;
    alignment = (Chaotic, R_Neutral);
    armor_class = -8;
  };;
val ghorghor_bey : character =
  {name = "Ghôrghôr Bey"; level = 17; race = "half-ogre";
   class_type = Fighter; alignment = (Chaotic, R_Neutral); armor_class = -8}

# ghorghor_bey.alignment;;
- : firmness * rectitude = (Chaotic, R_Neutral)

# ghorghor_bey.class_type;;
- : character_class = Fighter

# ghorghor_bey.level;;
- : int = 17
```

To construct a new record with some field values changed without typing in the unchanged fields we can use record update syntax as shown:
```ocaml
# let togrev  = { ghorghor_bey with name = "Togrev"; level = 20; armor_class = -6 };;
val togrev : character =
  {name = "Togrev"; level = 20; race = "half-ogre"; class_type = Fighter;
   alignment = (Chaotic, R_Neutral); armor_class = -6}
```

Note that records behave like single constructor variants. That allows pattern matching on them.
```ocaml
# match ghorghor_bey with { level; _ } -> level;;
- : int = 17
```

### Aliases

#### Type Aliases

Just like values, any type can be given a name.
```ocaml
# type latitude_longitude = float * float;;
type latitude_longitude = float * float
```

This is mostly useful as a means of documentation or to shorten long type expressions.

#### Function Parameter Aliases

Function parameters can also be given a name with pattern matching for tuples and records.
```ocaml
(* Tuples as parameters *)
# let tuple_sum (x, y) = x + y;;
val tuple_sum : int * int -> int = <fun>

# let f ((x, y) as arg) = tuple_sum arg;;
val f : int * int -> int = <fun>


(* Records as parameters *)
# type dummy_record = {a: int; b: int};;
type dummy_record = { a : int; b : int; }

# let record_sum ({a; b}: dummy_record) = a + b;;
val record_sum : dummy_record -> int = <fun>

# let f ({a;b} as arg) = record_sum arg;;
val f : dummy_record -> int = <fun>
```

This is useful for matching variant values of parameters.

```ocaml
# let meaning_of_life = function Some _ as opt -> opt | None -> Some 42;;
val meaning_of_life : int option -> int option = <fun>
```

## A Complete Example: Mathematical Expressions

This example shows how to represent simple mathematical expressions like `n * (x + y)` and multiply them out symbolically to get `n * x + n * y`:
```ocaml env=expr
# type expr =
  | Plus of expr * expr        (* a + b *)
  | Minus of expr * expr       (* a - b *)
  | Times of expr * expr       (* a * b *)
  | Divide of expr * expr      (* a / b *)
  | Var of string              (* "x", "y", etc. *);;
type expr =
    Plus of expr * expr
  | Minus of expr * expr
  | Times of expr * expr
  | Divide of expr * expr
  | Var of string
```

The expression `n * (x + y)` would be written:
```ocaml env=expr
# let e = Times (Var "n", Plus (Var "x", Var "y"));;
val e : expr = Times (Var "n", Plus (Var "x", Var "y"))
```

Here is a function that prints out `Times (Var "n", Plus (Var "x", Var "y"))`
as something more like `n * (x + y)`:
```ocaml env=expr
# let rec to_string = function
  | Plus (e1, e2) -> "(" ^ to_string e1 ^ " + " ^ to_string e2 ^ ")"
  | Minus (e1, e2) -> "(" ^ to_string e1 ^ " - " ^ to_string e2 ^ ")"
  | Times (e1, e2) -> "(" ^ to_string e1 ^ " * " ^ to_string e2 ^ ")"
  | Divide (e1, e2) -> "(" ^ to_string e1 ^ " / " ^ to_string e2 ^ ")"
  | Var v -> v;;
val to_string : expr -> string = <fun>
```

We can write a function to multiply out expressions of the form `n * (x + y)`
or `(x + y) * n`, and for this we will use a nested pattern:
```ocaml env=expr
# let rec distrib = function
  | Times (e1, Plus (e2, e3)) ->
     Plus (Times (distrib e1, distrib e2),
           Times (distrib e1, distrib e3))
  | Times (Plus (e1, e2), e3) ->
     Plus (Times (distrib e1, distrib e3),
           Times (distrib e2, distrib e3))
  | Plus (e1, e2) -> Plus (distrib e1, distrib e2)
  | Minus (e1, e2) -> Minus (distrib e1, distrib e2)
  | Times (e1, e2) -> Times (distrib e1, distrib e2)
  | Divide (e1, e2) -> Divide (distrib e1, distrib e2)
  | Var v -> Var v;;
val distrib : expr -> expr = <fun>
```

This is how it can be used:
```ocaml env=expr
# e |> distrib |> to_string |> print_endline;;
((n * x) + (n * y))
- : unit = ()
```

The first two patterns hold the key to how the `distrib` function works.
The first pattern is `Times (e1, Plus (e2, e3))`, which matches expressions of
the form `e1 * (e2 + e3)`. The right-hand side of this first pattern is
equivalent to `(e1 * e2) + (e1 * e3)`. The second pattern does the same thing,
except for expressions of the form `(e1 + e2) * e3`.

The remaining patterns don't change the expressions' form, but they call the
`distrib` function recursively on their subexpressions. This ensures that all its
subexpressions get multiplied out too. (If you only wanted
to multiply out the very top level of an expression, you could replace all
the remaining patterns with a simple `e -> e` rule.)

The reverse operation, i.e., factorising out common subexpressions, can be
implemented in a similar fashion. The following version only works for the top-level expression.
```ocaml env=expr
# let top_factorise = function
  | Plus (Times (e1, e2), Times (e3, e4)) when e1 = e3 ->
     Times (e1, Plus (e2, e4))
  | Plus (Times (e1, e2), Times (e3, e4)) when e2 = e4 ->
     Times (Plus (e1, e3), e4)
  | e -> e;;
val top_factorise : expr -> expr = <fun>
# top_factorise (Plus (Times (Var "n", Var "x"),
                   Times (Var "n", Var "y")));;
- : expr = Times (Var "n", Plus (Var "x", Var "y"))
```

The factorise function above introduces another feature: *guards* to each
pattern. The conditional follows the `when`, and it means that
the return code is executed only if the pattern matches and the condition in the
`when` clause is satisfied.

## Conclusion

This tutorial has provided a comprehensive overview of OCaml's basic data types and their usage. We have explored the built-in types, such as integers, floats, characters, lists, tuples, and strings, and the user-defined types: records and variants. Records and tuples are mechanisms for grouping heterogeneous data into cohesive units. Variants are a mechanism for exposing heterogeneous data as coherent alternatives.
<!--
From the data point of view, records and tuples are similar to the logical conjunction “and,” while variants are similar to the logical disjunction “or.” This analogy goes very deep, with records and tuples on one side as products and variants on the other side as union. These are true mathematical operations on data types. Records and tuples play the role of multiplication, which is why they are called product types. Variants play the role of addition. Putting it all together, basic OCaml types are said to be algebraic.

In this tutorial _variants_ and _products_ were presented, this correspond to [algebraic data types](https://en.wikipedia.org/wiki/Algebraic_data_type). At this level, a [nominal](https://en.wikipedia.org/wiki/Nominal_type_system) type-checking algorithm is used. Historically, this is OCaml's first type system, as it comes from the [ML](https://en.wikipedia.org/wiki/ML_(programming_language)) programming language, OCaml's ancestor. Although OCaml has other type systems, this document focused on data typed using this algorithm.

## Next: Advanced Data Types
-->
In this tutorial _variants_ and _products_ were presented, this correspond to [algebraic data types](https://en.wikipedia.org/wiki/Algebraic_data_type). At this level, a [nominal](https://en.wikipedia.org/wiki/Nominal_type_system) type-checking algorithm is used. Historically, this is OCaml's first type system, as it comes from the [ML](https://en.wikipedia.org/wiki/ML_(programming_language)) programming language, OCaml's ancestor. Although OCaml has other type systems, this document focused on data typed using this algorithm.
<!--
## Next: Advanced Data Types

Going further, you can explore several advanced topics related to OCaml's data types to deepen your understanding and enhance your programming skills.
- Mutually Recursive Variants
- Polymorphic Variants
- Extensible Variants
- [Generalised Algebraic Data Types](https://en.wikipedia.org/wiki/Generalized_algebraic_data_type)

As of writing this, these topics will be covered in forthcoming tutorials. Documentation on them is available in the OCaml [Language Manual](/manual/index.html) and in the [books](https://ocaml.org/books) on OCaml.

OCaml aggregates several type systems, also known as disciplines:
- A [nominal type system](https://en.wikipedia.org/wiki/Nominal_type_system) is used for predefined types, variants, and functions. , and it is also the scope of this tutorial.
- Two different [structural type systems](https://en.wikipedia.org/wiki/Structural_type_system) are also used:
  * One for polymorphic variants
  * Another for objects and classes
-->
