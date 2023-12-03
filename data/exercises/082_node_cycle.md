---
title: Cycle From a Given Node
slug: "82"
difficulty: beginner
tags: [ "graph" ]
description: "Return all closed paths (cycles) starting at a given node a in the graph g."
---

```ocaml
type 'a graph_term = {nodes : 'a list;  edges : ('a * 'a) list}

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
```

# Solution

```ocaml
# let cycles g a =
    let n = neighbors g a (fun _ -> true) in
    let p = List.concat_map (fun c -> list_path g a [c]) n in
    List.map (fun p -> p @ [a]) p;;
val cycles : 'a graph_term -> 'a -> 'a list list = <fun>
```

# Statement

Write a functions `cycle g a` that returns a closed path (cycle) `p`
starting at a given node `a` in the graph `g`. The predicate should
return the list of all cycles via backtracking.

```ocaml
# let example_graph =
  {nodes = ['b'; 'c'; 'd'; 'f'; 'g'; 'h'; 'k'];
   edges = [('h', 'g'); ('k', 'f'); ('f', 'b'); ('f', 'c'); ('c', 'b')]};;
val example_graph : char graph_term =
  {nodes = ['b'; 'c'; 'd'; 'f'; 'g'; 'h'; 'k'];
   edges = [('h', 'g'); ('k', 'f'); ('f', 'b'); ('f', 'c'); ('c', 'b')]}
# cycles example_graph 'f';;
- : char list list =
[['f'; 'b'; 'c'; 'f']; ['f'; 'c'; 'f']; ['f'; 'c'; 'b'; 'f'];
 ['f'; 'b'; 'f']; ['f'; 'k'; 'f']]
```
