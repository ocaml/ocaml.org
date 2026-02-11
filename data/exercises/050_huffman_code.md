---
title: Huffman Code
slug: "50"
difficulty: advanced
tags: [ "logic" ]
description: "Generate Huffman codes for a set of symbols with their respective frequencies using the huffman function."
---

## Solution

```ocaml
# (* Simple priority queue where the priorities are integers 0..100.
     The node with the lowest probability comes first. *)
  module Pq = struct
    type 'a t = {data: 'a list array; mutable first: int}
    let make() = {data = Array.make 101 []; first = 101}
        let add q p x =
      q.data.(p) <- x :: q.data.(p);  q.first <- min p q.first
          let get_min q =
      if q.first = 101 then None else
        match q.data.(q.first) with
        | [] -> assert false
        | x :: tl ->
           let p = q.first in
           q.data.(q.first) <- tl;
           while q.first < 101 && q.data.(q.first) = [] do
             q.first <- q.first + 1
           done;
           Some(p, x)
  end
    type tree =
    | Leaf of string
    | Node of tree * tree
      let rec huffman_tree q =
    match Pq.get_min q, Pq.get_min q with
    | Some(p1, t1), Some(p2, t2) -> Pq.add q (p1 + p2) (Node(t1, t2));
                                    huffman_tree q
    | Some(_, t), None | None, Some(_, t) -> t
    | None, None -> assert false
      (* Build the prefix-free binary code from the tree *)
  let rec prefixes_of_tree prefix = function
    | Leaf s -> [(s, prefix)]
    | Node(t0, t1) ->  prefixes_of_tree (prefix ^ "0") t0
                     @ prefixes_of_tree (prefix ^ "1") t1
                       let huffman fs =
    if List.fold_left (fun s (_, p) -> s + p) 0 fs <> 100 then
      failwith "huffman: sum of weights must be 100";
    let q = Pq.make () in
    List.iter (fun (s, f) -> Pq.add q f (Leaf s)) fs;
    prefixes_of_tree "" (huffman_tree q);;
module Pq :
  sig
    type 'a t = { data : 'a list array; mutable first : int; }
    val make : unit -> 'a t
    val add : 'a t -> int -> 'a -> unit
    val get_min : 'a t -> (int * 'a) option
  end
type tree = Leaf of string | Node of tree * tree
val huffman_tree : tree Pq.t -> tree = <fun>
val prefixes_of_tree : string -> tree -> (string * string) list = <fun>
val huffman : (string * int) list -> (string * string) list = <fun>
```

## Statement

First of all, consult a good book on discrete mathematics or algorithms
for a detailed description of Huffman codes (you can start with the
[Wikipedia page](http://en.wikipedia.org/wiki/Huffman_coding))!

We consider a set of symbols with their frequencies.
For example, if the alphabet is `"a"`,..., `"f"`
(represented as the positions 0,...5) and
respective frequencies are 45, 13, 12, 16, 9, 5:

```ocaml
# let fs = [("a", 45); ("b", 13); ("c", 12); ("d", 16);
          ("e", 9); ("f", 5)];;
val fs : (string * int) list =
  [("a", 45); ("b", 13); ("c", 12); ("d", 16); ("e", 9); ("f", 5)]
```

Our objective is to construct the
Huffman code `c` word for all symbols `s`. In our example, the result could
be
`hs = [("a", "0"); ("b", "101"); ("c", "100"); ("d", "111");
("e", "1101"); ("f", "1100")]`
(or `hs = [("a", "1");...]`). The task shall be performed by the function
`huffman` defined as follows: `huffman(fs)` returns the Huffman code
table for the frequency table `fs`

```ocaml
# huffman fs;;
- : (string * string) list =
[("a", "0"); ("c", "100"); ("b", "101"); ("f", "1100"); ("e", "1101");
 ("d", "111")]
```
