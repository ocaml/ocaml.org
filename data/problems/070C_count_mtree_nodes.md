---
title: Count the nodes of a multiway tree
number: "70C"
difficulty: beginner
tags: [ "multiway-tree" ]
---

```ocaml
type 'a mult_tree = T of 'a * 'a mult_tree list
```

# Solution

```ocaml
# let rec count_nodes (T (_, sub)) =
    List.fold_left (fun n t -> n + count_nodes t) 1 sub;;
val count_nodes : 'a mult_tree -> int = <fun>
```

# Statement

```ocaml
# count_nodes (T ('a', [T ('f', []) ]));;
- : int = 2
```
