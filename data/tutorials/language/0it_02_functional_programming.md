---
id: functional-programming
title: Functional Programming
description: >
  A guide to functional programming in OCaml
category: "Introduction"
---

# Functional Programming

## What Is Functional Programming?
We've got quite far into the tutorial, yet we haven't really considered
**functional programming**. All the features given so far (rich data
types, pattern matching, type inference, nested functions) could exist in 
a "super C" language. These are cool
features that make your code concise, easy to read, and have
fewer bugs; however, they actually have very little to do with functional
programming. In fact, the reason 
functional languages are so great is *not* because of functional
programming but because we've been stuck with C-like languages for
years, and in the meantime, cutting-edge programming has progressed
considerably. So while we were writing
`struct { int type; union { ... } }` for the umpteenth time, ML and
Haskell programmers had safe variants and pattern matching on datatypes.
While we were being careful to `free` all our `malloc`s, there have been
languages with garbage collectors able to outperform hand coding since
the 80s.

Let's explore functional programming.

The basic, and not very enlightening, distinction in **functional programming**
is that **functions** are first-class citizens.

(Remember that OCaml runs code when it sees the double semicolon `;;`. Throughout
this tutorial, executable code examples begin with the command prompt `#`, end in `;;`, and show 
the expected output. If it doesn't, it's showcasing the code pattern rather than an executable code block.)

Let's look at an
example to illustrate:

```ocaml
# let double x = x * 2 in
    List.map double [1; 2; 3];;
- : int list = [2; 4; 6]
```

In this example, we first defined a nested function called `double`
that took the argument `x` and returned `x * 2`. Then `map` calls
`double` on each element of the given list (`[1; 2; 3]`) to produce the
result: a list with each number doubled.

`map` is known as a **higher-order function** (HOF). Higher-order
functions are just a fancy way of saying that the function takes a
function as one of its arguments. Simple so far. If you're familiar
with C/C++ then this looks like passing a function pointer around.

**Closures** are functions which carry around some of the "environment"
in which they were defined. In particular, a closure can reference
variables which were available at the point of its definition. Let's
generalise the function above so that now we can take any list of
integers and multiply each element by an arbitrary value `n`:

```ocaml
# let multiply n list =
    let f x = n * x in
      List.map f list;;
val multiply : int -> int list -> int list = <fun>
```

Hence:

```ocaml
# multiply 2 [1; 2; 3];;
- : int list = [2; 4; 6]
# multiply 5 [1; 2; 3];;
- : int list = [5; 10; 15]
```

The important point to note about the `multiply` function is the nested
function `f`. This is a closure. Look at how `f` uses the value of `n`
which isn't actually passed as an explicit argument to `f`. Instead `f`
picks it up from its environment; it's an argument to the `multiply`
function and hence available within this function.

This might sound straightforward, but let's look a bit closer at that
call to map: `List.map f list`.

`map` is defined in the `List` module, far away from the current code.
In other words, we're passing `f` into a module defined "a long time
ago, in a galaxy far far away." For all we know, that code might pass `f`
to other modules or save a reference to `f` somewhere and call it
later. Whether it does or not, the closure will ensure that `f`
always has access back to its parental environment, and to `n`.

Here's the code pattern (skeleton) extracted from a real example from LabGtk. This is actually a method on a class
(we haven't talked about classes and objects yet, but just think of it
as a function definition for now).

<!-- $MDX skip -->
```ocaml
class html_skel obj = object (self)
  ...
  ...
  method save_to_channel chan =
    let receiver_fn content =
      output_string chan content;
      true
    in
      save obj receiver_fn
  ...
end
```
First of all you need to know that the `save` function called at the end
of the method takes a function as its second argument: (`receiver_fn`).
It repeatedly calls `receiver_fn` with snippets of text from the widget
that it's trying to save.

Now look at the definition of `receiver_fn`. This function is a closure
alright because it keeps a reference to `chan` from its environment.

## Partial Function Applications
Let's define a `plus` function, which just adds two integers:

```ocaml
# let plus a b =
    a + b;;
val plus : int -> int -> int = <fun>
```
Some questions for people asleep at the back of the class.

1. What is `plus`?
1. What is `plus 2 3`?
1. What is `plus 2`?

Question 1 is easy: `plus` is a function. It takes two arguments that
are integers and returns an integer. We write its type like this:

```ocaml
# plus;;
- : int -> int -> int = <fun>
```
Question 2 is even easier: `plus 2 3` is a number, the integer `5`. We
write its value and type like this:

```ocaml
# 5;;
- : int = 5
```
But what about question 3? It looks like `plus 2` is a typo or an incomplete copy-paste, but
it isn't. If we type this into the OCaml toplevel, it
returns:

```ocaml
# plus 2;;
- : int -> int = <fun>
```
This isn't an error. It's telling us that `plus 2` is in fact a
*function*, which takes an `int` and returns an `int`. 

