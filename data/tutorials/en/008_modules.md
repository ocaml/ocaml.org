---
title: Modules
description: >
  Learn about OCaml modules and how they can be used to cleanly separate distinct parts of your program
users:
  - beginner
  - intermediate
tags: [ "language" ]
date: 2021-05-27T21:07:30-00:00
---

## Basic usage

In OCaml, every piece of code is wrapped into a module. Optionally, a module
itself can be a submodule of another module, pretty much like directories in a
file system - but we don't do this very often.

When you write a program let's say using two files `amodule.ml` and
`bmodule.ml`, each of these files automatically defines a module named
`Amodule` and a module named `Bmodule` that provide whatever you put into the
files.

Here is the code that we have in our file `amodule.ml`:

<!-- $MDX file=examples/amodule.ml -->
```ocaml
let hello () = print_endline "Hello"
```

And here is what we have in `bmodule.ml`:

<!-- $MDX file=examples/bmodule.ml -->
```ocaml
let () = Amodule.hello ()
```

We can compile the files in one command:

<!-- $MDX dir=examples -->
```sh
$ ocamlopt -o hello amodule.ml bmodule.ml
```

Or, as a build system might do, one by one:

<!-- $MDX dir=examples -->
```sh
$ ocamlopt -c amodule.ml
$ ocamlopt -c bmodule.ml
$ ocamlopt -o hello amodule.cmx bmodule.cmx
```

Now we have an executable that prints "Hello". As you can see, if you want to
access anything from a given module, use the name of the module (always
starting with a capital) followed by a dot and the thing that you want to use.
It may be a value, a type constructor, or anything else that a given module can
provide.

Libraries, starting with the standard library, provide collections of modules.
for example, `List.iter` designates the `iter` function from the `List` module.

If you are using a given module heavily, you may want to make its contents
directly accessible. For this, we use the `open` directive. In our example,
`bmodule.ml` could have been written:

<!-- $MDX skip -->
```ocaml
open Amodule
let () = hello ()
```

Using `open` or not is a matter of personal taste. Some modules provide names
that are used in many other modules. This is the case of the `List` module for
instance. Usually, we don't do `open List`. Other modules like `Printf` provide
names that are normally not subject to conflicts, such as `printf`. In order to
avoid writing `Printf.printf` all over the place, it often makes sense to place
one `open Printf` at the beginning of the file:

```ocaml
open Printf
let data = ["a"; "beautiful"; "day"]
let () = List.iter (printf "%s\n") data
```

There are also local `open`s:

```ocaml
# let map_3d_matrix f m =
  let open Array in
    map (map (map f)) m;;
val map_3d_matrix :
  ('a -> 'b) -> 'a array array array -> 'b array array array = <fun>
# let map_3d_matrix' f =
  Array.(map (map (map f)));;
val map_3d_matrix' :
  ('a -> 'b) -> 'a array array array -> 'b array array array = <fun>
```

## Interfaces and signatures

A module can provide a certain number of things (functions, types, submodules,
...) to the rest of the program that is using it. If nothing special is done,
everything which is defined in a module will be accessible from the outside. That's
often fine in small personal programs, but there are many situations where it
is better that a module only provides what it is meant to provide, not any of
the auxiliary functions and types that are used internally.

For this, we have to define a module interface, which will act as a mask over
the module's implementation. Just like a module derives from a .ml file, the
corresponding module interface or signature derives from an .mli file. It
contains a list of values with their type. Let's rewrite our `amodule.ml` file
to something called `amodule2.ml`:

<!-- $MDX file=examples/amodule2.ml -->
```ocaml
let hello () = print_endline "Hello"
```

As it is, `Amodule` has the following interface:

```ocaml
val message : string

val hello : unit -> unit
```
```mdx-error
Line 1, characters 1-21:
Error: Value declarations are only allowed in signatures
```

Let's assume that accessing the `message` value directly is none of the others
modules' business. We want to hide it by defining a restricted interface. This
is our `amodule2.mli` file:

<!-- $MDX file=examples/amodule2.mli -->
```ocaml
val hello : unit -> unit
(** Displays a greeting message. *)
```

