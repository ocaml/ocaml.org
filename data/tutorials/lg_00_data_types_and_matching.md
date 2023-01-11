---
id: data-types
title: Data Types and Matching
description: >
  Learn to build custom types and write function to process this data
category: "language"
date: 2021-05-27T21:07:30-00:00
---

# Data Types and Matching

In this tutorial we learn how to build our own types in OCaml, and how to write
functions which process this new data.

## Built-in Compound Types

We have already seen simple data types such as `int`, `float`, `string`, and
`bool`.  Let's recap the built-in compound data types we can use in OCaml to
combine such values. First, we have lists which are ordered collections of any
number of elements of like type:

```ocaml
# [];;
- : 'a list = []
# [1; 2; 3];;
- : int list = [1; 2; 3]
# [[1; 2]; [3; 4]; [5; 6]];;
- : int list list = [[1; 2]; [3; 4]; [5; 6]]
# [false; true; false];;
- : bool list = [false; true; false]
```

Next, we have tuples, which collect a fixed number of elements together:

```ocaml
# (5.0, 6.5);;
- : float * float = (5., 6.5)
# (true, 0.0, 0.45, 0.73, "french blue");;
- : bool * float * float * float * string =
(true, 0., 0.45, 0.73, "french blue")
```

We have records, which are like labeled tuples. They are defined by writing a
type definition giving a name for the record, and names for each of its fields,
and their types:

```ocaml
# type point = {x : float; y : float};;
type point = { x : float; y : float; }
# let a = {x = 5.0; y = 6.5};;
val a : point = {x = 5.; y = 6.5}
# type colour = {websafe : bool; r : float; g : float; b : float; name : string};;
type colour = {
  websafe : bool;
  r : float;
  g : float;
  b : float;
  name : string;
}
# let b = {websafe = true; r = 0.0; g = 0.45; b = 0.73; name = "french blue"};;
val b : colour =
  {websafe = true; r = 0.; g = 0.45; b = 0.73; name = "french blue"}
```

A record must contain all fields:

```ocaml
# let c = {name = "puce"};;
Line 1, characters 9-24:
Error: Some record fields are undefined: websafe r g b
```

Records may be mutable:

```ocaml
# type person =
  {first_name : string;
   surname : string;
   mutable age : int};;
type person = { first_name : string; surname : string; mutable age : int; }
# let birthday p =
  p.age <- p.age + 1;;
val birthday : person -> unit = <fun>
```

Another mutable compound data type is the fixed-length array which, just as a
list, must contain elements of like type. However, its elements may be accessed
in constant time:

```ocaml
# let arr = [|1; 2; 3|];;
val arr : int array = [|1; 2; 3|]
# arr.(0);;
- : int = 1
# arr.(0) <- 0;;
- : unit = ()
# arr;;
- : int array = [|0; 2; 3|]
```

In this tutorial, we will define our own compound data types, using the `type`
keyword, and some of these built-in structures as building blocks.

## A Simple Custom Type

We can define a new data type `colour` which can take one of four values.

```ocaml env=colours
type colour = Red | Green | Blue | Yellow
```

Our new type is called `colour`, and has four *constructors* `Red`, `Green`,
`Blue` and `Yellow`. The name of the type must begin with a lower case letter,
and the names of the constructors with upper case letters. We can use our new
type anywhere a built-in type could be used:

```ocaml env=colours
# let additive_primaries = (Red, Green, Blue);;
val additive_primaries : colour * colour * colour = (Red, Green, Blue)
# let pattern = [(1, Red); (3, Green); (1, Red); (2, Green)];;
val pattern : (int * colour) list =
  [(1, Red); (3, Green); (1, Red); (2, Green)]
```

Notice the types inferred by OCaml for these expressions. We can pattern-match
on our new type, just as with any built-in type:

```ocaml env=colours
# let example c =
  match c with
  | Red -> "rose"
  | Green -> "grass"
  | Blue -> "sky"
  | Yellow -> "banana";;
val example : colour -> string = <fun>
```

Notice the type of the function includes the name of our new type `colour`. We
can make the function shorter and elide its parameter `c` by using the
alternative `function` keyword which allows direct matching:

```ocaml env=colours
# let example = function
  | Red -> "rose"
  | Green -> "grass"
  | Blue -> "sky"
  | Yellow -> "banana";;
val example : colour -> string = <fun>
```

