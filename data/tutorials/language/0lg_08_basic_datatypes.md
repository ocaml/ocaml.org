---
id: basic-data-types
title: Basic Data Types
description: |
  TBD
category: "Language"
---

# Basic Data Types

## Introduction

OCaml is a statically and strongly typed programming language. It is also an expression-oriented language, everything is a value, and every value has a type. Functions and types are the two foundational principles of OCaml. The OCaml type system is highly expressive, providing many advanced constructs. Yet, it is easy to use and unobtrusive. Thanks to type inference, programs can be written without typing annotations, except for documentation purposes and a few corner cases. The basic types and the type combination operations enable a vast range of possibilities.

This tutorial begins with a section presenting the types that are predefined in OCaml. It starts with atomic types such as integers and booleans. It continues by presenting predefined compound types such as strings and lists. The tutorial ends with a section about user-defined types: variants and records.

OCaml provides several other types, but they all are extensions of those presented in this tutorial. Types that are in the scope of this tutorial are all the basic constructors and the most common predefined types.

## Prerequisies and Goals

This is an intermediate-level tutorial. The only prerequisite is to have completed the Get Started series of tutorials.

The goal of this tutorial is to provide for following capabilities:
- Handle data of all predefined types using dedicated syntax
- Write variant type definitions: simple, recursive and polymorphic
- Write record type definitions (without mutable fields)
- Write type aliases
- Use pattern matching to define functions for all basic types

## Predefined Types

### Integers, Characters, Booleans and Characters

#### Integers

Here is an integer:
```ocaml
# 42;;
- : int = 42
```

The `int` type is the default and basic type of integer numbers in OCaml. It represents platform-dependent signed integers. This means `int` does not always have same the number of bits, depending on underlying platform characteristics such as processor architecture or operating system. Operations on `int` values are provided by the [`Stdlib`](/api/Stdlib.html) and the [`Int`](/api/Int.html) modules.

Usually, `int` has 31 bits in 32-bit architectures and 63 in 64-bit architectures, one bit is reserved for OCaml's runtime operation. The standard library also provides [`Int32`](/api/Int32.html) and [`Int64`](/api/Int64.html) modules which support platform independent operations on 32 and 64 bits signed integers. These modules are not detailed in this tutorial.

There are no dedicated types for unsigned integers in OCaml, bitwise operations on `int` just ignore the sign bit. Binary operators use standard symbols, signed remainder is written `mod`. There is no predefined power operator on integers in OCaml.

#### Floats and Type Conversions

Fixed-size float numbers have type `float`. Operations on `float` complies with the IEEE 754 standard, with 53 bits of mantissa and exponent ranging from -1022 to 1023.

OCaml does not perform any implicit type conversion between values. Therefore, arithmetic expressions can't mix integers and floats, parameters are either all `int` or all `float`. Arithmetic operators on floats are not the same, they are written with a dot suffix: `+.`,  `-.`, `*.`, `/.`.
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

Operations on `bool` are provided by the [`Stdlib`](/api/Stdlib.html) and the [`Bool`](/api/Bool.html) modules. Conjunction (“and”) is written `&&` and disjunction (“or”) is written `\\`; both don't evaluate their right argument if the value of their left argument is sufficient to decide the value of the whole expression.

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

Strings are finite and fixed-sized sequences of values of type `char`. Strings are immutable, it is impossible to change the value of a character inside a string. The string concatenation operator symbol is `^`.
```ocaml
# "" ^ " " ^ "world!";;
- : string = "hello world!"
```

Indexed access to string characters is possible using the following syntax:
```ocaml
# "buenos dias".[4];;
- : char : 'o'
```
Operations on `string` values are provided by the [`Stdlib`](/api/Stdlib.html) and the [`String`](/api/String.html) modules.

#### Byte Sequences

Byte sequences are finite and fixed-sized sequences of bytes. Each individual byte is represented by a `char` value. Byte sequences are mutable, they can't be extended or shortened, but each component byte may be updated. Essentially, a byte sequence `byte` is a mutable string that can't be printed. There is no way to write a `bytes` literally, it must be produced by a function.
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

