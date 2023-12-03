---
title: Eliminate Duplicates
slug: "8"
difficulty: intermediate
tags: [ "list" ]
description: "Eliminate consecutive duplicates of list elements."
---

# Solution

```ocaml
# let rec compress = function
    | a :: (b :: _ as t) -> if a = b then compress t else a :: compress t
    | smaller -> smaller;;
val compress : 'a list -> 'a list = <fun>
```

# Statement

Eliminate consecutive duplicates of list elements.

```ocaml
# compress ["a"; "a"; "a"; "a"; "b"; "c"; "c"; "a"; "a"; "d"; "e"; "e"; "e"; "e"];;
- : string list = ["a"; "b"; "c"; "a"; "d"; "e"]
```
