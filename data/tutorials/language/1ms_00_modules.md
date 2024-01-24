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

When you write a program, let's say using the two files `athens.ml` and
`berlin.ml`, each automatically defines a module named
`Athens` and `Berlin`, which provides whatever you put into the
files.

Here is the code that we have in our file `athens.ml`:
<!-- $MDX file=examples/athens.ml -->
```ocaml
let hello () = print_endline "Hello from Athens"
```

This is what we have in `berlin.ml`:
<!-- $MDX file=examples/berlin.ml -->
```ocaml
let () = Athens.hello ()
```

In order to compile them using the [Dune](https://dune.build/) build system, at least two configuration files are required:

* The `dune-project` file contains project-wide configuration data.
  Here's a very minimal one:
  ```lisp
   (lang dune 3.7)
  ```
* The `dune` file contains actual build directives. A project may have several
  of them, depending on the organisation of the sources. This is sufficient for
  our example:
  ```lisp
  (executable (name berlin))
  ```

Here is how to create the configuration files, build the source, and run the
executable:
<!-- $MDX dir=examples -->
```bash
$ echo "(lang dune 3.7)" > dune-project
$ echo "(executable (name berlin))" > dune
$ opam exec -- une build
$ opam exec -- dune exec ./berlin.exe
Hello
```

Actually, `dune build` is optional. Simply running `dune exec` would have
triggered the compilation. Beware that in the `dune exec` command, as the parameter
`./berlin.exe` is not a file path. This command means “execute the content of
the file `./berlin.ml`.” However, the actual executable file is stored and
named differently.

In a real-world project, it is preferable to start by creating the `dune`
configuration files and directory structure using the `dune init project`
command.

### Naming and Scoping

Now we have an executable that prints `Hello from Athens`. If you want to
access anything from a given module, use the name of the module (always
starting with a capital letter) followed by a dot and the thing you want to use.
It may be a value, a type constructor, or anything else that a given module can
provide.

Libraries, starting with the standard library, provide collections of modules.
For example, `List.iter` designates the `iter` function from the `List` module.

If you are using a given module heavily, you may want to make its contents
directly accessible. For this, we use the `open` directive. In our example,
`berlin.ml` could have been written:

<!-- $MDX skip -->
```ocaml
open Athens
let () = hello ()
```

Using `open` or not is a matter of personal taste. Some modules provide names
that are used in many other modules. This is the case of the `List` module, for
instance. Usually, we don't do `open List`. Other modules like `Printf` provide
names that normally aren't subject to conflicts, such as `printf`. In order to
avoid writing `Printf.printf` all over the place, it often makes sense to place
one `open Printf` at the beginning of the file:

```ocaml
open Printf
let data = ["a"; "beautiful"; "day"]
let () = List.iter (printf "%s\n") data
```

 The standard library is a module called `Stdlib` where modules `List`, `Option`, `Either` and others are [submodules](#submodules). Implicitly, all OCaml begins with `open Stdlib` which avoids writing `Stdlib.List.map`, `Stdlib.Array` or using `Stdlib.` anywhere.

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

## Interfaces and Signatures

A module can provide various kinds of things to programs or libraries: functions, types, submodules. If nothing special is done,
everything that's defined in a module will be accessible from the outside. That's
often fine in small personal programs, but there are many situations where it
is better that a module only provides what it is meant to provide, not any of
the auxiliary functions and types that are used internally.

For this, we have to define a module interface, which will act as a mask over
the module's implementation. Just like a module derives from a `.ml` file, the
corresponding module interface or signature derives from a `.mli` file. It
contains a list of values with their type. Let's copy and change our `athens.ml` file
into something called `cairo.ml`:

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

Let's assume that accessing the `message` value directly is none of the other
modules' business; we want it to be a private definition. We can hide it by
defining a restricted interface. This is our `cairo.mli` file:

<!-- $MDX file=examples/cairo.mli -->
```ocaml
val hello : unit -> unit
(** Displays a greeting message. *)
```

Note the double asterisk at the beginning of the comment. It is a good habit
to document `.mli` files using the format supported by
[ocamldoc](/releases/4.14/htmlman/ocamldoc.html)
<!-- FIXME: Refer to odoc -->

The `Cairo` calling program is defined in file `delhi.ml`:

<!-- $MDX file=examples/delhi.ml -->
```ocaml
let () = Cairo.hello ()
```

The `.mli` files must be compiled before the matching `.ml` files. This is done
automatically by Dune. We update the `dune` file to allow the compilation
of this example aside from the previous one.

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

## Abstract Types

What about type definitions? We saw that values such as functions can be
exported by placing their name and their type in an `.mli` file, e.g.:

<!-- $MDX skip -->
```ocaml
val hello : unit -> unit
```

But modules often define new types. Let's define a record type that
would represent a date:

```ocaml
type date = {day : int; month : int; year : int}
```

There are four options when it comes to writing the `.mli` file:

1. The type is completely omitted from the signature.
2. The type definition is copy-pasted into the signature.
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

## Submodules

### Submodule Implementation

We saw that one `exeter.ml` file results automatically in the module
implementation named `Exeter`. Its module signature is automatically derived
and is the broadest possible, or it can be restricted by writing an `exeter.mli`
file.

That said, a given module can also be defined explicitly from within a file.
That makes it a submodule of the current module. Let's consider this
`exeter.ml` file:

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
type. Let's do it in our `exeter.ml` file:

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
