---
title: N'th Element of a List
slug: "3"
difficulty: beginner
tags: [ "list" ]
description: "Find the N'th element of a list."
tutorials: [ "options"]
---

# Solution

```ocaml
# let rec at k = function
    | [] -> None
    | h :: t -> if k = 0 then Some h else at (k - 1) t;;
val at : int -> 'a list -> 'a option = <fun>
```

# Statement

Find the N'th element of a list.

**Remark:** OCaml has `List.nth` which numbers elements from `0` and
raises an exception if the index is out of bounds.

```ocaml
# List.nth ["a"; "b"; "c"; "d"; "e"] 2;;
- : string = "c"
# List.nth ["a"] 2;;
Exception: Failure "nth".
```
