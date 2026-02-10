---
id: mutability-imperative-control-flow
title: Mutability and Imperative Control Flow
description: >
  Write stateful programs in OCaml. Use for and while loops, if-then-else, mutable record fields, and references.
category: "Introduction"
prerequisite_tutorials:
  - "basic-data-types"
  - "values-and-functions"
  - "lists"
  - "modules"
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

Imperative and functional programming both have unique merits, and OCaml allows combining them efficiently. In the first part of this tutorial, we introduce mutable state and imperative control flow. See the second part for examples of recommended or discouraged use of these features.

## Immutable vs Mutable Data

When you use `let … = …` to bind a value to a name, this name-value binding is [immutable](https://en.wikipedia.org/wiki/Immutable_object), so it is impossible to _mutate_ (which is a fancy term for “change,” “update,” or “modify”) the value assigned to the name.

In the following sections, we introduce OCaml's language features for dealing with _mutable_ states.

## References

There is a special kind of value, called _reference_, whose contents can be updated:

```ocaml
# let d = ref 0;;
val d : int ref = {contents = 0}

# d := 1;;
- : unit = ()

# !d;;
- : int = 1
```

Here is what happens in this example:
1. The value `{ contents = 0 }` is bound to the name `d`. This is a normal definition. Like any other definition, it is immutable. However, the value `0` in the `contents` field of `d` is _mutable_, so it can be updated.
3. The _assignment_ operator `:=` is used to update the mutable value inside `d` from `0` to `1`.
4. The _dereference_ operator `!` reads the contents of the mutable value inside `d`.

The `ref` identifier above refers to two different things:
* The function `ref : 'a -> 'a ref` that creates a reference
* The type of mutable references: `'a ref`

**Assignment Operator**

```ocaml
# ( := );;
- : 'a ref -> 'a -> unit = <fun>
```

The assignment operator `:=` is just a function. It takes
1. the reference to be updated, and
1. the value that replaces the previous contents.

The update takes place as a [side effect](https://en.wikipedia.org/wiki/Side_effect_(computer_science)), and the value `()` is returned.

**Dereference Operator**

```ocaml
# ( ! );;
- : 'a ref -> 'a = <fun>
```

The dereference operator is a function that takes a reference and returns its contents.

Refer to the [Operators](/docs/operators) documentation for more information on how unary and binary operators work in OCaml.

When working with mutable data in OCaml,
* it is impossible to create uninitialised references, and
* the mutable content and the reference have different syntax and type: no confusion between them is possible.

## Mutable Record Fields

Any field in a record can be tagged using the `mutable` keyword. Such a field can be updated.

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

For instance, here is how a bookshop could track its inventory:
* Fields `title`, `author`, `volume`, `series` are constants.
* Field `stock` is mutable because this value changes with each sale or restocking.

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

Mutable record fields are updated using the left arrow symbol `<-`. In the expression `vol_7.stock <- vol_7.stock + 10`, the meaning of `vol_7.stock` depends on its context:
* In the left-hand side of `<-`, it refers to the mutable field to be updated.
* In the right-hand side of `<-`, it denotes the contents of the mutable field.

In contrast to references, there is no special syntax to dereference a mutable record field.

**Remark**: the left arrow symbol `<-` for mutating mutable record field values is not an operator function, like the assignment operator `( := )` is for `refs`. It is rather a _construct_ of the language, it has no type. 

### Remark: References Are Single Field Records

In OCaml, references are records with a single mutable field:

```ocaml
# #show_type ref;;
type 'a ref = { mutable contents : 'a; }
```

The type `'a ref` is a record with a single field `contents`, which is marked with the `mutable` keyword.

Since references are single field records, we can define functions `create`, `assign`, and `deref` using the mutable record field update syntax:

```ocaml
# let create v = { contents = v };;
val create : 'a -> 'a ref = <fun>

# let assign f v = f.contents <- v;;
val assign : 'a ref -> 'a -> unit = <fun>

# let deref f = f.contents;;
val deref : 'a ref -> 'a = <fun>

# let f = create 0;;
val f : int ref = {contents = 0}

# deref f;;
- : int = 0

# assign f 2;;
- : unit = ()

# deref f;;
- : int = 2
```

The functions:
* `create` does the same as the `ref` function provided by the standard library.
* `assign` does the same as the `( := )` operator.
* `deref` does the same as the `( ! )` operator.

## Arrays

In OCaml, an array is a mutable, fixed-size data structure that can store a sequence of elements of the same type. Arrays are indexed by integers, provide constant-time access, and allow the update of elements.

```ocaml
# let g = [| 2; 3; 4; 5; 6; 7; 8 |];;
val g : int array = [|2; 3; 4; 5; 6; 7; 8|]

# g.(0);;
- : int = 2

# g.(0) <- 9;;
- : unit = ()

# g.(0);;
- : int = 9
```

The left arrow symbol `<-` is used to update an array element at a given index. The array index access syntax `g.(i)`, where `g` is a value of type `array` and `i` is an integer, stands for either
* the array location to update (when on the left-hand side of `<-`), or
* the cell's content (when on the right-hand side of `<-`).

For a more detailed discussion on arrays, see the [Arrays](/docs/arrays) tutorial.

## Byte Sequences

The `bytes` type in OCaml represents a fixed-length, mutable byte sequence. In a value of type `bytes`, each element has 8 bits. Since characters in OCaml are represented using 8 bits, `bytes` values are mutable `char` sequences. Like arrays, byte sequences support indexed access.

```ocaml
# let h = Bytes.of_string "abcdefghijklmnopqrstuvwxyz";;
val h : bytes = Bytes.of_string "abcdefghijklmnopqrstuvwxyz"

# Bytes.get h 10;;
- : char = 'k'

# Bytes.set h 10 '_';;
- : unit = ()

# h;;
- : bytes = Bytes.of_string "abcdefghij_lmnopqrstuvwxyz"
```

Byte sequences can be created from `string` values using the function `Bytes.of_string`. Individual elements in the sequence can be updated or read by their index using `Bytes.set` and `Bytes.get`.

You can think of byte sequences as either:
* updatable strings that can't be printed, or
* `char` arrays without syntactic sugar for indexed read and update.

**Note**: the `bytes` type uses a much more compact memory representation than `char array`. As of writing this tutorial, there is an 8-factor between `bytes` and `char array`. The former should always be preferred, except when `array` is required by polymorphic functions handling arrays.

<!-- FIXME: link to a dedicated Byte Sequences tutorial -->

## Example: `get_char` Function

<!-- FIXME: needs more motivation -->

In this section, we compare two ways to implement a `get_char` function. The function waits until a key is pressed and returns the corresponding character without echoing it. This function will also be used later on in this tutorial.

We use two functions from the `Unix` module to read and update attributes of the terminal associated with standard input:
* `tcgetattr stdin` returns the terminal attributes as a record (similar to `deref`)
* `tcsetattr stdin TCSAFLUSH` updates the terminal attributes (similar to `assign`)

These attributes need to be set correctly (i.e., turn off echoing and disable canonical mode) in order to read it the way we want. The logic is the same in both implementations:
1. Read and record the terminal attributes
1. Set the terminal attributes
1. Wait until a key is pressed, read it as a character
1. Restore the initial terminal attributes
1. Return the read character

We read characters from standard input using the `input_char` function from the OCaml standard library.

Below is the first implementation. If you're working in macOS, run `#require "unix";;` first to avoid an `Unbound module error`.

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
* before `input_char`, setting both `c_icanon` and `c_echo` to `false`, and
* after `input_char`, restoring the initial values.

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

In this implementation, the record returned by the call to `tcgetattr` is not modified. A copy is made using `{ termio with c_icanon = false; c_echo = false }`. This copy only differs from the `termio` value on fields `c_icanon` and `c_echo`.

In the second call to `tcsetattr`, we restore the terminal attributes to their initial state.

## Imperative Control Flow

OCaml allows you to evaluate expressions in sequence and provides `for` and `while` loops to execute a block of code repeatedly.

### Evaluating Expressions in Sequence

**`let … in`**

```ocaml
# let () = print_string "This is" in print_endline " really Disco!";;
This is really Disco!
- : unit = ()
```

Using the `let … in` construct means two things:
* Names may be bound. In the example, no name is bound since `()` is used.
* Side effects take place in sequence. The bound expression (`print_string "This is"`) is evaluated first, and the referring expression (`print_endline " really Disco!"`) is evaluated second.

**Semicolon**

The single semicolon `;` operator is known as the _sequence_ operator. It allows you to evaluate multiple expressions in order, with the last expression's value as the entire sequence's value.

The values of any previous expressions are discarded. Thus, it makes sense to use expressions with side effects, except for the last expression of the sequence, which could be free of side effects.

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

**Remark** Even though it's called the sequence operator, the semicolon is not truly an operator because it is not a function of type `unit -> 'a -> 'a`. It is rather a _construct_ of the language. It allows adding a semicolon at the end of a sequence expression.

```ocaml
# (); 42; ;;
- : int = 42
```

Here, the semicolon after 42 is ignored.

**`begin … end` expressions**

In OCaml, `begin … end` and parentheses are the same.

Imagine we want to write a function that:
1. Has an `int` reference parameter containing value _n_
2. Updates the reference's contents to _2 &times; (n + 1)_

This is arguably convoluted and does not work:

```ocaml
# let f r = r := incr r; 2 * !r;;
Error: This expression has type unit but an expression was expected of type int
```

But here is how it can be made to work:

```ocaml
# let f r = r := begin incr r; 2 * !r end;;
val f : int ref -> unit = <fun>
```

The error came from the assign operator `:=`, which associates stronger than a semicolon `;`. Here is what we want to do, in order:
1. Increment `r`
2. Compute `2 * !r`
3. Assign into `r`

Remember the value of a semicolon-separated sequence is the value of its last expression. Grouping the first two steps with `begin … end` fixes the error.

**Fun fact**: `begin … end` and parentheses are literally the same:

```ocaml
# begin end;;
- : unit = ()
```

### `if … then … else …` and Side Effects

In OCaml, `if … then … else …` is an expression.

```ocaml
# 6 * if "foo" = "bar" then 5 else 5 + 2;;
- : int = 42
```

A conditional expression return type can be `unit` if both branches are too.

```ocaml
# if 0 = 1 then print_endline "foo" else print_endline "bar";;
bar
- : unit = ()
```

The above can also be expressed this way:

```ocaml
# print_endline (if 0 = 1 then "foo" else "bar");;
bar
- : unit = ()
```

The `unit` value `()` can serve as a [no-op](https://en.wikipedia.org/wiki/Noop) when only one branch has something to execute.

```ocaml
# if 0 = 1 then print_endline "foo" else ();;
- : unit = ()
```

But OCaml also allows writing `if … then … ` expressions without an `else` branch, which is the same as the above.

```ocaml
# if 0 = 1 then print_endline "foo";;
- : unit = ()
```

In parsing, conditional expressions groups more than sequencing:

```ocaml
# if true then print_endline "A" else print_endline "B"; print_endline "C";;
A
C
- : unit = ()
```

Here `; print_endline "C"` is executed after the whole conditional expression, not after `print_endline "B"`.

If you want to have two prints in a conditional expression branch, use `begin … end`.

```ocaml
# if true then
    print_endline "A"
  else begin
    print_endline "B";
    print_endline "C"
  end;;
A
- : unit = ()
```

Here is an error you might encounter:

```ocaml
# if true then
    print_endline "A";
    print_endline "C"
  else
    print_endline "B";;
Error: Syntax error
```

Failing to group in the first branch results in a syntax error. What's before the semicolon is parsed as an `if … then … ` without an `else` expression. What's after the semicolon appears as a [dangling](https://en.wikipedia.org/wiki/Dangling_else) `else`.

### For Loop

A `for` loop is an expression of type `unit`. Here, `for`, `to`, `do`, and `done` are keywords.

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

Here:
 - `i` is the loop counter; it is incremented after every iteration.
 - `0` is the first value of `i`.
 - `5` is the last value of `i`.
 - The expression `Printf.printf "%i\n" i` is the body of the loop.

The iteration evaluates the body expression (which may contain `i`) until `i` reaches `5`.

The body of a `for` loop must be an expression of type `unit`:

```ocaml
# let j = [| 2; 3; 4; 5; 6; 7; 8 |];;
val j : int array = [|2; 3; 4; 5; 6; 7; 8|]

# for i = Array.length j - 1 downto 0 do 0 done;;
Line 1, characters 39-40:
Warning 10 [non-unit-statement]: this expression should have type unit.
- : unit = ()
```

When you use the `downto` keyword (instead of the `to` keyword), the counter decreases on every iteration of the loop.

`for` loops are convenient to iterate over and modify arrays:

```ocaml
# let sum = ref 0 in
  for i = 0 to Array.length j - 1 do sum := !sum + j.(i) done;
  !sum;;
- : int = 35
```

**Note:** Here is how to do the same thing using an iterator function:

```ocaml
# let sum = ref 0 in Array.iter (fun i -> sum := !sum + i) j; !sum;;
- : int = 35
```

### While Loop

A `while` loop is an expression of type `unit`. Here, `while`, `do`, and `done` are keywords.

```ocaml
# let i = ref 0 in
  while !i <= 5 do
    Printf.printf "%i\n" !i;
    i := !i + 1;
  done;;
0
1
2
3
4
5
- : unit = ()
```

Here:
- `!i <= 5` is the condition.
- The expression ` Printf.printf "%i\n" !i; i := !i + 1;` is the body of the loop.

The iteration executes the body expression as long as the condition remains true.

In this example, the `while` loop continues to execute as long as the value held by the reference `i` is less than `5`.

### Breaking Loops Using Exceptions

Throwing the `Exit` exception is a recommended way to immediately exit from a loop.

The following example uses the `get_char` function we defined earlier (in the section [Example: `get_char` Function](#example-get_char-function)).

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

This `while` loop echoes characters typed on the keyboard. When the ASCII `Escape` character is read, the `Exit` exception is thrown, which terminates the iteration and displays the REPL reply: `- : unit = ()`.

### References Inside Closures

In the following example, the function `create_counter` returns a closure that “hides” a mutable reference `counter`. This closure captures the environment where `counter` is defined and can modify `counter` each time it's invoked. The `counter` reference is “hidden” within the closure, encapsulating its state.

```ocaml
# let create_counter () =
  let counter = ref (-1) in
  fun () -> incr counter; !counter;;
val create_counter : unit -> unit -> int = <fun>
```

First, we define a function named `create_counter` that takes no arguments. Inside `create_counter`, a reference `counter` is initialised with the value -1. This reference will hold the state of the counter. Next, we define a closure that takes no arguments `(fun () ->)`. The closure increments `counter` using `incr counter`, then returns the current value of `counter` using `!counter`.

```ocaml
# let c1 = create_counter ();;
val c1 : unit -> int = <fun>

# let c2 = create_counter ();;
val c2 : unit -> int = <fun>
```

Now, using partial application, we create two closures `c1` and `c2` that encapsulate a counter. Calling `c1 ()` will increment the counter associated with `c1` and return its current value. Similarly, calling `c2 ()` will update its own independent counter.

```ocaml
# c1 ();;
- : int = 0

# c1 ();;
- : int = 1

# c2 ();;
- : int = 0

# c1 ();;
- : int = 2
```

Calling `c1 ()` increments the counter associated with `c1` and returns its current value. Since this is the first call, the counter starts at 0. Another call to `c1 ()` increments the counter again, so it returns 1.

Calling `c2 ()` increments the counter associated with `c2`. Since `c2` has its own independent counter, it starts at 0. Another call to `c1 ()` increments its counter, resulting in 2.

## Recommendations for Mutable State and Side Effects

Functional and imperative programming styles are often used together. However, not all ways of combining them give good results. We show some patterns and anti-patterns relating to mutable states and side effects in this section.

### Good: Function-Encapsulated Mutability

Here is a function that computes the sum of an array of integers.

```ocaml
# let sum m =
    let result = ref 0 in
    for i = 0 to Array.length m - 1 do
      result := !result + m.(i)
    done;
    !result;;
val sum : int array -> int = <fun>
```

The function `sum` is written in an imperative style, using mutable data structures and a `for` loop. However, no mutability is exposed. It is a fully encapsulated implementation choice. This function is safe to use; no problems are to be expected.

### Good: Application-Wide State

Some applications maintain some state while they are running. Here are a couple of examples:
- A Read-Eval-Print-Loop (REPL). The state is the environment where values are bound to names. In OCaml, the environment is append-only, but some other languages allow replacing or removing name-value bindings.
- A server for a stateful protocol. Each session has a state. The global state consists of all the session states.
- A text editor. The state includes the most recent commands (to allow undo), the state of any open files, the settings, and the state of the UI.
- A cache.

The following is a toy line editor, using the `get_char` function [defined earlier](#example-getchar-function). It waits for characters on standard input and exits on end-of-file, carriage return, or newline. Otherwise, if the character is printable, it prints it and records it in a mutable list used as a stack. If the character is the delete code, the stack is popped and the last printed character is erased.

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

After this last command, you can type and edit any single line of text. Then, press return to get back to the REPL.

This example illustrates the following:
- The functions `record_char` and `remove_char` neither update the state nor produce side effects. Instead, they each return a pair of values consisting of a string to print and the next state, `new_state`.
- I/O and state-update side effects happen inside the `loop` function.
- The state is passed as argument to the `loop` function.

This is a possible way to handle an application-wide state. As in the [Function-Encapsulated Mutability](#good-function-encapsulated-mutability) example, state-aware code is contained in a narrow scope; the rest of the code is purely functional.

**Note**: Here, the state is copied, which is not memory efficient. In a memory-aware implementation, state-update functions would produce a “diff” (data describing the difference between the state's old and updated version).

### Good: Precomputing Values

Let's imagine you store angles as fractions of the circle in 8-bit unsigned integers, storing them as `char` values. In this system, 64 is 90 degrees, 128 is 180 degrees, 192 is 270 degrees, 256 is full circle, and so on. If you need to compute cosine on those values, an implementation might look like this:

```ocaml
# let char_cos c =
    c |> int_of_char |> float_of_int |> ( *. ) (Float.pi /. 128.0) |> cos;;
val char_cos : char -> float = <fun>
```

However, it is possible to make a faster implementation by precomputing all the possible values in advance. There are only 256 of them, which you'll see listed after the first result below:

```ocaml
# let char_cos_tab = Array.init 256 (fun i -> i |> char_of_int |> char_cos);;
val char_cos_tab : float array =

# let char_cos c = char_cos_tab.(int_of_char c);;
val char_cos : char -> float = <fun>
```

### Good: Memoization

The [memoization](https://en.wikipedia.org/wiki/Memoization) technique relies on the same idea as the previous section's example: lookup results from a table of previously computed values.

However, instead of precomputing everything, memoization uses a cache that is populated when calling the function. Either, the provided arguments
* are found in the cache (it is a hit) and the stored result is returned, or they
* are not found in the cache (it's a miss), and the result is computed, stored in the cache, and returned.

You can find a concrete example of memoization and an in-depth explanation in the chapter on [Memoization](https://ocaml.org/docs/memoization) of "OCaml Programming: Correct + Efficient + Beautiful."

### Good: Functional by Default

By default, OCaml programs should be written in a mostly functional style. This constitutes trying to avoid side effects where possible and relying on immutable data instead of mutable state.

It is possible to use an imperative programming style without losing the benefits of type and memory safety. However, it doesn't usually make sense to only program in an imperative style. Not using functional programming idioms at all would result in non-idiomatic OCaml code.

Most existing modules provide an interface meant to be used in a functional way. Some require the development and maintenance of [wrapper libraries](https://en.wikipedia.org/wiki/Wrapper_library) to be used in an imperative setting and such use results in inefficient code.

###  It Depends: Module State

A module may expose or encapsulate a state in several different ways:
1. Good: expose a type representing a state, with state creation or reset functions
1. It depends: only expose state initialisation, which implies there is only a single state
1. Bad: mutable state with no explicit initialisation function or no name referring to the mutable state

For example, the [`Hashtbl`](/manual/api/Hashtbl.html) module provides an interface of the first kind. It has the type `Hashtbl.t` representing mutable data. It also exposes `create`, `clear`, and `reset` functions. The `clear` and `reset` functions return `unit`. This strongly signals the reader that they perform the side-effect of updating the mutable data.

```ocaml
# #show Hashtbl.t;;
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

**Note**: The following example code will purposely not run in your REPL; the function `Array.truncate` is not defined. It is provided as an example to contemplate and avoid.

Here's an example of bad code:

```ocaml
# let partition p k =
    let m = Array.copy k in
    let k_len = ref 0 in
    let m_len = ref 0 in
    for i = 0 to Array.length k - 1 do
      if p k.(i) then begin
        k.(!k_len) <- k.(i);
        incr k_len
      end else begin
        m.(!m_len) <- k.(i);
        incr m_len
      end
    done;
    (Array.truncate k_len k, Array.truncate m_len m);;
Error: Unbound value Array.truncate
```


To understand why this is bad code, assume that the function `Array.truncate` has type `int -> 'a array -> 'a array`. It behaves such that `Array.truncate 3 [5; 6; 7; 8; 9]` returns `[5; 6; 7]`, and the returned array physically corresponds to the 3 first cells of the input array.

The type of `partition` would be `('a -> bool) -> 'a array -> 'a array * 'a array`, and it could be documented as:
> `partition p k` returns a pair of arrays `(m, n)` where `m` is an array containing all the elements of `k` that satisfy the predicate `p`, and `n` is an array containing the elements of `k` that do not satisfy `p`. The order of the elements from the input array is preserved.

On first glance, this looks like an application of [Function-Encapsulated Mutability](#good-function-encapsulated-mutability). However, it is not. The input array is modified. This function has a side effect that is either
* not intended, or
* not documented.

In the latter case, the function should be named differently (e.g., `partition_in_place` or `partition_mut`), and the effect on the input array should be documented.

<!-- TODO:

### Bad: Stateful External Factor

GOTCHA: This is the dual of the previous anti-pattern. “Mutable in disguise” is an unintended or undocumented side-effect performed by a function. “Stateful Influence” is the unintended or undocumented influence of some mutable state on the result of a function (as an external factor).

-->

### Bad: Undocumented Side Effects

Consider this code:

**Note**: The following example will not run in your REPL; there is no module `Analytics` defined. It is provided as an example to contemplate. [Analytics](https://en.wikipedia.org/wiki/Web_analytics) are remote monitoring libraries.

```ocaml
# module Array = struct
    include Stdlib.Array
    let copy a =
      if Array.length a > 1000000 then Analytics.collect "Array.copy" a;
      copy a
    end;;
Error: Unbound module Analytics
```

A module called `Array` is defined; it shadows and includes the [`Stdlib.Array`](/manual/api/Array.html) module. See the [Module Inclusion](docs/modules#module-inclusion) part of the [Modules](docs/modules) tutorial for details about this pattern.

To understand why this code is bad, figure out that `Analytics.collect` is a function that makes a network connection to transmit data to a remote server.

Now, the newly defined `Array` module contains a `copy` function that has a potentially unexpected side effect, but only if the array to copy has a million cells or above.

If you're writing functions with non-obvious side effects, don't shadow existing definitions. Instead, give the function a descriptive name (for instance, `Array.copy_with_analytics`) and document the fact that there's a side-effect that the caller may not be aware of.

### Bad: Side Effects Depending on Order of Evaluation

Consider the following code:

```ocaml
# let id_print s = print_string (s ^ " "); s;;
val id_print : string -> string = <fun>

# let s =
    Printf.sprintf "%s %s %s"
      (id_print "Monday")
      (id_print "Tuesday")
      (id_print "Wednesday");;
Wednesday Tuesday Monday val s : string = "Monday Tuesday Wednesday "
```

The function `id_print` returns its input unchanged. However, it has a side effect: it first prints the string it receives as an argument.

In the second line, we apply `id_print` to the arguments `"Monday"`, `"Tuesday"`, and `"Wednesday"`. Then `Printf.sprintf "%s %s %s"` is applied to the results.

Since the evaluation order for function arguments in OCaml is not explicitly defined, the order in which the `id_print` side effects take place is unreliable. In this example, the arguments are evaluated from right to left, but this could change in future compiler releases.

This issue also arises when applying arguments to variant constructors, building tuple values, or initialising record fields. Here, it is illustrated on a tuple value:

```ocaml
# let r = ref 0 in ((incr r; !r), (decr r; !r));;
- : int * int = (0, -1)
```

The value of this expression depends on the order of subexpression evaluation. Since this order is not specified, there is no reliable way to know what this value is. At the time of writing this tutorial, the evaluation produced `(0, -1)`, but if you see something else, it is not a bug. Such an unreliable value must be avoided.

To ensure that evaluation takes place in a specific order, use the means to put expressions in sequences using either `let … in` expressions or the semi-colon sequence operator (`;`). Check the [Evaluating Expressions in Sequence](#evaluating-expressions-in-sequence) section.

<!--
You can use the sequence operator `;` to execute expressions in a particular order:

```ocaml
# print_endline "ha"; print_endline "ho";;
ha
ho
- : unit = ()
```

`let` expressions are executed in the order they appear, so you can nest them to achieve a particular order of evaluation:

```ocaml
# let () = print_endline "ha" in print_endline "hu";;
ha
hu
- : unit = ()
```
-->
## Conclusion

A mutable state is neither good nor bad. For the cases where a mutable state enables a significantly simpler implementation, OCaml provides fine tools to deal with it. We looked at references, mutable record fields, arrays, byte sequences, and imperative control flow expressions like `for` and `while` loops. Finally, we discussed several examples of recommended and discouraged use of side effects and mutable states.
