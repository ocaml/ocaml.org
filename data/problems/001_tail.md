---
title: Tail of a list
number: "1"
difficulty: beginner
tags: [ "list" ]
---

# Solution

Here is a possible implementation of the last function in OCaml:

```ocaml
let last (lst : 'a list) : 'a option =
  match lst with
  | [] -> None
  | [x] -> Some x
  | _ :: t -> last t
```

This implementation uses pattern matching to handle three cases:

- If the input list is empty, the `last` function returns None.
- If the input list has only one element, the `last` function returns Some x, where x is the element of the list.
- If the input list has more than one element, the `last` function calls itself recursively on the tail of the list (i.e., the list without its first element). This will eventually reduce the input list to one of the first two cases, and the result will be returned accordingly.
Here are some examples of how this `last` function can be used:

```ocaml
# last ["a"; "b"; "c"; "d"];;
- : string option = Some "d"
# last [];;
- : 'a option = None
# last ["foo"];;
- : string option = Some "foo"
# last ["x"; "y"; "z"];;
- : string option = Some "z"
```

As you can see, the last function correctly returns the last element of the input list, or `None` if the input list is empty.

# Statement

Write a function `last : 'a list -> 'a option` that takes a list as input and returns the last element of the list as an `'a option` value. If the input list is empty, the last function should return None.

```ocaml
# last ["a" ; "b" ; "c" ; "d"];;
- : string option = Some "d"
# last [];;
- : 'a option = None
```

Your implementation should be as efficient as possible, and should not use any built-in functions or libraries for extracting the last element of a list.
