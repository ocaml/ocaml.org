---
id: sequences
title: Sequences
description: >
  Learn about sequences, of OCaml's most-used, built-in data types
category: "Data Structures"
language: English
prerequisite_tutorials:
  - "lists"
  - "options"
---

## Introduction

Sequences are very much like lists. However, from a pragmatic perspective, one
should imagine they can be either finite or infinite. That's the key intuition to understanding
and using sequences. To achieve this, sequence elements are computed on demand
and not stored in memory. Perhaps more frequently, sequences also allow for
reducing memory consumption from linear to constant space

<!--
Still in the intro: for people familiar with Python, I believe it would be very useful to mention Python’s generators: OCaml sequences are similar to Python generators. The main difference is that each element of a Python generator is consumed only once and never seen again, while an element in an OCaml sequence can be queried several times, but is re-computed each time (more expressive but opportunity for bugs). Also, OCaml does not have all the convenient syntax that Python has (there is no yield in OCaml [at least, until algebraic effects land in OCaml 5!]). The contrast between list and Seq.t in OCaml is the same as between range and xrange in old Python 2 (or [i for i in range(100)] versus range(100) in Python 3).
-->

One way to look at a value of type `'a Seq.t` is to consider it as a "lazy list"
where each element is wrapped in a function that must be "called" to reveal the value.

Consider how sequences are defined in the Standard Library:

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

A value of type `Seq.t` is not a list because the data it contains isn't
immediately available. A `unit` value has to be supplied to recover it, which we
may see as forcing evaluation to retrieve the first element of the list.
However, this only gives access to the tip of the
sequence, since the second argument of `Seq.Cons` is a function too.

This explain why sequences may be considered potentially
infinite: Until a `Seq.Nil` value has been found in the sequence, one can't say
for sure if some will ever appear. The sequence could be a stream of incoming
requests in a server, readings from an embedded sensor, or system logs. All have
unforeseeable termination, and it is easier to consider them potentially infinite.

