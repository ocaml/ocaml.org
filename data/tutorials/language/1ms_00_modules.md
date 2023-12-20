---
id : modules
title: Modules
short_title: Modules
description: >
  Learn about OCaml modules and how they can be used to cleanly separate distinct parts of your program
category: "Module System"
---

## Introduction

Here are the goals of this tutorial
- Learn how to use modules
- Learn how to define modules

Modules are collections of definitions grouped in a unit. This is the basic means to organize OCaml software. Separate concerns can and should be isolated into separate modules.

**Prerequisites**: [Values and Functions](/docs/values-and-functions) and [Basic Data Types and Pattern Matching](/docs/basic-data-types)

## Basic Usage

### File-Based Modules

In OCaml, every piece of code is wrapped into a module. Optionally, a module
itself can be a submodule of another module, pretty much like directories in a
file system.

When you write a program, let's say using the two files `amodule.ml` and
`bmodule.ml`, each automatically defines a module named
`Amodule` and a module named `Bmodule`, which provides whatever you put into the
files.

Here is the code that we have in our file `amodule.ml`:
<!-- $MDX file=examples/amodule.ml -->
```ocaml
let hello () = print_endline "Hello"
```

This is what we have in `bmodule.ml`:
<!-- $MDX file=examples/bmodule.ml -->
```ocaml
let () = Amodule.hello ()
```

