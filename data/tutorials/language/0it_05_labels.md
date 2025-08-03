---
id : labels
title: Labelled and Optional Arguments
description: >
  Provide labels to your functions arguments
category: "Introduction"
language: English
prerequisite_tutorials:
  - "values-and-functions"
---

It is possible to give names and default values to function parameters. This is broadly known as labels. In this tutorial, we learn how to use labels.

Throughout this tutorial, the code is written in UTop. In this document parameters that are not labelled are called _positional parameters_.

## Passing Labelled Arguments

The function `Option.value` from the standard library has a parameter labelled `default`.

```ocaml
# Option.value;;
- : 'a option -> default:'a -> 'a = <fun>
```

Labelled arguments are passed using a tilde `~` and can be placed at any position and in any order.

```ocaml
# Option.value (Some 10) ~default:42;;
- : int = 10

# Option.value ~default:42 (Some 10);;
- : int = 10

# Option.value ~default:42 None;;
- : int = 42
```

**Note**: Passing labelled arguments through the pipe operator (`|>`) throws a syntax error:

```ocaml
# ~default:42 |> Option.value None;;
Error: Syntax error
```

## Labelling Parameters

Here is how to name parameters in a function definition:

```ocaml
# let rec range ~first:lo ~last:hi =
    if lo > hi then []
    else lo :: range ~first:(lo + 1) ~last:hi;;
val range : first:int -> last:int -> int list = <fun>
```

The parameters of `range` are named
- `lo` and `hi` inside the function's body, as usual
- `first` and `last` when calling the function; these are the labels.

Here is how `range` is used:

```ocaml
# range ~first:1 ~last:10;;
- : int list = [1; 2; 3; 4; 5; 6; 7; 8; 9; 10]

# range ~last:10 ~first:1;;
- : int list = [1; 2; 3; 4; 5; 6; 7; 8; 9; 10]
```

It is possible to use a shorter syntax when using the same name as label and parameter.

```ocaml
# let rec range ~first ~last =
    if first > last then []
    else first :: range ~first:(first + 1) ~last;;
val range : first:int -> last:int -> int list = <fun>
```

At parameter definition `~first` is the same as `~first:first`. Passing argument `~last` is the same as `~last:last`.

## Passing Optional Arguments

Optional arguments can be omitted. When passed, a tilde `~` or a question mark `?` must be used. They can be placed at any position and in any order.

```ocaml
# let sum ?(init=0) u = List.fold_left ( + ) init u;;
val sum : ?init:int -> int list -> int = <fun>

# sum [0; 1; 2; 3; 4; 5];;
- : int = 15

# sum [0; 1; 2; 3; 4; 5] ~init:100;;
- : int = 115
```

It is also possible to pass optional arguments as values of type `option`. This is done using a question mark when passing the argument.

```ocaml
# sum [0; 1; 2; 3; 4; 5] ?init:(Some 100);;
- : int = 115

# sum [0; 1; 2; 3; 4; 5] ?init:None;;
- : int = 15
```

## Defining Optional Parameters With Default Values

In the previous section, we've defined a function with an optional parameter without explaining how it works. Let's look at a different variant of this function:

```ocaml
# let sum ?init:(x=0) u = List.fold_left ( + ) x u;;
val sum : ?init:int -> int list -> int = <fun>
```

It behaves the same, but in this case, `?init:(x = 0)` means that `~init` is an optional parameter that defaults to 0. Inside the function, the parameter is named `x`.

The definition in the previous section used the shortcut that makes `?(init = 0)` the same as `?init:(init = 0)`.

<!--
```ocaml
# let log ?(base = 10.) x = log10 x /. log10 base;;
val log : ?base:float -> float -> float = <fun>

# let get_ok ?(exn = fun _ -> Invalid_argument "result is Error _") = function
    | Ok v -> v
    | Error e -> raise (exn e);;
val get_ok : ?exn:('a -> exn) -> ('b, 'a) result -> 'b = <fun>

# let get_ok ?(exn = fun _ -> Invalid_argument "result is Error _") =
    Result.fold ~ok:Fun.id ~error:(fun e -> raise (exn e));;
val get_ok : ?exn:('a -> exn) -> ('b, 'a) result -> 'b = <fun>
```
-->

## Defining Optional Parameters Without Default Values

<!-- TODO: consider list take instead -->

An optional parameter can be declared without specifying a default value.

```ocaml
# let sub ?(pos=0) ?len:len_opt s =
    let default = String.length s - pos in
    let length = Option.value ~default len_opt in
    String.sub s pos length;;
val sub : ?pos:int -> ?len:int -> string -> string = <fun>
```

Here, we're defining a variant of the function `String.sub` from the standard library.
* `s` is the string from which we are extracting a substring.
* `pos` is the substring's starting position. It defaults to `0`.
* `len` is the substring's length. If missing, it defaults to `String.length s - pos`.

