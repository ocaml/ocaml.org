---
id: sets
title: Sets
description: >
  The standard library's Set module
category: "Data Structures"
---

## Introduction

`Set` provides the functor `Set.Make`. You must start by passing `Set.Make` a module. It specifies the element type for your set. In return, you get another module with those elements' set operations.

**Disclaimer:** The examples in this tutorial require OCaml 5.1. If you're running a previous version of OCaml , you can either use `elements` instead of `to_list`, which is a new function in OCaml 5.1, or upgrade OCaml by running `opam update`, then `opam upgrade ocaml`. Check your current version with `ocaml --version`. 

If you need to work with string sets, you must invoke `Set.Make(String)`. That returns a new module.

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

After naming the newly-created module `StringSet`, OCaml's toplevel displays the module's signature. Since it contains a large number of functions, the output copied here is shortened for brevity (`...`).

This module also defines two types:
- `type elt = string` for the elements, and
- `type t = Set.Make(String).t` for the sets.

## Creating a Set

1. We can create an empty set using `StringSet.empty`:

```ocaml
# StringSet.empty ;;
- : StringSet.t = <abstr>

# StringSet.empty |> StringSet.to_list;;
- : string list = []
```

For `StringSet.empty`, you can see that the OCaml toplevel displays the placeholder `<abstr>` instead of the actual value. However, converting the string set to a list using `StringSet.to_list` results in an empty list.

(Remember, for OCaml versions before 5.1, it will be `StringSet.empty |> StringSet.elements;;`)

2. A set with a single element is created using `StringSet.singleton`:

```ocaml
# StringSet.singleton "hello";;
- : StringSet.t = <abstr>

# StringSet.(singleton "hello" |> to_list);;
- : string list = ["hello"]
```

3. Converting a list into a set using `StringSet.of_list`:

```ocaml
# StringSet.of_list ["hello"; "hi"];;
- : StringSet.t = <abstr>

# StringSet.(of_list ["hello"; "hi"] |> to_list);;
- : string list = ["hello"; "hi"]
```

There's another relevant function `StringSet.of_seq: string Seq.t -> StringSet.t` that creates a set from a [sequence](/doc/sequences).

## Working With Sets

Let's look at a few functions for working with sets using these two sets.

```ocaml
# let first_set = ["hello"; "hi"] |> StringSet.of_list;;
- : val first_set : StringSet.t = <abstr>

# let second_set = ["good morning"; "hi"] |> StringSet.of_list;;
- : val second_set : StringSet.t = <abstr>
```

### Adding an Element to a Set

```ocaml
# StringSet.(first_set |> add "good morning" |> to_list);;
- : string list = ["good morning"; "hello"; "hi"]
```

The function `StringSet.add` with type `string -> StringSet.t -> StringSet.t` takes both a string and a string set. It returns a new string set. Sets created with the `Set.Make` functor in OCaml are immutable, so every time you add or remove an element from a set, a new set is created. The old value is unchanged.

### Removing an Element from a Set

```ocaml
# StringSet.(first_set |> remove "hello" |> to_list);;
- : string list = ["hi"]
```

The function `StringSet.remove` with type `string -> StringSet.t -> StringSet.t` takes both a string and a string set. It returns a new string set without the given string.

### Union of Two Sets

```ocaml
# StringSet.(union first_set second_set |> to_list);;
- : string list = ["good morning"; "hello"; "hi"]
```

With the function `StringSet.union`, we can compute the union of two sets.

### Intersection of Two Sets

```ocaml
# StringSet.(inter first_set second_set |> to_list);;
- : string list = ["hi"]
```

With the function `StringSet.inter`, we can compute the intersection of two sets.

### Subtracting a Set from Another

```ocaml
# StringSet.(diff first_set second_set |> to_list);;
- : string list = ["hello"]
```

With the function `StringSet.diff`, we can remove the elements of the second set from the first set.

### Filtering a Set

```ocaml
# ["good morning"; "hello"; "hi"]
  |> StringSet.of_list
  |> StringSet.filter (fun str -> String.length str <= 5)
  |> StringSet.to_list;;
- : string list = ["hello"; "hi"]
```

The function `StringSet.filter` of type `(string -> bool) -> StringSet.t -> StringSet.t` creates a new set by keeping the elements that satisfy a predicate from an existing set.

### Checking if an Element is Contained in a Set

```ocaml
# ["good morning"; "hello"; "hi"]
  |> StringSet.of_list
  |> StringSet.mem "hello";;
- : bool = true
```

To check if an element is contained in a set, use the `StringSet.mem` function.

## Sets With Custom Comparators

The `Set.Make` functor expects a module with two definitions: a type `t`
that represents the element type and the function `compare`,
whose signature is `t -> t -> int`. The
`String` module matches that structure, so we could
directly pass `String` as an argument to `Set.Make`. Incidentally, many
other modules also have that structure, including `Int` and `Float`,
so they too can be directly passed into `Set.Make` to construct a corresponding set module.

The `StringSet` module we created uses the built-in `compare` function provided by the `String` module.

Let's say we want to create a set of strings that performs a case-insensitive
comparison instead of the case-sensitive comparison provided by `String.compare`.

We can accomplish this by passing an ad-hoc module to the `Set.Make` function:

```ocaml
# module CISS = Set.Make(struct
  type t = string
  let compare a b = compare (String.lowercase_ascii a) (String.lowercase_ascii b)
end);;
- : sig
    type elt = string
    type t
    val empty : t
    val is_empty : t -> bool
    val mem : elt -> t -> bool
    val add : elt -> t -> t
(...)
```

We name the resulting module `CISS` (short for "Case Insensitive String Set").

You can see that this module has the intended behavior:

```ocaml
# CISS.singleton "hello" |> CISS.add "HELLO" |> CISS.to_list;;
- : string list = ["hello"]
```

The value `"HELLO"` is not added to the set because it is considered equal to the value `"hello"`, which is already contained in the set.

You can use any type for elements, as long as you define a meaningful `compare` operation.

```ocaml
# type color = Red | Green | Blue;;
type color = Red | Green | Blue

# module SC = Set.Make(struct
  type t = color
  let compare a b =
    match a, b with
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

We gave an overview of OCaml's `Set` module by creating a `StringSet` module using the `Set.Make` functor. Further, we looked at how to create sets based on a custom comparison function. For more information, refer to [Set](/manual/api/Set.Make.html) in the Standard Library documentation.

