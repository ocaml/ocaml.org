---
title: Replicate the Elements of a List a Given Number of Times
slug: "15"
difficulty: intermediate
tags: [ "list" ]
description: "Write a function that replicates the elements of a list a given number of times."
---

# Solution

```ocaml
# let replicate list n =
    let rec prepend n acc x =
      if n = 0 then acc else prepend (n-1) (x :: acc) x in
    let rec aux acc = function
      | [] -> acc
      | h :: t -> aux (prepend n acc h) t in
    (* This could also be written as:
       List.fold_left (prepend n) [] (List.rev list) *)
    aux [] (List.rev list);;
val replicate : 'a list -> int -> 'a list = <fun>
```

> Note that `List.rev list` is needed only because we want `aux` to be
> [tail recursive](http://en.wikipedia.org/wiki/Tail_call).

# Statement

Replicate the elements of a list a given number of times.

```ocaml
# replicate ["a"; "b"; "c"] 3;;
- : string list = ["a"; "a"; "a"; "b"; "b"; "b"; "c"; "c"; "c"]
```
