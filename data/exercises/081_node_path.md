---
title: Path From One Node to Another One
slug: "81"
difficulty: intermediate
tags: [ "graph" ]
description: "Return all acyclic paths between two nodes a and b in a given graph."
---

```ocaml
type 'a graph_term = {nodes : 'a list;  edges : ('a * 'a) list}
```

## Solution

```ocaml
# (* The datastructures used here are far from the most efficient ones
     but allow for a straightforward implementation. *)
  (* Returns all neighbors satisfying the condition. *)
  let neighbors g a cond =
    let edge l (b, c) = if b = a && cond c then c :: l
                        else if c = a && cond b then b :: l
                        else l in
    List.fold_left edge [] g.edges
  let rec list_path g a to_b = match to_b with
    | [] -> assert false (* [to_b] contains the path to [b]. *)
    | a' :: _ ->
       if a' = a then [to_b]
       else
         let n = neighbors g a' (fun c -> not (List.mem c to_b)) in
           List.concat_map (fun c -> list_path g a (c :: to_b)) n

  let paths g a b =
    assert(a <> b);
    list_path g a [b];;
val neighbors : 'a graph_term -> 'a -> ('a -> bool) -> 'a list = <fun>
val list_path : 'a graph_term -> 'a -> 'a list -> 'a list list = <fun>
val paths : 'a graph_term -> 'a -> 'a -> 'a list list = <fun>
```

## Statement

Write a function `paths g a b` that returns all acyclic path `p` from
node `a` to node `b ≠ a` in the graph `g`. The function should return
the list of all paths via backtracking.

```ocaml
# let example_graph =
  {nodes = ['b'; 'c'; 'd'; 'f'; 'g'; 'h'; 'k'];
   edges = [('h', 'g'); ('k', 'f'); ('f', 'b'); ('f', 'c'); ('c', 'b')]};;
val example_graph : char graph_term =
  {nodes = ['b'; 'c'; 'd'; 'f'; 'g'; 'h'; 'k'];
   edges = [('h', 'g'); ('k', 'f'); ('f', 'b'); ('f', 'c'); ('c', 'b')]}
# paths example_graph 'f' 'b';;
- : char list list = [['f'; 'c'; 'b']; ['f'; 'b']]
```
