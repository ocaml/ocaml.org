---
title: Palindrome
slug: "6"
difficulty: beginner
tags: [ "list" ]
description: "Find out whether a list is a palindrome."
---

## Solution

```ocaml
# let is_palindrome list =
    (* One can use either the rev function from the previous problem, or the built-in List.rev *)
    list = List.rev list;;
val is_palindrome : 'a list -> bool = <fun>
```

## Statement

Find out whether a list is a palindrome.

**Hint:** A palindrome is its own reverse.

```ocaml
# is_palindrome ["x"; "a"; "m"; "a"; "x"];;
- : bool = true
# not (is_palindrome ["a"; "b"]);;
- : bool = true
```
