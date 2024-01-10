---
id: sets
title: Sets
description: >
  The standard library's Set module
category: "Data Structures"
---

# Set

## Introduction

`Set` is a functor, which means that it is a module that is parameterised
by another module. More concretely, this means you cannot directly create
a set. Instead, you must first specify what type of elements your set will
contain.

The `Set` functor provides a function `Make` that accepts a module as a
parameter. Then it returns a new module representing a set of elements of the given type.

For example, if you want to work with sets of
strings, you can invoke `Set.Make(String)` that will return a new module,
which you can assign a name, for example, `StringSet`:
```ocaml
# module StringSet = Set.Make(String);;
module StringSet :
  sig
    type elt = string
    type t = Set.Make(String).t
    val empty : t
    val add : elt -> t -> t
    val singleton : elt -> t
    val remove : elt -> t -> t
    val union : t -> t -> t
    val inter : t -> t -> t
...
  end
```

After assigning your newly-created module to the name
`StringSet`, OCaml's toplevel displays the type signature of the module. In this case, it contains
a large number of convenience functions for working with sets (for example `is_empty`
checks if the set is empty, `add` adds an element to the set, `remove`
removes an element, and so on).

This module also defines two types: `type elt = String.t`, representing
the type of the elements, and `type t = Set.Make(String).t`, representing the type of
the set itself. These types are used by many of 
the functions defined in this module.

For example, the `add` function has the type `elt -> t -> t`, which means
that it expects an element (a string) and a set of strings. Then it will return
a set of strings.

## Creating a Set

1. We can create an empty set using `StringSet.empty`:
```ocaml
# StringSet.empty ;;
- : StringSet.t = <abstr>

# StringSet.empty |> StringSet.to_list;;
- : string list = []
```

For `StringSet.empty`, you can see that the OCaml toplevel displays `<abstr>` instead of a displaying the actual value. This is a limitation of the toplevel. However, you can see that converting the string set to a list using `StringSet.to_list` results in the empty list.

2. A set with a single element is created using `StringSet.singleton`:
```ocaml
# StringSet.singleton "hello";;
- : StringSet.t = <abstr>

# StringSet.singleton "hello" |> StringSet.to_list;;
- : string list = ["hello"]
```

3. Converting a list into a set using `StringSet.of_list`:
```ocaml
# StringSet.of_list ["hello"; "hi"];;
- : StringSet.t = <abstr>
```

There's another relevant function `StringSet.of_seq: string Seq.t -> StringSet.t` which creates a list from a [sequence](/doc/sequences).

## Working With Sets

Let's look at a few basic functions for working with sets.

### Adding an Element to a Set

```ocaml
# let my_set = ["hello"; "hi"] |> StringSet.of_list;;
- : StringSet.t = <abstr>

# my_set |> StringSet.add "good morning" |> StringSet.to_list;;
- : string list = ["good morning"; "hello"; "hi"]
```

The function `StringSet.add` with type `string -> StringSet.t -> StringSet.t` takes a string and a string set. It returns a new string set. Sets created with the `Set` functor in OCaml are immutable, so every time you add or remove an element from a set, a new set is created - the old value is unchanged.

### Removing an Element from a Set

```ocaml
# let my_set = ["hello"; "hi"] |> StringSet.of_list;;
- : StringSet.t = <abstr>

# my_set |> StringSet.remove "hello" |> StringSet.to_list;;
- : string list = ["hi"]
```

The function `StringSet.remove` with type `string -> StringSet.t -> StringSet.t` takes a string and a string set. It returns a new string set without the given string.

### Union of Two Sets

```ocaml
# let first_set = ["hello"; "hi"] |> StringSet.of_list;;
- : StringSet.t = <abstr>

# let second_set = ["good morning"; "hi"] |> StringSet.of_list;;
- : StringSet.t = <abstr>

# StringSet.union first_set second_set |> StringSet.to_list;;
- : string list = ["good morning"; "hello"; "hi"]
```