When an optional parameter isn't given a default value, its type inside the function is made an `option`. Here, `len` appears as `?len:int` in the function signature. However, inside the body of the function, `len_opt` is an `int option`.

<!-- TODO: consider a simpler example without any logic or exmplain use-case -->

This enables the following usages:

```ocaml
# sub ~len:5 ~pos:2 "immutability";;
- : string = "mutab"

# sub "immutability" ~pos:7 ;;
- : string = "ility"

# sub ~len:2 "immutability";;
- : string = "im"

# sub "immutability";;
- : string = "immutability"
```

It is possible to use the same name for the `len` parameter and label name.

```ocaml
# let sub ?(pos=0) ?len s =
    let default = String.length s - pos in
    let length = Option.value ~default len in
    String.sub s pos length;;
val sub : ?pos:int -> ?len:int -> string -> string = <fun>
```

## Optional Arguments and Partial Application

Let's compare two possible variants of the `String.concat` function from the standard library which has type `string -> string list -> string`.

In the first version, the optional separator is the last declared parameter.

```ocaml
# let concat_warn ss ?(sep="") = String.concat sep ss;;
Line 1, characters 15-18:
  Warning 16 [unerasable-optional-argument]:
  this optional argument cannot be erased.
val concat_warn : string list -> ?sep:string -> string = <fun>

# concat_warn ~sep:"--" ["foo"; "bar"; "baz"];;
- : string = "foo--bar--baz"

# concat_warn ~sep:"";;
- : string list -> string

# concat_warn ["foo"; "bar"; "baz"];;
- : ?sep:string -> string = <fun>
```

In the second version, the optional separator is the first declared parameter.

```ocaml
# let concat ?(sep="") ss = String.concat sep ss;;
val concat : ?sep:string -> string list -> string = <fun>

# concat ["foo"; "bar"; "baz"] ~sep:"--";;
- : string = "foo--bar--baz"

# concat ~sep:"--";;
- : string list -> string = <fun>
t
# concat ["foo"; "bar"; "baz"];;
- : string = "foobarbaz"
```

The only difference between the two versions is the order in which the parameters are declared. Both functions behave the same, except when only applied to the argument `["foo"; "bar"; "baz"]`. In that case:
- `concat` returns `"foobarbaz"`. The default value `""` of `~sep` is passed.
- `concat_warn` returns a partially applied function of type `?sep:string -> string`. The default value is not passed.

Most often, `concat` is needed. Therefore a function's last declared parameter shouldn't be optional. The warning suggests turning `concat_warn` into `concat`. Disregarding it exposes a function with an optional parameter that must be provided, which is contradictory.

**Note**: Optional parameters make it difficult for the compiler to know if a function is partially applied or not. This is why at least one positional parameter is required after the optional ones. If present at application, it means the function is fully applied, if missing, it means the function is partially applied.


### Passing Labelled Arguments Using the Pipe Operator

Declaring a function's unlabelled argument as the first one simplifies reading the function's type and does not prevent passing this argument using the pipe operator.

Let's modify the `range` function previously defined by adding an additional parameter `step`.

```ocaml
# let rec range step ~first ~last = if first > last then [] else first :: range step ~first:(first + step) ~last;;
val range : int -> first:int -> last:int -> int list = <fun>

# 3 |> range ~last:10 ~first:1;;
- : int list = [1; 4; 7; 10]
```

## Function with Only Optional Arguments

When all parameters of a function need to be optional, a dummy, positional and occurring last parameter must be added. The unit `()` value comes in handy for this. This is what is done here.

```ocaml
# let hello ?(who="world") () = "hello, " ^ who;;
val hello : ?who:string -> string = <fun>

# hello;;
- : ?who:string -> unit -> string = <fun>

# hello ();;
- : string = "hello, world"

# hello ~who:"sabine";;
- : unit -> string = <fun>

# hello ~who:"sabine" ();;
- : string = "hello, sabine"

# hello () ?who:None;;
- : string = "hello, world"

# hello ?who:(Some "christine") ();;
- : string = "hello, christine"
```

Without the unit parameter, the `optional argument cannot be erased` warning would be emitted.

## Forwarding an Optional Argument

Passing an optional argument with a question mark sign `?` allows forwarding it without unwrapping. These examples reuse the `sub` function defined in the [Optional Arguments Without Default Values](#optional-arguments-without-default-values) section.

```ocaml
# let take ?len s = sub ?len s;;
val take : ?len:int -> string -> string = <fun>

# take "immutability" ~len:2;;
- : string = "im"

# let rtake ?off s = sub ?pos:off s;;
val rtake : ?off:int -> string -> string = <fun>

# rtake "immutability" ~off:7;;
- : string = "ility"
```

In the definitions of `take` and `rtake`, the function `sub` is called with optional arguments passed with question marks.

In `take` the optional argument has the same name as in `sub`; writing `?len` is sufficient to forward without unwrapping.

## Conclusion

Functions can have named or optional parameters. Refer to the [reference manual](/manual/lablexamples.html) for more examples and details on labels.
