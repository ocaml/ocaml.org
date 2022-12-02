---
title: N'th element of a list
number: "3"
difficulty: beginner
tags: [ "list" ]
---

# Solution

Here is a possible implementation of the `at` function:

```ocaml
let rec at (k : int) (lst : 'a list) : 'a option =
  match lst with
  | [] -> None
  | h :: t -> if k = 0 then Some h else at (k - 1) t
```

This implementation uses pattern matching to handle two cases:

- If the input list is empty, the `at` function returns `None`.
- If the input list has at least one element, the `at` function checks if the index k is equal to 0. If it is, the function returns the first element of the list (i.e., the k-th element) as an `'a option` value. Otherwise, the function calls itself recursively on the tail of the list (i.e., the list without its first element) and the index `k - 1`. This will eventually reduce the input list to one of the first two cases, and the result will be returned accordingly.

# Statement

Write a function `at : int -> 'a list -> 'a option` that takes an integer `k` and a list as input, and returns the k-th element of the list as an `'a option` value. If the input list has fewer than `k` elements, the `at` function should return `None`.

For example, the following code should produce the indicated output:

```ocaml
# at 2 ["a"; "b"; "c"; "d"; "e"];;
- : string option = Some "c"
# at 2 ["a"];;
- : string option = None
```
