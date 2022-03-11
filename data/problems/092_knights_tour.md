---
title: Knight's tour
number: "92"
difficulty: intermediate
tags: []
---

# Solution

```ocaml
(* example pending *);;
```

# Statement

Another famous problem is this one: How can a knight jump on an N×N
chessboard in such a way that it visits every square exactly once?

Hints: Represent the squares by pairs of their coordinates `(x,y)`,
where both `x` and `y` are integers between 1 and N. Define the function
`jump n (x,y)` that returns all coordinates `(u,v)` to which a
knight can jump from `(x,y)` to on a `n`×`n` chessboard. And finally,
represent the solution of our problem as a list knight positions (the
knight's tour).
