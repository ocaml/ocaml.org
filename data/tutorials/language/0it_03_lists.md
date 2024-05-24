---
id: lists
title: Lists
description: >
  Learn about one of OCaml's must used, built-in data types
category: "Introduction"
---

A list is an ordered sequence of elements. All elements of a list in OCaml must
be the same type. Lists are built into the language and have a special syntax.
Here is a list of three integers:

```ocaml
# [1; 2; 3];;
- : int list = [1; 2; 3]
```

Note semicolons separate the elements, not commas. The empty list is written
`[]`. The type of this list of integers is `int list`.

A list, if it is not empty, has a *head* (the first element) and a *tail* (the
list consisting of the rest of the elements). In our example, the head is the
integer `1` while the tail is the list `[2; 3]`. An empty list has neither a
head nor a tail. Here are some more lists:

```ocaml
# [];;
- : 'a list = []
# [1; 2; 3];;
- : int list = [1; 2; 3]
# [false; true; false];;
- : bool list = [false; true; false]
# [[1; 2]; [3; 4]; [5; 6]];;
- : int list list = [[1; 2]; [3; 4]; [5; 6]]
```

Notice the type of the empty list is `'a list` (its element type is not known).
Notice also the type of the last list - `int list list` or a list of lists of
integers.

There are two built-in operators on lists. The `::` or cons operator, adds one
element to the front of a list. The `@` or append operator combines two lists:

```ocaml
# 1 :: [2; 3];;
- : int list = [1; 2; 3]
# [1] @ [2; 3];;
- : int list = [1; 2; 3]
```

## Functions on Lists

We can write functions which operate over lists by pattern matching:

```ocaml
# let rec total l =
    match l with
    | [] -> 0
    | h :: t -> h + total t;;
val total : int list -> int = <fun>
# total [1; 3; 5; 3; 1];;
- : int = 13
```

Consider a function to find the length of a list:

```ocaml
# let rec length l =
    match l with
    | [] -> 0
    | _ :: t -> 1 + length t;;
val length : 'a list -> int = <fun>
```

This function operates not just on lists of integers, but on any kind of list.

```ocaml
# length [1; 2; 3];;
- : int = 3
# length ["cow"; "sheep"; "cat"];;
- : int = 3
# length [[]];;
- : int = 1
```

Why is this? Because in the pattern `_ :: t` the head of the list is not
inspected, so its type cannot be relevant. Such a function is called
polymorphic. Here is another polymorphic function, our own version of the `@`
operator for appending:

```ocaml
# let rec append a b =
  match a with
  | [] -> b
  | h :: t -> h :: append t b;;
val append : 'a list -> 'a list -> 'a list = <fun>
```

Notice that the memory for the second list is shared, but the first list is
effectively copied.


## Higher Order Functions on Lists

We might wish to apply a function to each element in a list, yielding a new
one. We shall write a function `map` which is given another function as its
argument - such a function is called "higher-order":

```ocaml
# let rec map f l =
    match l with
    | [] -> []
    | h :: t -> f h :: map f t;;
val map : ('a -> 'b) -> 'a list -> 'b list = <fun>
```

Notice the type of the function `f` in parentheses as part of the whole type.
This `map` function, given a function of type `'a -> 'b` and a list of `'a`s,
will build a list of `'b'`s. Sometimes `'a` and `'b` might be the same type, of
course. Here are two examples showing the `map` function in use:

```ocaml
# map (fun x -> x * 2) [1; 2; 3];;
- : int list = [2; 4; 6]
# map total [[1; 2]; [3; 4]; [5; 6]];;
- : int list = [3; 7; 11]
```

## The Standard Library `List` Module

The standard library [List](/manual/api/List.html) module contains a
wide range of useful utility functions, including pre-written versions of many
of the functions we have written in this tutorial. A version of the module with
labelled functions is available as part of
[StdLabels](/manual/api/StdLabels.html).

In the [List](/manual/api/List.html) module documentation, functions
which can raise an exception are marked. Such exceptions are usually the result
of lists which are empty (and therefore have neither a head nor a tail) or
lists of mismatched length.

### Maps and Iterators

We have already written a `map` function from scratch, and it is no surprise
that one is included in the [List](/manual/api/List.html) module.
There is also a variant for two lists:

