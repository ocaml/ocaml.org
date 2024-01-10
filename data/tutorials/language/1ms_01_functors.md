---
id: functors
title: Functors
short_title: Functors
description: >
  Functors essentially work the same way as functions. The difference is that we are passing modules instead of values.
category: "Module System"
---

## Introduction

In this tutorial, we look at how to use a functor, how to write a functor, and show a couple of use cases involving functors.

As suggested by the name, a _functor_ is almost like a function. However, while functions are between values, functors are between modules. A functor takes a module as a parameter and returns a module as a result. A functor is a parametrised module.

**Prerequisites**: [Modules](/docs/modules).

## Project Setup

This tutorial uses the [Dune](https://dune.build) build tool. Make sure you have installed version 3.7 or later. We start by creating a fresh project. We need a folder named `funkt` with files `dune-project`, `dune`, and `funkt.ml`. The latter two are created empty.
```shell
$ mkdir funkt; cd funkt
```

**`dune-project`**
```lisp
(lang dune 3.7)
(package (name funkt))
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

The standard library contains a [`Set`](/api/Set.html) module providing a data structure that allows operations like union and intersection. To use the provided type and its associated [functions](/api/Set.S.html), it's necessary to use the functor provided by `Set`. For reference only, here is a shortened version of the interface of `Set`:
```ocaml
module type OrderedType = sig
  type t
  val compare : t -> t -> int
end

module type S = sig
  (** This is the module's signature returned by applying `Make` *)
end

module Make : functor (Ord : OrderedType) -> S
```

Here is how this reads (starting from the bottom-up, then going up):
* Like a function (indicated by the arrow `->`), the functor `Set.Make`
  - takes a module having `Set.OrderedType` as signature and
  - returns a module having `Set.S` as signature
* The module type `Set.S` is the signature of some sort of set
* The module type `Set.OrderedType` is the signature of elements of a

**Note**: Most set operation implementations must use a comparison function. Using `Stdlib.compare` would make it impossible to use a user-defined comparison algorithm. Passing the comparison function as a higher-order parameter, as done in `Array.sort`, for example, would add a lot of boilerplate code. Providing set operations as a functor allows specifying the comparison function only once.

Here is what it can look like in our project:

**`funkt.ml`**

```ocaml
module StringCompare = struct
  type t = string
  let compare = String.compare
end

module StringSet = Set.Make(StringCompare)
```

This defines a module `Funkt.StringSet`. What `Set.Make` needs is:
- A type `t`, here `string`
- A function allowing to compare two values of type `t`, here `String.compare`

However, since the module `String` defines
- A type name `t`, which is an alias for `string`
- A function `compare` of type `t -> t -> bool` that allows to compare two strings

This can be simplified using an _anonymous module_ expression:
```ocaml
module StringSet = Set.Make(struct
  type t = string
  let compare = String.compare
end)
```

The module expression `struct ... end` is inlined in the call to `Set.Make`.

The be simplified even further into this:
```ocaml
module StringSet = Set.Make(String)
```

In both versions, the result module from the functor application `Set.Make(String)` is bound to the name `StringSet`, and it has the signature `Set.S`. The module `StringSet` provides set operations and is parametrized by the module `String`. This means the function `String.compare` is used internally by `StringSet`, inside the implementation of the functions it provides. Making a group of functions (here those provided by `StringSet`) use another group of functions (here only `String.compare`) is the role of a functor.

With this, the command `dune exec funkt` shouldn't do anything, but it shouldn't fail either.

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

Here are the types of functions used throughout the pipe:
- `In_channel.input_lines : in_channel -> string list`,
- `Str.(split (regexp "[ \t.,;:()]+")) : string -> string list`,
- `List.concat_map : ('a -> 'b list) -> 'a list -> 'b list`,
- `StringSet.of_list : string list -> StringSet.t`, and
- `StringSet.iter : StringSet.t -> unit`.

This reads the following way:
- Read lines of text from standard input, that produces a list of strings.
- Split each string using a regular expression and flatten the resulting list of lists into a list.
- Convert the list of strings into a set.
- Display each element of the set.

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

There are no duplicates in a `Set`. Therefore, the string `"funkt"` is only displayed once, although it appears twice in the `dune` file.

## Extending a Module with a Standard Library Functor

Using the `include` statement, here is an alternate way to expose the module created by `Set.Make(String)`:

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

This allows the user to seemingly extend the module `String` with a submodule `Set`. Check the behaviour using `dune exec funkt < dune`.

## Functors are Parametrised Modules

### Functors from the Standard Library

Some ”modules” provide operations over an abstract type and need to be supplied with a parameter module used in their implementation. These “modules” are parametrised, in other words, functors. That's the case for the sets, maps, and hash tables provided by the standard library. It works like a contract between the functor and the developer:
* If you provide a module that implements what is expected (the parameter interface)
* The functor returns a module that implements what is promised (the result interface)

Here is the module's signature that the functors `Set.Make` and `Map.Make` expect:
```ocaml
module type OrderedType = sig
  type t
  val compare : t -> t -> int
end
```

Here is the module's signature that the functor `Hashtbl.Make` expects:
```ocaml
module type HashedType = sig
  type t
  val equal : t -> t -> bool
  val hash : t -> int
end
```

**Note**: `Ordered.t` is a type of set elements or map keys, `Set.S.t` is a type of set, and `Map.S.t` is a type of mapping. `HashedType.t` is a type of hash table keys, and `Hashtbl.S.t` is a type of hash table.

The functors  `Set.Make`, `Map.Make`, and `Hashtbl.Make` return modules satisfying the interfaces `Set.S`, `Map.S`, and `Hashtbl.S` (respectively), which all contain an abstract type `t` and associated functions. Refer to the documentation for the details about what they provide:
* [`Set.S`](/api/Set.S.html)
* [`Map.S`](/api/Map.S.html)
* [`Hashtbl.S`](/api/Hashtbl.S.html)

### Writing Your Own Functors

There are many kinds of [heap](https://en.wikipedia.org/wiki/Heap_(data_structure)) data structures. Example include binary heaps, leftist heaps, binomial heaps, or Fibonacci heaps.

The kind of data structures and algorithms used to implement a heap is not discussed in this document.

The common prerequisite to implement any heap is a means to compare the elements they contain. That's the same signature as the parameter of `Set.Make` and `Map.Make`:
```ocaml
module type OrderedType = sig
  type t
  val compare : t -> t -> int
end
```

Using such a parameter, a heap implementation must provide at least this interface:
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

Here is the skeleton of a possible implementation:

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

Here, binary heaps is the only implementation suggested. This can be extended to other implementations by adding one functor per each (e.g., `Heap.Leftist`, `Heap.Binomial`, `Heap.Fibonacci`, etc.).

## Injecting Dependencies Using Functors

**Dependencies Between Modules**

Here is a new version of the `funkt` program:

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

**Dependency Injection**

[Dependency injection](https://en.wikipedia.org/wiki/Dependency_injection) is a way to parametrise over a dependency.

Here is a refactoring of the module `IterPrint` to make of this technique:

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

The module `IterPrint` is refactored into a functor that takes as a parameter a module providing the function `iter`. The `with type 'a t := 'a Dep.t` constraint means the type `t` from the parameter `Dep` replaces the type `t` in the result module. This allows the type of `f` to use the type `t` from the parameter module `Dep`. With this refactoring, `IterPrint` only has one dependency; at the time it is compiled, no implementation of function `iter` is available yet.

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

The dependency `List` is _injected_ when compiling the module `Funkt`. Observe that the code using `IterPrint` is unchanged. Check the program's behaviour using `dune exec funkt < dune`.

**Replacing a Dependency**

Now, replacing the implementation of `iter` inside `IterListPrint` is no longer a refactoring; it is another functor application with another dependency. Here, `Array` replaces `List`:

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

Check the program's behaviour using `dune exec funkt < dune`.

**Note**: The functor `IterPrint.Make` returns a module that exposes the type from the injected dependency (here first `List.t` then `Array.t`). That's why a `with type` constraint is needed. If the dependency was an _implementation detail_ that wasn't exposed in the signature of `IterMake`'s initial version (i.e., in the type of `IterMake.f`), that constraint wouldn't be needed. Plus, the call site of `IterPrint.f` would be unchanged when injecting another dependency.

## Write a Functor to Extend Modules

In this section, we define a functor to extend several modules in the same way. This is the same idea as in the [Extending a Module with a Standard Library Functor](#extending-a-module-with-a-standard-library-functor), except we write the functor ourselves.

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

Run the `dune utop` command. Once inside the toplevel, enter the following commands.
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

Modules `Array` and `List` appear augmented with `Array.scan_left` and `List.scan_left`. For brevity, the output of the first two toplevel commands is not shown here.

## Initialisation of Stateful Modules

Modules can hold a state. Functors can provide a means to initialize stateful modules. As an example of such, here is a possible way to handle random number generation seeds as a state.

**`random.ml`**
```ocaml
module type SeedType : sig
  val v : int array
end

module type S : sig
  val reset_state : unit -> unit

  val bits : unit -> int
  val bits32 : unit -> int32
  val bits64 : unit -> int64
  val nativebits : unit -> nativeint
  val int : int -> int
  val int32 : int32 -> int32
  val int64 : int64 -> int64
  val nativeint : nativeint -> nativeint
  val full_int : int -> int
  val float : float -> float
  val bool : unit -> bool

end

module Make(Seed: SeedType) : S = struct
  let state = Seed.v |> Random.State.make |> ref
  let reset_state () = state := Random.State.make Seed.v

  let bits () = Random.State.bits !state
  let bits32 () = Random.State.bits32 !state
  let bits64 () = Random.State.bits64 !state
  let nativebits () = Random.State.nativebits !state
  let int = Random.State.int !state
  let int32 = Random.State.int32 !state
  let int64 = Random.State.int64 !state
  let nativeint = Random.State.nativeint !state
  let full_int = Random.State.full_int !state
  let float = Random.State.float !state
  let bool () = Random.State.bool !state
end
```

Create this file and launch `utop`.
```ocaml
# #mod_use "random.ml";;

# module R1 = Random.Make(struct let v = [|0; 1; 2; 3|] end);;

# module R2 = Random.Make(struct let v = [|0; 1; 2; 3|] end);;

# R1.bits ();;
- : int = 75783189

# R2.bits ();;
- : int = 75783189

# R1.bits ();;
- : int = 774473149

# R1.reset_state ();;
- : unit = ()

# R2.bits ();;
- : int = 774473149

# R1.bits ();;
- : int = 75783189
```

Modules `R1` and `R2` are created with the same state, therefore, the first calls to `R1.bits` and `R2.bits` return the same value.

The second call to `R1.bits` moves `R1`'s state one step and returns the corresponding bits. The call to `R1.reset_state` sets the `R1`'s state to its initial value.

Calling `R2.bits` a second time shows the modules aren't sharing the state, otherwise, the value from the first calls to `bits` would have been returned.

Calling `R1.bits` a third time returns the same result as the first call, which demonstrates the state has indeed been reset.

## Conclusion

Functors are pretty unique to the ML family of programming languages. They provide a means to pass definitions inside a module. The same behaviour can be achieved with high-order parameters. However, functors allow passing several definitions at once, which is more convenient.

Functor application essentially works the same way as function application: passing parameters and getting results. The difference is that we are passing modules instead of values. Beyond comfort, it enables a design approach where concerns are not only separated in silos, which is enabled by modules, but also in stages stacked upon each other.
