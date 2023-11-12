---
id: values-and-functions
title: Values and Functions
description: |
  Functions, values, definitions, environments, scopes, closures, and shadowing. This tutorial will help you master the fundamentals.
category: "Introduction"
---

# Values and Functions

## Introduction

This tutorial teaches the skills needed to handle expressions, values, and names. You'll learn the ability to write expressions, name values or leave them anonymous, appropriately scope names, handle multiple definitions of the same name, create and use closures, and produce or avoid side effects.

In OCaml, functions are values. In comparison to other mainstream languages, this creates a richer picture between expressions, values, and names. The approach in this tutorial is to acquire the related capabilities and understanding by interacting with OCaml in UTop. This hands-on experience is intended to build understanding by experimentation rather than starting with the definition of the concepts.

> Note: The [Introduction to the OCaml Toplevel](https://ocaml.org/docs/toplevel-introduction) guide covers how to use UTop.

It would benefit the reader to write variations around the examples provided to strengthen understanding. The topics discussed are not limited to interactive execution of OCaml expressions. However, we believe they are easier to understand within the dynamics of interaction with the OCaml interpreter.

The first four sections of this tutorial address non-function values. The following sections, starting at [Function as Values](#function-as-values), address functions.

**Prerequisites**: Ensure you have completed the [Get Started](https://ocaml.org/docs/installing-ocaml) series before proceeding with this tutorial.

<!--
When presenting OCaml or another functional programming language, it is often said: “Functions are treated as first-class citizens.” Without further explanation or context, this may not be helpful (it wasn't to me). The goal of this tutorial is to acquire the capabilities implied and entailed by that sentence. In turn, this should explain it:
- Write all kinds of definitions, for all kinds of values, in all different ways
- Accurately assess the scope of any definition
- Avoid being fooled by shadowed definitions and scopes
- Explain what a closure is and why it is so named
- Partially apply functions, create closures, and pass them as values
- Curry and uncurry functions
- Use the `unit` type as a function parameter or return value, when needed
-->

## What is a Value?

Like most functional programming languages, OCaml is an [expression-oriented](https://en.wikipedia.org/wiki/Expression-oriented_programming_language) programming language. That means programs are expressions. Actually, almost everything is an expression. In OCaml, there are no statements that specify actions to be taken on data. All computations must be through expression evaluation. Computing expressions produce values. Here are a few examples of expressions, their type, and the resulting values. Some include computation and some don't:
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

Every expression can be named. This is the purpose of the `let … = … ` statement. The name is on the left; the expression is on the right.
* If the expression can be evaluated, it takes place right away.
* Otherwise, the expression is turned into a value as-is. That's the case of function definition.

Global definitions are those entered at the top level. This is what happens when writing a definition in UTop:
```ocaml
# let the_answer = 2 * 3 * 7;;
val the_answer : int = 42
```

Here, `the_answer` is the global definition with a value of 42.

When a variant type has a single constructor, it is possible to combine pattern matching and definitions. The pattern is written between the `let` keyword and the equal sign. A very common case is pairs. It allows the creation of two names with a single `let`.
```ocaml
# let (x, y) = List.split [(1, 2); (3, 4); (5, 6); (7, 8)];;
val x : int list = [1; 3; 5; 7]
val y : int list = [2; 4; 6; 8]
```

This works for any single constructor variant. Here is a type named `tree` with a variable number of branches:
```ocaml
# type 'a tree = Node of 'a * 'a tree list;;
type 'a tree = Node of 'a * 'a tree list

# let t = Node (1, [Node (2, []); Node (3, []); Node (4, [])]);;
val t : int tree = Node (1, [Node (2, []); Node (3, []); Node (4, [])])

# let rec tree_map f (Node (x, u)) = Node (f x, List.map (tree_map f) u);;
val tree_map : ('a -> 'b) -> 'a tree -> 'b tree = <fun>

# tree_map (fun x -> x * x) t;;
- : int tree = Node (1, [Node (4, []); Node (9, []); Node (16, [])])
```

> Note: Above, `'a` means “any type.” It is called a *type parameter* and is pronounced like the Greek letter α (“alpha”). This type parameter will be replaced by a type. The same goes for `'b` ("beta"), `'c` ("gamma"), etc. Any letter preceded by a `'` is a type parameter, also known as a [type variable](https://en.wikipedia.org/wiki/Type_variable).

Because records are implicitly single-constructor variants, this also applies to them:
```ocaml
# type name = { first : string; last: string };;
type name = { first : string; last : string; }

# let robin = { first = "Robin"; last = "Milner" };;
val robin : name = {first = "Robin"; last = "Milner"}

# let { first; last } = robin;;
val first : string = "Robin"
val last : string = "Milner"
```

A special case of combined definition and pattern matching involves the `unit` type:
```ocaml
# let () = print_endline "ha ha";;
ha ha
```

> Note: As explained in the [Tour of OCaml](/docs/tour-of-ocaml) tutorial, the `unit` type has a single value `()`, which is pronounced "unit."

Above, the pattern does not contain any identifier, meaning no name is defined. The expression is evaluated, the side effect takes place (printing `ha ha` to standard output), no definition is created, and no value is returned. Writing that kind of pseudo-definition only expresses interest in the side effects.
```ocaml
# print_endline "ha ha";;
ha ha
- : unit = ()

# let _ = print_endline  "ha ha";;
ha ha
- : unit = ()
```

As seen in the last example, the catch-all pattern (`_`) can be used in definitions. The following example illustrates its use, which is distinct from the `()` pattern:
```ocaml
# let (_, y) = List.split [(1, 2); (3, 4); (5, 6); (7, 8)];;
val y : int list = [2; 4; 6; 8]
```
This construction creates two lists. The first is formed by the left element of each pair. The second is formed by the right element. Assuming we're only interested in the right elements, we give the name `y` to that list and discard the first by using `_`.

## Local Definitions

Local definitions are like global definitions, except the name is only bound inside an expression. They are introduced by the `let … = … in …` expression. The name bound before the `in` keyword is only bound in the expression after the `in` keyword.
```ocaml
# let b = 2 * 3 in b * 7;;
- : int = 42

# b;;
Error: Unbound value b
```

Here, the name `b` is bound to `6` inside the expression `b * 7`. A couple of remarks:
- No global definition is introduced in this example, which is why we get an error.
- Computation of `2 * 3` will always take place before `b * 7`.

Local definitions can be chained (one after another) or nested (one inside another). Here is an example of chaining:
```ocaml
# let b = 2 * 3 in
  let c = b * 7 in
  b * c;;
- : int = 252

# b;;
Error: Unbound value b
# c;;
Error: Unbound value c
```

This is how scoping works here:
- `b` is bound to `6` inside `let c = b * 7 in b * c`
- `c` is bound to `42` inside `b * c`

Here is an example of nesting:
```ocaml
# let b =
    let c = 2 * 3 in
    c * 5 in
  b * 7;;
- : int = 210

# b;;
Error: Unbound value b
# c;;
Error: Unbound value c
```
Here is how scoping works:
- `c` is bound to `6` inside `c * 5`
- `b` is bound to `30` inside `b * 7`

Arbitrary combinations of chaining or nesting are allowed.

In both examples `b` and `c` are local definitions.

## Scopes and Environments

Without oversimplifying, an OCaml program is a sequence of expressions or global `let` definitions. These items are said to be at the _top-level_. An OCaml REPL, such as UTop, is called a toplevel because that's where typed definitions go.

Execution evaluates each item from top to bottom.

At any time during evaluation, the _environment_ is the ordered sequence of available definitions.

Here, the name `tau` is added to the top-level environment.
```ocaml
# let tau = 6.28318;;
val tau : float = 6.28318
```

The scope of `tau` is global. This name is available anywhere after the definition.

Here, the global environment is unchanged:
```ocaml
# let pi = 3.14159 in 2. *. pi;;
- : float = 6.28318

# pi;;
Error: Unbound value pi
```

Calling `pi` results in an error because it hasn't been added to the global environment. However, with respect to the expression `2. *. pi`, the environment is different because it contains the definition of `pi`. Local definitions create local environments.

A definition's scope is the set of environments where it is reachable.

Although OCaml is an expression-oriented language, it is not entirely free of statements. The global `let` is a statement that may change the state of the global environment by adding a name-value *binding*. In some sense, that `let` is the only statement OCaml has. Note that top-level expressions also fall into that category because they are equivalent to `let _ =` definitions.
```ocaml
# (1.0 +. sqrt 5.0) /. 2.0;;
- : float = 1.6180339887498949

# let _ = (1.0 +. sqrt 5.0) /. 2.0;;
- : float = 1.6180339887498949
```

With respect to the environment, there are no means to:
- List its contents
- Clear its contents
- Remove a definition
- Reset it to an earlier state

### Inner Shadowing

[*Shadowing*](https://en.wikipedia.org/wiki/Variable_shadowing) is a subtle concept. As you learned in the [Tour of OCaml](/docs/tour-of-ocaml), bindings are immutable. Once you create a name, define it, and bind it to a value, it does not change. That said, a name can be defined again to create a new binding. This is known as shadowing. The second definition *shadows* the first.

A local definition may shadow any previous definition. Inner shadowing is limited to the local definition's scope. Therefore, anything written after will still take the previous definition, as shown:
```ocaml
# let d = 21;;
val d : int = 21

# let d = 7 in d * 2;;
- : int = 14

# d;;
- : int = 21
```

Here, the value of `d` hasn't changed. It's still `21`, as defined in the first expression. The second expression binds `d` locally, inside `d * 2`, not globally.

A name-value pair in a local expression *shadows* a binding with the same name in the global environment. In other words, the local binding temporarily hides the global one, making it inaccessible, but it doesn't change it.

### Same-Level Shadowing

Another kind of shadowing takes place when there are two definitions with the same name at the same level.
```ocaml
# let a = 2 * 3;;
val a : int = 6

# let e = a * 7;;
val e : int = 42

# let a = 7;;
val a : int = 7

# a;;
- : int = 7

# e;;
- : int = 42
```

In this example, `a` is defined twice. The key thing to understand is that `a` is *not updated*. It looks as if the value of `a` has changed, but it hasn't. When the second `a` is defined, the first one becomes unreachable, but it remains in the global environment. This means anything written after the second definition uses its value, but functions written *before* the second definition still use the first, even if called later.

## Function as Values

As already stated, in OCaml, functions are values. This is the key concept of [functional programming](https://en.wikipedia.org/wiki/Functional_programming). In this context, it is also possible to say that OCaml has [first-class](https://en.wikipedia.org/wiki/First-class_function) functions or that functions are [first-class citizens](https://en.wikipedia.org/wiki/First-class_citizen).

For now, let's put aside those definitions and instead start playing with functions. Their meaning will arise from experience. Once things make sense, using these terms is just a means to interact with the community.

This is a big takeaway. We believe functional programming (_ergo_ OCaml) is best understood by practising it rather than reading about it. Just like skateboarding, cooking, or woodworking. Learning by doing is not only possible, it is usually the easiest and the best way to start. Because in the end, the goal is to write OCaml code, not to be able to give the correct definition of abstract terms.

## Applying Functions

When several expressions are written side by side, the leftmost one should be a function. All the others are parameters. In OCaml, no parentheses are needed to express passing an argument to a function. Parentheses serve a single purpose: associating expressions to create subexpressions.
```ocaml
# max (21 * 2) (int_of_string "713");;
- : int = 713
```

There are two alternative ways to apply functions: using the *application* `@@` operator or the *pipe* `|>` operator.
```ocaml
# sqrt 9.0;;
- : float = 3.

# sqrt @@ 9.0;;
- : float = 3.
```

The `@@` application operator applies a parameter (on the right) to a function (on the left). It is useful when chaining several calls, as it avoids writing parentheses, which creates easier-to-read code. Here is an example with and without parentheses:
```ocaml
# int_of_float (sqrt (float_of_int (int_of_string "81")));;
- : int = 9

# int_of_float @@ sqrt @@ float_of_int @@ int_of_string "81";;
- : int = 9
```

The pipe operator (`|>`) also avoids parentheses but in reversed order: function on right, parameter on left.
```ocaml
# "81" |> int_of_string |> float_of_int |> sqrt |> int_of_float;;
- : int = 9
```
This is just like a Unix shell pipe.

## Anonymous Functions

As citizens of the same level as other values, functions don't have to be bound to a name to exist (although some must, but this will be explained later). Function values not bound to names are called _[anonymous functions](https://en.wikipedia.org/wiki/Anonymous_function)_. Here are a couple of examples:
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

In order, here is what they are:
- The identity function, which takes anything and returns it unchanged
- The square function, which takes an integer and returns it squared
- The function that takes two strings and returns their concatenation with a space character in between
- The function that takes a list and either returns `None`, if the list is empty, or returns the list with its first element removed.

Anonymous functions are often passed as parameters to other functions.
```ocaml
# List.map (fun x -> x * x) [1; 2; 3; 4];;
- : int list = [1; 4; 9; 16]
```

## Defining Global Functions

Defining a global function is exactly like binding a value to a name. The expression, which happens to be a function, is turned into value and bound to a name.
```ocaml
# let f = fun x -> x * x;;
val f : int -> int = <fun>

# let g x = x * x;;
val g : int -> int = <fun>
```

These two definitions are the same. The former explicitly binds the anonymous function to a name. The latter uses a more compact syntax and avoids the `fun` keyword and the arrow symbol.

## Defining Local Functions

A function may be defined locally. Just like any local definition, the function is only available inside its attached expression. Although local functions are often defined inside the function's scope, this is not a requirement. Here is a local function inside an expression:
```ocaml
# let sq x = x * x in sq 7 * sq 7;;
- : int = 2401

# sq;;
Error: Unbound value sq
```

Calling `sq` gets an error because it was only defined locally.

## Closures

The following example illustrates a [*closure*](https://en.wikipedia.org/wiki/Closure_(computer_programming)) using [Same-Level Shadowing](#same-level-shadowing):
```ocaml
# let a = 2 * 3;;
val a : int = 6

# let f x = x * a;;
val f : int -> int = <fun>

# f 7;;
- : int = 42

# let a = 7;;
val a : int = 7

# f 7;; (* What is the result? *)
- : int = 42
```

Here is how this makes sense:
1. Constant `a` is defined, and its value is 6.
1. Function `f` is defined. It takes a single parameter `x` and returns its product by `a`.
1. Compute `f` of 7, and its value is 42
1. Create a new definition `a`, shadowing the first one
1. Compute `f` of 7 again, the result is the same: 42

Although the new definition of `a` *shadows* the first one, the original remains the one the function `f` uses. The `f` function's environment captures the first value of `a`, so every time you apply `f` (even after the second definition of `a`), you can be confident the function will behave the same. A closure is a pair containing the function code and an environment.

However, all future expressions will use the new value of `a` (`7`), as shown here:
```ocaml
# let b = a * 3;;
val b : int = 21
```

Partially applying parameters to a function also creates a new closure. The environment is updated, but the function is unchanged.
```ocaml
# let max_42 = max 42;;
val max_42 : int -> int = <fun>
```

Inside the `max_42` function, the environment contains an additional binding between the first parameter of `max` and the value 42.

## Recursive Functions

In order to perform iterated computations, a function may call itself. Such a function is called _recursive_. In OCaml, recursive functions must be defined and explicitly declared by using `let rec`. It is not possible to accidentally create recursion loops between functions. As a consequence, recursive functions can't be anonymous.

The classic (and very inefficient) way to present recursion is using the function that computes [Fibonacci](https://en.wikipedia.org/wiki/Fibonacci_sequence) numbers.
```ocaml
# let rec fibo n = if n <= 1 then n else fibo (n - 1) + fibo (n - 2);;
val fibo : int -> int = <fun>

# let u = List.init 10 Fun.id;;
val u : int list = [0; 1; 2; 3; 4; 5; 6; 7; 8; 9]

# List.map fibo u;;
- : int list = [0; 1; 1; 2; 3; 5; 8; 13; 21; 34]
```

This version of `fibo` is inefficient because the number of recursive calls created doubles at each call, which creates exponential growth.

> Note: `List.init` is a standard library function that allows you to create a list by applying a given function to a sequence of integers, and `Fun.id` is the identity function, which returns its argument unchanged. We created a list with the numbers 0 - 9 and named it `u`. We applied the `fibo` function to every element of the list using `List.map`.

This version does a better job:
```ocaml
# let rec fib_loop m n i = if i = 0 then m else fib_loop n (n + m) (i - 1);;
val fib_loop : int -> int -> int -> int = <fun>

# let fib = fib_loop 0 1;;
val fib : int -> int = <fun>

# List.init 10 Fun.id |> List.map fib;;
- : int list = [0; 1; 1; 2; 3; 5; 8; 13; 21; 34]
```

The first version `fib_loop` takes two extra parameters: the two previously computed Fibonacci numbers.

The second version `fib` uses the first two Fibonacci numbers as initial values. There is nothing to be computed when returning from a recursive call, so this enables the compiler to perform an optimisation called [tail call elimination](https://en.wikipedia.org/wiki/Tail_call). This turns recursivity into imperative iteration in the generated native code and leads to improved performances.

> Note: Notice that the `fib_loop` function has three parameters `m n i` but when defining `fib` only two arguments were passed `0 1`, using partial application.

## Multiple Arguments Functions

### With Syntactic Sugar

*Syntactic sugar* refers to a clean, straightforward syntax. It's code shorthand that makes the code more compact.

To define a function with multiple arguments, each must be listed between the name of the function (right after the `let` keyword) and the equal sign, separated by space. Here is an example:
```ocaml
# let sweet_cat x y = x ^ " " ^ y;;
val sweet_cat : string -> string -> string = <fun>

# sweet_cat "kitty" "cat";;
- : string = "kitty cat"
```

This is how most multiple-argument functions are defined. Alternatives exist, but this should be the default.

### Without Syntactic Sugar

The function `sweet_cat` is the same as this one:
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

In reality, these two definitions are the same. If you check the assembly code generated using [compiler explorer](https://godbolt.org/), you'll see it is the same.

The way `sour_cat` is written corresponds more explicitly to the behaviour of both functions. The name `sour_cat` is bound to an anonymous function having parameter `x` and returning an anonymous function having parameter `y` and returning `x ^ " " ^ y`.

The way `sweet_cat` is written is an abbreviated version of `sour_cat`. Such a way of shortening syntax is called [syntactic sugar](https://en.wikipedia.org/wiki/Syntactic_sugar).

### Partial Application and Closures

Having multiple-argument functions as a series of nested single-argument functions is what makes partial application possible.
```ocaml
# let sour_kitty x = sour_cat "kitty" x;;
val sour_kitty : string -> string = <fun>

# let sweet_kitty = fun x -> sweet_cat "kitty kitty" x;;
val sweet_kitty : string -> string = <fun>

# sour_kitty "cat";;
- : string = "kitty cat"

# sweet_kitty "cat";;
- : string = "kitty kitty cat"
```

Both `sweet_cat` and `sour_cat` allow partial application.

Passing a single parameter to any of those functions returns a function of type `string -> string`. That result is a closure. The first argument, here `"kitty"`, is captured as if it had been in an earlier definition.

### Remove Useless Arguments

Here is another way to define `sour_kitty` and `sweet_kitty`:
```ocaml
# let sour_kitty = sour_cat "kitty";;
val sour_kitty : string -> string = <fun>

# let sweet_kitty = sweet_cat "kitty";;
val sweet_kitty : string -> string = <fun>
```

These expressions are the same:
- `fun x -> sweet_cat "kitty" x`
- `sweet_cat "kitty"`

Any function expression that declares a parameter and immediately applies it to some function sub-expression (in the example; `sweet_cat "kitty"`) is the same as the function sub-expression alone.

### Multiple-Argument Function Types

Carefully observe the following definition:
```ocaml
# let dummy_cat : string -> (string -> string) = sweet_cat;;
val dummy_cat : string -> string -> string = <fun>
```

Here the type annotation `: string -> (string -> string)` is used to explicitly state the type of `dummy_cat`. However, OCaml answers claiming the fresh definition has type `string -> string -> string`.

Here is how to make sense of this:
1. It is possible to pretend that `sweet_cat` has type `string -> (string -> string)`.
1. Types `string -> (string -> string)` and `string -> string -> string` are the same

The type `string -> string -> string` is the [pretty-printed](https://en.wikipedia.org/wiki/Prettyprint) version of `string -> (string -> string)`. The latter reflects, as described in the previous section, that a multiple-argument function is a single-parameter function that returns an anonymous function with one parameter removed.

Putting the parentheses the other way does not work:
```ocaml
# let bogus_cat : (string -> string) -> string = sweet_cat;;
Error: This expression has type string -> string -> string
       but an expression was expected of type (string -> string) -> string
       Type string is not compatible with type string -> string
```

Functions having type `(string -> string) -> string` take a function as a parameter. The function `sweet_cat` has a function as a result, not a function as a parameter.

In computer science language, the type arrow operator _associates to the right_. Function types without parentheses should be treated as if they have parentheses to the right in the same way that the type of `dummy_cat` was declared above. Except they are not displayed. This is [pretty printing](https://en.wikipedia.org/wiki/Prettyprint).

### Passing Tuples

In OCaml, a *tuple* is a data structure used to group a fixed number of values, which can be of different types. Tuples are surrounded by parentheses, and the elements are separated by commas. Here's the basic syntax to create and work with tuples in OCaml:
```ocaml
# ("felix", 1920);;
- : string * int = ("felix", 1920)
```

It is possible to use the tuple syntax to specify function parameters. Here is how it can be used to define yet another version of the running example:
```ocaml
# let spicy_cat (x, y) = x ^ " " ^ y;;
val spicy_cat : string * string -> string = <fun>
```

It behaves the same as previously.
```ocaml
# spicy_cat ("hello", "world");;
- : string = "hello world"
```

It looks like two arguments have been passed: `"hello"` and `"world"`. However, only one, the `("hello", "world")` pair, has been passed. Inspection of the generated assembly would show it isn't the same function as `sweet_cat`. It contains some more code. The contents of the pair passed to `spicy_cat` (`x` and `y`) must be extracted before evaluation of the `x ^ " " ^ y` expression. This is the role of the additional assembly instructions.

In many imperative languages, the `spicy_cat ("hello", "world")` syntax reads as a function call with two parameters; but in OCaml, it denotes applying the function `spicy_cat` to a pair containing `"hello"` and `"world"`.

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

These translations are attributed to the 20th-century logician [Haskell Curry](https://en.wikipedia.org/wiki/Haskell_Curry).

From a typing perspective, this means the following types are equivalent:
- `string -> (string -> string)` &mdash; curried function type
- `string * string -> string` &mdash; uncurried function type

Here, this is shown using `string` as an example, but it applies to any group of three types.

We will not dive any deeper into the details here, but these equivalences can be formally defined using _ad-hoc_ mathematics.

Often, currying or uncurrying are applied when refactoring the code. One form is changed into the other as an edit. However, it is also possible to implement one from the other to have both forms available:
```ocaml
# let uncurried_cat (x, y) = sweet_cat x y;;
val uncurried_cat : string * string -> string = <fun>

# let curried_cat x y = uncurried_cat (x, y);;
val curried_cat : string -> string -> string = <fun>
```

Functions can take several equivalent forms, depending on the way data is passed or returned. It is important to be able to:
* Refactor in any direction
* Have both forms starting from any of each.

Currying and uncurrying should be understood as operations acting on functions the same way addition and subtraction are operations acting on numbers.

In practice, curried functions are the default form functions should take because:
- They allow partial application
- It is less editing, no parentheses or commas
- No pattern matching over a tuple takes place

## Functions With Side Effects

To explain side effects, we need to define what *domain* and *codomain* are. Let's look at an example:
```ocaml
# string_of_int;;
- : int -> string = <fun>
```
For the function `string_of_int`:
- Its *domain* is `int`, the type of its input data.
- The *codomain* is `string`, the type of its output data.

In other words, the *domain* is left of the `->` and the *codomain* is on the right. These terms help avoid saying the "type at the right" or "type at the left" of a function's type arrow.

Some functions either take input data outside of their domain or produce data outside of their codomain. These out-of-signature data are called effects, or side effects. Input and output (I/O) are the most common forms of effects. Input is out-of-domain data and output is out-of-codomain data. However, the result of functions returning random numbers (such as `Random.bits` does) or the current time (such as `Unix.time` does) is influenced by external factors, which is also called an effect. The external factor is out-of-domain input. Similarly, any observable phenomena triggered by the computation of a function is out-of-codomain output.

In practice, what is considered an effect is an engineering choice. In most circumstances, I/O operations are considered as effects, unless they are ignored. Electromagnetic radiation emitted by the processor when computing a function isn't usually considered a relevant side-effect, except in some security-sensitive contexts. In the OCaml community, as well as in the wider functional programming community, functions are often said to be either [pure](https://en.wikipedia.org/wiki/Pure_function) or impure. The former does not have side effects, the latter does. This distinction makes sense and is useful. Knowing what the effects are, and when are they taking place, is a key design consideration. However, it is important to remember this distinction always assumes some sort of context. Any computation has effects, and what is considered a relevant effect is a design choice.

Since, by definition, effects lie outside function types, a function type can't reflect a function's possible effects. However, it is important to document a function's intended side effects. Consider the `Unix.time` function. It returns the number of seconds elapsed since January 1, 1970.
```ocaml
# Unix.time ;;
- : unit -> float = <fun>
```

> Note: If you're getting an `Unbound module error` in macOS, run this first: `#require "unix";;`.

To produce its result, no data needs to be passed to that function. The result is entirely determined by external factors. If it was passed information, it would not be used. But something must be passed as a parameter to trigger the request of the current time from the operating system.

Since the function must receive data to trigger the computation but the data is going to be ignored, it makes sense to provide the `()` value. What is discarded is meaningless in the first place.

A similar reasoning applies to functions producing an effect instead of being externally determined or influenced. Consider `print_endline`. It prints the string it was passed to standard output, followed by a line termination.
```ocaml
# print_endline;;
- : string -> unit = <fun>
```
Since the purpose of the function is only to produce an effect, it has no meaningful data to return; therefore, again, it makes sense to return the `()` value.

This illustrates the relationship between functions intended to have side effects and the `unit` type. The presence of the `unit` type does not indicate the presence of side effects. The absence of the `unit` type does not indicate the absence of side effects. But when no data needs to be passed as input or can be returned as output, the `unit` type should be used to indicate it and suggest the presence of side effects.

## Functions Are Almost as Other Values

Functions are supposed to be exactly as other values; however, there are three restrictions:

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

It may seem counterintuitive that classes of objects of the same kind (i.e., having the same type) exist where equality between objects does not make sense. High school mathematics does not provide examples of those classes. But in the case of computing procedures seen as functions, equality isn't the right tool to compare them.

3. Pattern matching does not allow inspecting a function. Catch-all patterns can match against a function, but it is useless.
```ocaml
# match Fun.id with _ -> ();;
- : unit = ()
```

## Conclusion

At the heart of OCaml lies the concept of the environment, a crucial element in its operation. To put it succinctly, the environment works as an ordered, append-only key-value store. It is notable for its append-only nature, meaning that items cannot be removed. Furthermore, it maintains order by preserving the sequence of available definitions.

When we employ a `let` statement, we introduce zero, one, or more name-value pairs into the pertinent environment. Similarly, when invoking a function with its parameters, we extend the environment by adding names and their corresponding arguments, so a closure in OCaml embodies an environment-function pairing, cementing the interconnectedness of these fundamental concepts.

During the review of this tutorial, it was asked:

> Why does having function as values define functional programming?

The answer to this question goes beyond the scope of this tutorial. However, without entering into the details, erasing the difference between functions and other values is meant to express they are the same thing. That's exactly what happens in the [λ-calculus](https://en.wikipedia.org/wiki/Lambda_calculus), the mathematical theory underneath functional programming. In that formalism, there are nothing but functions. Everything, including data, is a function, and computation reduces to parameter passing. In functional programming (and thus OCaml), having functions and values at the same level is an invitation to think this way. This is different from the imperative programming approach where everything reduces to reading and writing into the memory.
