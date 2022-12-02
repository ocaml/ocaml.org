---
title: Last two elements of a list
number: "2"
difficulty: beginner
tags: [ "list" ]
---

# Solution

Here is a possible implementation of the `last_two` function:

```ocaml
let rec last_two (lst : 'a list) : ('a * 'a) option =
  match lst with
  | [] | [_] -> None
  | [x; y] -> Some (x, y)
  | _ :: t -> last_two t
```

This implementation uses pattern matching to handle four cases:

- If the input list is empty or has only one element, the `last_two` function returns `None`.
- If the input list has exactly two elements, the `last_two` function returns a tuple containing those two elements.
- If the input list has more than two elements, the `last_two` function calls itself recursively on the tail of the list (i.e., the list without its first element). This will eventually reduce the input list to one of the first two cases, and the result will be returned accordingly.

Here are some examples of how this `last_two` function can be used:

```ocaml
# last_two ["a"; "b"; "c"; "d"];;
- : (string * string) option = Some ("c", "d")
# last_two ["a"];;
- : (string * string) option = None
# last_two ["foo"; "bar"];;
- : (string * string) option = Some ("foo", "bar")
# last_two ["x"; "y"; "z"];;
- : (string * string) option = Some ("y", "z")
```

As you can see, the `last_two` function correctly returns the last two elements of the input list as a tuple, or `None` if the input list has fewer than two elements.

# Statement

Write a function `last_two : 'a list -> ('a * 'a) option` that takes a list as input and returns a tuple containing the last two elements of the list as an `('a * 'a) option` value. If the input list has fewer than two elements, the `last_two` function should return `None`.

For example, the following code should produce the indicated output:

```ocaml
# last_two ["a"; "b"; "c"; "d"];;
- : (string * string) option = Some ("c", "d")
# last_two ["a"];;
- : (string * string) option = None
```
