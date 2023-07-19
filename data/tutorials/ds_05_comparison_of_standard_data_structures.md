---
id: data-structures-comparison
title: Comparison of Standard Data Structures
description: >
  A comparison of some core data-structures including lists, queues and arrays
category: "data-structures"
date: 2021-05-27T21:07:30-00:00
---

# Comparison of Standard Data Structures

This is a rough comparison of the different container types that are
provided by the OCaml language or by the OCaml standard library. In each
case, n is the number of valid elements in the container.

Note that the big-O cost given for some operations reflects the current
implementation but is not guaranteed by the official documentation.
Hopefully it will not become worse. Anyway, if you want more details,
you should read the documentation about each of the modules. Often, it
is also instructive to read the corresponding implementation.

## `List`: Immutable Singly-Linked Lists
Adding an element always creates a new list l from an element x and list
tl. tl remains unchanged, but it is not copied either.

* adding an element to the front: O(1), cons operator `::`
* length: O(n), function `List.length`
* random access: O(n)

Well-suited for: IO, pattern-matching

Not very efficient for: random access, indexed elements

## `Array`: Mutable Vectors
Arrays are mutable data structures with a fixed length and random access.

* adding an element (by creating a new array): O(n)
* modifying an element: O(1)
* random access: O(1)

Well-suited for sets of elements of known size, access by numeric index,
in-place modification. Basic arrays have a fixed length.

## `String`: Immutable Vectors
Strings are similar to arrays but are immutable. Strings are
specialized for storing chars (bytes) and have some convenient syntax.
Strings have a fixed length. For extensible strings, the standard Buffer
module can be used (see below).

* adding an element (by creating a new string): O(n)
* random access: O(1)

## `Set` and `Map`: Immutable Trees
Like lists, these are immutable and they may share some subtrees. They
are a good solution for keeping older versions of sets of items.

* adding an element: O(log n)
* returning the number of elements: O(n)
* finding an element: O(log n)
* finding the biggest or smallest: O(log n)

## `Hashtbl`: Automatically Growing Hash Tables
Ocaml hash tables are mutable data structures, which are a good solution
for storing (key, data) pairs in one single place.

* adding an element: O(1) amortized
* removing an element: O(1) amortized
* finding an element: O(1)

## `Buffer`: Extensible Strings
Buffers provide an efficient way to accumulate a sequence of bytes in a
single place. They are mutable.

* adding bytes at the end: O(1) amortized
* random access: O(1)

## Queue
OCaml queues are mutable first-in-first-out (FIFO) data structures.

* adding an element on the "in" side: O(1)
* taking an element on the "out" side: O(1)

## Stack
OCaml stacks are mutable last-in-first-out (LIFO) data structures. They
are just like lists, except that they are mutable, i.e. adding an
element doesn't create a new stack but simply adds it to the stack.

* adding an element at the top: O(1)
* taking an element at the top: O(1)
