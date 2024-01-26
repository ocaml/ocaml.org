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

Create files named `exeter.ml` and `exeter.ml` with the following contents:

**`exeter.ml`**
```ocaml
type measure_unit = Metric | Imperial
type length = unit * i
type meter = int
type date = { day : int; month : int; year : int }
```

**`exeter.mli`**
```ocaml
type unit = Metric | Imperial
type meter
type date = private { day : int; month : int; year : int }
```

But modules often define new types. Let's define a record type that
would represent a date:

```ocaml
type date = { day : int; month : int; year : int }
```

There are four options when it comes to writing the `.mli` file:

1. The type is completely omitted from the signature. In that case, the type is private. It can't be used from outside the module.
2. The type definition is copy-pasted into the signature. In that case, the type is public. It can be used.
3. The type is made abstract: only its name is given.
4. The record fields are made read-only: `type date = private { ... }`.

Case 3 would look like this:

```ocaml
type date
```

Now, users of the module can manipulate objects of type `date`, but they can't
access the record fields directly. They must use the functions that the module
provides. Let's assume the module provides three functions: one for creating a
date, one for computing the difference between two dates, and one that returns
the date in years:

<!-- $MDX skip -->
```ocaml
type date

val create : ?days:int -> ?months:int -> ?years:int -> unit -> date

val sub : date -> date -> date

val years : date -> float
```

The point is that only `create` and `sub` can be used to create `date` records.
Therefore, it is not possible for the user to create ill-formed
records. Actually, our implementation uses a record, but we could change it and
be sure that it will not break any code relying on this module! This makes
a lot of sense in a library because subsequent versions of it can
continue to expose the same interface while internally changing the
implementation, including data structures.

Case 4

## Submodules

### Submodule Implementation

We saw that one `fairbanks.ml` file results automatically in the module
implementation named `Exeter`. Its module signature is automatically derived
and is the broadest possible, or it can be restricted by writing an `fairbanks.mli`
file.

That said, a given module can also be defined explicitly from within a file.
That makes it a submodule of the current module. Let's consider this
`fairbanks.ml` file:

```ocaml
module Hello = struct
  let message = "Hello"
  let hello () = print_endline message
end

let goodbye () = print_endline "Goodbye"

let hello_goodbye () =
  Hello.hello ();
  goodbye ()
```

From another file, we now have two levels of modules. We can
write:

<!-- $MDX skip -->
```ocaml
let () =
  Exeter.Hello.hello ();
  Exeter.goodbye ()
```

### Submodule Interface

We can also restrict the interface of a submodule. It is called a module
type. Let's do it in our `fairbanks.ml` file:

```ocaml
module Hello : sig
 val hello : unit -> unit
end = struct
  let message = "Hello"
  let hello () = print_endline message
end

(* At this point, Hello.message is not accessible anymore. *)

let goodbye () = print_endline "Goodbye"

let hello_goodbye () =
  Hello.hello ();
  goodbye ()
```

The definition of the `Hello` module above is the equivalent of a
`hello.mli`, `hello.ml` pair of files. Writing all of that in one block of code
is not elegant, so in general, we prefer to define the module signature
separately:

<!-- $MDX skip -->
```ocaml
module type Hello_type = sig
 val hello : unit -> unit
end

module Hello : Hello_type = struct
  ...
end
```

`Hello_type` is a named module type and can be reused to define other module
interfaces.

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
