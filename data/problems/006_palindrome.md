---
title: Palindrome
number: "6"
difficulty: beginner
tags: [ "list" ]
---

# Solution

```ocaml
# let is_palindrome list =
    (* One can use either the rev function from the previous problem, or the built-in List.rev *)
    list = List.rev list;;
val is_palindrome : 'a list -> bool = <fun>
```

# Statement

Find out whether a list is a palindrome.

> HINT: a palindrome is its own reverse.

```ocaml
# is_palindrome ["x"; "a"; "m"; "a"; "x"];;
- : bool = true
# not (is_palindrome ["a"; "b"]);;
- : bool = true
```