We can match on more than one case at a time too:

```ocaml env=colours
# let rec is_primary = function
  | Red | Green | Blue -> true
  | _ -> false;;
val is_primary : colour -> bool = <fun>
```

## Constructors with Data

Each constructor in a data type can carry additional information with it. Let's
extend our `colour` type to allow arbitrary RGB triples, each element begin a
number from 0 (no colour) to 1 (full colour): 

```ocaml env=colours
# type colour =
  | Red
  | Green
  | Blue
  | Yellow
  | RGB of float * float * float;;
type colour = Red | Green | Blue | Yellow | RGB of float * float * float

# [Red; Blue; RGB (0.5, 0.65, 0.12)];;
- : colour list = [Red; Blue; RGB (0.5, 0.65, 0.12)]
```

Types, just like functions, may be recursively-defined. We extend our data type
to allow mixing of colours:

```ocaml env=colours
# type colour =
  | Red
  | Green
  | Blue
  | Yellow
  | RGB of float * float * float
  | Mix of float * colour * colour;;
type colour =
    Red
  | Green
  | Blue
  | Yellow
  | RGB of float * float * float
  | Mix of float * colour * colour
# Mix (0.5, Red, Mix (0.5, Blue, Green));;
- : colour = Mix (0.5, Red, Mix (0.5, Blue, Green))
```

Here is a function over our new `colour` data type:

```ocaml env=colours
# let rec rgb_of_colour = function
  | Red -> (1.0, 0.0, 0.0)
  | Green -> (0.0, 1.0, 0.0)
  | Blue -> (0.0, 0.0, 1.0)
  | Yellow -> (1.0, 1.0, 0.0)
  | RGB (r, g, b) -> (r, g, b)
  | Mix (p, a, b) ->
      let (r1, g1, b1) = rgb_of_colour a in
      let (r2, g2, b2) = rgb_of_colour b in
      let mix x y = x *. p +. y *. (1.0 -. p) in
        (mix r1 r2, mix g1 g2, mix b1 b2);;
val rgb_of_colour : colour -> float * float * float = <fun>
```

We can use records directly in the data type instead to label our components:

```ocaml env=colours
# type colour =
  | Red
  | Green
  | Blue
  | Yellow
  | RGB of {r : float; g : float; b : float}
  | Mix of {proportion : float; c1 : colour; c2 : colour};;
type colour =
    Red
  | Green
  | Blue
  | Yellow
  | RGB of { r : float; g : float; b : float; }
  | Mix of { proportion : float; c1 : colour; c2 : colour; }
```

## Example: Trees

Data types may be polymorphic as well as recursive. Here is an OCaml data type
for a binary tree carrying any kind of data:

```ocaml env=trees
# type 'a tree =
  | Leaf
  | Node of 'a tree * 'a * 'a tree;;
type 'a tree = Leaf | Node of 'a tree * 'a * 'a tree
# let t =
    Node (Node (Leaf, 1, Leaf), 2, Node (Node (Leaf, 3, Leaf), 4, Leaf));;
val t : int tree =
  Node (Node (Leaf, 1, Leaf), 2, Node (Node (Leaf, 3, Leaf), 4, Leaf))
```

Notice that we give the type parameter `'a` before the type name (if there is
more than one, we write `('a, 'b)` etc).  A `Leaf` holds no information,
just like an empty list. A `Node` holds a left tree, a value of type `'a`
and a right tree. In our example, we built an integer tree, but any type can be
used. Now we can write recursive and polymorphic functions over these trees, by
pattern matching on our new constructors:

```ocaml env=trees
# let rec total = function
  | Leaf -> 0
  | Node (l, x, r) -> total l + x + total r;;
val total : int tree -> int = <fun>
# let rec flip = function
  | Leaf -> Leaf
  | Node (l, x, r) -> Node (flip r, x, flip l);;
val flip : 'a tree -> 'a tree = <fun>
```

Here, `flip` is polymorphic while `total` operates only on trees of type `int
tree`. Let's try our new functions out:

```ocaml env=trees
# let all = total t;;
val all : int = 10
# let flipped = flip t;;
val flipped : int tree =
  Node (Node (Leaf, 4, Node (Leaf, 3, Leaf)), 2, Node (Leaf, 1, Leaf))
# t = flip flipped;;
- : bool = true
```

