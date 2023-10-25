---
id: imperative
title: Mutability and Imperative Programming
description: >
  Writing stateful programs in OCaml, mixing imperative and functional style
category: "Tutorials"
---

<!--
1. Deal with refs
1. Mutable record fields
1. for-loop
1. while-loop
1. raise Exit
1. Patterns and Anti-Pattern w.r.t. mixing FP & IP
1. Yes You Can! (do it with FP)

In a parking lot: Relationship between side-effects and mutability. Change of state is a side-effect; that must be said.

Side effects in parameters is bad because of parameter evaluation order not specified
-->


# Mutability and Imperative Programming

## Introduction

This document gathers two main teaching goals:
1. Writing imperative code in OCaml
1. Combining and balancing imperative and functional code

In OCaml, you can write code in imperative style without compromising on type and memory safety. In the first part of this tutorial, imperative programming in OCaml is introduced.

Imperative and functional programming have unique merits; OCaml allows to combine them for the better. See the second part of this tutorial for examples.

FIXME: this sentence needs to be improved.
Finally, we look at code examples written in imperative style and show corresponding examples in functional programming style.

**Prerequisites**: This is an intermediate level tutorial. You should have completed the [Basic Data Types](/docs/basic-data-types), [Values and Functions](/docs/values-and-functions) and [Lists](/docs/lists) tutorials.

## Mutable Data

FIXME: Do we need some text here?

### References

