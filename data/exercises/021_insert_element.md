---
title: Insert an Element at a Given Position Into a List
slug: "21"
difficulty: beginner
tags: [ "list" ]
description: "Insert an element at a specified position (0-based index) within a list."
---

## Solution

```ocaml
# let rec insert_at x n = function
    | [] -> [x]
    | h :: t as l -> if n = 0 then x :: l else h :: insert_at x (n - 1) t;;
val insert_at : 'a -> int -> 'a list -> 'a list = <fun>
```

## Statement

Start counting list elements with 0.  If the position is larger or
equal to the length of the list, insert the element at the end.  (The
behavior is unspecified if the position is negative.)

```ocaml
# insert_at "alfa" 1 ["a"; "b"; "c"; "d"];;
- : string list = ["a"; "alfa"; "b"; "c"; "d"]
```
