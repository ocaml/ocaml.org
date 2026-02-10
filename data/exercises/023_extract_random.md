---
title: Extract a Given Number of Randomly Selected Elements From a List
slug: "23"
difficulty: intermediate
tags: [ "list" ]
description: "Randomly select N elements from a list."
---


## Solution

```ocaml
# let rand_select list n =
    Random.init 0;
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
      aux (min n len) [] list len;;
val rand_select : 'a list -> int -> 'a list = <fun>
```

## Statement

The selected items shall be returned in a list. We use the `Random`
module and initialise it with `Random.init 0` at the start of
the function for reproducibility and validate the solution. To make the function truly random, however,
one should remove the call to `Random.init 0`

```ocaml
# rand_select ["a"; "b"; "c"; "d"; "e"; "f"; "g"; "h"] 3;;
- : string list = ["e"; "c"; "g"]
```
