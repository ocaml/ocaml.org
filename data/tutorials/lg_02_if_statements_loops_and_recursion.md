---
id: if-statements-and-loops
title: If Statements, Loops and Recursions
description: >
  Learn basic control-flow and recursion in OCaml
category: "language"
date: 2021-05-27T21:07:30-00:00
---

# If Statements, Loops and Recursions

## If Statements (Actually, These Are if Expressions)
OCaml has an `if` statement with two variations, and the obvious meaning:

<!-- $MDX skip -->
```ocaml
if boolean-condition then expression
  
if boolean-condition then expression else other-expression
```

Unlike in the conventional languages you'll be used to, `if` statements
are really expressions. In other words, they're much more like
`boolean-condition ? expression : other-expression` in C than like the if
statements you may be used to.

Here's a simple example of an `if` statement:

```ocaml
# let max a b =
  if a > b then a else b;;
val max : 'a -> 'a -> 'a = <fun>
```

As a short aside, if you type this into the OCaml
interactive toplevel (as above), you'll
notice that OCaml decides that this function is polymorphic, with the
following type:

```ocaml
# max;;
- : 'a -> 'a -> 'a = <fun>
```

And indeed OCaml lets you use `max` on any type:

```ocaml
# max 3 5;;
- : int = 5
# max 3.5 13.0;;
- : float = 13.
# max "a" "b";;
- : string = "b"
```

This is because `>` is in fact polymorphic. It works on any type, even
objects (it does a binary comparison).

\[Note that the `Stdlib` module defines `min` and `max` for you.\]

Let's look a bit more closely at the `if` expression. Here's the `range`
function which I showed you earlier without much explanation. You should
be able to combine your knowledge of recursive functions, lists and if
expressions to see what it does:

```ocaml
# let rec range a b =
    if a > b then []
    else a :: range (a + 1) b;;
val range : int -> int -> int list = <fun>
```

Let's examine some typical calls to this function. Let's start with the
easy case of `a > b`. A call to `range 11 10` returns `[]` (the empty
list) and that's it.

What about calling `range 10 10`? Since `10 > 10` is false, the
`else`-clause is evaluated, which is: `10 :: (range 11 10)` (I've added
the brackets to make the order of evaluation more clear). We've just
worked out that `range 11 10` = `[]`, so this is: `10 :: []`. Remember
our formal description of lists and the `::` (cons) operator? `10 :: []`
is just the same as `[10]`.

Let's try `range 9 10`:

<!-- $MDX skip -->
```ocaml
range 9 10
→ 9 :: (range 10 10)
→ 9 :: [10]
→ [9; 10]
```

It should be fairly clear that `range 1 10` evaluates to
`[1; 2; 3; 4; 5; 6; 7; 8; 9; 10]`.

What we've got here is a simple case of recursion. Functional
programming can be said to prefer recursion over loops, but I'm jumping
ahead of myself. We'll discuss recursion more at the end of this
chapter.

Back, temporarily, to `if` statements. What does this function do?

```ocaml
# let f x y =
    x + if y > 0 then y else 0;;
val f : int -> int -> int = <fun>
```

