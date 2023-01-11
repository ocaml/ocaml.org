---
id: error-handling
title: Error Handling
description: >
  Discover the different ways you can manage errors in your OCaml programs
category: "language"
date: 2021-05-27T21:07:30-00:00
---

# Error Handling

## Exceptions

One way of handling errors in OCaml is exceptions. The
standard library relies heavily upon them.

Exceptions belong to the type `exn` (an extensible sum type):

```ocaml
exception Foo of string

let i_will_fail () =
  raise (Foo "Oh no!")
```

Here, we add a variant `Foo` to the type `exn`, and create a function
that will raise this exception. Now, how do we handle exceptions?
The construct is `try ... with ...`:

```ocaml
let safe_inverse n =
  try Some (1 / n) with
    Division_by_zero -> None

let safe_list_find p l =
  try Some (List.find p l) with
    Not_found -> None
```

We can try those functions:

```ocaml
# 1 / 0;;
Exception: Division_by_zero.
# safe_inverse 2;;
- : int option = Some 0
# safe_inverse 0;;
- : int option = None
# List.find (fun x -> x mod 2 = 0) [1; 3; 5];;
Exception: Not_found.
# safe_list_find (fun x -> x mod 2 = 0) [1; 3; 4; 5];;
- : int option = Some 4
# safe_list_find (fun x -> x mod 2 = 0) [1; 3; 5];;
- : int option = None
```

The biggest issue with exceptions is that they do not appear in types.
One has to read the documentation to see that, indeed, `Map.S.find`
or `List.hd` are not total functions, and that they might fail.

It is considered good practice nowadays, when a function can fail in
cases that are not bugs (i.e., not `assert false`, but network failures,
keys not present, etc.)
to return a more explicit type such as `'a option` or `('a, 'b) result`.
A relatively common idiom is to have such a safe version of the function,
say, `val foo : a -> b option`, and an exception raising
version `val foo_exn : a -> b`.

### Documentation

Functions that can raise exceptions should be documented like this:

<!-- $MDX skip -->
```ocaml
val foo : a -> b
(** foo does this and that, here is how it works, etc.
    @raise Invalid_argument if [a] doesn't satisfy ...
    @raise Sys_error if filesystem is not happy *)
```

### Stacktraces

To get a stacktrace when a unhandled exception makes your program crash, you
need to compile the program in "debug" mode (with `-g` when calling
`ocamlc`, or `-tag 'debug'` when calling `ocamlbuild`).
Then:

```
OCAMLRUNPARAM=b ./myprogram [args]
```

And you will get a stacktrace. Alternatively, you can call, from within the program,

```ocaml
let () = Printexc.record_backtrace true
```

### Printing

To print an exception, the module `Printexc` comes in handy. For instance,
the following function `notify_user : (unit -> 'a) -> 'a` can be used
to call a function and, if it fails, print the exception on `stderr`.
If stacktraces are enabled, this function will also display it.

```ocaml
let notify_user f =
  try f () with e ->
    let msg = Printexc.to_string e
    and stack = Printexc.get_backtrace () in
      Printf.eprintf "there was an error: %s%s\n" msg stack;
      raise e
```

OCaml knows how to print its built-in exception, but you can also tell it
how to print your own exceptions:

```ocaml
exception Foo of int

let () =
  Printexc.register_printer
    (function
      | Foo i -> Some (Printf.sprintf "Foo(%d)" i)
      | _ -> None (* for other exceptions *)
    )
```

Each printer should take care of the exceptions it knows about, returning
`Some <printed exception>`, and return `None` otherwise (let the other printers
do the job!).

## Result Type

The Stdlib module contains the following type:

```ocaml
type ('a, 'b) result =
  | Ok of 'a
  | Error of 'b
```

A value `Ok x` means that the computation succeeded with `x`, and
a value `Error e` means that it failed.
Pattern matching can be used to deal with both cases, as with any
other sum type. The advantage here is that a function `a -> b` that
fails can be modified so its type is `a -> (b, error) result`,
which makes the failure explicit.
The error case `e` in `Error e` can be of any type
(the `'b` type variable), but a few possible choices
are:

- `exn`, in which case the result type just makes exceptions explicit.
- `string`, where the error case is a message that indicates what failed.
- `string Lazy.t`, a more elaborate form of error message that is only evaluated
  if printing is required.
- some polymorphic variant, with one case per
  possible error. This is very accurate (each error can be dealt with
  explicitly and occurs in the type) but the use of polymorphic variants
  sometimes make error messages hard to read.

For easy combination of functions that can fail, many alternative standard
libraries provide useful combinators on the `result` type: `map`, `>>=`, etc.

## Assertions
The built-in `assert` takes an expression as an argument and throws an
exception *if* the provided expression evaluates to `false`. 
Assuming that you don't catch this exception (it's probably
unwise to catch this exception, particularly for beginners), this
results in the program stopping and printing out the source file and
line number where the error occurred. An example:

```ocaml
# assert (Sys.os_type = "Win32");;
Exception: Assert_failure ("//toplevel//", 1, 1).
Called from Stdlib__Fun.protect in file "fun.ml", line 33, characters 8-15
Re-raised at Stdlib__Fun.protect in file "fun.ml", line 38, characters 6-52
Called from Topeval.load_lambda in file "toplevel/byte/topeval.ml", line 89, characters 4-150
```

(Running this on Win32, of course, won't throw an error).

You can also just call `assert false` to stop your program if things
just aren't going well, but you're probably better to use ...

`failwith "error message"` throws a `Failure` exception, which again
assuming you don't try to catch it, will stop the program with the given
error message. `failwith` is often used during pattern matching, like
this real example:

<!-- $MDX skip -->
```ocaml
match Sys.os_type with
| "Unix" | "Cygwin" ->   (* code omitted *)
| "Win32" ->             (* code omitted *)
| "MacOS" ->             (* code omitted *)
| _ -> failwith "this system is not supported"
```

Note a couple of extra pattern matching features in this example too. A
so-called "range pattern" is used to match either `"Unix"` or
`"Cygwin"`, and the special `_` pattern which matches "anything else".
