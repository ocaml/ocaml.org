---
title: Layout a Binary Tree (1)
slug: "64"
difficulty: intermediate
tags: [ "binary-tree" ]
description: "Assign coordinates (x, y) to nodes in a binary tree, with x based on the inorder sequence and y based on the depth of the node."
---

```ocaml
type 'a binary_tree =
  | Empty
  | Node of 'a * 'a binary_tree * 'a binary_tree
```

# Solution

```ocaml
# let layout_binary_tree_1 t =
    let rec layout depth x_left = function
      (* This function returns a pair: the laid out tree and the first
       * free x location *)
      | Empty -> (Empty, x_left)
      | Node (v,l,r) ->
         let (l', l_x_max) = layout (depth + 1) x_left l in
         let (r', r_x_max) = layout (depth + 1) (l_x_max + 1) r in
           (Node ((v, l_x_max, depth), l', r'), r_x_max)
    in
      fst (layout 1 1 t);;
val layout_binary_tree_1 : 'a binary_tree -> ('a * int * int) binary_tree =
  <fun>
```

# Statement

As a preparation for drawing the tree, a layout algorithm is required to
determine the position of each node in a rectangular grid. Several
layout methods are conceivable, one of them is shown in the illustration.


![Binary Tree Grid](/media/problems/tree-layout1.gif)

In this layout strategy, the position of a node v is obtained by the
following two rules:

* *x(v)* is equal to the position of the node v in the *inorder*
 sequence;
* *y(v)* is equal to the depth of the node *v* in the tree.

In order to store the position of the nodes, we will enrich the value
at each node with the position `(x,y)`.

The tree pictured above is
```ocaml
# let example_layout_tree =
  let leaf x = Node (x, Empty, Empty) in
  Node ('n', Node ('k', Node ('c', leaf 'a',
                           Node ('h', Node ('g', leaf 'e', Empty), Empty)),
                 leaf 'm'),
       Node ('u', Node ('p', Empty, Node ('s', leaf 'q', Empty)), Empty));;
val example_layout_tree : char binary_tree =
  Node ('n',
   Node ('k',
    Node ('c', Node ('a', Empty, Empty),
     Node ('h', Node ('g', Node ('e', Empty, Empty), Empty), Empty)),
    Node ('m', Empty, Empty)),
   Node ('u', Node ('p', Empty, Node ('s', Node ('q', Empty, Empty), Empty)),
    Empty))
```

```ocaml
# layout_binary_tree_1 example_layout_tree;;
- : (char * int * int) binary_tree =
Node (('n', 8, 1),
 Node (('k', 6, 2),
  Node (('c', 2, 3), Node (('a', 1, 4), Empty, Empty),
   Node (('h', 5, 4),
    Node (('g', 4, 5), Node (('e', 3, 6), Empty, Empty), Empty), Empty)),
  Node (('m', 7, 3), Empty, Empty)),
 Node (('u', 12, 2),
  Node (('p', 9, 3), Empty,
   Node (('s', 11, 4), Node (('q', 10, 5), Empty, Empty), Empty)),
  Empty))
```
