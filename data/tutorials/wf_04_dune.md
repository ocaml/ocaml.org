---
id: dune
title: Juggling with Modules, Libraries and Packages
description: >
  Learn about an OCaml's most-used, built-in data types
category: "guides"
date: 2023-01-12T09:00:00-01:00
---

# Juggling with Modules, Libraries and Packages

## Prerequisites

## Introduction

OCaml is a multi-paradigm programming language, it allows writing code using several styles. Historically, it has included four paradigms:

1. Functional - At its core, and from its inception, OCaml is a functional
   programming language. By default, it is the recommended style.
1. Imperative - For performance and comfort, OCaml provides most of the
   constructs found in imperative languages. However, they come with two twists:

   - No [nullable values](https://en.wikipedia.org/wiki/Null_pointer)
   - No confusion between mutable and [immutable values](https://en.wikipedia.org/wiki/Immutable_object)
1. Modular - In OCaml, the premier mean of structuring sources are modules,
   which allows separate compilation and avoiding name clashes. The OCaml module
   system remains among the most advanced with _functions_ from module to module (named
   _functors_ to avoid confusion with regular functions).
1. Object-Orientation - OCaml is not an object-oriented language, it provides
   means to write object-oriented software, but using that style is only an option, not a requirement of the language.

Since OCaml 5, a fifth paradigm is available: effect-handlers allow writing
software in a style which is so new it doesn't have a name yet! This will not be
discussed in this document.

The rest of this document presents the concepts and tools which are used to
structure most of the projects written in OCaml, in its functional and
modular part.

## Minimum Dune Setup

Examples in this document are command lines supposed to be executed in order.
They have been tested in Linux using Bourne shell `sh`.

[Dune](https://dune.build) is the main build system for OCaml. To start working,
it needs two files: a single `dune-project` which is supposed to be at the root
of the project and at least one `dune` file. Here is how to initialize the test
setup used in the document:

```sh
$ cd `mktemp -d -p ~`
$ echo '(lang dune 3.6)' > dune-project
$ echo '(executable (name clark))' > dune
```
Full-fledge projects will have more structure, but in order to keep this
tutorial as simple as possible we start from the bare minimum.

This setting allows compiling an empty project.
```sh
$ touch clark.ml
$ dune exec --display=quiet ./clark.exe
```

Yes, the empty file is valid OCaml syntax. In the rest of the document, here is how project files are presented:

##### `dune-project`
```lisp
(lang dune 3.6)
```

##### `dune`
```lisp
(executable (name clark))
```

##### `clark.ml`
```ocaml
```

## Modules Basics

This section recalls some basic concepts related to modules. Importantly, it
doesn't address functors. See [Modules](/docs) and [Functors](/functors)
tutorials for more detailed information about those concepts.

### Each `.ml` File Defines a Module

OCaml source code files are expected to have a `.ml` filename extension. The
compiler reads each of them once and conceptually produces one module per file.
For instance, the file `clark.ml` entails a module named `Clark`.

Definitions from a module can be used in other modules, they are uniquely
identified by the prefixing internal names with their module name. In the
following example, the module `Clark` is using a string defined in module
`Foo`. Here are the files:

<!--
echo 'let hello = "Hello"' > foo.ml
echo 'Printf.printf "%s\\n" Foo.hello' > clark.ml
-->
##### `foo.ml`
```ocaml
let hello = "Hello"
```
##### `clark.ml`
```ocaml
Printf.printf "%s\n" Foo.hello
```

Here is the compilation and execution:

```sh
$ dune exec --display=quiet ./clark.exe
Hello
```

### Private Definitions and `.mli` Files

It is possible to have definitions inside a module which aren't exposed to other modules. This can be done by associating a `.mli` file to the module that needs to keep definitions for itself. In this example, we add a private `world` string to the `Foo` module. The string `Foo.hello` is visible because it appears inside `foo.mli`. File `clark.ml` is unchanged.
<!--
echo 'let world = "world"' >> foo.ml
echo 'let hello = hello ^ " " ^ world ^ "!"' >> foo.ml
echo 'val hello : string' > foo.mli
-->
##### `foo.ml`
```ocaml
let hello = "Hello"
let world = "world"
let hello = hello ^ " " ^ world ^ "!"
```
##### `foo.mli`
```ocaml
val hello : string
```
Compilation and execution:
```sh
$ dune exec --display=quiet ./clark.exe
Hello world
```
But the string `Foo.world` is not visible from module `Clark` since it does not
appear inside `foo.mli`. If the file `clark.ml` is changed into this:
<!--
echo 'Printf.printf "%s\\n" Foo.world' > clark.ml
-->
##### `clark.ml`
```ocaml
Printf.printf "%s\n" Foo.world
```
Compilation fails:
```sh
$ dune exec --display=quiet ./clark.exe
File "clark.ml", line 1, characters 14-23:
1 | print_endline Foo.world
                  ^^^^^^^^^
Error: Unbound value Foo.world
```

### Inline Module Nesting

It is possible to define modules inside `.ml` files. Continuing with the same
example, we add two modules inside `Foo` (i.e. `foo.ml`): `Hello` and `World`,
each defining a string, which are both named `s`.
<!--
rm foo.mli
echo 'module Hello = struct let s = "Hello" end' > foo.ml
echo 'module World = struct let s = "world!" end' >> foo.ml
echo 'Printf.printf "%s %s\\n" Foo.Hello.s Foo.World.s' > clark.ml
-->
##### `foo.ml`
```ocaml
module Hello = struct let s = "Hello" end
module World = struct let s = "world" end
```
##### `clark.ml`
```ocaml
Printf.printf "%s %s!\n" Foo.Hello.s Foo.World.s
```
Compilation and execution:
```sh
$ dune exec --display=quiet ./clark.exe
Hello world!
```

## From Modules to Libraries

### Separated Files Module Nesting

Using Dune, it is possible to acheive the same modular organization as in the
previous subsection using separated files for each submodule of `Foo`. File
`clark.ml` is unchanged. A folder `bar` is created. Submodules `Hello` and
`World` are turned into stand-alone files: `hello.ml` and `world.ml`,
respectively, inside directory `bar`. The `foo.ml` file is removed. A `dune`
file is created inside `bar` to express it hosts the `Foo` module. A dependency
is added into the root `dune` file to express dependency on `Foo`.
<!--
mkdir bar
echo '(library (name foo))' > bar/dune
echo 'let s = "Hello"' > bar/hello.ml
echo 'let s = "World"' > bar/world.ml
echo '(executable (name clark) (libraries foo))' > dune
echo 'Printf.printf "%s %s!\\n" Foo.Hello.s Foo.World.s' > clark.ml
-->
##### `dune`
```lisp
(executable (name clark) (libraries foo))
```
##### `bar/hello.ml`
```ocaml
let s = "Hello"
```
##### `bar/world.ml`
```ocaml
let s = "World"
```
#### `bar/dune`
```lisp
(library (name foo))
```
Compilation and execution produces an unchanged output:
```sh
$ dune exec --display=quiet ./clark.exe
Hello world!
```

It is worth making a couple of observations:
* Name of the folder hosting `Foo` (here `bar`) is irrelevant
* File `bar/dune` means the folder `bar` exports a module named `Foo`, with a
  capital, despite being written `foo`, without a capital. This is inspired by
  the way file names induce module names.

### Flat Organization

In the previous example, module `Clark` at the root of the project, depends on
module `Foo`, located in folder `bar`. This is not a requirement, it is possible
to locate the `Clark` module in a folder next to `bar`. To acheive that, no file
editing is needed:
```sh
$ mkdir main
$ mv clark.ml dune main
$ dune exec --display=quiet ./main/clark.exe
Hello world!
```

Observations the project root folder no longer have any `dune` file.

### Private Definitions Without Interface Files

It is possible to restrict the exported interface of a module defined in a
folder using Dune without having to write a `.mli` file. This is done by having
a `.ml` file which has the same name as the one defined in the `dune` file. This
is how it can look like in our running example:
<!--
echo 'let s = Printf.sprintf "%s %s!" Hello.s World.s' > bar/foo.ml
echo 'Printf.printf "%s\n" Foo.s' > main/clark.ml
--->
##### bar/foo.ml
```ocaml
let s = Printf.sprintf "%s %s!" Hello.s World.s
```
With only this, the project no longer builds. There are no module definitions
statements inside `foo.ml`, threfore no modules `Foo.Hello` and `Foo.World` are
exported by `Foo`, despite the presence of files `hello.ml` and `world.ml` in
folder `bar`.
```sh
dune exec --display=quiet ./main/clark.exe
File "main/clark.ml", line 1, characters 25-36:
1 | Printf.printf "%s %s!\n" Foo.Hello.s Foo.World.s
                             ^^^^^^^^^^^
Error: Unbound module Foo.Hello
```
The main executable needs to be updated:
##### `main/clark.ml`
```ocaml
Printf.printf "%s\n" Foo.s
```
This restores the expected behaviour.
```sh
$ dune exec --display=quiet ./main/clark.exe
Hello World!
```
The `.ml` file bound modules `Hello` and `World` have become private inside
`Foo`.

### OCaml Libraries

Accute readers may wonder why Dune files in the previous examples mentions
`library` and `libraries` instead of `module` and `modules`. An OCaml library is
a module build from by aggregating a set of modules defined by files. A package
may exist only as a binary file. Historically, they had to be built as such.
Nowadays, Dune almost turns those binaries into a hidden design concern, only
exposing language level modules and dependencies between them.

Dune provides a mean to distinguish the name of the library from the name of the
module it defines. Let's illustrate this by modifying our example again:
<!--
touch disco.opam
echo '(library (name foo) (public_name disco))' > bar/dune
echo '(executable (name clark) (libraries disco))' > main/dune
-->

The `dune` file inside `bar` must declare the name of the package it provides,
using the `public-name` instruction:
##### `bar/dune`
```lisp
(library (name foo) (public-name disco))
```

The `dune` file inside `main` must declare
##### `main/dune`
```lisp
(executable (name clark) (libraries disco))
```

Additionally, the project must now have an Opam configuration file. It can remain empty for the time being:
##### `disco.opam`
```
```
With this, the overall behaviour remains unchanged:
```sh
dune exec --display=quiet ./main/clark.exe
Hello World!
```

Observe the package name `disco` only makes sense to Dune, it isn't naming any
module, file or directory. It only express dependency between components.
Because library names are turned into modules names, they must obey OCaml syntax
rules relatives to modules, they can't begin by a digit or have dots. Dune
library names have no such constraints.

## Combining Modules

The previous section mostly discussed:
- Accessing a module from another, that's dependencies
- Private definitions, that's encapsulation
- Nested modules, that's hierarchical structuring

Each of them being addresed by the syntax and Dune mechanisms. Collectively,
these mechanisms

This section further details more advanced concepts.

### Shortening Names

Definitions binds names to things, either types, values or modules. In a
restricted perspective available modules only provides means to:

1. Avoid clashes in large sets of names, every defined entity having a unique identifier
1. Avoid using unique identifiers everywhere, it would be cumbersome

The latter point is the subject of this section

#### All Local Names are Short

When writing a definition, using `let`, `type` or `module`, a local name is
declared. This is the only one that needs to and can be used inside the module where it
lies. The “fully qualified” identifier isn't needed or available.

Let's take a look at extract of the source code of the `Seq` module (with minor simplification). The file is named `seq.ml`

```ocaml
type 'a node =
  | Nil
  | Cons of 'a * 'a t
and 'a t = unit -> 'a node

let rec append seq1 seq2 () =
  match seq1 () with
  | Nil -> seq2 ()
  | Cons (x, next) -> Cons (x, append next seq2)

let rec flat_map f seq () = match seq () with
  | Nil -> Nil
  | Cons (x, next) ->
    append (f x) (flat_map f next) ()

```

The names defined are the following:
* `node`
* `Nil`
* `Cons`
* `t`
* `append`
* `flat_map`

From `utop` these declarations can be accessed by prefixing them by either `Seq.` or `Stdlib.Seq.` Previous section explained the `Seq` part 

This is almost always fine. Expect when it's not. Imagine the following file:
```ocaml
module Azimuth = struct
  type t = int
  module Cardinal : sig
    type t = North | East | South | West
    val _of : t -> Azimuth.t
  end = struct
    type t = North | East | South | West
    let _of = function
      | North -> 0
      | East -> 90
      | South -> 180
      | West -> 270
  end
end
```
Here we'd like `Azimuth.Cardinal._of` to have type `Azimuth.Cardinal.t ->
Azimuth.t`. Unfortunately, if we omit the type type annotation `: A.t` the
infered type is `Azimuth.Cardinal.t -> int` and leaving it is a syntax error.

To resolve this situation a local alias must be used. Here is how it looks like:
```ocaml
module Azimuth = struct
  type t = int
  module Cardinal : sig
    type cardinal_t := t
    type t = North | East | South | West
    val _of : t -> cardinal_t
  end = struct
    type t = North | East | South | West
    let _of = function
      | North -> 0
      | East -> 90
      | South -> 180
      | West -> 270
  end
end

```

### Extending an Existing Module

On occasions, one may feel a couple of functions are missing in a module used by
the project but not developed inside the project. Using OCaml module constructs,
it is possible to build an _extension_ of such a module. It provides the same
interface as the initial module, except it also have the added functions.

Here is an example adding functions `drop` and `take` to the standard library
module `List`:
```ocaml
module List : sig
    include module type of Stdlib.List
    val drop : int -> 'a list -> 'a list
    val take : int -> 'a list -> 'a list
end = struct
    include Stdlib.List
    let rec drop n = function _ :: u when n > 0 -> drop (n - 1) u | u -> u
    let rec take n = function x :: u when n > 0 -> x :: take (n - 1) u | _ -> []
end
```

Naming this module `List` will result in having the original `List` module being
masked by the new one. The original `List`, provided by the standard library,
remains available as `Stdlib.List`. The `include` statement should be understood
as coping and pasting the whole original code at its location.

The interface part of this code isn't really necessary. Had it been omitted, the
infered interface would have been the same. It's only there to illustrate the
`module type of` statement which allows copying and pasting a module signature.

This pattern also allows to embed a whole module inside another one. Here is how
to supplement the `String` module with an instance of the `Map` functor with
`string` keys.
```ocaml
module String = struct
  include Stdlib.String
  module Map = Map.Make(Stdlib.String)
end
```

### Overloading an Existing Module

Using the pattern described in the previous subsection, it is also possible to
make it look like if a function is replaced or modified.

```ocaml
module List = struct
  include Stdlib.List
  let fold_right f x u = Stdlib.List.fold_right f u x
  let sort cmp u =
  let module Array = struct
    include Stdlib.Array
    let sort cmp a = Stdlib.Array.sort cmp a; a
  end in
  let open Array in
  u |> of_list |> sort cmp |> to_list
end
```

Here, the replacement of `List` provides:
- A `List.fold_right` function which does the same as `Stdlib.List.fold_right`
  but has the same signature as `List.fold_left`
- A `List.sort` which is internally using `Array.sort`

### Exposing a Flattening a Module H



### Discussion

Although this pattern bears some ressemblence with object-oriented inheritence
it is fairly different:
- It is possible to merge several modules into one
- It is possible to 
