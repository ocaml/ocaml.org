---
title: Tree Construction From a Node String
slug: "70A"
difficulty: intermediate
tags: [ "multiway-tree" ]
description: "Convert multiway trees into depth-first order sequence strings and vice versa, where nodes are single characters."
---

```ocaml
type 'a mult_tree = T of 'a * 'a mult_tree list
```

## Solution

```ocaml
# (* We could build the final string by string concatenation but
     this is expensive due to the number of operations.  We use a
     buffer instead. *)
  let rec add_string_of_tree buf (T (c, sub)) =
    Buffer.add_char buf c;
    List.iter (add_string_of_tree buf) sub;
    Buffer.add_char buf '^';;
val add_string_of_tree : Buffer.t -> char mult_tree -> unit = <fun>

# let string_of_tree t =
    let buf = Buffer.create 128 in
    add_string_of_tree buf t;
    Buffer.contents buf;;

val string_of_tree : char mult_tree -> string = <fun>

# let tree_of_string s =
    let rec parse_node chars =
      match chars with
      | [] -> failwith "Unexpected end of input (expecting node)"
      | c :: rest ->
          let (children, rest') = parse_children rest in
          (T (c, children), rest')
    and parse_children chars =
      match chars with
      | [] -> failwith "Unexpected end of input (expecting ^)"
      | '^' :: rest -> ([], rest)
      | _ ->
          let (child, rest') = parse_node chars in
          let (siblings, rest'') = parse_children rest' in
          (child :: siblings, rest'')
    in
    let (tree, remaining) = parse_node (List.of_seq (String.to_seq s)) in
    match remaining with
    | [] -> tree
    | _ -> failwith "Extra input after tree";;
val tree_of_string : string -> char mult_tree = <fun>
```

## Statement

![Multiway Tree](/media/problems/multiway-tree.gif)

*A multiway tree is composed of a root element and a (possibly empty)
set of successors which are multiway trees themselves. A multiway tree
is never empty. The set of successor trees is sometimes called a
forest.*

To represent multiway trees, we will use the following type which is a
direct translation of the definition:

```ocaml
# type 'a mult_tree = T of 'a * 'a mult_tree list;;
type 'a mult_tree = T of 'a * 'a mult_tree list
```

The example tree depicted opposite is therefore represented by the
following OCaml expression:

```ocaml
# T ('a', [T ('f', [T ('g', [])]); T ('c', []); T ('b', [T ('d', []); T ('e', [])])]);;
- : char mult_tree =
T ('a',
 [T ('f', [T ('g', [])]); T ('c', []); T ('b', [T ('d', []); T ('e', [])])])
```

We suppose that the nodes of a multiway tree contain single characters.
In the depth-first order sequence of its nodes, a special character `^`
has been inserted whenever, during the tree traversal, the move is a
backtrack to the previous level.

By this rule, the tree in the figure opposite is represented as:
`afg^^c^bd^e^^^`.

Write functions `string_of_tree : char mult_tree -> string` to construct
the string representing the tree and
`tree_of_string : string -> char mult_tree` to construct the tree when
the string is given.

```ocaml
# let t = T ('a', [T ('f', [T ('g', [])]); T ('c', []);
          T ('b', [T ('d', []); T ('e', [])])]);;
val t : char mult_tree =
  T ('a',
   [T ('f', [T ('g', [])]); T ('c', []); T ('b', [T ('d', []); T ('e', [])])])
```
