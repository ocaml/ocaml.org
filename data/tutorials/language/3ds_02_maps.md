---
id: maps
title: Maps
description: >
  Create a mapping using the standard library's Map module
category: "Data Structures"
---

## Introduction

In the most general sense, the [`Map`](/manual/api/Map.html) module lets you create _immutable_ key-value
[associative array](https://en.wikipedia.org/wiki/Associative_array) for your types. More concretely, 
OCaml's `Map` module is implemented using a binary search tree algorithm to support fast lookups (of O(Log n)). 

**Note**: The concept of a `Map` in this tutorial refers to a data structure that stores a
set of key-value pairs. It is sometimes called a dictionary or an association table. This
is a distinct concept from the maps we've explored in previous lessons, such as `List.map`,
`Array.map`, and `Option.map`, which are functions that operate over data rather than
being data themselves.

To use `Map`, we first have to use the [`Map.Make`](/manual/api/Map.Make.html) functor to
create our custom map module. Refer to the [Functors](/docs/functors) for more information
on functors. This functor has a module parameter that defines the keys' type to be used in
the maps, and a function for comparing them.

For a different implementation of an association table in OCaml's Standard Library, see the tutorial
on [Hash Tables](/docs/hash-tables).

```ocaml
# module StringMap = Map.Make(String);;

module StringMap :
  sig
    type key = string
    type 'a t = 'a Map.Make(String).t
    val empty : 'a t
    val add : key -> 'a -> 'a t -> 'a t
    val add_to_list : key -> 'a -> 'a list t -> 'a list t
    val update : key -> ('a option -> 'a option) -> 'a t -> 'a t
    val singleton : key -> 'a -> 'a t
    val remove : key -> 'a t -> 'a t
    (* ... *)
  end
```

After naming the newly-created module `StringMap`, OCaml's toplevel displays the
module's signature. Since it contains a large number of functions, the output
copied here is shortened for brevity `(...)`.

When we created the `StringMap` module, we fed the `Map.Make` functor the `String` module to
define the type of the map's keys, which we can observe in the `StringMap`'s signature
(`type key string`). However, we did not yet define the value's type. The value's type will
be defined when we create our first map.

## Creating a Map

The `StringMap` module has an `empty` value that has a type parameter `'a` in
its type: `empty : 'a t`.

This means that we can use `empty` to create new empty maps where the value is of any type.

The type of the values can be specified in two ways:
* When you create your new map with an annotation
* By adding an element to the map:

**Example 1**: By Annotation
```ocaml
# let int_map : int StringMap.t = StringMap.empty;;
val int_map : int StringMap.t = <abstr>
```

**Example 2**: By Adding an Element
```ocaml
# let int_map = StringMap.(empty |> add "one" 1);;
val int_map : int StringMap.t = <abstr>
```

## Working With Maps

Throughout the rest of this tutorial, we will use the following map:

```ocaml
# let lucky_numbers = StringMap.of_seq @@ List.to_seq [
    ("leostera", 2112);
    ("charstring88", 88);
    ("divagnz", 13);
  ];;
val lucky_numbers : int StringMap.t = <abstr>
```

## Finding Entries in a Map

To find entries in a map, use the `find_opt` or `find` functions:

```ocaml
# StringMap.find_opt "leostera" lucky_numbers;;
- : int option = Some 2112

# StringMap.find "leostera" lucky_numbers;;
- : int = 2112
```

When the searched key is present in the map:
- `find_opt` returns the associated value, wrapped in an option
- `find` returns the associated value

When the searched key is absent from the map:
- `find_opt` returns `None`
- `find` throws the `Not_found` exception

We can also use `find_first_opt` and `find_last_opt` if we want to use a
predicate function:

```ocaml
# let first_under_10_chars : (string * int) option =
  StringMap.find_first_opt
    (fun key -> String.length key < 10)
    lucky_numbers;;
val first_under_10_chars : (string * int) option = Some ("divagnz", 13)
```

The functions `find_first` and `find_last` behave similarly, except they
throw exceptions instead of returning options.

Note that `find_first_opt` and `find_last_opt` return the key-value pair,
not just the value.

## Adding Entries to a Map

To add an entry to a map, use the `add` function that takes a key, a value, and
the map to which it will be added. It returns a new map with that key-value pair added:

```ocaml
# let more_lucky_numbers = lucky_numbers |> StringMap.add "paguzar" 108;;
val more_lucky_numbers : int StringMap.t = <abstr>

# StringMap.find_opt "paguzar" lucky_numbers;;
- : int option = None

# StringMap.find_opt "paguzar" more_lucky_numbers;;
- : int option = Some 108
```

If the passed key is already associated with a value, the passed value replaces it.

Note that the initial map `lucky_numbers` remains unchanged.

## Removing Entries From a Map

To remove an entry from a map, use the `remove` function, which takes a key and
a map. It returns a new map with that key's entry removed.

```ocaml
# let fewer_lucky_numbers = lucky_numbers |> StringMap.remove "divagnz";;
val fewer_lucky_numbers : int StringMap.t = <abstr>

# StringMap.find_opt "divagnz" lucky_numbers;;
- : int option = Some 13

# StringMap.find_opt "divagnz" fewer_lucky_numbers;;
- : int option = None
```

Removing a key that isn't present in the map has no effect.

Note that the initial map `lucky_numbers` remains unchanged.

## Changing the Value Associated With a Key

To change a key's associated value, use the `update` function. It takes a
key, a map, and an update function. It returns a new map with the key's
associated value replaced by the new one.

```ocaml
# let updated_lucky_numbers =
    lucky_numbers
    |> StringMap.update "charstring88" (Option.map (fun _ -> 99));;
val updated_lucky_numbers : int StringMap.t = <abstr>

# StringMap.find_opt "charstring88" lucky_numbers;;
- : int option = Some 88

# StringMap.find_opt "charstring88" updated_lucky_numbers;;
- : int option = Some 99
```

You should experiment with different update functions; several behaviors are possible.

## Checking if a Key is Contained in a Map

To check if a key is a member of a map, use the `mem` function:

```ocaml
# StringMap.mem "paguzar" less_lucky_numbers;;
- : bool = false
```

## Merging Maps

To merge two maps, use the `union` function. This function takes two maps, a
function deciding how to handle entries with identical keys, and it returns a new map.

**Note**: As with all the other functions of `Map`, the input maps are not modified.

```ocaml
# StringMap.union;;
- : (string -> 'a -> 'a -> 'a option) ->
    'a StringMap.t -> 'a StringMap.t -> 'a StringMap.t
= <fun>
```

Here are examples of duplicate key resolution functions:

```ocaml
# let pick_fst key v1 _ = Some v1;;
val pick_fst : 'a -> 'b -> 'c -> 'b option = <fun>

# let pick_snd key _ v2 = Some v2;;
val pick_snd : 'a -> 'b -> 'c -> 'c option = <fun>

# let drop _ _ _ = None;;
val drop : 'a -> 'b -> 'c -> 'd option = <fun>
```

- `pick_fst` picks the result's value from the first map
- `pick_snd` picks the result's value from the second map
- `drop` drops both entries in the result map

```ocaml
# StringMap.(
    union pick_fst lucky_numbers updated_lucky_numbers
    |> find_opt "charstring88"
  );;
- : int option = Some 88

# StringMap.(
    union pick_snd lucky_numbers updated_lucky_numbers
    |> find_opt "charstring88"
  );;
- : int option = Some 99

# StringMap.(
    union drop lucky_numbers updated_lucky_numbers
    |> find_opt "charstring88"
  );;
- : int option = None
```

## Filtering a Map

To filter a map, use the `filter` function. It takes a predicate to filter
entries and a map. It returns a new map containing the entries satisfying the
predicate.

```ocaml
# let even_numbers =
  StringMap.filter
    (fun _ number -> number mod 2 = 0)
    lucky_numbers;;
val even_numbers : int StringMap.t = <abstr>
```

## Map a Map

Map modules have a `map` function:

```ocaml
StringMap.map;;
- : ('a -> 'b) -> 'a StringMap.t -> 'b StringMap.t = <fun>
```

The `lucky_numbers` map associates string keys with integer values:

```ocaml
# lucky_numbers;;
- : int StringMap.t = <abstr>
```

Using `StringMap.map`, we create a map associating keys with string values:

```ocaml
# let lucky_strings = StringMap.map string_of_int lucky_numbers;;
val lucky_strings : string StringMap.t = <abstr>
```

The keys are the same in both maps. For each key, a value in `lucky_numbers` is converted into a value in `lucky_strings` using `string_of_int`.

```ocaml
# lucky_numbers |> StringMap.find "leostera" |> string_of_int;;
- : string = "2112"

# lucky_strings |> StringMap.find "leostera";;
- : string = "2112"
```

## Maps With Custom Key Types

If you need to create a map with a custom key type, you can call the `Map.Make`
functor with a module of your own, provided that it implements two things:

1. A type `t` exposing the type of the map's key
2. A function `compare : t -> t -> int` that compares `t` values

Let's define our custom map below for non-negative numbers.

We'll start by defining a module for strings that compares them in a case-insensitive way.

```ocaml
# module Istring = struct
    type t = string
    let compare a b = String.(compare (lowercase_ascii a) (lowercase_ascii b))
  end;;
module Istring : sig type t val compare : t -> t -> int end
```

Note that our module has a `type t` and also a `compare` function. Now we can
call the `Map.Make` functor to get a map for non-negative numbers:

```ocaml
# module IstringMap = Map.Make(Istring);;
module IstringMap :
  sig
    type key = Istring.t
    type 'a t = 'a Map.Make(Istring).t
    val empty : 'a t
    val is_empty : 'a t -> bool
    val mem : key -> 'a t -> bool
    val add : key -> 'a -> 'a t -> 'a t
    val update : key -> ('a option -> 'a option) -> 'a t -> 'a t
    val singleton : key -> 'a -> 'a t
    val remove : key -> 'a t -> 'a t
    (* ... *)
end

# let lucky_int_numbers = IstringMap.of_seq @@ List.to_seq [
    ("leostera", 2112);
    ("charstring88", 88);
    ("divagnz", 13);
  ];;
val lucky_int_numbers : int IstringMap.t = <abstr>
```

## Conclusion

This was an overview of OCaml's `Map` module. Maps are reasonably efficient and
can be an alternative to the imperative `Hashtbl` module.

For more information, refer to [Map](/manual/api/Map.html) in the Standard Library
documentation.
