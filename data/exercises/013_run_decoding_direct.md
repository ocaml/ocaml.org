---
title: Run-Length Encoding of a List (Direct Solution)
slug: "13"
difficulty: intermediate
tags: [ "list" ]
description: "Perform run-length encoding directly by counting duplicates and simplifying the result list."
---

```ocaml
type 'a rle =
  | One of 'a
  | Many of int * 'a
```

## Solution

```ocaml
# let encode list =
    let rle count x = if count = 0 then One x else Many (count + 1, x) in
    let rec aux count acc = function
      | [] -> [] (* Can only be reached if original list is empty *)
      | [x] -> rle count x :: acc
      | a :: (b :: _ as t) -> if a = b then aux (count + 1) acc t
                              else aux 0 (rle count a :: acc) t
    in
      List.rev (aux 0 [] list);;
val encode : 'a list -> 'a rle list = <fun>
```

## Statement

Implement the so-called run-length encoding data compression method
directly. I.e. don't explicitly create the sublists containing the
duplicates, as in problem "[Pack consecutive duplicates of list elements into sublists](#9)", but only count them. As in problem
"[Modified run-length encoding](#10)", simplify the result list by replacing the singleton lists (1 X) by X.

```ocaml
# encode ["a";"a";"a";"a";"b";"c";"c";"a";"a";"d";"e";"e";"e";"e"];;
- : string rle list =
[Many (4, "a"); One "b"; Many (2, "c"); Many (2, "a"); One "d";
 Many (4, "e")]
```
