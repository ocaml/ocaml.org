---
id : labels
title: Labelled and Optional Arguments
description: >
  Provide labels to your functions arguments
category: "Introduction"
---

# Labelled and Optional Arguments

It is possible to give names and default values to function parameters. This is broadly known as labels. In this tutorial, we learn how to use labels.

Throughout this tutorial, the code is written in UTop. In this document, to distinguish them, parameters that are not labelled are called _positional parameters_.

**Prerequisites**: [Values and Functions](/docs/values-and-functions)

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

# Option.value ~default:42 None
- : int = 42
```

## Defining Labelled Parameters

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

Optional arguments can be omitted; when passed a tilde `~` or a question mark `?` must be used. They can be placed at any position and in any order. How to define functions with optional parameters will be covered in the next sections.
```ocaml
# let sum ?(init = 0) u = List.fold_left ( + ) init;;
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

<!--
```ocaml
# let log ?(base = 10.) x = log10 x /. log10 base;;
val log : ?base:float -> float -> float = <fun>

# let get_ok ?(exn = fun _ -> Invalid_argument "result is Error _") = function
    | Ok v -> v
    | Error e -> raise (exn e);;
val get_ok : ?exn:('a -> exn) -> ('b, 'a) result -> 'b = <fun>

# let get_ok ?(exn = fun _ -> Invalid_argument "result is Error _") =
    Result.fold ~ok:Fun.id ~error:(fun e -> raise (exn e))
-->

## Defining Optional Parameters With Default Values

When defining a function, optional arguments are declared using `?`:
```ocaml
# let rec range ?step:(x=1) lo hi =
    if lo > hi then []
    else lo :: range ~step:x (lo + x) hi;;
val range : ?step:int -> int -> int -> int list = <fun>
```

In this case, `?step:(x=1)` means that `~step` is an optional parameter that defaults to 1. Inside the function, the parameter is named `x`.

Here is how this is used:
```ocaml
# range 1 10;;
- : int list = [1; 2; 3; 4; 5; 6; 7; 8; 9; 10]

# range 1 10 ~step:2;;
- : int list = [1; 3; 5; 7; 9]
```

It is possible to use the same name for the parameter and label name.
```ocaml
# let rec range ?(step=1) lo hi =
  if lo > hi then []
  else lo :: range ~step (lo + step) hi;;
val range : ?step:int -> int -> int -> int list = <fun>
```

This is the same as if we had written `?step:(step=1)`.

## Defining Optional Parameter Without Default Values

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
* `s` is the string which we are extracting a substring from
* `pos` is the starting position of the substring, it defaults to `0`
* `len` is the length of the substring. If missing, it defaults to `String.length s - pos`

When an optional parameter isn't given a default value, its type inside the function is made an `option`. Here, `len` appears as an `int` in the type of `sub` but appears as an `int option` inside, it is the type of `len_opt`. It is not possible to specify the default value of `len` when declaring it, therefore it doesn't have a default value.

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

Let's compare two possible variants of the `String.concat` function from the standard library which has type `string -> string list -> string`. Both variants make the separator (the first positional parameter in `String.concat`) an optional parameter with the empty string `""` as the default value. The only difference between the two versions is the order in which the parameters are declared.

In the first version, the optional separator is the last declared parameter.
```ocaml
# let concat_warn ss ?(sep="") = String.concat sep ss;;
Line 1, characters 15-18:
  Warning 16 [unerasable-optional-argument]:
  this optional argument cannot be erased.
val concat_warn : string list -> ?sep:string -> string = <fun>

# concat_warn ~sep:"; " ["a"; "b"; "c"];;
- : string = "a; b; c"

# concat_warn ~sep:"";;
- : string list -> string

# concat_warn ["a"; "b"; "c"];;
- : ?sep:string -> string = <fun>
```

In the second version, the optional separator is the first declared parameter.
```ocaml
# let concat ?(sep="") ss = String.concat sep ss;;
val concat : ?sep:string -> string list -> string = <fun>

# concat ["a"; "b"; "c"] ~sep:", ";;
- : string = "a, b, c"

# concat ~sep:"";;
- : string list -> string = <fun>
t
# concat ["a"; "b"; "c"];;
- : string = "abc"
```

Both functions behave the same, except when only applied to the argument `["a"; "b"; "c"]`. In that case:
- `concat` returns `"abc"`, the default value `""` of `~sep` is passed.
- `concat_warn` returns a partially applied function of type `?sep:string -> string`, the default value is not passed.

Most often, what is needed is the second version. Therefore a function's last declared parameter shouldn't be optional. The warning suggests turning `concat_warn` into `concat`. Disregarding it exposes a function with an optional parameter that must be provided, which is contradictory.

**Note**: Optional parameters make it difficult for the compiler to know if a function is partially applied or not. This is why at least one positional parameter is required after the optional ones. If present at application, it means the function is fully applied, if missing, it means the function is partially applied.

## Function with Only Optional Arguments

When all parameters of a function need to be optional, a dummy, positional and occurring last parameter must be added. The unit value comes in handy for this. This is what is done here.
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

Without this unit parameter, the `optional argument cannot be erased` warning would be emitted.

## Forwarding an Optional Argument

Passing an optional argument with a question mark sign `?` allows forwarding it without unwrapping. These examples reuse the `sub` function defined in the [Optional Arguments Without Default Values](#optional-arguments-without-default-values) section.
```ocaml
# let prefix ?len s = sub ?len s;;
val prefix : ?len:int -> string -> string = <fun>

# prefix "immutability" ~len:2;;
- : string = "im"

# let postfix ?off s = sub ?pos:off s;;
val postfix : ?off:int -> string -> string = <fun>

# postfix "immutability" ~off:7;;
- : string = "ility"
```

In the definitions of `prefix` and `postfix`, the function `sub` is called with optional arguments prefixed with question marks.

In `prefix` the optional argument has the same name as in `sub`, writing `?len` is sufficient to forward without unwrapping.

## Conclusion

Functions can have named or optional parameters. However, OCaml does not support [variadic](https://en.wikipedia.org/wiki/Variadic_function) functions. Refer to the [reference manual](/htmlman//lablexamples.html) for more examples and details on labels.