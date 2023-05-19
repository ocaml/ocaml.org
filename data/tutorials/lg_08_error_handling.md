---
id: error-handling
title: Error Handling
description: >
  Discover the different ways you can manage errors in your OCaml programs
category: "language"
date: 2021-05-27T21:07:30-00:00
---

# Error Handling

In OCaml, errors can be handled in several ways. This document presents most of
the available means. However, handling errors using the effect handlers
introduced in OCaml 5 isn't addressed yet. This topic is also addressed in th [_Error Handling_](https://dev.realworldocaml.org/error-handling.html) chapter
of the _Real World OCaml_ book by Yaron Minsky and Anil Madhavapeddy (see references).

## Error as Special Values

Don't do that.

Some languages, most emblematically C, treat certain values as errors. For
instance, in Unix systems, here what is contained in `man 2 read`:
> read - read from a file descriptor
>
> `#include <unistd.h>`
>
> `ssize_t read(int fd, void *buf, size_t count);`
>
> [...]
>
> On error, -1 is returned, and `errno` is set to indicate the error.

Great software was written using this style. However, since correct are errors
values can't be distinguished, nothing but the programmer's discipline ensures
errors aren't ignored. This has been the cause of many bugs, some with dire
consequences. This is not the proper way to deal with errors in OCaml.

There are three major ways to make it impossible to ignore errors in OCaml:
1. Exceptions
1. **`option`** values
1. **`result`** values

Use them. Do not encode errors inside data.

Exceptions provide a mean to deal with errors at the control flow level while
`option` and **`result`** provide means to turn errors into dedicated data.

The rest of this document presents and compares approaches towards error
handling.

## Exceptions

Historically, the first way of handling errors in OCaml is exceptions. The
standard library relies heavily upon them.

The biggest issue with exceptions is that they do not appear in types. One has
to read the documentation to see that, indeed, `List.find` or `String.sub` are
functions that might fail by raising an exception.

However, exceptions have the great merit of being compiled into efficient
machine code. When implementing trial and error approaches likely to back-track
often, exceptions can be used to achieve good performance.

Exceptions belong to the type `exn` which is an [extensible sum
type](/manual/extensiblevariants.html).

```ocaml
# exception Foo of string;;
exception Foo of string

# let i_will_fail () = raise (Foo "Oh no!");;
val i_will_fail : unit -> 'a = <fun>

# i_will_fail ();;
Exception: Foo "Oh no!".
```

Here, we add a variant `Foo` to the type `exn` and create a function that will
raise this exception. Now, how do we handle exceptions? The construct is `try
... with ...`:

```ocaml
# try i_will_fail () with Foo _ -> ();;
- : unit = ()
```

### Predefined Exceptions

The standard library predefines several exceptions, see
[`Stdlib`](/api/Stdlib.html). Here are a few examples:

```ocaml
# 1 / 0;;
Exception: Division_by_zero.
# List.find (fun x -> x mod 2 = 0) [1; 3; 5];;
Exception: Not_found.
# String.sub "Hello world!" 3 (-2);;
Exception: Invalid_argument "String.sub / Bytes.sub".
# let rec loop x = x :: loop x;;
val loop : 'a -> 'a list = <fun>
# loop 42;;
Stack overflow during evaluation (looping recursion?).
```

Although the last one doesn't look as an exception, it actually is.
```ocaml
# try loop 42 with Stack_overflow -> [];;
- : int list = []
```

Among the predefined exceptions of the standard library, the following ones
are intended to be raised by user-written functions:

* `Exit` can be used to terminate an iteration, like a `break` statement
* `Not_found` should be raised when searching failed because there isn't
  anything satisfactory to be found
* `Invalid_argument` should be raised when a parameter can't be accepted
* `Failure` should be raised when a result can't be produced

Functions are provided by the standard library to raise `Invalid_argument` and
`Failure` using a string parameter:
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

Both can make sense, and there isn't a general rule. If the standard library
exceptions are used, they must be raised under their intended conditions,
otherwise handlers will have trouble processing them. Using custom exceptions
will force client code to include dedicated catch conditions. This can be
desirable for errors that must be handled at the client level.

