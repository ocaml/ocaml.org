---
id: data-structures-comparison 
title: Comparison of Standard Containers
description: >
  Rough comparison of the different container types in OCaml
category: "Resources"
---

# Comparison of Standard Containers
This is a rough comparison of the different container types 
provided by the OCaml standard library. In each
case, _n_ is the number of valid elements in the container.

Note that the big-O cost given for some operations reflects the current
implementation but is not guaranteed by the official documentation.
Hopefully it will not become worse. Anyway, if you want more details,
you should read the [documentation](/api/index.html) about each of the modules, or the OCaml [source code](https://github.com/ocaml/ocaml/tree/trunk/stdlib). Often, it
is also instructive to read the corresponding implementation.

## Lists: immutable singly-linked lists
Adding an element always creates a new list _l_ from an element _x_ and list
_tl_. _tl_ remains unchanged, but it is not copied either.

* "adding" an element: _O(1)_, [cons](https://en.wikipedia.org/wiki/Cons) operator `::`
* length: _O(n)_, function `List.length`
* accessing cell `i`: _O(i)_
* finding an element: _O(n)_

Well-suited for: IO, pattern-matching

Not very efficient for: random access, indexed elements

## Arrays: mutable vectors
Arrays are mutable data structures with a fixed length and random access.

* "adding" an element (by creating a new array): _O(n)_
* length: _O(1)_, function `Array.length`
* accessing cell `i`: _O(1)_
* finding an element: _O(n)_

Well-suited for sets of elements of known size, access by numeric index,
in-place modification. Basic arrays have a fixed length.

## Strings: immutable vectors
Strings are very similar to arrays but are immutable. Strings are
specialized for storing chars (bytes) and have some convenient syntax.
Strings have a fixed length. For extensible strings, the standard Buffer
module can be used (see below).

* "adding" an element (by creating a new string): _O(n)_
* length: _O(1)_
* accessing character `i`: _O(1)_
* finding an element: _O(n)_

## Set and Map: immutable trees
Like lists, these are immutable and they may share some subtrees. They
are a good solution for keeping older versions of sets of items.

* "adding" an element: _O(log n)_
* returning the number of elements: _O(n)_
* finding an element: _O(log n)_

Sets and maps are very useful in compilation and meta-programming, but
in other situations hash tables are often more appropriate (see below).

## Hashtbl: automatically growing hash tables
Ocaml hash tables are mutable data structures, which are a good solution
for storing (key, data) pairs in one single place.

* adding an element: _O(1)_ if the initial size of the table is larger
 than the number of elements it contains; _O(log n)_ on average if _n_
 elements have been added in a table which is initially much smaller
 than _n_.
* returning the number of elements: _O(1)_
* finding an element: _O(1)_

## Buffer: extensible strings
Buffers provide an efficient way to accumulate a sequence of bytes in a
single place. They are mutable.

* adding a char: _O(1)_ if the buffer is big enough, or _O(log n)_ on
 average if the initial size of the buffer was much smaller than the
 number of bytes _n_.
* adding a string of _k_ chars: _O(k * "adding a char")_
* length: _O(1)_
* accessing cell `i`: _O(1)_

## Queue
OCaml queues are mutable first-in-first-out (FIFO) data structures.

* adding an element: _O(1)_
* taking an element: _O(1)_
* length: _O(1)_

## Stack
OCaml stacks are mutable last-in-first-out (LIFO) data structures. They
are just like lists, except that they are mutable, i.e. adding an
element doesn't create a new stack but simply adds it to the stack.

* adding an element: _O(1)_
* taking an element: _O(1)_
* length: _O(1)_