```ocaml
# List.map2 ( + ) [1; 2; 3] [4; 5; 6];;
- : int list = [5; 7; 9]
```

In addition, we have an imperative analogue to
[`map`](/manual/api/List.html#VALmap), called
[`iter`](/manual/api/List.html#VALiter). It takes an imperative
function of type `'a -> unit` and an `'a list` and applies the function to each
element in turn. A suitable function might be `print_endline`:

```ocaml
# List.iter print_endline ["frank"; "james"; "mary"];;
frank
james
mary
- : unit = ()
```

There is a variant [`iter2`](/manual/api/List.html#VALiter2) for two
lists too:

```ocaml
# List.iter2
    (fun a b -> print_endline (a ^ " " ^ b))
    ["frank"; "james"; "mary"]
    ["carter"; "lee"; "jones"];;
frank carter
james lee
mary jones
- : unit = ()
```

Notice that [`map2`](/manual/api/List.html#VALmap2) and
[`iter2`](/manual/api/List.html#VALiter2) will fail if the lists are
of unequal length:

```ocaml
# List.map2 ( + ) [1; 2; 3] [4; 5];;
Exception: Invalid_argument "List.map2".
```

### List Scanning

The useful function [`mem`](/manual/api/List.html#VALmem) checks
whether a given element is a member of a list by scanning its contents:

```ocaml
# List.mem "frank" ["james"; "frank"; "mary"];;
- : bool = true
# List.mem [] [[1; 2]; [3]; []; [5]];;
- : bool = true
```

There are more elaborate scanning functions: imagine we wish to check to see if
all elements of a list are even, or if any element is even. We could either
write functions to go over each element of the list, keeping a boolean check,
or use `mem` and other functions already known to us:

```ocaml
# let all =
    not (List.mem false (List.map (fun x -> x mod 2 = 0) [2; 4; 6; 8]));;
val all : bool = true
# let any =
    List.mem true (List.map (fun x -> x mod 2 = 0) [1; 2; 3]);;
val any : bool = true
```

This is rather clumsy, though. The standard library provides two useful
functions [`for_all`](/manual/api/List.html#VALfor_all) and
[`exists`](/manual/api/List.html#VALexists) for this common problem:

```ocaml
# List.for_all (fun x -> x mod 2 = 0) [2; 4; 6; 8];;
- : bool = true
# List.exists (fun x -> x mod 2 = 0) [1; 2; 3];;
- : bool = true
```

So you can see how the standard library has evolved into its present state:
pieces of frequently-used code are turned into useful general functions.

### List Searching

The function [`find`](/manual/api/List.html#VALfind) returns the
first element of a list matching a given predicate (a predicate is a testing
function which returns either true or false when given an element). It raises
an exception if such an element is not found:


```ocaml
# List.find (fun x -> x mod 2 = 0) [1; 2; 3; 4; 5];;
- : int = 2
# List.find (fun x -> x mod 2 = 0) [1; 3; 5];;
Exception: Not_found.
```

The [`filter`](/manual/api/List.html#VALfilter) function again takes
a predicate and tests it against each element in the list, but this time
returns the list of all elements which test true:

```ocaml
# List.filter (fun x -> x mod 2 = 0) [1; 2; 3; 4; 5];;
- : int list = [2; 4]
```

If we wish to know also which elements did not test true, we can use
[`partition`](/manual/api/List.html#VALpartition) which returns a
pair of lists: the first being the list of elements for which the predicate is
true, the second those for which it is false.

```ocaml
# List.partition (fun x -> x mod 2 = 0) [1; 2; 3; 4; 5];;
- : int list * int list = ([2; 4], [1; 3; 5])
```

Note that the documentation for
[`filter`](/manual/api/List.html#VALfilter)  and
[`partition`](/manual/api/List.html#VALpartition) tells us that the
order of the input is preserved in the output. Where this is not stated it the
documentation, it cannot be assumed.

### Association Lists

Association lists are a simple (and simplistic) way of implementing the
dictionary data structure: that is to say, a group of keys each with an
associated value. For large dictionaries, for efficiency, we would use the
standard library's [Map](/manual/api/Map.html) or
[Hashtbl](/manual/api/Hashtbl.html) modules. But these functions from
the List module are useful for lists which are generally small, and have other
advantages: since they are just lists of pairs, they can be built and modified
easily. They are also easily printed in the toplevel.

```ocaml
# List.assoc 4 [(3, "three"); (1, "one"); (4, "four")];;
- : string = "four"
# List.mem_assoc 4 [(3, "three"); (1, "one"); (4, "four")];;
- : bool = true
```

When using association lists, and for other purposes, it is sometimes useful to
be able to make a list of pairs from a pair of lists and vice versa. The
[`List`](/manual/api/List.html) module provides the functions
[`split`](/manual/api/List.html#VALsplit) and
[`combine`](/manual/api/List.html#VALcombine) for this purpose:

```ocaml
# List.split [(3, "three"); (1, "one"); (4, "four")];;
- : int list * string list = ([3; 1; 4], ["three"; "one"; "four"])
# List.combine [3; 1; 4] ["three"; "one"; "four"];;
- : (int * string) list = [(3, "three"); (1, "one"); (4, "four")]
```

### Sorting Lists

The function [`List.sort`](/manual/api/List.html#VALsort), given a
comparison function of type `'a -> 'a -> int` (zero if equal, negative if first
smaller, positive if second smaller) and an input list of type `'a list`,
returns the list sorted according to the comparison function. Typically, we use
the built-in comparison function
[`compare`](/manual/api/Stdlib.html#VALcompare) which can compare any
two values of like type (with the exception of functions which are incomparable).

```ocaml
# List.sort compare [1; 4; 6; 4; 1];;
- : int list = [1; 1; 4; 4; 6]
# List.sort compare ["Reynolds"; "Smith"; "Barnes"];;
- : string list = ["Barnes"; "Reynolds"; "Smith"]
# List.sort (Fun.flip compare) [1; 4; 6; 4; 1];;
- : int list = [6; 4; 4; 1; 1]
# List.sort compare [(1, 3); (1, 2); (2, 3); (2, 2)];;
- : (int * int) list = [(1, 2); (1, 3); (2, 2); (2, 3)]
# List.sort
    (fun a b -> compare (fst a) (fst b))
    [(1, 3); (1, 2); (2, 3); (2, 2)];;
- : (int * int) list = [(1, 3); (1, 2); (2, 3); (2, 2)]
```

The function [`Fun.flip`](/manual/api/Fun.html#VALflip) reverses a binary function parameter order.

### Folds

There are two interestingly-named functions in the List module,
[`fold_left`](/manual/api/List.html#VALfold_left) and
[`fold_right`](/manual/api/List.html#VALfold_right). Their job is
to combine the elements of a list together, using a given function,
accumulating an answer which is then returned. The answer returned depends upon
the function given, the elements of the list, and the initial value of the
accumulator supplied. So you can imagine these are very general functions.
Let's explore [`fold_left`](/manual/api/List.html#VALfold_left)
first.

In this example, we supply the addition function and an initial
accumulator value of 0:

```ocaml
# List.fold_left ( + ) 0 [1; 2; 3];;
- : int = 6
```

The result is the sum of the elements in the list. Now let's use OCaml's
built-in `max` function which returns the larger of two given integers in place
of our addition function. We use `min_int`, the smallest possible integer, as
our initial accumulator

```ocaml
# List.fold_left max min_int [2; 4; 6; 0; 1];;
- : int = 6
```

The largest number in the list is found. Let's look at the type of the
[`fold_left`](/manual/api/List.html#VALfold_left) function:

```ocaml
# List.fold_left;;
- : ('a -> 'b -> 'a) -> 'a -> 'b list -> 'a = <fun>
```

The function is of type `'a -> 'b -> 'a` where `'a` is the accumulator and `'b`
is the type of each element of the list. The next parameter is the initial
accumulator, which must be of type `'a`, and then finally the input list of
type `'b list`. The result is the final value of the accumulator, so it must
have type `'a`. Of course, in both of our examples, `'a` and `'b` are the same
as one another. But this is not always so.

Consider the following definition of `append` which uses
[`fold_right`](/manual/api/List.html#VALfold_right)
([`fold_left`](/manual/api/List.html#VALfold_left) considers the
elements from the left,
[`fold_right`](/manual/api/List.html#VALfold_right) from the right):

```ocaml
# let append x y =
    List.fold_right (fun e a -> e :: a) x y;;
val append : 'a list -> 'a list -> 'a list = <fun>
```

In this example, the initial accumulator is the second list, and each element
of the first is consed to it in turn. You can see the order of the
fold right parameters is a little different:

```ocaml
# List.fold_right;;
- : ('a -> 'b -> 'b) -> 'a list -> 'b -> 'b = <fun>
```

The function comes first, then the list of elements, then the initial
accumulator value. We can use
[`fold_right`](/manual/api/List.html#VALfold_right) to define our
usual `map` function:

```ocaml
# let map f l =
    List.fold_right (fun e a -> f e :: a) l [];;
val map : ('a -> 'b) -> 'a list -> 'b list = <fun>
```

But care is needed. If we try that with
[`List.concat`](/manual/api/List.html#VALconcat), which turns a
list of lists into a list by concatenating the lists together, we produce this:

```ocaml
# let concat l = List.fold_left ( @ ) [] l;;
val concat : 'a list list -> 'a list = <fun>
```

Unfortunately, the order of evaluation here is such that larger and larger
items are passed to the `@` operator as its first argument, and so the function
has a worse running time than
[`List.concat`](/manual/api/List.html#VALconcat). You can read more
about the time and space efficiency of lists and other common OCaml data
structures in the [comparison of standard
containers](/docs/data-structures-comparison).

Here are some more redefinitions of familiar functions in terms of
[`fold_left`](/manual/api/List.html#VALfold_left) or
[`fold_right`](/manual/api/List.html#VALfold_right). Can you work
out how they operate?

```ocaml
# let length' l =
    List.fold_left (fun a _ -> a + 1) 0 l;;
val length' : 'a list -> int = <fun>
# let rev' l =
    List.fold_left (fun a e -> e :: a) [] l;;
val rev' : 'a list -> 'a list = <fun>
# let split' l =
    List.fold_right
      (fun (x, y) (xs, ys) -> (x :: xs, y :: ys))
      l
      ([], []);;
val split' : ('a * 'b) list -> 'a list * 'b list = <fun>
```

## Lists and Tail Recursion

The `length` function [previously
defined](https://ocaml.org/docs/lists#functions-on-lists) builds up an
intermediate expression of a size proportional to its input list:

```
   length [1; 2; 3]
=> 1 + length [2; 3]
=> 1 + (1 + length [3])
=> 1 + (1 + (1 + length []))
=> 1 + (1 + (1 + 0))
=> 1 + (1 + 1)
=> 1 + 2
=> 3
```

**Note** The above is not OCaml syntax, it is a sketch meant to explain how
evaluation of `length [1; 2; 3]` takes place. The sign `=>` indicates an
evaluation step.

For long lists, this may overflow the stack (be too large for the computer to
handle). The solution is to write our function with an accumulating parameter,
like this:

```ocaml
# let rec length acc l =
    match l with
    | [] -> acc
    | _ :: t -> length (acc + 1) t;;
val length : int -> 'a list -> int = <fun>
# let l = length 0 [1; 2; 3];;
val l : int = 3
```

This function now uses a constant amount of space on the stack:

```
   length 0 [1; 2; 3]
=> length 1 [2; 3]
=> length 2 [3]
=> length 3 []
=> 3
```

We call such a function *tail-recursive*. We may write a wrapper function so
that the initial accumulator value is supplied automatically:

```ocaml
# let rec length_inner acc l =
    match l with
    | [] -> acc
    | _ :: t -> length_inner (acc + 1) t;;
val length_inner : int -> 'a list -> int = <fun>
# let length l = length_inner 0 l;;
val length : 'a list -> int = <fun>
```

Or, we can do it all in one function:

```ocaml
# let length l =
    let rec length_inner acc l =
      match l with
      | [] -> acc
      | _ :: t -> length_inner (acc + 1) t
    in
      length_inner 0 l;;
val length : 'a list -> int = <fun>
```

In the standard library documentation, functions which are not tail-recursive
are marked.