### Using `Fun.protect`

The `Fun` module of the standard library contains the following defintion:
```ocaml
val protect : finally:(unit -> unit) -> (unit -> 'a) -> 'a
```
This function is meant to be used when something _always_ needs to be done
_after_ a computation is complete, either it succeded or failed. Any computation
can be postponed by wrapping it into a dummy function with only `()` as
 parameter. Here, the computation triggered by passing `x` to `f` (including its
 side effects) will not take place:
```ocaml
let work () = f x
```

It would, on execution of `work ()`. This is what `protect` does, and such a
`work` function is the kind of parameter `protect` expects. The `finally`
function is called by `protect`, after the completion of `work ()`, in two
possible way, depending on its outcome
1. If it successed, the result produced is forwarded
2. If it failed, exception raised is forwarded

The `finally` function is only expected to perform some side-effect. In summary,
`protect` performs two computations in order: `work` and then `finally`, and
forwards the outcome of `work` either result or exception.

The `finally` function shall not raise any exception. If it does, it will be
raised again, but wrapped into `Finally_raised`.

Here is an example of how it can be used. Let's imagine a function reading the
`n` first line of a text file is needed (like the `head` Unix command). If the
file hasn't enough lines, the function must throw `End_of_file`. Here is a
possible implementation using `Fun.protect` to make sure the file is always closed:
```ocaml
# let rec head_channel chan =
  let rec loop acc n = match input_line chan with
    | line when n > 0 -> loop (line :: acc) (n - 1)
    | _ -> List.rev acc in
  loop [];;
val head_channel : in_channel -> int -> string list = <fun>
# let head_file filename n =
  let ic = open_in filename in
  let finally () = close_in ic in
  Fun.protect ~finally (fun () -> head_channel ic n);;
val head_file : string -> int -> string list = <fun>
```

### Asynchronous Exceptions

Some exceptions don't arise because something attempted by the program failed,
but rather because an external factor is impeding its execution. Those exeptions
are called asynchronous. This is the case, for instance, of the following ones:

* `Out_of_memory`
* `Stack_overflow`
* `Sys.Break`

