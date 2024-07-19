---
id: values-and-functions
title: Values and Functions
description: |
  Functions, values, definitions, environments, scopes, closures, and shadowing. This tutorial will help you master the fundamentals.
category: "Introduction"
prerequisite_tutorials:
  - "toplevel-introduction"
  - "installing-ocaml"
---

## Introduction

In OCaml, functions are treated as values, so you can use functions as arguments to functions and return them from functions. This tutorial introduces the relationship between expressions, values, and names. The first four sections address non-function values. The following sections, starting at [Function as Values](#function-as-values), address functions.

We use UTop to understand these concepts by example. You are encouraged to modify the examples to gain a better understanding. 

## What is a Value?

Like most functional programming languages, OCaml is an [expression-oriented](https://en.wikipedia.org/wiki/Expression-oriented_programming_language) programming language. That means programs are expressions. Actually, almost everything is an expression. In OCaml, statements don't specify actions to be taken on data. All computations are made through expression evaluation. Computing expressions produce values. Below, you'll find a few examples of expressions, their types, and the resulting values. Some include computation and some do not:

```ocaml
# "Every expression has a type";;
- : string = "Every expression has a type"

# 2 * 21;;
- : int = 42

# int_of_float;;
- : float -> int = <fun>

# int_of_float (3.14159 *. 2.0);;
- : int = 6

# fun x -> x * x;;
- : int -> int = <fun>

# print_endline;;
- : string -> unit = <fun>

# print_endline "Hello!";;
Hello!
- : unit
```

An expression's type (before evaluation) and its resulting value's type (after computation) are the same. This allows the compiler to avoid runtime type checks in binaries. In OCaml, the compiler removes type information, so it's not available at runtime. In programming theory, this is called [subject reduction](https://en.wikipedia.org/wiki/Subject_reduction).

## Global Definitions

Every value can be named. This is the purpose of the `let … = … ` statement. The name is on the left; the expression is on the right.
* If the expression can be evaluated, it is.
* Otherwise, the expression is turned into a value as-is. That's the case of function definition.

This is what happens when writing a definition in UTop:
```ocaml
# let the_answer = 2 * 3 * 7;;
val the_answer : int = 42
```

Global definitions are those entered at the top level. Here, `the_answer` is defined globally.

## Local Definitions

Local definitions bind a name inside an expression:
```ocaml
# let d = 2 * 3 in d * 7;;
- : int = 42

# d;;
Error: Unbound value d
```

Local definitions are introduced by the `let … = … in …` expression. The name bound before the `in` keyword is only bound in the expression after the `in` keyword. Here, the name `d` is bound to `6` inside the expression `d * 7`.

A couple of remarks:
- No global definition is introduced in this example, which is why we get an error.
- Computation of `2 * 3` will always take place before `d * 7`.

Local definitions can be chained (one after another) or nested (one inside another). Here is an example of chaining:
```ocaml
# let d = 2 * 3 in
  let e = d * 7 in
  d * e;;
- : int = 252

# d;;
Error: Unbound value d
# e;;
Error: Unbound value e
```

Here is how scoping works:
- `d` is bound to `6` inside `let e = d * 7 in d * e`
- `e` is bound to `42` inside `d * e`

Here is an example of nesting:
```ocaml
# let d =
    let e = 2 * 3 in
    e * 5 in
  d * 7;;
- : int = 210

# d;;
Error: Unbound value d
# e;;
Error: Unbound value e
```
Here is how scoping works:
- `e` is bound to `6` inside `e * 5`
- `d` is bound to `30` inside `d * 7`

Arbitrary combinations of chaining or nesting are allowed.

In both examples, `d` and `e` are local definitions.


## Pattern Matching in Definitions

<!-- 5 cases to illustrate below: Unit case. `_`, tuples, user-defined constructor variants, and records-->
<!-- FIXME: review & revise this entire section :: Sabine -->

<!--the example illustrates tuples::-->
When pattern matching only has one case, it can be used in name definitions and in
`let ... =` and `fun ... ->` expressions. In that case, less or more than one
name may be defined. This applies to tuples, records, and custom single-variant
types.

### Pattern Matching on Tuples

A common case is tuples. It allows the creation of two names with a single `let`.
```ocaml
# List.split;;
- : ('a * 'b) list -> 'a list * 'b list

# let (x, y) = List.split [(1, 2); (3, 4); (5, 6); (7, 8)];;
val x : int list = [1; 3; 5; 7]
val y : int list = [2; 4; 6; 8]
```

The `List.split` function turns a list of pairs into a pair of lists. Here, each resulting list is bound to a name.

### Pattern Matching on Records

<!--Because records are implicitly single-constructor variants,-->
We can pattern match on records:
```ocaml
# type name = { first : string; last: string };;
type name = { first : string; last : string; }

# let robin = { first = "Robin"; last = "Milner" };;
val robin : name = {first = "Robin"; last = "Milner"}

# let { first = given_name; last = family_name } = robin;;
val given_name : string = "Robin"
val family_name : string = "Milner"
```

### Pattern Matching in Function Parameters

Single-case pattern matching can also be used for parameter declaration.

Here is an example with tuples:
```ocaml
# let get_country ((country, { first; last }) : string * name) = country;;
val get_country : string * name -> string = <fun>
```

Here is an example with the `name` record:
```ocaml
# let introduce {first; last} = "I am " ^ first ^ " " ^ last;;
val introduce : name -> string = <fun>
```

**Note** Using the `discard` pattern for parameter declaration is also possible.
```ocaml
# let get_meaning _ = 42;;
val get_meaning : 'a -> int = <fun>
```


### Pattern Matching on `unit`
<!--Unit example-->
A special case of combined definition and pattern matching involves the `unit` type:
```ocaml
# let () = print_endline "ha ha";;
ha ha
```

**Note**: As explained in the [Tour of OCaml](/docs/tour-of-ocaml) tutorial, the `unit` type has a single value `()`, which is pronounced "unit."

Above, the pattern does not contain any identifier, meaning no name is defined. The expression is evaluated and the side effect takes place (printing `ha ha` to standard output).

**Note**: In order for compiled files to only evaluate an expression for its side effects, you must write them after `let () =`.

<!-- user-defined single constructor variant example -->
<!-- FIXME: create an example nested pattern matching -->

### Pattern Matching on User-Defined Types

This also works with user-defined types.
```ocaml
# type citizen = string * name;;
type citizen = string * name

# let ((country, { first = forename; last = surname }) : citizen) = ("United Kingdom", robin);;
val country : string = "United Kingdom"
val forename : string = "Robin"
val surname : string = "Milner"
```

### Discarding Values Using Pattern Matching
<!-- `_` example-->
As seen in the last example, the catch-all pattern (`_`) can be used in definitions.
```ocaml
# let (_, y) = List.split [(1, 2); (3, 4); (5, 6); (7, 8)];;
val y : int list = [2; 4; 6; 8]
```

The `List.split` function returns a pair of lists. We're only interested in the second list, we give it the name `y` and discard the first list by using `_`.

## Scopes and Environments

Without oversimplifying, an OCaml program is a sequence of expressions or global `let` definitions. <!--These items are said to be at the _top-level_. An OCaml REPL, such as UTop, is called a "toplevel" because that's where typed definitions go.-->

Execution evaluates each item from top to bottom.

At any time during evaluation, the _environment_ is the ordered sequence of available definitions. The *environment* is also known as *context* in other languages.

Here, the name `twenty` is added to the top-level environment.
```ocaml
# let twenty = 20;;
val twenty : int = 20
```

The scope of `twenty` is global. This name is available anywhere after the definition.

Here, the global environment is unchanged:
```ocaml
# let ten = 10 in 2 * ten;;
- : int = 20

# ten;;
Error: Unbound value ten
```

Evaluating `ten` results in an error because it hasn't been added to the global environment. However, in the expression `2 * ten`, the local environment contains the definition of `ten`.

Although OCaml is an expression-oriented language, it has a few statements. The global `let` modifies the global environment by adding a name-value *binding*.

Top-level expressions are also statements because they are equivalent to `let _ =` definitions.
```ocaml
# (1.0 +. sqrt 5.0) /. 2.0;;
- : float = 1.6180339887498949

# let _ = (1.0 +. sqrt 5.0) /. 2.0;;
- : float = 1.6180339887498949
```
<!--
With respect to the environment, there are no means to:
- List its contents
- Clear its contents
- Remove a definition
- Reset it to an earlier state
-->
### Inner Shadowing

Once you create a name, define it, and bind it to a value, it does not change. That said, a name can be defined again to create a new binding:
```ocaml
# let i = 21;;
val i : int = 21

# let i = 7 in i * 2;;
- : int = 14

# i;;
- : int = 21
```

The second definition [*shadows*](https://en.wikipedia.org/wiki/Variable_shadowing) the first. Inner shadowing is limited to the local definition's scope. Therefore, anything written after will still take the previous definition, as shown above. Here, the value of `i` hasn't changed. It's still `21`, as defined in the first expression. The second expression binds `i` locally, inside `i * 2`, not globally.

<!--
A name-value pair in a local expression *shadows* a binding with the same name in the global environment. In other words, the local binding temporarily hides the global one, making it inaccessible, but it doesn't change it.
-->

### Same-Level Shadowing

Another kind of shadowing takes place when there are two definitions with the same name at the same level.
```ocaml
# let h = 2 * 3;;
val h : int = 6

# let e = h * 7;;
val e : int = 42

# let h = 7;;
val h : int = 7

# e;;
- : int = 42
```

There are now two definitions of `h` in the environment. The first `h` is unchanged. When the second `h` is defined, the first one becomes unreachable. <!--This means anything written after the second definition uses its value, but functions written *before* the second definition still use the first, even if called later.-->

## Function as Values

In OCaml, functions are values. This is the key concept of [functional programming](https://en.wikipedia.org/wiki/Functional_programming). In this context, it is also possible to say that OCaml has [first-class](https://en.wikipedia.org/wiki/First-class_function) functions.
<!--
For now, let's put aside those definitions and instead start playing with functions. Their meaning will arise from experience. Once things make sense, using these terms is just a means to interact with the community.

This is a big takeaway. We believe functional programming (_ergo_ OCaml) is best understood by practising it rather than reading about it. Just like skateboarding, cooking, or woodworking. Learning by doing is not only possible, it is usually the easiest and the best way to start. Because in the end, the goal is to write OCaml code, not to be able to give the correct definition of abstract terms.
-->
## Applying Functions

When several expressions are written side by side, the leftmost one should be a function. All the others are arguments. In OCaml, no parentheses are needed to express passing an argument to a function. Parentheses serve a single purpose: associating expressions to create subexpressions.
```ocaml
# max (21 * 2) (int_of_string "713");;
- : int = 713
```

The `max` function returns the largest of its two arguments, which are:
- `42`, the result of `21 * 2`
- `713`, the result of `int_of_string "713"`

When creating subexpressions, using `begin ... end` is also possible. This is the same as using brackets `( ... )`. As such, the above could also be rewritten and get the same result:

```ocaml
# max begin 21 * 2 end begin int_of_string "713" end;;
- : int = 713
```

```ocaml
# String.starts_with ~prefix:"state" "stateless";;
- : bool = true
```

Some functions, such as `String.starts_with` have labelled parameters. Labels are useful when a function has several parameters of the same type; naming arguments allows to guess their purpose. Above, `~prefix:"state"` indicates `"state"` is passed as labelled argument `prefix`.

Labelled and optional parameters are detailed in the [Labelled Arguments](/docs/labels) tutorial.

There are two alternative ways to apply functions.

### The Application Operator

The application operator `@@` operator.
```ocaml
# sqrt 9.0;;
- : float = 3.

# sqrt @@ 9.0;;
- : float = 3.
```

The `@@` application operator applies an argument (on the right) to a function (on the left). It is useful when chaining several calls, as it avoids writing parentheses, which creates easier-to-read code. Here is an example with and without parentheses:
```ocaml
# int_of_float (sqrt (float_of_int (int_of_string "81")));;
- : int = 9

# int_of_float @@ sqrt @@ float_of_int @@ int_of_string "81";;
- : int = 9
```

### The Pipe Operator

The pipe operator (`|>`) also avoids parentheses but in reversed order: function on right, argument on left.
```ocaml
# "81" |> int_of_string |> float_of_int |> sqrt |> int_of_float;;
- : int = 9
```
This is just like a Unix shell pipe.

## Anonymous Functions

Functions don't have to be bound to a name unless they are [recursive](#recursive-functions). Take these examples:
```ocaml
# fun x -> x;;
- : 'a -> 'a = <fun>

# fun x -> x * x;;
- : int -> int = <fun>

# fun s t -> s ^ " " ^ t ;;
- : string -> string-> string = <fun>

# function [] -> None | x :: _ -> Some x;;
- : 'a list -> 'a option = <fun>
```

Function values not bound to names are called _[anonymous functions](https://en.wikipedia.org/wiki/Anonymous_function)_.

In order, here is what they are:
- The identity function, which takes anything and returns it unchanged
- The square function, which takes an integer and returns it squared
- The function that takes two strings and returns their concatenation with a space character in between
- The function that takes a list and either returns `None`, if the list is empty, or returns its first element.

Anonymous functions are often passed as arguments to other functions.
```ocaml
# List.map (fun x -> x * x) [1; 2; 3; 4];;
- : int list = [1; 4; 9; 16]
```

## Defining Global Functions

You can globally bind a function to a name using a global definition.
```ocaml
# let f = fun x -> x * x;;
val f : int -> int = <fun>
```
The expression, which happens to be a function, is turned into value and bound to a name. Here is another way to do the same thing:
```ocaml
# let g x = x * x;;
val g : int -> int = <fun>
```

The former explicitly binds the anonymous function to a name. The latter uses a more compact syntax and avoids the `fun` keyword and the arrow symbol.

## Defining Local Functions

A function may be defined locally.
```ocaml
# let sq x = x * x in sq 7 * sq 7;;
- : int = 2401

# sq;;
Error: Unbound value sq
```

Calling `sq` gets an error because it was only defined locally.

The function `sq` is only available inside the `sq 7 * sq 7` expression.

Although local functions are often defined inside the function's scope, this is not a requirement.

## Closures

This example illustrates a [*closure*](https://en.wikipedia.org/wiki/Closure_(computer_programming)) using [Same-Level Shadowing](#same-level-shadowing)
```ocaml
# let j = 2 * 3;;
val j : int = 6

# let k x = x * j;;
val k : int -> int = <fun>

# k 7;;
- : int = 42

# let j = 7;;
val j : int = 7

# k 7;; (* What is the result? *)
- : int = 42
```

Here is how this makes sense:
1. Constant `j` is defined, and its value is 6.
1. Function `k` is defined. It has a single parameter `x` and returns the value of `x * j`.
1. Compute `k` of 7, and its value is 42
1. Create a new definition `j`, shadowing the first one
1. Compute `k` of 7 again, the result is the same: 42

Although the new definition of `j` *shadows* the first one, the original remains the one the function `k` uses. The `k` function's environment captures the first value of `j`, so every time you apply `k` (even after the second definition of `j`), you can be confident the function will behave the same.

However, all future expressions will use the new value of `j` (`7`), as shown here:
```ocaml
# let m = j * 3;;
val m : int = 21
```

Partially applying arguments to a function also creates a new closure.
```ocaml
# let max_42 = max 42;;
val max_42 : int -> int = <fun>
```

Inside the `max_42` function, the environment contains an additional binding between the first parameter of `max` and the value 42.

## Recursive Functions

In order to perform iterated computations, a function may call itself. Such a function is called _recursive_.
```ocaml
# let rec fibo n =
    if n <= 1 then n else fibo (n - 1) + fibo (n - 2);;
val fibo : int -> int = <fun>

# let u = List.init 10 Fun.id;;
val u : int list = [0; 1; 2; 3; 4; 5; 6; 7; 8; 9]

# List.map fibo u;;
- : int list = [0; 1; 1; 2; 3; 5; 8; 13; 21; 34]
```

This is a classic (and very inefficient) way to compute [Fibonacci](https://en.wikipedia.org/wiki/Fibonacci_sequence) numbers. The number of recursive calls created doubles at each call, which creates exponential growth.

In OCaml, recursive functions must be defined and explicitly declared by using `let rec`. It is not possible to accidentally create a recursive function, and recursive functions can't be anonymous.

**Note**: `List.init` is a standard library function that allows you to create a list by applying a given function to a sequence of integers, and `Fun.id` is the identity function, which returns its argument unchanged. We created a list with the numbers 0 - 9 and named it `u`. We applied the `fibo` function to every element of the list using `List.map`.

This version does a better job:
```ocaml
# let rec fib_loop m n i =
    if i = 0 then m else fib_loop n (n + m) (i - 1);;
val fib_loop : int -> int -> int -> int = <fun>

# let fib = fib_loop 0 1;;
val fib : int -> int = <fun>

# List.init 10 Fun.id |> List.map fib;;
- : int list = [0; 1; 1; 2; 3; 5; 8; 13; 21; 34]
```

The first version `fib_loop` has two extra parameters: the two previously computed Fibonacci numbers.

The second version `fib` uses the first two Fibonacci numbers as initial values. There is nothing to be computed when returning from a recursive call, so this enables the compiler to perform an optimisation called [tail call elimination](https://en.wikipedia.org/wiki/Tail_call). <!--This turns recursivity into imperative iteration in the generated native code and leads to improved performances.-->

**Note**: Notice that the `fib_loop` function has three parameters `m n i` but when defining `fib` only two arguments were passed `0 1`, using partial application.

## Functions with Multiple Parameters

### Defining Functions with Multiple Parameters

To define a function with multiple parameters, each must be listed between the name of the function (right after the `let` keyword) and the equal sign, separated by space:
```ocaml
# let sweet_cat x y = x ^ " " ^ y;;
val sweet_cat : string -> string -> string = <fun>

# sweet_cat "kitty" "cat";;
- : string = "kitty cat"
```

### Anonymous Functions with Multiple Parameters

We can use anonymous functions to define the same function in a different way:
```ocaml
# let sour_cat = fun x -> fun y -> x ^ " " ^ y;;
val sour_cat : string -> string -> string = <fun>

# sour_cat "kitty" "cat";;
- : string = "kitty cat"
```

Observe `sweet_cat` and `sour_cat` have the same body: `x ^ " " ^ y`. They only differ in the way parameters are listed:
1. As `x y` between name and `=` in `sweet_cat`
2. As `fun x -> fun y ->` after `=` in `sour_cat` (and nothing but name before `=`)

Also observe that `sweet_cat` and `sour_cat` have the same type: `string -> string -> string`.

If you check the assembly code generated using [compiler explorer](https://godbolt.org/), you'll see it is the same for both functions.

The way `sour_cat` is written corresponds more explicitly to the behaviour of both functions. The name `sour_cat` is bound to an anonymous function having parameter `x` and returning an anonymous function having parameter `y` and returning `x ^ " " ^ y`.

The way `sweet_cat` is written is an abbreviated version of `sour_cat`. Such a way of shortening syntax is called [syntactic sugar](https://en.wikipedia.org/wiki/Syntactic_sugar).

### Partial Application and Closures

We want to define functions of type `string -> string` that appends `"kitty "` in front of its arguments. This can be done using `sour_cat` and `sweet_cat`
```ocaml
# let sour_kitty x = sour_cat "kitty" x;;
val sour_kitty : string -> string = <fun>

# let sweet_kitty = fun x -> sweet_cat "kitty" x;;
val sweet_kitty : string -> string = <fun>

# sour_kitty "cat";;
- : string = "kitty cat"

# sweet_kitty "cat";;
- : string = "kitty cat"
```

However, both definitions can be shortened using something called _partial application_
```ocaml
# let sour_kitty = sour_cat "kitty";;
val sour_kitty : string -> string = <fun>

# let sweet_kitty = sweet_cat "kitty";;
val sweet_kitty : string -> string = <fun>
```

Since a multiple-parameter function is a series of nested single-argument functions, you don't have to pass all arguments at once.

Passing a single argument to `sour_kitty` or `sweet_kitty` returns a function of type `string -> string`. 
 The first argument, here `"kitty"`, is captured and the result is a [closure](#closures).

These expressions have the same value:
- `fun x -> sweet_cat "kitty" x`
- `sweet_cat "kitty"`

### Types of Functions of Multiple Parameters

Let's look at the types here:
```ocaml
# let dummy_cat : string -> (string -> string) = sweet_cat;;
val dummy_cat : string -> string -> string = <fun>
```

Here the type annotation `: string -> (string -> string)` is used to explicitly state the type of `dummy_cat`.

However, OCaml answers claiming the fresh definition has type `string -> string -> string`. This is because types `string -> string -> string` and `string -> (string -> string)` are the same.

With parentheses, it is obvious that a multiple-argument function is a single-parameter function that returns an anonymous function with one parameter removed.

Putting the parentheses the other way does not work:
```ocaml
# let bogus_cat : (string -> string) -> string = sweet_cat;;
Error: This expression has type string -> string -> string
       but an expression was expected of type (string -> string) -> string
       Type string is not compatible with type string -> string
```

Functions having type `(string -> string) -> string` take a function as a parameter. The function `sweet_cat` has a function as a result, not a function as a parameter.

The type arrow operator [_associates to the right_](https://en.wikipedia.org/wiki/Operator_associativity). Function types without parentheses should be treated as if they have parentheses to the right in the same way that the type of `dummy_cat` was declared above. Except they are not displayed.

### Tuples as Function Parameters

In OCaml, a *tuple* is a data structure used to group a fixed number of values, which can be of different types. Tuples are surrounded by parentheses, and the elements are separated by commas. Here's the basic syntax to create and work with tuples in OCaml:
```ocaml
# ("felix", 1920);;
- : string * int = ("felix", 1920)
```

It is possible to use the tuple syntax to specify function parameters. Here is how it can be used to define yet another version of the running example:
```ocaml
# let spicy_cat (x, y) = x ^ " " ^ y;;
val spicy_cat : string * string -> string = <fun>

# spicy_cat ("hello", "world");;
- : string = "hello world"
```

It looks like two arguments have been passed: `"hello"` and `"world"`. However, only one, the `("hello", "world")` tuple, has been passed. Inspection of the generated assembly would show it isn't the same function as `sweet_cat`. It contains some more code. The contents of the tuple passed to `spicy_cat` (`x` and `y`) must be extracted before evaluation of the `x ^ " " ^ y` expression. This is the role of the additional assembly instructions.

In many imperative languages, the `spicy_cat ("hello", "world")` syntax reads as a function call with two arguments; but in OCaml, it denotes applying the function `spicy_cat` to a tuple containing `"hello"` and `"world"`.


### Currying and Uncurrying

In the previous sections, two kinds of multiple-parameter functions have been presented.
- Functions returning a function, such as `sweet_cat` and `sour_cat`
- Functions taking a tuple as a parameter, such as `spicy_cat`

Interestingly, both kinds of functions provide a way to pass several pieces of data while being functions with a single parameter. From this perspective, it makes sense to say: “All functions have a single argument.”

This goes even further. It is always possible to translate back and forth between functions that look like `sweet_cat` (or `sour_cat`) and functions that look like `spicy_cat`.

These translations have names:
* [Currying](https://en.wikipedia.org/wiki/Currying) goes from the `spicy_cat` form into the `sour_cat` (or `sweet_cat`) form.
* Uncurrying goes from the `sour_cat` (or `sweet_cat`) form into the `spicy_cat` form.

It also said that `sweet_cat` and `sour_cat` are _curried_ functions whilst `spicy_cat` is _uncurried_.

Functions with the following types can be translated back and forth:
- `string -> (string -> string)` &mdash; curried function type
- `string * string -> string` &mdash; uncurried function type

These translations are attributed to the 20th-century logician [Haskell Curry](https://en.wikipedia.org/wiki/Haskell_Curry).

Here, this is shown using `string` as an example, but it applies to any group of three types.

You can change the curried form into the uncurried form when refactoring, or the other way round.

However, it is also possible to implement one from the other to have both forms available:
```ocaml
# let uncurried_cat (x, y) = sweet_cat x y;;
val uncurried_cat : string * string -> string = <fun>

# let curried_cat x y = uncurried_cat (x, y);;
val curried_cat : string -> string -> string = <fun>
```

<!-- Currying and uncurrying can be understood as operations acting on functions the same way addition and subtraction are operations acting on numbers. -->

In practice, curried functions are the default because:
- They allow partial application
- No parentheses or commas
- No pattern matching over a tuple takes place

## Functions With Side Effects

To explain side effects, we need to define what *domain* and *codomain* are. Let's look at an example:
```ocaml
# string_of_int;;
- : int -> string = <fun>
```
For the function `string_of_int`:
- Its *domain* is `int`, the type of its parameters
- The *codomain* is `string`, the type of its results

In other words, the *domain* is left of the `->` and the *codomain* is on the right. These terms help avoid saying the "type at the right" or "type at the left" of a function's type arrow.

Some functions operate on data outside of their domain or codomain.
This behaviour is called an effect, or a side effect.

Doing input and output (I/O) with the operating system is the most common form of side effects. <!-- Input is out-of-domain data and output is out-of-codomain data. --> The result of functions returning random numbers (such as `Random.bits` does) or the current time (such as `Unix.time` does) is influenced by external factors, which is also called an effect. <!-- The external factor is out-of-domain input. -->

Similarly, any observable phenomena triggered by the computation of a function is an out-of-codomain output.

In practice, what is considered an effect is an engineering choice. In most circumstances, system I/O operations are considered as effects, unless they are ignored. The heat emitted by the processor when computing a function isn't usually considered a relevant side-effect, except when considering energy-efficient design.

In the OCaml community, as well as in the wider functional programming community, functions are often said to be either [pure](https://en.wikipedia.org/wiki/Pure_function) or impure. The former does not have side effects, the latter does. This distinction makes sense and is useful. Knowing what the effects are, and when are they taking place, is a key design consideration. However, it is important to remember this distinction always assumes some sort of context. Any computation has effects, and what is considered a relevant effect is a design choice.

Since, by definition, effects lie outside function types, a function type can't reflect a function's possible effects. However, it is important to document a function's intended side effects. Consider the `Unix.time` function. It returns the number of seconds elapsed since January 1, 1970.
```ocaml
# Unix.time ;;
- : unit -> float = <fun>
```

**Note**: If you're getting an `Unbound module error` in macOS, run this first: `#require "unix";;`.

The result of the `Unix.time` function is determined only by external factors. To perform the side effect, the function must be applied to an argument. Since no data needs to be passed, the argument is the `()` value.

Consider `print_endline`. It prints the string it was passed to standard output, followed by a line termination.
```ocaml
# print_endline;;
- : string -> unit = <fun>
```
Since the purpose of the function is only to produce an effect, it has no meaningful data to return; it returns the `()` value.

This illustrates the relationship between functions that have side effects and the `unit` type. The presence of the `unit` type does not indicate the presence of side effects. The absence of the `unit` type does not indicate the absence of side effects. But when no data needs to be passed as input or can be returned as output, the `unit` type is used.

## What Makes Functions Different From Other Values

Functions are like other values; however, there are restrictions:

1. Function values cannot be displayed in interactive sessions. The placeholder `<fun>` is displayed instead. This is because there is nothing meaningful to print. Once parsed and typed-checked, OCaml discards the function's source code and nothing remains to be printed.
```ocaml
# sqrt;;
- : float -> float = <fun>
```

2. Equality between functions can't be tested.
```ocaml
# pred;;
- : int -> int = <fun>

# succ;;
- : int -> int = <fun>

# pred = succ;;
Exception: Invalid_argument "compare: functional value".
```

There are two main reasons explaining this:
- There is no algorithm that takes two functions and determines if they return the same output when provided the same input.
- Assuming it was possible, such an algorithm would declare that implementations of quicksort and bubble sort are equal. That would mean one could replace the other, and that may not be wise.
<!--
It may seem counterintuitive that classes of objects of the same kind (i.e., having the same type) exist where equality between objects does not make sense. High school mathematics does not provide examples of those classes. But in the case of computing procedures seen as functions, equality isn't the right tool to compare them.
-->
<!--
- Pattern matching does not allow inspecting a function. Catch-all patterns can match against a function, but it is useless.
```ocaml
# match Fun.id with _ -> ();;
- : unit = ()
```
-->
## Conclusion

At the heart of OCaml lies the concept of the environment. The environment works as an ordered, append-only, key-value store. This means that items cannot be removed. Furthermore, it maintains order by preserving the sequence of available definitions.

When we use a `let` statement, we introduce zero, one, or more name-value pairs into the environment. Similarly, when applying a function to some arguments, we extend the environment by adding names and values corresponding to its arguments.
<!--
One may wonder:

> Why is function-as-values the key concept of functional programming?

The answer to this question goes beyond the scope of this tutorial. This comes from the [λ-calculus](https://en.wikipedia.org/wiki/Lambda_calculus), the mathematical theory underneath functional programming. In that formalism, there are nothing but functions. Everything, including data, is a function, and computation reduces to parameter passing. In functional programming (and thus OCaml), having functions and values at the same level is an invitation to think this way. This is different from the imperative programming approach where everything reduces to reading and writing into the memory.
-->
