---
id: values-and-functions
title: Values and Functions
description: |
  TBD
category: "Language"
---

# Values and Functions

## Introduction

This tutorial teaches the skills needed to handle expressions, values, and names. You'll learn the ability to write expressions, name values or leave them anonymous, appropriately scope names, handle multiple definitions of the same name, create and use closures, and produce or avoid side effects.

In OCaml, functions are values. In comparison to other mainstream languages, this creates a richer picture between expressions, values, and names. The approach in this tutorial is to acquire the related capabilities and the understanding by interacting with OCaml in UTop. This hands-on experience first is intended to build the understanding by experimentation rather than starting with the definition of the concepts.

> Note: The ["Introduction to the OCaml Toplevel" guide](https://ocaml.org/docs/toplevel-introduction) covers how to use UTop.

It would benefit the reader to write variations around the examples provided to strengthen understanding. The topics discussed are not limited to interactive execution of OCaml expressions. However, we believe they are easier to understand within the dynamics of interaction with the OCaml interpreter.

**Prerequisites**: This is an intermediate-level tutorial. Ensure you have have [completed the “Get Started” series](https://ocaml.org/docs/installing-ocaml) before proceeding with this tutorial.

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

## What is a Value

Like most functional programming languages, OCaml is an [expression-oriented](https://en.wikipedia.org/wiki/Expression-oriented_programming_language) programming language. That means programs are expressions. Actually, almost everything is an expression. Computing them produce values, that is the unique mean to do something. Here are a few examples of expressions, their type, and the resulting values. Some include computation, some don't:
```ocaml
# "Everything has a value, every value has a type";;
- : string = "Everything is a value, every value has a type"

# 2 * 21;;
- : int = 42

# int_of_float;;
- : float -> int = <fun>

# int_of_float (3.14159 *. 2.0);;
- : int = 6

# fun x -> x * x;;
- : int -> int = <fun>

# ();;
- : unit = ()

# print_endline;;
- : string -> unit = <fun>

# print_endline "Hello!";;
Hello!
- : unit
```

An expression's type (before evaluation) and its resulting value's type (after computation) are the same. This allows the compiler to avoid runtime type checks in binaries. In OCaml, the compiler removes type information, so it's not available at runtime. In programming theory, this is called [subject reduction](https://en.wikipedia.org/wiki/Subject_reduction).

## Global Definitions

Every value can be named. This is the purpose of the `let ... = ... ` construction. The name is on the left; the expression is on the right.
* If the expression can be evaluated, it take places right away.
* Otherwise, the expression is turned into a value as-is. That's the case of function definition.

The following sections discusses definitions with computation. Definitions without computation, like functions, are discussed later.

Global definitions are those entered at the toplevel. This is what happens when writing a definition in UTop:
```ocaml
# let the_answer = 2 * 3 * 7;;
val the_answer : int = 42
```

Here, `the_answer` is a global definition.

When a variant type has a single constructor, it is possible to combine pattern matching and definition. The pattern is written between the `let` keyword and the equal sign. A very common case is pairs. It allows the creation of two names with a single `let`.
```ocaml
# let (x, y) = List.split [(1,2); (3,4); (5,6); (7,8)];;
val x : int list = [1; 3; 5; 7]
val y : int list = [2; 4; 6; 8]
```

This works for any variant type. Here is a type named `tree` with a variable number of branches:
```ocaml
# type 'a tree = Node of 'a * 'a tree list;;
type 'a tree = Node of 'a * 'a tree list

# let t = Node (1, [Node (2, []); Node (3, []); Node (4, [])]);;
val t : int tree = Node (1, [Node (2, []); Node (3, []); Node (4, [])])

# let rec tree_map f (Node (x, u)) = Node (f x, List.map (tree_map f) u);;
val tree_map : ('a -> 'b) -> 'a tree -> 'b tree = <fun>

tree_map (fun x -> x * x) t;;
- : int tree = Node (1, [Node (4, []); Node (9, []); Node (16, [])])
```

> Note: Above, `'a` means “any type.” It is called a "type variable" and is pronounced like the Greek letter α (“alpha”). This type parameter will be replaced by another type.

Because records are implicitly single constructor variants, this also applies to them:
```ocaml
# type name = { first : string; last: string };;
type name = { first : string; last : string; }

# let robin = { first = "Robin"; last = "Milner" };;
val robin : name = {first = "Robin"; last = "Milner"}

# let { first; last } = robin;;
val first : string = "Robin"
val last : string = "Milner"
```

A special case of combined definition and pattern matching involves the unit type:
```ocaml
# let () = print_endline "ha ha";;
ha ha
```

Below, the pattern does not contain any identifier, meaning no name is defined. The expression is evaluated, the side effect takes place, no definition is created, and no value is returned. Writing that kind of pseudo-definition only expresses interest in the side effects.
```ocaml
# print_endline "ha ha";;
ha ha
- : unit = ()

# let _ = print_endline  "ha ha";;
ha ha
- : unit = ()
```

As seen in the last example, the catch-all pattern (the underscore symbol) can be used in definitions. The following example illustrates its use, which is distinct from the unit pattern:
```ocaml
# let (_, y) = List.split [(1,2); (3,4); (5,6); (7,8)];;
val y : int list = [2; 4; 6; 8]
```

## Local Definitions

Local definitions are like global definitions, except the name is only bound inside an expression. They are introduced by the `let ... = ... in ...` construction. The name bound before the `in` keyword is only bound in the expression after the `in` keyword
```ocaml
# let b = 2 * 3 in b * 7;;
- : int = 42

# b;;
Error: Unbound value b
```

Here, the name `b` is bound to `6` inside the expression `b * 7`. A couple of remarks:
- No global definition is introduced in this example
- Computation of `2 * 3` will always take place before `b * 7`

Local definitions can be chained (one after another) or nested (one inside another). Here is an example of chaining:
```ocaml
# let b = 2 * 3 in
  let c = b * 7 in
  b * c;;
- : int = 252
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
```
Here is how scoping works:
- `c` is bound to `6` inside `c * 5`
- `b` is bound to `30` inside `b * 7`

Arbitrary combinations of chaining or nesting are allowed.

## Scopes and Environments

Without oversimplifying, an OCaml program is a sequence of definitions or expressions. These items are said to be at the _top level_. That's why an OCaml REPL, such as UTop, is called a toplevel, because that's where typed expressions go.

Execution evaluates each expression from top to bottom.

At any time during evaluation, the _environment_ is the ordered sequence of available definitions.

Here, the name `tau` is added into the toplevel environment.
```ocaml
# let tau = 6.28318;;
val tau : float = 6.28318
```

The scope of `tau` is global. This name is available anywhere after the definition.

Here, the global environment is unchanged:
```ocaml
# let pi = 3.14159 in 2. *. pi;;
- : float = 6.28318
```

However, with respect to the expression `2. *. pi`, the environment is different because it contains the definition of `pi`. Local definitions create local environments.

The scope of a definition is the set of environments where it is reachable.

Although OCaml is an expression-oriented language, it is not entirely free of statements. The `let` construct is a statement that may change the state of the environment by adding a name-value binding. In some sense, the `let` is the only statement OCaml has. Note these expressions at the toplevel also fall into that category because they are equivalent to `let _ =` definitions.
```ocaml
# (1.0 +. sqrt 5.0) /. 2.0;;
- : float = 1.6180339887498949

# let _ = (1.0 +. sqrt 5.0) /. 2.0;;
- : float = 1.6180339887498949
```

With respect to the environment, there are no means to:
- List its contents
- Remove a definition
- Reset it to an earlier state

### Same-Level Shadowing

You can write two definitions using the same identifier in sequence:
```ocaml
# let c = 2 * 3;;
val c : int = 6

# let d = c * 7;;
val d : int = 42

# let c = 7 * 7;;
val c : int = 49

# d;;
- : int = 42
```

In this example, `c` is defined twice. The key thing to understand is that `c` is not updated. It looks as if the value of `c` has changed, but it hasn't. When the second definition takes place, the first one becomes unreachable, but it still remains in the environment.

Here is how this can be useful:
```ocaml
# let rec length len = function
  | [] -> len
  | _ :: u -> length (len + 1) u;;
val length : int -> 'a list -> int = <fun>

# let length u = length 0 u;;
val length : 'a list -> int = <fun>
```

The first definition of `length` has two parameters: the list to process and the accumulated length that has already been computed. Writing it this way makes it tail-recursive.

In practice, computing a list's length always starts with the accumulator set to nil. Therefore, the first definition is shadowed by the second where the accumulator parameter is set to 0.

### Inner Shadowing

A local definition may shadow any other definition, just like a global definition does. The only difference is that shadowing is limited to the local definition's scope.
```ocaml
# let d = 21;;
val d : int = 21

# let d = 7 in d * 2;;
- : int = 14

# d;;
- : int = 21
```

## Function as Values

As already stated, in OCaml, function are values. The this the key concept of [functional programming](https://en.wikipedia.org/wiki/Functional_programming). In this context, it is also possible to say that OCaml has [first-class](https://en.wikipedia.org/wiki/First-class_function) functions or that functions are [first-class citizens](https://en.wikipedia.org/wiki/First-class_citizen).

The view taken in this tutorial is to skip those definitions and instead star playing with them. We believe their meaning will arise from experience. Once things make sense, naming them is just a mean to interact with the community.

This is a big take away. We believe functional programming (_ergo_ OCaml) is best understood by practising it rather than reading about it. Just like skateboarding, cooking or wood working, learn by doing is not only possible, it the easiest to most and the right way to start. Because in the end, the goal is not to be able to give correct definition of abstract terms but to write OCaml code.

## Calling Functions

In OCaml, no symbol is needed to express passing an argument to a function. When several expressions are written side by side, the leftmost one should be a function. All the others are parameters. In OCaml, parentheses serve a single purpose: associating expressions to create subexpressions.
```ocaml
# max (21 * 2) (int_of_string "713");;
- : int = 713
```

There are two alternative ways to call functions: using the application `@@` operator or the pipe `|>` operator.
```ocaml
# ( @@ );;
- : ('a -> 'b) -> 'a -> 'b = <fun>

# sqrt 9.0;;
- : float = 3.

# sqrt @@ 9.0;;
- : float = 3.
```

The application operator applies a parameter (on the right) to a function (on the left). It is useful when chaining several calls, as it avoids writing parentheses. Here is what it can look like:
```ocaml
# truncate (sqrt (float_of_int (int_of_string "81")));;
- : int = 9

# truncate @@ sqrt @@ float_of_int @@ int_of_string "81";;
- : int = 9
```

The pipe operator also allows avoiding parentheses but in reversed order:
```ocaml
# ( |> );;
- : 'a -> ('a -> 'b) -> 'b = <fun>

# "81" |> int_of_string |> float_of_int |> sqrt |> truncate;;
- : int = 9
```
This is just like a Unix shell pipe.

## Anonymous Functions

As citizens of the same level as other values, functions don't have to be bound to a name to exist (although some must, but this will be explained later). Function values not bound to names are called _anonymous functions_. Here are a couple of examples:
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

In order, here is what they do:
- The identity function that takes anything, returns it unchanged.
- The square function takes an integer, returns its square.
- The function taking two strings returns their concatenation with a space character in between.
- A function taking a list, returning `None` if the list is empty, and the tail of the list otherwise.

## Defining Global Functions

Defining a global function isn't very different from creating a definition and binding a value to a name. The only difference is that no computation takes place. The expression is turned into a function value and bound to the name.
```ocaml
# let f = fun x -> x * x;;
val f : int -> int = <fun>

# let f x = x * x;;
val f : int -> int = <fun>
```

These two definitions are the same. The former explicitly binds the anonymous function to a name. The latter is the same, but it uses a more compact syntax and avoids the `fun` keyword and the arrow symbol.

## Defining Local Functions

A function may be defined locally. Just like any local definition, the function is only available inside its attached expression. Although the local functions are often defined inside the scope of the function, this is not a requirement. Here is a local function inside a toplevel expression.
```ocaml
# let sq x = x * x in sq 7 * sq 7;;
- : int = 2401

# sq;;
Error: Unbound value sq
```

## Closures

The following sequence of definitions and expressions illustrates what a closure is:
```ocaml
# let d = 2 * 3;;
val d : int = 6

# let f x = x * d;;
val f : int -> int = <fun>

# f 7;;
- : int = 42

# let d = 10;;
val d : int = 10

# f 7;; (* What is the result? *)
- : int = 42
```

Here is how this makes sense:
1. Constant `d` is defined, and its value is 6.
1. Function `f` is defined. It takes a single parameter and returns its product by `d`.
1. Compute `f` of 7
1. Create a new definition `d`, shadowing the first one
1. Compute `f` of 7 again, the result is the same

Although the new definition of `d` shadows the first one, the first value of `d` remains the one used inside `f`. That first definition of `d` is trapped inside the definition of `f`. Inside `f`, the environment is frozen as it was when `f` was defined, with the first value of `d` inside. That's why it is called a closure.

A function value is a pair containing the function code and an environment. It is that pair that is called a [closure](https://en.wikipedia.org/wiki/Closure_(computer_programming)).

Partially applying parameters to a function creates a new closure. The environment is updated, but the function is unchanged.
```ocaml
# let max_42 = max 42;;
val max_42 : int -> int = <fun>
```

Inside the `max_42` function, the environment contains an additional binding between the first parameter of `max` and the value 42.

## Recursive Functions

In order to perform iterated computations, a function may call itself. Such a function is called _recursive_. Recursive functions must be defined; they can't be anonymous. A recursive function also needs to be explicitly declared as such by using `let rec`. In OCaml, either a function is declared as recursive or it isn't recursive. It is not possible to accidentally create recursion loops between functions. As a consequence, recursive functions can't be anonymous.

The classic (and very inefficient) way to present recursion is using the function that computes numbers of the [Fibonacci Sequence](https://en.wikipedia.org/wiki/Fibonacci_sequence).
```ocaml
# let rec fibo n = if n <= 1 then n else fibo (n - 1) + fibo (n - 2);;
val fibo : int -> int = <fun>

# List.init 10 Fun.id |> List.map fibo;;
- : int list = [0; 1; 1; 2; 3; 5; 8; 13; 21; 34]
```

This version of `fibo` is inefficient because the number of recursive calls created doubles at each call, which creates exponential growth.

This version does a better job:
```ocaml
# let rec fibo m n i = if i = 0 then m else fibo n (n + m) (i - 1);;
val fibo : int -> int -> int -> int = <fun>

# let fibo = fibo 0 1;;
val fibo : int -> int = <fun>

# List.init 10 Fun.id |> List.map fibo;;
- : int list = [0; 1; 1; 2; 3; 5; 8; 13; 21; 34]
```

The first version takes two extra parameters: the two previously computed Fibonacci numbers.

The second version uses the two first Fibonacci numbers as initial values. There is nothing to be computed when returning from a recursive call, so this enables the compiler to perform an optimisation called “tail call elimination,” which turns recursivity into imperative iteration in the generated native code and leads to much improved performances.

## Passing Multiple Arguments to Functions

Until now, functions with several arguments had a type looking like this: `a₁ -> a₂ -> a₃ -> ⋯ -> b`

Where `a₁` is the type of the first argument, `a₂` is the type of the second argument, etc., and `b` is the type of the result. However, this type isn't displayed as it is. In reality, this type is the following: `a₁ -> (a₂ -> (a₃ -> ⋯ -> b))`. The arrow symbol is a binary operator. Here is how this can be observed:
```ocaml
# ( + );;
- : int -> int -> int = <fun>

# let f : (int -> (int -> int)) = ( + );;
val f : int -> int -> int = <fun>
```

In this example, the type of the integer addition function `( + )` is displayed first. It prints as `int -> int -> int`. It takes two integers and returns an integer. In the second part, `f` is defined to have type `int -> (int -> int)`. Despite the type of `( + )` looking different, the binding with `f` is allowed because those two types are the same. The toplevel always prints the version without parentheses to make it easier to read.

Putting the parentheses the other way does not work:
```ocaml
# let g : ((int -> int) -> int) = ( + );;
Error: This expression has type int -> int -> int
       but an expression was expected of type (int -> int) -> int
       Type int is not compatible with type int -> int
```

In mathematical language, it is said that the type arrow operator _associates to the right_. Function types without parentheses should be treated as if they have parentheses, placed to the right the same way that the type of `f` was declared above. These types are the same:
- `int -> int -> int`
- `int -> (int -> int)`

But only the first is displayed, so it is not the same as `(int -> int) -> int`.

Most importantly, this means a “binary” function isn't really a function that takes two parameters. In the case of addition, it is a function that takes an integer and returns a function of type `int -> int`. And it is indeed!
```ocaml
# ( + ) 2;;
- : int -> int = <fun>
```

Passing a single integer to the addition returns a function of type `int -> int`. That function value is a closure. The value passed as the first parameter, here 2, is captured as if it had been in an earlier definition.

## Passing Multiple Arguments as Tuples

Consider this function:
```ocaml
# let space_cat (s, t) = s ^ " " ^ t;;
val space_cat : string * string -> string = <fun>
```

It takes a pair of strings and returns a string.
```ocaml
# space_cat ("hello", "world");;
- : string = "hello world"
```

Asking whether `space_cat` is a binary function or not makes sense. Morally, it takes two parameters: the two strings that are sandwiching the space character. Wrapped as a pair, they are a single piece of data, so `space_cat` has a single parameter. But it is the elements of that pair that are relevant, not the pair as a whole. So morally, `space_cat` is a binary function. Syntactically, the call `space_cat ("hello", "world")` looks pretty much like a function call in high school maths or a spreadsheet application, both having two parameters: `"hello"` and `"pair"`.

## Currying and Uncurrying

In the two previous sections, two kinds of “multiple parameter” functions have been presented.
- Functions returning a function, such as `( + )`
- Functions taking a pair or a tuple as a parameter, such as `space_cat`

Interestingly, both kinds of functions provide a way to pass several parameters while being functions with a single parameter. In this perspective, it makes sense to say: “All functions have a single argument.”

This goes even further. Any function of the same kind can be translated into an equivalent function of the second kind, and conversely. Using OCaml support for higher-order functions, it is possible to define those transformations as functions.

Here is the translation from the first kind to the second kind:
```ocaml
# fun f -> fun (x, y) -> f x y;;
- : ('a -> 'b -> 'c) -> 'a * 'b -> 'c = <fun>
```

Here is the reverse translation:
```ocaml
# fun f -> fun x y -> f (x, y);;
- : ('a * 'b -> 'c) -> 'a -> 'b -> 'c = <fun>
```

These translations are attributed to the 20th-century logician [Haskell Curry](https://en.wikipedia.org/wiki/Haskell_Curry). The second translation is called currying and the first is called uncurrying.

From a typing perspective, this means that for any types `a`, `b`, and `c`, the following types are equivalent:
- `a -> (b -> c)` &mdash; curried function type
- `a * b -> c` &mdash; uncurried function type

We will not dive any deeper into the details here. This equivalence can be formally defined using _ad-hoc_ mathematics.

It is rarely necessary to use the functions above. However, it is important to understand that changing a function may not need any code refactoring. A function can be given several equivalent forms and changed into another, either using refactoring or using a higher-order function. Since functions are values, currying and uncurrying are operations on those values.

In practice, curried functions are the default form functions should take because:
- Allows partial application
- Less editing, no parentheses or commas
- No pattern matching over a tuple

## Functions With Side-Effects

With respect to its type, a function is expected to process input data from its domain and produce a result data from its codomain.

However, some functions either take input data outside of their declared domain or produce data outside of their codomain. These out-of-signature data are called effects, or side effects. Input and output (I/O) are the most common forms of effects. Input is out-of-domain data and output out-of-codomain data. However, the result of functions returning random numbers or the current time is influenced by external factors, which is also called an effect. The external factor is out-of-domain input. Similarly, any observable phenomena triggered by the computation of a function is out-of-codomain output.

In practice, what is considered an effect is an engineering choice. In most circumstances, I/O operations are considered as effects, unless they are ignored. Electromagnetic radiation emitted by the processor when computing a function isn't usually considered a relevant side-effect, except in some security-sensitive contexts. In the OCaml community, as well as in the wider functional programming community, functions are often said to be either pure or impure. The former does not have side effects, the latter does. This distinction makes sense and is useful. Knowing what the effects are, and when are they taking place, is a key design consideration. However, it is important to remember this distinction always assumes some sort of context. Any computation has effects, and what is considered a relevant effect is a design choice.

Since, by definition, effects lie outside function types, a function type can't reflect the effects a function may have. However, it is important to document the intended side effects a function may have. Consider the `Unix.time` function. It returns the number of seconds elapsed since Jan 1, 1970.
```ocaml
# Unix.time ;;
- : unit -> float = <fun>
```
If you're getting an `Unbound module error` in macOS, run this first: `#require "unix";;`.

To produce its result, no data needs to be passed to that function. The result is entirely determined by external factors. If it was passed information, it would not be used. But something must be passed as a parameter to trigger the request the current time from the operating system.

Since the function must receive data to trigger the computation but the data is going to be ignored, it makes sense to provide the unit value (). What is discarded is meaningless in the first place.

A similar reasoning applies to functions producing an effect instead of being externally determined or influenced. Consider `print_endline`. It prints the string it was passed to standard output, followed by a line termination.
```ocaml
# print_endline;;
- : string -> unit = <fun>
```
Since the purpose of the function is only to produce an effect, it has no meaningful data to return; therefore, again, it makes sense to return the unit value.

This illustrates the relationship between functions intended to have side effects and the unit type. The presence of the unit type does not indicate the presence of side effects. The absence of the unit type does not indicate the absence of side effects. But when no data needs to be passed as input or can be returned as output, the unit type should be used to indicate it and suggest the presence of side effects.

## Functions are Almost as Other Values

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
- It is impossible to write an algorithm that takes two functions and returns `true`, if they always return the same output when provided the same input, and `false` otherwise.
- Assuming it was possible, such an algorithm would declare that implementations of quicksort and bubble sort are equal. That would mean one could replace the other, which is may not be wise.

It may seem counterintuitive that classes of objects of the same kind (i.e., having the same type) exist where equality between objects does not make sense. High school mathematics does not provide examples of those classes. But in the case of computing procedures seen as functions, equality isn't the right tool to compare them.

3. Pattern matching does not allow inspecting a function. Catch-all patterns can match against a function, but it is useless.
```ocaml
# match Fun.id with id -> ();;
- : unit = ()
```

## Conclusion

At the heart of OCaml lies the concept of the environment, a crucial element in its operation. To put it succinctly, the environment works as an ordered, append-only key-value store. It is notable for its append-only nature, meaning that items cannot be removed. Furthermore, it maintains order by preserving the sequence of available definitions.

When we employ a `let` statement, we introduce zero, one, or more name-value pairs into the pertinent environment. Similarly, when invoking a function with its parameters, we extend the environment by adding names and their corresponding arguments, so a closure in OCaml embodies an environment-function pairing, cementing the interconnectedness of these fundamental concepts.

During the review of this tutorial, it was asked:

> Why is it so that having function as values is what actually defines functional programming?

Answering this question goes beyond the scope of a tutorial about expressions and values in OCaml. However, and without entering into the details, erasing the difference between functions and other values is meant to express they are the same thing. That's exactly what happens in the [λ-calculus](https://en.wikipedia.org/wiki/Lambda_calculus), the mathematical theory underneath functional programming. In that formalism, there's nothing but functions. Everything, including data, is a function and computation reduces to parameter passing. In functional programming and OCaml, having function and values at the same level is an invitation to think about programs this way. That is different from the imperative programming approach where everything reduces to reading and writing into the memory.
