---
title: Depth-First Order Graph Traversal
slug: "87"
difficulty: intermediate
tags: [ "graph" ]
description: "Generate a depth-first order graph traversal sequence using the given adjacency-list representation, starting from a specified point."
tutorials: [ "maps"]
---

```ocaml
module type GRAPH = sig
  type node = char
  type t
  val of_adjacency : (node * node list) list -> t
  val dfs_fold : t -> node -> ('a -> node -> 'a) -> 'a -> 'a
end
```

# Solution

In a depth-first search you fully explore the edges of the most
recently discovered node *v* before 'backtracking' to explore edges
leaving the node from which *v* was discovered. To do a depth-first
search means keeping careful track of what vertices have been visited
and when.

We compute timestamps for each vertex discovered in the search. A
discovered vertex has two timestamps associated with it : its
discovery time (in map `d`) and its finishing time (in map `f`) (a
vertex is finished when its adjacency list has been completely
examined). These timestamps are often useful in graph algorithms and
aid in reasoning about the behavior of depth-first search.

We color nodes during the search to help in the bookkeeping (map
`color`). All vertices of the graph are initially `White`. When a
vertex is discovered it is marked `Gray` and when it is finished, it
is marked `Black`.

If vertex *v* is discovered in the adjacency list of previously
discovered node *u*, this fact is recorded in the predecessor subgraph
(map `pred`).

```ocaml
# module M : GRAPH = struct

    module Char_map = Map.Make (Char)
    type node = char
    type t = (node list) Char_map.t

    let of_adjacency l = 
      List.fold_right (fun (x, y) -> Char_map.add x y) l Char_map.empty

    type colors = White|Gray|Black

    type 'a state = {
        d : int Char_map.t; (*discovery time*)
      f : int Char_map.t; (*finishing time*)
      pred : char Char_map.t; (*predecessor*)
      color : colors Char_map.t; (*vertex colors*)
      acc : 'a; (*user specified type used by 'fold'*)
    }

    let dfs_fold g c fn acc =
      let rec dfs_visit t u {d; f; pred; color; acc} =
        let edge (t, state) v =
          if Char_map.find v state.color = White then
            dfs_visit t v {state with pred = Char_map.add v u state.pred}
          else  (t, state)
        in
        let t, {d; f; pred; color; acc} =
          let t = t + 1 in
          List.fold_left edge
            (t, {d = Char_map.add u t d; f;
                 pred; color = Char_map.add u Gray color; acc = fn acc u})
            (Char_map.find u g)
        in
        let t = t + 1 in
        t , {d; f = Char_map.add u t f; pred;
             color = Char_map.add u Black color; acc}
      in
      let v = List.fold_left (fun k (x, _) -> x :: k) []
                             (Char_map.bindings g) in
      let initial_state= 
        {d = Char_map.empty;
         f = Char_map.empty;
         pred = Char_map.empty;
         color = List.fold_right (fun x -> Char_map.add x White)
                                 v Char_map.empty;
         acc}
      in
      (snd (dfs_visit 0 c initial_state)).acc
  end;;
module M : GRAPH
```

# Statement

Write a function that generates a
[depth-first order graph traversal](https://en.wikipedia.org/wiki/Depth-first_search)
sequence. The starting point should be specified, and the output should
be a list of nodes that are reachable from this starting point (in
depth-first order).

Specifically, the graph will be provided by its
[adjacency-list representation](https://en.wikipedia.org/wiki/Adjacency_list)
and you must create a module `M` with the following signature:

```ocaml
# module type GRAPH = sig
    type node = char
    type t
    val of_adjacency : (node * node list) list -> t
    val dfs_fold : t -> node -> ('a -> node -> 'a) -> 'a -> 'a
  end;;
module type GRAPH =
  sig
    type node = char
    type t
    val of_adjacency : (node * node list) list -> t
    val dfs_fold : t -> node -> ('a -> node -> 'a) -> 'a -> 'a
  end
```

where `M.dfs_fold g n f a` applies `f` on the nodes of the graph
`g` in depth first order, starting with node `n`.

```ocaml
# let g = M.of_adjacency
          ['u', ['v'; 'x'];
           'v',      ['y'];
           'w', ['z'; 'y'];
           'x',      ['v'];
           'y',      ['x'];
           'z',      ['z'];
          ];;
val g : M.t = <abstr>
```
