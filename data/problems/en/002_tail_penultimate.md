---
title: Last two elements of a list
number: "2"
difficulty: beginner
tags: [ "list" ]
---

# Solution

```ocaml
# let rec last_two = function
    | [] | [_] -> None
    | [x; y] -> Some (x,y)
    | _ :: t -> last_two t;;
val last_two : 'a list -> ('a * 'a) option = <fun>
```

# Statement

Find the last but one (last and penultimate) elements of a list.

```ocaml
# last_two ["a"; "b"; "c"; "d"];;
- : (string * string) option = Some ("c", "d")
# last_two ["a"];;
- : (string * string) option = None
```