In OCaml, any value `a` of type `t` can be turned into a constant function by
writing `fun _ -> a` or `fun () -> a`. The latter function is called a
[_thunk_](https://en.wikipedia.org/wiki/Thunk). Using this terminology, `Seq.t`
values are thunks.

## Constructing Sequences

With this understanding, we can manually construct a sequence like so:

``` ocaml
# let seq_123  =
    fun () -> Seq.Cons (1,
      fun () -> Seq.Cons (2,
        fun () -> Seq.Cons (3,
          fun () -> Seq.Nil)));;
val seq_123 : unit -> int Seq.node = <fun>
```

**Note:** The second component of each `Seq.Cons`' tuple is a function. This has
the effect of providing a means of acquiring a value rather than providing a
value directly.

We can also construct sequences using functions. Here is how to build an
infinite sequence of integers:

```ocaml
# let rec ints n : int Seq.t = fun () -> Seq.Cons (n, ints (n + 1));;
val ints : int -> int Seq.t = <fun>
```

The function `ints n` looks as if building the infinite sequence `(n; n + 1; n +
2; n + 3;...)`. In reality, since machine integers have bounds, the sequence
isn't indefinitely increasing. For technical reasons, when `max_int` is reached, it will circle
down to `min_int`.

The OCaml Standard Library contains a module for sequences called
[`Seq`](/releases/api/Seq.html). It contains `Seq.int`, which we implemented above.

## Iterating Over Sequences

The OCaml Standard Library also contains a `Seq.iter` function, which has the
same behavior as `List.iter`. Writing this:

```ocaml
# Seq.iter print_int (ints 0);;
```

in an OCaml toplevel means “print integers forever,” and you have to press
`Ctrl-C` to interrupt the execution. The following code is the same infinite
loop without any output:

```ocaml
# Seq.iter ignore (ints 0);;
```

The key point is that it doesn't leak memory. This example runs in constant
space. It is effectively nothing more than an infinite loop, which can be
confirmed by monitoring the space consumption of the program and by noticing
that it spins forever without crashing. Whereas a version of this with a list
`let rec ints n = n :: ints (n + 1)` would allocate a list of length
proportional to the running time, and thus would crash by running out of memory
pretty quickly.

## Taking Parts of a Sequence

The `Seq` module of the OCaml Standard Library contains the definition of the
function `Seq.take`, which returns a specified number of elements from the
beginning of a sequence. Here is a simplified implementation:

```ocaml
# let rec take n seq () =
    if n <= 0 then
      Seq.Nil
    else
      match seq () with
      | Seq.Cons (x, seq) -> Seq.Cons (x, take (n - 1) seq)
      | _ -> Seq.Nil;;
val take : int -> 'a Seq.t -> 'a Seq.t = <fun>
```

`take n seq` returns, at most, the `n` first elements of the sequence `seq`. If
`seq` contains less than `n` elements, an identical sequence is returned. In
particular, if `seq` is empty, or `n` is negative, an empty sequence is returned.

Observe the first line of our `take` function. It is the common pattern for recursive
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

([`Seq.ints i`](/manual/api/Seq.html) is the infinite sequence of the integers beginning at i and counting up.)

## Filtering a Sequence

The `Seq` module also has a function `Seq.filter`:

```ocaml
# Seq.filter;;
- : ('a -> bool) -> 'a Seq.t -> 'a Seq.t = <fun>
```

It builds a sequence of elements satisfying a condition.

Using `Seq.filter`, taking inspiration from the [trial division](https://en.wikipedia.org/wiki/Trial_division) algorithm, it is possible to define a function which seemingly generates the list of all primes numbers.

```ocaml
let rec trial_div seq () = match seq () with
  | Seq.Cons (m, seq_rest) -> Seq.Cons (m, trial_div (Seq.filter (fun n -> n mod m > 0) seq_rest))
  | Seq.Nil -> Seq.Nil
let primes = Seq.ints 2 |> trial_div;;
val trial_div : int Seq.t -> int Seq.t = <fun>
val primes : int Seq.t = <fun>
```

For instance, here is a list of 100 first prime numbers:

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

The function `trial_div` is recursive in OCaml and can be understood if we break
it down into its constituent parts. It is defined using the `rec` keyword, allowing the
function to call itself. For each loop in the recursive call, it pattern-matches
on either `Seq.Cons (m, seq)` or the end of the sequence, `Seq.Nil`.

If it matches on the first branch `Seq.Cons (m, seq)`, we filter the
remaining sequence of all integers that are divisible by `m` before recursively
calling `trial_div` on the filtered sequence. This branch is matched on until we
reach the end of the sequence for every recursive call.

So far, we recursively traveled down our sequence until we reached the 100th
prime number. Next, we retrace our steps up the recursive trail, wherein we
construct our result by calling `Seq.Cons` on `m` and the previously constructed
filtered sequence beginning with `Seq.Nil`.

**Side Note**: It may be interesting to learn that `trial_div`, while it can
colloquially be called a recursive, is an example of a kind of recursion called
[corecursion](https://en.wikipedia.org/wiki/Corecursion). Corecursion differs
from recursion in that it constructs results incrementally rather than consuming
it's input incrementally. Unlike traditional recursion, which works towards a
base case, corecursive functions must indefinitely produce values as a stream. The `trial_div` function is corecursive
because it does not immediately compute the complete sequence of primes. Instead, it
produces prime numbers on-demand, filtering and deferring further computation until
more elements are requested. This allows the sequence to be processed
incrementally rather than requiring a complete traversal upfront.

## Unfolding Sequences

Standard higher-order iteration functions are available on sequences. For
instance:
* `Seq.iter`
* `Seq.map`
* `Seq.fold_left`

All of these kinds of higher-order functions are also available for
[`Array`](/manual/api/Array.html), `List`, and `Set` and behave essentially the
same. Observe that there is no `fold_right` function. Since OCaml 4.11, there is
something which isn't (yet) available on other types: `unfold`. Here is how it
is implemented:

```ocaml
# let rec unfold f x () = match f x with
  | None -> Seq.Nil
  | Some (x, seq) -> Seq.Cons (x, unfold f seq);;
val unfold : ('a -> ('b * 'a) option) -> 'a -> 'b Seq.t = <fun>
```

Unlike previously mentioned iterators, `Seq.unfold` does not have a sequence
parameter, but a sequence result. `unfold` provides a general means to build
sequences. The result returned by `Seq.unfold f x` is the sequence built by
accumulating the results of successive calls to `f` until it returns `None`.
This is:

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

As a fun fact, we can observe that a `map` over sequences can be implemented using
`Seq.unfold`. Here is how to write it:

```ocaml
# let map f = Seq.unfold (fun seq -> seq |> Seq.uncons |> Option.map (fun (x, seq) -> (f x, seq)));;
val map : ('a -> 'b) -> 'a Seq.t -> 'b Seq.t = <fun>
```

We can check our `map` function by applying a square function to a sequence:

```ocaml
# Seq.ints 0 |> map (fun x -> x * x) |> Seq.take 10 |> List.of_seq;;
- : int list = [0; 1; 4; 9; 16; 25; 36; 49; 64; 81]
```

The function `Seq.uncons` returns the head and tail of a sequence if it is not
empty. Otherwise, it returns `None`.

### Reading a File with `Seq.Unfold`

For the next example, we will demonstrate the versatility of `Seq.unfold` by
using it to read a file.

Before doing so, let's define a function that reads a file's line from a
provided channel, with the type signature needed by `Seq.unfold`.

```ocaml
# let input_line_opt chan =
    try Some (In_Channel.input_line chan, chan)
    with End_of_file -> None;;
val input_line_opt : in_channel -> (string * in_channel) option = <fun>
```

**Note**: To make the code in the next section work, create a file named "README.md" and add dummy content. We use a file generated by the following command:

``` shell
cat > README.md <<EOF
This is the first line.
This is the second line.
EOF
```

Finally, let's read the file's contents using `Seq.unfold`. Mind that `cin` is a local definition.

```ocaml
# let cin = open_in "README.md" in
    cin |> Seq.unfold In_channel.input_line_opt |> Seq.iter print_endline;
    close_in cin;;
This is the first line.
This is the second line.
- : unit = ()
```

Note: production code should handle file opening errors, this example has been
kept short to focus only on how files relate to sequences.

## Consumers vs Producers

A function with a sequence parameter consumes it; it's a sequence consumer. A function with a sequence result produces it; it's a sequence producer. In both cases, consumption and production occurs on only one element before continuing with the rest.

### Sequence Consumers: Partially Applied Functions as Parameters

A consumer is a function that **processes** a sequence, consuming its
elements. Consumers should be written as higher-order functions that take a
function parameter. This allows for deferred evaluation,
ensuring that elements are fetched one at a time instead of forcing the entire
sequence to be evaluated upfront.

#### Consumer Example: `Seq.iter`

```ocaml
# let print_seq = Seq.iter print_int;;
val print_seq : int Seq.t -> unit = <fun>

```

In `print_seq`, `Seq.iter` takes the function `print_int` and applies it to each
element as they are generated. If `List.iter` was used, the whole integer list would be needed before displaying them starts.

### Sequence Producers: Functions as Results

A producer is a function that **generates** a sequence. Producers return a function so that elements are only computed when needed.  This
ensures deferred evaluation and avoids unnecessary computation.

#### Producer Example: `Seq.unfold`

```ocaml
 # let naturals =
  Seq.unfold (fun x -> Some (x, x + 1)) 0;;
val naturals : int Seq.t = <fun>
```

This application of `Seq.unfold` has type  `unit -> int Seq.node`, making it a function, a deferred producer. Each time this function is called, a new element is produced.

## Be Aware of Seq.Cons vs Seq.cons

The `Seq` module in the OCaml Standard Library contains two version of
"cons-ing" that warrant special attention due to their similar names and distinct
behavior.

We have already been introduced to the `Seq.Cons` variant constructor. As a
refresher, here is how to display its definition:

 ``` ocaml
# #show Seq.node;;
type 'a node = 'a Seq.node = Nil | Cons of 'a * 'a Seq.t

 ```

The other version of "cons-ing" is the
function `Seq.cons` (with a lowercase `c`) with the following value declaration:

```ocaml
val cons : 'a -> 'a Seq.t -> 'a Seq.t
```

From the signature, we gather that it is a function that takes two parameters, a
value and a sequence. Its definition is the following:

``` ocaml
 # let cons x next () = Cons (x, next);;
val cons : 'a -> 'a t -> unit -> 'a node = <fun>
```

`Seq.Cons` and `Seq.cons` are similar in that both are capable of creating a new
sequence:

 ``` ocaml
# let ints_from_2 = Seq.ints 2
  let ints_a () = Seq.Cons (1, ints_from_2)  (* With Seq.Cons *)
  let ints_b = Seq.cons 1 ints_from_2;;      (* With Seq.cons *)
val ints_from_2 : int Seq.t = <fun>
val ints_a : unit -> int Seq.node = <fun>
val ints_b : int Seq.t = <fun>

# ints_a |> Seq.take 3 |> List.of_seq;;
- : int list = [1; 2; 3]

# ints_b |> Seq.take 3 |> List.of_seq;;
- : int list = [1; 2; 3]
```

Now that we have seen these two versions of "cons-ing" can construct the same
sequence, it begs the question: what makes `Seq.cons` and `Seq.Cons` different?

Lets look at how confusing `Seq.Cons` and `Seq.con` can lead to unintended
behavior.

### Fibs with `Seq.cons`

Although the following looks like a possible way to define the [Fibonacci
sequence](https://en.wikipedia.org/wiki/Fibonacci_number), it leads to trouble:

```ocaml
# let rec fibs_v1 m n = Seq.cons m (fibs_v1 n (n + m));;
val fibs : int -> int -> int Seq.t = <fun>

# let fibs_v1 0 1;;
Stack overflow during evaluation (looping recursion?).
```

<!-- Or with an int version:

```ocaml
# let rec ints_v1 n = Seq.cons n (n + 1);;
val fibs : int -> int -> int Seq.t = <fun>

# let res = ints_v1 0;;
Stack overflow during evaluation (looping recursion?).

n```
-->

This produces a never-ending recursion that leads to a stack overflow.

### Fibs with `Seq.Cons`

Next, lets define `fibs_v2` using the constructor `Seq.Cons`:

```ocaml
# let rec fibs_v2 m n () = Seq.Cons (m, fibs_v2 n (n + m));;
val fibs_v2 : int -> int -> int Seq.t = <fun>
```

<!-- Or with an int version:
``` ocaml
# let rec ints_v2 n () = Seq.Cons (n, ints_v2 (n + 1));;
val ints_v2 : int -> int Seq.t = <fun>

```
-->

This implementation successfully defines a producer of lazy sequences with which
we can produce and then consume Fibonacci numbers:

```ocaml
# fibs_v2 0 1 |> Seq.take 10 |> List.of_seq;;
- : int list = [0; 1; 1; 2; 3; 5; 8; 13; 21; 34]
```

<!-- Or with an int version
``` ocaml
# ints_v2 1 |> Seq.take 10 |> List.of_seq;;
- : int list = [1; 2; 3; 4; 5; 6; 7; 8; 9; 10]
```
-->

### Understanding the Difference

Why is it so? The issue with `fibs_v1`  lies in the recursive call `fibs_v1 n (n + m)`.
Function application is complete because `fibs_v1` is provided with all the
arguments it expects, triggering runaway recursion without a base case. In the
latter definition of `fibs_v2`, function application is partial because the `()` argument is missing.
Since evaluation is [eager](https://en.wikipedia.org/wiki/Evaluation_strategy#Eager_evaluation) in
OCaml, in the former case evaluation of the recursive call is triggered and a
non-terminating looping occurs. By contrast in the latter case, the partially
applied function is immediately returned as a
[closure](https://en.wikipedia.org/wiki/Closure_(computer_programming)).

For this reason, it is not possible to create a Fibonacci function using
`Seq.cons`.

If the distinction remains a mystery, take a moment to compare the inputs to the
`Seq.Cons` constructor and `Seq.cons` function. They look deceptively similar,
but one takes as input a value of type `'a * 'a t` and the other takes as input
arguments of `'a` and `'a t`.

### A Mental Model for `Seq.Cons` vs `Seq.cons`

It useful to think of `Seq.Cons` and `Seq.cons` as accomplishing different
tasks. `Seq.Cons` provides a convenient means of recursively defining a sequence
generator and a clumsy means to prepend a value to a sequence.  Conversely,
`Seq.cons` provides a convenient means to prepend a value to a sequence and an
impossible means to recursively defining a sequence generator.

## Sequences for Conversions

Throughout the OCaml Standard Library, sequences are used as a bridge to perform
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
  * Glen Mével [gmevel](https://github.com/gmevel) -->





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

``` let primes = Seq.unfold_skippable begin fun (prime_list, n) -> if
List.for_all (fun p -> n mod p <> 0) prime_list then Yield (n, (n::prime_list,
n+1)) else Skip (prime_list, n+1) end ([], 2) ``` -->
