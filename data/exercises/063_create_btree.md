---
title: Construct a Complete Binary Tree
slug: "63"
difficulty: intermediate
tags: [ "binary-tree" ]
description: "Construct a complete binary tree from a list of elements, and make sure it satisfies the property of being 'left-adjusted'."
---

```ocaml
type 'a binary_tree =
  | Empty
  | Node of 'a * 'a binary_tree * 'a binary_tree
```

## Solution

```ocaml
# let rec split_n lst acc n = match (n, lst) with
    | (0, _) -> (List.rev acc, lst)
    | (_, []) -> (List.rev acc, [])
    | (_, h :: t) -> split_n t (h :: acc) (n-1)

  let rec myflatten p c =
    match (p, c) with
    | (p, []) -> List.map (fun x -> Node (x, Empty, Empty)) p
    | (x :: t, [y]) -> Node (x, y, Empty) :: myflatten t []
    | (ph :: pt, x :: y :: t) -> (Node (ph, x, y)) :: myflatten pt t
    | _ -> invalid_arg "myflatten"

  let complete_binary_tree = function
    | [] -> Empty
    | lst ->
       let rec aux l = function
         | [] -> []
         | lst -> let p, c = split_n lst [] (1 lsl l) in
                  myflatten p (aux (l + 1) c)
       in
         List.hd (aux 0 lst);;
val split_n : 'a list -> 'a list -> int -> 'a list * 'a list = <fun>
val myflatten : 'a list -> 'a binary_tree list -> 'a binary_tree list = <fun>
val complete_binary_tree : 'a list -> 'a binary_tree = <fun>
```

## Statement

A *complete* binary tree with height H is defined as follows: The levels
1,2,3,...,H-1 contain the maximum number of nodes (i.e. 2<sup>i-1</sup>
at the level i, note that we start counting the levels from 1 at the
root). In level H, which may contain less than the maximum possible
number of nodes, all the nodes are "left-adjusted". This means that in a
levelorder tree traversal all internal nodes come first, the leaves come
second, and empty successors (the nil's which are not really nodes!)
come last.

Particularly, complete binary trees are used as data structures (or
addressing schemes) for heaps.

We can assign an address number to each node in a complete binary tree
by enumerating the nodes in levelorder, starting at the root with
number 1. In doing so, we realize that for every node X with address A
the following property holds: The address of X's left and right
successors are 2\*A and 2\*A+1, respectively, supposed the successors do
exist. This fact can be used to elegantly construct a complete binary
tree structure. Write a function `is_complete_binary_tree` with the
following specification: `is_complete_binary_tree n t` returns `true`
iff `t` is a complete binary tree with `n` nodes.

```ocaml
# complete_binary_tree [1; 2; 3; 4; 5; 6];;
- : int binary_tree =
Node (1, Node (2, Node (4, Empty, Empty), Node (5, Empty, Empty)),
 Node (3, Node (6, Empty, Empty), Empty))
```
