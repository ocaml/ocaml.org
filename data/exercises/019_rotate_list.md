---
title: Rotate a List N Places to the Left
slug: "19"
difficulty: intermediate
tags: [ "list" ]
description: "Write a function that rotates a list N places to the left."
---

# Solution

```ocaml
# let split list n =
    let rec aux i acc = function
      | [] -> List.rev acc, []
      | h :: t as l -> if i = 0 then List.rev acc, l
                       else aux (i - 1) (h :: acc) t  in
    aux n [] list

  let rotate list n =
    let len = List.length list in
    (* Compute a rotation value between 0 and len - 1 *)
    let n = if len = 0 then 0 else (n mod len + len) mod len in
    if n = 0 then list
    else let a, b = split list n in b @ a;;
val split : 'a list -> int -> 'a list * 'a list = <fun>
val rotate : 'a list -> int -> 'a list = <fun>
```

# Statement

Rotate a list N places to the left.

```ocaml
# rotate ["a"; "b"; "c"; "d"; "e"; "f"; "g"; "h"] 3;;
- : string list = ["d"; "e"; "f"; "g"; "h"; "a"; "b"; "c"]
```
