---
id: map
title: Map
description: >
  Create a mapping using the standard library's Map module
category: "Data Structures"
---

## Module Map

The **Map** module lets you create _immutable_ key-value maps for your types. 

Immutable maps are never modified, and every operation returns a new map instead.

To use **Map**, we first have to use the **Map.Make** functor to create our custom map module. This functor takes a module parameter that defines the type of keys to be used in the map, and a function for comparing them. 

```ocaml=
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

After naming the newly-created module **StringMap**, OCaml's toplevel displays the module's signature. Since it contains a large number of functions, the output copied here is shortened for brevity (...).

This module doesn't define what the type of the _values_ in the map is. The type of values will be defined when we create our first map.

## Creating a Map

The **StringMap** module has an `empty` value that has a variable (`'a`) in its type: `empty : 'a t`.

This means that we can use `empty` to create new empty maps where the value is of any type.

```ocaml=
let int_map : int StringMap.t = StringMap.empty;;
let float_map : float StringMap.t = StringMap.empty;;
```

The type of the values can be defined in two ways:
* When you create your new map with an annotation
* By simply adding an element to the map:

```ocaml=
let int_map = StringMap.(empty |> add "one" 1);;
```

## Working With Maps

Let's look at a few functions for working with maps using the following maps:

```ocaml=
let lucky_numbers = StringMap.(
    empty
    |> add "leostera" 2112
    |> add "charstring88" 88
    |> add "divagnz" 13
);;

let unlucky_numbers = StringMap.(
    empty
    |> add "the number of the beast" 666
);;
```

### Adding Entries to a Map

To add an entry to a map, we can use the `add` function that takes in the key, the value, and the map. This function returns a new map with the new entry added:

```ocaml=
let new_lucky_numbers = StringMap.(
    lucky_numbers
    |> add "paguzar" 108
);;
```

If the key is already in the map, it will be replaced by the new entry.

Note that `lucky_numbers` remains unchanged.

### Removing Entries from a Map

To remove an entry from a map, we can use the `remove` function, which takes in a key and a map and returns a new map with the entry associated with that key removed.

```ocaml=
let new_lucky_numbers = StringMap.(
  new_lucky_numbers |> remove "paguzar"
);;
```

Removing an entry that isn't in the map has no effect.

Note that `lucky_numbers` remains unchanged.

### Checking if a Key is Contained in a Map

To check if a key is contained in a Map we can use the `mem` function:

```ocaml=
let is_paguzar_in_the_map: bool =
  StringMap.mem "paguzar" lucky_numbers
;;
```

### Finding Entries in a Map

To find entries in a map, we can use the `find_opt` function:

```ocaml=
let has_2112_value : int option = 
  StringMap.find_opt "leostera" lucky_numbers
;;
```

We can also use `find_first_opt` and `find_last_opt` if we want to use a predicate function:

```ocaml=
let first_under_10_chars : (string * int) option = 
  StringMap.find_first_opt
    (fun key -> String.length key < 10)
    lucky_numbers
;;
```

Note that `find_first_opt` and `find_last_opt` will return the entire entry, and not just the value.

### Merging Maps

To merge two maps, you can use the `union` function, which takes two maps, and a function that decides how to resolve conflicting keys and returns a new map. Note that the input maps are not modified.

```ocaml=
let all_numbers =
    StringMap.union
        conflict_fun
        lucky_numbers
        unlucky_numbers
;;
```

The behavior of `StringMap.union` can be tuned based on the conflict function we pass in.

For example, we can always pick the value from the first map, or choose to sum both values together (which would only work for values of type `int`), or we can even choose to ignore a value entirely if it is present in both maps.

Here are a few conflict functions we can try:

```ocaml=
let choose_first key v1 _v2 = Some (key, v1)
let choose_second key _v1 v2 = Some (key, v2)
let sum_values key v1 v2 = Some (key, v1 + v2)
let ignore _key _v1 _v2 = None
```

### Filtering a Map

To filter a map, we can use the `filter` function. `filter` takes a predicate to filter entries by and a map. It returns a new map with only the entries that passed the filter.

```ocaml=
let even_numbers =
  StringMap.filter
    (fun _key number -> number mod 2 = 0)
    lucky_numbers
;;
```

### Reducing a Map

### Maps With Custom Key Types

If you need to create a Map with a custom key type, you can call the **Map.Make** functor with a module of your own, provided that it implements 2 things:

1. It has a `t` type with no type parameters.
2. It has a `compare : t -> t -> int` function that can be used to compare two values of type `t`.

Let's define our custom map below, for non-negative numbers.

We'll start by defining a small module for non-negative numbers that uses an `int` under the hood but hides this.

```ocaml=
module Non_negative_int : sig 
  type t
  val of_int : int -> (t, [| `invalid_number]) result
  val compare : t -> t -> int
end = struct
  type t = int
  
  let of_int x = 
     if x > 0 then Ok x
     else Error `invalid_number
  
  let compare a b = a - b
end
;;
```

Note that our module has a `type t` and also a `compare` function. Now we can call the **Map.Make** function on it, to get a map for non-negative numbers:

```ocaml=
module NonNegIntMap = Map.Make(Non_negative_int);;
```

This map will only work with key values that are of type `Non_negative_int.t`.

# Conclusion

This was an overview of OCaml's **Map** module. Maps are reasonably efficient and can be we a good alternative to the imperative **Hashtbl** module.

For more information, refer to [Map](https://v2.ocaml.org/api/Map.html) in the Standard Library documentation.
