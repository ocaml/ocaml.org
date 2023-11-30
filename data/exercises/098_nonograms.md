---
title: Nonograms
slug: "98"
difficulty: advanced
tags: []
description: "Solve nonogram puzzles by constructing the corresponding bitmap from annotated rows and columns."
---

# Solution

Brute force solution: construct boards trying all the fill
possibilities for the columns given the prescribed patterns for them
and reject the solution if it does not satisfy the row patterns.


```ocaml
# type element = Empty | X (* ensure we do not miss cases in patterns *);;
type element = Empty | X
```

You may want to look at
[more efficient algorithms](http://link.springer.com/article/10.1007%2Fs10489-009-0200-0)
and implement them so you can solve the following within reasonable time:

<!-- $MDX skip -->
```ocaml
  solve [[14]; [1; 1]; [7; 1]; [3; 3]; [2; 3; 2];
         [2; 3; 2]; [1; 3; 6; 1; 1]; [1; 8; 2; 1]; [1; 4; 6; 1]; [1; 3; 2; 5; 1; 1];
         [1; 5; 1]; [2; 2]; [2; 1; 1; 1; 2]; [6; 5; 3]; [12]]
        [[7]; [2; 2]; [2; 2]; [2; 1; 1; 1; 1]; [1; 2; 4; 2];
         [1; 1; 4; 2]; [1; 1; 2; 3]; [1; 1; 3; 2]; [1; 1; 1; 2; 2; 1]; [1; 1; 5; 1; 2];
         [1; 1; 7; 2]; [1; 6; 3]; [1; 1; 3; 2]; [1; 4; 3]; [1; 3; 1];
         [1; 2; 2]; [2; 1; 1; 1; 1]; [2; 2]; [2; 2]; [7]]
```

# Statement

Around 1994, a certain kind of puzzles was very popular in England. The
"Sunday Telegraph" newspaper wrote: "Nonograms are puzzles from Japan
and are currently published each week only in The Sunday Telegraph.
Simply use your logic and skill to complete the grid and reveal a
picture or diagram." As an OCaml programmer, you are in a better
situation: you can have your computer do the work!

The puzzle goes like this: Essentially, each row and column of a
rectangular bitmap is annotated with the respective lengths of its
distinct strings of occupied cells. The person who solves the puzzle
must complete the bitmap given only these lengths.

```text
          Problem statement:          Solution:

          |_|_|_|_|_|_|_|_| 3         |_|X|X|X|_|_|_|_| 3
          |_|_|_|_|_|_|_|_| 2 1       |X|X|_|X|_|_|_|_| 2 1
          |_|_|_|_|_|_|_|_| 3 2       |_|X|X|X|_|_|X|X| 3 2
          |_|_|_|_|_|_|_|_| 2 2       |_|_|X|X|_|_|X|X| 2 2
          |_|_|_|_|_|_|_|_| 6         |_|_|X|X|X|X|X|X| 6
          |_|_|_|_|_|_|_|_| 1 5       |X|_|X|X|X|X|X|_| 1 5
          |_|_|_|_|_|_|_|_| 6         |X|X|X|X|X|X|_|_| 6
          |_|_|_|_|_|_|_|_| 1         |_|_|_|_|X|_|_|_| 1
          |_|_|_|_|_|_|_|_| 2         |_|_|_|X|X|_|_|_| 2
           1 3 1 7 5 3 4 3             1 3 1 7 5 3 4 3
           2 1 5 1                     2 1 5 1
```

For the example above, the problem can be stated as the two lists
`[[3]; [2; 1]; [3; 2]; [2; 2]; [6]; [1; 5]; [6]; [1]; [2]]` and
`[[1; 2]; [3; 1]; [1; 5]; [7; 1]; [5]; [3]; [4]; [3]]` which give the "solid"
lengths of the rows and columns, top-to-bottom and left-to-right,
respectively. Published puzzles are larger than this example, e.g.
25×20, and apparently always have unique solutions.

<!-- $MDX skip -->
```ocaml
# solve [[3]; [2; 1]; [3; 2]; [2; 2]; [6]; [1; 5]; [6]; [1]; [2]]
      [[1; 2]; [3; 1]; [1; 5]; [7; 1]; [5]; [3]; [4]; [3]];;
```
