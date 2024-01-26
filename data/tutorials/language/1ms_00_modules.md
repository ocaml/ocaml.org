---
id: modules
title: Modules
short_title: Modules
description: >
  Modules are collections of definitions. This is the basic means to organise OCaml software.
category: "Module System"
---

## Introduction

In this tutorial, we look at how to use and define modules.

Modules are collections of definitions grouped together. This is the basic means to organise OCaml software. Separate concerns can and should be isolated into separate modules.

**Prerequisites**: [Values and Functions](/docs/values-and-functions) and [Basic Data Types and Pattern Matching](/docs/basic-data-types)

## Basic Usage

### File-Based Modules

In OCaml, every piece of code is wrapped into a module. Optionally, a module
itself can be a submodule of another module, pretty much like directories in a
file system.

When you write a program using two files named `athens.ml` and `berlin.ml`,
each automatically defines a module named `Athens` and `Berlin`, which provides
whatever you put into the files.

Here is the code in the file `athens.ml`:
<!-- $MDX file=examples/athens.ml -->
```ocaml
let hello () = print_endline "Hello from Athens"
```

This is what is in `berlin.ml`:
<!-- $MDX file=examples/berlin.ml -->
```ocaml
let () = Athens.hello ()
```

To compile them using [Dune](https://dune.build/), at least two
configuration files are required:
* The `dune-project` file contains project-wide configuration data.
  Here's a very minimal one:
  ```lisp
   (lang dune 3.7)
  ```
* The `dune` file contains actual build directives. A project may have several
  `dune` files, one per folder containing things to build. This single line is
  sufficient in this example:
  ```lisp
  (executable (name berlin))
  ```

Here is a possible way to create those files, build the source, and run the
executable:
<!-- $MDX dir=examples -->
```bash
$ echo "(lang dune 3.7)" > dune-project

$ echo "(executable (name berlin))" > dune

$ opan exec -- dune build

$ opam exec -- dune exec ./berlin.exe
Hello
```

Actually, `dune build` is optional. Running `dune exec` would have triggered the
compilation. Note that in the `dune exec` command, the parameter `./berlin.exe`
is not a file path. This command means “execute the content of the file
`./berlin.ml`.” However, the executable file is stored and named differently.

In a project, it is preferable to create the `dune` configuration files and
directory structure using the `dune init project` command.

### Naming and Scoping

In `berlin.ml`, we used `Athens.hello` to refer to `hello` from `athens.ml`.
Generally, to access something from a module, use the module's name (which
always starts with a capital letter: `Athens`) followed by a dot and the
thing you want to use (`hello`). It may be a value, a type constructor, or
anything the module provides.

If you are using a module heavily, you can directly access its contents. To do
this, use the `open` directive. In our example, `berlin.ml` could have been
written:
<!-- $MDX skip -->
```ocaml
open Athens
let () = hello ()
```

