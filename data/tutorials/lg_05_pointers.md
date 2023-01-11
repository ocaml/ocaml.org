---
id : pointers
title: Pointers in OCaml
description: >
  Use OCaml's explicit pointers with references
category: "language"
date: 2021-05-27T21:07:30-00:00
---

# Pointers

## Status of Pointers in OCaml
Pointers exist in OCaml, and in fact they spread all over the place.
They are used either implicitly (in the most cases), or explicitly (in
the rare occasions where implicit pointers are not more handy). The vast
majority of pointers usages that are found in usual programming
languages simply disappear in OCaml, or more exactly, those pointers are
totally automatically handled by the compiler. Thus, the OCaml programmer
can safely ignore the existence of pointers, focusing on the semantics of their
program.

For instance, lists or trees are defined without explicit pointers using
a concrete datatype definition. The underlying implementation uses
pointers, but this is hidden from the programmer since pointer
handling is done by the compiler.

In the rare occasions where explicit pointers are needed (the most
common case is when translating into OCaml an algorithm described in a
classic imperative language), OCaml provides references that are
full-fledged pointers, even first class citizen pointers (references can
be passed as argument, embedded into arbitrary data structures, and
returned as function results).

### Explicit Pointers Are OCaml Values of Type `ref`
You can program directly with explicit references if you want to, but
this is normally a waste of time and effort.

Let's examine the simple example of linked lists (integer lists to be
simple). This data type is defined in C (or in Pascal) using explicit
pointers, for instance:

```C
/* Cells and lists type in C */
struct cell {
  int hd;
  struct cell *tl;
};

typedef struct cell cell, *list;
```
```Pascal
{Cells and lists type in Pascal}
type
 list = ^cell;
 cell = record
  hd: integer;
  tl: cell;
 end;
```
We can translate this in OCaml, using a sum type definition, without
pointers:

```ocaml
# type list = Nil | Cons of int * list;;
type list = Nil | Cons of int * list
```

Cell lists are thus represented as pairs, and the recursive structure of
lists is evident, with the two alternatives, empty list (the
`Nil`constructor) and non empty list (the `Cons` constructor).

Automatic management of pointers and automatic memory allocation shine
when allocating list values: one just writes `Cons (x, l)` to add `x` in
front of the list `l`. In C, you need to write this function, to
allocate a new cell and then fill its fields. For instance:

```C
/* The empty list */
#define nil NULL

/* The constructor of lists */
list cons (element x, list l)
{
  list result;
  result = (list) malloc (sizeof (cell));
  result -> hd = x;
  result -> tl = l;
  return (result);
}
```
Similarly, in Pascal:

```Pascal
{Creating a list cell}
function cons (x: integer; l: list): list;
  var p: list;
  begin
    new(p);
    p^.hd := x;
    p^.tl := l;
    cons := p
  end;
```
We thus see that fields of list cells in the C program have to be
mutable, otherwise initialization is impossible. By contrast in OCaml,
allocation and initialization are merged into a single basic operation:
constructor application. This way, immutable data structures are
definable (those data types are often referred to as “pure” or
“functional” data structures). If physical modifications are necessary
for other reasons than mere initialization, OCaml provides records with
mutable fields. For instance, a list type defining lists whose elements
can be in place modified could be written:

```ocaml
# type list = Nil | Cons of cell
  and cell = { mutable hd : int; tl : list };;
type list = Nil | Cons of cell
and cell = { mutable hd : int; tl : list; }
```
If the structure of the list itself must also be modified (cells must be
physically removed from the list), the `tl` field would also be declared
as mutable:

```ocaml
# type list = Nil | Cons of cell
  and cell = { mutable hd : int; mutable tl : list };;
type list = Nil | Cons of cell
and cell = { mutable hd : int; mutable tl : list; }
```

Physical assignments are still useless to allocate mutable data: you
write `Cons {hd = 1; tl = l}` to add `1` to the list `l`. Physical
assignments that remain in OCaml programs should be just those
assignments that are mandatory to implement the algorithm at hand.

