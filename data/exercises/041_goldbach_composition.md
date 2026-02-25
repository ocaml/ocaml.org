---
title: A List of Goldbach Compositions
slug: "41"
difficulty: intermediate
tags: [ "arithmetic" ]
description: "Find even numbers in a range with Goldbach compositions where both primes exceed a specified limit"
---

```ocaml
let is_prime n =
  let n = abs n in
  let rec is_not_divisor d =
    d * d > n || (n mod d <> 0 && is_not_divisor (d + 1)) in
  n <> 1 && is_not_divisor 2

let goldbach n =
  let rec aux d =
    if is_prime d && is_prime (n - d) then (d, n - d)
    else aux (d + 1)
  in
    aux 2
```

## Solution

```ocaml
# (* [goldbach] is defined in the previous question. *)
  let rec goldbach_list a b =
    if a > b then [] else
      if a mod 2 = 1 then goldbach_list (a + 1) b
      else (a, goldbach a) :: goldbach_list (a + 2) b

  let goldbach_limit a b lim =
    List.filter (fun (_, (a, b)) -> a > lim && b > lim) (goldbach_list a b);;
val goldbach_list : int -> int -> (int * (int * int)) list = <fun>
val goldbach_limit : int -> int -> int -> (int * (int * int)) list = <fun>
```

## Statement

Given a range of integers by its lower and upper limit, print a list of
all even numbers and their Goldbach composition.

In most cases, if an even number is written as the sum of two prime
numbers, one of them is very small. Very rarely, the primes are both
bigger than say 50. Try to find out how many such cases there are in the
range 2..3000.

```ocaml
# goldbach_list 9 20;;
- : (int * (int * int)) list =
[(10, (3, 7)); (12, (5, 7)); (14, (3, 11)); (16, (3, 13)); (18, (5, 13));
 (20, (3, 17))]
```
