---
title: Split a List Into Two Parts; The Length of the First Part Is Given
slug: "17"
difficulty: beginner
tags: [ "list" ]
description: "Split a list into two parts, with the length of the first part specified."
---

## Solution

```ocaml
# let split list n =
    let rec aux i acc = function
      | [] -> List.rev acc, []
      | h :: t as l -> if i = 0 then List.rev acc, l
                       else aux (i - 1) (h :: acc) t 
    in
      aux n [] list;;
val split : 'a list -> int -> 'a list * 'a list = <fun>
```

## Statement

Split a list into two parts; the length of the first part is given.

If the length of the first part is longer than the entire list, then the
first part is the list and the second part is empty.

```ocaml
# split ["a"; "b"; "c"; "d"; "e"; "f"; "g"; "h"; "i"; "j"] 3;;
- : string list * string list =
(["a"; "b"; "c"], ["d"; "e"; "f"; "g"; "h"; "i"; "j"])
# split ["a"; "b"; "c"; "d"] 5;;
- : string list * string list = (["a"; "b"; "c"; "d"], [])
```
