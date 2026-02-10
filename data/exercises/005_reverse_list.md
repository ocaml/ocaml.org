---
title: Reverse a List
slug: "5"
difficulty: beginner
tags: [ "list" ]
description: "Write a function to reverse a list."
---

## Solution

```ocaml
# let rev list =
    let rec aux acc = function
      | [] -> acc
      | h :: t -> aux (h :: acc) t
    in
    aux [] list;;
val rev : 'a list -> 'a list = <fun>
```

## Statement

Reverse a list.

OCaml standard library has `List.rev` but we ask that you reimplement
it.

```ocaml
# rev ["a"; "b"; "c"];;
- : string list = ["c"; "b"; "a"]
```
