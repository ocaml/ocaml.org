---
id: hash-tables
title: Hash Tables
description: >
  Discover efficient and mutable lookup tables with OCaml's Hashtbl module
category: "data-structures"
date: 2021-05-27T21:07:30-00:00
---

# Hash Tables

Hash tables are an efficient and mutable data structure for storing and looking up values based on keys. In OCaml, hash tables are provided by the `Hashtbl` module, which offers a number of functions for creating, modifying, and querying hash tables.

Hash tables are particularly useful in OCaml because they offer fast lookups and updates, making them ideal for applications where data needs to be accessed and modified quickly, such as in databases and other data-intensive applications. They are also well-suited for scenarios where the number of elements in a data structure may change frequently, since hash tables can be dynamically resized to accommodate more elements.

In this documentation, we will provide an overview of the `Hashtbl` module and its various functions, as well as best practices for using hash tables in OCaml and tips for avoiding common pitfalls. We will also cover advanced topics such as implementing custom hash tables and using polymorphic hash tables. By the end of this documentation, you should have a good understanding of how to use hash tables in OCaml and how to use them effectively in your own projects.

## Creating and using hash tables in OCaml

This section covers the basics of creating and using hash tables in OCaml. It includes the following topics:

- The `Hashtbl` module
- Creating a new hash table with `Hashtbl.create`
- Adding, retrieving, and removing elements from a hash table

### The `Hashtbl` module

The `Hashtbl` module in OCaml provides functions for creating and using hash tables. To use the `Hashtbl` module in your code, you will need to open it with the open keyword. Here is an example of opening the `Hashtbl` module:

```ocaml
open Hashtbl
```

Once the `Hashtbl` module is open, you can use its functions to create and manipulate hash tables in your code. Some of the most commonly used functions in the `Hashtbl` module are:

- `create`: This function creates a new, empty hash table with a specified initial size.
- `add`: This function adds a key-value pair to a hash table.
- `find`: This function retrieves the value associated with a given key in a hash table.
- `find_all`: This function retrieves all values associated with a given key in a hash table.
- `remove`: This function removes a key-value pair from a hash table.
- `replace`: This function replaces the value associated with a given key in a hash table.

We will cover these and other functions in the `Hashtbl` module in more detail later in this documentation.

### Creating a new hash table with `Hashtbl.create`

To create a new hash table in OCaml, we can use the Hashtbl.create function from the Hashtbl module. This function takes a single argument, which is the initial size of the hash table. This initial size is just a best guess as to the amount of data that will be stored in the hash table, and the hash table can be automatically resized if necessary. Here is an example of creating a new hash table with Hashtbl.create:

```ocaml
let my_hashtbl = Hashtbl.create 123456
```

The type of `my_hashtbl` is `('_weak1, '_weak2) Hashtbl.t`, where `'_weak1` and `'_weak2` are the key and value types, respectively. These types are not yet determined, so we can use the hash table with any key and value types that we choose. Once we start adding elements to the hash table, the key and value types will be fixed and cannot be changed.

It is important to choose the right initial size for a hash table, as a too-small initial size can result in poor performance due to frequent resizing, while a too-large initial size can waste memory. A good rule of thumb is to choose an initial size that is approximately the same as the expected number of elements in the hash table. However, this is not a strict requirement, and the hash table can be automatically resized as needed.

Once a hash table has been created with `Hashtbl.create`, it can be used to store and retrieve elements using the other functions in the `Hashtbl` module. We will cover these functions in more detail in the next section.

### Adding, retrieving, and removing elements from a hash table

Once a hash table has been created with `Hashtbl.create`, we can add, retrieve, and remove elements from it using the other functions in the `Hashtbl` module. In this section, we will cover some of the most commonly used functions for adding, retrieving, and removing elements from a hash table.

