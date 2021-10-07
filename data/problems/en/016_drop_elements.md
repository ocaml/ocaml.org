---
title: Drop every N'th element from a list
number: "16"
difficulty: intermediate
tags: [ "list" ]
---

# Solution

```ocaml
# let drop list n =
    let rec aux i = function
      | [] -> []
      | h :: t -> if i = n then aux 1 t else h :: aux (i + 1) t  in
    aux 1 list;;
val drop : 'a list -> int -> 'a list = <fun>
```

# Statement

Drop every N'th element from a list.

```ocaml
# drop ["a"; "b"; "c"; "d"; "e"; "f"; "g"; "h"; "i"; "j"] 3;;
- : string list = ["a"; "b"; "d"; "e"; "g"; "h"; "j"]
```
