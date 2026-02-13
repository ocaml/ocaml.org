---
title: Goldbach's Conjecture
slug: "40"
difficulty: intermediate
tags: [ "arithmetic" ]
description: "Find two prime numbers that sum up to a given even integer, demonstrating Goldbach's conjecture."
---

```ocaml
let is_prime n =
  let n = abs n in
  let rec is_not_divisor d =
    d * d > n || (n mod d <> 0 && is_not_divisor (d + 1)) in
  n <> 1 && is_not_divisor 2
```

## Solution

```ocaml
# (* [is_prime] is defined in the previous solution *)
  let goldbach n =
    let rec aux d =
      if is_prime d && is_prime (n - d) then (d, n - d)
      else aux (d + 1)
    in
      aux 2;;
val goldbach : int -> int * int = <fun>
```

## Statement

Goldbach's conjecture says that every positive even number greater than
2 is the sum of two prime numbers. Example: 28 = 5 + 23. It is one of
the most famous facts in number theory that has not been proved to be
correct in the general case. It has been *numerically confirmed* up to
very large numbers. Write a function to find the two prime numbers that
sum up to a given even integer.

```ocaml
# goldbach 28;;
- : int * int = (5, 23)
```
