---
title: Debug
description: >
  Learn to build custom types and write function to process this data
users:
  - beginner
  - intermediate
tags: [ "debugging" ]
date: 2021-05-27T21:07:30-00:00
---

This tutorial presents two techniques for debugging OCaml programs:

* [Tracing functions calls](#Tracingfunctionscallsinthetoplevel),
  which works in the interactive toplevel.
* The [OCaml debugger](#The-OCaml-debugger), which allows analysing programs
  compiled with `ocamlc`.

## Tracing functions calls in the toplevel

The simplest way to debug programs in the toplevel is to follow the function
calls, by “tracing” the faulty function:

```ocaml
# let rec fib x = if x <= 1 then 1 else fib (x - 1) + fib (x - 2)
val fib : int -> int = <fun>
# #trace fib
fib is now traced.
# fib 3
fib <-- 3
fib <-- 1
fib --> 1
fib <-- 2
fib <-- 0
fib --> 1
fib <-- 1
fib --> 1
fib --> 2
fib --> 3
- : int = 3
# #untrace fib
fib is no longer traced.
```

###  Polymorphic functions

A difficulty with polymorphic functions is that the output of the trace system
is not very informative in case of polymorphic arguments and/or results.
Consider a sorting algorithm (say bubble sort):

```ocaml
# let exchange i j v =
  let aux = v.(i) in
    v.(i) <- v.(j);
    v.(j) <- aux
val exchange : int -> int -> 'a array -> unit = <fun>
# let one_pass_vect fin v =
  for j = 1 to fin do
    if v.(j - 1) > v.(j) then exchange (j - 1) j v
  done
val one_pass_vect : int -> 'a array -> unit = <fun>
# let bubble_sort_vect v =
  for i = Array.length v - 1 downto 0 do
    one_pass_vect i v
  done
val bubble_sort_vect : 'a array -> unit = <fun>
# let q = [|18; 3; 1|]
val q : int array = [|18; 3; 1|]
# #trace one_pass_vect
one_pass_vect is now traced.
# bubble_sort_vect q
one_pass_vect <-- 2
one_pass_vect --> <fun>
one_pass_vect* <-- [|<poly>; <poly>; <poly>|]
one_pass_vect* --> ()
one_pass_vect <-- 1
one_pass_vect --> <fun>
one_pass_vect* <-- [|<poly>; <poly>; <poly>|]
one_pass_vect* --> ()
one_pass_vect <-- 0
one_pass_vect --> <fun>
one_pass_vect* <-- [|<poly>; <poly>; <poly>|]
one_pass_vect* --> ()
- : unit = ()
```

The function `one_pass_vect` being polymorphic, its vector argument is printed
as a vector containing polymorphic values, `[|<poly>; <poly>; <poly>|]`, and
thus we cannot properly follow the computation.

A simple way to overcome this problem is to define a monomorphic version of the
faulty function. This is fairly easy using a *type constraint*.  Generally
speaking, this allows a proper understanding of the error in the definition of
the polymorphic function. Once this has been corrected, you just have to
suppress the type constraint to revert to a polymorphic version of the
function.

For our sorting routine, a single type constraint on the argument of the
`exchange` function warranties a monomorphic typing, that allows a proper trace
of function calls:

```ocaml
# let exchange i j (v : int array) =    (* notice the type constraint *)
  let aux = v.(i) in
    v.(i) <- v.(j);
    v.(j) <- aux
val exchange : int -> int -> int array -> unit = <fun>
# let one_pass_vect fin v =
  for j = 1 to fin do
    if v.(j - 1) > v.(j) then exchange (j - 1) j v
  done
val one_pass_vect : int -> int array -> unit = <fun>
# let bubble_sort_vect v =
  for i = Array.length v - 1 downto 0 do
    one_pass_vect i v
  done
val bubble_sort_vect : int array -> unit = <fun>
# let q = [| 18; 3; 1 |]
val q : int array = [|18; 3; 1|]
# #trace one_pass_vect
one_pass_vect is now traced.
# bubble_sort_vect q
one_pass_vect <-- 2
one_pass_vect --> <fun>
one_pass_vect* <-- [|18; 3; 1|]
one_pass_vect* --> ()
one_pass_vect <-- 1
one_pass_vect --> <fun>
one_pass_vect* <-- [|3; 1; 18|]
one_pass_vect* --> ()
one_pass_vect <-- 0
one_pass_vect --> <fun>
one_pass_vect* <-- [|1; 3; 18|]
one_pass_vect* --> ()
- : unit = ()
```

###  Limitations

To keep track of assignments to data structures and mutable variables in a
program, the trace facility is not powerful enough. You need an extra mechanism
to stop the program in any place and ask for internal values: that is a
symbolic debugger with its stepping feature.

Stepping a functional program has a meaning which is a bit weird to define and
understand. Let me say that we use the notion of *runtime events* that happen
for instance when a parameter is passed to a function or when entering a
pattern matching, or selecting a clause in a pttern matching. Computation
progress is taken into account by these events, independently of the
instructions executed on the hardware.

Although this is difficult to implement, there exists such a debugger for OCaml
under Unix: `ocamldebug`. Its use is illustrated in the next section.

In fact, for complex programs, it is likely the case that the programmer will
use explicit printing to find the bugs, since this methodology allows the
reduction of the trace material: only useful data are printed and special
purpose formats are more suited to get the relevant information, than what can
be output automatically by the generic pretty-printer used by the trace
mechanism.

## The OCaml debugger

We now give a quick tutorial for the OCaml debugger (`ocamldebug`).  Before
starting, please note that `ocamldebug` does not work under native Windows
ports of OCaml (but it runs under the Cygwin port).

###  Launching the debugger

Consider the following obviously wrong program written in the file
`uncaught.ml`:

```ocaml
(* file uncaught.ml *)
let l = ref []
let find_address name = List.assoc name !l
let add_address name address = l := (name, address) :: ! l

let () =
  add_address "IRIA" "Rocquencourt";;
  print_string (find_address "INRIA"); print_newline ();;
```
```mdx-error
val l : (string * string) list ref = {contents = [("IRIA", "Rocquencourt")]}
val find_address : string -> string = <fun>
val add_address : string -> string -> unit = <fun>
Exception: Not_found.
```

At runtime, the program raises an uncaught exception `Not_found`.  Suppose we
want to find where and why this exception has been raised, we can proceed as
follows. First, we compile the program in debug mode:

```
ocamlc -g uncaught.ml
```

We launch the debugger:

```
ocamldebug a.out
```

Then the debugger answers with a banner and a prompt:

```
OCaml Debugger version 4.12.0

(ocd)
```

###  Finding the cause of a spurious exception

Type `r` (for *run*); you get

```
(ocd) r
Loading program... done.
Time : 12
Program end.
Uncaught exception: Not_found
(ocd)
```

Self explanatory, isn't it? So, you want to step backward to set the program
counter before the time the exception is raised; hence type in `b` as
*backstep*, and you get

```
(ocd) b
Time : 11 - pc : 15500 - module List
143     [] -> <|b|>raise Not_found
```

The debugger tells you that you are in module `List`, inside a pattern matching
on a list that already chose the `[]` case and is about to execute `raise
Not_found`, since the program is stopped just before this expression (as
witnessed by the `<|b|>` mark).

But, as you know, you want the debugger to tell you which procedure calls the
one from `List`, and also who calls the procedure that calls the one from
`List`; hence, you want a backtrace of the execution stack:

```
(ocd) bt
#0  Pc : 15500  List char 3562
#1  Pc : 19128  Uncaught char 221
```

So the last function called is from module `List` at character 3562, that is:

<!-- $MDX skip -->
```ocaml
let rec assoc x = function
  | [] -> raise Not_found
          ^
  | (a,b)::l -> if a = x then b else assoc x l
```

The function that calls it is in module `Uncaught`, file `uncaught.ml` char
221:


<!-- $MDX skip -->
```ocaml
print_string (find_address "INRIA"); print_newline ();;
                                  ^
```

To sum up: if you're developing a program you can compile it with the `-g`
option, to be ready to debug the program if necessary. Hence, to find a
spurious exception you just need to type `ocamldebug a.out`, then `r`, `b`, and
`bt` gives you the backtrace.

###  Getting help and info in the debugger

To get more info about the current status of the debugger you can ask it
directly at the toplevel prompt of the debugger; for instance:

```
(ocd) info breakpoints
No breakpoint.

(ocd) help break
  1      15396  in List, character 3539
break : Set breakpoint at specified line or function.
Syntax: break function-name
break @ [module] linenum
break @ [module] # characternum
```

###  Setting break points

Let's set up a breakpoint and rerun the entire program from the
beginning (`(g)oto 0` then `(r)un`):

```
(ocd) break @Uncaught 9
Breakpoint 3 at 19112 : file Uncaught, line 9 column 34

(ocd) g 0
Time : 0
Beginning of program.

(ocd) r
Time : 6 - pc : 19112 - module Uncaught
Breakpoint : 1
9 add "IRIA" "Rocquencourt"<|a|>;;
```

Then, we can step and find what happens when `find_address` is about to be
called

```
(ocd) s
Time : 7 - pc : 19012 - module Uncaught
5 let find_address name = <|b|>List.assoc name !l;;

(ocd) p name
name : string = "INRIA"

(ocd) p !l
$1 : (string * string) list = ["IRIA", "Rocquencourt"]
(ocd)
```

Now we can guess why `List.assoc` will fail to find "INRIA" in the list...

###  Using the debugger under Emacs

Under Emacs you call the debugger using `ESC-x` `ocamldebug a.out`. Then Emacs
will send you directly to the file and character reported by the debugger, and
you can step back and forth using `ESC-b` and `ESC-s`, you can set up break
points using `CTRL-X space`, and so on...
