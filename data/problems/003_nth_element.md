---
title: N'th element of a list
number: "3"
difficulty: beginner
tags: [ "list" ]
---

# Solution

```ocaml
# let rec at k = function
    | [] -> None
    | h :: t -> if k = 1 then Some h else at (k - 1) t;;
val at : int -> 'a list -> 'a option = <fun>
```

# Statement

Find the K'th element of a list.

> REMARK: OCaml has `List.nth` which numbers elements from `0` and
> raises an exception if the index is out of bounds.

```ocaml
# List.nth ["a"; "b"; "c"; "d"; "e"] 2;;
- : string = "c"
# List.nth ["a"] 2;;
Exception: Failure "nth".
```
