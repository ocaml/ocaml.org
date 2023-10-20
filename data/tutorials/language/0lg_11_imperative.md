---
id: imperative
title: Mutability and Imperative Programming
description: >
  Writing stateful programs in OCaml, mixing imperative and functional style
category: "Tutorials"
---

TODO: Relationship between side-effects and mutability. Change of state is a side-effect; that must be said.

# Mutability and Imperative Programming

## Introduction

This document gathers two main teaching goals:
1. Writing imperative programming in OCaml
1. Mixing and balancing imperative and functional programming

OCaml provides all means needed to write in imperative style. However it does it without compromising on type and memory safety. In the first part of this tutorial, imperative programming in OCaml is introduced with an accent on the OCaml way to avoid many of the issues found in imperative programming.

OCaml inherits from its ancestors the view that both imperative and functional programming have unique merits and that combining them for the better is possible. In the second part of this tutorial, ways to mix imperative and functional programming are compared and ranked. Also, example functional equivalents of things that are often though as requiring imperative are presented.

**Prerequisites**: This is an intermediate level tutorial. The requirement is to have completed [Basic Data Types](/docs/basic-data-types), [Values and Functions](/docs/values-and-functions) and [Lists](/docs/lists) tutorials.

## Mutable Data

### References

A name-value binding created using the `let = ` construct is immutable, once added to the environment, it is impossible to change the value or remove the name. However, there is kind of value that can be updated, that is called a _reference_ in OCaml.
```ocaml
# let a = ref 0;;
val a : int ref = {contents = 0}

# a := 1;;
- : unit = ()

# !a;;
- : int = 1
```

Here is what happens above:
1. The value `{ contents = 0 }` is bound to the name `a`. This is a normal definition, like any other definition, it is immutable. However the value `{ contents = 0 }` can be updated.
1. The _assign_ operator `:=` is used to updated the value `a`. It is changed from 0 to 1.
1. The _dereference_ operator `!` is used to read the content of the value `a`.

The `ref` identifier denotes two different things:
* The type of mutable references: `'a ref`
* The function `ref : 'a -> 'a ref` that creates a reference value

The assign operator is just a function that takes a reference, a value of the corresponding type and replaces previous contents of the reference by the provided value. The update takes places as a side effect.
```ocaml
# ( := );;
- : 'a ref -> 'a -> unit = <fun>
```

The dereference operator is also a function. It takes a reference and returns its contents.
```ocaml
# ( ! );;
- : 'a ref -> 'a = <fun>
```

Refer to the [Operators](/docs/operators) tutorial for more information on how unary and binary operators work in OCaml.

In contrast to many mainstream languages, the way OCaml handles mutable data has the following characteristics:
* It is not possible to create a non initialized mutable store.
* No confusion between actually mutable content and referring name. They have different syntax and type.

### Mutable Fields

#### Reference are Single Fields Records

The value `{ contents = 0 }` no only looks like a record. It is a record. Having a look at the way the `ref` type is defined is enlightening:
```ocaml
#show ref;;
external ref : 'a -> 'a ref = "%makemutable"
type 'a ref = { mutable contents : 'a; }
```

Starting from the bottom, the `'a ref` type is a single field record. The unique field, called `contents` is marked using the `mutable` key word which means that its contents is updatable.

The `external ref : 'a -> 'a ref = "%makemutable"` means the function `ref` is not written in OCaml.

#### Any Record Can Have Mutable Fields

Any field in a record can be tagged using the `mutable` key word.
```ocaml
# type book = {
  series : string;
  volume : int;
  title : string;
  author : string;
  mutable first_published : (int * int * int) option;
  mutable stock : int;
  mutable order_pending : bool
};;
type book = {
  series : string;
  volume : int;
  title : string;
  author : string;
  mutable first_published : (int * int * int) option;
  mutable stock : int;
  mutable order_pending : bool;
}
```

For instance here is how a book store data base could store a book entry.
* Fields `title`, `author` are constants
* Fields `first_published`, `stock` and `order` are mutable because their value can change trough time.

By the time of writing this tutorial (October 2023), a good book store using such a data base should have an entry like this:
```ocaml
# let murderbot_7 = {
    series = "Murderbot Diaries";
    volume = 7;
    title = "System Collapse";
    author = "Martha Wells";
    first_published = None;
    stock = 0;
    order_pending = true
  };;
val murderbot_7 : book =
  {series = "Murderbot Diaries"; volume = 7; title = "System Collapse";
   author = "Martha Wells"; first_published = None; stock = 0;
   order_pending = true}
```

When the book actually reaches the shelves, here is how update can be done:
```ocaml
# murderbot_7.first_published <- Some (14, 11, 2023);;
- : unit = ()

# murderbot_7.stock <- 10;;
- : unit = ()

# murderbot_7.order_pending <- false;;
- : unit = ()

# murderbot_7;;
- : book =
{series = "Murderbot Diaries"; volume = 7; title = "System Collapse";
 author = "Martha Wells"; first_published = Some (14, 11, 2023); stock = 10;
 order_pending = false}
```

As of reference assignment, field update takes place in a side effect.

Taking step backwards into references, this allows understanding how assign and dereference functions work
```ocaml
# let assign a x = a.contents <- x;;
val assign : 'a ref -> 'a -> unit = <fun>

# let deref a = a.contents;;
val deref : 'a ref -> 'a = <fun>

# assign a 2;;
- : unit = ()

# deref a;;
- : int = 2
```