A name-value binding created using the `let … = …` construct is [immutable](https://en.wikipedia.org/wiki/Immutable_object), once added to the environment, it is impossible to change the value or remove the name. However, there is a kind of value that can be updated, that is called a _reference_ in OCaml.
```ocaml
# let a = ref 0;;
val a : int ref = {contents = 0}

# a := 1;;
- : unit = ()

# !a;;
- : int = 1
```

Here is what happens above:
1. The value `{ contents = 0 }` is bound to the name `a`. This is a normal definition, like any other definition, it is immutable. However the value `0` inside `contents` can be updated.
3. The _assign_ operator `:=` is used to update the value inside `a` from 0 to 1.
4. The _dereference_ operator `!` is used to read the content inside the value `a`.

The `ref` identifier denotes two different things:
* The type of mutable references: `'a ref`.
* The function `ref : 'a -> 'a ref` that creates a reference.

The assign operator is just a function that takes:
1. The reference to be updated
1. The value that replaces the previous contents.

The update takes place as a [side effect](https://en.wikipedia.org/wiki/Side_effect_(computer_science)).
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

The way OCaml handles mutable data has the following characteristics:
* It's impossible to create unintialized references.
* No confusion between mutable content and the reference is possible: They have different syntax and type.

### Mutable Fields

#### Reference are Single Fields Records

The value `{ contents = 0 }` of type `int ref` not only looks like a record: It is a record. Having a look at the way the `ref` type is defined is enlightening:
```ocaml
#show ref;;
external ref : 'a -> 'a ref = "%makemutable"
type 'a ref = { mutable contents : 'a; }
```

Starting from the bottom, the `'a ref` type is a record with just a single field `contents` which is marked with the `mutable` key word. This means that the field can be updated.

The `external ref : 'a -> 'a ref = "%makemutable"` means the function `ref` is not written in OCaml, but that is implementation detail we do not care about in this tutorial. If interested, check the [Calling C Libraries](/docs/calling-c-libraries) tutorial to learn how to use OCaml foreign function interface.

#### Any Record Can Have Mutable Fields

Any field in a record can be tagged using the `mutable` key word.
```ocaml
# type book = {
  series : string;
  volume : int;
  title : string;
  author : string;
  mutable stock : int;
};;
type book = {
  series : string;
  volume : int;
  title : string;
  author : string;
  mutable stock : int;
}
```

For instance here is how a book store could track its book inventory:
* Fields `title`, `author`, `volume`, `series` are constants
* Field `stock` is mutable because this value changes with each sale or when restocking

Such a data base should have an entry like this:
```ocaml
# let vol_7 = {
    series = "Murderbot Diaries";
    volume = 7;
    title = "System Collapse";
    author = "Martha Wells";
    stock = 3
  };;
val vol_7 : book =
  {series = "Murderbot Diaries"; volume = 7; title = "System Collapse";
   author = "Martha Wells"; stock = 0}
```

When the book store receives a delivery of 7 of these books, here is how the data update can be done:
```ocaml
# vol_7.stock <- vol_7.stock + 7;;
- : unit = ()

# vol_7;;
- : book =
{series = "Murderbot Diaries"; volume = 7; title = "System Collapse";
 author = "Martha Wells"; stock = 10 }
```

Mutable record field update is a side effect performed using the left arrow symbol `<-`. In the expression `vol_7.stock <- vol_7.stock + 7` the meaning of `vol_7.stock` depends on its context:
* In `vol_7.stock <- …` it refers to the mutable field to be updated
* In the right-hand side expression `vol_7.stock + 7`, it denotes the contents of the field

Looking at references again, we can define functions `assign` and `deref`:
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

The function `assign` does the same as the operator `( := )`, while the function `deref` does the same as the `( ! )` operator.

#### Field Update _vs_ Record Copy

In this section we compare two way to implement a C-like `getc` function. It waits until a key is pressed and returns the character corresponding without echoing it. This function will also be used later on in this tutorial.

This is using two functions from the `Unix` module. Both are used to access terminal attributes associated with standard input:
* `tcgetattr stdin TCSAFLUSH` read and return them as a record (this is similar to `deref`)
* `tcsetattr stdin TCSAFLUSH` update them (this is similar to `assign`)

These attributes need to be tweaked in order to do the reading the way we want. The logic is the same in both implementations:
1. Read the terminal attributes
1. Tweak the terminal attributes
1. Wait until a key is pressed, read it as a character
1. Restore the initial terminal attributes
1. Return the read character

Actual read is done using the `input_char` function from the standard library.

Here is the first implementation:
```ocaml
# let getc () =
    let open Unix in
    let termio = tcgetattr stdin in
    let c_icanon, c_echo = termio.c_icanon, termio.c_echo in
    termio.c_icanon <- false;
    termio.c_echo <- false;
    tcsetattr stdin TCSAFLUSH termio;
    let c = input_char (in_channel_of_descr stdin) in
    termio.c_icanon <- c_icanon;
    termio.c_echo <- c_echo;
    tcsetattr stdin TCSAFLUSH termio;
    c;;
val getc : unit -> char = <fun>
```
In this implementation, update of the `termio` fields takes place twice.
* Before `input_char`, both are set to `false`
* After `input_char`, initial values are restored

Here is the second implementation:
```ocaml
# let getc () =
    let open Unix in
    let termio = tcgetattr stdin in
    tcsetattr stdin TCSAFLUSH { termio with c_icanon = false; c_echo = false };
    let c = input_char (in_channel_of_descr stdin) in
    tcsetattr stdin TCSAFLUSH termio;
    c;;
val getc : unit -> char = <fun>
```

In this implementation, the record returned by the call to `tcgetattr` isn't updated. A copy is made using `{ termio with c_icanon = false; c_echo = false }`. That copy only differs from the read `termio` value on fields `c_icanon` and `c_echo`, that's the meaning of `termio with …`

That allows the second call to `tcsetattr` to restore terminal attributes back to their initial state.

### Arrays and Bytes Sequences

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

The update symbol `<-` used for fields is also used to update an arrays's cell content. The semantics of `a.(i)` work as field update:
* When on the left of `<-`, it denotes which cell to update.
* When on the right of `<-`, it denotes a cell's content.

Arrays are covered in detail in a [dedicated](/docs/arrays) tutorial.

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

While loops are expressions too.
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

This is requires using a `getc` function as defined in section [Field Update _vs_ Record Copy](#field-update-vs-record-copy).

The following loop echoes characters typed on the keyboard, as long as they are different from `Escape`.
```ocaml
# try
    print_endline "Press Escape to exit";
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

Some applications must maintain a state while they are running.  

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

### Bad: Side Effects in Arguments

## Example of Things You Don't Need Imperative Programming For
## Example where imperative programming isn't needed
## Imperative 
## Turning Code More Functional
## Imperative Programming Not 
## When FP is as good as IP
## Leveraging Functional Programming

### Fast Loops: Tail Recursion

When function is making too many recursive calls, the `Stack_overflow` exception will be raised.
```ocaml
# let rec naive_length = function [] -> 0 | _ :: u -> 1 + naive_length u;;
val naive_length : 'a list -> int = <fun>

# List.init 1000 (Fun.const ()) |> naive_length;;
- : int = 1000

# List.init 1000000 (Fun.const ()) |> naive_length;;
Stack overflow during evaluation (looping recursion?).
```

If a million element list is not enough, use a billion.

However, in some circumstances, it is possible to avoid this issue by using a [_tail recursive_](https://en.wikipedia.org/wiki/Tail_call) function. Here is how list length can be implemented using this technique
```ocaml
# let length u =
    let rec loop len = function [] -> len | _ :: u -> loop (len + 1) u in
    loop 0 u;;

# List.init 1000000 (Fun.const ()) |> naive_length;;
- : int = 1000000
```

This is how List.length is [implemented in the standard library](https://github.com/ocaml/ocaml/blob/trunk/stdlib/list.ml).

In the `naive_length` function, the addition is performed after returning from the recursive call. To do that in that order, all recursive calls must be recorded. This is the role of [_call stack_](https://en.wikipedia.org/wiki/Call_stackcall). Each recursive call pushes a _stack frame_ on the call stack. When the call stack become too large, the stack overflow exception is raised.

In the `length` function, the addition is performed before the recursive call. In that order, there is nothing to do after the recursive call, which renders the call stack useless. The OCaml compiler detects such functions and generates code which is not using a call stack. This code is smaller, faster and likely to consume less memory.

It also is possible to write length using shadowing instead of a local function.
```ocaml
# let rec length len = function [] -> len | _ :: u -> length (len + 1) u;;
val length : int -> 'a list -> int = <fun>

# let length u = length 0 u;;
val length : 'a list -> int = <fun>
```

### Accumulators: Continuation Passing Style

The tail call elimination technique can't be applied on variant types that have constructors with several recursive occurrences.
```ocaml
# type 'a btree = Leaf | Root of 'a * 'a btree * 'a btree;;

# let rec height = function
    | Leaf -> 0
    | Root (_, l_tree, r_tree) -> 1 + max (height l_tree) (height r_tree)
```

Since a binary tree has two subtrees, when computing its height, two recursive calls are needed and one must take place after the other.

Creating a tall enough tree triggers a stack overflow.
```ocaml
# let rec left_comb comb n = if n = 0 then comb else left_comb (Root ((), comb, Leaf)) (n - 1);;
val left_comb : int -> unit btree = <fun>

# let left_comb = left_comb Leaf;;

# left_comb 1000000 |> ignore;;
- : unit = ()

# left_comb 1000000 |> height;;
Stack overflow during evaluation (looping recursion?).
```

The way to work around this situation is to use [Continuation-passing Style](https://en.wikipedia.org/wiki/Continuation-passing_style). Here is how it looks like to compute the height of a `btree`.
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

# let rec height_cps t k = match t with
    | Leaf -> k 0
    | Root (_, l_tree, r_tree) ->
        let l_k l_hgt =
          let r_k r_hgt =
            k (1 + max l_hgt r_hgt) in
          height_cps r_tree r_k in
        height_cps l_tree l_k

# let height t = height_cps t Fun.id;;
val height : 'a btree -> int = <fun>

# left_comb 1000000 |> height;;
- : int = 1000000
```

Traversal in depth first order, accumulated in stack-continuation, result in reversed order.

In the `length` function, the already computed length accumulates in each call. Here, what is accumulated is no longer an integer, it is a function. Such a function is called a _continuation_, that's the `k` parameter in `height_cps`. At any time, the continuation represents what needs to be done after processing the data at hand:
* When reaching a `Leaf`, there's nothing to do but proceed with what's left to do, continuation `k` is called with 0.
* When reaching a `Root`:
  1. Make the recursive call on the left subtree `l_tree`, passing a continuation where
  1. The 
  1. A continuation function taking the left height as parameter (called `l_hgt`) an those body are the two last line of the code
    1. Inside that continuation, make the 

  
  when it's complete, call its result `r_hgt` (left height) 
  - Make a recursive call 




When inspecting a `Root`, the function makes a recursive call with a new closure as continuation. The body of that closure is 


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