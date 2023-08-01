---
id: a-tour-of-ocaml
title: A Tour of OCaml
description: >
  Hop on the OCaml sightseeing bus. This absolute beginner tutorial will drive you through the marvels and wonders of OCaml. You'll have a sneak peek at everything that matters. Money back if you don't see OCaml's big five game.
category: "Getting Started"
---

## Sightseeing the Language

Before proceeding with this tutorial, please ensure you've installed OCaml and set up the environment, as described in the [Installing OCaml](/docs/up-and-running) tutorial. After we take an introductory tour of OCaml's language features, we'll proceed to create our first OCaml project in the [How to Write an OCaml Program](/docs/how-to-write-an-ocaml-program) tutorial.

Let's walk through the basics of OCaml by trying out different elements in an interactive manner. We recommend that you execute the examples we provide, or slight variants of them, in your own environment to get the feel of coding in OCaml.

## Using an OCaml Toplevel: Chatting with OCaml

An OCaml toplevel is a chat between the user and the OCaml system. The user writes OCaml sentences, and the system analyses and executes them, which is why it is also called a Read-Eval-Print-Loop (REPL). Several OCaml toplevels exist like `ocaml` and `utop`, but in this tutorial, we will use the `utop` command, which looks like this:

```shell
$ utop
────────┬─────────────────────────────────────────────────────────────┬─────────
        │ Welcome to utop version 2.12.1 (using OCaml version 5.0.0)! │
        └─────────────────────────────────────────────────────────────┘

Type #utop_help for help about using utop.

─( 17:00:09 )─< command 0 >──────────────────────────────────────{ counter: 0 }─
utop #
```

Press `Ctrl-D` (end of file) or enter `#quit;;` to exit `utop`.

The OCaml code examples in this tutorial show the input needed at the hash prompt `#`, as displayed by `utop`, ending with double semicolumn `;;`. The `;;` let's OCaml know the expression is complete. Code sample lines beginning with dollar sign `$`, like above, should be entered in an Unix terminal.

