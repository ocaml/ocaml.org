---
id: Sequences
title: Sequences
description: >
  Learn about one an OCaml's must used, built-in data types
category: "data-structures"
date: 2023-01-12T09:00:00-01:00
---

# Sequences

## Introduction

Sequences look a lot like lists. However from a pragmatic perspective, one
should imagine they may be infinite. That's the key intuition to understanding
and using sequences.

One way to look at a value of type `'a Seq.t` is to consider it as an icicle, a
frozen stream of data. To understand this analogy, consider how sequences are
defined in the standard library:
```ocaml
type 'a node =
  | Nil
  | Cons of 'a * 'a t
and 'a t = unit -> 'a node
```
This is the mutually recursive definition of two types; `Seq.node` which is
almost the same as `list`:
```ocaml
type 'a list =
  | []
  | (::) of 'a * 'a list
```
and `Seq.t` which is merely a type alias for `unit -> 'a Seq.node`. The whole
point of this definition is the type of the second argument of `Seq.Cons`, which
is a function returning a sequence while its `list` sibling is a list. Let's
compare the constructors of `list` and `Seq.node`:
1. Empty lists and sequences are defined the same way, a constructor without any
   parameter: `Seq.Nil` and `[]`.
1. Non-empty lists and sequences are both pairs whose former member is a piece
   of data;
1. but the latter member, in lists, is a `list` too, while in sequences, it is a
   function returning a `Seq.node`.

A value of type `Seq.t` is “frozen” because the data it contains isn't
immediately available, a `unit` value has to be supplied to recover it, and
that's “unfreezing”. However, unfreezing only gives access to the tip of the
icicle, since the second argument of `Seq.Cons` is a function too.

Having frozen-by-function tails explains why sequences may be considered
potentially infinite. Unless a `Seq.Nil` has been found in the sequence, one
can't say for sure if some will ever appear. The sequence could be a stream of
client requests in a server, readings from an embedded sensor or system logs.
All have unforeseeable termination and it is easier to consider them infinite.

Here is how to build seemingly infinite sequences of integers:
```ocaml
# let rec ints_from n : int Seq.t = fun () -> Seq.Cons (n, ints_from (n + 1))
  let ints = ints_from 0;;
val ints_from : int -> int Seq.t = <fun>
val ints : ints Seq.t = <fun>
```
The function `ints_from n` looks as if building the infinite sequence
$(n; n + 1; n + 2; n + 3;...)$
while the value `ints` look as if representing the
infinite sequence $(0; 1; 2; 3; ...)$. In reality, since there isn't an infinite
amount of distinct values of type `int`, those sequences are not increasing,
when reaching `max_int` the values will circle down to `min_int`. They are
ultimately periodic.

The OCaml standard library contains a module on sequences called `Seq`. It
contains a `Seq.iter` function, which has the same behaviour as `List.iter`.
Writing this:
```ocaml
# Seq.iter print_int ints;;
```
in an OCaml top-level means: “print integers forever” and you have to type
`Crtl-C` to interrupt the execution. Perhaps more interestingly, the following
code is also an infinite loop:
```ocaml
# Seq.iter ignore ints;;
```
But the key point is: it doesn't leak memory.

## Example

Strangely, the `Seq` module of the OCaml standard library does not (yet) define
a function returning the elements at the beginning of a sequence. Here is a
possible implementation:
```ocaml
let rec take n seq () = match seq () with
| Seq.Cons (x, seq) when n > 0 -> Seq.Cons (x, take (n - 1) seq)
| _ -> Seq.Nil
```
`take n seq` returns, at most, the `n` first elements of the sequence `seq`. If
`seq` contains less than `n` elements, an identical sequence is returned. In
particular, if `seq` is empty, an empty sequence is returned.

Observe the first line of `take`, it is the common pattern for recursive
functions over sequences. The last two parameters are:
* a sequence called `seq`;
* a `unit` value.

When executed, the function begins by unfreezing `seq` (that is, calling `seq
()`) and then pattern match to look inside the data made available. However,
this does not happen unless a `unit` parameter is passed to `take`. Writing
`take 10 seq` does not compute anything, it is a partial application and returns
a function needing a `unit` to produce a result.

This can be used to print integers without looping forever as shown previously:
```ocaml
# ints |> take 43 |> List.of_seq;;
- : int list =
[0; 1; 2; 3; 4; 5; 6; 7; 8; 9; 10; 11; 12; 13; 14; 15; 16; 17; 18; 19; 20; 21;
 22; 23; 24; 25; 26; 27; 28; 29; 30; 31; 32; 33; 34; 35; 36; 37; 38; 39; 40;
 41; 42]
```

The `Seq` module has a function `Seq.filter`:
```ocaml
# Seq.filter;;
- : ('a -> bool) -> 'a Seq.t -> 'a Seq.t = <fun>
```
It builds a sequence of elements satisfying a condition.

Using `Seq.filter`, it is possible to make a straightforward implementation of the
[Sieve of Eratosthenes](https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes).
Here it is:
```ocaml
let rec sieve seq () = match seq () with
| Seq.Cons (m, seq) -> Seq.Cons (m, sieve (Seq.filter (fun n -> n mod m > 0) seq))
| seq -> seq;;
let facts = ints_from 2 |> sieve
```

This code can be used to generate lists of prime numbers. For instance, here is
the list of 100 first prime numbers:
```ocaml
# facts |> take 100 |> List.of_seq;;
- : int list =
[2; 3; 5; 7; 11; 13; 17; 19; 23; 29; 31; 37; 41; 43; 47; 53; 59; 61; 67; 71;
 73; 79; 83; 89; 97; 101; 103; 107; 109; 113; 127; 131; 137; 139; 149; 151;
 157; 163; 167; 173; 179; 181; 191; 193; 197; 199; 211; 223; 227; 229; 233;
 239; 241; 251; 257; 263; 269; 271; 277; 281; 283; 293; 307; 311; 313; 317;
 331; 337; 347; 349; 353; 359; 367; 373; 379; 383; 389; 397; 401; 409; 419;
 421; 431; 433; 439; 443; 449; 457; 461; 463; 467; 479; 487; 491; 499; 503;
 509; 521; 523]
```

The function `sieve` is recursive, in OCaml and common senses: it is defined
using the `rec` keyword and calls itself. However, some call that kind of
function “corecursive”. This word is used to emphasize that, by design, it does
not terminate. Strictly speaking, the sieve of Eratosthenes is not an
algorithm either since it does not terminate. This implementation behaves the
same.
