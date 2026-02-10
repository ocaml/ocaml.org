---
id: options
title: Options
description: >
  Add nothing-as-value to anything to avoid confusion between something and “no such thing“.
category: "Data Structures"
---

## Introduction

An [option](https://en.wikipedia.org/wiki/Option_type) value wraps another value or contains nothing if there isn't anything to wrap. The predefined variant type `option` represents such values.

<!-- $MDX non-deterministic=command -->
```ocaml
# #show option;;
type 'a option = None | Some of 'a
```

Here are examples of option values:

```ocaml
# Some 42;;
- : int option = Some 42

# None;;
- : 'a option = None
```

Here we have:
* 42, stored inside an `option` using the `Some` constructor and
* the `None` value, which doesn't store anything.

The option type is useful when the lack of data is better handled as the special value `None` rather than an exception. It is the type-safe version of returning error values. Since data wrapped in an option has a special meaning, confusion between values and the absence of values is impossible.

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

Most of the functions in this section, as well as other useful ones, are provided by the OCaml standard library in the [`Stdlib.Option`](/manual/api/Option.html) module.

### Map Over an Option

Using pattern matching, it is possible to define functions, allowing us to work with option values. For example, let's define a custom `map` function of type `('a -> 'b) -> 'a option -> 'b option` that allows us to apply a function to the wrapped value inside an `option` (if present):

```ocaml
let map f = function
  | None -> None
  | Some v -> Some (f v)
```

Our custom `map` function is the same as the standard library's `Option.map`:

```ocaml
# Option.map (fun x -> x * x) (Some 3);;
- : int option = Some 9

# Option.map (fun x -> x * x) None;;
- : int option : None
```

The following are a few simple examples demonstrating how the `Option.map` function works with different types and transformations:

**Example 1**: Incrementing an Integer

If there is a value inside `Some`, it gets incremented. If `None`, it remains `None`.

```ocaml
# Option.map (fun x -> x + 1) (Some 5);;
- : int option = Some 6

# Option.map (fun x -> x + 1) None;;
- : int option = None
```

**Example 2**: Extracting the First Character of a String

If there is a string inside `Some`, it extracts the first character. If `None`, it stays `None`.

```ocaml
# Option.map (fun s -> String.get s 0) (Some "hello");;
- : char option = Some 'h'

# Option.map (fun s -> String.get s 0) None;;
- : char option = None
```

**Example 3**: Doubling Each Element in an Option of a List

Here, `map` is applied to a list inside `Some`, doubling each number. If `None`, the list transformation doesn't occur.

```ocaml
# Option.map (List.map (fun x -> x * 2)) (Some [1; 2; 3]);;
- : int list option = Some [2; 4; 6]

# Option.map (List.map (fun x -> x * 2)) None;;
- : int list option = None
```

### Peel Off Doubly Wrapped Options

Sometimes we may encounter a value that is wrapped in multiple options. Let's define a custom `join` function of type `'a option option -> 'a option` that peels off one layer from a doubly wrapped option:

```ocaml
let join = function
  | Some Some v -> Some v
  | Some None -> None
  | None -> None
```

Our custom `join` function is the same as the standard library's `Option.join`:

```ocaml
# Option.join (Some (Some 42));;
- : int option = Some 42

# Option.join (Some None);;
- : 'a option = None

# Option.join None;;
- : 'a option = None
```

Here are additional examples demonstrating how `Option.join` works in different scenarios:

**Example 1**: Removing One Layer of Wrapping

If `Some (Some v)`, `join` extracts `v` and returns `Some v`. If `Some None` or `None`, it returns `None`.

```ocaml
# Option.join (Some (Some "hello"));;
- : string option = Some "hello"

# Option.join (Some None);;
- : 'a option = None

# Option.join None;;
- : 'a option = None
```

**Example 2**: Nested Option with a Computation

Here, `safe_divide` may return `Some` or `None`. `Option.join` ensures we don’t get `Some None`.

```ocaml
# let safe_divide x y = if y = 0 then None else Some (x / y);;
val safe_divide : int -> int -> int option = <fun>

# Option.join (Some (safe_divide 10 2));;
- : int option = Some 5

# Option.join (Some (safe_divide 10 0));;
- : int option = None

# Option.join None;;
- : int option = None
```

### Extract the Content of an Option

We will also want to extract the contents of a value wrapped in an option. Let's define a custom `get` function of type `'a option -> 'a` that allows us to access the value contained inside an `option`:

```ocaml
# let get = function
    | Some v -> v
    | None -> raise (Invalid_argument "option is None");;
val get : 'a option -> 'a = <fun>
```

Beware, `get o` throws an exception if `o` is `None`. To access the content of an `option` without the risk of raising an exception, the function `value` of type `'a option -> 'a -> 'a` can be used:

```ocaml
# let value opt ~default = match opt with
    | Some v -> v
    | None -> default;;
val value : 'a option -> default:'a -> 'a = <fun>
```

However, it needs a default value as an additional parameter.

In the standard library, these functions are `Option.get` and `Option.value`.

Here are examples demonstrating the usage of `Option.get` and `Option.value`:

**Example 1**: Extracting a Value with `Option.get`

```ocaml
# Option.get (Some 42);;
- : int = 42
```

The function successfully retrieves the value inside `Some 42`.

```ocaml
# Option.get None;;
Exception: Invalid_argument "Option.get".
```

Since `None` has no value, `Option.get` raises an exception.

**Example 2**: Extracting a Value with `Option.value` and a Default

```ocaml
# Option.value (Some "hello") ~default:"default";;
- : string = "hello"
```

The function returns `"hello"` because the option contains a value.

```ocaml
# Option.value None ~default:"default";;
- : string = "default"
```

Since the option is `None`, it returns the provided default value.

**Example 3**: Using `Option.value` for Safe Extraction

```ocaml
# let username = Some "alice";;
val username : string option = Some "alice"

# let display_name = Option.value username ~default:"Guest";;
val display_name : string = "alice"

# let missing_username = None;;
val missing_username : string option = None

# let display_name = Option.value missing_username ~default:"Guest";;
val display_name : string = "Guest"
```

These examples highlight the difference: `Option.get` is unsafe and raises an exception on `None`, while `Option.value` allows fallback behavior.

### Fold an Option

The function `fold` of type `none:'a -> some:('b -> 'a) -> 'b option -> 'a` can be seen as a combination of `map` and `value`:

```ocaml
let fold ~none ~some o = o |> Option.map some |> Option.value ~default:none
```

In the standard library, this function is `Option.bind`.

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

Here is the same function, using the standard library's `Option.fold`:

```ocaml
# let path () =
    let split_on_colon = String.split_on_char ':' in
    Sys.getenv_opt "PATH" |> Option.fold ~some:split_on_colon ~none:[];;
val path : unit -> string list = <fun>
```

The following are additional examples demonstrating the use of `Option.fold`:

**Example 1**: Applying a Function to `Some`, Using a Default for `None`

```ocaml
# Option.fold ~none:0 ~some:(fun x -> x * 2) (Some 5);;
- : int = 10
```
Since the option contains `Some 5`, `fold` applies the function `fun x -> x * 2`, resulting in `10`.

```ocaml
# Option.fold ~none:0 ~some:(fun x -> x * 2) None;;
- : int = 0
```

Since the option is `None`, `fold` returns the default value `0`.

**Example 2**: Extracting String Length or Defaulting to Zero
```ocaml
# let string_length_opt = Some "hello";;
val string_length_opt : string option = Some "hello"

# Option.fold ~none:0 ~some:String.length string_length_opt;;
- : int = 5
```

Here, `Option.fold` applies `String.length` to `"hello"`, returning `5`.

```ocaml
# let missing_string = None;;
val missing_string : string option = None

# Option.fold ~none:0 ~some:String.length missing_string;;
- : int = 0
```

Since `None` is given, it returns the default `0`.

**Example 3**: Handling Optional User Input

This function safely handles optional names by providing a fallback greeting:

```ocaml
# let greet name_opt =
    Option.fold ~none:"Hello, Guest!" ~some:(fun name -> "Hello, " ^ name ^ "!")
;;
val greet : string option -> string = <fun>

# greet (Some "Alice");;
- : string = "Hello, Alice!"

# greet None;;
- : string = "Hello, Guest!"
```

### Bind an Option

The `bind` function of type `'a option -> ('a -> 'b option) -> 'b option` works a bit like `map`. But whilst `map` expects a function parameter `f` that returns an unwrapped value of type `b`, `bind` expects a function `f` that returns a value already wrapped in an option `'b option`.

Let's try to implement a custom `bind` function:

```ocaml
# let bind o f =
  match o with
  | Some v -> (f v)
  | None -> None;;
val bind : 'a option -> ('a -> 'b option) -> 'b option = <fun>
```
In the standard library, this function is `Option.bind`.

The following are simple examples demonstrating the use of `Option.bind`:

**Example 1**: Safe Division

Here, `bind` ensures that division by zero safely returns `None` instead of raising an exception:

```ocaml
# let safe_div x y =
    if y = 0 then None else Some (x / y);;
val safe_div : int -> int -> int option = <fun>

# Option.bind (Some 10) (fun x -> safe_div x 2);;
- : int option = Some 5

# Option.bind (Some 10) (fun x -> safe_div x 0);;
- : int option = None

# Option.bind None (fun x -> safe_div x 2);;
- : int option = None
```

**Example 2**: Extracting and Transforming Nested Options

Here, `bind` is used to wrap a value returned by a function in an option:

```ocaml
# let find_user user_id =
    if user_id = 1 then Some "Alice" else None;;
val find_user : int -> string option = <fun>

# let user_to_email username =
    if username = "Alice" then Some "alice@example.com" else None;;
val user_to_email : string -> string option = <fun>

# Option.bind (find_user 1) user_to_email;;
- : string option = Some "alice@example.com"

# Option.bind (find_user 2) user_to_email;;
- : string option = None
```

Notice how the function `user_to_email` does not require explicit pattern-matching on the option returned by `find_user`. With `Option.bind`, we can let the `bind` function handle the unwrapping for us.

**Example 3**: Chaining Computations

This example retrieves a configuration value and ensures it falls within a valid range.

```ocaml
# let lookup_config key =
    if key = "timeout" then Some 30 else None;;
val lookup_config : string -> int option = <fun>

# let validate_timeout t =
    if t > 0 && t < 60 then Some t else None;;
val validate_timeout : int -> int option = <fun>

# Option.bind (lookup_config "timeout") validate_timeout;;
- : int option = Some 30

# Option.bind (lookup_config "unknown_key") validate_timeout;;
- : int option = None
```

## Conclusion

The `option` type in OCaml provides a powerful and type-safe way to represent values that may be absent, avoiding the pitfalls of exceptions. By leveraging functions such as `map`, `join`, `get`, `value`, `fold`, and `bind`, we can work with optional values in a structured and expressive manner. These utilities enable functional-style programming while maintaining safety and composability. The `Option` module in the standard library encapsulates these patterns, making it easier to write clear, concise, and robust code when dealing with optional values.
