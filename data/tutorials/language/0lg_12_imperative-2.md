---
id: imperative-2
title: From Imperative to Functional
description: >
  How to get imperative level performance in a functional style
category: "Tutorials"
---

# From Imperative to Functional

## Introduction

The goal of this document is to teach some of the functional programming tricks allowing you to get the same level of performance you get in imperative style.

Draft: Things you though you counln't do w/o imperative



TODO: Move this into another document

This document has two main teaching goals:
1. Writing imperative code in OCaml
1. Combining and balancing imperative and functional code

In OCaml, you can write code in imperative style without compromising on type and memory safety. In the first part of this tutorial, imperative programming in OCaml is introduced.

Imperative and functional programming both have unique merits; OCaml allows combining them efficiently. See the second part of this tutorial for examples.

Finally, we look at code examples written in imperative style and show corresponding examples in functional programming style.

**Prerequisites**: This is an intermediate-level tutorial. You should have completed the [Basic Data Types](/docs/basic-data-types), [Values and Functions](/docs/values-and-functions) and [Lists](/docs/lists) tutorials.

### Fast Loops: Tail Recursion

When a function is making too many recursive calls, the `Stack_overflow` exception will be raised.
```ocaml
# let rec naive_length = function [] -> 0 | _ :: u -> 1 + naive_length u;;
val naive_length : 'a list -> int = <fun>

# List.init 1000 (Fun.const ()) |> naive_length;;
- : int = 1000

# List.init 1000000 (Fun.const ()) |> naive_length;;
Stack overflow during evaluation (looping recursion?).
```

If a million-element list is not enough, use a billion.

However, in some circumstances, it is possible to avoid this issue by using a [_tail recursive_](https://en.wikipedia.org/wiki/Tail_call) function. Here is how list length can be implemented using this technique
```ocaml
# let length u =
    let rec loop len = function [] -> len | _ :: u -> loop (len + 1) u in
    loop 0 u;;

# List.init 1000000 (Fun.const ()) |> naive_length;;
- : int = 1000000
```

This is how `List.length`` is [implemented](https://github.com/ocaml/ocaml/blob/trunk/stdlib/list.ml) in the standard library.

In the `naive_length` function, the addition is performed after returning from the recursive call. To do that in that order, all recursive calls must be recorded. This is the role of the [call stack](https://en.wikipedia.org/wiki/Call_stackcall). Each recursive call pushes a _stack frame_ on the call stack. When the call stack becomes too large, the stack overflow exception is raised.

In the `length` function, the addition is performed before the recursive call. In that order, there is nothing to do after the recursive call, which renders the call stack useless. The OCaml compiler detects such functions and generates code which is not using a call stack. This code is smaller, faster and likely to consume less memory.

It also is possible to write length using shadowing instead of a local function.
```ocaml
# let rec length len = function [] -> len | _ :: u -> length (len + 1) u;;
val length : int -> 'a list -> int = <fun>

# let length u = length 0 u;;
val length : 'a list -> int = <fun>
```

## Accumulators: Continuation Passing Style

**Note 1**: This is an advanced technique, skip that section if you don't need it.

The tail call elimination technique can't be applied to variant types that have constructors with several recursive occurrences.
```ocaml
# type 'a btree = Leaf | Root of 'a * 'a btree * 'a btree;;

# let rec height = function
    | Leaf -> 0
    | Root (_, l_tree, r_tree) -> 1 + max (height l_tree) (height r_tree)
```

Since a binary tree has two subtrees, when computing its height, two recursive calls are needed and one must take place after the other.

Creating a tall enough tree triggers a stack overflow.
```ocaml
# let rec left_comb acc n =
    if n = 0 then
      acc
    else
      left_comb (Root ((), acc, Leaf)) (n - 1);;
val left_comb : int -> unit btree = <fun>

# let left_comb = left_comb Leaf;;

# left_comb 1000000 |> ignore;;
- : unit = ()

# left_comb 1000000 |> height;;
Stack overflow during evaluation (looping recursion?).
```

The way to work around this situation is to use [Continuation-passing Style](https://en.wikipedia.org/wiki/Continuation-passing_style). Here is what it looks like to compute the height of a `btree`.
```ocaml
# let ( let* ) f x = f x;;
val ( let* ) : ('a -> 'b) -> 'a -> 'b = <fun>

# let rec height_cps t k = match t with
    | Leaf -> k 0
    | Root (_, l_tree, r_tree) ->
        let* l_hgt = height_cps l_tree in
        let* r_hgt = height_cps r_tree in
        k (1 + max l_hgt r_hgt);;
val height_cps : 'a btree -> (int -> 'b) -> 'b = <fun>

# let height t = height_cps t Fun.id;;
val height : 'a btree -> int = <fun>

# left_comb 1000000 |> height;;
- : int = 1000000
```

In the `length` function, the already computed length accumulates in each call. Here, what is accumulated is no longer an integer, it is a function. Such a function is called a _continuation_, that's the `k` parameter in `height_cps`. At any time, the continuation represents what needs to be done after processing the data at hand:
* If it's a `Leaf`, there's nothing to do but proceed with what's left to do, the continuation `k` is called with the hight of `Leaf` which is zero.
* If it's a `Root`, there are two subtrees: `l_tree` on the left, `r_tree` on the right.
  * Make the recursive call on `l_tree` and a continuation function taking the result of that call `l_hgt` as input. This makes sense because the continuation will be evaluated after the recursive call.
  * That continuation makes the recursive call on `r_tree` and another continuation that takes the result that second call `r_hgt` as input
  * The second continuation picks the tallest height, increments it, and passes it to the received continuation `k`

Don't freak out. Continuations are hard to grasp. Here is a translation of the above definition without custom binders, it may help to understand differently.
```ocaml
# let rec height_cps' t k = match t with
    | Leaf -> k 0
    | Root (_, l_tree, r_tree) ->
        let l_k l_hgt =
          let r_k r_hgt =
            k (1 + max l_hgt r_hgt) in
          height_cps' r_tree r_k in
        height_cps' l_tree l_k    clear_line !state;

```

Alternatively, large language model chatbots do a fair job explaining that kind of code, you can have a try.

### Asynchronous Processing

TODO: Mention concurrency

## Conclusion

Handling mutable state isn't good or bad. In the cases where it is needed, OCaml provides fine tools to handle them. Many courses and books on programming and algorithmic are written in imperative style without stronger reasons than being the dominant style. Many techniques can be translated into functional style without loss in speed or increased memory consumption. Careful inspection of many efficient programming techniques or good practices shows in essence, they are functional, made working the imperative setting by hook or by crook. In OCaml, it is possible to express things in their true nature and it is preferable to do so.

## References

* [The Curse of the Excluded Middle](https://queue.acm.org/detail.cfm?id=2611829), Erik Meijer. ACM Queue, Volume 12, Issue 4, April 2014, pages 20-29
* https://www.lri.fr/~filliatr/hauteur/pres-hauteur.pdf
* https://medium.com/neat-tips-tricks/ocaml-continuation-explained-3b73839b679f
* https://discuss.ocaml.org/t/what-is-the-use-of-continuation-passing-style-cps/4491/7
* https://www.pathsensitive.com/2019/07/the-best-refactoring-youve-never-heard.html
* https://link.springer.com/chapter/10.1007/11783596_2    clear_line !state;
