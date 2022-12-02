---
id: data-structures-comparison
title: Comparison of Standard Data Structures
description: >
  A comparison of some core data-structures including lists, queues and arrays
category: "data-structures"
date: 2021-05-27T21:07:30-00:00
---

# Comparison of Standard Data Structures

This document provides a comparison of the different container types that are provided by the OCaml language or by the OCaml standard library. For each container type, we describe its key features, characteristics, and performance characteristics, and we provide some examples of how to use it in OCaml.

Note that the big-O cost given for some operations reflects the current implementation of the container types, but it is not guaranteed by the official documentation. If you want more details, you should read the documentation for each of the container modules, and you may also find it helpful to read the corresponding implementation.

## Lists: immutable singly-linked lists

Lists are a fundamental data structure in OCaml, and they are often used to represent sequences of values. They are immutable, which means that once a list is created, it cannot be modified. This makes them a good choice for scenarios where you need to preserve older versions of the list, or where you need to avoid side effects.

Lists are implemented as singly-linked lists, which means that each element in the list is linked to the next element in the list, but not to the previous element. This allows you to add elements to the front of the list efficiently, but it also means that you cannot access elements in the list by index, and you cannot modify elements in place.

Here are some of the key features and characteristics of lists:

- Adding an element to the front of the list is efficient, with a big-O cost of O(1). This is achieved using the :: cons operator, which creates a new list from an element and an existing list. The original list is not copied, but it remains unchanged.
- Finding the length of the list is efficient, with a big-O cost of O(n). This is achieved using the List.length function, which iterates over the elements in the list and counts them.
- Random access to elements in the list is inefficient, with a big-O cost of O(n). This means that you cannot access elements in the list by index, and you cannot modify elements in place.

Here is an example of how to use lists in OCaml:

```ocaml
let fruits = ["Apple"; "Banana"; "Orange"; "Strawberry"];; (* define a list of fruits *)
let numbers = [1; 2; 3; 4; 5];; (* define a list of numbers *)

let first_fruit = List.hd fruits;; (* get the first fruit in the list *)
let last_fruit = List.tl fruits;; (* get the last fruit in the list *)
let first_two_fruits = List.take 2 fruits;; (* get the first two fruits in the list *)
let last_two_fruits = List.drop 2 fruits;; (* get the last two fruits in the list *)
```

Lists are well-suited for scenarios where you need to represent sequences of values, such as IO operations or pattern-matching. They are not very efficient for scenarios where you need random access or indexed elements.

## Arrays: mutable vectors

Arrays are a fundamental data structure in OCaml, and they are often used to represent sets of elements of known size. They are mutable, which means that you can modify elements in place, and they have a fixed length, which means that you cannot add or remove elements from the array.

Arrays are implemented as vectors, which means that they provide efficient random access to elements by index. This allows you to quickly access and modify elements in the array, but it also means that you need to specify the size of the array when you create it.

Here are some of the key features and characteristics of arrays:

- Adding an element to an array is inefficient, with a big-O cost of O(n). This is because you need to create a new array, copy the elements from the old array to the new array, and add the new element. The original array is not modified, but it is not copied either.
- Modifying an element in an array is efficient, with a big-O cost of O(1). This is because you can directly access and modify the element by index.
- Random access to elements in an array is efficient, with a big-O cost of O(1). This means that you can quickly access and modify elements in the array by index.

Here is an example of how to use arrays in OCaml:

```ocaml
let fruits = ["Apple"; "Banana"; "Orange"; "Strawberry"];; (* define an array of fruits *)
let numbers = [1; 2; 3; 4; 5];; (* define an array of numbers *)

fruits.(0) <- "Pear";; (* modify the first element in the array *)
let first_fruit = fruits.(0);; (* get the first fruit in the array *)
let last_fruit = fruits.(Array.length fruits - 1);; (* get the last fruit in the array *)
```

Arrays are well-suited for scenarios where you need to represent sets of elements of known size, and where you need to access and modify elements by numeric index. Basic arrays have a fixed length, but you can use the `Array.append` and `Array.concat` functions to combine multiple arrays into a single larger array.

## Strings: immutable vectors

Strings are a common data structure in OCaml, and they are often used to represent text data. They are similar to arrays in that they are a sequence of elements, but they are specialized for storing characters (bytes) and they have a convenient syntax for creating and manipulating strings.

