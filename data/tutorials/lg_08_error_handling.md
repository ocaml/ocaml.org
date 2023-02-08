---
id: error-handling
title: Error Handling
description: >
  Discover the different ways you can manage errors in your OCaml programs
category: "language"
date: 2021-05-27T21:07:30-00:00
---

# Error Handling

## Error as Special Values

Don't do that.

Some languages, most emblematically C, treats certain values as errors. For
instance, when receiving data through a network connection, a function expected
to return the number of received bytes might return a negative number meaning:
“timed out waiting”. Another example would be returning the empty string when
extracting a substring of negative length. Great software was written using this
style, but is is not the proper way to deal with errors in OCaml.

OCaml has three major ways to deal with errors:
1. Exceptions
1. `Option` values
1. `Result` values

Use them. Do not encode errors inside data. Exceptions provide a mean to deal
with errors at the control flow level while `Option` and `Result` provide a mean
to turn errors into dedicated data.

The rest of this document presents and compares approaches towards error
handling.

## Exceptions

Historically, the first way of handling errors in OCaml is exceptions. The
standard library relies heavily upon them.

The biggest issue with exceptions is that they do not appear in types. One has
to read the documentation to see that, indeed, `List.find` or `String.sub` are not
total functions, and that they might fail by raising an exception.

However, exceptions have the great merit of being compiled into efficient
machine code. When implementing trial and error approaches likely to back-track
often, exceptions can be used to acheive good performance.

Exceptions belong to the type `exn` which is an [extensible sum type](/releases/latest/manual/extensiblevariants.html).

```ocaml
# exception Foo of string;;
exception Foo of string

# let i_will_fail () =
  raise (Foo "Oh no!");;

# i_will_fail ();;
Exception: Foo "Oh no!".
```

Here, we add a variant `Foo` to the type `exn`, and create a function that will
raise this exception. Now, how do we handle exceptions? The construct is `try
... with ...`:

```ocaml
# try i_will_fail () with Foo _ -> ();;
- : unit = ()
```

### Predefined Exceptions

The standard library predefines several exceptions, see
[`Stdlib`](/releases/latest/api/Stdlib.html). Here are a few examples:

```ocaml
# 1 / 0;;
Exception: Division_by_zero.
# List.find (fun x -> x mod 2 = 0) [1; 3; 5];;
Exception: Not_found.
# String.sub "Hello world!" 3 (-2);;
Exception: Invalid_argument "String.sub / Bytes.sub".
# let rec loop x = x :: loop x
val loop : 'a -> 'a list = <fun>
# loop 42;;
Stack overflow during evaluation (looping recursion?).
```

Although the last one doesn't look as an exception, it actually is.
```ocaml
# try loop 42 with Stack_overflow -> [];;
- : int list = []
```

Among them the predefined exceptions of the standard library, the following ones
are intended to be raised by user written functions:
```ocaml
exception Exit
exception Not_found
exception Invalid_argument of string
exception Failure of string
```

* `Exit` terminates your program with a success status, which is 0 in Unices (they do error values)
* `Not_found` should be raised when searching failed because there isn't anything satisfactory to be found
* `Invalid_argument` should be raised when a parameter can't be accepted
* `Failure` should be raised when a result can't be produced

Functions are provided to raise `Invalid_argument` and `Failure` using a string parameter:
```ocaml
val invalid_arg : string -> 'a
(** @raise Invalid_argument *)
val failwith : string -> 'a
(** @raise Failure *)
```

When implementing a software component which exposes functions raising
exceptions, a design decision must be made:
* Use the prexisting exceptions
* Raise custom exceptions

Both can make sense, there isn't a general rule. If the exceptions of the
standard library are used, they must be raised under the conditions they are
intended to, otherwise handlers will have trouble processing them. Using custom
exceptions will force client code to include dedicated catch conditions. This
can be desirable for errors that must be handled at the the client level.

### Documentation

Functions that can raise exceptions should be documented like this:

