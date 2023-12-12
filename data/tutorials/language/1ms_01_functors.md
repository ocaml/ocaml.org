---
id: functors
title: Functors
short_title: Functors
description: >
  Learn about functors, modules parameterised by other modules
category: "Module System"
---

## Introduction

Learning goals:
- How to use a functor
- How to write a functor
- When to use a functor, some cases

A functor is just a parametrized module.

**Prerequisites**: Transitive closure leading to modules.

## Project Setup

This tutorial uses the [Dune](https://dune.build) build tool. Make sure to have installed version 3.7 or later. We start by creating a fresh project. We need a folder named `funkt` with files `dune-project`, `dune`, `funkt.opam` and `funkt.ml`, the latter two are created empty.
```shell
$ mkdir funkt; cd funkt

$ touch funkt.opam funkt.ml
```

**`dune-project`**
```lisp
(lang dune 3.7)
```

**`dune`**
```lisp
(executable
  (name funkt)
  (public_name funkt)
  (libraries str))
```

Check this works using the `dune exec funkt` command, it shouldn't do anything (the empty file is valid OCaml syntax) but it shouldn't fail either. The stanza `libraries str` will be used later.

## Using an Existing Functor: `Set.Make`

The standard library contains a [`Set`](/api/Set.html) module providing a data structure that allows operations like union and intersection. To use the provided type and its associated [functions](/api/Set.S.html), it is required to use the functor provided by `Set`. For reference only, here is a shortened version of the interface of `Set`.
```ocaml
module type OrderedType = sig
  type t
  val compare : t -> t -> int
end

module type S = sig
  (* ... *)
end

module Make : functor (Ord : OrderedType) -> S
```

**Note**: Most set operation implementations must use a comparison function. Using `Stdlib.compare` would make it impossible to use a user-defined comparison algorithm. Passing the comparison function as a higher-order parameter (like in `Array.sort` for instance) would add a lot of boilerplate. Providing set operations as a functor allows specifying the comparison function only once.

The functor `Set.Make` needs to be passed a module of type `Set.OrderedType` to produce a module of type `Set.S`. Here is how it can look like in our project:

**`funkt.ml`**
```ocaml
module StringSet = Set.Make(String)
```

With this, the command `dune exec funkt` shouldn't do anything but it shouldn't fail either. Here is the meaning of that statement
- The module `funkt.StringSet` is defined
- The module `String` (from the standard library) is applied to the functor `Set.Make`. This is allowed because the `String` module satisfies the interface `Set.OrderedSet`
  - It defines a type name `t` (which is an alias for `string`)
  - It defines a function `compare` of type `t -> t -> bool`, that is the function `String.compare`
- The result module from the functor application `Set.Make(String)` is bound to the name `StringSet`, it has the signature `Set.S`.

Add some code to the `funkt.ml` file to produce an executable that does something and checks the result.

**`funkt.ml`**
```ocaml
module StringSet = Set.Make(String)

let _ =
  In_channel.input_lines stdin
  |> List.concat_map Str.(split (regexp "[ \t.,;:()]+"))
  |> StringSet.of_list
  |> StringSet.iter print_endline
```

Here are the types of functions used throughout the pipe
- `In_channel.input_lines : in_channel -> string list`
- `Str.(split (regexp "[ \t.,;:()]+")) : string -> string list`
- `List.concat_map : ('a -> 'b list) -> 'a list -> 'b list`
- `StringSet.of_list : string list -> StringSet.t` and
- `StringSet.iter : StringSet.t -> unit`

This reads the following way:
- Read lines of text from standard input, produce a list of strings
- Split each string using a regular expression, flatten the list of lists into a list
- Convert the list of strings into a set
- Display each element of the set

The functions `StringSet.of_list` and `StringSet.iter` are available as the result of the functor application.

```shell
$ dune exec funkt < dune
executable
libraries
name
public_name
str
funkt
```

There are no duplicates in a `Set`. Therefore, the string `"funkt"` is only displayed once although it appears twice in the file `dune`.

## Extending a Module with a Functor

Using the `include` statement, here is an alternate way to expose the module created by `Set.Make(String)`.

**`funkt.ml`**
```ocaml
module String = struct
  include String
  module Set = Set.Make(String)
end

let _ =
  stdin
  |> In_channel.input_lines
  |> List.concat_map Str.(split (regexp "[ \t.,;:()]+"))
  |> String.Set.of_list
  |> String.Set.iter print_endline
```

This allows seemingly extending the module `String` with a submodule `Set`. Check the behaviour using `dune exec funkt < dune`.

## Parametrized Implementations

### The Standard Library: `Set`, `Map` and `Hashtbl`

Some ”modules” provide operations over an abstract type and need to be supplied with a parameter module used in their implementation. These “modules” are parametrized, in other words, functors. That's the case for the sets, maps and hash tables provided by the standard library. It works in a contract way:
* if you provide a module that implements what is expected (the parameter interface);
* the functor returns a module that implements what is promised (the result interface)

Here is the signature of the module that the functors `Set.Make` and `Map.Make` expect:
```ocaml
module type OrderedType = sig
  type t
  val compare : t -> t -> int
end
```

Here is the signature of the module that the functor `Hashtbl.Make` expects:
```ocaml
module type HashedType = sig
  type t
  val equal : t -> t -> bool
  val hash : t -> int
end
```

**Note**: `Ordered.t` is a type of set elements or map keys, `Set.S.t` is a type of set and `Map.S.t` is a type of mapping. `HashedType.t` is a type of hash table keys and `Hashtbl.S.t` is a type of hash table.

The functors  `Set.Make`, `Map.Make` and `Hashtbl.Make` return modules satisfying the interfaces `Set.S`, `Map.S` and `Hashtbl.S` (respectively) that all contain an abstract type `t` and associated functions. Refer to the documentation for the details about what they provide:
* [`Set.S`](/api/Set.S.html)
* [`Map.S`](/api/Map.S.html)
* [`Hashtbl.S`](/api/Hashtbl.S.html)

## Custom Parametrized Implementation

There are many kinds of [heap](https://en.wikipedia.org/wiki/Heap_(data_structure)) data structures. Example include binary heaps, leftist heaps, binomial heaps or Fibonacci heaps.

What kind of data structures and algorithms are used to implement a heap is not discussed in this document.

The common prerequisite to implementing any kind of heap is the availability of a means to compare the elements they contain. That's the same signature as the parameter of `Set.Make` and `Map.Make`:
```ocaml
module type OrderedType = sig
  type t
  val compare : t -> t -> int
end
```

Using such a parameter, a heap implementation must provide at least this interface
```ocaml
module type HeapType = sig
  type elt
  type t
  val empty : t
  val is_empty : t -> bool
  val insert : t -> elt -> t
  val merge : t -> t -> t
  val find : t -> elt
  val delete : t -> t
end
```

Heap implementations can be represented as functors from `OrderedType` into `HeapType`. Each kind of heap would be a different functor.

Here is the skeleton of a possible implementation.

**heap.ml**
```ocaml
module type OrderedType = sig
  type t
  val compare : t -> t -> int
end

module type S = sig
  type elt
  type t
  val empty : t
  val is_empty : t -> bool
  val insert : t -> elt -> t
  val merge : t -> t -> t
  val find : t -> elt
  val delete : t -> t
end

module Binary(Elt: OrderedType) : S = struct
  type elt = | (* Replace by your own *)
  type t = | (* Replace by your own *)
  (* Add private functions here *)
  let is_empty h = failwith "Not yet implemented"
  let insert h e = failwith "Not yet implemented"
  let merge h1 h2 = failwith "Not yet implemented"
  let find h = failwith "Not yet implemented"
  let delete h = failwith "Not yet implemented"
end
```

Here binary heaps is the only implementation suggested. This can be extended to other implementations by adding one functor per each (e.g. `Heap.Leftist`, `Heap.Binomial`, `Heap.Fibonacci`, etc.)

## Injecting Dependencies Using Functors

### Module Dependencies

Here is a new version of the `funkt` program.

**`funkt.ml`**
```ocaml
module StringSet = Set.Make(String)

module IterPrint : sig
  val f : string list -> unit
end = struct
  let f = List.iter (fun s -> Out_channel.output_string stdout (s ^ "\n"))
end

let _ =
  stdin
  |> In_channel.input_lines
  |> List.concat_map Str.(split (regexp "[ \t.,;:()]+"))
  |> StringSet.of_list
  |> StringSet.elements
  |> IterPrint.f
```

It embeds an additional `IterPrint` module that exposes a single function `f` of type `string list -> unit` and has two dependencies:
  - Module `List` through `List.iter` and the type of its `f` function
  - Module `Out_channel` through `Out_channel.output_string`

Check the behaviour of the program using `dune exec funkt < dune`.

### Dependency Injection

This is a dependency injection refactoring of the module `IterPrint`.

**`iterPrint.ml`**
```ocaml
module type Iterable = sig
  type 'a t
  val iter : ('a -> unit) -> 'a t -> unit
end

module type S = sig
  type 'a t
  val f : string t -> unit
end

module Make(Dep: Iterable) : S with type 'a t := 'a Dep.t = struct
  let f = Dep.iter (fun s -> Out_channel.output_string stdout (s ^ "\n"))
end
```

The module `IterPrint` is refactored into a functor that takes the dependency providing `iter` as a parameter. The `with type 'a t := 'a Dep.t` constraint means the type `t` from the parameter `Dep` replaces the type `t` in the result module. This allows the type of `f` to use the type `t` from the parameter module `Dep`. With this refactoring, `IterPrint` only has one dependency; at the time it is compiled, no implementation of function `iter` is available yet.

**Note**: An OCaml interface file must be a module, not a functor. Functors must be embedded inside modules. Therefore, it is customary to call them `Make`.

**`funkt.ml`**

```ocaml
module StringSet = Set.Make(String)
module IterPrint = IterPrint.Make(List)

let _ =
  stdin
  |> In_channel.input_lines
  |> List.concat_map Str.(split (regexp "[ \t.,;:()]+"))
  |> StringSet.of_list
  |> StringSet.elements
  |> IterPrint.f
```

The dependency `List` is _injected_ when compiling the module `Funkt`. Observe that the code using `IterPrint` is unchanged. Check the behaviour of the program using `dune exec funkt < dune`.

### Dependency Substitution

Now, replacing the implementation of `iter` inside `IterListPrint` is no longer a refactoring, it is another functor application with another dependency. Here, `Array` replaces `List`.

**`funkt.ml`**
```ocaml
module StringSet = Set.Make(String)
module IterPrint = IterPrint.Make(Array)

let _ =
  stdin
  |> In_channel.input_lines
  |> List.concat_map Str.(split (regexp "[ \t.,;:()]+"))
  |> StringSet.of_list
  |> StringSet.elements
  |> Array.of_list
  |> IterPrint.f
```

Check the behaviour of the program using `dune exec funkt < dune`.

**Note**: The functor `IterPrint.Make` returns a module that exposes the type of the injected dependency (here first `List.t` then `Array.t`). That's why a `with type` constraint is needed. If the dependency was an _implementation detail_ that is not exposed in the signature of the initial version of `IterMake` (i.e. in the type of `IterMake.f`), that constraint wouldn't be needed and the call site of `IterPrint.f` would be unchanged when injecting another dependency.

## Custom Module Extension

In this section, we define a functor to extend another module. This is the same idea as in the [Extending a Module with a Functor](#extending-a-module-with-a-functor), except we write the functor ourselves.

Create a fresh directory with the following files:

**`dune-project`**
```lisp
(lang dune 3.7)
```
**`dune`**
```lisp
(library (name scanLeft))
```

**`scanLeft.ml`**
```ocaml
module type LeftFoldable = sig
  type 'a t
  val fold_left : ('b -> 'a -> 'b) -> 'b -> 'a t -> 'b
  val of_list : 'a list -> 'a t
end

module type S = sig
  type 'a t
  val scan_left : ('b -> 'a -> 'b) -> 'b -> 'a t -> 'b t
end

module Make(F: LeftFoldable) : S with type 'a t := 'a F.t = struct
  let scan_left f b u =
    let f (b, u) a = let b' = f b a in (b', b' :: u) in
    u |> F.fold_left f (b, []) |> snd |> List.rev |> F.of_list
end
```

Run the `dune utop` command, and inside the toplevel enter the following commands. For brievety, the output of the first two toplevel commands is not shown here.
```ocaml
# module Array = struct
    include Stdlib.Array
    include ScanLeft.Make(Stdlib.Array)
  end;;

# module List = struct
    include List
    include ScanLeft.Make(struct
      include List
      let of_list = Fun.id
    end)
  end;;

# Array.init 10 Fun.id |> Array.scan_left ( + ) 0;;
- : int array = [|0; 1; 3; 6; 10; 15; 21; 28; 36; 45|]

# List.init 10 Fun.id |> List.scan_left ( + ) 0;;
- : int list = [0; 1; 3; 6; 10; 15; 21; 28; 36; 45]
```

Modules `Array` and `List` appear augmented with `Array.scan_left` and `List.scan_left`.

## Conclusion