Using `open` is optional. Usually, we don't open the module `List` because it
provides names other modules also provide, such as `Array` or `Option`. Other
modules like `Printf` provide names that aren't subject to conflicts, such as
`printf`. Placing `open Printf` at the beginning of the file avoids writing
`Printf.printf` all over the place.
```ocaml
open Printf
let data = ["a"; "beautiful"; "day"]
let () = List.iter (printf "%s\n") data
```

 The standard library is a module called `Stdlib` where modules `List`,
 `Option`, `Either`, and others are [submodules](#submodules). Implicitly, all
 OCaml begins with `open Stdlib`. That avoids writing `Stdlib.List.map`,
 `Stdlib.Array`, or using `Stdlib.` anywhere.

There are also two means to open modules locally:
```ocaml
# let list_sum_sq m =
    let open List in
    init m Fun.id |> map (fun i -> i * i) |> fold_left ( + ) 0;;
val list_sum_sq : int -> int = <fun>

# let array_sum_sq m =
    Array.(init m Fun.id |> map (fun i -> i * i) |> fold_left ( + ) 0);;
val array_sum_sq : int -> int = <fun>
```

## Interfaces and Implementations

By default, anything defined in a module is accessible from other modules.
Values, functions, types, or submodules, everything is public. This can be
restricted. That allows distinguishing content provided to other modules from
internal use content. What is internal is kept private and not available from
other modules.

For this, we must distinguish:
- Implementation, which is a module's actual content.
- Interface, which is a module's public content list.

An `.ml` file contains a module implementation. By default, without an explicitly
defined interface, an implementation has a default interface where everything is
public.

Copy the `athens.ml` file into `cairo.ml` and change it with this contents:
<!-- $MDX file=examples/cairo.ml -->
```ocaml
let message = "Hello from Cairo"
let hello () = print_endline message
```

As it is, `Cairo` has the following interface:
<!-- $MDX skip -->
```ocaml
val message : string
val hello : unit -> unit
```

Explicitly defining a module interface allows restricting the default one. It
acts as a mask over the module's implementation. The `cairo.ml` file defines
`Cairo`'s implementation. Adding a `cairo.mli` file defines `Cairo`'s interface.
Filenames without extensions must be the same.

To turn `message` into a private definition, don't list it in the `cairo.mli` file:
<!-- $MDX file=examples/cairo.mli -->
```ocaml
val hello : unit -> unit
(** [hello ()] displays a greeting message. *)
```

**Note**: The double asterisk at the beginning of the comment indicates a
comment meant for API documentation tools, such as
[`odoc`](https://github.com/ocaml/odoc). It is a good habit to document `.mli`
files using the format supported by this tool.

The file `delhi.ml` defines the program calling `Cairo`:

<!-- $MDX file=examples/delhi.ml -->
```ocaml
let () = Cairo.hello ()
```

Update the `dune` file to allow the compilation of this example aside from the
previous one.

<!-- $MDX dir=examples -->
```bash
<<<<<<< HEAD
$ echo "(executables (names bmodule bmodule2))" > dune
$ opam exec -- dune build
$ opam exec -- dune exec ./bmodule.exe
Hello
$ opam exec -- dune exec ./bmodule2.exe
Hello 2
=======
$ echo "(executables (names berlin delhi))" > dune

$ dune build

$ dune exec ./berlin.exe
Hello from Athens

$ dune exec ./delhi.exe
Hello from Cairo
>>>>>>> 5196e1c0 (Refresh modules.md text)
```

You can check that `Cairo.message` is not public by attempting to compile a `delhi.ml` file containing:
```ocaml
let () = print_endline Cairo.message
```

This triggers a compilation error.

## Abstract and Read-Only Types

Function and value definitions are either public or private. That also applies
to type definitions, but there are two more cases.

Create files named `exeter.mli` and `exeter.ml` with the following contents:

**Interface: `exeter.mli`**

```ocaml

type aleph = Ada | Alan | Alonzo

type gimel
val gimel_of_bool : bool -> gimel
val gimel_flip : gimel -> gimel
val gimel_to_string : gimel -> string

type dalet = private Dennis of int | Donald of string | Dorothy
val dalet_of : (int, string) Either.t option -> dalet
```

**Implementation: `exeter.ml`**

```ocaml
type aleph = Ada | Alan | Alonzo

type bet = bool

type gimel = Christos | Christine

let gimel_of_bool b = if (b : bet) then Christos else Christine
let gimel_flip = function Christos -> Christine | Christine -> Christos
let gimel_to_string x = "Christ" ^ match x with Christos -> "os" | _ -> "ine"

type dalet = Dennis of int | Donald of string | Dorothy
let dalet_of = function
  | None -> Dorothy
  | Some (Either.Left x) -> Dennis x
  | Some (Either.Right x) -> Donald x
```


Update file `dune`:
```lisp
(executables (names berlin delhi) (modules berlin delhi))
(library (name exeter) (modules exeter) (modes byte))
```

Run the `dune utop` command, it triggers `Exeter`'s compilation, launches `utop` and loads `Exeter`.
```ocaml
# open Exeter;;


```

Type `aleph` is public. Values can be created, such as `x` or read
```ocaml
# #show bet;;
Unknown element.
```

Type `bet` is private, it is not available outside of the implementation where it is defined, here `Exeter`.
```ocaml
# #show gimel;;
type gimel

# Christos;;
Error: Unbound constructor Christos

# #show_val gimel_of_bool;;
val gimel_of_bool : bool -> gimel

# true |> gimel_of_bool |> gimel_to_string;;
- : string = "Christos"

# true |> gimel_of_bool |> gimel_flip |> gimel_to_string;;
- : string = "Christine"
```

Type `gimel` is _abstract_. Values are available, but only as function results or arguments. Only the provided functions `gimel_of_bool`, `gimel_flip`, and ` gimel_to_string` and polymorphic functions can receive or return `gimel` values.
```ocaml
#show dalet;;
type dalet = private Dennis of int | Donald of string | Dorothy

# Dennis 42;;
Error: Cannot create values of the private type Exeter.dalet

# dalet_of (Some (Either.Left 10));;
- : dalet = Dennis 10

# let dalet_to_string = function
  | None -> "Dorothy"
  | Some (Either.Left _) -> "Dennis"
  | Some (Either.Right _) -> "Donald";;
val dalet_to_string : ('a, 'b) Either.t option -> string = <fun>
```

 The type `dalet` is _read-only_. Pattern matching is possible, but values can only be constructed by the provided functions, here `dalet_to_string`.

Abstract and read-only types can be either variants, as shown in this section, records, or aliases. It is possible to access a read-only record field's value, but creating such a record requires using a provided function.

## Submodules

### Submodule Implementation

A module can be defined inside another module. That makes it a _submodule_.
Let's consider the files `florence.ml` and `glasgow.ml`

**`florence.ml`**
```ocaml
module Hello = struct
  let message = "Hello from Florence"
  let print () = print_endline message
end

let print_goodbye () = print_endline "Goodbye"
```

**`glasgow.ml`**
```ocaml
let () =
  Florence.Hello.print ();
  Florence.print_goodbye ()
```

The module `Hello` is a submodule of module `Florence`.

### Submodule Interface

We can also restrict the interface of a submodule. Here is a second version of the `florence.ml` file:
```ocaml
module Hello : sig
 val print : unit -> unit
end = struct
  let message = "Hello"
  let print () = print_endline message
end

let print_goodbye () = print_endline "Goodbye"
```

The first version made `Florence.Hello.message` public. In this version it can't be accessed from `glasgow.ml`.

### Interfaces are Types

The role played by interfaces to implementations is akin to the role played by types to values. Here is third possible way to write file `florence.ml`:
```ocaml
module type HelloType = sig
  val hello : unit -> unit
end

module Hello : HelloType = struct
  let message = "Hello"
  let print () = print_endline message
end

let print_goodbye () = print_endline "Goodbye"
```

The interface used previously for `Florence.Hello` is turned into a `module type` called `HelloType`. Later, when defining `Florence.Hello`, it is annotated with `HelloType` as a value could be. The `HelloType` acts as a type alias.

This allows writing once interfaces shared by several modules. An implementation satisfies any module type listing some of its contents. This implies a module may have several types and there are subtyping relationship between module types.

## Module Manipulation

### Displaying a Module's Interface

You can use the OCaml toplevel to see the contents of an existing
module, such as `Unit`:

```ocaml
# #show Unit;;
module Unit :
  sig
    type t = unit = ()
    val equal : t -> t -> bool
    val compare : t -> t -> int
    val to_string : t -> string
  end
```

There is online documentation for each library, for instance, [`Unit`](/api/Unit.html).

The OCaml compiler tool chain can be used to dump a `.ml` file default interface.
```shell
$ ocamlc -c -i cairo.ml
val message : string
val hello : unit -> unit
```

### Module Inclusion

Let's say we feel that a function is missing from the standard `List` module,
but we really want it as if it were part of it. In an `extlib.ml` file, we
can achieve this effect by using the `include` directive:

```ocaml
module List = struct
  include Stdlib.List
  let uncons = function
    | [] -> None
    | hd :: tl -> Some (hd, tl)
end
```

It creates a module `Extlib.List` that has everything the standard `List`
module has, plus a new `uncons` function. In order to override the default `List` module from another `.ml` file, we merely need to add `open Extlib` at the beginning.

## Stateful Modules

A module may have an internal state. This is the case standard library `Random` module. The functions `Random.get_state` and `Random.set_state` provide read and write access to the internal state, which is nameless and has an abstract type.
```ocaml
# let s = Random.get_state ();;
val s : Random.State.t = <abstr>

# Random.bits ();;
- : int = 89809344

# Random.bits ();;
- : int = 994326685

# Random.set_state s;;
- : unit = ()

# Random.bits ();;
- : int = 89809344
```

Values returned by `Random.bits` will differ in your setup, but the first and third calls return the same results, showing that the internal state was reset.

## Conclusion

In OCaml, modules are the basic means of organising software. To sum up, a module is a collection of definitions wrapped under a name. These definitions can be submodules, which allows the creation of hierarchies of modules. Top-level modules must be files and are the units of compilation. Every module has an interface, which is the list of definitions a module exposes. By default, a module's interface exposes all its definitions, but this can be restricted using the interface syntax.

Going further, here are the other means to handle OCaml software components:
- Functors, which act like functions from modules to modules
- Libraries, which are compiled modules bundled together
- Packages, which are installation and distribution units
