---
title: Lisp-Like Tree Representation
slug: "73"
difficulty: intermediate
tags: [ "multiway-tree" ]
description: "Return the Lispy notation of a given multiway tree."
---

```ocaml
type 'a mult_tree = T of 'a * 'a mult_tree list

let t = T ('a', [T ('f', [T ('g', [])]); T ('c', []);
          T ('b', [T ('d', []); T ('e', [])])])
```

## Solution

```ocaml
# let rec add_lispy buf = function
    | T(c, []) -> Buffer.add_char buf c
    | T(c, sub) ->
       Buffer.add_char buf '(';
       Buffer.add_char buf c;
       List.iter (fun t -> Buffer.add_char buf ' '; add_lispy buf t) sub;
       Buffer.add_char buf ')'
  let lispy t =
    let buf = Buffer.create 128 in
    add_lispy buf t;
    Buffer.contents buf;;
val add_lispy : Buffer.t -> char mult_tree -> unit = <fun>
val lispy : char mult_tree -> string = <fun>
```

## Statement

There is a particular notation for multiway trees in Lisp. The
picture shows how multiway tree structures are represented in Lisp.

![Lisp representation of trees](/media/problems/lisp-like-tree.png)

Note that in the "lispy" notation a node with successors (children) in
the tree is always the first element in a list, followed by its
children. The "lispy" representation of a multiway tree is a sequence of
atoms and parentheses '(' and ')'. This is very close to the way trees
are represented in OCaml, except that no constructor `T` is used. Write
a function `lispy : char mult_tree -> string` that returns the
lispy notation of the tree.

```ocaml
# lispy (T ('a', []));;
- : string = "a"
# lispy (T ('a', [T ('b', [])]));;
- : string = "(a b)"
# lispy t;;
- : string = "(a (f g) c (b d e))"
```