To add elements to a hash table, we can use the `Hashtbl.add` function. This function takes the hash table, the key, and the value as arguments, and adds the key-value pair to the hash table. Here is an example of using `Hashtbl.add` to add elements to a hash table:

```ocaml
Hashtbl.add my_hash "h" "hello";
Hashtbl.add my_hash "h" "hi";
Hashtbl.add my_hash "h" "hug";
Hashtbl.add my_hash "h" "hard";
Hashtbl.add my_hash "w" "wimp";
Hashtbl.add my_hash "w" "world";
Hashtbl.add my_hash "w" "wine"
```

Note that hash tables are modified in-place, so calling `Hashtbl.add` does not create a new hash table, but instead modifies the existing one. This means that we can use the same variable (my_hash in this case) to add elements to the hash table multiple times.

To retrieve an element from the hash table, we can use the `Hashtbl.find` function. This function takes the hash table and the key as arguments, and returns the value associated with that key. If the key is not found in the hash table, an exception is raised. Here is an example of using `Hashtbl.find` to retrieve an element from a hash table:

```ocaml
Hashtbl.find my_hash "h"
```

This code would return the value `"hard"`, which is the last value that was added to the hash table with the key `"h"`.

To retrieve all elements with a given key from a hash table, we can use the `Hashtbl.find_all` function. This function takes the hash table and the key as arguments, and returns a list of all values associated with that key. If the key is not found in the hash table, an empty list is returned. Here is an example of using `Hashtbl.find_all` to retrieve all elements with a given key from a hash table:

```ocaml
Hashtbl.find_all my_hash "h"
```

This code would return the list `["hard"; "hug"; "hi"; "hello"]`, which contains all of the values that were added to the hash table with the key `"h"`.

To remove a key-value pair from a hash table, we can use the `Hashtbl.remove` function. This function takes the hash table and the key as arguments, and removes the key-value pair associated with that key from the hash table. Here is an example of using `Hashtbl.remove` to remove a key-value pair from a hash table:

```ocaml
Hashtbl.remove my_hash "h"
```

This code would remove the key-value pair with the key `"h"` from the hash table.

## More operations to work with Hash tables


### Mapping a hash table with `Hashtbl.map`

The `Hashtbl.map` function allows you to create a new hash table by applying a transformation function to the keys and values in an existing hash table. This can be useful for modifying the data in a hash table in a consistent way.

Here is an example of how to use the `Hashtbl.map` function in OCaml:

```ocaml
(* Create a new hash table. *)
let my_hash = Hashtbl.create 123456

(* Add some keys and values to the hash table. *)
Hashtbl.add my_hash "hello" 1
Hashtbl.add my_hash "world" 2

(* Define a transformation function that adds 1 to the value of each key. *)
let transform key value = (key, value + 1)

(* Create a new hash table by mapping the transformation function over the keys and values in my_hash. *)
let mapped_hash = Hashtbl.map transform my_hash

(* Retrieve the keys and values from the mapped hash table. *)
let keys = Hashtbl.fold (fun key value acc -> key :: acc) mapped_hash []
let values = Hashtbl.fold (fun key value acc -> value :: acc) mapped_hash []

(* Print the keys and values from the mapped hash table. *)
print_string (String.concat ", " keys)
print_string (String.concat ", " (List.map string_of_int values))
```

In this example, we first create a new hash table with the `Hashtbl.create` function and add some keys and values to it. Then, we define a transformation function that adds 1 to the value of each key.

Next, we use the `Hashtbl.map` function to create a new hash table by applying the transformation function to the keys and values in the original hash table. The `Hashtbl.map` function returns a new hash table with the transformed keys and values.

Finally, we use the `Hashtbl.fold` function to retrieve the keys and values from the mapped hash table and print them to the screen. The `Hashtbl.fold` function allows us to iterate over the elements in a hash table and collect the results in a list.

By using the `Hashtbl.map` function, we can create a new hash table with the keys and values transformed by a certain function. This can be useful for modifying the data in a hash table in a consistent way.

