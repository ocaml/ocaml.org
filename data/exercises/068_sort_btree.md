---
title: Preorder and Inorder Sequences of Binary Trees
slug: "68"
difficulty: intermediate
tags: [ "binary-tree" ]
description: "Generate the preorder and inorder sequences of a binary tree."
---

```ocaml
type 'a binary_tree =
  | Empty
  | Node of 'a * 'a binary_tree * 'a binary_tree
```

## Solution

We use lists to represent the result. Note that `preorder` and `inorder` can be made more efficient by avoiding list concatenations.

```ocaml
# let rec preorder = function
    | Empty -> []
    | Node (v, l, r) -> v :: (preorder l @ preorder r)
    let rec inorder = function
    | Empty -> []
    | Node (v, l, r) -> inorder l @ (v :: inorder r)
    let rec split_pre_in p i x accp acci = match (p, i) with
    | [], [] -> (List.rev accp, List.rev acci), ([], [])
    | h1 :: t1, h2 :: t2 ->
       if x = h2 then
         (List.tl (List.rev (h1 :: accp)), t1),
         (List.rev (List.tl (h2 :: acci)), t2)
       else
         split_pre_in t1 t2 x (h1 :: accp) (h2 :: acci)
    | _ -> assert false
    let rec pre_in_tree p i = match (p, i) with
    | [], [] -> Empty
    | (h1 :: t1), (h2 :: t2) ->
       let (lp, rp), (li, ri) = split_pre_in p i h1 [] [] in
         Node (h1, pre_in_tree lp li, pre_in_tree rp ri)
    | _ -> invalid_arg "pre_in_tree";;
val preorder : 'a binary_tree -> 'a list = <fun>
val inorder : 'a binary_tree -> 'a list = <fun>
val split_pre_in :
  'a list ->
  'a list ->
  'a -> 'a list -> 'a list -> ('a list * 'a list) * ('a list * 'a list) =
  <fun>
val pre_in_tree : 'a list -> 'a list -> 'a binary_tree = <fun>
```

Solution using
[difference lists](https://en.wikipedia.org/wiki/Difference_list).

```ocaml
  (* solution pending *)
```


## Statement

We consider binary trees with nodes that are identified by single
lower-case letters, as in the example of the previous problem.

1. Write functions `preorder` and `inorder`
   that construct the
   [preorder](https://en.wikipedia.org/wiki/Tree_traversal#Pre-order)
   and
   [inorder](https://en.wikipedia.org/wiki/Tree_traversal#In-order_.28symmetric.29)
 sequence of a given binary tree, respectively. The
 results should be atoms, e.g. 'abdecfg' for the preorder sequence of
 the example in the previous problem.
1. Can you use `preorder` from problem part 1 in the reverse
 direction; i.e. given a preorder sequence, construct a corresponding
 tree? If not, make the necessary arrangements.
1. If both the preorder sequence and the inorder sequence of the nodes
 of a binary tree are given, then the tree is determined
 unambiguously. Write a function `pre_in_tree` that does the job.
1. Solve problems 1 to 3 using
   [difference lists](https://en.wikipedia.org/wiki/Difference_list).
   Cool!  Use the
 function `timeit` (defined in problem “[Compare the two methods of
 calculating Euler&#39;s totient function.](#38)”) to compare the
 solutions.

What happens if the same character appears in more than one node. Try
for instance `pre_in_tree "aba" "baa"`.

```ocaml
# preorder (Node (1, Node (2, Empty, Empty), Empty));;
- : int list = [1; 2]
```
