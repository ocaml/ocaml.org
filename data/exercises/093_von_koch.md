---
title: Von Koch's Conjecture
slug: "93"
difficulty: advanced
tags: []
description: "Calculate a numbering scheme for a given tree, such that for each edge K, the difference of its node numbers equals to K."
---

# Solution

```ocaml
(* example pending *);;
```

# Statement

Several years ago I met a mathematician who was intrigued by a problem
for which he didn't know a solution. His name was Von Koch, and I don't
know whether the problem has been solved since.

![Tree numbering](/media/problems/von-koch1.gif)

Anyway, the puzzle goes like this: Given a tree with N nodes (and hence
N-1 edges). Find a way to enumerate the nodes from 1 to N and,
accordingly, the edges from 1 to N-1 in such a way, that for each edge K
the difference of its node numbers equals to K. The conjecture is that
this is always possible.

For small trees the problem is easy to solve by hand. However, for
larger trees, and 14 is already very large, it is extremely difficult to
find a solution. And remember, we don't know for sure whether there is
always a solution!

![Larger tree](/media/problems/von-koch2.gif)

Write a function that calculates a numbering scheme for a given tree.
What is the solution for the larger tree pictured here?