In the example above, we used the `Hashtbl.map` function to add 1 to the value of each key in the original hash table. However, the transformation function can be any arbitrary function that takes a key and value as arguments and returns a new key and value pair.

For example, we could use the `Hashtbl.map` function to transform the keys and values in a hash table in the following ways:

- Convert the keys and values to uppercase or lowercase letters.
- Truncate the keys and values to a certain length.
- Replace the keys and values with new values based on a lookup table.
- Apply a mathematical or statistical operation to the keys and values.

By using the `Hashtbl.map` function, you can modify the data in a hash table in a consistent and efficient way. This can be useful for preprocessing data before using it in your application or for transforming the results of a hash table operation.

### Clearing a hash table with `Hashtbl.reset`

The `Hashtbl.reset` function allows you to clear all the keys and values from a hash table. This can be useful for reusing a hash table for different data or purposes.

Here is an example of how to use the `Hashtbl.reset` function:

```ocaml
(* Create a new hash table. *)
let my_hash = Hashtbl.create 123456

(* Add some keys and values to the hash table. *)
Hashtbl.add my_hash "hello" 1
Hashtbl.add my_hash "world" 2

(* Clear the keys and values from the hash table. *)
Hashtbl.reset my_hash

(* Add new keys and values to the hash table. *)
Hashtbl.add my_hash "hello" 3
Hashtbl.add my_hash "world" 4

(* my_hash now containes the elements ("hello",3) and ("world",4) *)
```

The `Hashtbl.reset` function is simple to use and can be useful for cleaning up a hash table and preparing it for reuse.

### Copying a hash table with `Hashtbl.copy`

The Hashtbl.copy function allows you to create a new hash table with the same keys and values as an existing hash table. This can be useful for creating a new hash table with the same data as an existing hash table, without modifying the original hash table.

Here is an example of how to use it:

```ocaml
(* Create a new hash table. *)
let my_hash = Hashtbl.create 123456

(* Add some keys and values to the hash table. *)
Hashtbl.add my_hash "hello" 1
Hashtbl.add my_hash "world" 2

(* Copy the hash table. *)
let my_copy = Hashtbl.copy my_hash

(* my_copy now contains the elements ("hello",1) and ("world",2) *)
```

### Iterating over a hash table with `Hashtbl.iter`

The `Hashtbl.iter` function allows you to iterate over all the keys and values in a hash table. This can be useful for performing some operation on each key and value in the hash table.

Here is an example of how to use the `Hashtbl.iter` function in OCaml:

```ocaml
(* Create a new hash table. *)
let my_hash = Hashtbl.create 123456;;

(* Add some keys and values to the hash table. *)
Hashtbl.add my_hash "hello" 1;;
Hashtbl.add my_hash "world" 2;;

(* Iterate over the keys and values in the hash table. *)
Hashtbl.iter (fun key value -> print_string (key ^ ": " ^ string_of_int value)) my_hash;;
```

In this example, we use the `Hashtbl.iter` function to iterate over each key and value in the hash table. For each key and value, we print a string to the screen with the key and value.

The `Hashtbl.iter` function takes two arguments: a function to apply to each key and value in the hash table, and the hash table to iterate over. The function passed to the `Hashtbl.iter` function must take two arguments: a key and a value. The `Hashtbl.iter` function returns unit.

The `Hashtbl.iter` function is a convenient way to perform some operation on each key and value in a hash table.

### Filtering a hash table with `Hashtbl.filter`

The Hashtbl.filter function allows you to create a new hash table with only the keys and values that satisfy a certain condition. This can be useful for creating a new hash table with a subset of the keys and values from an existing hash table.

Here is an example of how to use the `Hashtbl.filter` function:

