---
title: Layout a Binary Tree (2)
slug: "65"
difficulty: intermediate
tags: [ "binary-tree" ]
description: "Arrange nodes in a binary tree according to specific rules, assigning positions to each node."
---

```ocaml
type 'a binary_tree =
  | Empty
  | Node of 'a * 'a binary_tree * 'a binary_tree
```

## Solution

```ocaml
# let layout_binary_tree_2 t =
    let rec height = function
      | Empty -> 0
      | Node (_, l, r) -> 1 + max (height l) (height r) in
    let tree_height = height t in
    let rec find_missing_left depth = function
      | Empty -> tree_height - depth
      | Node (_, l, _) -> find_missing_left (depth + 1) l in
    let translate_dst = 1 lsl (find_missing_left 0 t) - 1 in
                        (* remember than 1 lsl a = 2ᵃ *)
    let rec layout depth x_root = function
      | Empty -> Empty
      | Node (x, l, r) ->
         let spacing = 1 lsl (tree_height - depth - 1) in
         let l' = layout (depth + 1) (x_root - spacing) l
         and r' = layout (depth + 1) (x_root + spacing) r in
           Node((x, x_root, depth), l',r') in
    layout 1 ((1 lsl (tree_height - 1)) - translate_dst) t;;
val layout_binary_tree_2 : 'a binary_tree -> ('a * int * int) binary_tree =
  <fun>
```

## Statement

![Binary Tree Grid](/media/problems/tree-layout2.gif)

An alternative layout method is depicted in this illustration. Find
out the rules and write the corresponding OCaml function.

**Hint:** On a given level, the horizontal distance between
neighbouring nodes is constant.

The tree shown is 
```ocaml
# let example_layout_tree =
  let leaf x = Node (x, Empty, Empty) in
  Node ('n', Node ('k', Node ('c', leaf 'a',
                           Node ('e', leaf 'd', leaf 'g')),
                 leaf 'm'),
       Node ('u', Node ('p', Empty, leaf 'q'), Empty));;
val example_layout_tree : char binary_tree =
  Node ('n',
   Node ('k',
    Node ('c', Node ('a', Empty, Empty),
     Node ('e', Node ('d', Empty, Empty), Node ('g', Empty, Empty))),
    Node ('m', Empty, Empty)),
   Node ('u', Node ('p', Empty, Node ('q', Empty, Empty)), Empty))
```

```ocaml
# layout_binary_tree_2 example_layout_tree ;;
- : (char * int * int) binary_tree =
Node (('n', 15, 1),
 Node (('k', 7, 2),
  Node (('c', 3, 3), Node (('a', 1, 4), Empty, Empty),
   Node (('e', 5, 4), Node (('d', 4, 5), Empty, Empty),
    Node (('g', 6, 5), Empty, Empty))),
  Node (('m', 11, 3), Empty, Empty)),
 Node (('u', 23, 2),
  Node (('p', 19, 3), Empty, Node (('q', 21, 4), Empty, Empty)), Empty))
```