Arrays may contain values of any type. Here arrays are `int array`, `char array` and `string array`, but any type of data can be used in an array. Usually, `array` is said to be a polymorphic type. Strictly speaking, it is a type operator, it accepts a type as a parameter (here `int`, `char` and `string`) to form another type (those inferred here). This is the empty array.
```ocaml
# [||];;
- : 'a array = [||]
```
Here `'a` means “any type”. It is called a type variable and is usually pronounced as if it were the Greek letter α (“alpha”). This type parameter is meant to be replaced by another type.

Like `string` and `bytes`, arrays support direct access, but the syntax is not the same.
```ocaml
# [| 'a'; 'b'; 'c' |].(2);;
- : char = 'c'
```

Arrays are mutable, they can't be extended or shortened, but each component value may be updated.
```ocaml
# let a = [| 'a'; 'b'; 'c'; 'd' |];;
val a : char array = [|'a'; 'b'; 'c'; 'd'|]

# a.(2) <- '3';;
- : unit = ()

# a;;
- : char array = [|'a'; 'b'; '3'; 'd'|]
```

Operations on arrays are provided by the [`Array`](/api/Array.html) modules. There is a dedicated tutorial Arrays.

#### Lists

As literals, lists are very much like arrays. Here are the same examples as previously, turned into lists.
```ocaml
# [ 0; 1; 2; 3; 4; 5 ];;
- : int list = [0; 1; 2; 3; 4; 5]

# [ 'a'; 'b'; 'c' ];;
- : char list = ['a'; 'b'; 'c'|]

# [ "foo"; "bar"; "baz" ];;
- : string list = ["foo"; "bar"; "baz"]
```

Like arrays, lists are finite sequences of values of the same type. They are polymorphic too. However, lists are extensible, immutable, and don't support direct access to all the values it contains. Lists play a central role in functional programming, they are the subject of a [dedicated tutorial](/docs/lists).

Operations on lists are provided by the [`List`](/api/List.html) module. The `List.append` function, which concatenates two lists can also be used as an operator with the symbol `@`.

Two symbols are of special importance with respect to lists.
- The empty list is written `[]`, has type `'a list'` and is pronounced nil
- The list constructor operator, written `::` and pronounced “cons”, is used to add a value at the head of a list

Together, they are the basic means to build lists and access the data stored in lists. For instance here is how lists are built by successively applying the cons operator.
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

In the above expressions `[1; 2; 3]` is the value which is matched over. Each expression between `|` and `->` symbols is a pattern. They are expressions of type list, only formed using `[]`, `::` and variables names; representing various shapes a list may have. When the pattern is `[]` it means “if the list is empty”. When the pattern is `x :: u` it means “if the list contains data, let `x` be the first element of the list and `u` be the rest of the list.” Expression at the right of the `->` symbols are the results returned in each corresponding case.

Operations on lists are provided by the [`List`](/api/List.html) module. There is a dedicated tutorial on Lists.

### Options & Results

#### Options

The `option` type is also a polymorphic type. Option values can store any kind of data, or represent the absence of any such data. Option values can only be constructed in two different ways; either `None` when no data is available or `Some` otherwise.
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

When it makes sense to mark the outcomes of a function as being either failure or success, the `result` type can do it. There are only two ways to build a result value; either using `Ok` or `Error`, with the intended meaning. Both constructors can hold any kind of data. The `result` type is polymorphic but it has two type parameters, one for `Ok` values, and another for `Error` values.
```ocaml
# Ok 42;;
- : (int, 'a) result = Ok 42

# Error "Sorry";;
- : ('a, string) result = Error "Sorry"
```

Operations on results are provided by the [`Result`](/api/Result.html) module. Results are discussed in the [Error Handling](/docs/error-handling) guide.

### Tuples

Here is a tuple, actually a pair.
```ocaml
# (3, 'a');;
- : int * char = (3, 'a')
```

This is a pair containing the integer `3` and the character `'a'`; its type is `int * char`. The `*` symbol stands for _product type_.

This generalizes to tuples with 3 or more components, for instance : `(6.28, true, "hello")` has type `float * bool * string`. The types `int * char` and `float * bool * string` are called _product types_. The `*` symbol is used to denote types bundled together in products.

