---
title: Graph Isomorphism
slug: "85"
difficulty: intermediate
tags: [ "graph" ]
description: "Determine whether two graphs are isomorphic based on the given definition and hint."
---

```ocaml
type 'a graph_term = {nodes : 'a list;  edges : ('a * 'a) list}
```

## Solution

```ocaml
(* solution pending *);;
```

## Statement

Two graphs G1(N1,E1) and G2(N2,E2) are isomorphic if there is a
bijection f: N1 → N2 such that for any nodes X,Y of N1, X and Y are
adjacent if and only if f(X) and f(Y) are adjacent.

Write a function that determines whether two graphs are isomorphic.

**Hint:** Use an open-ended list to represent the function f.

```ocaml
# let g = {nodes = [1; 2; 3; 4; 5; 6; 7; 8];
         edges = [(1, 5); (1, 6); (1, 7); (2, 5); (2, 6); (2, 8); (3, 5);
                  (3, 7); (3, 8); (4, 6); (4, 7); (4, 8)]};;
val g : int graph_term =
  {nodes = [1; 2; 3; 4; 5; 6; 7; 8];
   edges =
    [(1, 5); (1, 6); (1, 7); (2, 5); (2, 6); (2, 8); (3, 5); (3, 7);
     (3, 8); (4, 6); (4, 7); (4, 8)]}
```
