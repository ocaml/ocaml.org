---
id : labels
title: Labelled and Optional Arguments
description: >
  Provide labels to your functions arguments
category: "Introduction"
---

# Labelled and Optional Arguments

It is possible to give names and default values to function parameters. This is broadly known as labels. In this tutorial, we learn how to use labels.

Throughout this tutorial, the code is written in UTop.

**Prerequisites**: [Values and Functions](/docs/values-and-functions)

## Passing Labelled Parameters

The function `Option.value` from the standard library has an argument labelled `default`.
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

Here is how to name arguments in a function definition:
```ocaml
# let rec range ~first:lo ~last:hi =
    if lo > hi then []
    else lo :: range ~first:(lo + 1) ~last:hi;;
val range : first:int -> last:int -> int list = <fun>
```

The arguments of `range` are named
- `lo` and `hi` inside the function's body, as usual
- `first` and `last` when calling the function; these are the labels.

Here is how `range` is used:
```ocaml
# range ~first:1 ~last:10;;
- : int list = [1; 2; 3; 4; 5; 6; 7; 8; 9; 10]

# range ~last:10 ~first:1;;
- : int list = [1; 2; 3; 4; 5; 6; 7; 8; 9; 10]
```

## Passing Optional Parameters

Optional arguments are passed using a tilde `~` or a question mark `?`. They can be placed at any position and in any order.

```ocaml
# let dummy ?(num = 42) txt = (num, "hello, " ^ txt);;
val dummy : ?num:int -> string -> int * string = <fun>
```

```ocaml
# dummy "world";;
- : int * string = (42, "hello, world")


dummy "world";;
- : string = "hello, world"

# dummy "hello" ~who:"sabine";;
- : string = "bonjour, sabine"
```

```ocaml
# dummy "bonjour" ?hi:(Some "hola") "christine";;
- : string = "bonjour, christine"

# dummy "christine";;
- : string = "bonjour christine"
```

## Defining Optional Parameters With Default Values

When defining a function, optional arguments are declared using `?`:
```ocaml
let rec range ?step:(x=1) lo hi =
  if lo > hi then []
  else lo :: range ~step:x (lo + x) hi;;
val range : ?step:int -> int -> int -> int list = <fun>
```

In this case, `?step:(x=1)` means that `~step` is an optional argument that defaults to 1 and inside the function, its name is `x`.

Here is how this is used:
```ocaml
# range 1 10;;
- : int list = [1; 2; 3; 4; 5; 6; 7; 8; 9; 10]

# range 1 10 ~step:2;;
- : int list = [1; 3; 5; 7; 9]
```

Here, `step` is the label used when calling the function, `x` is the parameter name used inside the function, and `1` is the default value.

It is possible to use the same name for the parameter and label name.
```ocaml
# let rec range ?(step=1) lo hi =
  if lo > hi then []
  else lo :: range ~step (lo + step) hi;;
val range : ?step:int -> int -> int -> int list = <fun>
```

This is the same as if we had written `?step:(step=1)`.

## Defining Optional Arguments Without Default Values

<!-- TODO: consider list take instead -->

An optional argument can be declared without specifying a default value.
```ocaml
# let sub ?(pos=0) ?len:len_opt s =
    let default = String.length s - pos in
    let len = Option.value ~default len_opt in
    String.sub s pos len;;
val sub : ?pos:int -> ?len:int -> string -> string = <fun>
```

Here, we're defining a variant of the function `String.sub` from the standard library.
* `s` is the string which we are extracting a substring from
* `pos` is the starting position of the substring, it defaults to `0`
* `len` is the length of the substring. If missing, it defaults to `String.length s - pos`

When an optional argument isn't given a default value, its type inside the function is made an `option`. Here, `len` appears as an `int` in the type of `sub` but appears as an `int option` inside, it is the type of `len_opt`.

The default value of `len` depends on the actual value of `pos`, therefore it is specified without a default value.

The `len` parameter is specified without a default value. This is because no constant value can be defined in advance.

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

## Optional Arguments and Partial Application

Let's compare two possible variants of the `String.concat` function from the standard library which has type `string -> string list -> string`. Both variants make the separator (the first argument) an optional argument with the empty string `""` as the default value. The only difference between the two versions is the order in which the arguments are declared.

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

Both functions behave the same, except when only applied to the parameter `["a"; "b"; "c"]`. In that case:
- `concat` returns `"abc"`, the optional argument `~sep` is applied with the default value `""`.
- `concat_warn` returns a partially applied function of type `?sep:string -> string`, the optional argument is not applied.

