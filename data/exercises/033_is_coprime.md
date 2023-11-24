---
title: Determine Whether Two Positive Integer Numbers Are Coprime
slug: "33"
difficulty: beginner
tags: [ "arithmetic" ]
description: "Determine if two positive integers are coprime, meaning their greatest common divisor is 1."
---

```ocaml
let rec gcd a b =
  if b = 0 then a else gcd b (a mod b)
```

# Solution

```ocaml
# (* [gcd] is defined in the previous question *)
  let coprime a b = gcd a b = 1;;
val coprime : int -> int -> bool = <fun>
```

# Statement

Determine whether two positive integer numbers are coprime.

Two numbers are coprime if their greatest common divisor equals 1.

```ocaml
# coprime 13 27;;
- : bool = true
# not (coprime 20536 7826);;
- : bool = true
```