What sort of
function is this? Let's experiment by first giving this mysterious
function a name (`f`) and then trying it out on a few integers to see
what it does:

```ocaml
# let f = plus 2;;
val f : int -> int = <fun>
# f 10;;
- : int = 12
# f 15;;
- : int = 17
# f 99;;
- : int = 101
```
In engineering, this is sufficient proof to state
`f` (i.e., `plus 2`) is the function that adds 2 to its parameter.

Looking at the types of these expressions, we may be able to see some
rationale for the strange `->` arrow notation used for function types:

```ocaml
# plus;;
- : int -> int -> int = <fun>
# plus 2;;
- : int -> int = <fun>
# plus 2 3;;
- : int = 5
```

This process is called **partial application** of a function.

Remember our `double` and `multiply` functions from earlier on?
`multiply` was defined as this:

```ocaml
# let multiply n list =
  let f x = n * x in
    List.map f list;;
val multiply : int -> int list -> int list = <fun>
```
We can now define `double` and `triple` functions very easily, like
this:

```ocaml
# let double = multiply 2;;
val double : int list -> int list = <fun>
# let triple = multiply 3;;
val triple : int list -> int list = <fun>
```
They really are functions, look:

```ocaml
# double [1; 2; 3];;
- : int list = [2; 4; 6]
# triple [1; 2; 3];;
- : int list = [3; 6; 9]
```

You can also use partial application directly (without the intermediate
`f` function) like this:

```ocaml
# let multiply n = List.map (( * ) n);;
val multiply : int -> int list -> int list = <fun>
# let double = multiply 2;;
val double : int list -> int list = <fun>
# let triple = multiply 3;;
val triple : int list -> int list = <fun>
# double [1; 2; 3];;
- : int list = [2; 4; 6]
# triple [1; 2; 3];;
- : int list = [3; 6; 9]
```

In the example above, `(( * ) n)` is the partial application of the `( * )`
(times) function. Note the extra spaces needed so that OCaml doesn't
think `(*` starts a comment.

You can also put infix operators into brackets to make functions. Here's an
identical definition of the `plus` function as before:

```ocaml
# let plus = ( + );;
val plus : int -> int -> int = <fun>
# plus 2 3;;
- : int = 5
```
Here's some more examples of partial application:

```ocaml
# List.map (plus 2) [1; 2; 3];;
- : int list = [3; 4; 5]
# let list_of_functions = List.map plus [1; 2; 3];;
val list_of_functions : (int -> int) list = [<fun>; <fun>; <fun>]
```

## What Is Functional Programming Good For?
Functional programming, like any good programming technique, is a useful
tool for solving some classes of problems. It's very
good for callbacks, which have multiple uses from GUIs to
event-driven loops. It's great for expressing generic algorithms.
`List.map` is really a generic algorithm for applying functions over any
type of list. Similarly you can define generic functions over trees.
Certain types of numerical problems can be solved more quickly with
functional programming (for example, numerically calculating the
derivative of a mathematical function).

## Pure and Impure Functional Programming
A **pure function** is one without any **side effects**. A side effect
means that the function keeps some sort of hidden state inside
it. `strlen` is a good example of a pure function in C. If you call
`strlen` with the same string, it always returns the same length. The
output of `strlen` (the length) only depends on the inputs (the string)
and nothing else. Many functions in C are, unfortunately, impure. For
example, `malloc`. If you call it with the same number, it certainly
won't return the same pointer to you. `malloc`, of course, relies on a
huge amount of hidden internal state (objects allocated on the heap, the
allocation method in use, grabbing pages from the operating system,
etc.).

ML-derived languages like OCaml are "mostly pure," meaning they allow
side effects through things like references and arrays. But
most of the code you'll write will be "pure functional" because functional languages
encourage this thinking. Haskell, another functional language, is pure
functional. OCaml is therefore more practical because writing impure
functions is sometimes useful.

There are various theoretical advantages of having pure functions. One
advantage is that if a function is pure, it is called several
times with the same arguments. The compiler only needs to actually call
the function once. A good example in C is:

```C
for (i = 0; i < strlen (s); ++i)
  {
    // Do something which doesn't affect s.
  }
```
If naively compiled, this loop is O(n<sup>2</sup>) because `strlen (s)`
is called each time and `strlen` needs to iterate over the whole of `s`.
If the compiler is smart enough to work out that `strlen` is pure
functional *and* that `s` is not updated in the loop, then it can remove
the redundant extra calls to `strlen` and make the loop O(n). Do
compilers really do this? In the case of `strlen` yes, in other cases,
probably not.

Concentrating on writing small pure functions allows you to construct
reusable code using a bottom-up approach, testing each small function as
you go along. The current fashion is to carefully plan your
programs using a top-down approach, but in this author's opinion, this
often results in projects failing.

