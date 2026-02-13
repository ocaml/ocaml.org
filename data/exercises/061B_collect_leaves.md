---
title: Collect the Leaves of a Binary Tree in a List
slug: "61B"
difficulty: beginner
tags: [ "binary-tree" ]
description: "Extract all the leaf nodes from a binary tree and returns them as a list."
---

```ocaml
type 'a binary_tree =
  | Empty
  | Node of 'a * 'a binary_tree * 'a binary_tree
```

## Solution

```ocaml
# (* Having an accumulator acc prevents using inefficient List.append.
   * Every Leaf will be pushed directly into accumulator.
   * Not tail-recursive, but that is no problem since we have a binary tree and
   * and stack depth is logarithmic. *)
  let leaves t =
    let rec leaves_aux t acc = match t with
      | Empty -> acc
      | Node (x, Empty, Empty) -> x :: acc
      | Node (x, l, r) -> leaves_aux l (leaves_aux r acc)
    in
    leaves_aux t [];;
val leaves : 'a binary_tree -> 'a list = <fun>
```

## Statement

A leaf is a node with no successors. Write a function `leaves` to
collect them in a list.

```ocaml
# leaves Empty;;
- : 'a list = []
```