<!-- $MDX skip -->
```ocaml
val foo : a -> b
(** [foo] does this and that, here is how it works, etc.
    @raise Invalid_argument if [a] doesn't satisfy ...
    @raise Sys_error if filesystem is not happy
*)
```

### Stack traces

To get a stack trace when an unhandled exception makes your program crash, you
need to compile the program in "debug" mode (with `-g` when calling
`ocamlc`, or `-tag 'debug'` when calling `ocamlbuild`).
Then:

```
OCAMLRUNPARAM=b ./myprogram [args]
```

And you will get a stack trace. Alternatively, you can call, from within the program,

```ocaml
let () = Printexc.record_backtrace true
```

### Printing

To print an exception, the module `Printexc` comes in handy. For instance,
the following function `notify_user : (unit -> 'a) -> 'a` can be used
to call a function and, if it fails, print the exception on `stderr`.
If stack traces are enabled, this function will also display it.

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

## Runtime Crashes

Although OCaml is a very safe language, it is possible to trigger unrecoverable
errors at runtime.

### Exceptions not Raised

Under panic circumstances, the native code compiler does a best-effort at
raising meaningful exceptions. However, some error conditions may remain
undetected, which will result in a segmentation fault. This is the specially the
case for stack overflows, which aren't always detected.

> But catching stack overflows is tricky, both in Unix-like systems and under Windows, so the current implementation in OCaml is a best effort that is occasionally buggy.