```ocaml
(* Create a new hash table. *)
let my_hash = Hashtbl.create 123456;;

(* Add some keys and values to the hash table. *)
Hashtbl.add my_hash "hello" 1;;
Hashtbl.add my_hash "world" 2;;
Hashtbl.add my_hash "foo" 3;;
Hashtbl.add my_hash "bar" 4;;

(* Filter the hash table to only include values greater than 2. *)
let my_filtered_hash = Hashtbl.filter (fun key value -> value > 2) my_hash;;

(* my_filtered_hash will only contain the elements ("foo",3) and ("bar",4) *)
```

In this example, we use the `Hashtbl.filter` function to create a new hash table that only includes the keys and values from the original hash table where the value is greater than 2.

The `Hashtbl.filter` function takes two arguments: a function that specifies the condition to filter the hash table by, and the hash table to filter. The function passed to the `Hashtbl.filter` function must take two arguments: a key and a value. The `Hashtbl.filter` function returns a new hash table with only the keys and values that satisfy the condition.

The `Hashtbl.filter` function is a convenient way to create a new hash table with a subset of the keys and values from an existing hash table.

## Advanced Usages

### Choosing the right hash function for your data

A hash function is a function that maps data of an arbitrary size to data of a fixed size. The resulting data is called the hash value, or simply the hash. Hash functions are often used in computer science to index and retrieve data from data structures such as hash tables, databases, and sets.

Hash functions are widely used in computer science due to their ability to map data of arbitrary size to a fixed-size value, which can be used as an index or key in various data structures. They are also useful for generating unique identifiers for data, as it is unlikely that two different pieces of data will have the same hash value.

When working with hash tables, it is important to choose a good hash function for the keys in your data. A good hash function will distribute the keys evenly across the hash table, allowing for efficient storage and retrieval of elements. On the other hand, a bad hash function can cause keys to be clustered together, resulting in poor performance and potential collisions.

In OCaml, the `Hashtbl` module provides several built-in hash functions for different data types. For example, the `Hashtbl.hash` function can be used to hash integers, floats, and strings, while the `Hashtbl.hash_param` function can be used to customize the behavior of the hash function for different data types.

When choosing a hash function for your data, it is important to consider the characteristics of the keys and the distribution of the data. For example, if the keys are uniformly distributed, a simple hash function such as `Hashtbl.hash` may be sufficient. On the other hand, if the keys are not uniformly distributed, a more sophisticated hash function such as `Hashtbl.hash_param` may be necessary to achieve good performance.

In general, it is a good idea to experiment with different hash functions and evaluate their performance on your data to determine the best one for your use case. By carefully choosing the right hash function, you can improve the performance and efficiency of your hash table implementation.

Here is an example of how to specify a custom hash function using the `Hashtbl.hash_param` function:

```ocaml
(* Define a module for hashing integers. *)
module Int_hash =
  struct
    (* Define a type alias for integers. *)
    type t = int

    (* Define the "equal" function for integers. This function
       takes two integers as arguments and returns true if they
       are equal, and false otherwise. *)
    let equal i j = i = j

    (* Define the "hash" function for integers. This function
       takes an integer as an argument and returns its hash
       value. In this case, we use the bitwise "land" operator
       to compute the hash value. *)
    let hash i = i land max_int
  end

(* Use the Hashtbl.Make functor to create a new module for
   hash tables with integer keys, using the Int_hash module
   we defined above. This module will provide functions for
   creating and manipulating hash tables with integer keys. *)
module Int_hashtbl = Hashtbl.Make(Int_hash)

(* Create a new hash table with an initial size of 17. *)
let h = Int_hashtbl.create 17

(* Add a key-value pair to the hash table. *)
Int_hashtbl.add h 12 "hello"
```

In this example, we define a custom `Int_hash` module with a `t` type alias for `int` and two functions: `equal` and `hash`. The equal function takes two `int` values as arguments and returns `true` if they are equal, and `false` otherwise. The `hash` function takes an `int` value as an argument and returns its hash value.

### Implementing custom equality tests