In order to compile them using the [Dune](https://dune.build/) build system, at least two configuration files are required:

* The `dune-project` file, which contains project-wide configuration data.
  Here's a very minimal one:
  ```lisp
   (lang dune 3.7)
  ```
* The `dune` file, which contains actual build directives. A project may have several
  of them, depending on the organisation of the sources. This is sufficient for
  our example:
  ```lisp
  (executable (name bmodule))
  ```

Here is how to create the configuration files, build the source, and run the
executable:
<!-- $MDX dir=examples -->
```bash
$ echo "(lang dune 3.7)" > dune-project
$ echo "(executable (name bmodule))" > dune
$ opam exec -- dune build
$ opam exec -- dune exec ./bmodule.exe
Hello
```

Actually, `dune build` is optional. Simply running `dune exec` would have
triggered the compilation. Note that in the `dune exec` command the argument
`./bmodule.exe` is not a file path. This command means “execute the content of
the file `./bmodule.ml`.” However, the actual executable file is stored and
named differently.

In a real-world project, it is preferable to start by creating the `dune`
configuration files and directory structure using the `dune init project`
command.

### Naming and Scoping

Now we have an executable that prints `Hello`. If you want to
access anything from a given module, use the name of the module (always
starting with a capital letter) followed by a dot and the thing you want to use.
It may be a value, a type constructor, or anything else that a given module can
provide.

Libraries, starting with the standard library, provide collections of modules.
For example, `List.iter` designates the `iter` function from the `List` module.

If you are using a given module heavily, you may want to make its contents
directly accessible. For this, we use the `open` directive. In our example,
`bmodule.ml` could have been written:

<!-- $MDX skip -->
```ocaml
open Amodule
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

There are also local `open`s:

```ocaml
# let sum_sq m =
    let open List in
    init m Fun.id |> map (fun i -> i * i) |> fold_left ( + ) 0;;
val sum_sq : int -> int = <fun>

# let sym_sq' m =
    Array.(init m Fun.id |> map (fun i -> i * i) |> fold_left ( + ) 0);;
val sum_sq' : int -> int = <fun>

```

## Interfaces and Signatures

A module can provide a certain number of things (functions, types, submodules,
etc.) to the rest of the program using it. If nothing special is done,
everything that's defined in a module will be accessible from the outside. That's
often fine in small personal programs, but there are many situations where it
is better that a module only provides what it is meant to provide, not any of
the auxiliary functions and types that are used internally.

For this, we have to define a module interface, which will act as a mask over
the module's implementation. Just like a module derives from a `.ml` file, the
corresponding module interface or signature derives from a `.mli` file. It
contains a list of values with their type. Let's rewrite our `amodule.ml` file
to something called `amodule2.ml`:

<!-- $MDX file=examples/amodule2.ml -->
```ocaml
let message = "Hello 2"
let hello () = print_endline message
```

As it is, `Amodule2` has the following interface:

<!-- $MDX skip -->
```ocaml
val message : string
val hello : unit -> unit
```

Let's assume that accessing the `message` value directly is none of the other
modules' business; we want it to be a private definition. We can hide it by
defining a restricted interface. This is our `amodule2.mli` file:

<!-- $MDX file=examples/amodule2.mli -->
```ocaml
val hello : unit -> unit
(** Displays a greeting message. *)
```

Note the double asterisk at the beginning of the comment. It is a good habit
to document `.mli` files using the format supported by
[ocamldoc](/releases/4.14/htmlman/ocamldoc.html)

The corresponding module `Bmodule2` is defined in file `bmodule2.ml`:

<!-- $MDX file=examples/bmodule2.ml -->
```ocaml
let () = Amodule2.hello ()
```

The .`mli` files must be compiled before the matching `.ml` files. This is done
automatically by Dune. We update the `dune` file to allow the compilation
of this example aside from the previous one.

<!-- $MDX dir=examples -->
```bash
$ echo "(executables (names bmodule bmodule2))" > dune
$ opam exec -- dune build
$ opam exec -- dune exec ./bmodule.exe
Hello
$ opam exec -- dune exec ./bmodule2.exe
Hello 2
```

## Abstract Types

What about type definitions? We saw that values such as functions can be
exported by placing their name and their type in an `.mli` file, e.g.:

<!-- $MDX skip -->
```ocaml
val hello : unit -> unit
```

But modules often define new types. Let's define a simple record type that
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

We saw that one `example.ml` file results automatically in the module
implementation named `Example`. Its module signature is automatically derived
and is the broadest possible, or it can be restricted by writing an `example.mli`
file.

That said, a given module can also be defined explicitly from within a file.
That makes it a submodule of the current module. Let's consider this
`example.ml` file:

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

From another file, it is clear that we now have two levels of modules. We can
write:

<!-- $MDX skip -->
```ocaml
let () =
  Example.Hello.hello ();
  Example.goodbye ()
```

### Submodule Interface

We can also restrict the interface of a given submodule. It is called a module
type. Let's do it in our `example.ml` file:

```ocaml
module Hello : sig
 val hello : unit -> unit
end
=
struct
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
`hello.mli`/`hello.ml` pair of files. Writing all of that in one block of code
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

## Practical Manipulation of Modules

### Displaying the Interface of a Module

You can use the OCaml toplevel to visualise the contents of an existing
module, such as `Fun`:

```ocaml
# #show Fun;;
module Fun :
  sig
    external id : 'a -> 'a = "%identity"
    val const : 'a -> 'b -> 'a
    val flip : ('a -> 'b -> 'c) -> 'b -> 'a -> 'c
    val negate : ('a -> bool) -> 'a -> bool
    val protect : finally:(unit -> unit) -> (unit -> 'a) -> 'a
    exception Finally_raised of exn
  end
```

There is online documentation for each library, for instance [`Fun`](/api/Fun.html)

### Module Inclusion

Let's say we feel that a function is missing from the standard `List` module,
but we really want it as if it were part of it. In an `extlib.ml` file, we
can achieve this effect by using the `include` directive:

```ocaml
module List = struct
  include List
  let uncons = function
    | [] -> None
    | hd :: tl -> Some (hd, tl)
end
```

It creates a module `Extlib.List` that has everything the standard `List`
module has, plus a new `uncons` function. In order to override the default `List` module from another `.ml` file, we merely need to add `open Extlib` at the beginning.

## Conclusion

In OCaml, modules are the basic means of organizing software. To sum up, a module is a collection of definitions wrapped under a name. These definitions can be submodules, which allows the creation of hierarchies of modules. Top-level modules must be files and are the units of compilation. Every module has an interface, which is the list of what a module exposes. By default, a module's interface exposes all its definitions, but this can be restricted using the interface syntax.

Going further, here are the other means to handle OCaml software components:
- Functors, which act like functions from modules to modules
- Libraries, which are compiled modules bundled together into archives
- Packages, which are installation and distribution units
