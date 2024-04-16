---
id: options
title: Options
description: >
  Add nothing-as-value to anything to avoid confusion between something and “no such thing“.
category: "Data Structures"
---

## Introduction

An [option](https://en.wikipedia.org/wiki/Option_type) value wraps another value or contains nothing if there isn't anything to wrap. The predefined type `option` represents such values.
<!-- $MDX non-deterministic=command -->
```ocaml
# #show option;;
type 'a option = None | Some of 'a
```

Here are option values:
```ocaml
# Some 42;;
- : int option = Some 42

# None;;
- : 'a option = None
```

Here we have:
* 42, stored inside an `option` using the `Some` constructor and
* the `None` value, which doesn't store anything.

The option type is useful when the lack of data is better handled as the special value `None` rather than an exception. It is the type-safe version of returning error values. Since no wrapped data has any special meaning, confusion between regular values and the absence of value is impossible.

## Exceptions _vs_ Options

The function `Sys.getenv : string -> string` from the OCaml standard library queries the value of an environment variable; however, it throws an exception if the variable is not defined. On the other hand, the function `Sys.getenv_opt : string -> string option` does the same, except it returns `None` if the variable is not defined. Here is what may happen if we try to access an undefined environment variable:
```ocaml
# Sys.getenv "UNDEFINED_ENVIRONMENT_VARIABLE";;
Exception: Not_found.

# Sys.getenv_opt "UNDEFINED_ENVIRONMENT_VARIABLE";;
- : string option = None
```

See [Error Handling](/docs/error-handling) for a longer discussion on error handling using options, exceptions, and other means.

## The Standard Library `Option` Module

Most of the functions in this section, as well as other useful ones, are provided by the OCaml standard library in the [`Stdlib.Option`](/manual/latest/api/Option.html) module.

### Map Over an Option

Using pattern matching, it is possible to define functions, allowing to work with option values. Here is `map` of type `('a -> 'b) -> 'a option -> 'b option`. It allows to apply a function to the wrapped value inside an `option`, if present:
```ocaml
let map f = function
  | None -> None
  | Some v -> Some (f v)
```

In the standard library, this is `Option.map`.
```ocaml
# Option.map (fun x -> x * x) (Some 3);;
- : int option = Some 9

# Option.map (fun x -> x * x) None;;
- : int option : None
```

### Peel-Off Doubly Wrapped Options

Here is `join` of type `'a option option -> 'a option`. It peels off one layer from a doubly wrapped option:

```ocaml
let join = function
  | Some Some v -> Some v
  | Some None -> None
  | None -> None
```

In the standard library, this is `Option.join`.
```ocaml
# Option.join (Some (Some 42));;
- : int option = Some 42

# Option.join (Some None);;
- : 'a option = None

# Option.join None;;
- : 'a option = None
```

### Access the Content of an Option

The function `get` of type `'a option -> 'a` allows access to the value contained inside an `option`.
```ocaml
let get = function
  | Some v -> v
  | None -> raise (Invalid_argument "option is None")
```

Beware, `get o` throws an exception if `o` is `None`. To access the content of an `option` without the risk of raising an exception, the function `value` of type `'a option -> 'a -> 'a` can be used:
```ocaml
let value opt ~default = match opt with
  | Some v -> v
  | None -> default
```

However, it needs a default value as an additional parameter.

In the standard library, these functions are `Option.get` and `Option.value`.

### Fold an Option

The function `fold` of type `none:'a -> some:('b -> 'a) -> 'b option -> 'a` can be seen as a combination of `map` and `value`
```ocaml
let fold ~none ~some o = o |> Option.map some |> Option.value ~default:none
```

In the standard library, this function is `Option.fold`.

The `Option.fold` function can be used to implement a fall-back logic without writing pattern matching. For instance, here is a function that turns the contents of the `$PATH` environment variable into a list of strings, or the empty list if undefined. This version uses pattern matching:
```ocaml
# let path () =
    let split_on_colon = String.split_on_char ':' in
    let opt = Sys.getenv_opt "PATH" in
    match opt with
    | Some s -> split_on_colon s
    | None -> [];;
val path : unit -> string list = <fun>
```

Here is the same function, using `Option.fold`:
```ocaml
# let path () =
    let split_on_colon = String.split_on_char ':' in
    Sys.getenv_opt "PATH" |> Option.fold ~some:split_on_colon ~none:[];;
val path : unit -> string list = <fun>
```

### Bind an Option

The `bind` function of type `'a option -> ('a -> 'b option) -> 'b option` works a bit like `map`. But whilst `map` expects a function parameter `f` that returns an unwrapped value of type `b`, `bind` expects an `f` that returns a value already wrapped in an option `'b option`.

Here, we display the type of `Option.map`, with parameters flipped and show a possible implementation of `Option.bind`.
```ocaml
# Fun.flip Option.map;;
- : 'a option -> ('a -> 'b) -> 'b option = <fun>

# let bind o f = o |> Option.map f |> Option.join;;
val bind : 'a option -> ('a -> 'b option) -> 'b option = <fun>
```

Observe that the types are the same, except for the codomain of the function parameter.

## Conclusion

By the way, any type where `map` and `join` functions can be implemented, with similar behaviour, can be called a _monad_, and `option` is often used to introduce monads. But don't freak out! You don't need to know what a monad is to use the `option` type.

