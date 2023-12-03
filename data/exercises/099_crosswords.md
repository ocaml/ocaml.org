---
title: Crossword Puzzle
slug: "99"
difficulty: advanced
tags: []
description: "Fill in the crossword puzzle according to the given framework and word list."
---

# Solution

```ocaml
(* example pending *);;
```

# Statement

![Crossword](/media/problems/crossword.gif)

Given an empty (or almost empty) framework of a crossword puzzle and a
set of words. The problem is to place the words into the framework.

The particular crossword puzzle is specified in a text file which first
lists the words (one word per line) in an arbitrary order. Then, after
an empty line, the crossword framework is defined. In this framework
specification, an empty character location is represented by a dot (.).
In order to make the solution easier, character locations can also
contain predefined character values. The puzzle above is defined in the
file
[p7_09a.dat](https://sites.google.com/site/prologsite/prolog-problems/7/solutions-7/p7_09a.dat?attredirects=0&d=1),
other examples are
[p7_09b.dat](https://sites.google.com/site/prologsite/prolog-problems/7/solutions-7/p7_09b.dat?attredirects=0&d=1)
and
[p7_09d.dat](https://sites.google.com/site/prologsite/prolog-problems/7/solutions-7/p7_09d.dat?attredirects=0&d=1).
There is also an example of a puzzle
([p7_09c.dat](https://sites.google.com/site/prologsite/prolog-problems/7/solutions-7/p7_09c.dat?attredirects=0&d=1))
which does not have a solution.

Words are strings (character lists) of at least two characters. A
horizontal or vertical sequence of character places in the crossword
puzzle framework is called a site. Our problem is to find a compatible
way of placing words onto sites.

**Hints:**

1. The problem is not easy. You will need some time to thoroughly
 understand it. So, don't give up too early! And remember that the
 objective is a clean solution, not just a quick-and-dirty hack!
1. For efficiency reasons it is important, at least for larger puzzles,
 to sort the words and the sites in a particular order.
