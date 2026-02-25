---
title: Duplicate the Elements of a List
slug: "14"
difficulty: beginner
tags: [ "list" ]
description: "Write a function that duplicates the elements of a list."
---

## Solution

```ocaml
# let rec duplicate = function
    | [] -> []
    | h :: t -> h :: h :: duplicate t;;
val duplicate : 'a list -> 'a list = <fun>
```

> Remark: this function is not tail recursive.  Can you modify it so
> it becomes so?

## Statement

Duplicate the elements of a list.

```ocaml
# duplicate ["a"; "b"; "c"; "c"; "d"];;
- : string list = ["a"; "a"; "b"; "b"; "c"; "c"; "c"; "c"; "d"; "d"]
```
