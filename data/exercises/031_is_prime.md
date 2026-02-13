---
title: Determine Whether a Given Integer Number Is Prime
slug: "31"
difficulty: intermediate
tags: ["arithmetic"]
description: "Check if a given integer is a prime number."
---

## Solution

Recall that `d` divides `n` if and only if `n mod d = 0`. This is a naive
solution. See the [Sieve of
Eratosthenes](http://en.wikipedia.org/wiki/Sieve_of_Eratosthenes) for a
more clever one.

```ocaml
# let is_prime n =
    let n = abs n in
    let rec is_not_divisor d =
      d * d > n || (n mod d <> 0 && is_not_divisor (d + 1)) in
    n > 1 && is_not_divisor 2;;
val is_prime : int -> bool = <fun>
```

## Statement

Determine whether a given integer number is prime.

```ocaml
# not (is_prime 1);;
- : bool = true
# is_prime 7;;
- : bool = true
# not (is_prime 12);;
- : bool = true
```