The functions `assign` and `( := )` and the functions `deref` and `( ! )` are respectively doing the same thing.

### Arrays Bytes Sequences

#### Arrays

```ocaml
# let a = [| 2; 3; 4; 5; 6; 7; 8 |];;

# a.(0);;
- : int = 2

# a.(0) <- 9;;
- : unit = ()

# a.(0);;
- : int = 9
```

The update symbol `<-` used for fields is also used to update an arrays's cell content.

#### Byte Sequences

```ocaml
# let b = Bytes.of_string "abcdefghijklmnopqrstuvwxyz";;

# Bytes.get b 10;;
- : char = 'k'

# Bytes.set b 10 '_';;
- : unit = ()

# Bytes.get b 10;;
- : int = '_'
```

Byte sequences can be seen in two equivalent ways
* Updatable strings that can't be printed
* `char array` without syntactic sugar for indexed read and update

## Imperative Iteration

### For Loop

In OCaml, a for loop is an expression.
```ocaml
# for i = 0 to Array.length a - 1 do Printf.printf "%i\n" a.(i) done;;
9
3
4
5
6
7
8
- : unit = ()
```

For loop are convenient when iterating over arrays.
```ocaml
# let sum = ref 0 in
  for i = 0 to Array.length a - 1 do sum := !sum + a.(i) done;
  !sum;;
- : int = 42
```

The body of a for loop should be an expression of type `unit`.
```ocaml
# for i = Array.length a - 1 downto 0 do 0 done;;
Line 1, characters 39-40:
Warning 10 [non-unit-statement]: this expression should have type unit.
- : unit = ()
```

The `downto` key word allows the counter to decrease during the loop.

### While Loop

While loops are expressions to.
```ocaml
# let u = [9; 8; 7; 6; 5; 4; 3; 2; 1];;

# let sum, u = ref 0, ref u in
  while !u <> [] do
    sum := !sum + List.hd !u;
    u := List.tl !u
  done;
  !sum;;
- : int = 45
```

There are no repeat loops in OCaml.

### Breaking Out From a Loop

There is no break instruction in OCaml. Throwing the `Exit` exception is the recommended way to exit immediately from a loop.

Here is a possible implementation of `getc` in OCaml using the `Unix` module. In waits until a character is pressed and returns it immediately without echo.
```ocaml
# let getc () =
    let open Unix in
    let termio = tcgetattr stdin in
    tcsetattr stdin TCSAFLUSH { termio with c_icanon = false; c_echo = false };
    let c = input_char (in_channel_of_descr stdin) in
    tcsetattr stdin TCSAFLUSH termio;
    c
```

The following loop echoes characters typed on the keyboard, as long as they are different from `Escape`.
```ocaml
# try
    while true do
      let c = getc () in
      if c = '\027' then raise Exit;
      print_char c;
      flush stdout
    done
  with Exit -> ();;
```

## Recommendations on Mixing Functional and Imperative Programming

Functional and imperative programming are often mixed. However, not all mix creates good results. Some patterns and anti-patterns are listed in this section.

### Good: Function Encapsulated Mutability

Here is a possible way to compute the sum of an array of integers.
```ocaml
# let sum a =
    let result = ref 0 in
    for i = 0 to Array.length a - 1 do
      result := !result + a.(i)
    done;
    !result;;
val sum : int array -> int = <fun>
```

Function `sum` is written in the imperative style, using mutable data structures. That's an encapsulated implementation choice. That is just fine.

### Good: Application Wide State


### Good: Hash-Consing

### Good: Prefer Side-Effect Free / Stateless Functions

You can't avoid them. But should not unless unavoidable.

### Acceptable: Module Wide State

### Acceptable: Memoization

https://twitter.com/mrclbschff/status/1701737914319675747?t=HjFptgmk3LwnF3Zl0mtXmg&s=19

### Bad: Mutable in Disguise

Code looking as functional but actually stateful

### Bad: Hidden Side-Effect

TODO: include discussion on evaluation order, sides effects and monadic pipes

### Bad: Imperative by Default

## Example of Things You Don't Need Imperative Programming For
## Example where imperative programming isn't needed
## Imperative 
## Turning Code More Functional
## Imperative Programming Not 
## When FP is as good as IP
## Leveraging Functional Programming

### Fast Loops: Tail Recursion

Statelessness

### Accumulators: Continuation Passing Style

### Asynchronous Processing

TODO: Mention concurrency

## Conclusion

Handling mutable state isn't good or bad. In the cases where it is needed, OCaml provides fine tools to handle them. Many courses and books on programming and algorithmic are written in imperative style without stronger reasons thane being the dominant style. Many techniques can be translated into functional style without loss in speed or increased memory consumption. Careful inspection of many efficient programming techniques or good practices show they turn out to be functional programming in essense, made working the in imperative setting by hook or by crook. In OCaml, it is possible to express things in their true essence and it is preferable Monadsto do so.

## References

* [The Curse of the Excluded Middle](https://queue.acm.org/detail.cfm?id=2611829), Erik Meijer. ACM Queue, Volume 12, Issue 4, April 2014, pages 20-29
* https://www.lri.fr/~filliatr/hauteur/pres-hauteur.pdf
* https://medium.com/neat-tips-tricks/ocaml-continuation-explained-3b73839b679f
* https://discuss.ocaml.org/t/what-is-the-use-of-continuation-passing-style-cps/4491/7
* https://www.pathsensitive.com/2019/07/the-best-refactoring-youve-never-heard.html
* https://link.springer.com/chapter/10.1007/11783596_2