Clue: add brackets around the whole of the if expression. It clips `y`
like an [electronic diode](https://en.wikipedia.org/wiki/Diode#Current.E2.80.93voltage_characteristic).

The `abs` (absolute value) function is defined in `Stdlib` as:

```ocaml
# let abs x =
    if x >= 0 then x else -x;;
val abs : int -> int = <fun>
```

Also in `Stdlib`, the `string_of_float` function contains a complex
pair of nested `if` expressions:

<!-- $MDX skip -->
```ocaml
let string_of_float f =
  let s = format_float "%.12g" f in
  let l = string_length s in
  let rec loop i =
    if i >= l then s ^ "."
    else if s.[i] = '.' || s.[i] = 'e' then s
    else loop (i + 1)
  in
    loop 0
```

Let's examine this function. Suppose the function is called with `f` =
12.34. Then `s` = "12.34", and `l` = 5. We call `loop` the first time
with `i` = 0.

`i` is not greater than or equal to `l`, and `s.[i]` (the
`i`<sup>th</sup> character in `s`) is not a period or `'e'`. So
`loop (i + 1)` is called, ie. `loop 1`.

We go through the same dance for `i` = 1, and end up calling `loop 2`.

For `i` = 2, however, `s.[i]` is a period (refer to the original string,
`s` = "12.34"). So this immediately returns `s`, and the function
`string_of_float` returns "12.34".

What is `loop` doing? In fact it's checking whether the string returned
from `format_float` contains a period (or `'e'`). Suppose that we called
`string_of_float` with `12.0`. `format_float` would return the string
"12", but `string_of_float` must return "12." or "12.0" (because
floating point constants in OCaml must contain a period to differentiate
them from integer constants). Hence the check.

The strange use of recursion in this function is almost certainly for
efficiency. OCaml supports for loops, so why didn't the authors use for
loops? We'll see in the next section that OCaml's for loops are limited
in a way which prevents them from being used in `string_of_float`. Here,
however, is a more straightforward, but approximately twice as slow, way
of writing `string_of_float`:

<!-- $MDX skip -->
```ocaml
let string_of_float f =
  let s = format_float "%.12g" f in
    if String.contains s '.' || String.contains s 'e'
      then s
      else s ^ "."
```

## Using `begin ... end`
Here is some code from lablgtk:

<!-- $MDX skip -->
```ocaml
if GtkBase.Object.is_a obj cls then
  fun _ -> f obj
else begin
  eprintf "Glade-warning: %s expects a %s argument.\n" name cls;
  raise Not_found
end
```

`begin` and `end` are what is known as **syntactic sugar** for open and
close parentheses. In the example above, all they do is group the two
statements in the `else`-clause together. Suppose the author had written
this instead:

<!-- $MDX skip -->
```ocaml
if GtkBase.Object.is_a obj cls then
  fun _ -> f obj
else
  eprintf "Glade-warning: %s expects a %s argument.\n" name cls;
  raise Not_found
```
Fully bracketing and properly indenting the above expression gives:

<!-- $MDX skip -->
```ocaml
(if GtkBase.Object.is_a obj cls then
   fun _ -> f obj
 else
   eprintf "Glade-warning: %s expects a %s argument.\n" name cls
);
raise Not_found
```
Not what was intended at all. So the `begin` and `end` are necessary to
group together multiple statements in a `then` or `else` clause of an if
expression. You can also use plain ordinary parentheses `( ... )` if you
prefer (and I do prefer, because I **loathe** Pascal :-). Here are two
simple examples:

```ocaml
# if 1 = 0 then
    print_endline "THEN"
  else begin
    print_endline "ELSE";
    failwith "else clause"
  end;;
ELSE
Exception: Failure "else clause".
# if 1 = 0 then
    print_endline "THEN"
  else (
    print_endline "ELSE";
    failwith "else clause"
  );;
ELSE
Exception: Failure "else clause".
```

## For Loops and While Loops
OCaml supports a rather limited form of the familiar `for` loop:

<!-- $MDX skip -->
```ocaml
for variable = start_value to end_value do
  expression
done
  
for variable = start_value downto end_value do
  expression
done
```
A simple but real example from lablgtk:

<!-- $MDX skip -->
```ocaml
for i = 1 to n_jobs () do
  do_next_job ()
done
```
In OCaml, `for` loops are just shorthand for writing:

<!-- $MDX skip -->
```ocaml
let i = 1 in
do_next_job ();
let i = 2 in
do_next_job ();
let i = 3 in
do_next_job ();
  ...
let i = n_jobs () in
do_next_job ();
()
```

OCaml doesn't support the concept of breaking out of a `for` loop early
i.e. it has no `break`, `continue` or `last` statements. (You *could*
throw an exception and catch it outside, and this would run fast but
often looks clumsy.)

The expression inside an OCaml for loop should evaluate to `unit`
(otherwise you'll get a warning), and the for loop expression as a whole
returns `unit`:

```ocaml
# for i = 1 to 10 do i done;;
Line 1, characters 20-21:
Warning 10 [non-unit-statement]: this expression should have type unit.
- : unit = ()
```
Functional programmers tend to use recursion instead of explicit loops,
and regard **for** loops with suspicion since it can't return anything,
hence OCaml's relatively powerless **for** loop. We talk about recursion
below.

**While loops** in OCaml are written:

<!-- $MDX skip -->
```ocaml
while boolean-condition do
  expression
done
```
As with for loops, there is no way provided by the language to break out
of a while loop, except by throwing an exception, and this means that
while loops have fairly limited use. Again, remember that functional
programmers like recursion, and so while loops are second-class citizens
in the language.

If you stop to consider while loops, you may see that they aren't really
any use at all, except in conjunction with our old friend references.
Let's imagine that OCaml didn't have references for a moment:

<!-- $MDX skip -->
```ocaml
let quit_loop = false in
  while not quit_loop do
    print_string "Have you had enough yet? (y/n) ";
    let str = read_line () in
      if str.[0] = 'y' then
        (* how do I set quit_loop to true ?!? *)
  done
```
Remember that `quit_loop` is not a real "variable" - the let-binding
just makes `quit_loop` a shorthand for `false`. This means the while
loop condition (shown in red) is always true, and the loop runs on
forever!

Luckily OCaml *does have* references, so we can write the code above if
we want. Don't get confused and think that the `!` (exclamation mark)
means "not" as in C/Java. It's used here to mean "dereference the
pointer", similar in fact to Forth. You're better off reading `!` as
"get" or "deref".

<!-- $MDX skip -->
```ocaml
let quit_loop = ref false in
  while not !quit_loop do
    print_string "Have you had enough yet? (y/n) ";
    let str = read_line () in
      if str.[0] = 'y' then quit_loop := true
  done;;
```

## Looping Over Lists
If you want to loop over a list, don't be an imperative programmer and
reach for your trusty six-shooter Mr. For Loop! OCaml has some better
and faster ways to loop over lists, and they are all located in the
`List` module. There are in fact dozens of good functions in `List`, but
I'll only talk about the most useful ones here.

First off, let's define a list for us to use:

```ocaml
# let my_list = [1; 2; 3; 4; 5; 6; 7; 8; 9; 10];;
val my_list : int list = [1; 2; 3; 4; 5; 6; 7; 8; 9; 10]
```

If you want to call a function once on every element of the list, use
`List.iter`, like this:

```ocaml
# let f elem =
    Printf.printf "I'm looking at element %d now\n" elem
  in
    List.iter f my_list;;
I'm looking at element 1 now
I'm looking at element 2 now
I'm looking at element 3 now
I'm looking at element 4 now
I'm looking at element 5 now
I'm looking at element 6 now
I'm looking at element 7 now
I'm looking at element 8 now
I'm looking at element 9 now
I'm looking at element 10 now
- : unit = ()
```

`List.iter` is in fact what you should think about using first every
time your cerebellum suggests you use a for loop.

If you want to *transform* each element separately in the list - for
example, doubling each element in the list - then use `List.map`.

```ocaml
# List.map (( * ) 2) my_list;;
- : int list = [2; 4; 6; 8; 10; 12; 14; 16; 18; 20]
```

The function `List.filter` collects only those elements of a list which satisfy
some condition - e.g. returning all even numbers in a list.

```ocaml
# let is_even i =
    i mod 2 = 0
  in
    List.filter is_even my_list;;
- : int list = [2; 4; 6; 8; 10]
```

To find out if a list contains some element, use `List.mem` (short for
member):

```ocaml
# List.mem 12 my_list;;
- : bool = false
```

`List.for_all` and `List.exists` are the same as the "forall" and
"exist" operators in predicate logic.

For operating over two lists at the same time, there are "-2" variants
of some of these functions, namely `iter2`, `map2`, `for_all2`,
`exists2`.

The `map` and `filter` functions operate on individual list elements in
isolation. **Fold** is a more unusual operation that is best
thought about as "inserting an operator between each element of the
list". Suppose I wanted to add all the numbers in my list together. In
hand-waving terms what I want to do is insert a plus sign between the
elements in my list:

```ocaml
# 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8 + 9 + 10;;
- : int = 55
```

The fold operation does this, although the exact details are a little
bit more tricky. First of all, what happens if I try to fold an empty
list? In the case of summing the list it would be nice if the answer was
zero, instead of error. However if I was trying to find the product of
the list, I'd like the answer to be one instead. So I obviously have to
provide some sort of "default" argument to my fold. The second issue
doesn't arise with simple operators like `+` and `*`: what happens if
the operator I'm using isn't associative, ie. (a *op* b) *op* c not
equal to a *op* (b *op* c)? In that case it would matter if I started
from the left hand end of the list and worked right, versus if I started
from the right and worked left. For this reason there are two versions
of fold, called `List.fold_left` (works left to right) and
`List.fold_right` (works right to left, and is also less efficient).

Let's use `List.fold_left` to define `sum` and `product` functions for
integer lists:

```ocaml
# let sum = List.fold_left ( + ) 0;;
val sum : int list -> int = <fun>
# let product = List.fold_left ( * ) 1;;
val product : int list -> int = <fun>
# sum my_list;;
- : int = 55
# product my_list;;
- : int = 3628800
```

That was easy! Notice that I've accidentally come up with a way to do
mathematical factorials:

```ocaml
# let fact n = product (range 1 n);;
val fact : int -> int = <fun>
# fact 10;;
- : int = 3628800
```

(Notice that this factorial function isn't very useful because it
overflows the integers and gives wrong answers even for quite small
values of `n`.)

## Looping Over Strings
The `String` module also contains many dozens of useful string-related
functions, and some of them are concerned with looping over strings.

`String.copy` copies a string, like `strdup`. There is also a `String.iter`
function which works like `List.iter`, except over the characters of the
string.

## Recursion
Now we come to a hard topic - recursion. Functional programmers are
defined by their love of recursive functions, and in many ways recursive
functions in f.p. are the equivalent of loops in imperative programming.
In functional languages loops are second-class citizens, whilst
recursive functions get all the best support.

Writing recursive functions requires a change in mindset from writing
for loops and while loops. So what I'll give you in this section will be
just an introduction and examples.

In the first example we're going to read the whole of a file into memory
(into a long string). There are essentially three possible approaches to
this:

### Approach 1
Get the length of the file, and read it all in one go using the
`really_input` method. This is the simplest, but it might not work on
channels which are not really files (eg. reading keyboard input) which
is why we look at the other two approaches.

### Approach 2
The imperative approach, using a while loop which is broken out of using
an exception.

### Approach 3
A recursive loop, breaking out of the recursion again using an
exception.

We're going to introduce a few new concepts here. Our second two
approaches will use the `Buffer` module - an expandable buffer which you
can think of like a string onto which you can efficiently append more
text at the end. We're also going to be catching the `End_of_file`
exception which the input functions throw when they reach the end of the
input. Also we're going to use `Sys.argv.(1)` to get the first command
line parameter.

```ocaml
(* Read whole file: Approach 1 *)
open Printf
  
let read_whole_chan chan =
  let len = in_channel_length chan in
  let result = (Bytes.create len) in
    really_input chan result 0 len;
    (Bytes.to_string result)
  
let read_whole_file filename =
  let chan = open_in filename in
    read_whole_chan chan
  
let main () =
  let filename = Sys.argv.(1) in
  let str = read_whole_file filename in
    printf "I read %d characters from %s\n" (String.length str) filename
```

Approach 1 works but is not very satisfactory because `read_whole_chan`
won't work on non-file channels like keyboard input or sockets. Approach
2 involves a while loop:

```ocaml
(* Read whole file: Approach 2 *)
open Printf
  
let read_whole_chan chan =
  let buf = Buffer.create 4096 in
  try
    while true do
      let line = input_line chan in
        Buffer.add_string buf line;
        Buffer.add_char buf '\n'
    done;
    assert false (* This is never executed
	                (always raises Assert_failure). *)
  with
    End_of_file -> Buffer.contents buf
  
let read_whole_file filename =
  let chan = open_in filename in
    read_whole_chan chan
  
let main () =
  let filename = Sys.argv.(1) in
  let str = read_whole_file filename in
    printf "I read %d characters from %s\n" (String.length str) filename
```

The key to approach 2 is to look at the central while loop. Remember
that I said the only way to break out of a while loop early was with an
exception? This is exactly what we're doing here. Although I haven't
covered exceptions yet, you probably won't have any trouble
understanding the `End_of_file` exception thrown in the code above by
`input_line` when it hits the end of the file. The buffer `buf`
accumulates the contents of the file, and when we hit the end of the
file we return it (`Buffer.contents buf`).

One curious point about this is the apparently superfluous statement
(`assert false`) just after the while loop. What is it for?  Remember
that while loops, like for loops, are just expressions, and they return
the `unit` object (`()`). However OCaml demands that the return type
inside a `try` matches the return type of each caught exception. In this
case because `End_of_file` results in a `string`, the main body of the
`try` must also "return" a string — even though because of the infinite
while loop the string could never actually be returned.  `assert false`
has a polymorphic type, so will unify with whatever value is returned
by the `with` branch.

Here's our recursive version. Notice that it's *shorter* than approach
2, but not so easy to understand for imperative programmers at least:

```ocaml
(* Read whole file: Approach 3 *)
open Printf
  
let read_whole_chan chan =
  let buf = Buffer.create 4096 in
  let rec loop () =
    let line = input_line chan in
      Buffer.add_string buf line;
      Buffer.add_char buf '\n';
      loop ()
  in
    try loop () with
      End_of_file -> Buffer.contents buf
  
let read_whole_file filename =
  let chan = open_in filename in
    read_whole_chan chan
  
let main () =
  let filename = Sys.argv.(1) in
  let str = read_whole_file filename in
  printf "I read %d characters from %s\n" (String.length str) filename
```

Again we have an infinite loop - but in this case done using recursion.
`loop` calls itself at the end of the function. The infinite recursion
is broken when `input_line` throws an `End_of_file` exception.

It looks like approach 3 might overflow the stack if you gave it a
particularly large file, but this is in fact not the case. Because of
tail recursion (discussed below) the compiler will turn the recursive
`loop` function into a real while loop (!) which runs in constant stack
space.

In the next example we will show how recursion is great for constructing
or examining certain types of data structures, particularly trees. Let's
have a recursive type to represent files in a filesystem:

```ocaml
# type filesystem = File of string | Directory of filesystem list;;
type filesystem = File of string | Directory of filesystem list
```

The `opendir` and `readdir` functions are used to open a directory and
read elements from the directory. I'm going to define a handy
`readdir_no_ex` function which hides the annoying `End_of_file`
exception that `readdir` throws when it reaches the end of the
directory:

```ocaml
# #load "unix.cma";;
# open Unix;;
# let readdir_no_ex dirh =
  try
    Some (readdir dirh)
  with
    End_of_file -> None;;
val readdir_no_ex : dir_handle -> string option = <fun>
```
The type of `readdir_no_ex` is this. Recall our earlier discussion about
null pointers.

```ocaml
# readdir_no_ex;;
- : dir_handle -> string option = <fun>
```

I'm also going to define a simple recursive function which I can use to
convert the `filesystem` type into a string for (eg) printing:

```ocaml
# let rec string_of_filesystem fs =
  match fs with
  | File filename -> filename ^ "\n"
  | Directory fs_list ->
      List.fold_left (^) "" (List.map string_of_filesystem fs_list);;
val string_of_filesystem : filesystem -> string = <fun>
```

Note the use of `fold_left` and `map`. The `map` is used to
(recursively) convert each `filesystem` in the list into a `string`.
Then the `fold_left (^) ""` concatenates the list together into one big
string. Notice also the use of pattern matching. (The library defines a
function called `String.concat` which is essentially equivalent to
`fold_left (^) `, but implemented more efficiently).

Now let's define a function to read a directory structure, recursively,
and return a recursive `filesystem` data structure. I'm going to show
this function in steps, but I'll print out the entire function at the
end of this section. First the outline of the function:

<!-- $MDX skip -->
```ocaml
let rec read_directory path =
  let dirh = opendir path in
  let rec loop () =
    (* ..... *) in
  Directory (loop ())
```

The call to `opendir` opens up the given path and returns a `dir_handle`
from which we will be able to read the names using `readdir_no_ex`
later. The return value of the function is going to be a
`Directory fs_list`, so all we need to do to complete the function is to
write our function `loop` which returns a list of `filesystem`s. The
type of `loop` will be:

<!-- $MDX skip -->
```ocaml
loop : unit -> filesystem list
```

How do we define loop? Let's take it in steps again.

<!-- $MDX skip -->
```ocaml
let rec loop () =
  let filename = readdir_no_ex dirh in
  (* ..... *)
```

First we read the next filename from the directory handle. `filename`
has type `string option`, in other words it could be `None` or
`Some "foo"` where `foo` is the name of the next filename in the
directory. We also need to ignore the `"."` and `".."` files (ie. the
current directory and the parent directory). We can do all this with a
nice pattern match:

<!-- $MDX skip -->
```ocaml
let rec loop () =
  let filename = readdir_no_ex dirh in
    match filename with
    | None -> []
    | Some "." -> loop ()
    | Some ".." -> loop ()
    | Some filename ->
        (* ..... *)
```

The `None` case is easy. Thinking recursively (!) if `loop` is called
and we've reached the end of the directory, `loop` needs to return a
list of entries - and there's no entries - so it returns the empty list
(`[]`).

For `"."` and `".."` we just ignore the file and call `loop` again.

What do we do when `loop` reads a real filename (the `Some filename`
match below)? Let `pathname` be the full path to the file. We 'stat' the
file to see if it's really a directory. If it *is* a directory, we set
`this` by recursively calling `read_directory` which will return
`Directory something`. Notice that the overall result of
`read_directory` is `Directory (loop ())`. If the file is really a file
(not a directory) then we let `this` be `File pathname`. Then we do
something clever: we return `this :: loop ()`. This is the recursive
call to `loop ()` to calculate the remaining directory members (a list),
to which we prepend `this`.

```ocaml
# let rec read_directory path =
  let dirh = opendir path in
  let rec loop () =
    let filename = readdir_no_ex dirh in
      match filename with
      | None -> []
      | Some "." -> loop ()
      | Some ".." -> loop ()
      | Some filename ->
          let pathname = path ^ "/" ^ filename in
          let stat = lstat pathname in
          let this =
            if stat.st_kind = S_DIR then
              read_directory pathname
            else
              File pathname
          in
            this :: loop ()
  in
    Directory (loop ());;
val read_directory : string -> filesystem = <fun>
```

That's quite a complex bit of recursion, but although this is a made-up
example, it's fairly typical of the complex patterns of recursion found
in real-world functional programs. The two important lessons to take
away from this are:

* The use of recursion to build a list:

<!-- $MDX skip -->
```ocaml
let rec loop () =
  match data with (* Could also be an if statement *)
  | base case -> []
  | recursive case -> element :: loop ()
```
Compare this to our previous `range` function. The pattern of recursion
is exactly the same:

<!-- $MDX skip -->
```ocaml
# let rec range a b =
  if a > b then []              (* Base case *)
  else a :: range (a + 1) b     (* Recursive case *)
```

* The use of recursion to build up trees:

<!-- $MDX skip -->
```ocaml
let rec read_directory path =
  (* blah blah *)
  if file_is_a_directory path then
    read_directory path_to_file
  else
    Leaf file
```
All that remains now to make this a working program is a little bit of
code to call `read_directory` and display the result:

<!-- $MDX skip -->
```ocaml
let path = Sys.argv.(1) in
let fs = read_directory path in
print_endline (string_of_filesystem fs)
```

### Recursion Example: Maximum Element in a List
Remember the basic recursion pattern for lists:

<!-- $MDX skip -->
```ocaml
let rec loop () =
  a match or if statement
  | base case -> []
  | recursive case -> element :: loop ()
```
The key here is actually the use of the match / base case / recursive
case pattern. In this example - finding the maximum element in a list -
we're going to have two base cases and one recursive case. But before I
jump ahead to the code, let's just step back and think about the
problem. By thinking about the problem, the solution will appear "as if
by magic" (I promise you :-)

First of all, let's be clear that the maximum element of a list is just
the biggest one, e.g. the maximum element of the list `[1; 2; 3; 4; 1]`
is `4`.

Are there any special cases? Yes, there are. What's the maximum element
of the empty list `[]`? There *isn't one*. If we are passed an empty
list, we should throw an error.

What's the maximum element of a single element list such as `[4]`?
That's easy: it's just the element itself. So `list_max [4]` should
return `4`, or in the general case, `list_max [x]` should return `x`.

What's the maximum element of the general list `x :: remainder` (this is
the "cons" notation for the list, so `remainder` is the tail - also a
list)?

Think about this for a while. Suppose you know the maximum element of
`remainder`, which is, say, `y`. What's the maximum element of
`x :: remainder`? It depends on whether `x > y` or `x <= y`. If `x` is
bigger than `y`, then the overall maximum is `x`, whereas conversely if
`x` is less than `y`, then the overall maximum is `y`.

Does this really work? Consider `[1; 2; 3; 4; 1]` again. This is
`1 :: [2; 3; 4; 1]`. Now the maximum element of the remainder,
`[2; 3; 4; 1]`, is `4`. So now we're interested in `x = 1` and `y = 4`.
That head element `x = 1` doesn't matter because `y = 4` is bigger, so
the overall maximum of the whole list is `y = 4`.

Let's now code those rules above up, to get a working function:

```ocaml
# let rec list_max xs =
  match xs with
  | [] -> (* empty list: fail *)
      failwith "list_max called on empty list"
  | [x] -> (* single element list: return the element *)
      x
  | x :: remainder -> (* multiple element list: recursive case *)
      max x (list_max remainder);;
val list_max : 'a list -> 'a = <fun>
```
I've added comments so you can see how the rules / special cases we
decided upon above really correspond to lines of code.

Does it work?

```ocaml
# list_max [1; 2; 3; 4; 1];;
- : int = 4
# list_max [];;
Exception: Failure "list_max called on empty list".
# list_max [5; 4; 3; 2; 1];;
- : int = 5
# list_max [5; 4; 3; 2; 1; 100];;
- : int = 100
```
Notice how the solution proposed is both (a) very different from the
imperative for-loop solution, and (b) much more closely tied to the
problem specification. Functional programmers will tell you that this is
because the functional style is much higher level than the imperative
style, and therefore better and simpler. Whether you believe them is up
to you. It's certainly true that it's much simpler to reason logically
about the functional version, which is useful if you wanted to formally
prove that `list_max` is correct ("correct" being the mathematical way
to say that a program is provably bug-free, useful for space shuttles,
nuclear power plants and higher quality software in general).

### Tail Recursion
Let's look at the `range` function again for about the twentieth time:

```ocaml
# let rec range a b =
  if a > b then []
  else a :: range (a+1) b;;
val range : int -> int -> int list = <fun>
```
I'm going to rewrite it slightly to make something about the structure
of the program clearer (still the same function however):

```ocaml
# let rec range a b =
  if a > b then [] else
    let result = range (a+1) b in
      a :: result;;
val range : int -> int -> int list = <fun>
```
Let's call it:

```ocaml
# List.length (range 1 10);;
- : int = 10
# List.length (range 1 1000000);;
Stack overflow during evaluation (looping recursion?).
```
Hmmm ... at first sight this looks like a problem with recursive
programming, and hence with the whole of functional programming! If you
write your code recursively instead of iteratively then you necessarily
run out of stack space on large inputs, right?

In fact, wrong. Compilers can perform a simple optimisation on certain
types of recursive functions to turn them into while loops. These
certain types of recursive functions therefore run in constant stack
space, and with the equivalent efficiency of imperative while loops.
These functions are called **tail-recursive functions**.

In tail-recursive functions, the recursive call happens last of all.
Remember our `loop ()` functions above? They all had the form:

<!-- $MDX skip -->
```ocaml
let rec loop () =
  (* do something *)
  loop ()
```
Because the recursive call to `loop ()` happens as the very last thing,
`loop` is tail-recursive and the compiler will turn the whole thing into
a while loop.

Unfortunately `range` is not tail-recursive, and the longer version
above shows why. The recursive call to `range` doesn't happen as the
very last thing. In fact the last thing to happen is the `::` (cons)
operation. As a result, the compiler doesn't turn the recursion into a
while loop, and the function is not efficient in its use of stack space.

The use of an accumulating argument or `accumulator` allows one to write
functions such as `range` above in a tail-recursive manner, which means they
will be efficient and work properly on large inputs. Let's plan our rewritten
`range` function which will use an accumulator argument to store the "result so
far":

<!-- $MDX skip -->
```ocaml
let rec range2 a b accum =
  (* ... *)
  
let range a b =
  range2 a b []
```

The `accum` argument is going to accumulate the result. It's the "result
so far". We pass in the empty list ("no result so far"). The easy case
is when `a > b`:

<!-- $MDX skip -->
```ocaml
let rec range2 a b accum =
  if a > b then accum
  else
    (* ... *)
```
If `a > b` (i.e. if we've reached the end of the recursion), then stop
and return the result (`accum`).

Now the trick is to write the `else`-clause and make sure that the call
to `range2` is the very last thing that we do, so the function is
tail-recursive:

```ocaml
# let rec range2 a b accum =
  if a > b then accum
  else range2 (a + 1) b (a :: accum);;
val range2 : int -> int -> int list -> int list = <fun>
```
There's only one slight problem with this function: it constructs the
list backwards! However, this is easy to rectify by redefining range as:

```ocaml
# let range a b = List.rev (range2 a b []);;
val range : int -> int -> int list = <fun>
```
It works this time, although it's a bit slow to run because it really
does have to construct a list with a million elements in it:

```ocaml
# List.length (range 1 1000000);;
- : int = 1000000
```
The following implementation is twice as fast as the previous one,
because it does not need to reverse a list:

```ocaml
# let rec range2 a b accum =
  if b < a then accum
  else range2 a (b - 1) (b :: accum);;
val range2 : int -> int -> int list -> int list = <fun>
# let range a b =
  range2 a b [];;
val range : int -> int -> int list = <fun>
```
That was a brief overview of tail recursion, but in real world
situations determining if a function is tail recursive can be quite
hard. What did we really learn here? One thing is that recursive
functions have a dangerous trap for inexperienced programmers. Your
function can appear to work for small inputs (during testing), but fail
catastrophically in the field when exposed to large inputs. This is one
argument *against* using recursive functions, and for using explicit
while loops when possible.

## Mutable Records, References (Again!) and Arrays
Previously we mentioned records in passing. These are like C `struct`s:

```ocaml
# type pair_of_ints = {a : int; b : int};;
type pair_of_ints = { a : int; b : int; }
# {a = 3; b = 5};;
- : pair_of_ints = {a = 3; b = 5}
# {a = 3};;
Line 1, characters 1-8:
Error: Some record fields are undefined: b
```

One feature which I didn't cover: OCaml records can have mutable fields.
Normally an expression like `{a = 3; b = 5}` is an immutable, constant
object. However if the record has **mutable fields**, then
there is a way to change those fields in the record. This is an
imperative feature of OCaml, because functional languages don't normally
allow mutable objects (or references or mutable arrays, which we'll look
at in a moment).

Here is an object defined with a mutable field. This field is used to
count how many times the object has been accessed. You could imagine
this being used in a caching scheme to decide which objects you'd evict
from memory.

```ocaml
# type name = {name : string; mutable access_count : int};;
type name = { name : string; mutable access_count : int; }
```

Here is a function defined on names which prints the `name` field and
increments the mutable `access_count` field:

```ocaml
# let print_name name =
  print_endline ("The name is " ^ name.name);
  name.access_count <- name.access_count + 1;;
val print_name : name -> unit = <fun>
```

Notice a strange, and very non-functional feature of `print_name`: it modifies
its `access_count` parameter. This function is not "pure". OCaml is a
functional language, but not to the extent that it forces functional
programming down your throat.

Anyway, let's see `print_name` in action:

```ocaml
# let n = {name = "Richard Jones"; access_count = 0};;
val n : name = {name = "Richard Jones"; access_count = 0}
# n;;
- : name = {name = "Richard Jones"; access_count = 0}
# print_name n;;
The name is Richard Jones
- : unit = ()
# n;;
- : name = {name = "Richard Jones"; access_count = 1}
# print_name n;;
The name is Richard Jones
- : unit = ()
# n;;
- : name = {name = "Richard Jones"; access_count = 2}
```

Only fields explicitly marked as `mutable` can be assigned to using the
`<-` operator. If you try to assign to a non-mutable field, OCaml won't
let you:

```ocaml
# n.name <- "John Smith";;
Line 1, characters 1-23:
Error: The record field name is not mutable
```
References, with which we should be familiar by now, are implemented
using records with a mutable `contents` field. Check out the definition
in `Stdlib`:

```ocaml
type 'a ref = {mutable contents : 'a}
```

And look closely at what the OCaml toplevel prints out for the value of
a reference:

```ocaml
# let r = ref 100;;
val r : int Stdlib.ref = {Stdlib.contents = 100}
```

Arrays are another sort of mutable structure provided by OCaml. In
OCaml, plain lists are implemented as linked lists, and linked lists are
slow for some types of operation. For example, getting the head of a
list, or iterating over a list to perform some operation on each element
is reasonably fast. However, jumping to the n<sup>th</sup> element of a
list, or trying to randomly access a list - both are slow operations.
The OCaml `Array` type is a real array, so random access is fast, but
insertion and deletion of elements is slow. `Array`s are also mutable so
you can randomly change elements too.

The basics of arrays are simple:

```ocaml
# let a = Array.create 10 0;;
Line 1, characters 9-21:
Alert deprecated: Stdlib.Array.create
Use Array.make/ArrayLabels.make instead.
val a : int array = [|0; 0; 0; 0; 0; 0; 0; 0; 0; 0|]
# for i = 0 to Array.length a - 1 do
    a.(i) <- i
  done;;
- : unit = ()
# a;;
- : int array = [|0; 1; 2; 3; 4; 5; 6; 7; 8; 9|]
```
Notice the syntax for writing arrays: `[| element; element; ... |]`

The OCaml compiler was designed with heavy numerical processing in mind
(the sort of thing that FORTRAN is traditionally used for), and so it
contains various optimisations specifically for arrays of numbers,
vectors and matrices. Here is some benchmark code for doing dense matrix
multiplication. Notice that it uses for-loops and is generally very
imperative in style:

```ocaml
# let size = 30;;
val size : int = 30

# let mkmatrix rows cols =
  let count = ref 1
  and last_col = cols - 1
  and m = Array.make_matrix rows cols 0 in
    for i = 0 to rows - 1 do
      let mi = m.(i) in
        for j = 0 to last_col do
          mi.(j) <- !count;
          incr count
        done;
    done;
    m;;
val mkmatrix : int -> int -> int array array = <fun>

# let rec inner_loop k v m1i m2 j =
  if k < 0 then v
  else inner_loop (k - 1) (v + m1i.(k) * m2.(k).(j)) m1i m2 j;;
val inner_loop : int -> int -> int array -> int array array -> int -> int =
  <fun>

# let mmult rows cols m1 m2 m3 =
  let last_col = cols - 1
  and last_row = rows - 1 in
    for i = 0 to last_row do
      let m1i = m1.(i) and m3i = m3.(i) in
      for j = 0 to last_col do
        m3i.(j) <- inner_loop last_row 0 m1i m2 j
      done;
    done;;
val mmult :
  int -> int -> int array array -> int array array -> int array array -> unit =
  <fun>

# let () =
  let n =
    try int_of_string Sys.argv.(1)
    with Invalid_argument _ -> 1
  and m1 = mkmatrix size size
  and m2 = mkmatrix size size
  and m3 = Array.make_matrix size size 0 in
    for i = 1 to n - 1 do
      mmult size size m1 m2 m3
    done;
    mmult size size m1 m2 m3;
    Printf.printf "%d %d %d %d\n" m3.(0).(0) m3.(2).(3) m3.(3).(2) m3.(4).(4);;
Exception: Failure "int_of_string".
```

## Mutually Recursive Functions
Suppose I want to define two functions which call each other. This is
actually not a very common thing to do, but it can be useful sometimes.
Here's a contrived example (thanks to Ryan Tarpine): The number 0 is
even. Other numbers greater than 0 are even if their predecessor is odd.
Hence:

```ocaml
# let rec even n =
  match n with
  | 0 -> true
  | x -> odd (x - 1);;
Line 4, characters 10-13:
Error: Unbound value odd
```

The code above doesn't compile because we haven't defined the function
`odd` yet! That's easy though. Zero is not odd, and other numbers
greater than 0 are odd if their predecessor is even. So to make this
complete we need that function too:

```ocaml
# let rec even n =
  match n with
  | 0 -> true
  | x -> odd (x - 1);;
Line 4, characters 10-13:
Error: Unbound value odd

# let rec odd n =
  match n with
  | 0 -> false
  | x -> even (x - 1);;
Line 4, characters 10-14:
Error: Unbound value even
```

The only problem is... this program doesn't compile. In order to compile
the `even` function, we already need the definition of `odd`, and to
compile `odd` we need the definition of `even`. So swapping the two
definitions around won't help either.

There are no "forward prototypes" (as seen in languages descended
from C) in OCaml but there is a special syntax
for defining a set of two or more mutually recursive functions, like
`odd` and `even`:

```ocaml
# let rec even n =
    match n with
    | 0 -> true
    | x -> odd (x - 1)
  and odd n =
    match n with
    | 0 -> false
    | x -> even (x - 1);;
val even : int -> bool = <fun>
val odd : int -> bool = <fun>
```

You can also
use similar syntax for writing mutually recursive class definitions and
modules.