Strings are immutable, which means that you cannot modify the characters in a string. Instead, you need to create a new string when you want to add, remove, or modify characters. Strings have a fixed length, which means that you cannot add or remove characters from the string.

Here are some of the key features and characteristics of strings:

- Adding an element to a string is inefficient, with a big-O cost of O(n). This is because you need to create a new string, copy the characters from the old string to the new string, and add the new character. The original string is not modified, but it is not copied either.
- Random access to characters in a string is efficient, with a big-O cost of O(1). This means that you can quickly access and modify characters in the string by index.
- Strings have a convenient syntax for creating and manipulating strings. You can use the ^ operator to concatenate strings, and you can use string interpolation to include variables in a string.

Here is an example of how to use strings in OCaml:

```ocaml
let name = "Jane";; (* define a string *)
let hello = "Hello, " ^ name ^ "!";; (* concatenate strings *)
let favorite_color = "blue";; (* define a variable *)
let message = Printf.sprintf "Your favorite color is %s." favorite_color;; (* use string interpolation *)
```

Strings are well-suited for scenarios where you need to represent text data, and where you need to access and manipulate characters by index. Strings have a fixed length, but you can use the `^` operator to concatenate multiple strings into a single larger string. For scenarios where you need to efficiently append characters to a string, you can use the Buffer module (see below).

## Set and Map: immutable trees

Set and map are common data structures in OCaml that are used to store and manipulate sets of elements. They are similar to lists in that they are immutable, which means that you cannot modify the elements in a set or map. Instead, you need to create a new set or map when you want to add, remove, or modify elements. Sets and maps may share some subtrees, which can improve their performance and memory usage.

Here are some of the key features and characteristics of sets and maps:

- Adding an element to a set or map is efficient, with a big-O cost of O(log n). This means that you can quickly add elements to a set or map, even if the set or map contains many elements.
- The number of elements in a set or map can be returned in O(n) time. This means that you can quickly count the number of elements in a set or map, but it is not as efficient as some other data structures (e.g. arrays).
- Finding an element in a set or map is efficient, with a big-O cost of O(log n). This means that you can quickly search a set or map for a specific element.
- Finding the smallest or largest element in a set or map is efficient, with a big-O cost of O(log n). This means that you can quickly find the minimum or maximum element in a set or map.

Here is an example of how to use sets and maps in OCaml:

```ocaml
let numbers = [1; 2; 3];; (* define a list of numbers *)
let set = Set.of_list numbers;; (* convert the list to a set *)
let map = Map.of_list [(1, "one"); (2, "two"); (3, "three")];; (* convert the list to a map *)
let contains = Set.mem 2 set;; (* check if the set contains the number 2 *)
let value = Map.find 2 map;; (* lookup the value associated with the key 2 in the map *)
```

Sets and maps are well-suited for scenarios where you need to store and manipulate sets of elements, and where you need to efficiently add, remove, or search for elements. Sets and maps are immutable, which means that you cannot modify the elements in a set or map, but you can create new sets or maps based on existing sets or maps. Sets and maps may share subtrees, which can improve their performance and memory usage.

## Hashtbl: automatically growing hash tables

Hashtbl is a module in the OCaml standard library that provides a mutable data structure for storing (key, data) pairs. Hashtbls are efficient and easy to use, and they are a good solution for scenarios where you need to store and manipulate (key, data) pairs in one single place.

Here are some of the key features and characteristics of hash tables:

- Adding an element to a hash table is efficient, with a big-O cost of O(1) amortized. This means that you can quickly add elements to a hash table, even if the hash table contains many elements.
- Removing an element from a hash table is efficient, with a big-O cost of O(1) amortized. This means that you can quickly remove elements from a hash table, even if the hash table contains many elements.
- Finding an element in a hash table is efficient, with a big-O cost of O(1). This means that you can quickly search a hash table for a specific element.

Here is an example of how to use hash tables in OCaml:

```ocaml
let table = Hashtbl.create 16;; (* create a new hash table with an initial capacity of 16 *)
Hashtbl.add table "foo" 123;; (* add a (key, data) pair to the hash table *)
let data = Hashtbl.find table "foo";; (* lookup the data associated with the key "foo" in the hash table *)
```