[Xavier Leroy, October 2021](https://discuss.ocaml.org/t/stack-overflow-reported-as-segfault/8646/8?u=cuihtlauac)

### Bypassing Type-Safety

OCaml provides a mean to bypass it's own type safety. Don't use it. Here is how
to shoot in its own feet:

```shell
> echo "(Obj.magic () : int array).(0)" > foo.ml
> ocamlopt foo.ml
> ./a.out
Segmentation fault (core dumped)
```

### Language Bugs

When a crash isn't coming from:
* A limitation of the native code compiler
* `Obj.magic`

It may be a language bug. It happens. Here is what to do when this is suspected:

1. Make sure the crash affects both compilers: bytecode and native
1. Write a self-contained and minimal proof-of-concept code which does nothing but triggering the crash
1. File an issue in the [OCaml Bug Tracker in GitHub](https://github.com/ocaml/ocaml/issues)

Here is an example of such a bug: https://github.com/ocaml/ocaml/issues/7241

### Safe vs. Unsafe Functions

Uncaught exceptions raise runtime crashes. Therefore, there is a tendency to use
the following terminology:
* Function raising exceptions: Unsafe
* Function handling errors in data: Safe

The main means to write such kind of safe error handling functions is to use
either `Option` (next section) or `Result` (following section).

## Using the `Option` Type for Errors

The `Option` module provides the first alternative to exceptions. The `'a
option` datatype allows to express either the availability of data for instance
`Some 42` or the absence of data using `None`, which can represent an error.

Using `Option` it is possible to write function that return `None` instead of
throwing an exception.
```ocaml
let div_opt m n =
  try Some (m / n) with
    Division_by_zero -> None

let find_opt p l =
  try Some (List.find p l) with
    Not_found -> None
```
We can try those functions:

```ocaml
# 1 / 0;;
Exception: Division_by_zero.
# div_opt 42 2;;
- : int option = Some 24
# div_opt 42 0;;
- : int option = None
# List.find (fun x -> x mod 2 = 0) [1; 3; 5];;
Exception: Not_found.
# find_opt (fun x -> x mod 2 = 0) [1; 3; 4; 5];;
- : int option = Some 4
# find_opt (fun x -> x mod 2 = 0) [1; 3; 5];;
- : int option = None
```

This can even be turned into a higher-order generic function:
```ocaml
# let try_opt f x = try Some (f x) with _ -> None;;
val try_opt : ('a -> 'b) -> 'a -> 'b option = <fun>
```

It tends to be considered good practice nowadays when a function can fail in
cases that are not bugs (i.e., not `assert false`, but network failures, keys
not present, etc.) to return a more explicit type such as `'a option` or `('a,
'b) result` (see next section).

### Naming Conventions

There are two naming conventions to have two versions of the same partial
function, one raising exception, the other returning an option. In the above
examples, the convention of the standard library is used add an `_opt` suffix to
name of the version of the function which returns an option instead of raising
exceptions.
```ocaml
val find: ('a -> bool) -> 'a list -> 'a
(** @raise Not_found *)
val find_opt: ('a -> bool) -> 'a list -> 'a option
```
This is extracted from the `List` module of the standard library.

However, some project tend to avoid or reduce the usage of exceptions. In such a
context, reversing the convention is a relatively common idiom. It is the
version of the function which raises exceptions that is suffixed with `_exn`.
Using the same functions, that would be the specification
```ocaml
val find_exn: ('a -> bool) -> 'a list -> 'a
(** @raise Not_found *)
val find: ('a -> bool) -> 'a list -> 'a option
```
### Composing Functions Returning Options

The function `div_opt` can't raise exceptions. However, since it doesn't return
a result of type `int`, it can't be used in place of an `int`. The same way
OCaml doesn't
[promote](https://en.wikipedia.org/wiki/Type_conversion#Type_promotion) integers
into floats, it doesn't automatically converts `int option` into `int` or _vice
versa_.

```ocaml
# 21 + Some 21;;
Error: This expression has type 'a option
       but an expression was expected of type int
```

In order to combine option values with other values, conversion functions are
needed. Here are the functions provided by the `Option` module to extract the
data contained in an option:
```ocaml
val get : 'a t -> 'a
val value : 'a t -> default:'a -> 'a
val fold : none:'a -> some:('b -> 'a) -> 'b t -> 'a
```
`get` returns the content or raises `Invalid_argument` if applied to `None`.
`value` essentially behaves as `get`, except it must be called with a default
value which will be returned of if applied to `None`. `fold` also needs to be
passed a default value that is returned when called on `None`, but it also
expects a function that will be applied to the content of the option, when not
empty.

As a remark, observe that `value` can be implemented using `fold`:
```ocaml
# let value ~default = Option.fold ~none:default ~some:Fun.id;;
val value : default:'a -> 'a option -> 'a = <fun>
# Option.value ~default:() None = value ~default:() None;;
- : bool = true
# Option.value ~default:() (Some ()) = value ~default:() (Some ());;
- : bool = true
```

It is also possible to perform pattern matching on option values:
```ocaml
match opt with
| None -> ...    (* Something *)
| Some x -> ...  (* Something else *)
```
However, sequencing such expressions leads to deep nesting which is often considered bad:

> if you need more than 3 levels of indentation, you're screwed anyway, and should fix your program.

[Linux Kernel Style Guide](https://www.kernel.org/doc/Documentation/process/coding-style.rst)

The recomended way to avoid that is to refrain from or delay attempting to
access the content of an option value.

### Using on `Option.map` and `Option.bind`

Let's start with an example. Let's imagine one needs to write a function
returning the [hostname](https://en.wikipedia.org/wiki/Hostname) part of an
email address. For instance, given the email
"gaston.lagaffe@courrier.dupuis.be", it would return "courrier".

Here is a questionable but straitforward implementation, using exceptions:
```ocaml
let host email =
  let fqdn_pos = String.index email '@' + 1 in
  let fqdn_len = String.length email - fqdn_pos in
  let fqdn = String.sub email fqdn_pos fqdn_len in
  try
    let host_len = String.index fqdn '.' in
    String.sub fqdn 0 host_len
  with Not_found ->
    if fqdn <> "" then fqdn else raise Not_found
```
This may fail by raising `Not_found` if the first the call to `String.index`
does, which make sense since if there is no '@' character in input string, it's
not an email address. However, if the second call to `String.index` fails,
meaning no dot character was found, we may return the whole fully qualified
domain name (FQDN) as a fallback, but only if it isn't the empty string.

Note that `String.sub` may throw `Invalid_argument`. Fortunately, this can't
happen. In the worst case, the `@` character is the last one, then `fqdn_pos` is
off range by one but `fqdn_len` is null and that combination of parameters
doesn't count as an invalid substring.

Here the equivalent function, using the same logic but `Option` instead of
exceptions:
```ocaml
let host_opt email =
  match String.index_opt email '@' with
  | Some at_pos -> begin
      let fqdn_pos = at_pos + 1 in
      let fqdn_len = String.length email - fqdn_pos in
      let fqdn = String.sub email fqdn_pos fqdn_len in
      match String.index_opt fqdn '.' with
      | Some host_len -> Some (String.sub fqdn 0 host_len)
      | None -> if fqdn <> "" then Some fqdn else None
    end
  | None -> None
```

Although it qualifies as safe, its legibility isn't improved. Some claim even
claim it is worse.

Before showing how to improve this code, we need to explain how `Option.map` and
`Option.bind` work.
```ocaml
val Option.map : ('a -> 'b) -> 'a option -> 'b option
val Option.bind : 'a option -> ('a -> 'b option) -> 'b option
```

`Option.map` applies a function `f` to an option parameter, if it isn't `None`
```ocaml
let map f = function
| Some x -> Some (f x)
| None as opt -> opt
```

If `f` can be applied to something, its result is rewrapped into a fresh option.
If there isn't anything to supply to `f`, `None` is forwarded.

If we don't take arguments order into account, `Option.bind` is almost exacly
the same, except we assume `f` returns an option, therefore there is no need to
rewrapped its result, it's already an option value:
```ocaml
let bind o f = match opt with
| Some x -> f x
| None -> None
```

`bind` having flipped parameter with respect to `map` allows to use it as custom
let binder:
```ocaml
# let ( let* ) = Option.bind;;
val ( let* ) : 'a option -> ('a -> 'b option) -> 'b option = <fun>
```

Using these mechanisms, here a possible way to rewrite `host_opt`:
```ocaml
# let host_opt email =
  let* fqdn_pos = Option.map (( + ) 1) (String.index_opt email '@') in
  let fqdn_len = String.length email - fqdn_pos in
  let fqdn = String.sub email fqdn_pos fqdn_len in
  String.index_opt fqdn '.'
  |> Option.map (fun dot_pos -> String.sub fqdn 0 dot_pos)
  |> function None when fqdn <> "" -> Some fqdn | opt -> opt;;
val host_opt : string -> string option = <fun>
```

This version was picked to illustrate how to use and combine operations on
options allowing to acheive some balance between understandability and
robustness. A couple of observations:
* As in the original `host` function (with exceptions):
   - The calls to `String` functions (`index_opt`, `length` and `sub`) are written in
  the same order
   - The same local names are used, with the same types
* There isn't any indentation or matching left
* Line 1:
  - right-hand side of `=` : `Option.map` allows adding 1 to the result of `String.index_opt`, if it didn't failed
  - left-hand side of `=` : the `let*` syntax turns all the rest of the
  code (from line 2 to the end) into the body of an anonymous function which
  takes `fqdn_pos` as parameter, and the function `( let* )` is called with the
  right-hand side of `=` (as first parameter) and that anonymous function (as
  second parameter).
* Lines 2 and 3: same as in the original
* Line 4: `try` or `match` is removed
* Line 5: `String.sub` is applied, if the previous step didn't failed, otherwise the error is forwarded
* Line 6: if nothing was found earlier, and if isn't empty, `fqdn` is returned as a fallback



### Options and Return Early

One of the limitation of the option type is it doesn't record the reason which
prevented having a value. `None` is silent, it doesn't say anything about what
went wrong. For this reason, function returning option values should document
the circumstances under which it may return `None`. Such a documentation is
likely to ressemble to the one required for exceptions using `@raise`. The
`Result` type is intended to fill this gap: manage error in data, like option
values but also provide information on errors, like exceptions. It is the topic
of the next section.

## `Result` Type

The `Result` module of the standard library contains the following type:

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
