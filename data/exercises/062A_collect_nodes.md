---
title: Collect the Internal Nodes of a Binary Tree in a List
slug: "62A"
difficulty: beginner
tags: [ "binary-tree" ]
description: "Collect and returns all the internal nodes from a binary tree as a list."
---

```ocaml
type 'a binary_tree =
  | Empty
  | Node of 'a * 'a binary_tree * 'a binary_tree
```

# Solution

```ocaml
# (* Having an accumulator acc prevents using inefficient List.append.
   * Every internal node will be pushed directly into accumulator.
   * Not tail-recursive, but that is no problem since we have a binary tree and
   * and stack depth is logarithmic. *)
  let internals t = 
    let rec internals_aux t acc = match t with
      | Empty -> acc
      | Node (x, Empty, Empty) -> acc
      | Node (x, l, r) -> internals_aux l (x :: internals_aux r acc)
    in
    internals_aux t [];;
val internals : 'a binary_tree -> 'a list = <fun>
```

# Statement

An internal node of a binary tree has either one or two non-empty
successors. Write a function `internals` to collect them in a list.

```ocaml
# internals (Node ('a', Empty, Empty));;
- : char list = []
```