## Strictness vs. Laziness
C-derived and ML-derived languages are strict. Haskell and Miranda are
non-strict, or lazy, languages. OCaml is strict by default, but it allows a
lazy style of programming when needed.

In a strict language, arguments to functions are always evaluated first,
and the results are then passed to the function. For example, in a strict
language, the call `give_me_a_three (1/0)` is always going to result in
a `divide-by-zero` error:

```ocaml
# let give_me_a_three _ = 3;;
val give_me_a_three : 'a -> int = <fun>
# give_me_a_three (1 / 0);;
Exception: Division_by_zero.
```

If you've programmed in any conventional language, this is just how
things work. You might be surprised that things could work any other
way.

In a lazy language, something stranger happens. Arguments to functions
are only evaluated if the function actually uses them. Remember that the
`give_me_a_three` function throws away its argument and always returns a
3? In a lazy language, the above call would *not* fail because
`give_me_a_three` never looks at its first argument, so the first
argument is never evaluated. Thus, the division by zero doesn't happen.

Lazy languages also let you do really odd things like defining an
infinitely long list, provided you don't actually try to iterate over
the whole list this works (say, instead, that you just try to fetch the
first 10 elements).

OCaml is a strict language, but has a `lazy` module that lets you write
lazy expressions. Here's an example. First we create a lazy expression
for `1/0`:

```ocaml
# let lazy_expr = lazy (1 / 0);;
val lazy_expr : int lazy_t = <lazy>
```

Notice the type of this lazy expression is `int lazy_t`.

Because `give_me_a_three` takes `'a` (any type) we can pass this lazy
expression into the function:

```ocaml
# give_me_a_three lazy_expr;;
- : int = 3
```

To evaluate a lazy expression, you must use the `Lazy.force` function:

```ocaml
# Lazy.force lazy_expr;;
Exception: Division_by_zero.
```

## Boxed vs. Unboxed Types
"Boxes" is a term you'll hear often when discussing functional languages. 
It can be confusing, but in fact
the distinction between boxed and unboxed types is quite simple if
you've used C, C++, or Java before (in Perl, everything is boxed).

The way to understand a boxed object is to think of an object which has
been allocated on the heap using `malloc` in C (or equivalently `new` in
C++) and/or is referred to through a pointer. Take a look at this
example C program:

```C
#include <stdio.h>

void
printit (int *ptr)
{
  printf ("the number is %d\n", *ptr);
}

void
main ()
{
  int a = 3;
  int *p = &a;

  printit (p);
}
```

The variable `a` is allocated on the stack, and it is quite definitely
unboxed.

The function `printit` takes a boxed integer and prints it.

The diagram below shows an array of unboxed (top) vs. boxed (below)
integers:

![Boxed Array](/media/tutorials/boxedarray.png)


(No prizes for guessing that the array of unboxed integers is much faster
than the array of boxed integers.) 

In addition, because there are fewer
separate allocations, garbage collection is much faster and simpler on
the array of unboxed objects.

In C or C++, you shouldn't have problems constructing either of the two
array types above. In Java, you have two types, `int` which is
unboxed and `Integer` which is boxed, hence considerably less
efficient. In OCaml, the basic types are all unboxed.

## Aliases for Function Names and Arguments
It's possible to use this as a neat trick to save typing: aliasing function
names and function arguments.

Although we haven't looked at object-oriented programming (that's the
subject for the ["Objects" section](/docs/objects)),
here's an example code pattern of an
aliased function call that can be found in OCamlNet. All you need to know is that
`cgi # output # output_string "string"` is a method call, similar to
`cgi.output().output_string ("string")` in Java. 

<!-- $MDX skip -->
```ocaml
let begin_page cgi title =
  let out = cgi # output # output_string in
  out "<html>\n";
  out "<head>\n";
  out ("<title>" ^ text title ^ "</title>\n");
  out ("<style type=\"text/css\">\n");
  out "body { background: white; color: black; }\n";
  out "</style>\n";
  out "</head>\n";
  out "<body>\n";
  out ("<h1>" ^ text title ^ "</h1>\n")
```

The `let out = ... ` is a partial function application for that method
call (partial, because the string parameter hasn't been applied). `out`
is therefore a function, which takes a string parameter.

<!-- $MDX skip -->
```ocaml
out "<html>\n";
```

is equivalent to:
<!-- $MDX skip -->
```ocaml
cgi # output # output_string "<html>\n";
```

By altering the code pattern, we saved ourselves a lot of typing there.

We can also add arguments. This alternative definition of `print_string`
can be thought of as a kind of alias for a function name plus arguments:

<!-- $MDX skip -->
```ocaml
let print_string = output_string stdout;;
```

`output_string` takes two arguments (a channel and a string), but since
we have only supplied one, it is partially applied. So `print_string` is
a function that expects one string argument.