Instead of integers, we could build a tree of key-value pairs. Then, if we
insist that the keys are unique and that a smaller key is always left of a
larger key, we have a data structure for dictionaries which performs better
than a simple list of pairs. It is known as a *binary search tree*:

```ocaml env=trees
# let rec insert (k, v) = function
  | Leaf -> Node (Leaf, (k, v), Leaf)
  | Node (l, (k', v'), r) ->
      if k < k' then Node (insert (k, v) l, (k', v'), r) 
      else if k > k' then Node (l, (k', v'), insert (k, v) r)
      else Node (l, (k, v), r);;
val insert : 'a * 'b -> ('a * 'b) tree -> ('a * 'b) tree = <fun>
```

Similar functions can be written to look up values in a dictionary, to convert
a list of pairs to or from a tree dictionary, and so on.

## Example: Options

A simple, yet very common, use of polymorphic type with constructors is the
`option` type. Like `list`, it's predefined. Here is how:

<!-- $MDX non-deterministic=command -->
```ocaml
# #show option;;
type 'a option = None | Some of 'a
```

`option` used to wrap some data, if available, or absence of data otherwise.
Here is 42, stored inside an `option` using the data carrying constructor
`Some`:

```ocaml
# Some 42;;
- : int option = Some 42
```

The `None` constructor means no data is availble.

In other words a value of type `t option` for some type `t` represents:

* either a value `v` of type `t`, wrapped as `Some v`,
* no such value, then `o` has the value `None`.

The option type is very useful when lack of data is better handled as a special
value (_i.e._ `None`) rather than an exception. It is the type-safe version of
returning error values such as in C, for instance. Since no data has any special
meaning, confusion between regular values and absence of value is impossible. In
computer science, this type is called the [option
type](https://en.wikipedia.org/wiki/Option_type). OCaml has supported `option`
since its inception.

The function `Sys.getenv : string -> string` from the OCaml standard library
allows to query the value of an environment variable, however, it throws an
exception if the variable is not defined. On the other hand, the function
`Sys.getenv_opt : string -> string opt` does the same except it returns `None`
is the variable is not defined. Here is what may happen if we try to access an
undefined environment variable:

```ocaml
# Sys.getenv "UNDEFINED_ENVIRONMENT_VARIABLE";;
Exception: Not_found.
# Sys.getenv_opt "UNDEFINED_ENVIRONMENT_VARIABLE";;
- : string option = None
```

Using pattern-matching, it is possible to define functions, allowing users to easily
work with option values. Here is `map` of type `('a -> 'b) -> 'a option -> 'b
option`. It allows to apply a function to the value wrapped inside an `option`,
if present:

```ocaml
# let map f = function
  | None -> None
  | Some v -> Some (f v);;
val map : ('a -> 'b) -> 'a option -> 'b option = <fun>
```
`map` takes two parameters, the function `f` to be applied and an option value.
`map f o` returns `Some (f v)` if `o` is `Some v` and `None` if `o` is `None`.

Here is `join` of type `'a option option -> 'a option`. It peels off one layer
from a doubly wrapped option:

```ocaml
# let join = function
  | Some Some v -> Some v
  | Some None -> None
  | None -> None;;
val join : 'a option option -> 'a option = <fun>
```
`join` takes a single `option option` parameter and returns an `option`
parameter.

The function `get` of type `'a option -> 'a` allows to access the value
contained inside an `option`.
```ocaml
# let get = function
  | Some v -> v
  | None -> raise (Invalid_argument "option is None");;
val get : 'a option -> 'a = <fun>
```
But beware `get o` throws an exception if `o` is `None`. To access the content
of an `option` without risking to raise an exception, the function `value` of
type `'a option -> 'a -> 'a` can be used
```ocaml
# let value default = function
  | Some v -> v
  | None -> default;;
val value : 'a -> 'a option -> 'a = <fun>
```
However it takes a default value as an additional parameter.

The function `fold` of type `fold : ('a -> 'b) -> 'b -> 'a option -> 'b`
combines `map` and `value`
```ocaml
# let fold f default o = o |> map f |> value default;;
val fold : ('a -> 'b) -> 'b -> 'a option -> 'b = <fun>
```
To build a function going the other way round, which creates an `option` one can
define `unfold` of type `('a -> bool) -> ('a -> 'b) -> 'a -> 'b option` the
following way:
```ocaml
# let unfold p f x =
    if p x then
      Some (f x)
    else
      None;;
val unfold : ('a -> bool) -> ('a -> 'b) -> 'a -> 'b option = <fun>
```

Most of those functions as well as other useful ones are provided by the
OCaml standard library in the [`Stdlib.Option`](https://ocaml.org/api/Option.html)
supporting module.

By the way, any type where `map` and `join` functions can be implemented, with
similar behaviour, can be called a _monad_ and `option` is often used to
introduce monads. But don't freak out, you absolutely don't need to know what a
monad is to use the `option` type.

## Example: Mathematical Expressions

We wish to represent simple mathematical expressions like `n * (x + y)` and
multiply them out symbolically to get `n * x + n * y`.

Let's define a type for these expressions:

```ocaml env=expr
type expr =
  | Plus of expr * expr        (* a + b *)
  | Minus of expr * expr       (* a - b *)
  | Times of expr * expr       (* a * b *)
  | Divide of expr * expr      (* a / b *)
  | Var of string              (* "x", "y", etc. *)
```

The expression `n * (x + y)` would be written:

```ocaml env=expr
# Times (Var "n", Plus (Var "x", Var "y"));;
- : expr = Times (Var "n", Plus (Var "x", Var "y"))
```

Let's write a function which prints out `Times (Var "n", Plus (Var "x", Var
"y"))` as something more like `n * (x + y)`.

```ocaml env=expr
# let rec to_string e =
  match e with
  | Plus (left, right) ->
     "(" ^ to_string left ^ " + " ^ to_string right ^ ")"
  | Minus (left, right) ->
     "(" ^ to_string left ^ " - " ^ to_string right ^ ")"
  | Times (left, right) ->
   "(" ^ to_string left ^ " * " ^ to_string right ^ ")"
  | Divide (left, right) ->
   "(" ^ to_string left ^ " / " ^ to_string right ^ ")"
  | Var v -> v;;
