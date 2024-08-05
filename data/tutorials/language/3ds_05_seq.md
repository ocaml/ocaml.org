---
id: sequences
title: Sequences
description: >
  Learn about sequences, of OCaml's most-used, built-in data types
category: "Data Structures"
prerequisite_tutorials:
  - "lists"
  - "options"
---

## Introduction

Sequences are very much like lists. However, from a pragmatic perspective, one
should imagine they may be infinite. That's the key intuition to understanding
and using sequences. To achieve this, sequence elements are computed on demand
and not stored in memory. Perhaps more frequently, sequences also allow for
reducing memory consumption from linear to constant space

<!--
Still in the intro: for people familiar with Python, I believe it would be very useful to mention Python’s generators: OCaml sequences are similar to Python generators. The main difference is that each element of a Python generator is consumed only once and never seen again, while an element in an OCaml sequence can be queried several times, but is re-computed each time (more expressive but opportunity for bugs). Also, OCaml does not have all the convenient syntax that Python has (there is no yield in OCaml [at least, until algebraic effects land in OCaml 5!]). The contrast between list and Seq.t in OCaml is the same as between range and xrange in old Python 2 (or [i for i in range(100)] versus range(100) in Python 3).
-->

One way to look at a value of type `'a Seq.t` is to consider it as a list, but it contains
a twist when it's not empty: its tail is frozen. To understand this analogy,
consider how sequences are defined in the standard library:
```ocaml
type 'a node =
  | Nil
  | Cons of 'a * 'a t
and 'a t = unit -> 'a node
```
This is the mutually recursive definition of two types: `Seq.node`, which is
almost the same as `list`:
```ocaml
type 'a list =
  | []
  | (::) of 'a * 'a list
```
and `Seq.t`, which is merely a type alias for `unit -> 'a Seq.node`. The whole
point of this definition is `Seq.Cons` second component's type, which is a
function returning a sequence while its `list` counterpart is a list. Let's
compare the constructors of `list` and `Seq.node`:
1. Empty lists and sequences are defined the same way, a constructor without any
   parameters: `Seq.Nil` and `[]`.
1. Non-empty lists and sequences are both pairs whose former member is a piece
   of data.
1. However, the latter member in lists is recursively a `list`, while in
   sequences, it is a function returning a `Seq.node`.

A value of type `Seq.t` is “frozen” because the data it contains isn't
immediately available. A `unit` value has to be supplied to recover it, which we
may see as “unfreezing.” However, unfreezing only gives access to the tip of the
sequence, since the second argument of `Seq.Cons` is a function too.

Frozen-by-function tails explain why sequences may be considered potentially
infinite. Until a `Seq.Nil` value has been found in the sequence, one can't say
for sure if some will ever appear. The sequence could be a stream of incoming
requests in a server, readings from an embedded sensor, or system logs. All have
unforeseeable termination, and it is easier to consider them potentially infinite.

