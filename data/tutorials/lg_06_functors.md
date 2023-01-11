---
id: functors
title: Functors
description: >
  Learn about functors, modules parameterised by other modules
category: "language"
date: 2021-05-27T21:07:30-00:00
---

# Functors

Functors are probably one of the most complex features of OCaml, but you don't
have to use them extensively to be a successful OCaml programmer.  Actually,
you may never have to define a functor yourself, but you will surely encounter
them in the standard library. They are the only way of using the Set and Map
modules, but using them is not so difficult.

## What Are Functors and Why Do We Need Them?

A functor is a module that is parametrized by another module, just like a
function is a value which is parametrized by other values, the arguments.

It allows one to parametrize a type by a value, which is not possible directly
in OCaml without functors. For example, we can define a functor that takes an
int n and returns a collection of array operations that work exclusively on
arrays of length n. If by mistake the programmer passes a regular array to one
of those functions, it will result in a compilation error. If we were not using
this functor but the standard array type, the compiler would not be able to
detect the error, and we would get a runtime error at some undetermined date in
the future, which is much worse.

## Using an Existing Functor

The standard library defines a `Set` module, which provides a `Make` functor.
This functor takes one argument, which is a module that provides (at least) two
things: the type of elements, given as `t` and the comparison function given as
`compare`. The point of the functor is to ensure that the same comparison
function will always be used, even if the programmer makes a mistake.

For example, if we want to use sets of ints, we would do this:

```ocaml
# module Int_set =
  Set.Make (struct
              type t = int
              let compare = compare
            end);;
module Int_set :
  sig
    type elt = int
    type t
    val empty : t
    val is_empty : t -> bool
    val mem : elt -> t -> bool
    val add : elt -> t -> t
    val singleton : elt -> t
    val remove : elt -> t -> t
    val union : t -> t -> t
    val inter : t -> t -> t
    val disjoint : t -> t -> bool
    val diff : t -> t -> t
    val compare : t -> t -> elt
    val equal : t -> t -> bool
    val subset : t -> t -> bool
    val iter : (elt -> unit) -> t -> unit
    val map : (elt -> elt) -> t -> t
    val fold : (elt -> 'a -> 'a) -> t -> 'a -> 'a
    val for_all : (elt -> bool) -> t -> bool
    val exists : (elt -> bool) -> t -> bool
    val filter : (elt -> bool) -> t -> t
    val filter_map : (elt -> elt option) -> t -> t
    val partition : (elt -> bool) -> t -> t * t
    val cardinal : t -> elt
    val elements : t -> elt list
    val min_elt : t -> elt
    val min_elt_opt : t -> elt option
    val max_elt : t -> elt
    val max_elt_opt : t -> elt option
    val choose : t -> elt
    val choose_opt : t -> elt option
    val split : elt -> t -> t * bool * t
    val find : elt -> t -> elt
    val find_opt : elt -> t -> elt option
    val find_first : (elt -> bool) -> t -> elt
    val find_first_opt : (elt -> bool) -> t -> elt option
    val find_last : (elt -> bool) -> t -> elt
    val find_last_opt : (elt -> bool) -> t -> elt option
    val of_list : elt list -> t
    val to_seq_from : elt -> t -> elt Seq.t
    val to_seq : t -> elt Seq.t
    val to_rev_seq : t -> elt Seq.t
    val add_seq : elt Seq.t -> t -> t
    val of_seq : elt Seq.t -> t
  end
```

For sets of strings, it is even easier because the standard library provides a
`String` module with a type `t` and a function `compare`. If you were following
carefully, by now you must have guessed how to create a module for the
manipulation of sets of strings:

```ocaml
# module String_set = Set.Make (String);;
module String_set :
  sig
    type elt = string
    type t = Set.Make(String).t
    val empty : t
    val is_empty : t -> bool
    val mem : elt -> t -> bool
    val add : elt -> t -> t
    val singleton : elt -> t
    val remove : elt -> t -> t
    val union : t -> t -> t
    val inter : t -> t -> t
    val disjoint : t -> t -> bool
    val diff : t -> t -> t
    val compare : t -> t -> int
    val equal : t -> t -> bool
    val subset : t -> t -> bool
    val iter : (elt -> unit) -> t -> unit
    val map : (elt -> elt) -> t -> t
    val fold : (elt -> 'a -> 'a) -> t -> 'a -> 'a
    val for_all : (elt -> bool) -> t -> bool
    val exists : (elt -> bool) -> t -> bool
    val filter : (elt -> bool) -> t -> t
    val filter_map : (elt -> elt option) -> t -> t
    val partition : (elt -> bool) -> t -> t * t
    val cardinal : t -> int
    val elements : t -> elt list
    val min_elt : t -> elt
    val min_elt_opt : t -> elt option
    val max_elt : t -> elt
    val max_elt_opt : t -> elt option
    val choose : t -> elt
    val choose_opt : t -> elt option
    val split : elt -> t -> t * bool * t
    val find : elt -> t -> elt
    val find_opt : elt -> t -> elt option
    val find_first : (elt -> bool) -> t -> elt
    val find_first_opt : (elt -> bool) -> t -> elt option
    val find_last : (elt -> bool) -> t -> elt
    val find_last_opt : (elt -> bool) -> t -> elt option
    val of_list : elt list -> t
    val to_seq_from : elt -> t -> elt Seq.t
    val to_seq : t -> elt Seq.t
    val to_rev_seq : t -> elt Seq.t
    val add_seq : elt Seq.t -> t -> t
    val of_seq : elt Seq.t -> t
  end
```

(the parentheses are necessary)

## Defining Functors

A functor with one argument can be defined like this:

<!-- $MDX skip -->
```ocaml
module F (X : X_type) = struct
  ...
end
```

where `X` is the module that will be passed as argument, and `X_type` is its
signature, which is mandatory.

The signature of the returned module itself can be constrained, using this
syntax:

<!-- $MDX skip -->
```ocaml
module F (X : X_type) : Y_type =
struct
  ...
end
```

or by specifying this in the .mli file:

<!-- $MDX skip -->
```ocaml
module F (X : X_type) : Y_type
```

Overall, the syntax of functors is hard to grasp. The best may be to look at
the source files
[`set.ml`](https://github.com/ocaml/ocaml/blob/trunk/stdlib/set.ml) or
[`map.ml`](https://github.com/ocaml/ocaml/blob/trunk/stdlib/map.ml) of the
standard library.