(note the double asterisk at the beginning of the comment - it is a good habit
to document .mli files using the format supported by
[ocamldoc](/releases/4.13.0/htmlman/ocamldoc.html))

Such .mli files must be compiled just before the matching .ml files. They are
compiled using `ocamlc`, even if .ml files are compiled to native code using
`ocamlopt`:

<!-- $MDX dir=examples -->
```sh
$ ocamlc -c amodule2.mli
$ ocamlopt -c amodule2.ml
```

## Abstract types

What about type definitions? We saw that values such as functions can be
exported by placing their name and their type in a .mli file, e.g.

<!-- $MDX skip -->
```ocaml
val hello : unit -> unit
```

But modules often define new types. Let's define a simple record type that
would represent a date:

```ocaml
type date = {day : int; month : int; year : int}
```

There are four options when it comes to writing the .mli file:

1. The type is completely omitted from the signature.
1. The type definition is copy-pasted into the signature.
1. The type is made abstract: only its name is given.
1. The record fields are made read-only: `type date = private { ... }`

Case 3 would look like this:

```ocaml
type date
```

Now, users of the module can manipulate objects of type `date`, but they can't
access the record fields directly. They must use the functions that the module
provides. Let's assume the module provides three functions, one for creating a
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
Therefore, it is not possible for the user of the module to create ill-formed
records. Actually, our implementation uses a record, but we could change it and
be sure that it will not break any code that relies on this module! This makes
a lot of sense in a library since subsequent versions of the same library can
continue to expose the same interface, while internally changing the
implementation, including data structures.

## Submodules

###  Submodule implementation

We saw that one `example.ml` file results automatically in one module
implementation named `Example`. Its module signature is automatically derived
and is the broadest possible, or can be restricted by writing an `example.mli`
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

From another file, it is clear that we now have two levels of modules.  We can
write:

<!-- $MDX skip -->
```ocaml
let () =
  Example.Hello.hello ();
  Example.goodbye ()
```

###  Submodule interface

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
is not elegant so, in general, we prefer to define the module signature
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

`Hello_type` is a named module type, and can be reused to define other module
interfaces.

## Practical manipulation of modules

###  Displaying the interface of a module

You can use the `ocaml` toplevel to visualize the contents of an existing
module, such as `List`:

