---
id: basic-datatypes
title: Basic Datatypes And Pattern-Matching
description: |
  Predefined types, Variants, Records and Pattern-Matching
category: "Language"
---

# Basic Datatypes And Pattern-Matching

## Introduction

OCaml is a statically and strongly typed programming language. It is also an expression-oriented language: everything is a value and every value has a type. Functions and types are the two foundational principles of OCaml. The OCaml type system is highly expressive, providing many advanced constructs while being easy to use and unobtrusive. Thanks to type inference, programs can be written without type annotations, except for documentation purposes and a few corner cases. The basic types and the type combination operations enable a vast range of possibilities.

> Type annotation means when its necessary to write the value type to tell the compiler what to do, as opposed to tiper inference, when the compiler *infers* the type.

This tutorial begins with a section presenting the types that are predefined in OCaml. It starts with atomic types such as integers and Booleans. It continues by presenting predefined compound types such as strings and lists. The tutorial ends with a section about user-defined types: variants and records.

The OCaml type system aggregates several type systems, also known as disciplines:
- A [nominal type system](https://en.wikipedia.org/wiki/Nominal_type_system) is used for predefined types, variants, and functions. Historically, it the first system, directly coming from the type system used the [ML](https://en.wikipedia.org/wiki/ML_(programming_language)) programming language, which is OCaml accestor. By default, this what is meant by OCaml type system, and it is also the scope of this tutorial.
- Two different [structural type systems](https://en.wikipedia.org/wiki/Structural_type_system) are also used:
  * One for polymorphic variants
  * Another for objects and classes

OCaml also provides Generalized Algebraic Data Types, which are an extensions of those presented in this tutorial. Types that are in the scope of this tutorial are the most basic  ones.

## Prerequisites and Goals

This is an intermediate-level tutorial. The only prerequisite is to have completed the [Get Started](https://ocaml.org/docs/up-and-running) series of tutorials.

<!--
The goal of this tutorial is to provide for the following capabilities:
- Handle data of all predefined types using dedicated syntax
- Write variant type definitions: simple, recursive, and polymorphic
- Write record type definitions (without mutable fields)
- Write type aliases
- Use pattern matching to define functions for all basic type
-->

The goal of this tutorial will provide capabilities to handle data from predefined, variant and record types. This importantly includes pattern matching on those types.

## Predefined Types

### Integers, Characters, Booleans, and Characters

#### Integers

Here is an integer:
```ocaml
# 42;;
- : int = 42
```

The `int` type is the default and basic type of integer numbers in OCaml. It represents platform-dependent signed integers. This means `int` does not always have same the number of bits, depending on underlying platform characteristics, such as processor architecture or operating system. Operations on `int` values are provided by the [`Stdlib`](/api/Stdlib.html) and the [`Int`](/api/Int.html) modules.

Usually, `int` has 31 bits in 32-bit architectures and 63 in 64-bit architectures; one bit is reserved for OCaml's runtime operation. The standard library also provides [`Int32`](/api/Int32.html) and [`Int64`](/api/Int64.html) modules, which support platform independent operations on 32 and 64 bits signed integers. These modules are not detailed in this tutorial.

There are no dedicated types for unsigned integers in OCaml. Bitwise operations on `int` treat the sign bit as the other bits. Binary operators use standard symbols. The signed remainder operator is written `mod`. There is no predefined power operator on integers in OCaml.

#### Floats and Type Conversions

Fixed-sized float numbers have type `float`. Operations on `float` comply with the IEEE 754 standard, with 53 bits of mantissa and exponent ranging from -1022 to 1023.

OCaml does not perform any implicit type conversion between values. Therefore, arithmetic expressions can't mix integers and floats. Parameters are either all `int` or all `float`. Arithmetic operators on floats are not the same; they are written with a dot suffix: `+.`,  `-.`, `*.`, `/.`.
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
Operations on `float` are provided by the [`Stdlib`](/api/Stdlib.html) and the [`Float`](/api/Float.html) modules.

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

Operations on `bool` are provided by the [`Stdlib`](/api/Stdlib.html) and the [`Bool`](/api/Bool.html) modules. The conjunction “and” is written `&&` and disjunction “or” is written `\\`. Both are short-circuited, meaning that they don't evaluate their right argument if the value of the left one is sufficient to decide the value of the whole expression.

#### Characters

Values of type `char` correspond to the 256 symbols defined in the ISO/IEC 8859-1 standard. Character literals are surrounded by single quotes. Here is an example.
```ocaml
# 'a';;
- : char = 'a'
```
Operations on `char` values are provided by the [`Stdlib`](/api/Stdlib.html) and the [`Char`](/api/Char.html) modules.

The module [`Uchar`](/api/Uchar.html) provides support for Unicode characters.

### Strings & Byte Sequences

#### Strings

Strings are finite and fixed-sized sequences of values of type `char`. Strings are immutable, meaning it is impossible to change a character's value inside a string. The string concatenation operator symbol is `^`.
```ocaml
# "hello" ^ " " ^ "world!";;
- : string = "hello world!"
```

Indexed access to string characters is possible using the following syntax:
```ocaml
# "buenos dias".[4];;
- : char : 'o'
```
Operations on `string` values are provided by the [`Stdlib`](/api/Stdlib.html) and the [`String`](/api/String.html) modules.

#### Byte Sequences

Byte sequences are finite and fixed-sized sequences of bytes. Each individual byte is represented by a `char` value. Byte sequences are mutable, meaning they can't be extended or shortened, but each component byte may be updated. Essentially, a byte sequence `bytes` is a mutable string that can't be printed. There is no way to write `bytes` literally, so they must be produced by a function.
```ocaml
# String.to_bytes "hello";;
- : bytes = Bytes.of_string "hello"
```
Operations on `bytes` values are provided by the [`Stdlib`](/api/Stdlib.html) and the [`Bytes`](/api/Bytes.html) modules. Only the function `Bytes.get` allows direct access to the characters contained in a byte sequence. There is no direct access operator on byte sequences.

### Arrays & Lists

#### Arrays

Arrays are finite and fixed-sized sequences of values of the same type. Here are a couple of examples:
```ocaml
# [| 0; 1; 2; 3; 4; 5 |];;
- : int array = [|0; 1; 2; 3; 4; 5|]

# [| 'a'; 'b'; 'c' |];;
- : char array = [|'a'; 'b'; 'c'|]

# [| "foo"; "bar"; "baz" |];;
- : string array = [|"foo"; "bar"; "baz"|]
```

Arrays may contain values of any type. Here arrays are `int array`, `char array`, and `string array`, but any type of data can be used in an array. Usually, `array` is said to be a polymorphic type. Strictly speaking, it is a type operator, and it accepts a type as a parameter (here `int`, `char`, and `string`) to form another type (those inferred here). This is the empty array.
```ocaml
# [||];;
- : 'a array = [||]
```
Here `'a` means “any type.” It is called a type variable and is usually pronounced as if it were the Greek letter α (“alpha”). This type parameter is meant to be replaced by another type.

Like `string` and `bytes`, arrays support direct access, but the syntax is not the same.
```ocaml
# [| 'a'; 'b'; 'c' |].(2);;
- : char = 'c'
```

Arrays are mutable, meaning they can't be extended or shortened, but each element may be updated.
```ocaml
# let a = [| 'a'; 'b'; 'c'; 'd' |];;
val a : char array = [|'a'; 'b'; 'c'; 'd'|]

# a.(2) <- '3';;
- : unit = ()

# a;;
- : char array = [|'a'; 'b'; '3'; 'd'|]
```

Operations on arrays are provided by the [`Array`](/api/Array.html) module. There is a dedicated tutorial on Arrays.

#### Lists

As literals, lists are very much like arrays. Here are the same previous examples turned into lists.
```ocaml
# [ 0; 1; 2; 3; 4; 5 ];;
- : int list = [0; 1; 2; 3; 4; 5]

# [ 'a'; 'b'; 'c' ];;
- : char list = ['a'; 'b'; 'c']

# [ "foo"; "bar"; "baz" ];;
- : string list = ["foo"; "bar"; "baz"]
```

Like arrays, lists are finite sequences of values of the same type. They are polymorphic too. However, lists are extensible, immutable, and don't support direct access to all the values they contain. Lists play a central role in functional programming, and they are the subject of a [dedicated tutorial](/docs/lists).

Operations on lists are provided by the [`List`](/api/List.html) module. The `List.append` function, which concatenates two lists, can also be used as an operator with the symbol `@`.

There are symbols of special importance with respect to lists:
- The empty list is written `[]`, has type `'a list'`, and is pronounced “nil.”
- The list constructor operator, written `::` and pronounced “cons,” is used to add a value at the head of a list.

Together, they are the basic means to build a list and access the data it stores. For instance, here is how lists are built by successively applying the cons (`::`) operator.
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

In the above expressions, `[1; 2; 3]` is the value which is matched over. Each expression between the `|` and `->` symbols is a pattern. They are expressions of type list, only formed using `[]`, `::`, and variables names that represent various shapes a list may have. When the pattern is `[]`, it means “if the list is empty.” When the pattern is `x :: u`, it means “if the list contains data, let `x` be the first element of the list and `u` be the rest of the list.” Expression at the right of the `->` symbols are the results returned in each corresponding case.

Operations on lists are provided by the [`List`](/api/List.html) module. There is a [dedicated tutorial on lists](https://ocaml.org/docs/lists).

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

Here is an example of pattern matching on an option value.
```ocaml
# match Some 42 with None -> raise Exit | Some x -> x;;
- : int = 42
```

Operations on options are provided by the [`Option`](/api/Option.html) module. Options are discussed in the [Error Handling](/docs/error-handling) guide.

#### Results

The `result` type can be used to express that the outcome of a function can be either success or failure. There are only two ways to build a result value: either using `Ok` or `Error` with the intended meaning. Both constructors can hold any kind of data. The `result` type is polymorphic, but it has two type parameters: one for `Ok` values and another for `Error` values.
```ocaml
# Ok 42;;
- : (int, 'a) result = Ok 42

# Error "Sorry";;
- : ('a, string) result = Error "Sorry"
```

Operations on results are provided by the [`Result`](/api/Result.html) module. Results are discussed in the [Error Handling](/docs/error-handling) guide.

### Tuples

Here is a tuple containing two values, also known as a pair.
```ocaml
# (3, 'a');;
- : int * char = (3, 'a')
```

This is a pair containing the integer `3` and the character `'a'`; its type is `int * char`. The `*` symbol stands for _product type_.

This generalises to tuples with 3 or more elements. For instance, `(6.28, true, "hello")` has type `float * bool * string`. The types `int * char` and `float * bool * string` are called _product types_. The `*` symbol is used to denote types bundled together in products.

The predefined function `fst` returns the first element of a pair, while `snd` returns the second element of a pair.
```ocaml
# fst (3, 'a');;
- : int = 3

# snd (3, 'a');;
- : char = 'a'
```

In the standard library, both are defined using pattern matching. Here is how a function extracts the third element of the product of four types:
```ocaml
# let f x = match x with (a, b, c, d) -> c;;
val f : 'a * 'b * 'c * 'd -> 'c = <fun>
```

Note that types `int * char * bool`, `int * (char * bool)`, and `(int * char) * bool` are not the same. The values `(42, 'a', true)`, `(42, ('a', true))`, and `((42, 'a'), true)` are not equal. In mathematical language, it is said that the product type operator `*` is not associative.

### Functions

The type of functions from type `a` to type `b` is written `a -> b`. Here are a few examples:
```ocaml
# fun x -> x * x;;
- : int -> int = <fun>

# (fun x -> x * x) 9;;
- : int = 81
```

The first expression is an anonymous function of type `int -> int`. The type is inferred from the expression `x * x`, which must be of type `int` since `*` is an operator that returns an `int`. The `<fun>` printed in place of the value is a token, meaning functions don't have a value to be displayed. This is because if they have been compiled their code is no longer available.

The second expression is function application. The parameter `9` is applied, and the result `81` is returned.

```ocaml
# fun x -> x;;
- : 'a -> 'a = <fun>

# (fun x -> x) 42;;
- : int = 42

# (fun x -> x) "This is really disco!";;
- : string = "This is really disco!"
```

The first expression is another anonymous function. It is the identity function, it can be applied to anything, and it returns its argument unchanged. This means that its parameter can be of any type, and its result has the same type. The same code can be applied to data of different types. This is called _polymorphism_.

This is what is indicated by the `'a` in the in the inferred type, known as a _type variable_. It means values of any type can be passed to the function. When that happens, their type is substituted for the type variable. This also expresses that this identity has the same input and output type, whatever it may be.

The two following expressions show that the identity function can indeed be applied to parameters of different types:

```ocaml
# let f = fun x -> x * x;;
f : int -> int = <fun>

# f 9;;
- : int = 81
```

Defining a function is the same as giving a name to any value. This is illustrated in the first expression:

```ocaml
# let g x = x * x;;
g : int -> int = <fun>

# g 9;;
- : int = 81
```

Executable OCaml code consists primarily of functions, so it's beneficial to make them as concise and clear as possible. The function `g` is defined here using a shorter, more common, and maybe more intuitive syntax.

In OCaml, functions may terminate without returning a value of the expected type by throwing an exception, which does not appear in its type. There is no way to know if a function may raise an exception without inspecting its code.
```ocaml
# raise;;
- : exn -> 'a' = <fun>
```

Exceptions are discussed in the [Error Handling](/docs/error-handling) guide.

Functions may have several parameters.
```ocaml
# fun a b -> a ^ " " ^ b;;
- : string -> string -> string = <fun>

# let mean a b = (a + b) / 2;;
val mean : int -> int -> int = <fun>
```

Like the product type symbol `*`, the function type symbol `->` is not associative. The following two types are not the same:
- `(int -> int) -> int` : This is a function taking a function of type `int -> int` as parameter and returning an `int` as result.
- `int -> (int -> int)` : This is a function taking an `int` as parameter and returning a function of type `int -> int` as result.

### Unit

Uniquely, the type `unit` has only one value. It is written `()` and pronounced “unit.”

The `unit` type has several uses. One of its main roles is to serve as a token when a function does not need to be passed data or doesn't have any data to return once it has completed its computation. This happens when functions have side effects such as OS-level I/O. Functions need to be applied to something for their computation to be triggered, and they also must return something. When nothing meaningful can be passed or returned, `()` should be used.
```ocaml
# read_line;;
- : unit -> string = <fun>

# print_endline;;
- : string -> unit = <fun>
```

The function `read_line` reads an end-of-line terminated sequence of characters from standard input and returns it as a string. Reading input begins when `()` is passed.

The function `print_endline` prints the string followed by a line ending on standard output. Return of the unit value means the output request has been queued by the operating system.

## User-Defined Types

User defined types are always introduced using the `type … = …` construction. The keyword `type` must written in lowercase. The first ellipsis stands for type name and must not begin by a capital. The second ellipsis stands for the type definition. Three cases are possible
1. Variant
1. Record
1. Aliases

These three kinds of type definitions are covered in three next sections.

### Variants

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

Here is how pattern matching can be performed on the types defined above.
```ocaml
# let rectitude_to_french = function
    | Evil -> "Mauvais"
    | R_Neutral -> "Neutre"
    | Good -> "Bon";;
val rectitude_to_french : rectitude -> string = <fun>
```

Note that:

- `unit` is a variant with a unique constructor, which does not carry data: `()`.
- `bool` is also a variant with two constructors that don't carry data: `true` and `false`.

A pair `(x, y)` has type `a * b`, where `a` is the type of `x` and `b` is the type of `y`. Some may find it intriguing that `a * b` is called a product. Although this is not a complete explanation, here is a remark that may help in understanding: Consider the product type `character_class * character_alignement`. There are 12 classes and 9 alignments. Any pair of values from those types inhabits the product type. Therefore, in the product type, there are 9 × 12 = 108 values, which is also a product.

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

Here, the `function …` construct is used instead of the `match … with …` construct used previously.
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

The `match … with …` construct needs to be passed an expression that is inspected. The `function …` is a special form of anonymous function taking a parameter and forwarding it to a `match … with …` construct as shown above.

Warning: Wrapping product types with parenthesis turns them into a single parameter.
```ocaml
# type t1 = T1 of int * bool;;
type t1 = T1 of int * bool

# type t2 = T2 of (int * bool);;
type t2 = T2 of (int * bool)

# let p = (4, false);;
val p : int * bool = (4, false)

# T1 p;;
Error: The constructor T1 expects 2 argument(s),
       but is applied here to 1 argument(s)

# T2 p;;
- : t2 = T2 (4, false)
```

The constructor `T1` has two parameters of type `int` and `bool` whilst the constructor `T2` has a single parameter of type `int * bool`.

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
      List.fold_left (fun b (key, obj) -> b || key = name || has_field name obj) false u
  | _ -> false;;
val has_field : string -> json -> bool = <fun>
```

Here, the last pattern uses the symbol `_`, which catches everything. It allows returning `false` on all data which is neither `Array` nor `Object`.

### Polymorphic Data Types

#### Revisiting Predefined Types

The predefined type `option` is defined as a variant type with two constructors: `Some` and `None`. It can contain values of any type, such as `Some 42` or `Some "hola"`. In that sense, `option` is polymorphic. Here is how it is defined in the standard library:

```ocaml
# #show option;;
type 'a option = None | Some of 'a
```

The predefined type `list` is polymorphic in the same sense. It is a variant with two constructors and can hold data of any type. Here is how it is defined in the standard library:
```ocaml
# #show list;;
type 'a list = [] | (::) of 'a * 'a list
```

The only bit of magic here is turning constructors into symbols. This is left unexplained in this tutorial. The types `bool` and `unit` also are regular variants, with the same magic:
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

Where `(int, bool) pair` would be written `int * bool` and `Pair (42, true)` would be written `(42, true)`. From the developer's perspective, everything happens as if such a type were declared for every possible product shape. This is what allows pattern matching on products.

Even integers and floats can be seen as enumerated-like variant types, with many constructors and funky syntactic sugar. This is what allows pattern matching on those types.

In the end, the only type construction that does not reduce to a variant is the function arrow type. It is possible to perform pattern matching on values of any type, except functions.

#### User-Defined Polymorphic

Here is an example of a variant type that combines constructors with data, constructors without data, polymorphism, and recursion:
```ocaml
# type 'a tree =
  | Leaf
  | Node of 'a * 'a tree * 'a tree;;
type 'a tree = Leaf | Node of 'a * 'a tree * 'a tree
```

It can be used to represent arbitrarily labelled binary trees. Assuming such a tree would be labelled with integers, here is a possible way to compute the sum of the integers it contains, using recursion and pattern-matching.
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

In the OCaml community as well as in the larger functional programming community, the word *polymorphism* is used loosely. It is applied to things working in a similar fashion with various types. Several features of OCaml are polymorphic, in the broad sense, each is using a particular form of it, including its own name. In summary, OCaml has several forms of polymorphism. In most cases, the distinction between those concepts is blurred, but it sometimes needs to distinguish them. Here are the terms applicable to datatypes.
1. `'a list`, `'a option`, and `'a tree` are very often said to be polymorphic types. Formally, `bool list` or `int option` are the types, whilst `list` and `option` are [type operators](https://en.wikipedia.org/wiki/Type_constructor) that take a type as a parameter and result in a type. This is a form of [parametric polymorphism](https://en.wikipedia.org/wiki/Parametric_polymorphism). `'a list` and `'a option` denote [type families](https://en.wikipedia.org/wiki/Type_family), which are all the types created by applying type parameters to the operators.
2. OCaml has something called _Polymorphic Variants_. Although the types `option`, `list`, and `tree` are variants and polymorphic, they aren't polymorphic variants. They are type-parametrised variants. We stick to this usage and say the variants in this section are polymorphic. OCaml polymorphic variants are [covered in another tutorial](https://v2.ocaml.org/learn/tutorials/labels.html).

### Records

Records are like tuples in that several values are bundled together. In a tuple, elements are identified by their position in the corresponding product type. They are either first, second, third, or at some other position. In a record, each element has a name, it's a field. That's why record types must be declared before being used.

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

Access to the fields is done using the dot notation. Here is an example:
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

To some extent, records also are variants, with a single constructor carrying all the fields as a tuple. Here is how to alternatively define the `character` record as a variant.
```ocaml
# type character' = Character of string * int * string * character_class * (firmness * rectitude) * int;;
type character' =
    Character of string * int * string * character_class *
      (firmness * rectitude) * int

# let name (Character (name, _, _, _, _, _)) = name;;
val name : character' -> string = <fun>

# let level (Character (_, level, _, _, _, _)) = level;;
val level : character' -> int = <fun>

# let race (Character (_, _, race, _, _, _)) = race;;
val race : character' -> string = <fun>

# let class_type (Character (_, _, _, class_type, _, _)) = class_type;;
val class_type : character' -> character_class = <fun>

# let alignment (Character (_, _, _, _, alignment, _)) = alignment;;
val alignment : character' -> firmness * rectitude = <fun>

# let armor_class (Character (_, _, _, _, _, armor_class)) = armor_class;;
val armor_class : character -> int = <fun>
```

One function will retrieve and read the contained data per field. It provides the same functionality as the dotted notation.
```ocaml
# let ghorghor_bey' = Character ("Ghôrghôr Bey", 17, "half-ogre", Fighter, (Chaotic, R_Neutral), -8);;
val ghorghor_bey' : character =
  Character ("Ghôrghôr Bey", 17, "half-ogre", Fighter, (Chaotic, R_Neutral), -8)

# level ghorghor_bey';;
- : int = 17
```
Writing `level ghorghor_bey'` is the same as `ghorghor_bey.level`.

**Remarks**

1. To be true to facts, it is not possible to encode all records as variants because OCaml provides a means to define fields whose value can be updated, which isn't available while defining variant types. This will be detailed in an upcoming tutorial on imperative programming.

1. Records **should not** be defined using this technique. It is only demonstrated here to further illustrate the expressive strength of OCaml variants.

1. This way, to define records **may** be applied to _Generalised Algebraic Data Types_, which is the subject of another tutorial.

### Type Aliases

Just like values, any type can be given a name.
```ocaml
# type latitude_longitude = float * float;;
type latitude_longitude = float * float
```

This is mostly useful as a means of documentation or as a means to shorten long-type expressions.

## A Complete Example: Mathematical Expressions

This example show how to represent simple mathematical expressions like `n * (x + y)` and multiply them out symbolically to get `n * x + n * y`.

Here is a type for these expressions:
```ocaml env=expr
# type expr =
  | Plus of expr * expr        (* a + b *)
  | Minus of expr * expr       (* a - b *)
  | Times of expr * expr       (* a * b *)
  | Divide of expr * expr      (* a / b *)
  | Var of string              (* "x", "y", etc. *);;
```

The expression `n * (x + y)` would be written:
```ocaml env=expr
# let e = Times (Var "n", Plus (Var "x", Var "y"));;
val e : expr = Times (Var "n", Plus (Var "x", Var "y"))
```

Here is a function which prints out `Times (Var "n", Plus (Var "x", Var "y"))`
as something more like `n * (x + y)`.

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
# let rec distribute = function
  | Times (e1, Plus (e2, e3)) ->
     Plus (Times (distribute e1, distribute e2),
           Times (distribute e1, distribute e3))
  | Times (Plus (e1, e2), e3) ->
     Plus (Times (distribute e1, distribute e3),
           Times (distribute e2, distribute e3))
  | Plus (e1, e2) -> Plus (distribute e1, distribute e2)
  | Minus (e1, e2) -> Minus (distribute e1, distribute e2)
  | Times (e1, e2) -> Times (distribute e1, distribute e2)
  | Divide (e1, e2) -> Divide (distribute e1, distribute e2)
  | Var v -> Var v;;
val distribute : expr -> expr = <fun>
```

This is how it can be used:
```ocaml env=expr
# e |> distribute |> to_string |> print_endline;;
((n * x) + (n * y))
- : unit = ()
```

How does the `distribute` function work? The key is in the first two patterns.
The first pattern is `Times (e1, Plus (e2, e3))` which matches expressions of
the form `e1 * (e2 + e3)`. The right-hand side of this first pattern is the
equivalent of `(e1 * e2) + (e1 * e3)`. The second pattern does the same thing,
except for expressions of the form `(e1 + e2) * e3`.

The remaining patterns don't change the expressions's form, but they call the
`distribute` function recursively on their subexpressions. This ensures that all
subexpressions within the expression get multiplied out too (if you only wanted
to multiply out the very top level of an expression, then you could replace all
the remaining patterns with a simple `e -> e` rule).

The reverse operation, i.e. factorizing out common subexpressions, can be
implemented in a similar fashion. The following version only works for the top
level expression.
```ocaml env=expr
# let top_factorize = function
  | Plus (Times (e1, e2), Times (e3, e4)) when e1 = e3 ->
     Times (e1, Plus (e2, e4))
  | Plus (Times (e1, e2), Times (e3, e4)) when e2 = e4 ->
     Times (Plus (e1, e3), e4)
  | e -> e;;
val top_factorize : expr -> expr = <fun>
# top_factorize (Plus (Times (Var "n", Var "x"),
                   Times (Var "n", Var "y")));;
- : expr = Times (Var "n", Plus (Var "x", Var "y"))
```

The factorize function above introduces another feature: *guards* to each
pattern. It is the conditional which follows the `when`, and it means that
the return code is executed only if the pattern matches and the condition in the
`when` clause is satisfied.

## Conclusion

This tutorial has provided a comprehensive overview of the basic data types in OCaml and their usage. We have explored the built-in types, such as integers, floats, characters, lists, tuples, and strings, and the user-defined types: records and variants. Records and tuples are mechanisms for grouping heterogeneous data into cohesive units. Variants are a mechanism for exposing heterogeneous data as coherent alternatives.

From the data point of view, records and tuples are similar to the logical conjunction “and,” while variants are similar to the logical disjunction “or.” This analogy goes very deep, with records and tuples on one side as products and variants on the other side as union. These are true mathematical operations on data types. Records and tuples play the role of multiplication, which is why they are called product types. Variants play the role of addition. Putting it all together, basic OCaml types are said to be algebraic.

## Next: Advanced Data Types

Going further, there are several advanced topics related to data types in OCaml that you can explore to deepen your understanding and enhance your programming skills.
- Mutually Recursive Variants
- Polymorphic Variants
- Extensible Variants
- Generalised Algebraic Data Types

As of writing this, these topics are not yet covered in tutorials. Documentation on them is available in the OCaml [Language Manual](https://v2.ocaml.org/releases/5.0/htmlman/index.html) and in the [books](https://ocaml.org/books) on OCaml.