val to_string : expr -> string = <fun>
# let print_expr e =
  print_endline (to_string e);;
val print_expr : expr -> unit = <fun>
```

(The `^` operator concatenates strings). We separate the function into two so
that our `to_string` function is usable in other contexts. Here's the
`print_expr` function in action:

```ocaml env=expr
# print_expr (Times (Var "n", Plus (Var "x", Var "y")));;
(n * (x + y))
- : unit = ()
```

We can write a function to multiply out expressions of the form `n * (x + y)`
or `(x + y) * n` and for this we will use a nested pattern:

```ocaml env=expr
# let rec multiply_out e =
  match e with
  | Times (e1, Plus (e2, e3)) ->
     Plus (Times (multiply_out e1, multiply_out e2),
           Times (multiply_out e1, multiply_out e3))
  | Times (Plus (e1, e2), e3) ->
     Plus (Times (multiply_out e1, multiply_out e3),
           Times (multiply_out e2, multiply_out e3))
  | Plus (left, right) ->
     Plus (multiply_out left, multiply_out right)
  | Minus (left, right) ->
     Minus (multiply_out left, multiply_out right)
  | Times (left, right) ->
     Times (multiply_out left, multiply_out right)
  | Divide (left, right) ->
     Divide (multiply_out left, multiply_out right)
  | Var v -> Var v;;
val multiply_out : expr -> expr = <fun>
```

Here it is in action:

```ocaml env=expr
# print_expr (multiply_out (Times (Var "n", Plus (Var "x", Var "y"))));;
((n * x) + (n * y))
- : unit = ()
```

How does the `multiply_out` function work? The key is in the first two
patterns. The first pattern is `Times (e1, Plus (e2, e3))` which matches
expressions of the form `e1 * (e2 + e3)`. Now look at the right hand side of
this first pattern match, and convince yourself that it is the equivalent of
`(e1 * e2) + (e1 * e3)`. The second pattern does the same thing, except for
expressions of the form `(e1 + e2) * e3`.

The remaining patterns don't change the form of the expression, but they
crucially *do* call the `multiply_out` function recursively on their
subexpressions. This ensures that all subexpressions within the expression get
multiplied out too (if you only wanted to multiply out the very top level of an
expression, then you could replace all the remaining patterns with a simple `e
-> e` rule).

Can we do the reverse (i.e. factorizing out common subexpressions)? We can!
(But it's a bit more complicated). The following version only works for the top
level expression. You could certainly extend it to cope with all levels of an
expression and more complex cases:

```ocaml env=expr
# let factorize e =
  match e with
  | Plus (Times (e1, e2), Times (e3, e4)) when e1 = e3 ->
     Times (e1, Plus (e2, e4))
  | Plus (Times (e1, e2), Times (e3, e4)) when e2 = e4 ->
     Times (Plus (e1, e3), e4)
  | e -> e;;