Upon hitting `Enter`, OCaml runs the code. The following line shows the output. (For simplicity, anything but the user input and OCaml's output in `utop` is omitted in this tutorial.)

```ocaml
# 2 + 2;;
- : int = 4
```

Neither the prompt `#` nor the double semicolumns `;;` are part of the code. When the toplevel displays the prompt `#`, it means it is waiting for user input. The double semicolumn means “send.” It marks the end of the input and signals OCaml to run the code. Without double semicolumn, pressing return just creates a new line.

Again, the line which follows shows OCaml's result. The above example says, “What you've entered is an integer (`int`) that evaluates into 4.”

If you need to amend the code before hitting enter, you can use your keyboard's right and left arrows to move inside the text. The up and down arrows allows navitation through previously typed commands, if you have multiple lines of code.

Remember: commands beginning with a hash mark are not part of the OCaml syntax; they are interpreted by UTop itself.

## Expressions and Definitions

```ocaml
# 50 * 50;;
- : int = 2500
```

In OCaml, everything has a value and every value has a type. Here`50 * 50` is an expression that evaluates to `2500`, which is of type `int` (integer). Here are examples of other primitive values and types:
```ocaml
# 6.28;;
- : float = 6.28

# "This is really disco!";;
- : string = "This is really disco!"

# true;;
- : bool = true
```

OCaml has *type inference*. It automatically determines the type of an expression without much guidance from the programmer. Lists are the topic of a [dedicated tutorial](/docs/lists). For the time being, the following two expressions are both lists. The former contains integers, and the latter, strings.
```ocaml
# [1; 2; 3; 4];;
- : int list = [1; 2; 3; 4]

# ["this"; "is"; "mambo"];;
- : string list = ["this"; "is"; "mambo"]
```

The lists' type, `int list` and `string list`, has been inferred from the type of their elements.

Tests also are expressions
```ocaml
# if 0 = 1 then "test is true" else "test is false";;
- : string = "test is false"
```
In OCaml, `if ... then ... else ...` and the ternary conditional operator are the same thing.

Values can be given names using the `let` keyword. This is called *binding* a value to a name. For example:

```ocaml
# let x = 50;;
val x : int = 50

# x * x;;
- : int = 2500
```

When entering `let x = 50;;`, OCaml responds with `val x : int = 50`, meaning that `x` is an identifier bound to value `50`. So `x * x;;` evaluates to the same as `50 * 50;;`.

Bindings in OCaml are *immutable*, meaning that the value assigned to a name never changes. There is no overloading in OCaml, so inside a lexical scope, names have a single value, which only depends on its definition.

Do not use dashes in names; use underscores instead. For example: `x_plus_y` works, `x-plus-y` does not.

Names can be defined locally, within an expression, using the `let ... in ...` syntax:

```ocaml
# let y = 50 in y * y;;
- : int = 2500

# y;;
Error: Unbound value y
```

This example defines the name `y` and binds it to the value `50`. It is then used in the expression `y * y`, resulting in the value `2500`. Note that `y` is only defined in the expression following the `in` keyword.

Since `let ... in ...` is an expression, it can be used within another expression in order to have several values with their own names:

```ocaml
# let a = 1 in
  let b = 2 in
    a + b;;
- : int = 3
```

This defines two names: `a` with value `1` and `b` with value `2`. Then the example uses them in the expression `a + b`, resulting in the value of `3`.

## Functions

In OCaml, since everything is a value, functions are values too. Functions are defined using the `let` keyword:

```ocaml
# let square x = x * x;;
val square : int -> int = <fun>

# square 50;;
- : int = 2500
```

This example defines a function named `square` with the single argument `x`. Its _function body_ is the expression `x * x`. There is no “return” keyword in OCaml.

When `square` is applied to `50`, it evaluates `x * x` into `50 * 50`, which leads to `2500`.

The REPL indicates that the type of `square` is `int -> int`. This means it is a function taking an `int` as parameter (input) and returning an `int` as result (output). Function value can't be displayed, that is why `<fun>` is printed instead.

### Anonymous Functions

_Anonymous_ functions do not have a name, and they are defined with the `fun` keyword:

```ocaml
# fun x -> x * x;;
- : int -> int = <fun>
```

We can write anonymous functions and immediately apply them to a value:

```ocaml
# (fun x -> x * x) 50;;
- : int = 2500
```

### Functions with Multiple Arguments and Partial Application

A function may take several arguments, separated by spaces. This is the case both in function declaration and in function calls.

```ocaml
# let cat a b = a ^ " " ^ b;;
val cat : string -> string -> string = <fun>
```

The function `cat` takes two `string` arguments, `a` and `b`, and returns a value of type `string`.

```ocaml
# cat "ha" "ha";;
- : string = "ha ha"
```

Functions don't have to be called with all the arguments they expect. It is possible to only pass `a` to `cat` without passing `b`.

```ocaml
# let cat_hi = cat "hi";;
cat_hi : string -> string = <fun>
```

This returns a function which expects a single string, here the `b` from the definition of `cat`. This is called a _partial application_. In the above, `cat` was partially applied to `"hi"`.

The function `cat_hi`, which resulted from the partial application of `cat`, behaves as follows:

```ocaml
# cat_hi "friend";;
- : string = "hi friend"
```

### Type Variables and Higher-Order Functions

A function may expect a function as parameter, which is called a _higher-order_ function. A well-known example of higher-order function is `List.map`.

```ocaml
# List.map;;
- : ('a -> 'b) -> 'a list -> 'b list = <fun>

# List.map (fun x -> x * x);;
- : int list -> int list = <fun>

# List.map (fun x -> x * x) [0; 1; 2; 3; 4; 5];;
- : int list = [0; 1; 4; 9; 16; 25]
```

The name of this function begins with `List.` because it is part of the predefined library of functions acting on lists. (This matter will be discussed more later.) Function `List.map` takes two parameters: the second is a list, and the first is a function that can be applied to the list's elements, whatever they may be. `List.map` returns a list formed by applying the function provided as parameter to each of the elements of the input list.

The function `List.map` can be applied on any kind of list. Here it is given a list of integers, but it could be a list of floats, strings, or anything. This is known as _polymorphism_. The `List.map` function is polymorphic, meaning it has two _type variables_: `'a` and `'b` (pronounced alpha and beta). They both can be anything; however, in regard to the function passed to `List.map`:
1. Input list elements have the same type of its input
2. Output list elements have the same type of its output

### Side-Effects and the `unit` Type

Performing operating system level input-output operations is done using functions. Here is an example of each:

```ocaml
# read_line;;
- : unit -> string = <fun>

# read_line ();;
caramba
- : string = "caramba"

# print_endline;;
- : string -> unit = <fun>

# print_endline "ah ah";;
ah ah
- : unit = ()
```

The function `read_line` reads characters on standard input and returns them as a string when end-of-line (EOL) is reached. The function `print_endline` prints a string on standard output, followed by an EOL.

The function `read_line` doesn't need any data to proceed, and the function `print_endline` doesn't have any meaningful data to return. Indicating this absence of data is the role of the `unit` type, which appears in their signature. The type `unit` has as single value, written `()` and pronounced *unit*. It is used as a placeholder when no data is passed or returned, but some token still has to be passed to start processing or when it has terminated.

Input-output is an example of something taking place when executing a function but which does not appear in the function type. This is called a _side-effect_ and does not stop at I/O. The `unit` type is often used to indicate the presence of side-effects, although it's not always the case.

### Operators

_FIXME: Shall we move this to another tutorial? Which one?_

Operators are functions. The function underlying behind an operator is refered by surrounding the operator symbol with parenthesis. Here are the addition, string concatenation and equality functions:

```ocaml
# (+);;
- : int -> int -> int = <fun>
# (^);;
- : string -> string -> string = <fun>
# (=);;
- : 'a -> 'a -> bool = <fun>
```

Note: The operator symbol for multiplication is ` * `, but OCaml comments also have an openning delimitor `(*` and a closing delimitor `*)`. To resolve the parsing ambiguity, space must be inserted to get the multiplication function.

```ocaml
# ( * );;
- : int -> int -> int = <fun>
```

Using operators as functions is convinient when combined with partial application. For instance, here is how to get the values which are greater or equal to 10 in a list of integers, using the function `List.filter` applied to the function `( < ) 10`:
```ocaml
# List.filter;;
- : ('a -> bool) -> 'a list -> 'a list = <fun>

# List.filter (( <= ) 10);;
- : int list -> int list = <fun>

# List.filter (( <= ) 10) [6; 15; 7; 14; 8; 13; 9; 12; 10; 11];;
- : int list = [15; 14; 13; 12; 10; 11]
```

The first two lines are only informative.

1. The first shows the `List.filter` type, which is a function taking two parameters. The first parameter is a function; the second is a list.
2. The second is the partial application of `List.filter` to `( <= ) 10`, which is a function returning `true` if applied to a number which is greater than or equal to 10.

Finally, in the third line, all the arguments expected by `List.filter` are provided. The returned list contains the values satisfying the `( <= ) 10` function.

It is also possible to define binary operators. Here is an example:
```ocaml
# let ( ^? ) = cat;;
val ( ^? ) : string -> string -> string = <fun>
# "hi" ^? "friend";;
- : string = "hi friend"
```

There are syntactic restrictions on possible operators symbols. They will not be
detailed here.

### Recursive Functions

A recursive function calls itself in its own definition. Such functions must be declared using `let rec` instead of just `let`. Here is an example:

```ocaml
# let rec range a b =
    if a > b then []
    else a :: range (a + 1) b;;
val range : int -> int -> int list = <fun>

# range 2 11;;
- : int list = [2; 3; 4; 5; 6; 7; 8; 9; 10; 11]
```

## Data and Typing

### Type Conversion and Type-Inference

OCaml has floating-point values of type `float`. To add floats, one must use `+.` instead of `+`:

```ocaml
# 2.0 +. 2.0;;
- : float = 4.
```

In OCaml, `+.` is the addition between floats, while `+` is the addition between integers.

In many programming languages, values can be automatically converted from one type into another. This includes *implicit type conversion* and *promotion*. For example, in such a language, if you write `1 + 2.5`, the first argument, which is an integer, is promoted to a floating point number, making the result a floating point number, too.

OCaml never implicitly converts values from one type to another. It is not possible to perform the addition of a float and integer. Both examples below throw an error:
```ocaml
# 1 + 2.5;;
Error: This expression has type float but an expression was expected of type
         int

# 1 +. 2.5;;
Error: This expression has type int but an expression was expected of type
         float
  Hint: Did you mean `1.'?
```
In the first example, `+` is intended to be used with integers, so it can't be used with the `2.5` float. In the second example, `+.` is intended to be used with floats, so it can't be used with the `1` integer.

In OCaml you need to explicitly convert the integer to a floating point number using the `float_of_int` function:

```ocaml
# float_of_int 1 +. 2.5;;
- : float = 3.5
```

There are several reasons why OCaml requires explicit conversions. Most importantly, it enables types to be worked out automatically. OCaml's *type inference* algorithm computes a type for each expression and requires very little annotation, in comparison to other languages. Arguably, this saves more time than we lose by being more explicit.

### Pattern Matching

Here is a factorial function:

```ocaml
# let rec fact n =
    if n <= 1 then 1 else n * fact (n - 1);;
val fact : int -> int = <fun>
```

In OCaml, _pattern matching_ is often preferred. It is generalisation of the `switch` statement found in many languages. Here an alternate version of `fact`, using pattern matching:
```ocaml
# let rec fact n =
    match n with
    | 0 -> 1
    | 1 -> 1
    | n -> n * fact (n - 1);;
val fact : int -> int = <fun>
```

### Lists

Lists may be the most common data type in OCaml. They are ordered collections of
values having the same type. Here are a few examples.

```ocaml
# [];;
- : 'a list = []

# [1; 2; 3];;
- : int list = [1; 2; 3]

# [false; false; true];;
- : bool list = [false; false; true]

# [[1; 2]; [3]; [4; 5; 6]];;
- : int list list = [[1; 2]; [3]; [4; 5; 6]]
```

Lists are defined as being either empty, which is written `[]`, or being an element `x` added at the front of another list `u`, which is written `x :: u` (the double colon operator is pronounced “cons”).

```ocaml
# 1 :: [2; 3; 4];;
- : int list = [1; 2; 3; 4]
```

These notations also apply to pattern matching. For example, here is how to define a recursive function that computes the sum of a list of integers:

```ocaml
# let rec sum u =
    match u with
    | [] -> 0
    | x :: v -> x + sum v;;
val sum : int list -> int = <fun>

# sum [1; 4; 3; 2; 5]/L
- : int = 15
```

#### Polymorphic Functions on Lists

Here is how to write a recursive function that computes the length of a list:

```ocaml
# let rec length u =
    match u with
    | [] -> 0
    | _ :: v -> 1 + length v;;
val length : 'a list -> int = <fun>

# length [1; 2; 3; 4];;
- : int = 4

# length ["cow"; "sheep"; "cat"];;
- : int = 3

# length [[]];;
- : int = 1
```

This function operates not just on lists of integers but on any kind of list. It is a polymorphic function. Its type indicates input of type `'a list` where `'a` is type variable standing for any type. The empty list pattern `[]` can be of any element type. So the `_ :: v` pattern, as the value at the head of the list, is irrelevant because the `_` pattern indicates it is not inspected. Since both patterns must be of the same type, the typing algorithm infers the `'a list -> int` type.

#### Higher Order Functions on Lists

Functions taking other functions as parameters are called _higher-order_ functions. This was illustrated earlier using function `List.map`. Here is how it is written using pattern matching on lists:

```ocaml
# let rec map f u =
    match u with
    | [] -> []
    | x :: u -> f x :: map f u;;
val map : ('a -> 'b) -> 'a list -> 'b list = <fun>

# let u = range 0 10000 in List.map square u = map square u;;
- : bool = true
```

### Pairs and Tuples

Tuples are fixed-length collections of elements of any type. Pairs are tuples having two elements. Here is a 3-tuple and a pair:

```ocaml
# (1, "one", 'K');;
- : int * string * char = (1, "one", 'K')

# ([], false);;
- : 'a list * bool = ([], false)
```

Access to the component of tuple is done using pattern matching. For instance, the predefined function `snd` returns the second component of a pair:
```ocaml
# let snd p =
    match p with
    | (_, y) -> y;;
val snd : 'a * 'b -> 'b = <fun>
```

The type of tuples is written using `*` between the components' types.

### Variants Types

Like pattern matching generalises `switch` statements, variant types generalises enumerated and union types.

Here is the definition of a variant type acting as an enumerated data type:

```ocaml
# type primary_colour = Red | Green | Blue;;
type primary_colour = Red | Green | Blue

# [Red; Blue; Red];;
- : colour list = [Red; Blue; Red]
```

Here is the definition of a variant type acting as a union type:
```ocaml
# type http_response =
| Data of string
| Error of int;;
type http_response = Data of string | Error of int
```

Here is something sitting in between:
```ocaml
# type page_range =
| All
| Current
| Range of int * int;;
type page_range = All | Current | Range of int * int
```

In the previous definitions, the capitalised identifiers are called *constructors*. They allow the creation of variant values. This is unrelated to object-oriented programming.

As suggested in the first sentence of this section, variants go along with pattern matching. Here are some examples:
```ocaml
# let colour_to_rgb colour =
    match colour with
    | Red -> (0xff, 0, 0)
    | Green -> (0, 0xff, 0)
    | Blue -> (0, 0, 0xff);;
val colour_to_rgb : primary_colour -> int * int * int = <fun>

# let http_status_code response =
    match response with
    | Data _ -> 200
    | Error code -> code;;
val http_status_code : http_response -> int = <fun>

# let is_printable page_count cur range =
    match range with
    | All -> true
    | Current -> 0 <= cur && cur < page_count
    | Range (lo, hi) -> 0 <= lo && lo <= hi && hi < page_count
val is_printable : int -> int -> page_range -> bool = <fun>
```

Like a function, a variant can be recursive if refers to itself in its own definition. The predefined type `list` provides an example of such a variant:
```ocaml
# show list;;
type 'a list = [] | (::) of 'a * 'a list
```

As previously shown, `sum`, `length`, and `map` functions provide examples of pattern matching over the list variant type.

### Records

Like tuples, records also pack elements of several types together. However, each element is given a name. Like variant types, records types must be defined before being used. Here are examples of a record type, a value, access to a component, and pattern matching on the same record.

```ocaml
# type person = {
    first_name : string;
    surname : string;
    age : int
  };;
type person = { first_name : string; surname : string; age : int; }

# let frank = {
     first_name = "Gérard";
     surname = "Huet";
     age = 40
  };;
val frank : person = {first_name = "Gérard"; surname = "Huet"; age = 40}

# let s = frank.surname;;
val s : string = "Huet"

# let is_teenager person =
    match person with
    | { age = x; _ } -> 13 <= x && x <= 19;;
val is_teenager : person -> bool = <fun>

# is_teenager frank;;
- : bool = false
```

## Dealing With Errors

### Exceptions

When a computation is interrupted, an exception is thrown. For instance:

```ocaml
# 10 / 0;;
Exception: Division_by_zero.
```

Exceptions are raised using the `raise` function.

```ocaml
# let id_42 n = if n <> 42 then raise (Failure "Sorry") else n;;
val id_42 : int -> int = <fun>

# id_42 42;;
- : int = 42

# id_42 0;;
Exception: Failure "Sorry".
```

Note that exceptions do not appear in function types.

Exceptions are caught using the `try ... with ...` construction

```ocaml
# try id_42 0 with Failure _ -> 0;;
- : int = 0
```

The standard library provides several predefined exceptions. It is possible to define exceptions.

### Using the `result` type

Another way to deal with errors in OCaml is by returning value of type `result`,
which can represent either the correct result or an error. Here is how it is defined:

```ocaml
# #show result;;
type ('a, 'b) result = Ok of 'a | Error of 'b
```

So one may write:

```ocaml
# let id_42_res n = if n <> 42 then Error "Sorry" else Ok n;;
val id_42_res : int -> (int, string) result = <fun>

# id_42_res 42;;
- : (int, string) result = Ok 42

# id_42_res 0;;
- : (int, string) result = Error "Sorry"
```

## Working with Mutable State

OCaml supports imperative programming. Usually, the `let ...` syntax does not define variables, it defines constants. However, mutable variables exists in OCaml, they are called references. Here's how we create a reference to an integer:

```ocaml
# let r = ref 0;;
val r : int ref = {contents = 0}
```

It is syntactically impossible to create an unintialised or null reference. The `r`
reference is created with the integer zero. Accessing a reference's content
is done using the `!` de-reference operator.

```ocaml
# !r;;
- : int = 0
```

Let's put something else behind `r`. Here `:=` is the assignment operator; it is
pronounced “receives”.

```ocaml
# r := 42;;
- : unit = ()
```

This returns `()` because changing the content of a reference is a side-effect.

```ocaml
# !r;;
- : int = 42
```

Execute an expression after another with the `;` operator. Writing `a; b` means: execute `a`; once done, execute `b`, only return the value of `b`.

```ocaml
# print_string "hello "; print_endline "world!";;
hello world!
- : unit = ()
```

Here the first side-effect displays `hello `, the second `world!`. The
returned value comes from the second function call.

OCaml also has mutable arrays. Here is how to create one:

```ocaml
# let a = [| 11; 12; 13; 14; 15; 16; 17 |];;
val a : int array = [|11; 12; 13; 14; 15; 16; 17|]
```

Here is how indexed access is done:

```ocaml
# a.(4);;
- : int = 15
```

Assignment into arrays and reference assignment are done with different operators.
```ocaml
# a.(4) <- 0;;
- : unit = ()

# a.(4);;
- : int = 0
```

## Modules and the Standard Library.

Organising source code in OCaml is done using something called _modules_. A module is a group of definitions. The _standard library_ is a set of modules available to all OCaml programs. Here is how the definitions contains in the `Option` module of the standard library can be listed:
```ocaml
# #show Option;;
module Option :
  sig
    type 'a t = 'a option = None | Some of 'a
    val none : 'a t
    val some : 'a -> 'a t
    val value : 'a t -> default:'a -> 'a
    val get : 'a t -> 'a
    val bind : 'a t -> ('a -> 'b t) -> 'b t
    val join : 'a t t -> 'a t
    val map : ('a -> 'b) -> 'a t -> 'b t
    val fold : none:'a -> some:('b -> 'a) -> 'b t -> 'a
    val iter : ('a -> unit) -> 'a t -> unit
    val is_none : 'a t -> bool
    val is_some : 'a t -> bool
    val equal : ('a -> 'a -> bool) -> 'a t -> 'a t -> bool
    val compare : ('a -> 'a -> int) -> 'a t -> 'a t -> int
    val to_result : none:'e -> 'a t -> ('a, 'e) result
    val to_list : 'a t -> 'a list
    val to_seq : 'a t -> 'a Seq.t
  end
```

Definitions provided by modules are refered to by adding the module name as a prefix to the their name.
```ocaml
# Option.map;;
- : ('a -> 'b) -> 'a option -> 'b option = <fun>

# Option.map (fun x -> x * x);;
- : int option -> int option = <fun>

# Option.map (fun x -> x * x) None;;
- : int option = None

# Option.map (fun x -> x * x) (Some 8);;
- : int option = Some 64
```

Here, the function `Option.map` is used. When the option value provided contains an actual value (i.e. it is `Some` something), it applies the provided function and returns its result wrapped in a option. When the option value provided doesn't contain anything (i.e. is is `None`), it ignores the function it is provided the and behaves as the identity function.

The `List.map` function which was used earlier in this section also part of a module, the `List` module.
```ocaml
# List.map;;
- : ('a -> 'b) -> 'a list -> 'b list = <fun>

# List.map (fun x -> x * x);;
- : int list -> int list = <fun>

```
This illustrates the first feature of the OCaml module system. It provides a mean to separate concerns by preventing name clashes. Two functions having different type may have the same if they are provided by different modules.

Module also allows efficient separated compilation, this is illustrated in the next tutorial.

## Sum-Up and Where Next?

OCaml has many features, and these may be its Big Five ones:

1. Type-Inference
2. Variant Types and Pattern Matching
3. Lists
4. Values and Definitions
5. Functions

To become a proficient OCaml developer, make sure to master them.

Next tutorial: [How to Write an OCaml Project](/docs/how-to-write-an-ocaml-project). In this tutorial, OCaml was used interactively, and it shows how to write OCaml files, how to compile them, and how to kickstart a project.