It is often necessary to define custom equality tests for the keys in your data. The equality test is used to determine whether two keys are equal, and is used by the hash table to determine whether a key already exists in the table or not.

In OCaml, the `Hashtbl` module provides several built-in equality tests for different data types. For example, the `Hashtbl.equal` function can be used to compare integers, floats, and strings, while the `Hashtbl.seeded_hash` function can be used to customize the behavior of the equality test for different data types.

When implementing a custom equality test, it is important to consider the characteristics of the keys and the requirements of your application. For example, if the keys are simple data types such as integers or strings, a simple equality test such as `Hashtbl.equal` may be sufficient. On the other hand, if the keys are more complex data structures, a more sophisticated equality test such as `Hashtbl.seeded_hash` may be necessary to correctly compare the keys.

In general, it is a good idea to carefully design the equality test for your keys to ensure that it correctly determines whether two keys are equal or not. By implementing a custom equality test, you can ensure that your hash table behaves as expected and performs well with your data.

Here is an example of how to implement a custom equality test for a hash table in OCaml:

```ocaml
module String_hash =
  struct
    type t = string

    (* Define a custom equality test for strings. *)
    let equal s1 s2 =
      let l1 = String.length s1 in
      let l2 = String.length s2 in
      if l1 <> l2 then false
      else
        let rec loop i =
          if i >= l1 then true
          else if s1.[i] <> s2.[i] then false
          else loop (i + 1)
        in
        loop 0

    (* Use the default hash function for strings. *)
    let hash = Hashtbl.hash
  end

(* Use the Hashtbl.Make functor to create a new module for
   hash tables with string keys, using the String_hash module
   we defined above. This module will provide functions for
   creating and manipulating hash tables with string keys. *)
module String_hashtbl = Hashtbl.Make(String_hash)

(* Create a new hash table with an initial size of 123456. *)
let h = String_hashtbl.create 123456

(* Add a key-value pair to the hash table. *)
String_hashtbl.add h "hello" "world"
```

In this example, we define a `String_hash` module with a `t` type alias for string and two functions: `equal` and `hash`. The equal function a custom equality test we define, which takes two strings as arguments and returns `true` if they are equal, and `false` otherwise. The hash function uses the default `hash` function provided by the `Hashtbl` module for strings.

## Common pitfalls and best practices

### Avoiding hash collisions

Hash collisions occur when two or more keys in a hash table have the same hash value. This can lead to incorrect behavior of the hash table, such as keys being overwritten or not being able to be retrieved correctly.

To avoid hash collisions, it is important to choose a good hash function for your keys. A good hash function should be able to map the keys in your data to unique hash values as uniformly as possible. This will help to distribute the keys evenly across the hash table and reduce the likelihood of collisions.

In OCaml, the `Hashtbl` module provides several built-in hash functions for different data types. For example, the `Hashtbl.hash` function can be used for integers, floats, and strings, while the `Hashtbl.seeded_hash` function can be used to customize the behavior of the hash function for different data types.

When implementing a custom hash function, it is important to consider the characteristics of the keys and the requirements of your application. For example, if the keys are simple data types such as integers or strings, a simple hash function such as `Hashtbl.hash` may be sufficient. On the other hand, if the keys are more complex data structures, a more sophisticated hash function such as `Hashtbl.seeded_hash` may be necessary to produce unique hash values for the keys.

In general, it is a good idea to carefully design the hash function for your keys to ensure that it produces unique hash values and avoids collisions. By implementing a custom hash function, you can ensure that your hash table behaves as expected and performs well with your data.

### Choosing the right initial size for a hash table

The initial size of a hash table determines the amount of memory allocated for the table when it is first created. Choosing the right initial size for a hash table is important because it affects the performance and efficiency of the table.

A hash table with a larger initial size will have more memory allocated for it, which means that it can store more keys and values without having to resize the table. This can improve the performance of the table, because it will have to resize less often and therefore have fewer costly operations.

