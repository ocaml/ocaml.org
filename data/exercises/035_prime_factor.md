---
title: Determine the Prime Factors of a Given Positive Integer
slug: "35"
difficulty: intermediate
tags: [ "arithmetic" ]
description: "Find the prime factors of a given positive integer 'n'."
tutorials: [ "values-and-functions"]
---


## Solution

```ocaml
# (* Recall that d divides n iff [n mod d = 0] *)
  let factors n =
    let rec aux d n =
      if n = 1 then [] else
        if n mod d = 0 then d :: aux d (n / d) else aux (d + 1) n
    in
      aux 2 n;;
val factors : int -> int list = <fun>
```

## Statement

Construct a flat list containing the prime factors in ascending order.


```ocaml
# factors 315;;
- : int list = [3; 3; 5; 7]
```
