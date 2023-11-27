---
id: options
title: Options
description: >
  Add nothing-as-value to anything to avoid confusion between something and “no such thing“.
category: "Introduction"
---

# Options

## Introduction

An option is a value that wraps another value, or nothing if there isn't anything to wrap. The predefined type `option` is the 
<!-- $MDX non-deterministic=command -->
```ocaml
# #show option;;
type 'a option = None | Some of 'a
```

Here is 42, stored inside an `option` using the data carrying constructor
`Some`:

```ocaml
# Some 42;;
- : int option = Some 42
```

The `None` constructor means no data is available.

In other words, a value of type `t option` for some type `t` represents:
* either a value `v` of type `t`, wrapped as `Some v`
* no such value, then `o` has the value `None`

The option type is very useful when lack of data is better handled as a special value (_i.e.,_ `None`) rather than an exception. It is the type-safe version of returning error values such as in C, for instance. Since no data has any special meaning, confusion between regular values and absence of value is impossible. In computer science, this type is called the [option
type](https://en.wikipedia.org/wiki/Option_type). OCaml has supported `option` since its inception.

## Exceptions _vs_ Options

The function `Sys.getenv : string -> string` from the OCaml standard library
allows us to query the value of an environment variable; however, it throws an exception if the variable is not defined. On the other hand, the function
`Sys.getenv_opt : string -> string option` does the same, except it returns
`None` as the variable is not defined. Here is what may happen if we try to
access an undefined environment variable:
```ocaml
# Sys.getenv "UNDEFINED_ENVIRONMENT_VARIABLE";;
Exception: Not_found.
# Sys.getenv_opt "UNDEFINED_ENVIRONMENT_VARIABLE";;
- : string option = None
```

See the [Error Handling](/docs/error-handling) for an longer discussion on error handling using options, exceptions and others means.

## The Standard Library `Option` Module

Most of the functions in this section as well as other useful ones are provided by the OCaml standard library in the [`Stdlib.Option`](https://ocaml.org/api/Option.html) supporting module.

### Map an Option

Using pattern-matching, it is possible to define functions, allowing users to easily work with option values. Here is `map` of type `('a -> 'b) -> 'a option -> 'b option`. It allows us to apply a function to the value wrapped inside an `option`, if present:
```ocaml
# let map f = function
  | None -> None
  | Some v -> Some (f v);;
val map : ('a -> 'b) -> 'a option -> 'b option = <fun>
```

`map` takes two parameters: the function `f` to be applied and an option value. `map f o` returns `Some (f v)` if `o` is `Some v` and `None` if `o` is `None`.

In the standard library, this is `Option.map`.

### Peel-Off Doubly Wrapped Options

Here is `join` of type `'a option option -> 'a option`. It peels off one layer from a doubly wrapped option:

```ocaml
# let join = function
  | Some Some v -> Some v
  | Some None -> None
  | None -> None;;
val join : 'a option option -> 'a option = <fun>
```
`join` takes a single `option option` parameter and returns an `option`
parameter.

In the standard library, this is `Option.join`.

### Access the Content of an Option

The function `get` of type `'a option -> 'a` allows access to the value contained inside an `option`.
```ocaml
# let get = function
  | Some v -> v
  | None -> raise (Invalid_argument "option is None");;
val get : 'a option -> 'a = <fun>
```
But beware, `get o` throws an exception if `o` is `None`. To access the content of an `option` without risking to raise an exception, the function `value` of type `'a option -> 'a -> 'a` can be used
```ocaml
# let value default = function
  | Some v -> v
  | None -> default;;
val value : 'a -> 'a option -> 'a = <fun>
```
However it takes a default value as an additional parameter.

In the standard library, these function are `Option.get` and `Option.value`. The latter is defined using a labelled parameter:
```ocaml
# Option.value;;
- : 'a option -> default:'a -> 'a = <fun>
```

### Fold an Option

The function `fold` of type `fold : ('a -> 'b) -> 'b -> 'a option -> 'b` combines `map` and `value`
```ocaml
# let fold f default o = o |> Option.map f |> value default;;
val fold : ('a -> 'b) -> 'b -> 'a option -> 'b = <fun>
```

The `fold` function can be used to implement a fall-back logic without writing pattern matching. For instance, here is a function that turns the contents of the `$PATH` environment variable into a list of strings, or the empty list if undefined. This version is using pattern-matching.
```ocaml
# let path () =
    let opt = Sys.getenv_opt "PATH" in
    match opt with
    | Some s -> String.split_on_char ':' s
    | None -> [];;
val path : unit -> string list = <fun>
```

This versions calls `fold`.
```ocaml
# let path () = Sys.getenv_opt "PATH" |> fold (String.split_on_char ':') [];;
val path : unit -> string list = <fun>
```

In the standard library, this function is defined using labelled arguments:
```ocaml
# Option.fold;;
- : none:'a -> some:('b -> 'a) -> 'b option -> 'a = <fun>
```

### Unfold an Option

To build a function going the other way round, which creates an `option` one can define `unfold` of type `('a -> bool) -> ('a -> 'b) -> 'a -> 'b option` the following way:
```ocaml
# let unfold p f x =
    if p x then
      Some (f x)
    else
      None;;
val unfold : ('a -> bool) -> ('a -> 'b) -> 'a -> 'b option = <fun>
```

This does not exist in the standard library.

### Bind an Option

The `bind` function of type `'a option -> ('a -> 'b option) -> 'b option` works like `map`. But whilst `map` expects a function-as-parameter `f` that returns an unwrapped value of type `b`, `bind` expects a function-as-parameter `f` that returns a value already wrapped in a option `'b option`.

In other words, `Option.bind` is the same as this:
```ocaml
# let bind o f = Option.(o |> map f |> join);;
```

## Conclusion

By the way, any type where `map` and `join` functions can be implemented, with similar behaviour, can be called a _monad_, and `option` is often used to introduce monads. But don't freak out! You absolutely don't need to know what a monad is to use the `option` type.

