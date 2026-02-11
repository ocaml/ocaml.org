---
title: "Lotto: Draw N Different Random Numbers From the Set 1..M"
slug: "24"
difficulty: beginner
tags: [ "list" ]
description: "Draw N different random numbers from the set 1..M."
---

```ocaml
let rand_select list n =
  let rec extract acc n = function
    | [] -> raise Not_found
    | h :: t -> if n = 0 then (h, acc @ t) else extract (h :: acc) (n - 1) t
  in
  let extract_rand list len =
    extract [] (Random.int len) list
  in
  let rec aux n acc list len =
    if n = 0 then acc else
      let picked, rest = extract_rand list len in
      aux (n - 1) (picked :: acc) rest (len - 1)
  in
  let len = List.length list in
    aux (min n len) [] list len
```

```ocaml
let range a b =
  let rec aux acc high low =
    if high >= low then
      aux (high :: acc) (high - 1) low
    else acc
  in
    if a < b then aux [] b a else List.rev (aux [] a b)
```

## Solution

```ocaml
# (* [range] and [rand_select] defined in problems above *)
  let lotto_select n m = rand_select (range 1 m) n;;
val lotto_select : int -> int -> int list = <fun>
```

## Statement

Draw N different random numbers from the set `1..M`.

The selected numbers shall be returned in a list.

```ocaml
# lotto_select 6 49;;
- : int list = [20; 28; 45; 16; 24; 38]
```
