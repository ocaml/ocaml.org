---
title: Symmetric Binary Trees
slug: "56"
difficulty: intermediate
tags: [ "binary-tree" ]
description: "Determine if a given binary tree is symmetric, meaning its right subtree is a mirror image of its left subtree."
---

```ocaml
type 'a binary_tree =
  | Empty
  | Node of 'a * 'a binary_tree * 'a binary_tree
```

# Solution

```ocaml
# let rec is_mirror t1 t2 =
    match t1, t2 with
    | Empty, Empty -> true
    | Node(_, l1, r1), Node(_, l2, r2) ->
       is_mirror l1 r2 && is_mirror r1 l2
    | _ -> false

  let is_symmetric = function
    | Empty -> true
    | Node(_, l, r) -> is_mirror l r;;
val is_mirror : 'a binary_tree -> 'b binary_tree -> bool = <fun>
val is_symmetric : 'a binary_tree -> bool = <fun>
```

# Statement

Let us call a binary tree symmetric if you can draw a vertical line
through the root node and then the right subtree is the mirror image of
the left subtree. Write a function `is_symmetric` to check whether a
given binary tree is symmetric.

**Hint:** Write a function `is_mirror` first to check whether one tree
 is the mirror image of another. We are only interested in the
 structure, not in the contents of the nodes.