```ocaml
# #show List;;
module List = List
module List :
  sig
    type 'a t = 'a list = [] | (::) of 'a * 'a list
    val length : 'a t -> int
    val compare_lengths : 'a t -> 'b t -> int
    val compare_length_with : 'a t -> int -> int
    val cons : 'a -> 'a t -> 'a t
    val hd : 'a t -> 'a
    val tl : 'a t -> 'a t
    val nth : 'a t -> int -> 'a
    val nth_opt : 'a t -> int -> 'a option
    val rev : 'a t -> 'a t
    val init : int -> (int -> 'a) -> 'a t
    val append : 'a t -> 'a t -> 'a t
    val rev_append : 'a t -> 'a t -> 'a t
    val concat : 'a t t -> 'a t
    val flatten : 'a t t -> 'a t
    val equal : ('a -> 'a -> bool) -> 'a t -> 'a t -> bool
    val compare : ('a -> 'a -> int) -> 'a t -> 'a t -> int
    val iter : ('a -> unit) -> 'a t -> unit
    val iteri : (int -> 'a -> unit) -> 'a t -> unit
    val map : ('a -> 'b) -> 'a t -> 'b t
    val mapi : (int -> 'a -> 'b) -> 'a t -> 'b t
    val rev_map : ('a -> 'b) -> 'a t -> 'b t
    val filter_map : ('a -> 'b option) -> 'a t -> 'b t
    val concat_map : ('a -> 'b t) -> 'a t -> 'b t
    val fold_left_map : ('a -> 'b -> 'a * 'c) -> 'a -> 'b t -> 'a * 'c t
    val fold_left : ('a -> 'b -> 'a) -> 'a -> 'b t -> 'a
    val fold_right : ('a -> 'b -> 'b) -> 'a t -> 'b -> 'b
    val iter2 : ('a -> 'b -> unit) -> 'a t -> 'b t -> unit
    val map2 : ('a -> 'b -> 'c) -> 'a t -> 'b t -> 'c t
    val rev_map2 : ('a -> 'b -> 'c) -> 'a t -> 'b t -> 'c t
    val fold_left2 : ('a -> 'b -> 'c -> 'a) -> 'a -> 'b t -> 'c t -> 'a
    val fold_right2 : ('a -> 'b -> 'c -> 'c) -> 'a t -> 'b t -> 'c -> 'c
    val for_all : ('a -> bool) -> 'a t -> bool
    val exists : ('a -> bool) -> 'a t -> bool
    val for_all2 : ('a -> 'b -> bool) -> 'a t -> 'b t -> bool
    val exists2 : ('a -> 'b -> bool) -> 'a t -> 'b t -> bool
    val mem : 'a -> 'a t -> bool
    val memq : 'a -> 'a t -> bool
    val find : ('a -> bool) -> 'a t -> 'a
    val find_opt : ('a -> bool) -> 'a t -> 'a option
    val find_map : ('a -> 'b option) -> 'a t -> 'b option
    val filter : ('a -> bool) -> 'a t -> 'a t
    val find_all : ('a -> bool) -> 'a t -> 'a t
    val filteri : (int -> 'a -> bool) -> 'a t -> 'a t
    val partition : ('a -> bool) -> 'a t -> 'a t * 'a t
    val partition_map : ('a -> ('b, 'c) Either.t) -> 'a t -> 'b t * 'c t
    val assoc : 'a -> ('a * 'b) t -> 'b
    val assoc_opt : 'a -> ('a * 'b) t -> 'b option
    val assq : 'a -> ('a * 'b) t -> 'b
    val assq_opt : 'a -> ('a * 'b) t -> 'b option
    val mem_assoc : 'a -> ('a * 'b) t -> bool
    val mem_assq : 'a -> ('a * 'b) t -> bool
    val remove_assoc : 'a -> ('a * 'b) t -> ('a * 'b) t
    val remove_assq : 'a -> ('a * 'b) t -> ('a * 'b) t
    val split : ('a * 'b) t -> 'a t * 'b t
    val combine : 'a t -> 'b t -> ('a * 'b) t
    val sort : ('a -> 'a -> int) -> 'a t -> 'a t
    val stable_sort : ('a -> 'a -> int) -> 'a t -> 'a t
    val fast_sort : ('a -> 'a -> int) -> 'a t -> 'a t
    val sort_uniq : ('a -> 'a -> int) -> 'a t -> 'a t
    val merge : ('a -> 'a -> int) -> 'a t -> 'a t -> 'a t
    val to_seq : 'a t -> 'a Seq.t
    val of_seq : 'a Seq.t -> 'a t
  end
```

There is online documentation for each library.

###  Module inclusion

Let's say we feel that a function is missing from the standard `List` module,
but we really want it as if it were part of it. In an `extensions.ml` file, we
can achieve this effect by using the `include` directive:

