---
id: first-hour
title: A First Hour with OCaml
description: >
  Discover the OCaml programming language in this longer tutorial that takes you
  from absolute beginner to someone who is able to write programs in OCaml.
category: "getting-started"
date: 2021-08-06T17:11:00-00:00
---

# A First Hour with OCaml

You may follow along with this tutorial with just a basic OCaml installation,
as described in [Up and Running](/docs/up-and-running).

Alternatively, you may follow almost all of it by running OCaml in your browser
using the [OCaml Playground](https://ocaml.org/play), with no installation required.

On macOS/iOS/iPadOS, you can download this [all-in-one package on the App Store](https://apps.apple.com/app/ocaml-learn-code/id1547506826). It contains an editor side-by-side with an interactive toplevel. Plus, it's free and [open source](https://github.com/GroupeMINASTE/OCaml-iOS)!

## Running OCaml Programs

To try small OCaml expressions, use an interactive toplevel, or REPL
(Read-Eval-Print Loop). The `ocaml` command provides a basic toplevel
(install `rlwrap` through your system package manager and run `rlwrap ocaml` instead to get history navigation).

The alternative REPL [UTop](https://github.com/ocaml-community/utop) may be installed
through [opam](https://opam.ocaml.org/doc/Install.html) or your system package manager. It has
the same basic interface but is much more convenient to use (history
navigation, auto-completion, etc.).

Use `;;` to indicate that you've finished entering each expression and prompt
OCaml to evaluate it. We run OCaml and evaluate a simple expression:

```console
        OCaml version 4.14.0

# 50 * 50;;
- : int = 2500
```

This is how it looks using `utop`:

```console
───────┬─────────────────────────────────────────────────────────────┬────
       │ Welcome to utop version 2.7.0 (using OCaml version 4.14.0)! │
       └─────────────────────────────────────────────────────────────┘

Type #utop_help for help about using `utop`.

─( 10:12:16 )─< command 0 >───────────────────────────────────────────────
utop # 50 * 50;;
- : int = 2500
```

The in-browser [OCaml Playground](https://ocaml.org/play) has a similar interface.

The examples in this tutorial can be typed in by hand or copied into `ocaml`,
`utop`, or the OCaml Playground with copy and paste. Alternatively, we may type into a file
and load its contents directly with the `#use` directive:

```console
$ ocaml
        OCaml version 4.14.0

# #use "program.ml"
```

Note that `#use` is not part of the OCaml language proper; it's an instruction
to the OCaml toplevel only.

## Expressions

Our phrase `50 * 50` was an expression that evaluated to `2500`. OCaml told
us that the type was `int`, an integer. Every expression in OCaml has a type.
To avoid repetition, we can give a name to our number:

```ocaml
# let x = 50;;
val x : int = 50
# x * x;;
- : int = 2500
```

Note that this isn't a variable as in languages like C and Python. Its value
cannot be changed. 

We can write also write it all on one line using `let` ... `in` ...:

```ocaml
# let x = 50 in x * x;;
- : int = 2500
```

Of course, we can have multiple names:

```ocaml
# let a = 1 in
  let b = 2 in
    a + b;;
- : int = 3
```

Note that this is still just one expression. We can define a function to do the
job for any number:

```ocaml
# let square x = x * x;;
val square : int -> int = <fun>
# square 50;;
- : int = 2500
```

This says that `square` is a function with one argument, namely `x`, and that
the result of the function is the result of evaluating the expression `x * x`
with the given value associated with `x`. Here is another function, this time
using the comparison operator `=` to test for evenness:

```ocaml
# let square_is_even x =
    square x mod 2 = 0;;
val square_is_even : int -> bool = <fun>
# square_is_even 50;;
- : bool = true
# square_is_even 3;;
- : bool = false
```

Notice the type OCaml infers for the function.

A function may take multiple
arguments. Unlike imperative languages, they're written without parentheses
and commas. We shall explain why later.

```ocaml
# let ordered a b c =
    a <= b && b <= c;;
val ordered : 'a -> 'a -> 'a -> bool = <fun>
# ordered 1 1 2;;
- : bool = true
```

We can work with floating-point numbers too, but we must write `+.`, for
example, instead of just `+`:

```ocaml
# let average a b =
    (a +. b) /. 2.0;;
val average : float -> float -> float = <fun>
```

This is rather unusual. In other languages (such as C) integers get promoted to
floating point values in certain circumstances. For example, if you write `1 + 2.5` then the first argument (which is an integer) is promoted to a floating
point number, making the result a floating point number, too.

OCaml never does implicit casts like this. In OCaml, `1 + 2.5` is a type error.
The `+` operator in OCaml requires two integers as arguments, and here we
give it an integer and a floating point number, so it reports this error:

```ocaml
# 1 + 2.5;;
Line 1, characters 5-8:
Error: This expression has type float but an expression was expected of type
         int
```

OCaml doesn't promote integers to floating point numbers automatically, so this
is also an error:

```ocaml
# 1 +. 2.5;;
Line 1, characters 1-2:
Error: This expression has type int but an expression was expected of type
         float
  Hint: Did you mean `1.'?
```

What if you actually want to add an integer and a floating point number
together? (Say they are stored as `i` and `f`). In OCaml you need to
explicitly cast:

<!-- $MDX skip -->
```ocaml
float_of_int i +. f
```

The `float_of_int` function takes an `int` and returns a `float`.

You might think that these explicit casts are ugly, time-consuming even, but
there are several arguments in their favour. Firstly, OCaml needs this explicit
casting to be able to work out types automatically, which is a wonderful
time-saving feature. Secondly, if you've spent time debugging C programs, you'll
know that (a) implicit casts cause errors which are hard to find, and (b) much
of the time you're sitting there trying to work out where the implicit casts
happen. Making the casts explicit helps you in debugging. Thirdly, some casts
are actually expensive operations. We do ourselves no favours by hiding them.

## Recursive Functions

A recursive function is one which uses itself in its own definition. An OCaml
function isn't recursive unless you explicitly say so by using `let rec`
instead of just `let`. Here's an example of a recursive function:

```ocaml
# let rec range a b =
    if a > b then []
    else a :: range (a + 1) b;;
val range : int -> int -> int list = <fun>
# let digits = range 0 9;;
val digits : int list = [0; 1; 2; 3; 4; 5; 6; 7; 8; 9]
```

We have used OCaml's `if` ... `then` ... `else` ... construct to test a
condition and choose a path of evaluation. Notice that, like everything else in
OCaml, it's an expression, not a statement. The result of evaluating the whole
expression is either the result of evaluating the `then` part or the `else`
part.

The only difference between `let` and `let rec` is in the scoping of the
function name. If the above function had been defined with just `let`, then the
call to `range` would have tried to look for an existing (previously defined)
function called `range`, not the currently-being-defined function.

## Types

The basic types in OCaml are:

```text
OCaml type  Range

int         63-bit signed int on 64-bit processors, or 31-bit signed int on
            32-bit processors
float       IEEE double-precision floating point, equivalent to C's double
bool        A boolean, written either 'true' or 'false'
char        An 8-bit character
string      A string (sequence of 8 bit chars)
```

OCaml provides a `char` type, which is used for simple 8-bit characters, written
`'x'` for example. There are [comprehensive Unicode
libraries](https://github.com/yoriyuki/Camomile) that provide more extensive
functionality for text management.

Strings are not just lists of characters. They have their own, more
efficient internal representation. Strings are immutable.

When we type our expressions into the OCaml toplevel, OCaml prints the type:

```ocaml
# 1 + 2;;
- : int = 3
# 1.0 +. 2.0;;
- : float = 3.
# false;;
- : bool = false
# 'c';;
- : char = 'c'
# "Help me!";;
- : string = "Help me!"
```

Each expression has one and only one type.

OCaml works out types automatically so you will rarely need to explicitly write
down the function type. However, OCaml often prints out what it infers
are the function types, so you need to know the syntax. For a function
`f` that takes arguments `arg1`, `arg2`, ... `argn` and returns type
`rettype`, the compiler will print:

<!-- $MDX skip -->
```ocaml
f : arg1 -> arg2 -> ... -> argn -> rettype
```

The arrow syntax looks strange now, but later you'll see why it was chosen. Our
function `average` which takes two floats and returns a float has type:

<!-- $MDX skip -->
```ocaml
average : float -> float -> float
```

The OCaml standard `int_of_char` casting function:

<!-- $MDX skip -->
```ocaml
int_of_char : char -> int
```

Now look at some of the properties that distinguishes OCaml from other
languages:

- OCaml is a strongly statically-typed language. This means each expression has
  a only one type, and it's determined before the program is run.

- OCaml uses type inference to work out (infer) the types, so you don't have
  to. If you use the OCaml toplevel, then OCaml will tell you its inferred
  type for your function.

- OCaml doesn't do any implicit conversion of types. If you want a floating
  point number, you have to write `2.0` because `2` is an integer. OCaml does
  no automatic conversion between int and floats, or any other type. As a
  side effect of type inference in OCaml, functions (including operators) can't
  have overloaded definitions.

## Pattern Matching

Instead of using one or more `if` ... `then` ... `else` ... constructs to make
choices in OCaml programs, we can use the `match` keyword to match on multiple
possible values. Consider the factorial function:

```ocaml
# let rec factorial n =
    if n <= 1 then 1 else n * factorial (n - 1);;
val factorial : int -> int = <fun>
```

We can write it using pattern matching instead:

```ocaml
# let rec factorial n =
    match n with
    | 0 | 1 -> 1
    | x -> x * factorial (x - 1);;
val factorial : int -> int = <fun>
```

Equally, we could use the pattern `_` which matches anything, and write:

```ocaml
# let rec factorial n =
    match n with
    | 0 | 1 -> 1
    | _ -> n * factorial (n - 1);;
val factorial : int -> int = <fun>
```

In fact, we may simplify further with the `function` keyword, which introduces
pattern-matching directly:

```ocaml
# let rec factorial = function
    | 0 | 1 -> 1
    | n -> n * factorial (n - 1);;
val factorial : int -> int = <fun>
```

We will use pattern matching more extensively as we introduce more complicated
data structures.

## Lists

Lists are a common compound data type in OCaml. They are ordered collections of
elements of like type:

```ocaml
# [];;
- : 'a list = []
# [1; 2; 3];;
- : int list = [1; 2; 3]
# [false; false; true];;
- : bool list = [false; false; true]
# [[1; 2]; [3; 4]; [5; 6]];;
- : int list list = [[1; 2]; [3; 4]; [5; 6]]
```

Each list can have a head (its first element) and a tail (the list of the rest
of its elements). There are two built-in operators on lists. The `::`, or cons
operator, adds one element to the front of a list. The `@`, or append operator,
combines two lists:

```ocaml
# 1 :: [2; 3];;
- : int list = [1; 2; 3]
# [1] @ [2; 3];;
- : int list = [1; 2; 3]
```

We can write functions which operate over lists by pattern matching:

```ocaml
# let rec total l =
    match l with
    | [] -> 0
    | h :: t -> h + total t;;
val total : int list -> int = <fun>
# total [1; 3; 5; 3; 1];;
- : int = 13
```

You can see how the pattern `h :: t` is used to deconstruct the list, naming
its head and tail. If we omit a case, OCaml will notice and warn us:

```ocaml
# let rec total_wrong l =
    match l with
    | h :: t -> h + total_wrong t;;
Lines 2-3, characters 5-34:
Warning 8 [partial-match]: this pattern-matching is not exhaustive.
Here is an example of a case that is not matched:
[]
val total_wrong : int list -> int = <fun>
# total_wrong [1; 3; 5; 3; 1];;
Exception: Match_failure ("//toplevel//", 2, 5).
```

We shall talk about the "exception" that was caused by our ignoring the
warning later. Consider now a function to find the length of a list:

```ocaml
# let rec length l =
    match l with
    | [] -> 0
    | _ :: t -> 1 + length t;;
val length : 'a list -> int = <fun>
```

This function operates not just on lists of integers, but on any kind of list.
This is indicated by the type, which allows its input to be `'a list`
(pronounced alpha list).

```ocaml
# length [1; 2; 3];;
- : int = 3
# length ["cow"; "sheep"; "cat"];;
- : int = 3
# length [[]];;
- : int = 1
```

In the pattern `_ :: t`, the head of the list is not
inspected, so its type cannot be relevant. Such a function is called
polymorphic. Here is another polymorphic function, our own version of the `@`
operator for appending:

```ocaml
# let rec append a b =
    match a with
    | [] -> b
    | h :: t -> h :: append t b;;
val append : 'a list -> 'a list -> 'a list = <fun>
```

Notice that the memory for the second list is shared,
but the first list is effectively copied. Such sharing is common when we use
immutable data types (ones whose values cannot be changed).

We might wish to apply a function to each element in a list, yielding a new
one. We shall write a function `map` that's given another function as its
argument. Such a function is called "higher-order":

```ocaml
# let rec map f l =
    match l with
    | [] -> []
    | h :: t -> f h :: map f t;;
val map : ('a -> 'b) -> 'a list -> 'b list = <fun>
```

Notice the type of the function `f` in parentheses as part of the whole type.
This `map` function, given a function of type `'a -> 'b` and a list of `'a`s,
will build a list of `'b`s. Sometimes `'a` and `'b` might be the same type, of
course. Here are some examples of using `map`:

```ocaml
# map total [[1; 2]; [3; 4]; [5; 6]];;
- : int list = [3; 7; 11]
# map (fun x -> x * 2) [1; 2; 3];;
- : int list = [2; 4; 6]
```

(The syntax `fun` ... `->` ... is used to build a function without a name, which
we'll only use in one place in the program.)

We need not give a function all its arguments at once. This is called partial
application. For example:

```ocaml
# let add a b = a + b;;
val add : int -> int -> int = <fun>
# add;;
- : int -> int -> int = <fun>
# let f = add 6;;
val f : int -> int = <fun>
# f 7;;
- : int = 13
```

Look at the types of `add` and `f` to see what is going on. We can use partial
application to add to each item of a list:

```ocaml
# map (add 6) [1; 2; 3];;
- : int list = [7; 8; 9]
```

Indeed, we can use partial application of our `map` function to map over lists
of lists:

```ocaml
# map (map (fun x -> x * 2)) [[1; 2]; [3; 4]; [5; 6]];;
- : int list list = [[2; 4]; [6; 8]; [10; 12]]
```

## Other Built-In Types

We have seen basic data types like `int`, and our first compound data type, the
list. There are two more ways compound data types of interest. First we have
tuples, which are fixed-length collections of elements of any type:

```ocaml
# let t = (1, "one", '1');;
val t : int * string * char = (1, "one", '1')
```

Notice how the type is written. Records are like tuples, but they have named
elements:

```ocaml
# type person =
   {first_name : string;
    surname : string;
    age : int};;
type person = { first_name : string; surname : string; age : int; }
# let frank =
    {first_name = "Frank";
     surname = "Smith";
     age = 40};;
val frank : person = {first_name = "Frank"; surname = "Smith"; age = 40}
# let s = frank.surname;;
val s : string = "Smith"
```

Pattern-matching works on tuples and records too, of course.

## Our Own Data Types

We can define new data types in OCaml with the `type` keyword:

```ocaml
# type colour = Red | Blue | Green | Yellow;;
type colour = Red | Blue | Green | Yellow
# let l = [Red; Blue; Red];;
val l : colour list = [Red; Blue; Red]
```

Each "type constructor," which must begin with a capital letter, can optionally
carry data along with it:

```ocaml
# type colour =
   | Red
   | Blue
   | Green
   | Yellow
   | RGB of int * int * int;;
type colour = Red | Blue | Green | Yellow | RGB of int * int * int
# let l = [Red; Blue; RGB (30, 255, 154)];;
val l : colour list = [Red; Blue; RGB (30, 255, 154)]
```

Data types may be polymorphic and recursive, too. Here is an OCaml data type for
a binary tree carrying any kind of data:

```ocaml
# type 'a tree =
   | Leaf
   | Node of 'a tree * 'a * 'a tree;;
type 'a tree = Leaf | Node of 'a tree * 'a * 'a tree
# let t =
    Node (Node (Leaf, 1, Leaf), 2, Node (Node (Leaf, 3, Leaf), 4, Leaf));;
val t : int tree =
  Node (Node (Leaf, 1, Leaf), 2, Node (Node (Leaf, 3, Leaf), 4, Leaf))
```

A `Leaf` holds no information, just like an empty list. A `Node` holds
a left tree, a value of type `'a`, and a right tree. Now we can write recursive
and polymorphic functions over these trees by pattern matching on our new
constructors:

```ocaml
# let rec total t =
    match t with
    | Leaf -> 0
    | Node (l, x, r) -> total l + x + total r;;
val total : int tree -> int = <fun>
# let rec flip t =
    match t with
    | Leaf -> Leaf
    | Node (l, x, r) -> Node (flip r, x, flip l);;
val flip : 'a tree -> 'a tree = <fun>
```

Let's try our new functions:

```ocaml
# let all = total t;;
val all : int = 10
# let flipped = flip t;;
val flipped : int tree =
  Node (Node (Leaf, 4, Node (Leaf, 3, Leaf)), 2, Node (Leaf, 1, Leaf))
# t = flip flipped;;
- : bool = true
```

Notice that we don't need to explicitly free memory for such data structures
when we no longer need it because OCaml is a garbage-collected language. It will free
memory for data structures when they are no longer needed. In our example, once
the Boolean test `t = flip flipped` has been evaluated, the data structure
`flip flipped` is no longer reachable by the rest of the program, and its
memory may be reclaimed by the garbage collector (GC).

## Dealing With Errors

OCaml deals with exceptional situations in two ways. One is to use _exceptions_,
which may be defined in roughly the same way as types:

```ocaml
# exception E;;
exception E
# exception E2 of string;;
exception E2 of string
```

An exception is raised like this:

```ocaml
# let f a b =
    if b = 0 then raise (E2 "division by zero") else a / b;;
val f : int -> int -> int = <fun>
```

An exception may be handled with pattern matching:

```ocaml
# try f 10 0 with E2 _ -> 0;;
- : int = 0
```

When an exception is not handled, it's printed at the toplevel:

```ocaml
# f 10 0;;
Exception: E2 "division by zero".
```

The other way to deal with exceptional situations in OCaml is by returning a
value of a type that can represent either the correct result or an error, e.g.,
the built-in polymorphic `option` type:

```ocaml
# type 'a option = None | Some of 'a;;
type 'a option = None | Some of 'a
```

So we may write:

```ocaml
# let f a b =
    if b = 0 then None else Some (a / b);;
val f : int -> int -> int option = <fun>
```

We can use exception handling to build an option-style function from one that
raises an exception, the built-in `List.find` function, which finds the first
element matching a given Boolean test:

```ocaml
# let list_find_opt p l =
    try Some (List.find p l) with
    Not_found -> None;;
val list_find_opt : ('a -> bool) -> 'a list -> 'a option = <fun>
```

As an alternative, we can use an extended form of our usual `match` expression
to match both values and catch exceptions:

```ocaml
# let list_find_opt p l =
    match List.find p l with
    | v -> Some v
    | exception Not_found -> None;;
val list_find_opt : ('a -> bool) -> 'a list -> 'a option = <fun>
```

## Imperative OCaml

OCaml is not just a functional language; it supports imperative programming,
too. OCaml programmers tend to use imperative features sparingly, but almost
all OCaml programmers use them sometimes. If you want a variable
that you can assign and change throughout your program, you need to use a
_reference_.

Here's how we create a reference to an integer in OCaml:

```ocaml
# let r = ref 0;;
val r : int ref = {contents = 0}
```

This reference is currently storing the integer zero. Let's put something
else into it (assignment):

```ocaml
# r := 100;;
- : unit = ()
```

And let's find out what the reference contains now:

```ocaml
# !r;;
- : int = 100
```

So the `:=` operator is used to assign to references, and the `!` operator
de-references to get the contents.

References have their place, but you may find that you don't use them very
often. Much more often you'll be using `let` ... `=` ... `in` ... to name local
expressions in your function definitions.

We can combine multiple imperative operations with `;`. For example, here is a
function to swap the contents of two references of like type:

```ocaml
# let swap a b =
    let t = !a in
      a := !b;
      b := t;;
val swap : 'a ref -> 'a ref -> unit = <fun>
```

Notice the function return type is `unit`. There is exactly one thing of type
`unit`, and it's written `()`. We use `unit` to call a function that needs no
other argument and is only used for its imperative side effect. For example:

```ocaml
# let print_number n =
    print_string (string_of_int n);
    print_newline ();;
val print_number : int -> unit = <fun>
```

We can look at the type of the built-in function `print_newline` by typing its
name without applying the `unit` argument:

```ocaml
# print_newline;;
- : unit -> unit = <fun>
```

The usual imperative looping constructs are available. Here is a `for` loop:

```ocaml
# let table n =
    for row = 1 to n do
      for column = 1 to n do
        print_string (string_of_int (row * column));
        print_string " "
      done;
      print_newline ()
    done;;
val table : int -> unit = <fun>
# let () = table 10;;
1 2 3 4 5 6 7 8 9 10
2 4 6 8 10 12 14 16 18 20
3 6 9 12 15 18 21 24 27 30
4 8 12 16 20 24 28 32 36 40
5 10 15 20 25 30 35 40 45 50
6 12 18 24 30 36 42 48 54 60
7 14 21 28 35 42 49 56 63 70
8 16 24 32 40 48 56 64 72 80
9 18 27 36 45 54 63 72 81 90
10 20 30 40 50 60 70 80 90 100
```

Here is a `while` loop, used to write a function to calculate the power of
two larger than or equal to a given number:

```ocaml
# let smallest_power_of_two x =
    let t = ref 1 in
      while !t < x do
        t := !t * 2
      done;
      !t;;
val smallest_power_of_two : int -> int = <fun>
```

In addition to references, the imperative part of OCaml has arrays of items of
like type, whose elements can be accessed or updated in constant time:

```ocaml
# let arr = [|1; 2; 3|];;
val arr : int array = [|1; 2; 3|]
# arr.(0);;
- : int = 1
# arr.(0) <- 0;;
- : unit = ()
# arr;;
- : int array = [|0; 2; 3|]
```

Records may have mutable fields too, which must be marked in the type:

```ocaml
# type person =
    {first_name : string;
     surname : string;
     mutable age : int};;
type person = { first_name : string; surname : string; mutable age : int; }
# let birthday p =
    p.age <- p.age + 1;;
val birthday : person -> unit = <fun>
```

## The Standard Library

OCaml comes with a library of useful modules that are available anywhere OCaml
is. For example, there are standard libraries for functional data structures
(such as maps and sets), for imperative data structures (such as hash tables),
and for interacting with the operating system. We use them by writing the module followed by a
full stop, then followed by the name of the function. Here are some functions from
the `List` module:

```ocaml
# List.concat [[1; 2; 3]; [4; 5; 6]; [7; 8; 9]];;
- : int list = [1; 2; 3; 4; 5; 6; 7; 8; 9]
# List.filter (( < ) 10) [1; 4; 20; 10; 9; 2];;
- : int list = [20]
# List.sort compare [1; 6; 2; 2; 3; 56; 3; 2];;
- : int list = [1; 2; 2; 2; 3; 3; 6; 56]
```

The `Printf` module provides type-checked printing facilities, so we know at
compile time that the printing will work:

```ocaml
# let print_length s =
    Printf.printf "%s has %i characters\n" s (String.length s);;
val print_length : string -> unit = <fun>
# List.iter print_length ["one"; "two"; "three"];;
one has 3 characters
two has 3 characters
three has 5 characters
- : unit = ()
```

You can find the full list of standard library modules in the
[manual](/releases/latest/manual.html).

## A Module From Opam

Apart from the standard library, a much wider range of modules are available
through the OCaml Package Manager, opam. Please note: you must have OCaml on your computer
to follow the tutorial moving forward, not just the OCaml Playground tool.

For these examples, we're going to use module called `Graphics`, which can be
installed with `opam install graphics`, and the `ocamlfind` program that installed
with `opam install ocamlfind`. The `Graphics` module is a very simple
cross-platform graphics system which was once part of OCaml itself. Now it's
available separately through opam.

If we want to use the functions in `Graphics`, there are two ways we can
do it. Either at the start of our program we have the `open Graphics`
declaration, or we prefix all calls to the functions like this:
`Graphics.open_graph`.

To use `Graphics` in the toplevel, you must first load the library with

<!-- $MDX skip -->
```ocaml
# #use "topfind";;
- : unit = ()
Findlib has been successfully loaded. Additional directives:
...
  #require "package";;      to load a package
...

- : unit = ()
# #require "graphics";;
/Users/me/.opam/4.14.0/lib/graphics: added to search path
/Users/me/.opam/4.14.0/lib/graphics/graphics.cma: loaded
```

A couple of examples should make this clear. (The two examples draw different
things, so experiment with them.) Note the first example uses `open` to open the Graphics
module, then calls `open_graph`, and the second one uses `Graphics.open_graph`
directly.

<!-- $MDX skip -->
```ocaml
open Graphics;;

open_graph " 640x480";;

for i = 12 downto 1 do
  let radius = i * 20 in
    set_color (if i mod 2 = 0 then red else yellow);
    fill_circle 320 240 radius
done;;

read_line ();;
```

<!-- $MDX skip -->
```ocaml
Random.self_init ();;

Graphics.open_graph " 640x480";;

let rec iterate r x_init i =
  if i = 1 then x_init else
    let x = iterate r x_init (i - 1) in
      r *. x *. (1.0 -. x);;

for x = 0 to 639 do
  let r = 4.0 *. (float_of_int x) /. 640.0 in
  for i = 0 to 39 do
    let x_init = Random.float 1.0 in
    let x_final = iterate r x_init 500 in
    let y = int_of_float (x_final *. 480.) in
      Graphics.plot x y
  done
done;;

read_line ();;
```

You should copy and paste these examples into OCaml piece by piece. Each piece
ends with a `;;`.

## Compiling OCaml Programs

So far we've been using only the OCaml toplevel. Now we'll compile OCaml
programs into fast stand-alone executables. Consider the following program,
saved as "helloworld.ml"

<!-- $MDX skip -->
```ocaml
print_endline "Hello, World!"
```

(Notice there is no need to write `;;` since we are not using the toplevel).
We may compile it like this:

<!-- $MDX skip -->
```ocaml
ocamlopt -o helloworld helloworld.ml
```

Now our current directory has four more files. The files `helloworld.cmi`,
`helloworld.cmo`, and `helloworld.o` are left over from the compilation
process. The file `helloworld` is our executable:

<!-- $MDX skip -->
```ocaml
$ ./helloworld
Hello, World!
$
```

If we have more than one file, we list them all. Here is an example, defined in
its own file `data.ml` with a corresponding `data.mli` interface, and a main
file `main.ml` that uses it.

<!-- $MDX skip -->
```ocaml
data.ml:

let to_print = "Hello, World!"
```

<!-- $MDX skip -->
```ocaml
data.mli:

val to_print : string
```

<!-- $MDX skip -->
```ocaml
main.ml:

print_endline Data.to_print
```

We can compile it like this:

```console
ocamlopt -o main data.mli data.ml main.ml
```

Most users of OCaml do not call the compiler directly. They use one of the
[build systems](/docs/compiling-ocaml-projects) to manage
compilation for them.

## Where Next?

This quick tour should have given you a little taste of OCaml and why you might
like to explore it further. Elsewhere on [ocaml.org](/), there are
pointers to [books on OCaml](/books) and
[other tutorials](/docs).
