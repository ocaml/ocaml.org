---
title: A String Representation of Binary Trees
slug: "67"
difficulty: intermediate
tags: [ "binary-tree" ]
description: "Convert binary trees to and from string representations."
---

```ocaml
type 'a binary_tree =
  | Empty
  | Node of 'a * 'a binary_tree * 'a binary_tree
```

# Solution

A simple solution is:

```ocaml
# let rec string_of_tree = function
    | Empty -> ""
    | Node(data, l, r) ->
       let data = String.make 1 data in
       match l, r with
       | Empty, Empty -> data
       | _, _ -> data ^ "(" ^ (string_of_tree l)
                 ^ "," ^ (string_of_tree r) ^ ")";;
val string_of_tree : char binary_tree -> string = <fun>
```

One can also use a buffer to allocate a lot less memory:

```ocaml
# let rec buffer_add_tree buf = function
    | Empty -> ()
    | Node (data, l, r) ->
       Buffer.add_char buf data;
       match l, r with
       | Empty, Empty -> ()
       | _, _ -> Buffer.add_char buf '(';
                 buffer_add_tree buf l;
                 Buffer.add_char buf ',';
                 buffer_add_tree buf r;
                 Buffer.add_char buf ')'
                 let string_of_tree t =
    let buf = Buffer.create 128 in
      buffer_add_tree buf t;
      Buffer.contents buf;;
val buffer_add_tree : Buffer.t -> char binary_tree -> unit = <fun>
val string_of_tree : char binary_tree -> string = <fun>
```

For the reverse conversion, we assume that the string is well formed
and do not deal with error reporting.

```ocaml
# let tree_of_string =
    let rec make ofs s =
      if ofs >= String.length s || s.[ofs] = ',' || s.[ofs] = ')' then
        (Empty, ofs)
      else
        let v = s.[ofs] in
        if ofs + 1 < String.length s && s.[ofs + 1] = '(' then
          let l, ofs = make (ofs + 2) s in (* skip "v(" *)
          let r, ofs = make (ofs + 1) s in (* skip "," *)
            (Node (v, l, r), ofs + 1) (* skip ")" *)
        else (Node (v, Empty, Empty), ofs + 1)
    in
      fun s -> fst (make 0 s);;
val tree_of_string : string -> char binary_tree = <fun>
```

# Statement

![Binary Tree](/media/problems/binary-tree.gif)

Somebody represents binary trees as strings of the following type (see
example): `"a(b(d,e),c(,f(g,)))"`.

* Write an OCaml function `string_of_tree` which generates this
 string representation,
 if the tree is given as usual (as `Empty` or `Node(x,l,r)` term).
 Then write a function `tree_of_string` which does this inverse;
 i.e. given the string
 representation, construct the tree in the usual form. Finally,
 combine the two predicates in a single function `tree_string` which
 can be used in both directions.
* Write the same predicate `tree_string` using difference lists and a
 single predicate `tree_dlist` which does the conversion between a
 tree and a difference list in both directions.

For simplicity, suppose the information in the nodes is a single letter
and there are no spaces in the string.

```ocaml
# let example_layout_tree =
  let leaf x = Node (x, Empty, Empty) in
    (Node ('a', Node ('b', leaf 'd', leaf 'e'),
     Node ('c', Empty, Node ('f', leaf 'g', Empty))));;
val example_layout_tree : char binary_tree =
  Node ('a', Node ('b', Node ('d', Empty, Empty), Node ('e', Empty, Empty)),
   Node ('c', Empty, Node ('f', Node ('g', Empty, Empty), Empty)))
```
