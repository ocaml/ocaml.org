---
id: Sequences
title: Sequences
description: >
  Learn about an OCaml's most-used, built-in data types
category: "data-structures"
date: 2023-01-12T09:00:00-01:00
---

# Sequences

## Prerequisites

| Concept | Status | Documentation | Reference |
|---|---|---|---|
| Basic types | Mandatory | | |
| Functions | Mandatory | | |
| Lists   | Mandatory |   |   |
| Options | Recommended |   |   |
| Arrays  | Nice to have |   |   |

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
potentially infinite. Until a `Seq.Nil` value has been found in the sequence,
one can't say for sure if some will ever appear. The sequence could be a stream
of incoming requests in a server, readings from an embedded sensor or system logs.
All have unforeseeable termination and it is easier to consider them infinite.

In OCaml, any value `a` of type `t` can be turned into a constant function by
writing `fun _ -> a`, which has type `'a -> t`. When writing `fun () -> a`
instead, we get a function of type `unit -> t`. Such a function is called a
[_thunk_](https://en.wikipedia.org/wiki/Thunk). Using this terminology, sequence
values are thunks. With the analogy used earlier, `a` is frozen in its thunk.

Here is how to build seemingly infinite sequences of integers:
```ocaml
# let rec ints n : int Seq.t = fun () -> Seq.Cons (n, ints (n + 1))
val ints : int -> int Seq.t = <fun>
```
The function `ints n` look as if building the infinite sequence
$(n; n + 1; n + 2; n + 3;...)$. In reality, since there isn't an infinite
amount of distinct values of type `int`, those sequences are not increasing,
when reaching `max_int` the values will circle down to `min_int`. They are
ultimately periodic.

The OCaml standard library contains a module on sequences called
[`Seq`](/releases/5.0/api/Seq.html). It contains a `Seq.iter` function, which
has the same behaviour as `List.iter`. Writing this:
```ocaml
# Seq.iter print_int (ints 0);;
```
in an OCaml top-level means: “print integers forever” and you have to type
`Crtl-C` to interrupt the execution. Perhaps more interestingly, the following
code is also an infinite loop:
```ocaml
# Seq.iter ignore (ints 0);;
```
But the key point is: it doesn't leak memory.

## Example

The `Seq` module of the OCaml standard library contains the definition of the
function `Seq.take` which returns a specified number of elements from the
beginning of a sequence. Here is a simplified implementation:
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
# Seq.ints 0 |> Seq.take 43 |> List.of_seq;;
- : int list =
[0; 1; 2; 3; 4; 5; 6; 7; 8; 9; 10; 11; 12; 13; 14; 15; 16; 17; 18; 19; 20; 21;
 22; 23; 24; 25; 26; 27; 28; 29; 30; 31; 32; 33; 34; 35; 36; 37; 38; 39; 40;
 41; 42]
```

The `Seq` module also has a function `Seq.filter`:
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
  | seq -> seq
let facts = ints_from 2 |> sieve;;
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

## Unfolding Sequences

Standard higher-order iteration functions are available on sequences. For
instance:
* `Seq.iter`
* `Seq.map`
* `Seq.fold_left`

All those are also available for `Array`, `List` and `Set` and behave
essentially the same. Observe that there is no `fold_right` function. Since
OCaml 4.11 there is something which isn't (yet) available on other types:
`unfold`. Here is how it is implemented:
```ocaml
let rec unfold f seq () = match f seq with
  | None -> Nil
  | Some (x, seq) -> Cons (x, unfold f seq)
```
And here is its type:
```ocaml
val unfold : ('a -> ('b * 'a) option) -> 'a -> 'b Seq.t = <fun>
```
Unlike previously mentioned iterators `Seq.unfold` does not have a sequence
parameter, but a sequence result. `unfold` provides a general means to build
sequences. For instance, `Seq.ints` can be implemented using `Seq.unfold` in a
fairly compact way:
```ocaml
let ints = Seq.unfold (fun n -> Some (n, n + 1));;
```

As a fun fact, one should observe `map` over sequences can be implemented using
`Seq.unfold`. Here is how to write it:
```ocaml
# let map f = Seq.unfold (fun s -> s |> Seq.uncons |> Option.map (fun (x, y) -> (f x, y)));;
val map : ('a -> 'b) -> 'a Seq.t -> 'b Seq.t = <fun>
```
Here is a quick check:
```ocaml
# Seq.ints 0 |> map (fun x -> x * x) |> Seq.take 10 |> List.of_seq;;
- : int list = [0; 1; 4; 9; 16; 25; 36; 49; 64; 81]
```
The function `Seq.uncons` returns the head and tail of a sequence if it is not empty or `None` otherwise.

Using this function:
```ocaml
let input_line_opt chan =
  try Some (input_line chan, chan)
  with End_of_file -> close_in chan; None
```
It is possible to read a file using `Seq.unfold`:
```ocaml
"README.md" |> open_in |> Seq.unfold input_line_opt |> Seq.iter print_endline
```

Although this can be an appealing style, bear in mind it does not prevent from
taking care of open files. While the code above is fine, this one no longer is:
```ocaml
"README.md" |> open_in |> Seq.unfold input_line_opt |> Seq.take 10 |> Seq.iter print_endline
```
Here, `close_in` will never be called over the input channel opened on `README.md`.

## Sequences for Conversions

Throughout the standard library, sequences are used as a bridge to perform
conversions between many datatypes. For instance, here are the signatures of
some of those functions:
* Lists
  ```ocaml
  val List.of_seq : 'a list -> 'a Seq.t
  val List.to_seq : 'a Seq.t -> 'a list
  ```
* Arrays
  ```ocaml
  val Array.of_seq : 'a array -> 'a Seq.t
  val Array.to_seq : 'a Seq.t -> 'a array
  ```
* Strings
  ```ocaml
  val String.of_seq : string -> char Seq.t
  val String.to_seq : char Seq.t -> string
  ```
Similar functions are also provided for sets, maps, hash tables (`Hashtbl`) and
others (except `Seq`, obviously). When implementing a datatype module, it is
advised to expose `to_seq` and `of_seq` functions.

## Miscellaneous

There are a couple of related Libraries, all providing means to handle large
flows of data:

* Rizo I [Streaming](/p/streaming)
* Gabriel Radanne [Iter](/p/iter)
* Jane Street `Base.Sequence`

There used to be a module called [`Stream`](/releases/4.13/api/Stream.html) in
the OCaml standard library. It was
[removed](https://github.com/ocaml/ocaml/pull/10482) in 2021 with the release of
OCaml 4.14. Beware books and documentation written before may still mention it.