With the function `StringSet.union`, we can compute the union of two sets.

### Intersection of Two Sets

```ocaml
# let first_set = ["hello"; "hi"] |> StringSet.of_list;;
- : StringSet.t = <abstr>

# let second_set = ["good morning"; "hi"] |> StringSet.of_list;;
- : StringSet.t = <abstr>

# StringSet.inter first_set second_set |> StringSet.to_list;;
- : string list = ["hi"]
```

With the function `StringSet.inter`, we can compute the intersection of two sets.

### Subtracting a Set from Another

```ocaml
# let first_set = ["hello"; "hi"] |> StringSet.of_list;;
- : StringSet.t = <abstr>

# let second_set = ["good morning"; "hi"] |> StringSet.of_list;;
- : StringSet.t = <abstr>

# StringSet.diff first_set second_set |> StringSet.to_list;;
- : string list = ["hello"]
```

With the function `StringSet.diff`, we can remove the elements from one set from another.

### Filtering a Set

```ocaml
# ["good morning"; "hello"; "hi"]
  |> StringSet.of_list
  |> StringSet.filter (fun str -> String.length str <= 5)
  |> StringSet.to_list;;
- : string list = ["hello"; "hi"]
```

The function `StringSet.filter` of type `(string -> bool) -> StringSet.t -> StringSet.t` allows us to apply a predicate to all elements of a set to create a new set.

### Checking if an Element is Contained in a Set

```ocaml
# ["good morning"; "hello"; "hi"]
  |> StringSet.of_list
  |> StringSet.mem "hello";;
- : bool = true
```

To check if an element is contained in a given set, we can use the `StringSet.mem` function.

## Sets With Custom Comparators

The `Set.Make` functor expects a module with two fields: a type `t`
that represents the element type and a function `compare`,
whose signature is `t -> t -> int`. The 
`String` module matches that structure, so we could
directly pass `String` as an argument to `Set.Make`. Incidentally, many
other modules also have that structure, including `Int` and `Float`,
so they too can be directly passed into `Set.Make` in order to construct a
set of integers or a set of floating point numbers.

The `StringSet` module we created uses the built-in `compare` function provided by the `String` module.

Let's say we want to create a set of strings that performs a case-insensitive
comparison instead of the case-sensitive comparison provided by `String.compare`.

We can accomplish this by passing an ad-hoc module to the `Set.Make` function:

```ocaml
# module CISS = Set.Make(struct
  type t = string
  let compare a b = compare (String.lowercase_ascii a) (String.lowercase_ascii b)
end);;
```

We name the resulting module `CISS` (short for "Case Insensitive String Set").

You can see that this module has the intended behavior:

```ocaml
# CISS.singleton "hello" |> CISS.add "HELLO" |> CISS.to_list;;
- : string list = ["hello"]
```
The value `"HELLO"` is not added to the set because it is considered equal to the value `"hello"` that is already contained in the set.

Note that this technique can also be used to allow arbitrary types
to be used as the element type for set, as long as you can define a
meaningful compare operation:

```ocaml
# type color = Red | Green | Blue;;
type color = Red | Green | Blue

# module SC = Set.Make(struct
  type t = color
  let compare a b =
    match (a, b) with
    | (Red, Red) -> 0
    | (Red, Green) -> 1
    | (Red, Blue) -> 1
    | (Green, Red) -> -1
    | (Green, Green) -> 0
    | (Green, Blue) -> 1
    | (Blue, Red) -> -1
    | (Blue, Green) -> -1
    | (Blue, Blue) -> 0
end);;
...
```

## Conclusion

We gave an overview of the `Set` module in OCaml by creating a `StringSet` module using the `Set.Make` functor. Further, we looked at how to create sets based on a custom compare function. For more information, refer to [Set in the Standard Library documentation](https://ocaml.org/api/Set.Make.html)

