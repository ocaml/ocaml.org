---
id: imperative
title: Imperative and Mutability
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


# Imperative and Mutability

## Introduction

This document has two main teaching goals:
1. Writing imperative code in OCaml
1. Combining and balancing imperative and functional code

In OCaml, you can write code in imperative style without compromising on type and memory safety. In the first part of this tutorial, imperative programming in OCaml is introduced.

Imperative and functional programming both have unique merits; OCaml allows combining them efficiently. See the second part of this tutorial for examples of recommended, handle-with-care or inadvisable patterns.

**Prerequisites**: This is an intermediate-level tutorial. You should have completed the [Basic Data Types](/docs/basic-data-types), [Values and Functions](/docs/values-and-functions), [Lists](/docs/lists) and [Modules](/docs/modules) tutorials

## Mutable Data

A name-value binding created using the `let … = …` construct is [immutable](https://en.wikipedia.org/wiki/Immutable_object), once added to the environment, it is impossible to replace the value or remove the name.

### References

However, there is a kind of value that can be updated. That is called a _reference_ in OCaml.
```ocaml
# let a = ref 0;;
val a : int ref = {contents = 0}

# a := 1;;
- : unit = ()

# !a;;
- : int = 1
```

Here is what happens above:
1. The value `{ contents = 0 }` is bound to the name `a`. This is a normal definition, like any other definition, it is immutable. However, the value `0` inside `contents` can be updated.
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
* It's impossible to create uninitialised references.
* No confusion between mutable content and the reference is possible: They have different syntax and type.

### Mutable Fields

#### References Are Single Fields Records

The value `{ contents = 0 }` of type `int ref` frome the previous section not only looks like a record: It is a record. Having a look at the way the `ref` type is defined is enlightening:
```ocaml
# #show ref;;
external ref : 'a -> 'a ref = "%makemutable"
type 'a ref = { mutable contents : 'a; }
```

Starting from the bottom, the `'a ref` type is a record with a single field `contents` which is marked with the `mutable` keyword. This means that the field can be updated.

The `external ref : 'a -> 'a ref = "%makemutable"` means the function `ref` is not written in OCaml, but that is an implementation detail we do not care about in this tutorial. If interested, check the [Calling C Libraries](/docs/calling-c-libraries) tutorial to learn how to use the foreign function interface.

#### Any Record Can Have Mutable Fields

Any field in a record can be tagged using the `mutable` keyword.
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

For instance here is how a bookshop could track its book inventory:
* Fields `title`, `author`, `volume`, `series` are constants
* Field `stock` is mutable because this value changes with each sale or when restocking

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

When the bookshop receives the delivery of 10 of these books, here is how the data update can be done:
```ocaml
# vol_7.stock <- vol_7.stock + 10;;
- : unit = ()

# vol_7;;
- : book =
{series = "Murderbot Diaries"; volume = 7; title = "System Collapse";
 author = "Martha Wells"; stock = 10 }
```

Mutable record field update is a side effect performed using the left arrow symbol `<-`. In the expression `vol_7.stock <- vol_7.stock + 7` the meaning of `vol_7.stock` depends on its context:
* In the left-hand side of `<-` it refers to the mutable field to be updated
* In the right-hand side of `<-`, it denotes the contents of the field

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

In this section, we compare two ways to implement a `get_char` function. It waits until a key is pressed and returns the character corresponding without echoing it. This function will also be used later on in this tutorial.

This is using two functions from the `Unix` module. Both are used to access attributes of the terminal associated with standard input:
* `tcgetattr stdin TCSAFLUSH` read and return them as a record (this is similar to `deref`)
* `tcsetattr stdin TCSAFLUSH` update them (this is similar to `assign`)

These attributes need to be tweaked in order to do the reading the way we want. The logic is the same in both implementations:
1. Read the terminal attributes
1. Tweak the terminal attributes
1. Wait until a key is pressed, read it as a character
1. Restore the initial terminal attributes
1. Return the read character

The actual read is done using the `input_char` function from the standard library.

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
In this implementation, the update of the `termio` fields takes place twice.
* Before `input_char`, both are set to `false`
* After `input_char`, initial values are restored

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

In this implementation, the record returned by the call to `tcgetattr` isn't updated. A copy is made using `{ termio with c_icanon = false; c_echo = false }`. That copy only differs from the read `termio` value on fields `c_icanon` and `c_echo`, that's the meaning of `termio with …`

That allows the second call to `tcsetattr` to restore terminal attributes to their initial state without explicitly reading them.

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

The update symbol `<-` used for fields is also used to update an array's cell content. The semantics of `a.(i)` work as field update:
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

In OCaml, a for loop is an expression of type `unit`.
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

For loops are convenient to iterate over arrays.
```ocaml
# let sum = ref 0 in
  for i = 0 to Array.length a - 1 do sum := !sum + a.(i) done;
  !sum;;
- : int = 42
```

**Note: Here is how to do the same thing using an iterator function:
```ocaml
# let sum = ref 0 in Array.iter (fun i -> sum := !sum + i) a; !sum;;
- : int = 42
```

The body of a for loop must be an expression of type `unit`.
```ocaml
# for i = Array.length a - 1 downto 0 do 0 done;;
Line 1, characters 39-40:
Warning 10 [non-unit-statement]: this expression should have type unit.
- : unit = ()
```

The `downto` keyword allows the counter to decrease during the loop.

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

This requires using a `get_char` function as defined in [Field Update _vs_ Record Copy](#field-update-vs-record-copy) section.

The following loop echoes characters typed on the keyboard, as long as they are different from `Escape`.
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

## Recommendations on Mixing Functional and Imperative Programming

Functional and imperative programming are often mixed. However, not all mix creates good results. Some patterns and anti-patterns are listed in this section.

### Good: Function-Encapsulated Mutability

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

Function `sum` is written in the imperative style, using mutable data structures. That's an encapsulated implementation choice. No mutability is exposed, That is just fine.

### Good: Application Wide State

Some applications maintain a state while they are running. Here is a couple of examples:
- A REPL, the state is the environment. In OCaml it is append-only, but some languages allow reset or removals.
- A server for a stateful protocol. Each session has a state, the global state is the conjunction of all the session states.
- A text editor. The state includes the commands (to allow undo), the settings, what is displayed and the file.
- Any cache.

The following is a toy line editor, using the `get_char` function [defined earlier](#field-update-vs-record-copy). It waits for characters on standard input and exits on end-of-file, carriage return or newline. Otherwise, if the character is printable, it prints it and records it in a mutable list used as a stack. If the character is the delete code, the stack is popped and the last printed character is erased.
```ocaml
# let record_char state c =
    (String.make 1 c, c :: state);;
val record_char : char list -> char -> char list = <fun>

# let remove_char state =
    ("\b \b", if state = [] then [] else List.tl state);;
val remove_char : 'a list -> 'a list = <fun>

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

This is not a production-grade code. However, it illustrates the following:
- State handling functions `record_char` and `remove_char` don't update the state or produce side effects, they only produce data
- I/O and state update side effects are confined to the `loop`` function
- The state is passed as a parameter to the `loop` function

This is the idea of a possible way to handle an application-wide state. As in the [Function-Encapsulated Mutability](#good-function-encapsulated-mutability) state aware code is contained in a narrow scope, the rest of the code is functional.

**Note**: Here, the state is copied, which is not memory efficient. In a memory-aware implementation, state update functions would produce “diffs” (data describing the difference between the old and updated versions of the state).

### Good: Memoization

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

The [memoization](https://en.wikipedia.org/wiki/Memoization) technique relies on the same idea: get the results from a table recording previously computed values.

However, instead of precomputing everything as in the example, memoization uses a cache. When calling the function, the input data is checked against it:
* If it's a hit, the stored result is returned
* If it's a miss, the result is computed, stored and returned

Management of the cache is yet another application of [function-encapsulated mutability](#good-function-encapsulated-mutability).

Refer to CS3110 or Real World OCaml for complete examples using caching:
1. https://cs3110.github.io/textbook/chapters/ds/memoization.html
1. https://dev.realworldocaml.org/imperative-programming.html

### Acceptable: Module Bound State

A module may expose or encapsulate a state in several different ways:
1. Good: Expose a type representing a state, with state creation or reset functions
1. Acceptable: Only expose state initialisation, this implies there only is a single state
1. Bad: No explicit initialisation function or no name referring state

The [`Hashtbl`](/api/Hashtbl.html) module provides an interface of the first kind. It has the type `Hashtbl.t` representing mutable data, it also exposes `create`, `clear` and `reset` functions. Its functorial interface makes functor instantiation and hash table creation distinct operations.

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

TODO: optional arguments

On the other hand, a module may define mutable data internally impacting its behaviour without exposing it in its interface. This is inadvisable.

### Bad: Mutable in Disguise

Consider this code:
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

As an anti-pattern, this is purposely broken. Let's assume the function `Array.truncate` has type `int -> 'a array -> 'a array` and behaves such that `Array.truncate 3 [5; 6; 7; 8; 9]` returns `[5; 6; 7]` and that array physically corresponds to the 3 first cells of the input array.

The type of `truncate` should be `('a -> bool) -> 'a array -> 'a array * 'a array` and it could be documented as:
> `partition p a` returns a pair of arrays `(b, c)` where `b` is an array containing all the elements of `a` that satisfy the predicate `p`, and `c` is an array containing the elements of `a` that do not satisfy `p`. The order of the elements from the input array is preserved.

**Don't do that**. It looks like an application of the [Function-Encapsulated mutability](#good-function-encapsulated-mutability). But it is not, the input array is modified. This function has a side effect that is either not intended or not documented, in the latter case, the function should be named differently.

### Bad: Stateful External Factor

GOTCHA: This is the dual of the previous anti-pattern. “Mutable in disguise” is a perspiration side-effect. “Stateful Influence” is the unintended or undocumented influence of a mutable state into a function (as an external factor).


### Bad: Hidden Side Effects
Consider this code:
```ocaml
# module Array = struct
    include Stdlib.Array
    let copy a =
      if Array.length a > 1 lsl 20 then Analytics.collect "Array.copy" a;
      copy a
    end;;
Error: Unbound value analytics_record
```

As an anti-pattern, this is purposely broken. A module called `Array` is defined, it shadows and includes the [`Stdlib.Array`](/api/Array.html) module. See the [Module Inclusion](docs/modules#module-inclusion) part of the [Modules](docs/modules) tutorial for details about this pattern.

However, the newly defined `Array` module contains a `copy` function which has a side effect. If the array to copy has a million cells or above, it will create a network connection and transmit data.

**Don't do that**. Side effects and mutability are hard enough alone. Don't add complexity to the intrinsic complexity of the matter by hiding relevant information from the developers or maintainers.

### Bad: Imperative by Default

By default, OCaml programs should be written in a mostly functional style, the imperative style shouldn't be the default. It is possible to use the imperative style without losing the benefits of type and memory safety, it doesn't make sense to only use it. Not using functional programming idioms at all would result in a contrived and obfuscated style.

Additionally, most modules provide an interface meant to be used in functional way. Some would require the development and maintenance of [wrapper libraries](https://en.wikipedia.org/wiki/Wrapper_library) to be used in an imperative setting. That would be wasteful and brittle.

### Bad: Side Effects in Arguments

Consider the following code:
```ocaml
# let id_print s = print_string (s ^ " "); s;;
val id_print : string -> string = <fun>

# let s = Printf.sprintf "%s %s %s " (id_print "monday") (id_print "tuesday")  (id_print "wednesday");;
wednesday tuesday monday val s : string = "monday tuesday wednesday "
```

Functionally `id_print` is an identity function on `string`, it returns its input unchanged. However, it has a side effect: it prints each string it receives. Wrapping the parameters passed to `Printf.sprintf` into calls to `id_print` makes the side effects happen.

The order in which the `id_ print` side effects take place is unreliable. Parameters are evaluated from right to left, but this is not part of the definition of the OCaml language, this way the compiler is implemented, but it could change.

There are several means to make sure computation takes place in a specified order.

Use the use the semicolon operator `;`
```ocaml
# print_endline "ha"; print_endline "ho";;
ha
hu
- : unit = ()
```

Use a `let` construction:
```ocaml
# let () = print_endline "ha" in print_endline "hu";;
ha
hu
- : unit = ()
```

## Conclusion

Handling mutable state isn't good or bad. In the cases where it is needed, OCaml provides fine tools to handle them. Many courses and books on programming and algorithmic are written in imperative style without stronger reasons than being the dominant style. Many techniques can be translated into functional style without loss in speed or increased memory consumption. Careful inspection of many efficient programming techniques or good practices shows in essence, they are functional, made working the imperative setting by hook or by crook. In OCaml, it is possible to express things in their true nature and it is preferable to do so.

## References

* https://www.lri.fr/~filliatr/hauteur/pres-hauteur.pdf
* https://medium.com/neat-tips-tricks/ocaml-continuation-explained-3b73839b679f
* https://discuss.ocaml.org/t/what-is-the-use-of-continuation-passing-style-cps/4491/7
* https://www.pathsensitive.com/2019/07/the-best-refactoring-youve-never-heard.html
* https://link.springer.com/chapter/10.1007/11783596_2