```ocaml
# module List = struct
  include List
  let rec optmap f = function
    | [] -> []
    | hd :: tl ->
       match f hd with
       | None -> optmap f tl
       | Some x -> x :: optmap f tl
  end;;
module List :
  sig
    type 'a t = 'a list = [] | (::) of 'a * 'a list
    val length : 'a t -> int
    val compare_lengths : 'a t -> 'b t -> int
    val compare_length_with : 'a t -> int -> int
    val cons : 'a -> 'a t -> 'a t
    val hd : 'a t -> 'a
    val tl : 'a t -> 'a t
    val nth : 'a t -> int -> 'a
    val nth_opt : 'a t -> int -> 'a option
    val rev : 'a t -> 'a t
    val init : int -> (int -> 'a) -> 'a t
    val append : 'a t -> 'a t -> 'a t
    val rev_append : 'a t -> 'a t -> 'a t
    val concat : 'a t t -> 'a t
    val flatten : 'a t t -> 'a t
    val equal : ('a -> 'a -> bool) -> 'a t -> 'a t -> bool
    val compare : ('a -> 'a -> int) -> 'a t -> 'a t -> int
    val iter : ('a -> unit) -> 'a t -> unit
    val iteri : (int -> 'a -> unit) -> 'a t -> unit
    val map : ('a -> 'b) -> 'a t -> 'b t
    val mapi : (int -> 'a -> 'b) -> 'a t -> 'b t
    val rev_map : ('a -> 'b) -> 'a t -> 'b t
    val filter_map : ('a -> 'b option) -> 'a t -> 'b t
    val concat_map : ('a -> 'b t) -> 'a t -> 'b t
    val fold_left_map : ('a -> 'b -> 'a * 'c) -> 'a -> 'b t -> 'a * 'c t
    val fold_left : ('a -> 'b -> 'a) -> 'a -> 'b t -> 'a
    val fold_right : ('a -> 'b -> 'b) -> 'a t -> 'b -> 'b
    val iter2 : ('a -> 'b -> unit) -> 'a t -> 'b t -> unit
    val map2 : ('a -> 'b -> 'c) -> 'a t -> 'b t -> 'c t
    val rev_map2 : ('a -> 'b -> 'c) -> 'a t -> 'b t -> 'c t
    val fold_left2 : ('a -> 'b -> 'c -> 'a) -> 'a -> 'b t -> 'c t -> 'a
    val fold_right2 : ('a -> 'b -> 'c -> 'c) -> 'a t -> 'b t -> 'c -> 'c
    val for_all : ('a -> bool) -> 'a t -> bool
    val exists : ('a -> bool) -> 'a t -> bool
    val for_all2 : ('a -> 'b -> bool) -> 'a t -> 'b t -> bool
    val exists2 : ('a -> 'b -> bool) -> 'a t -> 'b t -> bool
    val mem : 'a -> 'a t -> bool
    val memq : 'a -> 'a t -> bool
    val find : ('a -> bool) -> 'a t -> 'a
    val find_opt : ('a -> bool) -> 'a t -> 'a option
    val find_map : ('a -> 'b option) -> 'a t -> 'b option
    val filter : ('a -> bool) -> 'a t -> 'a t
    val find_all : ('a -> bool) -> 'a t -> 'a t
    val filteri : (int -> 'a -> bool) -> 'a t -> 'a t
    val partition : ('a -> bool) -> 'a t -> 'a t * 'a t
    val partition_map : ('a -> ('b, 'c) Either.t) -> 'a t -> 'b t * 'c t
    val assoc : 'a -> ('a * 'b) t -> 'b
    val assoc_opt : 'a -> ('a * 'b) t -> 'b option
    val assq : 'a -> ('a * 'b) t -> 'b
    val assq_opt : 'a -> ('a * 'b) t -> 'b option
    val mem_assoc : 'a -> ('a * 'b) t -> bool
    val mem_assq : 'a -> ('a * 'b) t -> bool
    val remove_assoc : 'a -> ('a * 'b) t -> ('a * 'b) t
    val remove_assq : 'a -> ('a * 'b) t -> ('a * 'b) t
    val split : ('a * 'b) t -> 'a t * 'b t
    val combine : 'a t -> 'b t -> ('a * 'b) t
    val sort : ('a -> 'a -> int) -> 'a t -> 'a t
    val stable_sort : ('a -> 'a -> int) -> 'a t -> 'a t
    val fast_sort : ('a -> 'a -> int) -> 'a t -> 'a t
    val sort_uniq : ('a -> 'a -> int) -> 'a t -> 'a t
    val merge : ('a -> 'a -> int) -> 'a t -> 'a t -> 'a t
    val to_seq : 'a t -> 'a Seq.t
    val of_seq : 'a Seq.t -> 'a t
    val optmap : ('a -> 'b option) -> 'a t -> 'b t
  end
```

It creates a module `Extensions.List` that has everything the standard `List`
module has, plus a new `optmap` function. From another file, all we have to do
to override the default `List` module is `open Extensions` at the beginning of
the .ml file:

<!-- $MDX skip -->
```ocaml
open Extensions

...

List.optmap ...
```
