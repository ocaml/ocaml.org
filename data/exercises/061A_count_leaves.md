---
title: Count the Leaves of a Binary Tree
slug: "61A"
difficulty: beginner
tags: [ "binary-tree" ]
description: "Count the number of leaf nodes in a binary tree."
tutorials: [ "basic-data-types"]
---

```ocaml
type 'a binary_tree =
  | Empty
  | Node of 'a * 'a binary_tree * 'a binary_tree
```

# Solution

```ocaml
# let rec count_leaves = function
    | Empty -> 0
    | Node (_, Empty, Empty) -> 1
    | Node (_, l, r) -> count_leaves l + count_leaves r;;
val count_leaves : 'a binary_tree -> int = <fun>
```

# Statement

A leaf is a node with no successors. Write a function `count_leaves` to
count them.

```ocaml
# count_leaves Empty;;
- : int = 0
```
