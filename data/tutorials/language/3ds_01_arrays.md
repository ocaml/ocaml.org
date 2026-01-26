---
id: arrays
title: Arrays
description: >
  The standard library's Array module
category: "Data Structures"
language: English
---

## Introduction

In OCaml, arrays are collections of elements of one type. Unlike lists, arrays can be mutated by replacing their elements with other values of the same type, but cannot be resized. Arrays also allow efficient access to elements at any position.

Despite these differences, many of the functions readily available on arrays are similar to the ones available for lists. Please refer to the [List tutorial](https://ocaml.org/docs/lists) and [documentation](/manual/api/List.html) for more details about these functions.

This tutorial aims to introduce the subject of arrays in OCaml and showcase the most useful functions and use cases.

Arrays are commonly used in OCaml for tasks such as:

- Storing and processing large amounts of data
- Implementing algorithms that require random access and modification of elements
- Working with matrices and other multi-dimensional data structures

## Creating Arrays

To create an array in OCaml, you can use the `[| ...; ... |]` syntax, which allows you to specify the values of each element directly. For example, to create an array with the values 1, 2, 3, 4, and 5, you will write `[| 1; 2; 3; 4; 5 |]`:

```ocaml
# [| 1; 2; 3; 4; 5 |];;
- : int array = [|1; 2; 3; 4; 5|]
```

Alternatively, you can create an array using the `Array.make` function, which takes two arguments: the length of the array and the initial value of each element. For example, to create an array of length 5 with all elements initialised to 0, you can write:

```ocaml
# let zeroes = Array.make 5 0;;
val zeroes : int array = [|0; 0; 0; 0; 0|]
```

`Array.init` generates an array of a given length by applying a function to each index of the array, starting at 0. The following line of code creates an array containing the first 5 even numbers using a function which doubles its argument:

```ocaml
# let even_numbers = Array.init 5 (fun i -> i * 2);;
val even_numbers : int array = [|0; 2; 4; 6; 8|]
```

## Accessing Array Elements

You can access individual elements of an array using the `.(index)` syntax, with the index of the element you want to access. The index of the first element is 0, and the index of the last element is one less than the size of the array.  For example, to access the third element of an array `even_numbers`, you would write:

```ocaml
# even_numbers.(2);;
- : int = 4
```

## Modifying Array Elements

To modify an element in an array, we simply assign a new value to it using the indexing operator. For example, to change the value of the third element of the array `even_numbers` created above to 42, we have to write:

```ocaml
# even_numbers.(2) <- 42;;
- : unit = ()
```

Note that this operation returns `unit`, not the modified array. `even_numbers` is modified in place as a side effect.

## The Standard Library [`Array`](/manual/api/Array.html) Module

OCaml provides several useful functions for working with arrays. Here are some of the most common ones:

### Length of an Array

The `Array.length` function returns the size of an array:

```ocaml
# Array.length even_numbers;;
- : int = 5
```

### Iterate on an Array

`Array.iter` applies a function to each element of an array, one at a time. The given function must return `unit`, operating by side effect. To print all the elements of the array `zeroes` created above, we can apply `print_int` to each element:

```ocaml
# Array.iter (fun x -> print_int x; print_string " ") zeroes;;
0 0 0 0 0 - : unit = ()
```

Iterating on arrays can also be made using `for` loops. Here is the same example using a loop:

```ocaml
# for i = 0 to Array.length zeroes - 1 do
    print_int zeroes.(i);
    print_string " "
  done;;
0 0 0 0 0 - : unit = ()
```

### Map an Array

The `Array.map` function creates a new array by applying a given function to each element of an array. For example, we can get an array containing the square of each number in the `even_numbers` array:

```ocaml
# Array.map (fun x -> x * x) even_numbers;;
- : int array = [|0; 4; 1764; 36; 64|]
```

### Folding an Array

To combine all the elements of an array into a single result, we can use the `Array.fold_left` and `Array.fold_right` functions. These functions take a binary function, an initial accumulator value, and an array as arguments. The binary function takes two arguments: the accumulator's current value and the current element of the array, then returns a new accumulator value. Both functions traverse the array
 but in opposite directions. This is essentially the same as `List.fold_left` and `List.fold_right`.

Here is the signature of `Array.fold_left`:

```ocaml
# Array.fold_left;;
val fold_left : ('a -> 'b -> 'a) -> 'a -> 'b array -> 'a = <fun>
```

`fold_left f init a` computes `f (... (f(f init a.(0)) a.(1)) ...) a.(n-1)`

Similarly, we can use the `Array.fold_right` function, which switches the order of its parameters:

```ocaml
# Array.fold_right;;
val fold_right : ('b -> 'a -> 'a) -> 'b array -> 'a -> 'a = <fun>
```

`fold_right f a init` computes `f a.(0) (f a.(1) ( ... (f a.(n-1) init) ...))`

These functions derive a single value from the whole array. For example, they can be used to find the maximum element of an array:

```ocaml
# Array.fold_left Int.max min_int even_numbers;;
- : int = 42
```

### Sorting an Array

To sort an array, we can use the `Array.sort` function. This function takes as arguments:
- a comparison function
- an array

It sorts the provided array in place and in ascending order, according to the provided comparison function. Sorting performed by `Array.sort` modifies the content of the provided array, which is why it returns `unit`. For example, to sort the array `even_numbers` created above, we can use:

```ocaml
# Array.sort compare even_numbers;;
- : unit = ()
# even_numbers;;
- : int array = [|0; 2; 6; 8; 42|]
```

## Copying Part of an Array into Another Array

The `Array.blit` function efficiently copies a contiguous part of an array into an array. Similar to the `array.(x) <- y` operation, this function modifies the destination in place and returns `unit`, not the modified array. Suppose you wanted to copy a part of `ones` into `zeroes`:

```ocaml
# let ones = Array.make 5 1;;
val ones : int array = [|1; 1; 1; 1; 1|]
# Array.blit ones 0 zeroes 1 2;;
- : unit = ()
# zeroes;;
- : int array = [|0; 1; 1; 0; 0|]
```

This copies two elements of `ones`, starting at index `0` (this array slice is `[| 1; 1 |]`) into `zeroes`, starting at index `1`. It is your responsibility to make sure that the two indices provided are valid in their respective arrays and that the number of elements to copy is within the bounds of each array.

We can also use this function to copy part of an array onto itself:

```ocaml
# Array.blit zeroes 1 zeroes 3 2;;
- : unit = ()
# zeroes;;
- : int array = [|0; 1; 1; 1; 1|]
```

This copies two elements of `zeroes`, starting at index `1` into the last part of `zeroes`, starting at index `3`.

## Conclusion

In this tutorial, we covered the basics of arrays in OCaml, including how to create and manipulate them, as well as some of the most useful functions and use cases. Please refer to the [standard library documentation](/manual/api/Array.html) to browse the complete list of functions of the [`Array`](/manual/api/Array.html) module.
