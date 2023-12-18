---
title: Construct the Bottom-Up Order Sequence of the Tree Nodes
slug: "72"
difficulty: beginner
tags: [ "multiway-tree" ]
description: "Construct the bottom-up sequence of nodes in a given multiway tree."
---

```ocaml
type 'a mult_tree = T of 'a * 'a mult_tree list

let t = T ('a', [T ('f', [T ('g', [])]); T ('c', []);
          T ('b', [T ('d', []); T ('e', [])])])
```

# Solution

```ocaml
# let rec prepend_bottom_up (T (c, sub)) l =
    List.fold_right (fun t l -> prepend_bottom_up t l) sub (c :: l)
  let bottom_up t = prepend_bottom_up t [];;
val prepend_bottom_up : 'a mult_tree -> 'a list -> 'a list = <fun>
val bottom_up : 'a mult_tree -> 'a list = <fun>
```

# Statement

Write a function `bottom_up t` which constructs the bottom-up sequence
of the nodes of the multiway tree `t`.

```ocaml
# bottom_up (T ('a', [T ('b', [])]));;
- : char list = ['b'; 'a']
# bottom_up t;;
- : char list = ['g'; 'f'; 'c'; 'd'; 'e'; 'b'; 'a']
```
