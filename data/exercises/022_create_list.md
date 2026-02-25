---
title: Create a List Containing All Integers Within a Given Range
slug: "22"
difficulty: beginner
tags: [ "list" ]
description: "Generate a list of integers in ascending order from A to B, and in descending order if A is greater than B."
tutorials: [ "lists", "loops-recursion" ]
---

## Solution

```ocaml
# let range a b =
    let rec aux a b =
      if a > b then [] else a :: aux (a + 1) b
    in
      if a > b then List.rev (aux b a) else aux a b;;
val range : int -> int -> int list = <fun>
```

A tail recursive implementation:

```ocaml
# let range a b =
    let rec aux acc high low =
      if high >= low then
        aux (high :: acc) (high - 1) low
      else acc
    in
      if a < b then aux [] b a else List.rev (aux [] a b);;
val range : int -> int -> int list = <fun>
```

## Statement

If first argument is greater than second, produce a list in decreasing
order.

```ocaml
# range 4 9;;
- : int list = [4; 5; 6; 7; 8; 9]
```