In OCaml, any value `a` of type `t` can be turned into a constant function by
writing `fun _ -> a` or `fun () -> a`. The latter function is called a
[_thunk_](https://en.wikipedia.org/wiki/Thunk). Using this terminology, `Seq.t`
values are thunks. With the analogy used earlier, `a` is frozen in its thunk.

Here is how to build seemingly infinite sequences of integers:
```ocaml
# let rec ints n : int Seq.t = fun () -> Seq.Cons (n, ints (n + 1));;
val ints : int -> int Seq.t = <fun>
```
The function `ints n` looks as if building the infinite sequence `(n; n + 1; n +
2; n + 3;...)`. In reality, since machine integers have bounds, the sequence
isn't indefinitely increasing. When reaching `max_int`, it will circle
down to `min_int`.

The OCaml standard library contains a module on sequences called
[`Seq`](/releases/5.0/api/Seq.html). It contains a `Seq.iter` function, which
has the same behaviour as `List.iter`. Writing this:
```ocaml
# Seq.iter print_int (ints 0);;
```
in an OCaml toplevel means “print integers forever,” and you have to press
`Ctrl-C` to interrupt the execution. The following code is the same infinite
loop without any output:
```ocaml
# Seq.iter ignore (ints 0);;
```
The key point is: it doesn't leak memory. This example is running in constant
space. It is effectively nothing more than an infinite loop, which can be
confirmed by monitoring the space consumption of the program and by noticing
that it spins forever without crashing. Whereas a version of this with a list
`let rec ints n = n :: ints (n + 1)` would allocate a list of length
proportional to the running time, and thus would crash by running out of memory
pretty quickly.

## Example

The `Seq` module of the OCaml standard library contains the definition of the
function `Seq.take`, which returns a specified number of elements from the
beginning of a sequence. Here is a simplified implementation:
```ocaml
let rec take n seq () =
  if n <= 0 then
    Seq.Nil
  else
    match seq () with
    | Seq.Cons (x, seq) -> Seq.Cons (x, take (n - 1) seq)
    | _ -> Seq.Nil
```
`take n seq` returns, at most, the `n` first elements of the sequence `seq`. If
`seq` contains less than `n` elements, an identical sequence is returned. In
particular, if `seq` is empty, or `n` is negative, an empty sequence is returned.

Observe the first line of `take`. It is the common pattern for recursive
functions over sequences. The last two parameters are:
* a sequence called `seq`
* a `unit` value

When executed, the function begins by unfreezing `seq` (that is, calling `seq
()`) and then pattern matching to look inside the data made available. However, this
does not happen unless a `unit` parameter is passed to `take`. Writing `take 10
seq` does not compute anything. It is a partial application and returns a
function needing a `unit` to produce a result.

This can be used to print integers without looping forever, as shown previously:
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

Using `Seq.filter`, taking inspiration from the [trial division](https://en.wikipedia.org/wiki/Trial_division) algorithm, it is possible to define a function which seemingly generates the list of all primes numbers.
```ocaml
let rec trial_div seq () = match seq () with
  | Seq.Cons (m, seq) -> Seq.Cons (m, trial_div (Seq.filter (fun n -> n mod m > 0) seq))
  | seq -> seq
let primes = Seq.ints 2 |> trial_div;;
val trial_div : int Seq.t -> int Seq.t = <fun>
val primes : int Seq.t = <fun>
```

For instance, here is the list of 100 first prime numbers:
```ocaml
# primes |> Seq.take 100 |> List.of_seq;;
- : int list =
[2; 3; 5; 7; 11; 13; 17; 19; 23; 29; 31; 37; 41; 43; 47; 53; 59; 61; 67; 71;
 73; 79; 83; 89; 97; 101; 103; 107; 109; 113; 127; 131; 137; 139; 149; 151;
 157; 163; 167; 173; 179; 181; 191; 193; 197; 199; 211; 223; 227; 229; 233;
 239; 241; 251; 257; 263; 269; 271; 277; 281; 283; 293; 307; 311; 313; 317;
 331; 337; 347; 349; 353; 359; 367; 373; 379; 383; 389; 397; 401; 409; 419;
 421; 431; 433; 439; 443; 449; 457; 461; 463; 467; 479; 487; 491; 499; 503;
 509; 521; 523; 541]
```

The function `trial_div` is recursive in OCaml and common sense. It is defined
using the `rec` keyword and calls itself. However, some call that kind of
function [corecursive](https://en.wikipedia.org/wiki/Corecursion). This word is
used to emphasise that, although it may not terminate, it can indefinitely
produce valid output.

## Unfolding Sequences

Standard higher-order iteration functions are available on sequences. For
instance:
* `Seq.iter`
* `Seq.map`
* `Seq.fold_left`

All those are also available for [`Array`](/manual/api/Array.html), `List`, and `Set` and behave
essentially the same. Observe that there is no `fold_right` function. Since
OCaml 4.11, there is something which isn't (yet) available on other types:
`unfold`. Here is how it is implemented:
```ocaml
let rec unfold f x () = match f x with
  | None -> Seq.Nil
  | Some (x, seq) -> Seq.Cons (x, unfold f seq)
```
And here is its type:
```ocaml
val unfold : ('a -> ('b * 'a) option) -> 'a -> 'b Seq.t = <fun>
```
Unlike previously mentioned iterators, `Seq.unfold` does not have a sequence
parameter, but a sequence result. `unfold` provides a general means to build
sequences. The result returned by `Seq.unfold f x` is the sequence built by accumulating the results of successive calls to `f` until it returns `None`. This is:
```
(fst p₀, fst p₁, fst p₂, fst p₃, fst p₄, ...)
```
where `Some p₀ = f x` and `Some pₙ₊₁ = f (snd pₙ)`.

For instance, `Seq.ints` can be implemented using `Seq.unfold` in a
fairly compact way:
```ocaml
# let ints = Seq.unfold (fun n -> Some (n, n + 1));;
val ints : int -> int Seq.t = <fun>
```


As a fun fact, one should observe `map` over sequences can be implemented using
`Seq.unfold`. Here is how to write it:
```ocaml
# let map f = Seq.unfold (fun seq -> seq |> Seq.uncons |> Option.map (fun (x, seq) -> (f x, seq)));;
val map : ('a -> 'b) -> 'a Seq.t -> 'b Seq.t = <fun>
```
Here is a quick check:
```ocaml
# Seq.ints 0 |> map (fun x -> x * x) |> Seq.take 10 |> List.of_seq;;
- : int list = [0; 1; 4; 9; 16; 25; 36; 49; 64; 81]
```
The function `Seq.uncons` returns the head and tail of a sequence if it is not
empty. Otherwise, it returns `None`.

Using this function:
```ocaml
let input_line_opt chan =
  try Some (input_line chan, chan)
  with End_of_file -> None
```
It is possible to read a file using `Seq.unfold`:
```ocaml
let cin = open_in "README.md" in
cin |> Seq.unfold input_line_opt |> Seq.iter print_endline;
close_in cin
```

<!--
Suggestion: perhaps it would be enlightening to illustrate the use of Seq.unfold by re-implementing the already seen function primes? Perhaps in an exercise rather than in the main text of the tutorial.

```
let rec next_prime prime_list n =
  if List.for_all (fun p -> n mod p <> 0) prime_list then
    n
  else next_prime prime_list (n+1)

let primes =
  Seq.unfold
    begin fun (prime_list, n) ->
      let p = next_prime prime_list n in
      Some (p, (p::prime_list, p+1))
    end
    ([], 2)
```

This example illustrates a non-trivial use of the accumulator, and also the fact that the producer function loops until it finds a new prime to yield, because Seq.unfold does not allow the producer to “skip” a value: it must produce a new element or end the sequence. If we were allowed to skip values, we could more simply do:

```
let primes =
  Seq.unfold_skippable
    begin fun (prime_list, n) ->
      if List.for_all (fun p -> n mod p <> 0) prime_list then
        Yield (n, (n::prime_list, n+1))
      else
        Skip (prime_list, n+1)
    end
    ([], 2)
```
-->

## Sequences Are Functions

The `Seq` module contains this definition:
```ocaml
val cons : 'a -> 'a Seq.t -> 'a Seq.t
```

Although `Seq.cons x seq` and `Seq.Cons (x, seq)` are the same, `Seq.cons` is a function and `Seq.Cons` is a variant's constructor, which is not the same in OCaml. This can lead to subtle bugs. This section illustrates this.
<!--
No need to introduce another mathematical sequence, we can reuse earlier examples (better for pedagogy):
```
let rec ints n = Seq.cons n (ints (n+1))
```
-->
Although this looks like a possible way to define the [Fibonacci
sequence](https://en.wikipedia.org/wiki/Fibonacci_number):
```ocaml
# let rec fibs m n = Seq.cons m (fibs n (n + m));;
val fibs : int -> int -> int Seq.t = <fun>
```
It actually isn't. It's an unending recursion which blows away the stack.

<!--
At that point, Seq.cons has not been introduced yet, so the reader only knows fun () -> Seq.Cons … and would not have fallen into the trap of writing Seq.cons … instead. Besides, she may not understand this section at all because Seq.cons is not explained here. The progression of this section should be turned upside down.
-->
```
# fibs 0 1;;
Stack overflow during evaluation (looping recursion?).
```
This definition is behaving as expected (spot the differences, there are four): <!-- How do you count four? -->
```ocaml
# let rec fibs m n () = Seq.Cons (m, fibs n (n + m));;
val fibs : int -> int -> int Seq.t = <fun>
```
It can be used to produce some Fibonacci numbers:
```ocaml
# fibs 0 1 |> Seq.take 10 |> List.of_seq;;
- : int list = [0; 1; 1; 2; 3; 5; 8; 13; 21; 34]
```
Why is it so? The key difference lies in the recursive call `fibs n (n + m)`. In
the former definition, the application is complete because `fibs` is provided
with all the arguments it expects. In the latter definition, the application is
partial because the `()` argument is missing. Since evaluation is
[eager](https://en.wikipedia.org/wiki/Evaluation_strategy#Eager_evaluation) in
OCaml, in the former case, evaluation of the recursive call is triggered and a
non-terminating looping occurs. In contrast, in the latter case, the partially
applied function is immediately returned as a
[closure](https://en.wikipedia.org/wiki/Closure_(computer_programming)).

Sequences are functions, as stated by their type:
```ocaml
# #show Seq.t;;
type 'a t = unit -> 'a Seq.node
```
Functions working with sequences must be written accordingly.
* Sequence consumer: partially applied function parameter
* Sequence producer: partially applied function result

When code dealing with sequences does not behave as expected, like if it is
crashing or hanging, there's a fair chance a mistake like in the first
definition of `fibs` was made.

## Sequences for Conversions

Throughout the standard library, sequences are used as a bridge to perform
conversions between many datatypes. For instance, here are the signatures of
some of those functions:
* Lists
  ```ocaml
  val List.to_seq : 'a list -> 'a Seq.t
  val List.of_seq : 'a Seq.t -> 'a list
  ```
* Arrays
  ```ocaml
  val Array.to_seq : 'a array -> 'a Seq.t
  val Array.of_seq : 'a Seq.t -> 'a array
  ```
* Strings
  ```ocaml
  val String.to_seq : string -> char Seq.t
  val String.of_seq : char Seq.t -> string
  ```
Similar functions are also provided for sets, maps, hash tables (`Hashtbl`), and
others. When implementing a datatype module, it is
advised to expose `to_seq` and `of_seq` functions.

## Miscellaneous Considerations

There are a couple of related libraries, all providing means to handle large
flows of data:

* Rizo I [Streaming](/p/streaming)
* Simon Cruanes and Gabriel Radanne [Iter](/p/iter)
* Simon Cruanes [OSeq](/p/oseq) (an extension of `Seq` with more functions)
* Jane Street `Base.Sequence`

There used to be a module called [`Stream`](/releases/4.13/api/Stream.html) in
the OCaml standard library. It was
[removed](https://github.com/ocaml/ocaml/pull/10482) in 2021 with the release of
OCaml 4.14. Beware books and documentation written before may still mention it.
<!-- 
## Exercises

* [Streams](/problems#100)
* [Diagonal](/problems#101) -->

<!--
## Credits

* Authors:

  1. Cuihtlauac Alvarado [@cuihtlauac](https://github.com/cuihtlauac)

* Suggestions and Corrections:

  * Miod Vallat [@dustanddreams](https://github.com/dustanddreams)
  * Sayo Bamigbade [@SaySayo](https://github.com/SaySayo)
  * Christine Rose [@christinerose](https://github.com/christinerose)
  * Sabine Schmaltz [@sabine](https://github.com/sabine)
  * Guillaume Petiot [@gpetiot](https://github.com/gpetiot)
  * Xavier Van de Woestyne [@xvw](https://github.com/xvw)
  * Simon Cruanes [@c-cube](https://github.com/c-cube)
  * Glen Mével [gmevel](https://github.com/gmevel)
-->