Most often, what is needed is the latter behaviour, therefore a function's last declared parameter shouldn't be optional. The warning suggests turning `concat_warn` into `concat`. Disregarding it exposes a function with an optional argument that must be passed, which is contradictory.

## Function with Only Optional Arguments

When all parameters of a function need to be optional, a dummy, non-optional and occurring last parameter must be added. The unit value comes in handy for this. This is what is done here.
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

When defining a function with an optional parameter, the question mark sign `?` allows to forward it to another function without unwrapping. These examples reuse the `sub` function defined in the [Optional Arguments Without Default Values](#optional-arguments-without-default-values) section.
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

In the definitions of `prefix` and `postfix`, the function `sub` is called with optional arguments prefixed with question marks. Here is how this syntactic sugar works:
* `sub ?len s` turns into: `match len with Some x -> sub ~len:x s | _ -> sub s`
* `sub ?pos:off s` turns into: `match off with Some x -> sub ~pos:x s | _ -> sub s`

In `prefix` the optional argument has the same name as in `sub`, writing `?len` is sufficient to forward without unwrapping.

## Foo

```ocaml
# let foo ~bar = match bar with Some x -> x * x | _ -> 42;;
```

# Labels and The Standard Library

- https://v2.ocaml.org/releases/5.1/api/StdLabels.html
  - https://v2.ocaml.org/releases/5.1/api/ArrayLabels.html
  - https://v2.ocaml.org/releases/5.1/api/BytesLabels.html
  - https://v2.ocaml.org/releases/5.1/api/ListLabels.html
  - https://v2.ocaml.org/releases/5.1/api/StringLabels.html
- https://v2.ocaml.org/releases/5.1/api/MoreLabels.html
  - https://v2.ocaml.org/releases/5.1/api/MoreLabels.Hashtbl.html
  - https://v2.ocaml.org/releases/5.1/api/MoreLabels.Map.html
  - https://v2.ocaml.org/releases/5.1/api/MoreLabels.Set.html
- https://v2.ocaml.org/releases/5.1/api/UnixLabels.html

## When and When Not to Use `~` and `?`
The syntax for labels and optional arguments is confusing, and you may
often wonder when to use `~foo`, when to use `?foo`, and when to use
plain `foo`. It's something of a black art that takes practice to get
right.

`?foo` is only used when declaring the arguments of a function, i.e.,:

<!-- $MDX skip -->
```ocaml
let f ?arg1 ... =
```

or when using the specialised "unwrap `option` wrapper" form for
function calls:

```ocaml
# let open_application ?width ?height () =
  open_window ~title:"My Application" ?width ?height;;
val open_application : ?width:int -> ?height:int -> unit -> unit -> window =
  <fun>
```
The declaration `?foo` creates a variable called `foo`, so if you need
the value of `?foo`, use just `foo`.

The same applies to labels. Only use the `~foo` form when declaring
arguments of a function, i.e.,:

<!-- $MDX skip -->
```ocaml
let f ~foo:foo ... =
```

The declaration `~foo:foo` creates a variable called simply `foo`, so if
you need the value just use plain `foo`.

However, things get complicated for two reasons: first, the shorthand
form `~foo` (equivalent to `~foo:foo`), and second, when you call a
function that takes a labelled or optional argument using the
shorthand form.

Here is some apparently obscure code from LablGTK to demonstrate all of
this:

<!-- $MDX skip -->
```ocaml
# let html ?border_width ?width ?height ?packing ?show () =  (* line 1 *)
  let w = create () in
  load_empty w;
  Container.set w ?border_width ?width ?height;            (* line 4 *)
  pack_return (new html w) ~packing ~show                  (* line 5 *);;
```
On line 1, we have the function definition. Notice there are 5 optional
arguments and the mandatory `unit` 6<sup>th</sup> argument. Each of the
optional arguments is going to define a variable, e.g., `border_width` of
type `'a option`.

On line 4, we use the special `?foo` form for passing optional arguments
to functions that take optional arguments. `Container.set` has the
following type:

<!-- $MDX skip -->
```ocaml
module Container = struct
  let set ?border_width ?(width = -2) ?(height = -2) w =
    (* ... *)
```
Line 5 uses the `~`shorthand. Let's write this in long form:

```ocaml
# pack_return (new html w) ~packing:packing ~show:show;;
Line 1, characters 1-12:
Error: Unbound value pack_return
```

The `pack_return` function actually takes mandatory labelled arguments
called `~packing` and `~show`, each of type `'a option`. In other words,
`pack_return` explicitly unwraps the `option` wrapper.
