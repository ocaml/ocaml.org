---
title: N'th lement of a list
number: "3"
difficulty: beginner
tags: [ "list" ]
---

# Solution

```ocaml
# let rec at l k =
    match l with
    | [] -> failwith "nth"
    | h :: t -> if k = 0 then h else kth t (k - 1);;
val at : 'a list -> int -> 'a = <fun>
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
