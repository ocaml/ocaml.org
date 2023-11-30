---
title: Calculate Euler's Totient Function Φ(m)
slug: "34"
difficulty: intermediate
tags: [ "arithmetic" ]
description: "Find Euler's totient function (phi) for a given positive integer 'n'."
---

```ocaml
let rec gcd a b = if b = 0 then a else gcd b (a mod b)
let coprime a b = gcd a b = 1
```

# Solution

```ocaml
# (* [coprime] is defined in the previous question *)
  let phi n =
    let rec count_coprime acc d =
      if d < n then
        count_coprime (if coprime n d then acc + 1 else acc) (d + 1)
      else acc
    in
      if n = 1 then 1 else count_coprime 0 1;;
val phi : int -> int = <fun>
```

# Statement

Euler's so-called totient function φ(m) is defined as the number of
positive integers r (1 ≤ r < m) that are coprime to m. We let φ(1) = 1.

Find out what the value of φ(m) is if m is a prime number.  Euler's
totient function plays an important role in one of the most widely used
public key cryptography methods (RSA). In this exercise you should use
the most primitive method to calculate this function (there are smarter
ways that we shall discuss later).

```ocaml
# phi 10;;
- : int = 4
```
