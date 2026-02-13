---
title: Construct the Minimal Spanning Tree
slug: "84"
difficulty: intermediate
tags: [ "graph" ]
description: "Construct the minimal spanning tree of a given labeled graph."
---

## Solution

```ocaml
(* solution pending *);;
```

## Statement

![Spanning tree graph](/media/problems/spanning-tree-graph2.gif)

Write a function `ms_tree graph` to construct the minimal spanning tree
of a given labelled graph. A labelled graph will be represented as
follows:

```ocaml
# type ('a, 'b) labeled_graph = {nodes : 'a list;
                               labeled_edges : ('a * 'a * 'b) list};;
type ('a, 'b) labeled_graph = {
  nodes : 'a list;
  labeled_edges : ('a * 'a * 'b) list;
}
```

(Beware that from now on `nodes` and `edges` mask the previous fields of
the same name.)

**Hint:** Use the [algorithm of Prim](http://en.wikipedia.org/wiki/Prim%27s_algorithm).
A small modification of the solution of P83 does the trick. The data of the
example graph to the right can be found below.

```ocaml
# let g = {nodes = ['a'; 'b'; 'c'; 'd'; 'e'; 'f'; 'g'; 'h'];
         labeled_edges = [('a', 'b', 5); ('a', 'd', 3); ('b', 'c', 2);
                          ('b', 'e', 4); ('c', 'e', 6); ('d', 'e', 7);
                          ('d', 'f', 4); ('d', 'g', 3); ('e', 'h', 5);
                          ('f', 'g', 4); ('g', 'h', 1)]};;
val g : (char, int) labeled_graph =
  {nodes = ['a'; 'b'; 'c'; 'd'; 'e'; 'f'; 'g'; 'h'];
   labeled_edges =
    [('a', 'b', 5); ('a', 'd', 3); ('b', 'c', 2); ('b', 'e', 4);
     ('c', 'e', 6); ('d', 'e', 7); ('d', 'f', 4); ('d', 'g', 3);
     ('e', 'h', 5); ('f', 'g', 4); ('g', 'h', 1)]}
```