The predefined function `fst` returns the first component of a pair, while `snd` returns the second component of a pair.
```ocaml
# fst (3, 'a');;
- : int = 3

# snd (3, 'a');;
- : char = 'a'
```

In the standard library, both are defined using pattern matching. Here is how a function extracts the third component of the product of four types.
```ocaml
# let f x = match x with (a, b, c, d) -> c;;
val f : 'a * 'b * 'c * 'd -> 'c = <fun>
```

Note that the product type operator `*` is not associative. Types `int * char * bool`, `int * (char * bool)` and `(int * char) * bool` are not the same, the values `(42, 'a', true)`, `(42, ('a', true))` and `((42, 'a'), true)` are not equal.

### Functions

The type of functions from type `a` to type `b` is written `a -> b`. Here are a few examples:
```ocaml
# fun x -> x * x;;
- : int -> int = <fun>

# (fun x -> x * x) 9;;
- : int = 81
```

The first expression is an anonymous function of type `int -> int`. The type is inferred from the expression `x * x` which must be of type `int` since `*` is an operator which returns an `int`. The `<fun>` printed in place of the value is a token meaning functions don't have a value to be displayed. This is because if they have been compiled, their code may not be available.

The second expression is function application, the parameter `9` is applied, and the result `81`` is returned.

```ocaml
# fun x -> x;;
- : 'a -> 'a = <fun>

# (fun x -> x) 42;;
- : int = 42

# (fun x -> x) "This is really disco!";;
- : string = "This is really disco!"
```

The first expression is another anonymous function, it is the identity function, and it returns its argument, unchanged. This function can be applied to anything. Anything can be returned unchanged. This means the parameter of that function can be of any type, and the result must have the same type. This is called _polymorphism_ the same code can be applied to data of different types.

This is what is indicated by the `'a` in the type (pronounced as the Greek letter α, “alpha”). This is a _type variable_. It means values of any type can be passed to the function. When that happens, their type is substituted for the type variable. This also expresses identity has the same input and output type, whatever it may be.

The two following expressions show the identity function can indeed be applied to parameters of different types.

```ocaml
# let f = fun x -> x * x;;
f : int -> int = <fun>

# f 9;;
- : int = 81
```

Defining a function is the same as giving a name to any value. This is was is illustrated in the first expression.

```ocaml
# let g x = x * x;;
g : int -> int

# g 9;;
- : int = 81
```

When writing in OCaml, a lot of functions are written. The function `g` is defined here using a shorter, more common syntax and maybe more intuitive syntax.

In OCaml, functions may terminate without returning a value of the expected type by throwing an exception, this does not appear in its type. There is no way to know if a function may raise an exception without inspecting its code.
```ocaml
# raise;;
- : exn -> 'a' = <fun>
```

Functions may have several parameters.
```ocaml
# fun a b -> a ^ " " ^ b;;
- : string -> string -> string = <fun>

# let mean a b = (a + b) / 2;;
val mean : int -> int -> int = <fun>
```

As for the product type symbol `*`, the function type symbol `->` is not associative. These two types are not the same:
- `(int -> int) -> int` : This is a function taking a function of type `int -> int` as parameter, and returning an `int` as result
- `int -> (int -> int)` : This is a function taking an `int` as parameter and returning a function of type `int -> int` as result

### Unit

A unique value has type `unit`, it is written `()` and pronounced “unit”.

The `unit` type has several usages. One of its main roles is to serve as a token when a function does not need to be passed data or doesn't have any data to return once it has completed its computation. This happens when functions have side effects such as OS-level I/O. Functions need to be applied to something for their computation to be triggered, they also must return something. When nothing making sense can be passed or returned, `()` should be used.
```ocaml
# read_line;;
- : unit -> string = <fun>

# print_endline;;
- : string -> unit = <fun>
```

Function `read_line` reads an end-of-line terminated sequence of characters from standard input and returns it as a string. Reading input begins when `()` is passed.

Function `print_endline` prints the string followed by and line ending on standard output. Return of the unit value means the output request has been queued by the operating system.

## User-Defined Types

### Variants

#### Enumerated Data Types

