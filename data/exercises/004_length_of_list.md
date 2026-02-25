---
title: Length of a List
slug: "4"
difficulty: beginner
tags: [ "list" ]
description: "Find the number of elements of a list."
---

## Solution

This function is tail-recursive: it uses a constant amount of stack memory regardless of list size.

```ocaml
# let length list =
    let rec aux n = function
      | [] -> n
      | _ :: t -> aux (n + 1) t
    in
    aux 0 list;;
val length : 'a list -> int = <fun>
```

## Statement

Find the number of elements of a list.

OCaml standard library has `List.length` but we ask that you reimplement
it. Bonus for a [tail recursive](http://en.wikipedia.org/wiki/Tail_call)
solution.

```ocaml
# length ["a"; "b"; "c"];;
- : int = 3
# length [];;
- : int = 0
```
