---
title: Remove the K'th Element From a List
number: "20"
difficulty: beginner
tags: [ "list" ]
---

# Solution

```ocaml
# let rec remove_at n = function
    | [] -> []
    | h :: t -> if n = 0 then t else h :: remove_at (n - 1) t;;
val remove_at : int -> 'a list -> 'a list = <fun>
```

# Statement

Remove the K'th element from a list.

The first element of the list is numbered 0, the second 1,...

```ocaml
# remove_at 1 ["a"; "b"; "c"; "d"];;
- : string list = ["a"; "c"; "d"]
```