Hashtbls are well-suited for scenarios where you need to store and manipulate (key, data) pairs, and where you need to efficiently add, remove, or search for elements. Hashtbls are mutable, which means that you can modify the elements in a hash table. Hashtbls automatically grow and shrink as needed to optimize their performance and memory usage.

## Buffer: extensible strings

The Buffer module in the OCaml standard library provides a mutable data structure for efficiently storing and manipulating sequences of bytes. Buffers are an efficient way to accumulate bytes in a single place, and they are well-suited for scenarios where you need to efficiently add bytes to a sequence and access individual bytes in the sequence.

Here are some of the key features and characteristics of buffers:

- Adding bytes to a buffer is efficient, with a big-O cost of O(1) amortized. This means that you can quickly add bytes to a buffer, even if the buffer contains many bytes.
- Random access to individual bytes in a buffer is efficient, with a big-O cost of O(1). This means that you can quickly access individual bytes in a buffer, even if the buffer contains many bytes.
- Buffers are mutable, which means that you can modify the bytes in a buffer.

Here is an example of how to use buffers in OCaml:

```ocaml
let buffer = Buffer.create 16;; (* create a new buffer with an initial capacity of 16 bytes *)
Buffer.add_string buffer "hello world";; (* add a string to the buffer *)
let length = Buffer.length buffer;; (* get the number of bytes in the buffer *)
let byte = Buffer.nth buffer 5;; (* get the 5th byte in the buffer *)
```

Buffers are well-suited for scenarios where you need to efficiently store and manipulate sequences of bytes. Buffers automatically grow and shrink as needed to optimize their performance and memory usage.

## Queue

Queues are mutable data structures in OCaml that are well-suited for scenarios where you need to efficiently store and manipulate a sequence of items in a first-in-first-out (FIFO) order. Queues are ideal for scenarios where you need to add items to one end of a sequence and remove items from the other end, such as in a queue or line.

Here are some of the key features and characteristics of queues in OCaml:

- Adding an element to a queue is efficient, with a big-O cost of O(1). This means that you can quickly add items to a queue, even if the queue contains many items.
- Removing an element from a queue is efficient, with a big-O cost of O(1). This means that you can quickly remove items from a queue, even if the queue contains many items.
- Queues are mutable, which means that you can modify the items in a queue.

Here is an example of how to use queues in OCaml:

```ocaml
let queue = Queue.create ();; (* create a new queue *)
Queue.push 1 queue;; (* add an element to the queue *)
Queue.push 2 queue;; (* add another element to the queue *)
let length = Queue.length queue;; (* get the number of elements in the queue *)
let item = Queue.pop queue;; (* remove and return the first element from the queue *)
```

Queues are well-suited for scenarios where you need to efficiently store and manipulate a sequence of items in a FIFO order. Queues can be efficiently modified and accessed, even if they contain many items.

## Stack

Stacks are mutable data structures in OCaml that are well-suited for scenarios where you need to efficiently store and manipulate a sequence of items in a last-in-first-out (LIFO) order. Stacks are ideal for scenarios where you need to add items to one end of a sequence and remove items from the same end, such as in a stack of books or plates.

Here are some of the key features and characteristics of stacks in OCaml:

- Adding an element to a stack is efficient, with a big-O cost of O(1). This means that you can quickly add items to a stack, even if the stack contains many items.
- Removing an element from a stack is efficient, with a big-O cost of O(1). This means that you can quickly remove items from a stack, even if the stack contains many items.
- Stacks are mutable, which means that you can modify the items in a stack.
- Stacks are similar to lists, except that they are mutable. This means that adding an element to a stack doesn't create a new stack but simply adds the element to the stack.

Here is an example of how to use stacks in OCaml:

```ocaml
let stack = Stack.create ();; (* create a new stack *)
Stack.push 1 stack;; (* add an element to the stack *)
Stack.push 2 stack;; (* add another element to the stack *)
let length = Stack.length stack;; (* get the number of elements in the stack *)
let item = Stack.pop stack;; (* remove and return the top element from the stack *)
```

Stacks are well-suited for scenarios where you need to efficiently store and manipulate a sequence of items in a LIFO order. Stacks can be efficiently modified and accessed, even if they contain many items.
