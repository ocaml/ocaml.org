---
title: Construct Height-Balanced Binary Trees With a Given Number of Nodes
slug: "60"
difficulty: intermediate
tags: [ "binary-tree" ]
description: "Calculate the maximum and minimum number of nodes, height, and generate all height-balanced binary trees."
tutorials: [ "basic-data-types" ]
---

```ocaml
type 'a binary_tree =
  | Empty
  | Node of 'a * 'a binary_tree * 'a binary_tree

let max_nodes h = 1 lsl h - 1
```

## Solution

### Minimum of nodes

The following solution comes directly from translating the question.

```ocaml
# let rec min_nodes h =
    if h <= 0 then 0
    else if h = 1 then 1
    else min_nodes (h - 1) + min_nodes (h - 2) + 1;;
val min_nodes : int -> int = <fun>
```

It is not the more efficient one however.  One should use the last
two values as the state to avoid the double recursion.

```ocaml
# let rec min_nodes_loop m0 m1 h =
    if h <= 1 then m1
    else min_nodes_loop m1 (m1 + m0 + 1) (h - 1)
    let min_nodes h =
    if h <= 0 then 0 else min_nodes_loop 0 1 h;;
val min_nodes_loop : int -> int -> int -> int = <fun>
val min_nodes : int -> int = <fun>
```