On the other hand, a hash table with a smaller initial size will have less memory allocated for it, which means that it will have to resize more often to accommodate new keys and values. This can decrease the performance of the table, because it will have to perform more resizing operations and therefore have more costly operations.

In general, it is a good idea to choose the initial size of a hash table based on the expected number of keys and values that will be stored in the table. A larger initial size will be more efficient for tables with a large number of keys and values, while a smaller initial size will be more efficient for tables with a small number of keys and values.

### Handling missing keys gracefully

It is important to handle the case when a key is not found in the table. This can happen when the key has not been added to the table or when it has been removed from the table.

`Hashtbl` module provides several functions for handling missing keys gracefully. For example, the `Hashtbl.mem` function can be used to check if a key exists, and the `Hashtbl.find_opt` function can be used to retrieve the value of a key if it exists in the table and return `None` if the key doesn't exist.

Here's an example of how to use the `Hashtbl.mem` function to test for the existence of the key before using it:

```ocaml
(* Create a new hash table. *)
let my_hashtbl = Hashtbl.create 123456

(* Check if the key "hello" exists in the hash table. *)
if Hashtbl.mem my_hashtbl "hello" then
  (* Retrieve the value of the key "hello" from the hash table. *)
  let value = Hashtbl.find my_hashtbl "hello" in
  (* Use the value of the key "hello" in the application. *)
  print_string value
else
  (* Handle the case where the key "hello" does not exist in the hash table. *)
  print_string "Key not found in hash table."
```

In this example, we use the `Hashtbl.mem` function to check if the key `"hello`" exists in the hash table. If the key exists, we use the `Hashtbl.find` function to retrieve the value of the key and use it in the application. If the key does not exist, we handle the missing key gracefully by printing a message to the user.

The same example can be written as follow with the `Hashtbl.find_opt` function:

```ocaml
(* Create a new hash table. *)
let my_hashtbl = Hashtbl.create 123456

let () =
 match Hashtbl.find_opt my_hashtbl "hello" with
 | None -> 
  (* Handle the case where the key "hello" does not exist in the hash table. *)
  print_string "Key not found in hash table."
| Some value ->
  (* Use the value of the key "hello" in the application. *)
  print_string value
```

## Conclusion

### Recap of key concepts

In this tutorial, we have learned about hash tables in OCaml and how to create and use them effectively in our applications. Here are the key concepts that we have covered:

- A hash table is an efficient, mutable data structure that allows you to store and retrieve data based on a key.
- The `Hashtbl` module in OCaml provides functions for creating, modifying, and querying hash tables.
- To create a new hash table, use the `Hashtbl.create` function. This function takes an initial size as an argument and returns a new hash table.
- To add a key and value to a hash table, use the `Hashtbl.add` function. This function takes a key, value, and hash table as arguments and returns unit.
- To retrieve the value associated with a key in a hash table, use the `Hashtbl.find` function. This function takes a key and hash table as arguments and returns the associated value.
- To remove a key and its associated value from a hash table, use the `Hashtbl.remove` function. This function takes a key and hash table as arguments and returns unit.
- The `Hashtbl.map` function allows you to create a new hash table by applying a function to each key and value in an existing hash table.
- The `Hashtbl.reset` function allows you to clear all keys and values from a hash table.
- The `Hashtbl.copy` function allows you to create a new hash table with the same keys and values as an existing hash table.
- The `Hashtbl.iter` function allows you to iterate over all the keys and values in a hash table.
- The `Hashtbl.filter` function allows you to create a new hash table with only the keys and values that satisfy a certain condition.

### Additionnal Resources

Now that you have a basic understanding of how to use hash tables in OCaml, you can continue to explore more advanced features of the Hashtbl module. To learn more about using hash tables in OCaml, check out the following resources:

- The `Hashtbl` module documentation in the OCaml manual: https://v2.ocaml.org/api/Hashtbl.html
