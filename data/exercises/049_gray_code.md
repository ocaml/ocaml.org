---
title: Gray Code
slug: "49"
difficulty: intermediate
tags: [ "logic" ]
description: "Generate the n-bit Gray code sequence following certain construction rules using the gray function."
---

## Solution

```ocaml
# let gray n =
    let rec gray_next_level k l =
      if k < n then
        (* This is the core part of the Gray code construction.
         * first_half is reversed and has a "0" attached to every element.
         * Second part is reversed (it must be reversed for correct gray code).
         * Every element has "1" attached to the front.*)
        let (first_half,second_half) =
          List.fold_left (fun (acc1,acc2) x ->
              (("0" ^ x) :: acc1, ("1" ^ x) :: acc2)) ([], []) l
        in
        (* List.rev_append turns first_half around and attaches it to second_half.
         * The result is the modified first_half in correct order attached to
         * the second_half modified in reversed order.*)
        gray_next_level (k + 1) (List.rev_append first_half second_half)
      else l
    in
      gray_next_level 1 ["0"; "1"];;
val gray : int -> string list = <fun>
```

## Statement

An n-bit Gray code is a sequence of n-bit strings constructed according
to certain rules. For example,

```text
n = 1: C(1) = ['0', '1'].
n = 2: C(2) = ['00', '01', '11', '10'].
n = 3: C(3) = ['000', '001', '011', '010', '110', '111', '101', '100'].
```
Find out the construction rules and write a function with the following
specification: `gray n` returns the `n`-bit Gray code.

```ocaml
# gray 1;;
- : string list = ["0"; "1"]
# gray 2;;
- : string list = ["00"; "01"; "11"; "10"]
# gray 3;;
- : string list = ["000"; "001"; "011"; "010"; "110"; "111"; "101"; "100"]
```
