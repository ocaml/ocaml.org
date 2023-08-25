
---
tags: ocamlorg-docs
---

[toc]

# Values and Functions

## Introduction

### Learning Goals

When presenting functional programming or OCaml, it is often said: “functions are treated as first-class citizens”. This may not be helpful (it wasn't to me). The goal of this tutorial is acquire the capabilities implied and entailed by this sentence. In turn, this should explain than sentence. 
- Write all kind of definitions, for all kind of values, in all different ways
- Acturately asses the scope of any definition
- Avoid being fooled by shadowed definitions and scopes
- Explain what a closure is why it is named like that
- partially apply functions, create closures and pass them as values
- Curry and uncurry functions
- Use the `unit` type as function parameter or return value, when needed

### Chatting with OCaml

This tutorial is supposed to be played using Utop. Code samples are intended to be pasted in this top-level. The reader should write variants around the exemples provided to strengthen understanding. Although others may be used, we assume Utop. The topics discussed are not limited to interactive execution of OCaml expressions. However, we believe they are easier to understand within the dynamics of interaction with the OCaml interpreter.

### Touch Base on Double Semicolon

When using Utop to interact with the OCaml interpreter, line endding with double semicolons trigger the parsing, type-checking and evaluation of everything typed between the prompt and the double semicolon, it may have several lines. The interpretation of that double semicolon isn't made by the OCaml interpreter, it is made by Utop, the OCaml toplevel. Once evaluation of a double semicolon entry is over, the REPL waits for another piece of input.

Nethertheless, the double semicolon `;;` is a valid token in the OCaml syntax. It has no meaning, it is a [no-op](https://en.wikipedia.org/wiki/NOP_(code)). It is ignored and never needed. In OCaml source code files meant to be compiled or interpreted as scripts, double semicolon can and should be avoided. This just a mean to avoid double semicolumns required by the toplevel to raise errors when using the compiler.

## Non Function Values

### Values

Like most functional programming languages, OCaml is an [expression oriented programming language](https://en.wikipedia.org/wiki/Expression-oriented_programming_language). There are no statements, i.e. syntactical constructions made to produce a computation of some sort. Jumps are examples of statements. Computations triggered by OCaml are written as expressions. Once completed, they produce a value, which has a type. Here are a few examples of expressions, their type and resulting values.

```ocaml
# "Everything has a value, every value has a type";;
- : string = "everything is a value, every value as a type"

# 2 * 21;;
- : int = 42

# int_of_float;;
- : float -> int = <fun>

# int_of_float (3.14159 *. 2.0);;
- : int = 6

# fun x -> x * x;;
- : nat -> nat = <fun>

# ();;
- : unit = ()

# print_endline;;
- : string -> unit = <fun>
```

An essential property of the relationship between expressions, values, computation and types is called _subject reduction_. The type of an expression, before computation, is the same as the type of the value it produces, after computation. This allows the compiler to avoid runtime type checks in binaries.

### Global Definitions

Every expression can be given a name. The relationship between a name and an expression is called a definition and is introduced by the `let ... = ... ` construction.

If the expression can be computed at time of its binding to a name, it is and the relationship is between a name and a value. Otherwise, which is the case of functions, the expression is turned into a special value without being computed. Definitions with computation are discussed in this section. Definitions without computationn, which are functions, are disscused it the next section.

Global definitions are those entered at the toplevel. This is what happens in when writing a definition in Utop.
```ocaml
# let a = 2 * 3 * 7;;
val a : int = 42
```

Here, `a` is a global definition. 

When a variant type has a single constructor, it is possible to combine pattern matching and definition. The pattern is written between the `let` keyword and the equal sign. A common very common case are pairs. It allows creating two names with a single `let`.
```ocaml
# let (x, y) = List.split [(1,2); (3,4); (5,6); (7,8)];;
val x : int list = [1; 3; 5; 7]
val y : int list = [2; 4; 6; 8]
``` 

This works for any variant type. Here is a type of trees with a variable numbers of branches.
```ocaml
# type 'a tree = Node of 'a * 'a tree list;;
type 'a tree = Node of 'a * 'a tree list

# let rec tree_map f (Node (x, u)) = Node (f x, List.map (tree_map f) u);;
val tree_map : ('a -> 'b) -> 'a tree -> 'b tree = <fun>
```

Because records are implicitely single constructor variants, this also applies to them.
```ocaml
# type name = { first : string; last: string };;
type name = { first : string; last : string; }

# let robin = { first = "Robin"; last = "Milner" };; 
val robin : name = {first = "Robin"; last = "Milner"}

# let { first; last } = robin;;
val first : string = "Robin"
val last : string = "Milner"
```

A special case of combined definition and pattern matching involves the unit type.
```ocaml
# let () = print_endline "ha ha";;
ha ha
```

Here, the pattern does not contain any identifier, no name is defined. The expression is evaluated, the side effect takes place, no definition is created, no value is returned. In fact, writting that kind of pseudo-definition expresses being only interested in the side-effects.
```ocaml 
# print_endline "ha ha";;
ha ha
- : unit = ()

# let _ = print_endline  "ha ha";;
ha ha
- : unit = ()
```

As seen in the last example, the catch all pattern (the underscore symbol) can be used in definitions. The following example illustrate its use, which is distinct from the unit pattern:
```ocaml
# let (_, y) = List.split [(1,2); (3,4); (5,6); (7,8)];;
val y : int list = [2; 4; 6; 8]
```

### Local Definitions

Local definitions are like global definition, except the name is only bound inside an expression. They are introduced by the `let ... = ... in ...` construction. The name bound before the `in` keyword is only bound in the expression after the `in` keyword
```ocaml
# let b = 2 * 3 in b * 7;;
- : int = 42

# b;;
Error: Unbound value b
```

Here, the name `b` is bound to `6` inside the expression `b * 7`. A couple of remarks
- No global definition is introduced in this example
- Computation of `2 * 3` will always take place before `b * 7`

Local definitions can be chained (one after another) or nested (one inside another). Here is an example of chaining.
```ocaml
# let b = 2 * 3 in
  let c = b * 7 in
  b * c;;
- : int = 252
```

Here is how scoping works here:
- `b` is bound to `6` inside `let c = b * 7 in b * c`
- `c` is bound to `42` inside `b * c`

Here is an example of nesting.
```ocaml
# let b = 
    let c = 2 * 3 in 
    c * 5 in 
  b * 7;;
```
Here is how scoping works here:
- `c` is bound to `6` inside `c * 5`
- `b` is bound to `30` inside `b * 7`

Arbitrary combinations or chaining and nesting are allowed.

### Scopes and Environments

Without over simplifying, an OCaml program is a sequence of definitions or expressions. These items are said to be at the _toplevel_. That's why an OCaml REPL, such as UTop, is called a toplevel, that's where typed expressions go. 

Execution evaluates each expression, from top to bottom. 

At any time during evaluation, the _environement_ is the ordered sequence of definitions which are available.

Here, the name `tau` is added into the toplevel environment.
```ocaml
# let tau = 6.28318;;
val tau : float = 6.28318
```

The scope of `tau` is global. This name is available anywhere after the definition.

Here the global environment is unchanged.
```ocaml
# let pi = 3.14159 in 2. *. pi;;
- : float = 6.28318
```

However, with respect to the expression `2. *. pi` the environment is different, it contains the definition of `pi`. Local definition create local environments. 

The scope of a definition are the environments where it is reachable.

Although OCaml is an expresion oriented language, it is not entirely free of statements. The `let` construct is a statement. It is a statement which may change the state of the environment, by adding a name-value binding. Note that expressions at the toplevel also fall into that category because they are equivalent to `let _ =` definitions.
```ocaml
# (1.0 +. sqrt 5.0) /. 2.0;;
- : float = 1.6180339887498949

# let _ = (1.0 +. sqrt 5.0) /. 2.0;;
- : float = 1.6180339887498949
```

With respect to the environments, there are no means to:
- list its contents 
- remove a definition
- reset it to an earlier state
 
#### Same-Level Shadowing

It is allowed to write two definitions using the same identifier in sequence.
```ocaml 
# let c = 2 * 3;;
val c : int = 6

# let d = c * 7;;
val d : int = 42

# let c = 7 * 7;;
- : int = 49

# d;;
- : int = 42
```

In this example, `c` is defined twice. The key thing to understand is `c` is not updated. It looks as if the value of `c` has changed, but it hasn't. When the second definition takes place, the first one becomes unreacheable, but it remains in the environment.

Here is how this can be useful:
```ocaml
# let rec length len = function
  | [] -> len
  | _ :: u -> length (len + 1) u;;
val length : int -> 'a list -> int = <fun>

# let length u = length 0 u;;
val length : 'a list -> int = <fun>
```

The first definition of `length` has two parameters, the list those length is computed and the accumulated length already computed. Writing it this way makes it tail recursive.

However, in practice, computing a list's length always start with the accumullator set to nil. Therefore, the first definition is shadowed by the second one where the acculator parameter is set to 0.

#### Inner Shadowing

A local definition may shadow any another definition, just like a global does. The only difference the shadowing is limited to the scope of the local definition.
```ocaml
# let d = 21;;
val d : int = 21

# let d = 7 in d * 2;;
val d : int = 14

# d;;
- : int = 21
```

## Function Values

### Restrictions 

Functions are supposed to be exactly as other values. However, there are two restrictions.

Function values cannot be displayed in interactive sessions, the placeholder `<fun>` is displayed. This is because there is nothing meaningful to print. Once parsed and typed-checked, the souce code of a function is discarded by OCaml, nothing remains to be printed.
```ocaml
# sqrt;;
- : float -> float = <fun>
```

Equality between functions can't be tested.
```ocaml
# pred = succ;;
Exception: Invalid_argument "compare: functional value".
```

There are two main reasons explaining this.
1. It is impossible to write an algorithm which takes two functions and returns true if they always return the same output when provided the same input and false otherwise
1. Assuming it was possible, such an algorithm would declare that quicksort and bubblesort are equal. That would mean those procedures are substituables, which is not the case.

It may seem counterintuitive that it exists classes of objects of the same kind (i.e. having the same type) where equality between objects does not make sense. High-school mathematics does not provide examples of those classes. But it the case of computing procedures seen as functions, equality isn't the right tool to compare them.

### Calling Functions

In OCaml, no symbol is needed to express passing an argument to a function. When several expressions are written side by side, the leftmost one should be a function, all the others are parameters. In OCaml, parenthesis serve a single purpose: associating expressions to create sub-expressions.
```ocaml
# max (21 * 2) (int_of_string "713");;
- : int = 713
```

There are two alternative ways to call functions, using the application `@@` operator or the pipe `|>` operator.
```ocaml
# ( @@ );;
- : ('a -> 'b) -> 'a -> 'b = <fun>

# sqrt 9.0;;
- : float = 3.

# sqrt @@ 9.0;;
```

The application operator applies a parameter, on the right, to a function, on the left. It is useful when chaining several calls, as it avoids writting parenthesis. Here is how it can look like.
```ocaml
# truncate (sqrt (float_of_int (int_of_string "81")));;
- : int = 9

# truncate @@ sqrt @@ float_of_int @@ int_of_string "81";;
- : int = 9
```

The pipe operator also allows avoiding parenthesis, but in reversed order
```ocaml 
# ( |> );;
- : 'a -> ('a -> 'b) -> 'b = <fun>

# "81" |> int_of_string |> float_of_int |> sqrt |> truncate;;
- : int = 9
```
This is just like an Unix shell pipe.

### Anonymous Functions

As citizens of the same level as other values, functions don't have to be bound to a name to exist (although some must, this will be explained later). Function values not bound to names are called _anonymous functions_. Here are a couple of examples:
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
- This is the identity function, takes anything, returns it unchanged
- The square function, takes an integer, returns its square
- A function taking two strings, returning the their concatenation, with a space character in between
- A function taking a list, returning `None` if the list is empty, and the tail of the list otherwise

### Defining Global Functions

Definining a global function isn't very different from creating a definition, binding a value to a name. The only difference is no computation takes place. The expression is turned into a function value and bound to the name.
```ocaml
# let f = fun x -> x * x;;
val f : int -> int = <fun>

# let f x = x * x;;
val f : int -> int = <fun>
```

These two definitions are the same. The former explicitly binds the anonymous function to a name. The latter is the same, using a more compact syntax, avoiding the `fun` keyword and the arrow symbol.

### Defining Local Functions

A function may be defined locally. Just like any local definition, the function is only available inside the expression which it is attached to. Although the local functions are often defined inside the scope of function, this is not a requirement. Here is a local function inside a regular expression.
```ocaml
# let sq x = x * x in sq 7 * sq 7;;
- : int = 2401
```

### Closures

The following sequence of definitions and expressions illustrates what a closure is.
```ocaml
# let d = 2 * 3;;
val d : int = 6

# let f x = x * d;;
val f : 'a -> int = <fun>

# f 7;;
- : int = 42

# let d = 10;;
val d : int = 10

# f 7;; (* What the result? *)
- : int = 42
```

Here is how this is making sense:
1. Constant `d` is defined, its value is 6.
1. Function `f` is defined, it takes a single parameter and returns its product by `d`
1. Compute `f` of 7
1. Create a new definition `d` shadowing the first one
1. Compute `f` of 7 again, result is the same

Although the new definition of `d` shadows the first one, the first value of `d` remains the one used inside `f`. That first definition of `d` is traped inside the definition of `f`. Inside `f` the environement is frozen as it was when `f` was defined, with the first value of `d` inside. That's why it is called a closure.

Partially applying parameters also creates a closure. 
```ocaml
# let max_42 = max 42;;
val max_42 : int -> int = <fun>
```

In the `max_42` function, the environment contains an additional binding, between the first parameter of `max` and the value 42.

Actually, all function values are closures. 

### Recursive Functions

In order to perform iterated computations, a function may call itself. Such a function is called _recursive_. Recursive function must be defined, they can't be anonymous. A recursive function also needs to be explicitely declared as such using `let rec`. In OCaml, either a function is declared as recursive, or it isn't recursive, it is not possible to accidentaly create recursion loops between functions. As a consequence, recursive functions can't be anonymous.

The classic, and very inefficient, way to present recursion is using the function which computes numbers of the [Fibonacci Sequence](https://en.wikipedia.org/wiki/Fibonacci_sequence).
```ocaml
# let rec fibo n = if n <= 1 then n else fibo (n - 1) + fibo (n - 2);;
val fibo : int -> int = <fun>

# List.init 10 Fun.id |> List.map fibo;;
- : int list = [0; 1; 1; 2; 3; 5; 8; 13; 21; 34]
```

This version of `fibo` is inefficient because the number of recursive call it creates doubles at each call, which creates an exponential growth.

This version does a better job.
```ocaml
# let rec fibo m n i = if i = 0 then m else fibo n (n + m) (i - 1);;
val fibo : int -> int -> int -> int = <fun>

# let fibo = fibo 0 1;;
val fibo : int -> int = <fun>

# List.init 10 Fun.id |> List.map fibo;;
- : int list = [0; 1; 1; 2; 3; 5; 8; 13; 21; 34]
```

The first version takes two extra parameters, the two previously computed Fibonacci numbers. The second version uses the two first Fibonacci numbers as initial values. There is nothing to be computed when returning from recursive call, this enables the compiler to perform an optimization called “tail call elimination” which turns recursivity into imperative iteration in the generated native code and leads to much improved performances.

#### Passing Multiple Arguments to Functions

Until now, functions having several arguments had a type looking like this: `a₁ -> a₂ -> a₃ -> ⋯ -> b`

Where `a₁` is the type of the first argument, `a₂` is the type of the second argument, etc. and `b` is the type of the result. However, this type isn't displayed as it really is. In reality this type is the following: `a₁ -> (a₂ -> (a₃ -> ⋯ -> b))`. The arrow symbol is a binary operator. Here is how this can be observed:
```ocaml
# ( + );;
- : int -> int -> int = <fun>

# let f : (int -> (int -> int)) = ( + );;
val f : int -> int -> int = <fun>
```

In this example, first the type of the integer addition function `( + )` is displayed. It prints as `int -> int -> int`, it takes two integers and returns an integer. In the second part an `f` is defined to have type `int -> (int -> int)`. Despite the type of `( + )` looking different, the binding with `f` is allowed, because those two types are actuallly the same. The toplevel always prints the version without parenthesis to make it easier to read.

Putting the parenthesis the other way does not work:
```ocaml
# let g : ((int -> int) -> int) = ( + );;
Error: This expression has type int -> int -> int
       but an expression was expected of type (int -> int) -> int
       Type int is not compatible with type int -> int 
```

In mathematical language, it is said the type arrow operator _associates to the right_. Function types without parenthesis should be thought to have parenthesis put to the right, like the type of `f` was declared. These types are the same:
- `int -> int -> int`
- `int -> (int -> int)`

But only the first is displayed. And it is not the same as `(int -> int) -> int`.

Most importantly, this means a “binary” function isn't really a function which takes two parameters. In the case of addition, it is a function which takes an integer and returns a function of type `int -> int`. And it is indeed.
```ocaml
# ( + ) 2;;
- : int -> int = <fun>
```

Passing a single integer to the addition returns a function of type `int -> int`. That function value is a closure; the value passed as first parameter, here 2, is captured as if it had been in an earlier definition. 

#### Passing Multiple Arguments as Tuples

Consider this function:
```ocaml 
# let space_cat (s, t) = s ^ " " ^ t;;
val space_cat : string * string -> string
```

It takes a pair of strings and returns a string.
```ocaml
# space_cat ("hello", "world");;
- : string = "hello world"
```

Asking whether `space_cat` is a binary function makes sense. Morally, it takes two parameters, the strings which are sandwitching the space charater. Syntactically, the call `space_cat ("hello", "world")` looks pretty much as a function call in high-school maths, or in a spreadsheet application.

However, from Ocaml perspective `space_cat` takes a single parameter, which is a pair. 

### Currying and Uncurrying

In the two previous sections, two kinds of “multiple parameter” functions have been presented.
- Function returning a function, such as `( + )`
- Functions taking a pair or a tuple as parameter, such as `space_cat`

Interrestingly, both kind of functions provides a way to pass several parameters while actually being functions with a single parameter. In this persepective, it makes sense to say: “all functions have a single argument”.

This goes even further. Any function of the same kind can be translated into an equivalent function of the second kind and conversely. Using OCaml support for higher order functions, it is possible to defined those transformation as functions.

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

These translations are attributed to the 20th centuty logician [Haskell Curry](https://en.wikipedia.org/wiki/Haskell_Curry). The second translation is called currying and the first is called uncurrying. 

From typing perspective, this means, for any types `a`, `b` and `c` the following types are equivalent:
- `a -> (b -> c)` &mdash; curried function type
- `a * b -> c` &mdash; uncurried function type

We will not dive any deeper into the details. But this equivalence can be formally defined using _ad-hoc_ mathematics. 

It is very rare to need to use the functions above. However, it is important to understand changing a function may not need any code refactoring. A function can be given several equivalent forms, and changed into another, either using refactoring or using a higher-order function. As functions are values, currying and currying are operations on those values. 

In practice, curried functions are the default form function should take.
- Allows partial application
- Less editing, no parenthesis and comas
- No pattern matching over a tuple

### Functions with Side-Effects

With respect to its type, a function is expected to process input data from its domain, and produce a result data from its codomain.

However, some functions either take input data outside of their declared domain, and produce data outside of their codomain. This ouside data are called effects, or side-effects. Input and output are the most common forms of effects. Input being out-of-domain data and output out-of-codomain data. However, the result of functions returning random numbers or the current time is influenced by external factors, which is also called an effect, the external factor is out-of-domain input. Similarly, any observable phenomena triggered by the computation of a function is out-of-codoman output. 

In practice, what is considered an effect is a engineering choice. In most circumstances, I/O are considered as effects, unless they are ignored. Electromagnetic radiation emitted by the processor when computing a function isn't usually considered a relevant effect, except in some security sensitive contexts. In the OCaml community, as well as in the wider functional programming community, functions are often said to be either pure or impure. The former not having side effects, the latter having side effects. It is important to remember this always assumes some sort of context, any computation has effects, which one are considered relevant is a choice. 

Since, by definition, effects lie outside function types, a function type can't reflect the effects a function may have. However, it is important to document intended side effects a function may have. Consider the `Unix.time` function. It returns the number of seconds elapsed since Jan 1, 1970.
```ocaml
# Unix.time ;;
- : unit -> float = <fun>
```

This function does not need to be passed any data to return its result, it is entirely context dependent, entirely determined by external factors. Therefore, it could be passed anything, which would simply be discarded. Note it has to be passed something, to trigger the computation, which is actually requesting the information to the operating system, as suggested by the module name. Since that function needs to data to trigger the computation but the data is going to be ignored, it make sense to provide `()`, the unit value, the inhabitant of the type which only has a single value. 

A similar reasoning applies to function producing an effect instead of being effect determined functions. Consider `print_endline`, it prints the string it was passed to standard output, followed by a line termination.
```ocaml
# print_endline;;
- : string -> unit = <fun>
```
Since the purpose of the function is only to produce an effect, it has no meaninful data to return, therefore, again, it makse sense to return the unit value.

This illustrates the relationship between functions intended to have side effects and the unit type. Presence of the unit type does not indicate presence of intended side effects. Absence of the unit type does not indicate absence of side effects. But when no data needs to be passed as input or can be returned as output, the unit type should be used to indicate it and suggest presence of side effects.

## Conclusion

Values, functions and definitions are the most primitive and core concepts of OCaml. Even typing or execution aren't as central. The key concept is environment. In summary, it is an ordered add-only key-value store. Add-only because nothing can be deleted. It is ordered because it is just the list of available definition. When writing a `let`, zero, one or several name value pairs are added to the relevant environment. When calling a function parameters names and arguments are also added to the environment. A closure is an environement-function pair.



