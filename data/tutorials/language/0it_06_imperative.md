---
id: mutability-loops-and-imperative
title: Mutability, Loops, and Imperative Programming
description: >
  Writing stateful programs in OCaml, mixing imperative and functional style
category: "Introduction"
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

This document has two main teaching goals:
1. Writing imperative code in OCaml
1. Combining and balancing imperative and functional code
-->


# Mutability, Loops, and Imperative Programming

Imperative and functional programming both have unique merits; OCaml allows combining them efficiently. In the first part of this tutorial, mutable state and imperative control flow in OCaml are introduced. See the second part of this tutorial for examples of recommended, situational or discouraged use of these features.

**Prerequisites**: [Basic Data Types](/docs/basic-data-types), [Values and Functions](/docs/values-and-functions), [Lists](/docs/lists) and [Modules](/docs/modules).

## Immutable vs Mutable Data

When you use `let … = …` to bind a value to a name, this name-value binding is [immutable](https://en.wikipedia.org/wiki/Immutable_object): It is impossible to _mutate_ (which is a fancy term for “change”, “update”, or “modify”) the value assigned to the name.

In the following sections, we introduce OCaml's language features for dealing with _mutable_ state.

## References

There is a special kind of value, called _reference_, whose contents can be updated:
```ocaml
# let a = ref 0;;
val a : int ref = {contents = 0}

# a := 1;;
- : unit = ()

# !a;;
- : int = 1
```

Here is what happens in this example:
1. The value `{ contents = 0 }` is bound to the name `a`. This is a normal definition. Like any other definition it is immutable. However, the value `0` in the `contents` field of `a` is _mutable_, i.e. it can be updated.
3. The _assignment_ operator `:=` is used to update the mutable value inside `a` from `0` to `1`.
4. The _dereference_ operator `!` reads the contents of the mutable value inside `a`.

The `ref` identifier above refers to two different things:
* The function `ref : 'a -> 'a ref` that creates a reference.
* The type of mutable references: `'a ref`.

**Assignment Operator**

```ocaml
# ( := );;
- : 'a ref -> 'a -> unit = <fun>
```

The assignment operator `:=` is just a function. It takes:
1. The reference to be updated
1. The value that replaces the previous contents.

The update takes place as a [side effect](https://en.wikipedia.org/wiki/Side_effect_(computer_science)), the value `()` is returned.

**Dereference Operator**

```ocaml
# ( ! );;
- : 'a ref -> 'a = <fun>
```
The dereference operator is a function that takes a reference and returns its contents.

Refer to the [Operators](/docs/operators) documentation for more information on how unary and binary operators work in OCaml.

Working with mutable data in OCaml,
* it is impossible to create uninitialised references, and
* the mutable content and the reference have different syntax and type: no confusion between them is possible.

## Mutable Record Fields

Any field in a record can be tagged using the `mutable` keyword, to declare that this field can be updated.
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

For instance, here is how a bookshop could track its book inventory:
* Fields `title`, `author`, `volume`, `series` are constants.
* Field `stock` is mutable because this value changes with each sale or when restocking.

Such a database should have an entry like this:
```ocaml
# let vol_7 = {
    series = "Murderbot Diaries";
    volume = 7;
    title = "System Collapse";
    author = "Martha Wells";
    stock = 0
  };;
val vol_7 : book =
  {series = "Murderbot Diaries"; volume = 7; title = "System Collapse";
   author = "Martha Wells"; stock = 0}
```

When the bookshop receives a delivery of 10 of these books, we update the mutable `stock` field:
```ocaml
# vol_7.stock <- vol_7.stock + 10;;
- : unit = ()

# vol_7;;
- : book =
{series = "Murderbot Diaries"; volume = 7; title = "System Collapse";
 author = "Martha Wells"; stock = 10 }
```

Mutable record fields are updated using the left arrow symbol `<-`. In the expression `vol_7.stock <- vol_7.stock + 7` the meaning of `vol_7.stock` depends on its context:
* In the left-hand side of `<-`, it refers to the mutable field to be updated
* In the right-hand side of `<-`, it denotes the contents of the mutable field

In contrast to references, there is no special syntax to dereference a mutable record field.

### References Are Single Field Records

In OCaml, references are records with a single mutable field:
```ocaml
# #show ref;;
external ref : 'a -> 'a ref = "%makemutable"
type 'a ref = { mutable contents : 'a; }
```

The type `'a ref` is a record with a single field `contents` which is marked with the `mutable` keyword.

The line `external ref : 'a -> 'a ref = "%makemutable"` means the function `ref` is not written in OCaml, but that is an implementation detail we do not care about in this tutorial. If interested, check the [Calling C Libraries](/docs/calling-c-libraries) tutorial to learn how to use the foreign function interface.

Since references are single field records, we can define functions `assign` and `deref` using the mutable record field update syntax:
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


## Arrays

In OCaml, an array is a mutable, fixed-size data structure that can store a sequence of elements of the same type. Arrays are indexed by integers and provide constant-time access and update of elements.

```ocaml
# let a = [| 2; 3; 4; 5; 6; 7; 8 |];;
val a : int array = [|2; 3; 4; 5; 6; 7; 8|]

# a.(0);;
- : int = 2

# a.(0) <- 9;;
- : unit = ()

# a.(0);;
- : int = 9
```

The arrow symbol `<-` is used to update an array element at a given index. The array index access syntax `a.(i)`, where `a` is a value of type `array` and `i` is an integer, stands for either

* the array location to update (when on the left hand side of `<-`), or
* the cell's content (when on the right hand side of `<-`).

For more a more detailed discussion of Arrays, see the [Arrays](/docs/arrays) tutorial.

## Byte Sequences

The `bytes` type in OCaml represents a mutable sequence of bytes. Each element in a `bytes` sequence is a character, but since characters in OCaml are represented as 8-bit bytes, a `bytes` value can effectively manage any sequence of bytes.

```ocaml
# let b = Bytes.of_string "abcdefghijklmnopqrstuvwxyz";;
val b : bytes = Bytes.of_string "abcdefghijklmnopqrstuvwxyz"

# Bytes.get b 10;;
- : char = 'k'

# Bytes.set b 10 '_';;
- : unit = ()

# b;;
- : bytes = Bytes.of_string "abcdefghij_lmnopqrstuvwxyz"
```

Byte sequences can be created from `string` values using the function `Bytes.of_string`. Individual elements in the sequence can be updated or read by their index using `Bytes.set`, and, respectively `Bytes.get`.

You can think of byte sequences as
* updatable strings that can't be printed, or
* `char array`s without syntactic sugar for indexed read and update.

<!-- FIXME: link to a dedicated Byte Sequences tutorial -->

## Example: `get_char` Function

<!-- FIXME: needs more motivation -->

In this section, we compare two ways to implement a `get_char` function. The function waits until a key is pressed and returns the corresponding character without echoing it. This function will also be used later on in this tutorial.

We use two functions from the `Unix` module to read/update attributes of the terminal associated with standard input:
* `tcgetattr stdin TCSAFLUSH` read and return them as a record (this is similar to `deref`)
* `tcsetattr stdin TCSAFLUSH` update them (this is similar to `assign`)

These attributes need to be set correctly (i.e. turn of echoing and disable canonical mode) in order to do the reading the way we want. The logic is the same in both implementations:
1. Read the terminal attributes
1. Set the terminal attributes
1. Wait until a key is pressed, read it as a character
1. Restore the initial terminal attributes
1. Return the read character

We read characters from standard input using the `input_char` function from the OCaml standard library.

Here is the first implementation:
```ocaml
# let get_char () =
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
val get_char : unit -> char = <fun>
```
In this implementation, we update the fields of `termio`
* before `input_char` (setting both `c_icanon` and `c_echo` to `false`), and
* after `input_char` (restoring the initial values).

Here is the second implementation:
```ocaml
# let get_char () =
    let open Unix in
    let termio = tcgetattr stdin in
    tcsetattr stdin TCSAFLUSH
      { termio with c_icanon = false; c_echo = false };
    let c = input_char (in_channel_of_descr stdin) in
    tcsetattr stdin TCSAFLUSH termio;
    c;;
val get_char : unit -> char = <fun>
```

In this implementation, the record returned by the call to `tcgetattr` is not modified. A copy is made using `{ termio with c_icanon = false; c_echo = false }`. This copy only differs from the `termio` value on fields `c_icanon` and `c_echo`, that's the meaning of `termio with …`

In the second call to `tcsetattr`, we restore the terminal attributes to their initial state without explicitly reading them.

## Imperative Control Flow

OCaml provides a sequence operator `;` that allows to chain expressions, as well as `for` loops and `while` loops which execute a block of code repeatedly.

### Sequence Operator

The `;` operator is known as the _sequence_ operator. It allows you to evaluate multiple expressions in order, with the value of the last expression being the value of the entire sequence.

The values of any previous expressions are discarded. Thus, it makes sense to use expressions with side effects, except for the last expression of the sequence which could be free of side effects.

```ocaml
# let _ =
  print_endline "Hello,";
  print_endline "world!";
  42;;
Hello,
world!
- : int = 42
```
In this example, the first two expressions are `print_endline` function calls, which produce side effects (printing to the console), and the last expression is simply the integer `42`, which becomes the value of the entire sequence. The `;` operator is used to separate these expressions.

**Remark** The semicolon is not an operator, in the sense that is it not a function of type `unit -> 'a -> 'a`. It is a construct of the language. That allows terminating sequences with a semicolon which is ignored.
```ocaml
# (); 42; ;;
- : int = 42
```

### For Loop

A `for` loop with syntax
```ocaml
for i = start_value to end_value do body done
```
has a loop variable `i` that starts at `start_value` and is incremented until it reaches `end_value`, evaluating the `body` expression (which may contain `i`) on every iteration. Here, `for`, `to`, `do`, and `done` are keywords used to declare the loop.

The type of a `for` loop expression is `unit`.
```ocaml
# for i = 0 to 5 do Printf.printf "%i\n" i done;;
0
1
2
3
4
5
- : unit = ()
```

Here, `0` is the start value and `5` is the end value that the loop variable `i`, which is incremented after every iteration, will take on.

The body of a `for` loop must be an expression of type `unit`:
```ocaml
# for i = Array.length a - 1 downto 0 do 0 done;;
Line 1, characters 39-40:
Warning 10 [non-unit-statement]: this expression should have type unit.
- : unit = ()
```

When you use the `downto` keyword (instead of the `to` keyword), the counter decreases on every iteration of the loop.

For example, `for` loops are convenient to iterate over and modify arrays:
```ocaml
# let a = [| 2; 3; 4; 5; 6; 7; 8 |];;
val a : int array = [|2; 3; 4; 5; 6; 7; 8|]

# let sum = ref 0 in
  for i = 0 to Array.length a - 1 do sum := !sum + a.(i) done;
  !sum;;
- : int = 42
```

**Note:** Here is how to do the same thing using an iterator function:
```ocaml
# let sum = ref 0 in Array.iter (fun i -> sum := !sum + i) a; !sum;;
- : int = 42
```

### While Loop

A `while` loop has syntax
```ocaml
while condition do body done
```
and continues to execute the `body` expression as long as `condition` remains true. Here, `while`, `do`, and `done` are keywords used to declare the while loop.

The type of a `while` loop expression is `unit`.

```ocaml
# let i = ref 0 in
  while !i < 5 do
    Printf.printf "%i\n" !i;
    i := !i + 1;
  done;;
0
1
2
3
4
- : unit = ()
```

In this example, the `while` loop continues to execute as long as the value held by the reference `i` is less than `5`.

### Breaking Loops Using Exceptions

Throwing the `Exit` exception is a recommended way to exit immediately from a loop.

The following example uses the `get_char` function we defined earlier (in the section [Example: `get_char` Function](#example-getchar-function)).

```ocaml
# try
    print_endline "Press Escape to exit";
    while true do
      let c = get_char () in
      if c = '\027' then raise Exit;
      print_char c;
      flush stdout
    done
  with Exit -> ();;
```
This `while` loop echoes characters typed on the keyboard. When the ASCII `Escape` character is read, the `Exit` exception is thrown.

## Recommendations for Mutable State and Side Effects

Functional and imperative programming styles are often used together. However, not all ways of combining them give good results. We show some patterns and anti-patterns relating to mutable state and side effects in this section.

### Good: Function-Encapsulated Mutability

Here is a function that computes the sum of an array of integers.
```ocaml
# let sum a =
    let result = ref 0 in
    for i = 0 to Array.length a - 1 do
      result := !result + a.(i)
    done;
    !result;;
val sum : int array -> int = <fun>
```

The function `sum` is written in imperative style, using mutable data structures and a `for` loop. However, no mutability is exposed: it is a fully encapsulated implementation choice. This function is safe to use, no problems are to be expected.

### Good: Application-Wide State

Some applications maintain some state while they are running. Here are a couple of examples:
- A Read-Eval-Print-Loop (REPL). The state is the environment where values are bound to names. In OCaml, the environment is append-only, but some languages allow replacing or removing name-value bindings.
- A server for a stateful protocol. Each session has a state, the global state consists of all the session states.
- A text editor. The state includes the most recent commands (to allow undo), state of any open files, the settings, and the state of the UI.
- A cache.

The following is a toy line editor, using the `get_char` function [defined earlier](#example-getchar-function). It waits for characters on standard input and exits on end-of-file, carriage return or newline. Otherwise, if the character is printable, it prints it and records it in a mutable list used as a stack. If the character is the delete code, the stack is popped and the last printed character is erased.
```ocaml
# let record_char state c =
    (String.make 1 c, c :: state);;
val record_char : char list -> char -> string * char list = <fun>

# let remove_char state =
    ("\b \b", if state = [] then [] else List.tl state);;
val remove_char : 'a list -> string * 'a list = <fun>

# let state_to_string state =
    List.(state |> rev |> to_seq |> String.of_seq);;
val state_to_string : char list -> string = <fun>

# let rec loop state =
    let c = get_char () in
    if c = '\004' || c = '\n' || c = '\r' then raise Exit;
    let s, new_state = match c with
      | '\127' -> remove_char !state
      | c when c >= ' ' -> record_char !state c
      | _ -> ("", !state) in
    print_string s;
    state := new_state;
    flush stdout;
    loop state;;
val loop : char list ref -> 'a = <fun>

# let state = ref [] in try loop state with Exit -> state_to_string !state;;
```

This example illustrates the following:
- The functions `record_char` and `remove_char` neither update the state nor produce side effects. Instead, they each return a pair of values consisting of a string to print, and the next state `new_state`.
- I/O and state update side effects happen inside the `loop` function
- The state is passed as a parameter to the `loop` function

This is a possible way to handle application-wide state. As in the [Function-Encapsulated Mutability](#good-function-encapsulated-mutability) example, state-aware code is contained in a narrow scope, the rest of the code is purely functional.

**Note**: Here, the state is copied, which is not memory efficient. In a memory-aware implementation, state update functions would produce a “diff” (data describing the difference between the old and updated version of the state).

### Good: Precomputing Values

Let's imagine you store angles as fractions of the circle in 8-bit unsigned integers, storing them as `char` values. In this system, 64 is 90 degrees, 128 is 180 degrees, 192 is 270 degrees, 256 is full circle and so on. If you need to compute cosine on those values, an implementation might look like this:
```ocaml
# let pi = 3.14159265358979312 /. 128.0;;
pi : float = 0.0245436926061702587

# let char_cos c =
    c |> int_of_char |> float_of_int |> ( *. ) (pi /. 128.0) |> cos;;
val char_cos : char -> float = <fun>
```

However, it is possible to make a faster implementation by precomputing all the possible values in advance, there are only 256 of them.
```ocaml
# let char_cos_tab = Array.init 256 (fun i -> i |> char_of_int |> char_cos);;
val char_cos_tab : float array =

# let char_cos c = char_cos_tab.(int_of_char c);;
val char_cos : char -> float = <fun>
```

### Good: Memoization

The [memoization](https://en.wikipedia.org/wiki/Memoization) technique relies on the same idea as the example from the previous section: look up results from a table of previously computed values.

However, instead of precomputing everything, memoization uses a cache that is populated when calling the function. Either, the provided parameters
* are found in the cache (it is a hit) and the stored result is returned, or they
* are not found in the cache (it's a miss) and the result is computed, stored in the cache, and returned.

You can find a concrete example of memoization and a more in-depth explanation in the chapter on [Memoization](https://cs3110.github.io/textbook/chapters/ds/memoization.html) of "OCaml Programming: Correct + Efficient + Beautiful".

<!-- FIXME: reference CS3110 memoization documented on ocaml.org after it is merged -->

### Good: Functional by Default

By default, OCaml programs should be written in a mostly functional style. This constitutes trying to avoid side-effects where possible, and relying on immutable state instead of mutable state.

It is possible to use an imperative programming style without losing the benefits of type and memory safety. However, it doesn't usually make sense to only program in an imperative style. Not using functional programming idioms at all would result in non-idiomatic OCaml code.

Most existing modules provide an interface meant to be used in functional way. Some would require the development and maintenance of [wrapper libraries](https://en.wikipedia.org/wiki/Wrapper_library) to be used in an imperative setting and such use would in many cases be inefficient.

###  It Depends: Module State

A module may expose or encapsulate a state in several different ways:
1. Good: Expose a type representing a state, with state creation or reset functions
1. It depends: Only expose state initialisation, this implies there only is a single state
1. Bad: Mutable state with no explicit initialisation function or no name referring to the mutable state

For example, the [`Hashtbl`](/api/Hashtbl.html) module provides an interface of the first kind. It has the type `Hashtbl.t` representing mutable data, it also exposes `create`, `clear` and `reset` functions. That the `clear` and `reset` functions return `unit` is a strong signal to the reader that they perform the side-effect of updating the mutable data.

```ocaml
#show Hashtbl.t;;
type ('a, 'b) t = ('a, 'b) Hashtbl.t

#  Hashtbl.create;;
- : ?random:bool -> int -> ('a, 'b) Hashtbl.t = <fun>

# Hashtbl.reset;;
- : ('a, 'b) Hashtbl.t -> unit = <fun>

# Hashtbl.clear;;
- : ('a, 'b) Hashtbl.t -> unit = <fun>
```

On the other hand, a module may define mutable data internally impacting its behaviour without exposing it in its interface. This is inadvisable.

### Bad: Undocumented Mutation

Here's an example of bad code:
```ocaml
# let partition p a =
    let b = Array.copy a in
    let a_len = ref 0 in
    let b_len = ref 0 in
    for i = 0 to Array.length a - 1 do
      if p a.(i) then begin
        a.(!a_len) <- a.(i);
        incr a_len
      end else begin
        b.(!b_len) <- a.(i);
        incr b_len
      end
    done;
    (Array.truncate a_len a, Array.truncate b_len b);;
```

**Note:** This example will not run in the REPL, since the function `Array.truncate` is not defined.

To understand why this is bad code, assume that the function `Array.truncate` has type `int -> 'a array -> 'a array`. It behaves such that `Array.truncate 3 [5; 6; 7; 8; 9]` returns `[5; 6; 7]` and the returned array physically corresponds to the 3 first cells of the input array.

The type of `partition` would be `('a -> bool) -> 'a array -> 'a array * 'a array` and it could be documented as:
> `partition p a` returns a pair of arrays `(b, c)` where `b` is an array containing all the elements of `a` that satisfy the predicate `p`, and `c` is an array containing the elements of `a` that do not satisfy `p`. The order of the elements from the input array is preserved.

On first glance, this looks like an application of [Function-Encapsulated mutability](#good-function-encapsulated-mutability). However, it is not: the input array is modified. This function has a side effect that is either
* not intended, or
* not documented.

In the latter case, the function should be named differently (e.g. `partition_in_place` or `partition_mut`) and the effect on the input array should be documented.

<!-- TODO:

### Bad: Stateful External Factor

GOTCHA: This is the dual of the previous anti-pattern. “Mutable in disguise” is an unintended or undocumented side-effect performed by a function. “Stateful Influence” is the unintended or undocumented influence of some mutable state on the result of a function (as an external factor).

-->

### Bad: Undocumented Side Effect

Consider this code:
```ocaml
# module Array = struct
    include Stdlib.Array
    let copy a =
      if Array.length a > 1000000 then Analytics.collect "Array.copy" a;
      copy a
    end;;
Error: Unbound module Analytics
```

**Note:** This code will not run because there is no module called `Analytics`.

A module called `Array` is defined, it shadows and includes the [`Stdlib.Array`](/api/Array.html) module. See the [Module Inclusion](docs/modules#module-inclusion) part of the [Modules](docs/modules) tutorial for details about this pattern.

To understand why this code is bad, assume that `Analytics.collect` is a function that makes a network connection to transmit data to another server.

Now, the newly defined `Array` module contains a `copy` function which has a potentially unexpected side effect, but only if the array to copy has a million cells or above.

If you're writing functions with non-obvious side effects, don't shadow existing definitions: give the function a descriptive name (e.g. `Array.copy_with_analytics`) and document the fact that there's a side-effect that the caller may not be aware of.

### Bad: Side Effects in Arguments

Consider the following code:
```ocaml
# let id_print s = print_string (s ^ " "); s;;
val id_print : string -> string = <fun>

# let s = Printf.sprintf "%s %s %s " (id_print "monday") (id_print "tuesday")  (id_print "wednesday");;
wednesday tuesday monday val s : string = "monday tuesday wednesday "
```

The function `id_print` returns its input unchanged. However, it has a side effect: it first prints the string it receives as an argument.

In the second line, we apply `id_print` to the arguments `"monday"`, `"tuesday"`, `"wednesday"`, respectively and apply `Printf.sprintf "%s %s %s "` to them.

Since the order of evaluation for function arguments in OCaml is not explicitly defined, the order in which the `id_print` side effects take place is unreliable. In this example, the arguments are evaluated from right to left, but this could change on future compiler releases.

There are several means to ensure that computation takes place in a specific order.

You can use the use the sequence operator `;` to execute expressions in a particular order:
```ocaml
# print_endline "ha"; print_endline "ho";;
ha
hu
- : unit = ()
```

`let` expressions are executed in the order they appear in, so you can nest them to achieve a particular order of evaluation:
```ocaml
# let () = print_endline "ha" in print_endline "hu";;
ha
hu
- : unit = ()
```

## Conclusion

Mutable state as such is neither good or bad. For the cases where mutable state enables a significantly simpler implementation, OCaml provides fine tools to deal with mutable state. We looked at references, mutable record fields, arrays, byte sequences, as well as imperative control flow expressions like `for` and `while` loops. Finally, we discussed several examples of recommended and discouraged use of side effects and mutable state.

<!--
References

* https://www.lri.fr/~filliatr/hauteur/pres-hauteur.pdf
* https://medium.com/neat-tips-tricks/ocaml-continuation-explained-3b73839b679f
* https://discuss.ocaml.org/t/what-is-the-use-of-continuation-passing-style-cps/4491/7
* https://www.pathsensitive.com/2019/07/the-best-refactoring-youve-never-heard.html
* https://link.springer.com/chapter/10.1007/11783596_2

-->