The latter is thrown when the user interrupts an interactive execution. Because
they are losely or unrelated with the program logic, it mostly doesn't make
sense to track the place where an asynchronous exceptions was thrown, could be
anywhere. Defining if an application needs to catch those exceptions and how it
should be done is beyond the scope of this tutorial. Interrested readers may
refer to Guillaume Munch-Maccagnoni [A Guide to recover from
interrupts](https://guillaume.munch.name/software/ocaml/memprof-limits/recovering.html).

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

### Stack Traces

To get a stack trace when an unhandled exception makes your program crash, you
need to compile the program in debug mode (with `-g` when calling `ocamlc`, or
`-tag 'debug'` when calling `ocamlbuild`). Then:

```shell
OCAMLRUNPARAM=b ./myprogram [args]
```

And you will get a stack trace. Alternatively, you can call, from within the
program,

```ocaml
let () = Printexc.record_backtrace true
```

### Printing

To print an exception, the module `Printexc` comes in handy. For instance, it
allows the definition of a function, such as `notify_user : (unit -> 'a) -> 'a`
to call a function and, if it fails, prints the exception on `stderr`. If
stack traces are enabled, this function will also display it.

```ocaml
let notify_user f =
  try f () with e ->
    let msg = Printexc.to_string e
    and stack = Printexc.get_backtrace () in
      Printf.eprintf "there was an error: %s%s\n" msg stack;
      raise e
```

OCaml knows how to print its built-in exceptions, but you can also tell it how to
print your own exceptions:

```ocaml
exception Foo of int

let () =
  Printexc.register_printer
    (function
      | Foo i -> Some (Printf.sprintf "Foo(%d)" i)
      | _ -> None (* for other exceptions *)
    )
```

Each printer should take care of the exceptions it knows about, returning `Some
<printed exception>`, and return `None` otherwise (let the other printers do the
job).

## Runtime Crashes

Although OCaml is a very safe language, it is possible to trigger unrecoverable
errors at runtime.

### Exceptions Not Raised

The compiler and runtime makes a best effort for raising meaningful exceptions.
However, some error conditions may remain undetected, which can result in a
segmentation fault. This is the specially the case for `Out_of_memory`, which
is not reliable. It used to be the case for `Stack_overflow`:

> But catching stack overflows is tricky, both in Unix-like systems and under
> Windows, so the current implementation in OCaml is a best effort that is
> occasionally buggy.

[Xavier Leroy, October
2021](https://discuss.ocaml.org/t/stack-overflow-reported-as-segfault/8646/8)

This has improved since. Only linked C code should be able to trigger an
undetected stack overflow.

### Genuinely Unsafe Functions

Some OCaml functions are genuinely unsafe. Use them with care; not like this:

```shell
> echo "fst Marshal.(from_string (to_string 0 []) 0)" > boom.ml
> ocamlc boom.ml
> ./a.out
Segmentation fault (core dumped)
```

### Language Bugs

When a crash isn't coming from:
* A limitation of the native code compiler
* An genuinely unsafe function such as found in modules `Marshal` and `Obj`

It may be a language bug. It happens. Here is what to do when this is suspected:

1. Make sure the crash affects both compilers: bytecode and native
1. Write a self-contained and minimal proof-of-concept code which does nothing
   but triggering the crash
1. File an issue in the [OCaml Bug Tracker in
   GitHub](https://github.com/ocaml/ocaml/issues)

Here is an example of such a bug: https://github.com/ocaml/ocaml/issues/7241

### Safe vs. Unsafe Functions

Uncaught exceptions raise runtime crashes. Therefore, there is a tendency to use
the following terminology:
* Function raising exceptions: Unsafe
* Function handling errors in data: Safe

The main means to write such kind of safe error handling functions is to use
either **`option`** (next section) or **`result`** (following section). Although
handling errors in data using those types allows avoiding the issues of error
values and execeptions, it incurs extracting the enclosed value at every step, which:
* may require some boilerplate code. This
* come with a runtime cost.

## Using the **`option`** Type for Errors

The **`option`** module provides the first alternative to exceptions. The `'a
option` datatype allows to express either the availability of data for instance
`Some 42` or the absence of data using `None`, which can represent an error.

Using **`option`** it is possible to write functions that return `None` instead of
throwing an exception. Here are two examples of such functions:
```ocaml
# let div_opt m n =
  try Some (m / n) with
    Division_by_zero -> None;;
val div_opt : int -> int -> int option = <fun>

# let find_opt p l =
  try Some (List.find p l) with
    Not_found -> None;;
val find_opt : ('a -> bool) -> 'a list -> 'a option = <fun>
```
We can try those functions:

```ocaml
# 1 / 0;;
Exception: Division_by_zero.
# div_opt 42 2;;
- : int option = Some 21
# div_opt 42 0;;
- : int option = None
# List.find (fun x -> x mod 2 = 0) [1; 3; 5];;
Exception: Not_found.
# find_opt (fun x -> x mod 2 = 0) [1; 3; 4; 5];;
- : int option = Some 4
# find_opt (fun x -> x mod 2 = 0) [1; 3; 5];;
- : int option = None
```

It tends to be considered good practice nowadays when a function can fail in
cases that are not bugs (i.e., not `assert false`, but network failures, keys
not present, etc.) to return type such as `'a option` or `('a, 'b) result` (see
next section) rather than throwing an exception.

### Naming Conventions

There are two naming conventions to have two versions of the same partial
function: one raising exception, the other returning an option. In the above
examples, the convention of the standard library is used: adding an `_opt`
suffix to name of the version of the function that returns an option instead of
raising exceptions.
```ocaml
val find: ('a -> bool) -> 'a list -> 'a
(** @raise Not_found *)
val find_opt: ('a -> bool) -> 'a list -> 'a option
```
This is extracted from the `List` module of the standard library.

However, some projects tend to avoid or reduce the usage of exceptions. In such
a context, reversing the convention is a relatively common idiom. It is the
version of the function that raises exceptions that is suffixed with `_exn`.
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
needed. Here are the functions provided by the **`option`** module to extract the
data contained in an option:
```ocaml
val get : 'a t -> 'a
val value : 'a t -> default:'a -> 'a
val fold : none:'a -> some:('b -> 'a) -> 'b t -> 'a
```
`get` returns the content or raises `Invalid_argument` if applied to `None`.
`value` essentially behaves as `get`, except it must be called with a default
value which will be returned if applied to `None`. `fold` also needs to be
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
However, sequencing such expressions leads to deep nesting which is often
considered bad:

> if you need more than 3 levels of indentation, you're screwed anyway, and
> should fix your program.

[Linux Kernel Style
Guide](https://www.kernel.org/doc/Documentation/process/coding-style.rst)

The recommended way to avoid that is to refrain from or delay attempting to
access the content of an option value, as explained in the next sub section.

### Using on `Option.map` and `Option.bind`

Let's start with an example. Let's imagine one needs to write a function
returning the [hostname](https://en.wikipedia.org/wiki/Hostname) part of an
email address provided as a string. For instance, given the string
`"gaston.lagaffe@courrier.dupuis.be"` it would return the string `"courrier"` (one may have a point arguing against such a design, but this is only an example).

Here is a questionable but straightforward implementation using exceptions:
```ocaml
# let host email =
  let fqdn_pos = String.index email '@' + 1 in
  let fqdn_len = String.length email - fqdn_pos in
  let fqdn = String.sub email fqdn_pos fqdn_len in
  try
    let host_len = String.index fqdn '.' in
    String.sub fqdn 0 host_len
  with Not_found ->
    if fqdn <> "" then fqdn else raise Not_found;;
val host : string -> string = <fun>
```
This may fail by raising `Not_found` if the first the call to `String.index`
does, which make sense since if there is no `@` character in the input string,
signifying that it's not an email address. However, if the second call to `String.index` fails,
meaning no dot character was found, we may return the whole fully qualified
domain name (FQDN) as a fallback, but only if it isn't the empty string.

Note that `String.sub` may throw `Invalid_argument`. Fortunately, this can't
happen. In the worst case, the `@` character is the last one, then `fqdn_pos` is
off range by one but `fqdn_len` is null, and that combination of parameters
doesn't count as an invalid substring.

Below is the equivalent function using the same logic, but using **`option`** instead of
exceptions:

```ocaml
# let host_opt email =
  match String.index_opt email '@' with
  | Some at_pos -> begin
      let fqdn_pos = at_pos + 1 in
      let fqdn_len = String.length email - fqdn_pos in
      let fqdn = String.sub email fqdn_pos fqdn_len in
      match String.index_opt fqdn '.' with
      | Some host_len -> Some (String.sub fqdn 0 host_len)
      | None -> if fqdn <> "" then Some fqdn else None
    end
  | None -> None;;
val host_opt : string -> string option = <fun>
```

Although it qualifies as safe, its legibility isn't improved. Some may even
claim it is worse.

Before showing how to improve this code, we need to explain how `Option.map` and
`Option.bind` work. Here are their types:

```ocaml
val map : ('a -> 'b) -> 'a option -> 'b option
val bind : 'a option -> ('a -> 'b option) -> 'b option
```

`Option.map` applies a function `f` to an option parameter, if it isn't `None`

```ocaml
let map f = function
| Some x -> Some (f x)
| None -> None
```

If `f` can be applied to something, its result is rewrapped into a fresh option.
If there isn't anything to supply to `f`, `None` is forwarded.

If we don't take arguments order into account, `Option.bind` is almost exactly
the same, except we assume `f` returns an option. Therefore, there is no need to
rewrap its result, since it's already an option value:
```ocaml
let bind opt f = match opt with
| Some x -> f x
| None -> None
```

`bind` having flipped parameter with respect to `map` allows using it as a
[binding operator](/manual/bindingops.html), which is a popular extension of
OCaml providing means to create “custom `let`”. Here is how it goes:
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
  |> Option.map (fun host_len -> String.sub fqdn 0 host_len)
  |> function None when fqdn <> "" -> Some fqdn | opt -> opt;;
val host_opt : string -> string option = <fun>
```

This version was picked to illustrate how to use and combine operations on
options allowing users to achieve some balance between understandability and
robustness. A couple of observations:
* As in the original `host` function (with exceptions):
   - The calls to `String` functions (`index_opt`, `length`, and `sub`) are the
  same and in the same order
   - The same local names are used with the same types
* There isn't any remaining indentation or pattern-matching
* Line 1:
  - right-hand side of `=` : `Option.map` allows adding 1 to the result of
    `String.index_opt`, if it didn't fail
  - left-hand side of `=` : the `let*` syntax turns all the rest of the code
  (from line 2 to the end) into the body of an anonymous function which takes
  `fqdn_pos` as parameter, and the function `( let* )` is called with `fqdn_pos`
  and that anonymous function.
* Lines 2 and 3: same as in the original
* Line 4: `try` or `match` is removed
* Line 5: `String.sub` is applied, if the previous step didn't fail, otherwise
  the error is forwarded
* Line 6: if nothing was found earlier, and if isn't empty, `fqdn` is returned
  as a fallback

When used to handle errors with catch statements, it requires some time to get
used the latter style. The key idea is avoiding or deferring from directly
looking into option values. Instead, pass them along using _ad-hoc_ pipes (such
as `map` and `bind`). Erik Meijer call that style: “following the happy path”.
Visually, it also resembles the “early return“ pattern often found in C.

One of the limitations of the option type is it doesn't record the reason which
prevented having a return value. `None` is silent, it doesn't say anything about
what went wrong. For this reason, functions returning option values should
document the circumstances under which it may return `None`. Such a
documentation is likely to ressemble to the one required for exceptions using
`@raise`. The **`result`** type is intended to fill this gap: manage error in data,
like option values, but also provide information on errors, like exceptions. It
is the topic of the next section.

## Using the **`result`** Type for Errors

The **`result`** module of the standard library defines the following type:

```ocaml
type ('a, 'b) result =
  | Ok of 'a
  | Error of 'b
```

A value `Ok x` means that the computation succeeded and produced `x`, a
value `Error e` means that it failed, and `e` represents whatever error
information has been collected in the process. Pattern matching can be used to
deal with both cases, as with any other sum type. However using `map` and `bind`
can be more convenient, maybe even more as it was with **`option`**.

Before taking a look at `Result.map`, let's think about `List.map` and
`Option.map` under a changed perspective. Both functions behave as identity when
applied to `[]` or `None`, respectively. That's the only possibility since those
parameters don't carry any data. Which isn't the case in **`result`** with its
`Error` constructor. Nevertheless, `Result.map` is implemented likewise, on
`Error`, it also behaves like identity.

Here is its type:
```ocaml
val map : ('a -> 'b) -> ('a, 'c) result -> ('b, 'c) result
```
And here is how it is written:
```ocaml
let map f = function
| Ok x -> Ok (f x)
| Error e -> Error e
```

The **`result`** module has two map functions: the one we've just seen and another
one, with the same logic, applied to `Error`

Here is its type:
```ocaml
val map : ('c -> 'd) -> ('a, 'c) result -> ('a, 'd) result
```
And here is how it is written:
```ocaml
let map_error f = function
| Ok x -> Ok x
| Error e -> f e
```

The same reasoning applies to `Result.bind`, except there's no `bind_error`.
Using those functions, here is an hypothetical example of code using [Anil
Madhavapeddy OCaml Yaml library](https://github.com/avsm/ocaml-yaml):
```ocaml
let file_opt = File.read_opt path in
let file_res = Option.to_result ~none:(`Msg "File not found") file_opt in begin
  let* yaml = Yaml.of_string file_res in
  let* found_opt = Yaml.Util.find key yaml in
  let* found = Option.to_result ~none:(`Msg (key ^ ", key not found")) found_opt in
  found
end |> Result.map_error (Printf.sprintf "%s, error: %s: " path)
```

Here are the types of the involved functions:
```ocaml
val File.read_opt : string -> string option
val Yaml.of_string : string -> (Yaml.value, [`Msg of string]) result
val Yaml.Util.find : string -> Yaml.value -> (Yaml.value option, [`Msg of string]) result
val Option.to_result : none:'e -> 'a option -> ('a, 'e) result
```

- `File.read_opt` is supposed to open a file, read its contents and return it as
a string wrapped in an option, if anything goes wrong `None` is returned.
- `Yaml.of_string` parses a string an turns into an ad-hoc OCaml type
- `Yaml.find` recursively searches a key in a Yaml tree, if found, it returns
  the corresponding data, wrapped in an option
- `Option.to_result` performs conversion of an **`option`** into a **`result`**.
- Finally, `let*` stands for `Result.bind`.

Since functions from the `Yaml` module both returns **`result`** data, it is easier
to write a pipe which processes that type all along. That's why
`Option.to_result` needs to be used. Stages which produce **`result`** must be
chained using `bind`, stages which do not must be chained using some map
function, in order for the result to be wrapped back into a **`result`**.

The map functions of the **`result`** module allows processing of data or errors,
but the routines used must not fail, as `Result.map` will never turn an `Ok`
into an `Error` and `Result.map_error` will never turn an `Error` into an `Ok`.
On the other hand, functions passed to `Result.bind` are allowed to fail. As
stated before there isn't a `Result.bind_error`. One way to make sense out of
that absence is to consider its type, it would have to be:
```ocaml
val Result.bind_error : ('a, 'e) result -> ('e -> ('a, 'f) result) -> ('a, 'f) result
```
We would have:
* `Result.map_error f (Ok x) = Ok x`
* And either:
  - `Result.map_error f (Error e) = Ok y`
  - `Result.map_error f (Error e) = Error e'`

This means an error would be turned back into valid data or changed into
another error. This is almost like recovering from an error. However, when
recovery fails, it may be preferable to preserve the initial cause of failure.
That behaviour can be achieved by defining the following function:

```ocaml
# let recover f = Result.(fold ~ok:ok ~error:(fun (e : 'e) -> Option.to_result ~none:e (f e)));;
val recover : ('e -> 'a option) -> ('a, 'e) result -> ('a, 'e) result = <fun>
```

Although any kind of data can be wrapped as a **`result`** `Error`, it is
recommended to use that constructor to carry actual errors, for instance:
- `exn`, in which case the result type just makes exceptions explicit
- `string`, where the error case is a message that indicates what failed
- `string Lazy.t`, a more elaborate form of error message that is only evaluated
  if printing is required
- some polymorphic variant, with one case per possible error. This is very
  accurate (each error can be dealt with explicitly and occurs in the type), but
  the use of polymorphic variants sometimes make the code harder to read.

Note that some say the types **`result`** and `Either.t` are
[ismorphic](https://en.wikipedia.org/wiki/Isomorphism). Concretely, it means
it's always possible to replace one by the other, like in a completely neutral
refactoring. Values of type **`result`** and `Either.t` can be translated back and
forth, and appling both translations one after the other, in any order, returns
to the starting value. Nevertheless, this doesn't mean **`result`** should be used
in place of `Either.t`, or vice versa. Naming things matters, as punned by Phil
Karlton's famous quote:

> There are only two hard things in Computer Science: cache invalidation and
> naming things.

Properly handling errors always makes the code harder to read. Using the right
tools, data, and functions can help. Use them.

## `bind` as a Binary Operator

When `Option.bind` or `Result.bind` are used, they are often aliased into a
custom binding operator, such as `let*`. However, it is also possible to use it
as a binary operator, which is very often writen `>>=`. Using `bind` this way
must be detailed because it is extremely popular in other functional programming
languages, and specially in Haskell.

Assuming `a` and `b` are valid OCaml expressions, the following three pieces of
source code are functionally identical:

```ocaml
bind a (fun x -> b)
```
```ocaml
let* x = a in b
```
```ocaml
a >>= fun x -> b
```

It may seem pointless. To make sense, one must look at expressions where several
calls to `bind` are chained. The following three are also equivalent:

```ocaml
bind a (fun x -> bind b (fun y -> c))
```
```ocaml
let* x = a in
let* y = b in
c
```
```ocaml
a >>= fun x -> b >>= fun y -> c
```
Variables `x` and `y` may appear in `c` in the three cases. The first form isn't
very convenient, it uses a lot of parenthesis. The second one is often the
prefered one due to its ressemblance with regular local definitions. The third
one is harder to read, as `>>=` associates to the right in order to avoid
parenthesis in that precise case, but it's easy to get lost. Nevertheless, it
has some appeal when named functions are used. It looks a bit like good old Unix
pipes:
```ocaml
a >>= f >>= g
```
looks better than:
```ocaml
let* x = a in
let* y = f x in
g y
```
Writing `x >>= f` is very close to what is found in functionally tainted
programming languages, which have methods and receivers such as Kotlin, Scala,
Go, Rust, Swift or even modern Java, where it would be looking like:
`x.bind(f)`.

Here is the same code as presented at the end of the previous section, rewritten
using `Result.bind` as a binary opeator:
```ocaml
File.read_opt path
|> Option.to_result ~none:(`Msg "File not found")
>>= Yaml.of_string
>>= Yaml.Util.find key
>>= Option.to_result ~none:(`Msg (key ^ ", key not found"))
|> Result.map_error (Printf.sprintf "%s, error: %s: " path)
```

By the way, this style is called [Tacit
Programming](https://en.wikipedia.org/wiki/Tacit_programming). Thanks to the
associativity priorities of the `>>=` and `|>` operators, no parenthesis extends beyond a single line.

OCaml has a strict typing discipline, not a strict styling discipline;
therefore, picking the right style is left to the author's decision. That
applies error handling, pick a style knowingly. See the [OCaml Programming
Guidelines](/docs/guidelines) for more details on those matters.

## Convertions Between Errors

### Throwing Exceptions From **`option`** or **`result`**

This is done by using the following functions:

- From **`option`** to `Failure` exception, use function `Option.get`:
  ```ocaml
  val get : 'a option -> 'a
  ```

- From **`result`** to `Failure`, exception use function `Result.get_ok` and `Result.get_error`:
  ```ocaml
  val get_ok : ('a, 'e) result -> 'a
  val get_error : ('a, 'e) result -> 'e
  ```

To raise other exceptions, pattern matching and `raise` must be used.

## Convertion Between **`option`** and **`result`**

This is done by using the following functions:

- From **`option`** to **`result`**, use function `Option.to_result`:
  ```ocaml
  val to_result : none:'e -> 'a option -> ('a, 'e) result
  ```
- From **`result`** to **`option`**, use function `Result.to_option`:
  ```ocaml
  val to_option : ('a, 'e) result -> 'a option
  ```

## Turning Exceptions in to **`option`** or **`result`**

The standard library does not provide such functions. This must be done using
**`try ... with`** or `match ... exception` statements. For instance, here is
how to create a version of `Stdlib.input_line` which returns and **`option`**
instead of throwing an exception:

```ocaml
let input_line_opt ic = try Some (input_line ic) with End_of_file -> None
```

It would be same for **`result`**, except some data must be provided to the
`Error` constructor.

Some may like to turn this into a higher-order generic function:
```ocaml
# let catch f x = try Some (f x) with _ -> None;;
val catch : ('a -> 'b) -> 'a -> 'b option = <fun>
```

## Assertions

The built-in `assert` instruction takes an expression as an argument and throws
the `Assert_failure` exception if the provided expression evaluates to `false`.
Assuming that you don't catch this exception (it's probably unwise to catch this
exception, particularly for beginners), this causes the program to stop and
print the source file and line number where the error occurred. An
example:

```ocaml
# assert (Sys.os_type = "Win32");;
Exception: Assert_failure ("//toplevel//", 1, 0).
```

Running this on Win32, of course, won't throw an error.

Writing `assert false` would just stop your program. This idiom is sometimes
used to indicate [dead code](https://en.wikipedia.org/wiki/Dead_code), parts of
the program that must be writen (often for type-checking or pattern matching
completeness) but are unreachable at run time.

Asserts should be understood as executable comments. There aren't supposed to
fail, unless during debugging or truly extraordinary circumstances that
absolutely prevent the execution from making any kind of progress.

When the execution reaches conditions which can't be handled, the right thing to
do is to throw a `Failure`, using `failwith "error message"`. Assertions aren't
 meant to handle those cases. For instance, in the following code:

<!-- $MDX skip -->
```ocaml
match Sys.os_type with
| "Unix" | "Cygwin" ->   (* code omitted *)
| "Win32" ->             (* code omitted *)
| "MacOS" ->             (* code omitted *)
| _ -> failwith "this system is not supported"
```

It is right to use `failwith`, other operating systems aren't supported, but
they are possible. Here is the dual example:
```ocaml
function x when true -> () | _ -> assert false
```
Here, it wouldn't be correct to use `failwith` because it requires a corrupted
system or the compiler to be bugged for the second code path to be executed.
Breakage of the language semantics qualifies as extraordinary circumstances. It
is catastrophic!

# Concluding Remarks

Properly handling errors is a complex matter. It is [cross-cutting
concern](https://en.wikipedia.org/wiki/Cross-cutting_concern), touches all parts
of an application, and can't be isolated in a dedicated module. In contrast to
several other mainstream languages, OCaml provides several mechanisms to handle
exceptional events, all with good runtime performance and code
understandability. Using them properly requires some initial learning and
practice. Later, it always requires some thinking, which is good since proper
error management shouldn't ever be overlooked. No error handling is better
than the others, and is should be matter of adequacy to the context rather than
of taste. But opinionated OCaml code is also fine, so it's a balance.

# External Ressources

- [“Exceptions”](https://v2.ocaml.org/releases/5.0/htmlman/coreexamples.html#s%3Aexceptions) in ”The OCaml Manual, The Core Language”, chapter 1, section 6, December 2022
- [Module **`option`**](https://v2.ocaml.org/releases/5.0/api/Option.html) in OCaml Library
- [Module **`result`**](https://v2.ocaml.org/releases/5.0/api/Result.html) in Ocaml Library
- [“Error Handling”](https://dev.realworldocaml.org/error-handling.html) in “Real World OCaml”, part 7, Yaron Minsky and Anil Madhavapeddy, 2ⁿᵈ edition, Cambridge University Press, October 2022
- “Add "finally" function to Pervasives”, Marcello Seri, GitHub PR, [ocaml/ocaml/pull/1855](https://github.com/ocaml/ocaml/pull/1855)
- “A guide to recover from interrupts”, Guillaume Munch-Maccagnoni, parf the [`memprof-limits`](https://gitlab.com/gadmm/memprof-limits/) documentation

# Acknowledgements

- Authors
  1. Simon Cruanes [@c-cube](https://github.com/c-cubeauthored)
  2. John Whitington [@johnwhitington](https://github.com/johnwhitington)
  3. Cuihtlauac Alvarado [@cuihtlauac](https://github.com/cuihtlauac)
- Contributors
  * Dan Frumin [@co-dan](https://github.com/co-dan)
  * Jean-Pierre Rodi
  * Thibaut Mattio [@tmattio](https://github.com/tmattio)
  * Jonah Beckford [@jonahbeckford](https://github.com/jonahbeckford)
- Suggestions and Corrections:
  * Claude Jager-Rubinson
  * [@rand00](https://github.com/rand00)
  * Guillaume Munch-Maccagnoni [@gadmm](https://github.com/gadmm)
  * Edwin Török [@edwintorok](https://github.com/edwintorok)
  * Kim Nguyễn [@Tchou](https://github.com/Tchou)
  * Ashine Foster [@AshineFoster](https://github.com/AshineFoster)
  * Miod Vallat [@dustanddreams](https://github.com/dustanddreams)
  * Christine Rose [@christinerose](https://github.com/christinerose)
  * Riku Silvola [@rikusilvola](https://github.com/rikusilvola)
  * Guillaume Petiot [@gpetiot](https://github.com/gpetiot)