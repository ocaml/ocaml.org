---
id: Sequences
title: Sequences
description: >
  Learn about one of OCaml's must used, built-in data types
category: "data-structures"
date: 2023-01-12T09:00:00-01:00
---

# Sequences

A sequence looks a lot like a list. However from a pragmatic perspective, one
should imagine it may be infinite. One way to look at a value of type `'a Seq.t`
is to consider it as an icicle, a frozen stream of data. To understand this
analogy, consider how sequences are defined in the standard libary:
```ocaml
type 'a node =
  | Nil
  | Cons of 'a * 'a t
and 'a t = unit -> 'a node
```
This is the mutually recursive definition of two types: `Seq.node`, which is almost
the same as `list`:
```ocaml
type 'a list =
  | []
  | (::) of 'a * 'a list
```
and `Seq.t`, which is merely a type alias for `unit -> 'a Seq.node`. The whole
point of this definition is `Seq.Cons` second argument type; in `list`; in `list`
it is a list, while in `Seq.t`, it is a function. Empty lists and empty sequence are
defined the same way (`Seq.Nil` and `[]`). Non-empty lists are non-empty
sequences values are both pairs those former member is a piece of data. But non
empty sequence values have a sequence returning function as latter member
instead of a list. That function is the frozen part of the sequence. When a
non-empty sequence is processed, access to data at the tip of the sequence is
immediate, but access to the rest of the sequence is deferred. To access the
tail of non-empty sequence, it has to be microwaved, i.e., the tail returning
function must be passed a `unit` value.

Having frozen-by-function tails explains why sequences should be considered
potentially infinite. Unless a `Seq.Nil` has been found in the sequence, one
can't say for sure if some will ever appear. The tail could be a stream of
client requests in a server, readings from an embedded sensor, or logs. All have
unforseenable termination and should be considered infinite.

Here is how to build seemingly infinite sequences of integers:
```ocaml
# let rec ints_from n : int Seq.t = fun () -> Seq.Cons (n, ints_from (n + 1));;
val ints_from : int -> int Seq.t = <fun>
# let ints = ints_from 0;;
val ints : ints Seq.t = <fun>
```
The function `ints_from n` looks as if building the infinite sequence `$(n; n +
1; n + 2; n + 3;...)$`, while the value `ints` looks as if representing the
infinite sequence `$(0; 1; 2; 3; ...)$`. In reality, since there isn't an infinite
amount of distinct values of type `int`, those sequences are not increasing,
when reaching `max_int` the values will circle down to `min_int`. Actually, they
are ultimately periodic.

The OCaml standard library contains a module on sequences called `Seq`. It contains an `Seq.iter` function, which has the same behaviour as `List.iter`. Writing this
```ocaml
# Seq.iter print_int ints;;
```
in an OCaml toplevel actually means “print integers forever,” and you have to
type `Crtl-C` to interrupt the execution. Perhaps more interestingly, the
following code is an infinite loop:
```ocaml
# Seq.iter ignore ints;;
```
But the key point is: it doesn't leak memory.
