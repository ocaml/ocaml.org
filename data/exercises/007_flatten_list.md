---
title: Flatten a List
slug: "7"
difficulty: intermediate
tags: [ "list" ]
description: "Write a function that flattens a nested list structure represented by the 'a node type."
tutorials: [ "loops-recursion"]
---

## Solution

```ocaml
# type 'a node =
    | One of 'a 
    | Many of 'a node list;;
type 'a node = One of 'a | Many of 'a node list
# (* This function traverses the list, prepending any encountered elements
    to an accumulator, which flattens the list in inverse order. It can
    then be reversed to obtain the actual flattened list. *);;
# let flatten list =
    let rec aux acc = function
      | [] -> acc
      | One x :: t -> aux (x :: acc) t
      | Many l :: t -> aux (aux acc l) t
    in
    List.rev (aux [] list);;
val flatten : 'a node list -> 'a list = <fun>
```

## Statement

Flatten a nested list structure.

```ocaml
type 'a node =
  | One of 'a 
  | Many of 'a node list
```

```ocaml
# flatten [One "a"; Many [One "b"; Many [One "c" ;One "d"]; One "e"]];;
- : string list = ["a"; "b"; "c"; "d"; "e"]
```
