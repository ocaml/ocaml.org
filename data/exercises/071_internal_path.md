---
title: Determine the Internal Path Length of a Tree
slug: "71"
difficulty: beginner
tags: [ "multiway-tree" ]
description: "Calculate and return the internal path length of a multiway tree"
---

```ocaml
type 'a mult_tree = T of 'a * 'a mult_tree list

let t = T ('a', [T ('f', [T ('g', [])]); T ('c', []);
          T ('b', [T ('d', []); T ('e', [])])])
```

## Solution

```ocaml
# let rec ipl_sub len (T(_, sub)) =
    (* [len] is the distance of the current node to the root.  Add the
       distance of all sub-nodes. *)
    List.fold_left (fun sum t -> sum + ipl_sub (len + 1) t) len sub
  let ipl t = ipl_sub 0 t;;
val ipl_sub : int -> 'a mult_tree -> int = <fun>
val ipl : 'a mult_tree -> int = <fun>
```

## Statement

We define the internal path length of a multiway tree as the total sum
of the path lengths from the root to all nodes of the tree. By this
definition, the tree `t` in the figure of the previous problem has an
internal path length of 9. Write a function `ipl tree` that returns the
internal path length of `tree`.

```ocaml
# ipl t;;
- : int = 9
```