It is not difficult to show that `min_nodes h` = F<sub>h+2‌</sub> - 1,
where (F<sub>n</sub>) is the
[Fibonacci sequence](https://en.wikipedia.org/wiki/Fibonacci_number).

### Minimum height

Inverting the formula max_nodes = 2<sup>`h`</sup> - 1, one directly
find that Hₘᵢₙ(n) = ⌈log₂(n+1)⌉ which is readily implemented:

```ocaml
# let min_height n = int_of_float (ceil (log (float(n + 1)) /. log 2.));;
val min_height : int -> int = <fun>
```

Let us give a proof that the formula for Hₘᵢₙ is valid.  First, if h
= `min_height` n, there exists a height-balanced tree of height h
with n nodes.  Thus 2ʰ - 1 = `max_nodes h` ≥ n i.e., h ≥ log₂(n+1).
To establish equality for Hₘᵢₙ(n), one has to show that, for any n,
there exists a height-balanced tree with height Hₘᵢₙ(n).  This is
due to the relation Hₘᵢₙ(n) = 1 + Hₘᵢₙ(n/2) where n/2 is the integer
division.  For n odd, this is readily proved — so one can build a
tree with a top node and two sub-trees with n/2 nodes of height
Hₘᵢₙ(n) - 1.  For n even, the same proof works if one first remarks
that, in that case, ⌈log₂(n+2)⌉ = ⌈log₂(n+1)⌉ — use log₂(n+1) ≤ h ∈
ℕ ⇔ 2ʰ ≥ n + 1 and the fact that 2ʰ is even for that.  This allows
to have a sub-tree with n/2 nodes.  For the other sub-tree with
n/2-1 nodes, one has to establish that Hₘᵢₙ(n/2-1) ≥ Hₘᵢₙ(n) - 2
which is easy because, if h = Hₘᵢₙ(n/2-1), then h+2 ≥ log₂(2n) ≥
log₂(n+1).

The above function is not the best one however.  Indeed, not every
64 bits integer can be represented exactly as a floating point
number.  Here is one that only uses integer operations:

```ocaml
# let rec ceil_log2_loop log plus1 n =
    if n = 1 then if plus1 then log + 1 else log
    else ceil_log2_loop (log + 1) (plus1 || n land 1 <> 0) (n / 2)
    let ceil_log2 n = ceil_log2_loop 0 false n;;
val ceil_log2_loop : int -> bool -> int -> int = <fun>
val ceil_log2 : int -> int = <fun>
```

This algorithm is still not the fastest however.  See for example
the [Hacker's Delight](http://www.hackersdelight.org/), section 5-3
(and 11-4).

Following the same idea as above, if h = `max_height` n, then one
easily deduces that `min_nodes` h ≤ n < `min_nodes`(h+1).  This
yields the following code:

```ocaml
# let rec max_height_search h n =
    if min_nodes h <= n then max_height_search (h + 1) n else h - 1
  let max_height n = max_height_search 0 n;;
val max_height_search : int -> int -> int = <fun>
val max_height : int -> int = <fun>
```

Of course, since `min_nodes` is computed recursively, there is no
need to recompute everything to go from `min_nodes h` to
`min_nodes(h+1)`:

```ocaml
# let rec max_height_search h m_h m_h1 n =
    if m_h <= n then max_height_search (h + 1) m_h1 (m_h1 + m_h + 1) n else h - 1
    let max_height n = max_height_search 0 0 1 n;;
val max_height_search : int -> int -> int -> int -> int = <fun>
val max_height : int -> int = <fun>
```

### Constructing trees

First, we define some convenience functions `fold_range` that folds
a function `f` on the range `n0`...`n1` i.e., it computes
`f (... f (f (f init n0) (n0+1)) (n0+2) ...) n1`.  You can think it
as performing the assignment `init ← f init n` for `n = n0,..., n1`
except that there is no mutable variable in the code.

```ocaml
# let rec fold_range ~f ~init n0 n1 =
    if n0 > n1 then init else fold_range ~f ~init:(f init n0) (n0 + 1) n1;;
val fold_range : f:('a -> int -> 'a) -> init:'a -> int -> int -> 'a = <fun>
```

When constructing trees, there is an obvious symmetry: if one swaps
the left and right sub-trees of a balanced tree, we still have a
balanced tree.  The following function returns all trees in `trees`
together with their permutation.

```ocaml
# let rec add_swap_left_right trees =
    List.fold_left (fun a n -> match n with
                               | Node (v, t1, t2) -> Node (v, t2, t1) :: a
                               | Empty -> a) trees trees;;
val add_swap_left_right : 'a binary_tree list -> 'a binary_tree list = <fun>
```

Finally we generate all trees recursively, using a priori the bounds
computed above.  It could be further optimized but our aim is to
straightforwardly express the idea.

```ocaml
# let rec hbal_tree_nodes_height h n =
    assert(min_nodes h <= n && n <= max_nodes h);
    if h = 0 then [Empty]
    else
      let acc = add_hbal_tree_node [] (h - 1) (h - 2) n in
      let acc = add_swap_left_right acc in
      add_hbal_tree_node acc (h - 1) (h - 1) n
  and add_hbal_tree_node l h1 h2 n =
    let min_n1 = max (min_nodes h1) (n - 1 - max_nodes h2) in
    let max_n1 = min (max_nodes h1) (n - 1 - min_nodes h2) in
    fold_range min_n1 max_n1 ~init:l ~f:(fun l n1 ->
        let t1 = hbal_tree_nodes_height h1 n1 in
        let t2 = hbal_tree_nodes_height h2 (n - 1 - n1) in
        List.fold_left (fun l t1 ->
            List.fold_left (fun l t2 -> Node ('x', t1, t2) :: l) l t2) l t1
      )
      let hbal_tree_nodes n =
    fold_range (min_height n) (max_height n) ~init:[] ~f:(fun l h ->
        List.rev_append (hbal_tree_nodes_height h n) l);;
val hbal_tree_nodes_height : int -> int -> char binary_tree list = <fun>
val add_hbal_tree_node :
  char binary_tree list -> int -> int -> int -> char binary_tree list = <fun>
val hbal_tree_nodes : int -> char binary_tree list = <fun>
```

## Statement

Consider a height-balanced binary tree of height `h`. What is the
maximum number of nodes it can contain? Clearly,
max_nodes = 2<sup>`h`</sup> - 1.

```ocaml
# let max_nodes h = 1 lsl h - 1;;
val max_nodes : int -> int = <fun>
```

### Finding the minimum number of nodes

However, what is the minimum number min_nodes? This question is more
difficult. Try to find a recursive statement and turn it into a function
`min_nodes` defined as follows: `min_nodes h` returns the minimum number
of nodes in a height-balanced binary tree of height `h`.

### Finding the minimum and maximum height

On the other hand, we might ask: what are the minimum (resp. maximum)
height H a
height-balanced binary tree with N nodes can have?
`min_height` (resp. `max_height n`) returns
the minimum (resp. maximum) height of a height-balanced binary tree
with `n` nodes.

### Constructing all trees

Now, we can attack the main problem: construct all the height-balanced
binary trees with a given number of nodes. `hbal_tree_nodes n` returns a
list of all height-balanced binary tree with `n` nodes.

Find out how many height-balanced trees exist for `n = 15`.

```ocaml
# List.length (hbal_tree_nodes 15);;
- : int = 1553
```
