---
title: Generate-and-Test Paradigm
slug: "58"
difficulty: intermediate
tags: [ "binary-tree" ]
description: "Generate symmetric, balanced binary trees for a given number of nodes and determine the number of such trees for 57 nodes."
---

```ocaml
type 'a binary_tree =
  | Empty
  | Node of 'a * 'a binary_tree * 'a binary_tree

let rec is_mirror t1 t2 =
    match t1, t2 with
    | Empty, Empty -> true
    | Node(_, l1, r1), Node(_, l2, r2) ->
       is_mirror l1 r2 && is_mirror r1 l2
    | _ -> false

let is_symmetric = function
  | Empty -> true
  | Node(_, l, r) -> is_mirror l r

let add_trees_with left right all =
    let add_right_tree all l =
      List.fold_left (fun a r -> Node ('x', l, r) :: a) all right in
    List.fold_left add_right_tree all left

let rec cbal_tree n =
    if n = 0 then [Empty]
    else if n mod 2 = 1 then
      let t = cbal_tree (n / 2) in
      add_trees_with t t []
    else (* n even: n-1 nodes for the left & right subtrees altogether. *)
      let t1 = cbal_tree (n / 2 - 1) in
      let t2 = cbal_tree (n / 2) in
      add_trees_with t1 t2 (add_trees_with t2 t1 [])
```

# Solution

```ocaml
# let sym_cbal_trees n =
    List.filter is_symmetric (cbal_tree n);;
val sym_cbal_trees : int -> char binary_tree list = <fun>
```

# Statement

Apply the generate-and-test paradigm to construct all symmetric,
completely balanced binary trees with a given number of nodes.

```ocaml
# sym_cbal_trees 5;;
- : char binary_tree list =
[Node ('x', Node ('x', Node ('x', Empty, Empty), Empty),
  Node ('x', Empty, Node ('x', Empty, Empty)));
 Node ('x', Node ('x', Empty, Node ('x', Empty, Empty)),
  Node ('x', Node ('x', Empty, Empty), Empty))]
```

How many such trees are there with 57 nodes? Investigate about how many
solutions there are for a given number of nodes? What if the number is
even? Write an appropriate function.

```ocaml
# List.length (sym_cbal_trees 57);;
- : int = 256
```