The simplest form of a variant type corresponds to an [enumerated type](https://en.wikipedia.org/wiki/Enumerated_type). It is defined by an explicit list of named values. Defined values are called constructors and must be capitalized.

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

Such kind of variant types can also be used to represent weekdays, cardinal
directions or any other fixed-sized set of values that can be given names. A
total ordering is defined on values, following the definition order (e.g. `Druid
< Ranger`).

Here is how pattern matching can be done on types defined as such.
```ocaml
# let rectitude_to_french = function
    | Evil -> "Mauvais"
    | R_Neutral -> "Neutre"
    | Good -> "Bon"
val rectitude_to_french : rectitude -> string = <fun>
```

Note that:

- `unit` is an enumerated-as-variant with a unique constructor: `()`.
- `bool` is also an enumerated-as-variant with two constructors: `true` and `false`.

A pair `(x, y)` has type `a * b` where `a` is the type of `x` and `b` is the type of `y`. Some may find it intriguing that `a * b` is called a product. Although this is not a complete explanation, here is a remark which may help understanding. Consider the product type `character_class * character_alignement`. There are 12 classes and 9 alignments. Any pair of values from those types inhabit the product type. Therefore, in the product type, there are 9 × 12 = 108 values, which also is a product.

#### Constructors With Data

It is possible to wrap data in constructors. The following type has several constructors with data and some without. It represents the different means to refer to a Git [revision](https://git-scm.com/docs/gitrevisions).
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

Here is how pattern matching can be used to write a function from `commit` to `string`
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

Here, the `function ...` construct is used instead of the `match ... with ...` construct. Previously, example functions had the form `let f x = match x with ...` and the variable `x` did not appear after any of the `->` symbols. When this is the case the `function ...` construct can be used instead, it stands for `fun x -> match x with ...` and saves from finding a name which is used right after and only once.


#### Recursive Variants

A variant definition referring to itself is recursive. A constructor may wrap data from the type being defined.

This is the case of the following definition, which can be used to store JSON values.
```ocaml
# type json =
  | Null
  | Bool of bool
  | Int of int
  | Float of float
  | String of string
  | Array of json list
  | Object of (string * json) list;;
```

Both constructors `Array` and `Object` contain values of type `json`.

Functions defined using pattern matching on recursive variants are often recursive too. This function checks if a name is present in a whole JSON tree.
```ocaml
# let rec has_field name = function
  | Array u ->
      List.fold_left (fun b obj -> b || has_field name obj) false u
  | Object u ->
      List.fold_left (fun b (key, obj) -> b || key = name || has_field name obj) false u
  | _ -> false;;
```

Here, the last pattern uses the symbol `_` which catches everything. It allows returning `false` on all data which is neither `Array` nor `Object`.

### Polymorphic Data Types

#### Revisiting Predefined Types

The predefined type `option` is defined as a variant type, with two constructors: `Some` and `None`. It can contain values of any type, such as `Some 42` or `Some "hola"`. The variant `option` is polymorphic. Here is how it is defined in the standard library:

```ocaml
#show option;;
type 'a option = None | Some of 'a
```

The predefined type `list` is also a polymorphic variant with two constructors. Here is how it is defined in the standard library:
```ocaml
#show list;;
type 'a list = [] | (::) of 'a * 'a list
```

The only bit of magic here is turning constructors into symbols. This is left unexplained in this tutorial. The types `bool` and `unit` also are regular variants, with the same magic:
```ocaml
#show unit;;
type unit = ()

#show bool;;
type bool = false | true
```

Implicitly, product types also behave as variant types. For instance, pairs can be seen as inhabitants of this type:
```ocaml
# type ('a, 'b) pair = Pair of 'a * 'b;;
type ('a, 'b) pair = Pair of 'a * 'b
```

Where `(int, bool) pair` would be written `int * bool` and `Pair (42, true)` would be written `(42, true)`. From the developer's perspective, everything happens as if such a type would be declared for every possible product shape. This is what allows pattern matching on products.

Even integers and floats can be seen as enumerated-like variant types, with many constructors and funky syntactic sugar. This is what allows pattern matching on those types.

In the end, the only type construction that does not reduce to a variant is the function arrow type. No pattern matching on functions.

#### User-Defined Polymorphic

Here is an example of a variant type that combines constructors with data and without data, polymorphism and recursion.
```ocaml
# type 'a tree =
  | Leaf
  | Node of 'a * 'a tree * 'a tree;;
type 'a tree = Leaf | Node of 'a * 'a tree * 'a tree
```

It can be used to represent arbitrarily labelled binary trees. Using pattern matching, here is how the map function can be defined in this type:
```ocaml
# let rec map f = function
  | Leaf -> Leaf
  | Node (x, lft, rht) -> Node (f x, map f lft, map f rht);;
val map : ('a -> 'b) -> 'a tree -> 'b tree = <fun>
```

**Remark**: OCaml has something called _Polymorphic Variants_. Although the types `option`, `list` and `tree` are variants and polymorphic, they aren't polymorphic variants, they are type-parametrized variants. Among the functional programming community the word “polymorphism” is used loosely, whenever anything can be applied to various types. We stick to this usage and say the variants in this section are polymorphic. OCaml polymorphic variants are covered in another tutorial.

### Records

Records are like tuples, several values are bundled together. In a tuple, components are identified by their position in the corresponding product type. They are either first, second, third or at some position. In a record, each component has a name. That's why record types must be declared before being used.

For instance, here is the definition of a record type meant to partially represent a Dungeons & Dragons character class.
```ocaml
# type character = {
  name : string;
  level : int;
  race : string;
  class_type : character_class;
  alignment : firmnness * rectitude;
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
This is using the types `character_class` and `character_alignment` defined earlier. Values of type `character` carry the same data as inhabitants of this product: `string * int * string * character_class * character_alignment * int`.

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

To some extent, records also are variants, with a single constructor carrying all the fields as a tuple. Here is how to alternately define the `character` record as a variant.
```ocaml
# type character' = Character of string * int * string * character_class * (firmness * rectitude) * int;;

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

One function for each field, to get the data it contains. It provides the same functionality as dotted notation.
```ocaml
# let ghorghor_bey' = Character ("Ghôrghôr Bey", 17, "half-ogre", Fighter, (Chaotic, R_Neutral), -8);;
val ghorghor_bey' : character =
  Character ("Ghôrghôr Bey", 17, "half-ogre", Fighter, (Chaotic, R_Neutral), -8)

# level ghorghor_bey';;
- : int = 17
```
Writting `level ghorghor_bey'` is the same as `ghorghor_bey.level`.

**Remarks**

1. To be true to facts, it is not possible to encode all records as variants since OCaml provides a means to define fields whose value can be updated which isn't available while defining variant types. This is detailed in the tutorial on imperative programming.

1. Records SHOULD NOT be defined using this technique. It is only demonstrated here to further illustrate the expressive strength of OCaml variants.

1. This way to define records MAY be applied to _Generalized Algebraic Data Types_ which are the subject of another tutorial.

### Type Aliases

Just like values, any type can be given a name.
```ocaml
# type latitude_longitude = float * float;;
type latitude_longitude = float * float
```

This is mostly useful as a means of documentation or as a means to shorten long-type expressions.

## Conclusion

This tutorial has provided a comprehensive overview of the basic data types in OCaml and their usage. We have explored the built-in types, such as integers, floats, characters, lists, tuples and strings, and user-defined types: records and variant types. Records and tuples are mechanisms for grouping heterogeneous data into cohesive units. Variants are a mechanism for exposing heterogeneous data as coherent alternatives.

From the data point of view, records and tuples are like conjunction (logical “and”), while variants are like disjunction (logical “or”). This analogy goes very deep, with records and tuples on one side as products and variants on the other side as union. These are true mathematical operations on data types. Records and tuples play the role of multiplication, that why they are called product types. Variants play the role of addition. Putting it all together, basic OCaml types are said to be algebraic.

## Next: Advanced Data Types

Going further, there are several advanced topics related to data types in OCaml that you can explore to deepen your understanding and enhance your programming skills.

- The Algebra of Types
- Mutually Recursive Variants
- Polymorphic Variants
- Extensible Variants
- Generalised Algebraic Data Types