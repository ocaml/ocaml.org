---
title: Eight Queens Problem
slug: "91"
difficulty: intermediate
tags: []
description: "Find all the distinct solutions for the Eight Queens puzzle on an N×N chessboard, where no two queens threaten each other."
---

# Solution

  This is a brute force algorithm enumerating all possible solutions.
  For a deeper analysis, look for example to
  [Wikipedia](https://en.wikipedia.org/wiki/Eight_queens_puzzle).
```ocaml
# let possible row col used_rows usedD1 usedD2 =
    not (List.mem row used_rows
         || List.mem (row + col) usedD1
         || List.mem (row - col) usedD2)
         let queens_positions n =
    let rec aux row col used_rows usedD1 usedD2 =
      if col > n then [List.rev used_rows]
      else
        (if row < n then aux (row + 1) col used_rows usedD1 usedD2
         else [])
        @ (if possible row col used_rows usedD1 usedD2 then
             aux 1 (col + 1) (row :: used_rows) (row + col :: usedD1)
                 (row - col :: usedD2)
           else [])
    in aux 1 1 [] [] [];;
val possible : int -> int -> int list -> int list -> int list -> bool = <fun>
val queens_positions : int -> int list list = <fun>
```

# Statement

This is a classical problem in computer science. The objective is to
place eight queens on a chessboard so that no two queens are attacking
each other; i.e., no two queens are in the same row, the same column, or
on the same diagonal.

**Hint:** Represent the positions of the queens as a list of numbers 1..N.
Example: `[4; 2; 7; 3; 6; 8; 5; 1]` means that the queen in the first column is
in row 4, the queen in the second column is in row 2, etc. Use the
generate-and-test paradigm.

```ocaml
# queens_positions 4;;
- : int list list = [[3; 1; 4; 2]; [2; 4; 1; 3]]
```
