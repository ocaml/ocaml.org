---
title: A List of Prime Numbers
slug: "39"
difficulty: beginner
tags: [ "arithmetic" ]
description: "Generate a list of all prime numbers within a specified range of integers."
---

# Solution

```ocaml
# let is_prime n =
    let n = max n (-n) in
    let rec is_not_divisor d =
      d * d > n || (n mod d <> 0 && is_not_divisor (d + 1))
    in
      is_not_divisor 2

  let rec all_primes a b =
    if a > b then [] else
      let rest = all_primes (a + 1) b in
      if is_prime a then a :: rest else rest;;
val is_prime : int -> bool = <fun>
val all_primes : int -> int -> int list = <fun>
```

# Statement

Given a range of integers by its lower and upper limit, construct a list
of all prime numbers in that range.

```ocaml
# List.length (all_primes 2 7920);;
- : int = 1000
```