Very often, pointers are used to implement physical modification of data
structures. In OCaml programs this means using vectors or mutable fields
in records.

**In conclusion:** You can use explicit pointers in OCaml, exactly as in C, but
this is not natural, since you get back the usual drawbacks and difficulties of
explicit pointers manipulation of classical algorithmic languages. See a more
complete example below.

## Defining Pointers in OCaml
The general pointer type can be defined using the definition of a
pointer: a pointer is either null, or a pointer to an assignable memory
location:

```ocaml
# type 'a pointer = Null | Pointer of 'a ref;;
type 'a pointer = Null | Pointer of 'a ref
```
Explicit dereferencing (or reading the pointer's designated value) and
pointer assignment (or writing to the pointer's designated memory
location) are easily defined. We define dereferencing as a prefix
operator named `!^`, and assignment as the infix `^:=`.

```ocaml
# let ( !^ ) = function
    | Null -> invalid_arg "Attempt to dereference the null pointer"
    | Pointer r -> !r;;
val ( !^ ) : 'a pointer -> 'a = <fun>

# let ( ^:= ) p v =
    match p with
     | Null -> invalid_arg "Attempt to assign the null pointer"
     | Pointer r -> r := v;;
val ( ^:= ) : 'a pointer -> 'a -> unit = <fun>
```

Now we define the allocation of a new pointer initialized to point to a
given value:

```ocaml
# let new_pointer x = Pointer (ref x);;
val new_pointer : 'a -> 'a pointer = <fun>
```
For instance, let's define and then assign a pointer to an integer:

```ocaml
# let p = new_pointer 0;;
val p : int pointer = Pointer {contents = 0}
# p ^:= 1;;
- : unit = ()
# !^p;;
- : int = 1
```

## Integer Lists
Now we can define lists using explicit pointers as in usual imperative
languages:

```ocaml
# type ilist = cell pointer
  and cell = { mutable hd : int; mutable tl : ilist };;
type ilist = cell pointer
and cell = { mutable hd : int; mutable tl : ilist; }
```
We then define allocation of a new cell, the list constructor and its
associated destructors.

```ocaml
# let new_cell () = {hd = 0; tl = Null};;
val new_cell : unit -> cell = <fun>
# let cons x l =
    let c = new_cell () in
    c.hd <- x;
    c.tl <- l;
    (new_pointer c : ilist);;
val cons : int -> ilist -> ilist = <fun>
# let hd (l : ilist) = !^l.hd;;
val hd : ilist -> int = <fun>
# let tl (l : ilist) = !^l.tl;;
val tl : ilist -> ilist = <fun>
```

We can now write all kind of classical algorithms, based on pointers
manipulation, with their associated loops, their unwanted sharing
problems and their null pointer errors. For instance, list
concatenation, as often described in literature, physically modifies
its first list argument, hooking the second list to the end of the
first:

```ocaml
# let append (l1 : ilist) (l2 : ilist) =
  let temp = ref l1 in
  while tl !temp <> Null do
    temp := tl !temp
  done;
  !^ !temp.tl <- l2;;
val append : ilist -> ilist -> unit = <fun>

# let l1 = cons 1 (cons 2 Null);;
val l1 : ilist =
  Pointer
   {contents = {hd = 1; tl = Pointer {contents = {hd = 2; tl = Null}}}}

# let l2 = cons 3 Null;;
val l2 : ilist = Pointer {contents = {hd = 3; tl = Null}}

# append l1 l2;;
- : unit = ()
```

The lists `l1` and `l2` are effectively catenated:

```ocaml
# l1;;
- : ilist =
Pointer
 {contents =
   {hd = 1;
    tl =
     Pointer
      {contents = {hd = 2; tl = Pointer {contents = {hd = 3; tl = Null}}}}}}
```

Just a nasty side effect of physical list concatenation: `l1` now
contains the concatenation of the two lists `l1` and `l2`, thus the list
`l1` no longer exists: in some sense `append` *consumes* its first
argument. In other words, the value of a list data now depends on its
history, that is on the sequence of function calls that use the value.
This strange behaviour leads to a lot of difficulties when explicitly
manipulating pointers. Try for instance, the seemingly harmless:

```ocaml
# append l1 l1;;
- : unit = ()
```

Then evaluate `l1`:

```ocaml
# l1;;
- : ilist =
Pointer
 {contents =
   {hd = 1;
    tl =
     Pointer
      {contents = {hd = 2; tl = Pointer {contents = {hd = 3; tl = <cycle>}}}}}}
```

## Polymorphic Lists
We can define polymorphic lists using pointers; here is a simple implementation
of those polymorphic mutable lists:

```ocaml
# type 'a lists = 'a cell pointer
  and 'a cell = { mutable hd : 'a pointer; mutable tl : 'a lists };;
type 'a lists = 'a cell pointer
and 'a cell = { mutable hd : 'a pointer; mutable tl : 'a lists; }
# let new_cell () = {hd = Null; tl = Null};;
val new_cell : unit -> 'a cell = <fun>
# let cons x l =
    let c = new_cell () in
    c.hd <- new_pointer x;
    c.tl <- l;
    (new_pointer c : 'a lists);;
val cons : 'a -> 'a lists -> 'a lists = <fun>
# let hd (l : 'a lists) = !^l.hd;;
val hd : 'a lists -> 'a pointer = <fun>
# let tl (l : 'a lists) = !^l.tl;;
val tl : 'a lists -> 'a lists = <fun>
# let append (l1 : 'a lists) (l2 : 'a lists) =
  let temp = ref l1 in
  while tl !temp <> Null do
    temp := tl !temp
  done;
  !^ !temp.tl <- l2;;
val append : 'a lists -> 'a lists -> unit = <fun>
```

## Null Pointers
So you've got a survey on your website which asks your readers for their
names and ages. Only problem is that for some reason a few of your
readers don't want to give you their age - they stubbornly refuse to
fill that field in. What's a poor database administrator to do?

Assume that the age is represented by an `int`, there are two possible
ways to solve this problem. The most common one (and the most *wrong*
one) is to assume some sort of "special" value for the age which means
that the age information wasn't collected. So if, say, age = -1 then the
data wasn't collected, otherwise the data was collected (even if it's
not valid!). This method kind of works until you start, for example,
calculating the mean age of visitors to your website. Since you forgot
to take into account your special value, you conclude that the mean age
of visitors is 7½ years old, and you employ web designers to remove all
the long words and use primary colours everywhere.

