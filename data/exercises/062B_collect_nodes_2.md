---
title: Collect the Nodes at a Given Level in a List
slug: "62B"
difficulty: beginner
tags: [ "binary-tree" ]
description: "Returns a list of all nodes at a given level within a binary tree."
---

```ocaml
type 'a binary_tree =
  | Empty
  | Node of 'a * 'a binary_tree * 'a binary_tree
```

# Solution

```ocaml
# (* Having an accumulator acc prevents using inefficient List.append.
   * Every node at level N will be pushed directly into accumulator.
   * Not tail-recursive, but that is no problem since we have a binary tree and
   * and stack depth is logarithmic. *)
  let at_level t level =
    let rec at_level_aux t acc counter = match t with
      | Empty -> acc
      | Node (x, l, r) ->
        if counter=level then
          x :: acc
        else
          at_level_aux l (at_level_aux r acc (counter + 1)) (counter + 1)
    in
      at_level_aux t [] 1;;
val at_level : 'a binary_tree -> int -> 'a list = <fun>
```

# Statement

A node of a binary tree is at level N if the path from the root to the
node has length N-1. The root node is at level 1. Write a function
`at_level t l` to collect all nodes of the tree `t` at level `l` in a
list.

```ocaml
# let example_tree =
  Node ('a', Node ('b', Node ('d', Empty, Empty), Node ('e', Empty, Empty)),
       Node ('c', Empty, Node ('f', Node ('g', Empty, Empty), Empty)));;
val example_tree : char binary_tree =
  Node ('a', Node ('b', Node ('d', Empty, Empty), Node ('e', Empty, Empty)),
   Node ('c', Empty, Node ('f', Node ('g', Empty, Empty), Empty)))
# at_level example_tree 2;;
- : char list = ['b'; 'c']
```

Using `at_level` it is easy to construct a function `levelorder` which
creates the level-order sequence of the nodes. However, there are more
efficient ways to do that.