val factorize : expr -> expr = <fun>
# factorize (Plus (Times (Var "n", Var "x"),
                   Times (Var "n", Var "y")));;
- : expr = Times (Var "n", Plus (Var "x", Var "y"))
```

The factorize function above introduces another couple of features. You can add
what are known as *guards* to each pattern match. A guard is the conditional
which follows the `when`, and it means that the pattern match only happens if
the pattern matches *and* the condition in the `when`-clause is satisfied.

<!-- $MDX skip -->
```ocaml
match value with
| pattern [ when condition ] -> result
| pattern [ when condition ] -> result
  ...
```

The second feature is the `=` operator which tests for "structural equality"
between two expressions. That means it goes recursively into each expression
checking they're exactly the same at all levels down.

Another feature which is useful when we build more complicated nested patterns
is the `as` keyword, which can be used to name part of an expression. For
example:

<!-- $MDX skip -->
```ocaml
Name ("/DeviceGray" | "/DeviceRGB" | "/DeviceCMYK") as n -> n

Node (l, ((k, _) as pair), r) when k = k' -> Some pair
```

## Mutually Recursive Data Types

Data types may be mutually-recursive when declared with `and`:

```ocaml
type t = A | B of t' and t' = C | D of t
```

One common use for mutually-recursive data types is to *decorate* a tree, by
adding information to each node using mutually-recursive types, one of which is
a tuple or record. For example:

```ocaml
type t' = Int of int | Add of t * t
and t = {annotation : string; data : t'}
```

Values of such mutually-recursive data type are manipulated by accompanying
mutually-recursive functions:

```ocaml
# let rec sum_t' = function
  | Int i -> i
  | Add (i, i') -> sum_t i + sum_t i'
  and sum_t {annotation; data} =
    if annotation <> "" then Printf.printf "Touching %s\n" annotation;
    sum_t' data;;
val sum_t' : t' -> int = <fun>
val sum_t : t -> int = <fun>
```

## A Note on Tupled Constructors

There is a difference between `RGB of float * float * float` and 
`RGB of (float * float * float)`. 
The first is a constructor with three pieces of data
associated with it, the second is a constructor with one tuple associated with
it. There are two ways this matters: the memory layout differs between the two
(a tuple is an extra indirection), and the ability to create or match using a
tuple:

```ocaml
# type t = T of int * int;;
type t = T of int * int

# type t2 = T2 of (int * int);;
type t2 = T2 of (int * int)

# let pair = (1, 2);;
val pair : int * int = (1, 2)

# T2 pair;;
- : t2 = T2 (1, 2)

# T pair;;
Line 1, characters 1-7:
Error: The constructor T expects 2 argument(s),
       but is applied here to 1 argument(s)

# match T2 (1, 2) with T2 x -> fst x;;
- : int = 1

# match T (1, 2) with T x -> fst x;;
Line 1, characters 21-24:
Error: The constructor T expects 2 argument(s),
       but is applied here to 1 argument(s)
```

Note, however, that OCaml allows us to use the always-matching `_` in either
version:

```ocaml
# match T2 (1, 2) with T2 _ -> 0;;
- : int = 0

# match T (1, 2) with T _ -> 0;;
- : int = 0
```

## Types and Modules

Often, a module will provide a single type and operations on that type. For
example, a module for a file format like PNG might have the following `png.mli`
interface:

<!-- $MDX skip -->
```ocaml
type t

val of_file : filename -> t

val to_file : t -> filename -> unit

val flip_vertical : t -> t

val flip_horizontal : t -> t

val rotate : float -> t -> t
```

Traditionally, we name the type `t`. In the program using this library, it
would then be `Png.t` which is shorter, reads better than `Png.png`, and avoids
confusion if the library also defines other types.
