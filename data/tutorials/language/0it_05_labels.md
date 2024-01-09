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

## Labelled Arguments

OCaml also has a way to label arguments and have optional arguments with
default values.

Here is the basic syntax:
```ocaml
# let rec range ~first:lo ~last:hi =
  if lo > hi then []
  else lo :: range ~first:(lo + 1) ~last:hi;;
val range : first:int -> last:int -> int list = <fun>
```

The arguments of `range` have:
- Internal names `lo` and `hi`
- External names `first` and `last`, these are the labels.

Notice that both `to` and `end` are reserved words in OCaml, so they
cannot be used.

The `~` (tilde) is not shown in the type definition, but
you need to use it everywhere else.

With labelled arguments, it doesn't matter which order you give the
arguments:
```ocaml
# range ~first:1 ~last:10;;
- : int list = [1; 2; 3; 4; 5; 6; 7; 8; 9; 10]

# range ~last:10 ~first:1;;
- : int list = [1; 2; 3; 4; 5; 6; 7; 8; 9; 10]
```

There is also a shorthand way to name the arguments so that the label
matches the variable in the function definition:
```ocaml
# let may ~f x =
  match x with
  | None -> ()
  | Some x -> ignore (f x);;
val may : f:('a -> 'b) -> 'a option -> unit = <fun>
```

It's worth spending some time working out exactly what this function
does, and also working out its type signature by hand.

First of all, the parameter `~f` is just shorthand for `~f:f`
(i.e., the label is `~f` and the variable used in the function is `f`).
Secondly, notice that the function takes two parameters. The second
parameter (`x`) is unlabelled. It is permitted for a function to take a
mixture of labelled and unlabelled arguments.

**BEGIN WTF**

What is the type of the labelled `f` parameter? Obviously it's a
function of some sort.

What is the type of the unlabelled `x` parameter? The `match` clause
gives us a clue. It's an `'a option`.

This tells us that `f` takes an `'a` parameter, and the return value of
`f` is ignored, so it could be anything. The type of `f` is therefore
`'a -> 'b`.

The `may` function as a whole returns `unit`. Notice in each case of the
`match` the result is `()`.

Thus the type of the `may` function is (you can verify this in the
OCaml interactive toplevel if you want):
```ocaml
# may;;
- : f:('a -> 'b) -> 'a option -> unit = <fun>
```
What does this function do? Running the function in the OCaml toplevel
gives us some clues:
```ocaml
# may ~f:print_endline None;;
- : unit = ()
# may ~f:print_endline (Some "hello");;
hello
- : unit = ()
```

If the unlabelled argument is a “null pointer” then `may` does nothing.
Otherwise, `may` calls the `f` function on the argument.

Why is this useful? We're just about to find out...

**END WTF**

## Optional Arguments With Default Values

Optional arguments are like labelled arguments, but we use `?` instead
of `~` in front when declaring them. Here is an example:
```ocaml
let rec range ?step:(x=1) lo hi =
  if lo > hi then []
  else lo :: range ~step:x (lo + x) hi;;
val range : ?step:int -> int -> int -> int list = <fun>
```

In this case, `?step:(x=1)` means that `~step` is an optional argument which defaults to 1.

Here is how this is used.
```ocaml
# range 1 10;;
- : int list = [1; 2; 3; 4; 5; 6; 7; 8; 9; 10]

# range 1 10 ~step:2;;
- : int list = [1; 3; 5; 7; 9]
```

Note the somewhat confusing syntax switching between `?` and `~`. Use a question mark when declaring an optional parameter; use a tilde when passing a value to a labelled parameter or specifying a value to an optional parameter.

Here, `step` is the label (the external name), `x` is the parameter name (the internal name), and `1` is the default value.

It is possible to use the same name for the parameter and label names.
```ocaml
# let rec range ?(step=1) lo hi =
  if lo > hi then []
  else lo :: range ~step (lo + step) hi;;
val range : ?step:int -> int -> int -> int list = <fun>
```

This is the same as if we had written `?step:(step=1)`.

## Optional Arguments Without Default Values

An optional argument can be declared without specifying a default value.
```ocaml
# let sub ?(pos=0) ?len:(len_opt) s =
    let default = String.length s - pos in
    let len = Option.value ~default len_opt in
    String.sub s pos len;;
val sub : ?pos:int -> ?len:int -> string -> string = <fun>
```

Here, we're defining a variant of the function `String.sub` from the standard library.
* `s` is the string which we are extracting a substring from
* `pos` is the starting position of the substring, it defaults to `0`
* `len` is the length of the substring. If missing, it defaults to `String.length s - pos`

When an optional argument isn't given a default value, its internal type is made an `option`. Here, `len` appears as an `int` in the type of `sub` but appears as an `int option` inside, it is the type of `len_opt`.

The default value of `len` depends on the actual value of `pos`, therefore it is specified without a default value.

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

Optional arguments can be applied in any order and any position.

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
# let hello_warn ?(who="world") () = "hello " ^ who;;
val hello_warn : ?who:string -> string = <fun>

# hello_warn;;
- : ?who:string -> unit -> string = <fun>

# hello_warn ();;
- : string = "hello world"

# hello_warn ~who:"sabine";;
- : unit -> string = <fun>

# hello_warn ~who:"sabine" ();;
- : string = "hello sabine"
```

Without this unit parameter, the `optional argument cannot be erased` warning would be emitted.

## Forwarding an Optional Argument

When defining a function with an optional parameter, it is possible to forward it as an argument to another function without unwrapping its option value. These examples reuse the `sub` function defined in the [Optional Arguments Without Default Values](#optional-arguments-without-default-values) section.
```ocaml
# let prefix ?len s = sub ?len s;;
val prefix : ?len:int -> string -> string = <fun>

# prefix "immutability" ~len:2;;
- : string = "im"

# let postfix ?off s = sub ?pos:(off) s;;
val postfix : ?off:int -> string -> string = <fun>

# postfix "immutability" ~off:7;;
- : string = "ility"
```

In the definitions of `prefix` and `postfix`, the function `sub` is called with optional arguments prefixed with question marks. Here is how this syntactic sugar works:
* `sub ?len s` turns into: `match len with Some x -> sub ~len:x s | _ -> sub s`
* `sub ?pos:(off) s` turns into: `match off with Some x -> sub ~pos:x s | _ -> sub s`

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