The other, correct method is to store the age in a field which has type
"int or null". Here's a SQL table for storing ages:

```SQL
create table users
(
  userid serial,
  name text not null,
  age int             -- may be null
);
```

If the age data isn't collected, then it goes into the database as a
special SQL `NULL` value. SQL ignores this automatically when you ask it
to compute averages and so on.

Programming languages also support nulls, although they may be easier to
use in some than in others. In Java, any reference to
an object can be null, so it might make sense in Java to store the
age as an `Integer` and allow references to the age to be null. In C
pointers can, of course, be null, but if you wanted a simple integer to
be null, you'd have to first box it up into an object allocated by
`malloc` on the heap.

OCaml has an elegant solution to the problem of nulls, using a simple
polymorphic variant type defined (in `Stdlib`) as:

```ocaml
type 'a option = None | Some of 'a
```

A "null pointer" is written `None`. The type of age in our example above
(an `int` which can be null) is `int option` (remember: backwards like
`int list` and `int binary_tree`).

```ocaml
# Some 3;;
- : int option = Some 3
```

What about a list of optional ints?

```ocaml
# [None; Some 3; Some 6; None];;
- : int option list/2 = [None; Some 3; Some 6; None]
```
And what about an optional list of ints?

```ocaml
# Some [1; 2; 3];;
- : int list/2 option = Some [1; 2; 3]
```
