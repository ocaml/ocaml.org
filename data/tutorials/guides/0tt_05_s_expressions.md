---
id: s-expressions
title: S-Expressions
description: >
  A tutorial on how to work with S-Expressions in OCaml
category: "Tutorials"
---

# S-Expressions

## Introduction

S-expressions is a popular text serialization format among the OCaml community. In the same way that JSON or YAML can be used to **pass structured data** between various components in a web-based context, S-expressions often fill the same role within an OCaml-to-OCaml context. The S-expression format isn't limited to OCaml and is quite old, it was invented for the Lisp language.

The [`sexplib`](https://github.com/janestreet/sexplib) created by Jane Street provides support for S-expression in OCaml. It was developped to provide support for S-expression to [Base](https://github.com/janestreet/base) and [Core](https://github.com/janestreet/core). However, S-expressions serialization does not depend on these packages. In this tutorial, we only use `sexplib`. You can install it using Opam.
```shell
$ opam install sexplib
```

## S-Expression format

S-expressions are represented as **nested lists** surrounded by parenthesis. Each element of the list can be either an **atom** or another nested list. The format of an S-expression follows a specific structure, which is crucial to understand when manipulating S-expressions.

Here are a few examples:

```lisp
()
(a)
(a b)
(a b c)
(a (b 0) (c 1.2))
```

Each of the individual symbols are atoms. An **atom** represents a basic data value. Atoms can be of different types, including integers, floating-point numbers, strings or booleans. In OCaml, atoms are represented as their corresponding OCaml data types. For example:

  + Integer: `42`
  + Float: `3.14`
  + String: `"Hello, world!"`
  + Boolean: `true`


Inside each set of parentheses is a nested list of S-Expressions. A nested list is used to represent the **hierarchical structure of S-Expressions**. Each element can be an atom or another nested list. The elements within the list are separated by spaces.

In OCaml, S-Expressions are defined as follows:

```ocaml
type sexp =
  | Atom of string
  | List of sexp list (** Nested list. *)
```

This type and the basic operations associated to this type are defined in the [sexplib](https://github.com/janestreet/sexplib) package.

Note: the syntax of [Dune configuration files](https://dune.readthedocs.io/en/latest/reference/lexical-conventions.html) is similar to S-expressions.

## Serializing

> Serialization is the process of translating a data structure or object state into a format that can be stored (e.g. files or data buffers) or transmitted and reconstructed later.

Here it means we can translate OCaml data types into S-expressions and then into a more machine readable format.

### Constructing

The [Core](https://github.com/janestreet/core) package provides many ways to deal with S-expressions, a `Sexp` module to deal with the S-expressions themselves, and `sexp_of_t` / `t_of_sexp` functions provided by data type modules (like `String`, `List`, etc.) that allow to convert OCaml data to and from S-expressions.

The provided examples are intended to be excuted in `utop`. Here is the initial setup:

```ocaml
# require "sexplib";;
# open Sexplib;;
```

To manually build S-expressions we can combine the two constructors `Atom` and `List` presented above. To build the S-expression representing `(1)`: 
```ocaml
# Sexp.Atom "1";;
- : Type.t = Sexplib.Sexp.Atom "1"
```
To build the S-expression representing `(1 2)`:
```ocaml
# Sexp.List [Atom "1"; Atom "2"];;
- : Type.t = Sexplib.Sexp.List [Sexplib.Sexp.Atom "1"; Sexplib.Sexp.Atom "2"]
```

### Printing and Formatting

For display the representation of the S-expressions, formatting functions like `Sexp.pp` are provided:

```ocaml
# Format.printf "%a\n" Sexp.pp Sexp.(List [List [Atom "1"; Atom "hello"]]);;
((1 hello))
- : unit = ()
```

To convert an S-expression to a string, simply use `Sexp.to_string`:
```ocaml
# Sexp.to_string Sexp.(List [List [Atom "1"; Atom "hello"]]);;
- : string = "((1 hello))"
```

You can also directly write the representation of an S-expression in a file by using `Sexp.save`:
```ocaml
# Sexp.save "myfile" Sexp.(List [List [Atom "1"; Atom "hello"]]);;
- : unit = ()
```

## Deserializing

> Deserialization is the process of extracting a data structure from a series of bytes.

Here it means we can build S-expressions from a storage format, like strings.

### Parsing

To parse an S-expression from a string, one can use `Sexp.of_string`:
```ocaml
# Sexp.of_string "((1 hello))";;
- : Type.t =
Sexplib.Sexp.List
 [Sexplib.Sexp.List [Sexplib.Sexp.Atom "1"; Sexplib.Sexp.Atom "hello"]]
```

Similarly, the function `Sexp.load_sexp` will read an S-expression from a file:
```ocaml
# Sexp.load_sexp "myfile";;
- : Type.t =
Sexplib.Sexp.List
 [Sexplib.Sexp.List [Sexplib.Sexp.Atom "1"; Sexplib.Sexp.Atom "hello"]]
```

### Pattern-matching

If you don't know the structure of some S-expressions beforehand it is possible to match on the `Atom` and `List` constructors to lookup for some value, for example:

```ocaml
# let rec contains_zero = function
    | Sexp.Atom "0" -> true
    | Sexp.Atom _ -> false
    | Sexp.List lx -> List.exists contains_zero lx;;
val contains_zero : Type.t -> bool = <fun>
# contains_zero (Sexp.List [Sexp.Atom "1"; Sexp.Atom "hello"]);;
- : bool = false
```

## Converting between OCaml types and S-Expressions

### Converting OCaml types into S-expressions

To build S-expressions from OCaml predefined types we can use the `sexp_of_t` functions predefined in this package:
```ocaml
# Std.sexp_of_int 0;;
- : Type.t = Sexp.Atom "0"
# Std.sexp_of_float 1.2;;
- : Type.t = Sexp.Atom "1.2"
# Std.sexp_of_string "hello world";;
- : Type.t = Sexp.Atom "hello world"
```

These functions can also be combined with the polymorphic ones available for lists and arrays:
```ocaml
# Std.(sexp_of_list sexp_of_int [1; 2; 3]);;
- : Type.t =
Sexp.List
 [Sexp.Atom "1"; Sexp.Atom "2"; Sexp.Atom "3"]

# Std.(sexp_of_array sexp_of_int [|3; 2; 1|]);;
- : Type.t =
Sexp.List
 [Sexp.Atom "3"; Sexp.Atom "2"; Sexp.Atom "1"]
```

By combining these functions you can write your own `sexp_of_t` functions for your own types (we will see later how to generate them automatically).

### Converting S-expressions into OCaml types

Similarly it is possible to convert S-expressions into the corresponding OCaml types by using the predefined `t_of_sexp` functions:
```ocaml
# Std.int_of_sexp (Sexp.Atom "0");;
- : int = 0
# Std.float_of_sexp (Sexp.Atom "1.2");;
- : float = 1.2
# Std.string_of_sexp (Sexp.Atom "hello world");;
- : string = "hello world"
```

Here again we can combine these functions with the ones defined for polymorphic data types such as:
```ocaml
# Std.list_of_sexp Std.int_of_sexp (Sexp.List [Sexp.Atom "1"; Sexp.Atom "2"; Sexp.Atom "3"]);;
- : int list = [1; 2; 3]
# Std.array_of_sexp Std.int_of_sexp (Sexp.List [Sexp.Atom "3"; Sexp.Atom "2"; Sexp.Atom "1"]);;
- : int array = [|3; 2; 1|]
```

### Setting up `ppx_sexp_conv`

[`ppx_sexp_conv`](https://github.com/janestreet/ppx_sexp_conv) is a library and a [PPX rewriter](https://ocaml.org/docs/metaprogramming#ppx-rewriters) that allows conversions between S-Expressions and OCaml types.

First, `ppx_sexp_conv` needs to be installed:
```shell
$ opam install ppx_sexp_conv
```

Then, to use `ppx_sexp_conv` in your project you must list it as a dependency and as a preprocessor in your dune file:
```lisp
(library
  (name <your_lib>)
 (preprocess
  (pps ppx_sexp_conv))
 (libraries ppx_sexp_conv <your_dependencies>))
```

Finally, to add the predefined converters to the scope, you must open the `Sexplib.Std` module.

### Automatically Generate Conversion Functions

`ppx_sexp_conv` will automatically generate conversion functions for the selected OCaml types.

These functions are of the form:
- `sexp_of_*` to convert from an OCaml type to a S-Expression
- `*_of_sexp` to convert from a S-Expression to an OCaml type

For example, `sexp_of_int` and `int_of_sexp` are generated for basic the `int` type. These functions will be specifically named after the OCaml type they allow to convert to and from.

To automatically generate such functions for your own type, you must annotate the type definition with an attribute: `[@@deriving sexp]`, such as:

```ocaml
# type color = Red | Blue | Green [@@deriving sexp];;
type color = Red | Blue | Green
val color_of_sexp : Sexp.t -> color = <fun>
val sexp_of_color : color -> Sexp.t = <fun>
```

This will prompt the `ppx_sexp_conv` preprocessor to generate both `sexp_of_color` and `color_of_sexp` functions, to convert between values of the type `color` and S-Expressions.

You can then use the generated function as usual:
```ocaml
# sexp_of_color Blue;;
- : Sexp.t = Sexplib.Sexp.Atom "Blue"
```

To only generate the `sexp_of_color` function, you can annotate the type with `[@@deriving sexp_of]`. Likewise, to only generate the `color_of_sexp` function, you can annotate the type with `[@@deriving of_sexp]`.

Every component of your type must also be converted:

```ocaml
# type direction = Up | Bottom | Left | Right [@@deriving sexp];;
type direction = Up | Bottom | Left | Right
val direction_of_sexp : Sexp.t -> direction = <fun>
val sexp_of_direction : direction -> Sexp.t = <fun>

# type movement = { direction : direction; distance: int }
[@@deriving sexp];;
type movement = { direction : direction; distance : int; }
val movement_of_sexp : Sexp.t -> movement = <fun>
val sexp_of_movement : movement -> Sexp.t = <fun>
```

In the example above, annotating the type `movement` is not enough, it depends on the type `direction` so `direction` must also be annotated with `[@@deriving sexp]` for the `sexp_of_movement` and `movement_of_sexp` functions to be generated.


## Conclusion

In this tutorial we have presented the different uses of S-expressions. We discussed how to build them manually, how to read them from a string and how to display them as a string. Similarly we showed how they can be used to convert from and to OCaml data types, and these conversions can be automatically generated by `ppx_sexp_conv`.

For more information, please refer to the documentation of the following modules and libraries:
- [sexplib](https://github.com/janestreet/sexplib): library containing basic S-exp functions
- [ppx_sexp_conv](https://github.com/janestreet/ppx_sexp_conv): PPX syntax extension that generates code for converting OCaml types to and from s-expressions
- [sexp](https://github.com/janestreet/sexp): command-line tools to work with S-expressions
