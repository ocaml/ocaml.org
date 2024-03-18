---
title: Tail of a List
slug: "1"
difficulty: beginner
tags: [ "list" ]
description: "Write a function that returns the last element of a list."
tutorials: [ "lists"]
---

# Solution

```ocaml
# let rec last = function 
  | [] -> None
  | [ x ] -> Some x
  | _ :: t -> last t;;
val last : 'a list -> 'a option = <fun>
```

# Statement

Write a function `last : 'a list -> 'a option` that returns the last element of a list

```ocaml
# last ["a" ; "b" ; "c" ; "d"];;
- : string option = Some "d"
# last [];;
- : 'a option = None
```
