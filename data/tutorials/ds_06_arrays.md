---
id: arrays
title: Arrays
description: >
  The standard library's Array module
category: "data-structures"
date: 2023-07-18T15:14:00-00:00
---

# Arrays

## Introduction

In OCaml, arrays are a collection of elements of the same type that are stored in contiguous memory locations. They are mutable and have a fixed size, which set them apart from lists.

Despite these differences the functions readily available on arrays are similar to the ones available for lists, please refer to the [List tutorial](https://ocaml.org/docs/lists) for more details about these functions.

This tutorial aims to introduce the subject of arrays in OCaml and showcase the most useful functions and use cases.

Arrays are commonly used in OCaml for tasks such as:

- Storing and processing large amounts of data
- Implementing algorithms that require random access and modification of elements
- Working with matrices and other multi-dimensional data structures

## Creating Arrays

To create an array in OCaml, you can use the `[| ...; ... |]` syntax, which allows you to specify the values of each element directly. For example, to create an array with the values 1, 2, 3, 4, and 5, you will use `[| 1; 2; 3; 4; 5 |]`:

```ocaml
# let my_array = [| 1; 2; 3; 4; 5 |];;
val my_array : int array = [|1; 2; 3; 4; 5|]
```

Alternatively, you can create an array using the `Array.make` function, which takes two arguments: the length of the array and the initial value of each element. For example, to create an array of length 5 with all elements initialized to 0, you can write:

```ocaml
# let zeroes = Array.make 5 0;;
val zeroes : int array = [|0; 0; 0; 0; 0|]
```

It is also possible to use `Array.init` to generate an array by applying a function to each index of the array (starting at 0). For example, the array containing the 5 first even numbers can be obtained by multiplying the indices by 2, such as:

```ocaml
# let even_numbers = Array.init 5 (fun i -> i * 2);;
val even_numbers : int array = [|0; 2; 4; 6; 8|]
```

## Accessing Array Elements

You can access individual elements of an array using the `.(index)` syntax, with the index of the element you want to access. The index starts from 0 and goes up to the size of the array minus one.  For example, to access the third element of an array `my_array`, you woud write:

```ocaml
# let third_element = my_array.(2);;
val third_element : int = 3
```

## Modifying Array Elements

To modify an element in an array, we simply assign a new value to it using the indexing operator. For example, to change the value of the third element of the array `my_array` created above to 42, we can write:

```ocaml
# my_array.(2) <- 42;;
- : unit = ()
```

Note that this modification doesn’t return the modified array: the value returned by this operation is `unit`, `my_array` is modified in-place in the current scope.

## The Standard Library `Array` Module

OCaml provides several useful functions for working with arrays. Here are some of the most common ones:

### Lenght of an Array

The `Array.length` function returns the size of an array. For example, to get the size of the array `arr` created above:

```ocaml
# let size = Array.length my_array;;
val size : int = 5
```

### Iterate on an Array

The `Array.iter` function applies a given function to each element of an array. For example, to print all the elements of the array `zeroes` created above, we can apply the `print_int` (as this is an `int array`) function to each element:

```ocaml
# Array.iter (fun x -> print_int x; print_string " ") zeroes;;
1 2 42 4 5 - : unit = ()
```

### Map an Array

The `Array.map` function applies a given function to each element of an array and returns a new array with the results. For example, to create a new array that contains the square of each element of the array `my_array` created above, we can apply the following square function `fun x -> x * x` to each element of the array:

```ocaml
# Array.map (fun x -> x * x) my_array;;
- : int array = [|1; 4; 1764; 16; 25|]
```

### Folding an Array

To go over all the elements of the array we can use the `Array.fold_left` function. This function takes a binary function, an initial accumulator value, and an array as arguments. The binary function takes two arguments: the current value of the accumulator and the current element of the array, and returns a new accumulator value. Here is its type signature:

```ocaml
val fold_left : ('a -> 'b -> 'a) -> 'a -> 'b array -> 'a
```

`fold_left f init a` computes `f (... (f (f init a.(0)) a.(1)) ...) a.(n-1)`

Similarly, we can use the `Array.fold_right` function, that switches the order of its arguments:

```ocaml
val fold_right : ('b -> 'a -> 'a) -> 'b array -> 'a -> 'a
```

`fold_right f a init` computes `f a.(0) (f a.(1) ( ... (f a.(n-1) init) ...))`

These functions derive a single value from the whole array. For example they can be used to find the maximum element of an array:

```ocaml
# let max_element = Array.fold_left max my_array.(0) my_array;;
val max_element : int = 42
```

Where `max` is the maximum function defined on elements of type int.

### Sorting an Array

To sort an array, we can use the `Array.sort` function. This function takes an array as argument and sorts it in ascending order. For example, to sort the array `my_array` created above, we can use:

```ocaml
# Array.sort compare my_arr;;
- : unit = ()
# my_array;;
- : int array = [|1; 2; 4; 5; 42|]
```

## Copying Part of an Array into Another Array

The `Array.blit` function is available to efficiently copy a portion of an array into another array. Similarly to the `array.(x) <- y`  modification instruction, this function modifies the destination in-place and does not return the modified array, but returns `unit`. Let’s suppose you want to copy a part of `even_numbers` into `zeroes`:

```ocaml
# Array.blit even_numbers 3 zeroes 1 2;;
- : unit = ()
# zeroes;;
- : int array = [|0; 6; 8; 0; 0|]
```

This copies `2` elements of `even_numbers` starting at index `3` (this sub-array is `[| 6; 8 |]`) into `zeroes`, starting at index `1`. It is your responsibility to make sure that the two indices provided are valid in their respective arrays and that the number of elements to copy is within the bounds of each array.

## Conclusion

In this tutorial, we covered the basics of arrays in OCaml, including how to create and manipulate them, and some of the most useful functions and use cases. Please refer to the [standard library documentation](https://v2.ocaml.org/api/Array.html) to browse the complete list of functions of the `Array` module.
