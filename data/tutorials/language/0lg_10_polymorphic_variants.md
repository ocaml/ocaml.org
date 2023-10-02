---
id: polymorphic-variants
title: Polymorphic Variants
description: |
  Everything you always wanted to know about polymorphic variants, but were afraid to ask
category: "Language"
---

# Polymorphic Variants

## Introduction

Product types and data types such as `option` and `list` are variants and polymorphic. In this tutorial, they are called _simple variants_ to distinguish them from the _polymorphic variants_ presented in this tutorial. Simple variants and polymorphic variants are close siblings. Their values are both introduced using labels that may carry data. Both can be recursive and have type parameters. Both are statically type-checked.

However, they are type checked using very different algorithms, which result in a very different programming experience. The relationship between value and type (writen with the colon symbol `:`) is changed with polymorphic variants. Usually, values are seen as inhabitants of a type, which is though as a set-like things. Polymorphic variant values should rather be thought as pieces of data that can be accepted by functions and polymorphic variant types a way to express compabitibity relationship between those functions. The approach in this tutorial is to build sense from experience using features of polymorphic variants.

By the way, don't trust ChatGPT if it tells you polymorphic variants are dynamically type-checked, it is hallucinating.

### Origin and Context

Polymorphic variants origins from Jacques Garrigue work on Objective Label, which was [first published in 1996](https://caml.inria.fr/pub/old_caml_site/caml-list-ar/0533.html). It became part of stantard OCaml in [release 3.0](https://caml.inria.fr/distrib/ocaml-3.00/), in 2000, along with labelled and optional function arguments.

The core type system of OCaml follows a [_nominal_](https://en.wikipedia.org/wiki/Nominal_type_system) discipline. Types are first explicitely declared, later they are used. The typing discipline used for polymorphic variants and classes is different, it is [_structural_](https://en.wikipedia.org/wiki/Structural_type_system).

In the nominal approach of typing, types are first defined; later, when type-checking an expression, three outcomes are possible:
1. If a matching type is found, it becomes the infered type
1. If any type can be applied, a type variable is created
1. If typing inconsistencies are found, an error is raised

This is very similar to solving an equation in mathematics. Equation on numbers accepts either zero, exactly one, several or infinitely many solutions. Nominal type checking finds that either zero, exactly one or any type can be used in an expression.

In the structural approach of typing, type definitions are optional, they can be omitted. Type checking an expression constructs a data structure that represents types which are compatible with it. These data structures are displayed as type expressions sharing ressemblance with simple variants but turns out to have pretty different meaning.

### Learning Goals

The goal of this tutorial is to make the reader acquire the following capabilities:
- Write polymorphic variant using code, from strach, using mainstream features
- Maintain existing code that is using polymorphic variants
- Sort out polymorphic variant types and errors
  - Add type annotation needed to resolve polymorphic variant type-checking issues
  - Add or remove catch all patterns in polymorphic variant pattern matching
  - Insert or remove type casts
- Refactor between simple and polymorphic variants
- Choose to use polymorphic variant when really needed

### Variants and Polymorphism

The type expression `'a list` does not designate a single type, it designates a family of types, all the types that can be created by substituing an actual type to type variable `'a`. The type expressions `int list`, `bool option list` or `(float -> float) list list` are real types, with associated values. They are example members of the family `'a list`. The identifiers `list`, `option` and others are type operators. Just like functions, they take parameters, except those parameters are not values, they are types; and result aren't values but a type too. Therfore, simple variants are polymorphic, but not in the same sense as polymorphic variants.
- Simple variants have [parametric poymorphism](https://en.wikipedia.org/wiki/Parametric_polymorphism)
- Polymorphic variants have a form of [structural polymorphism](https://en.wikipedia.org/wiki/Structural_type_system)

## A First Example

### Creating Polymorphic Variant Types From Pattern Matching

Polymorphic variant visual signature are backquotes. Pattern matching on them looks just the same as with simple variants, except for backquotes (and capitals, which are not longer mandatory). Here is a first example:
```ocaml
# let f = function `Broccoli -> "Broccoli" | `Fruit name -> name;;
f : [< `Broccoli | `Fruit of string ] -> string = <fun>
```

Here`` `Broccoli`` and`` `Fruit`` plays a role similar to the role played by the constructors `Broccoli` and `Fruit` in a variant declared as `type t = Broccoli | Fruit of string`. Except, and most importantly, that the type definition doesn't need to be written. The tokens`` `Broccoli`` and `` `Fruit`` are called _tags_ instead of constructors. A tag is defined by a name and a list of parameter types.

The expression ``[< `Broccoli | `Fruit of string ]`` play the role of a type. However, it does not represent a single type, it represents three different types.
- The type that only has`` `Broccoli`` as inhabitant, its translation into a simple variant is `type t0 = Broccoli`
- The type that only has`` `Fruit`` as inhabitant, its translation into a simple variant is `type t1 = Fruit of string`
- Type type that has both`` `Broccoli`` and`` `Fruit`` inhabitants, its translation into a simple variant is `type t2 = Broccoli | Fruit of string`

Note each of the above translations into simple variants is correct. However, entering them as-is into the environment would lead to constructor shadowing.

This also illustrates the other strinking feature of polymorphic variants: values can be attached to several types. For instance, the tag `` `Broccoli`` inhabits ``[ `Broccoli ]`` and``[ `Broccoli | `Fruit of String ]``, but it also inhabits any type that containts it.

What is displayed by the type-checker, for instance ``[< `Broccoli | `Fruit of string ]``, isn't a single type. It is a type expression that designates a constrained set of types. For instance, all types defined by a group of tags that contains either`` `Broccoli`` or `` `Fruit of string`` and nothing more. This is the meaning of the `<` sign in this type expression. This a bit similar to what happens with `'a list`, which isn't a single type either, but a type expression that desginates the set of lists of something, i.e. the set of types where `'a` has been replaced by some other type.

This is the sense of the polymorphism of polymorphic variants. Polymorphic variants types are type expressions. The structural typing algorithm used for polymorphic variants creates type expressions that designate sets of types (here the three types above), which are defined by contraints on sets of tags: the inequality symbols. The polymorphism of polymorphic variant is different.

In the rest of this tutorial, the following terminology is used:
- “simple variants”: product types and variants such as `list`, `option` and others
- polymorphic variant: type expressions displayed by the OCaml type-checker such as ``[< `Broccoli | `Fruit of string ]``

### Tag Sharing

Here is another function using pattern matching on a polymorphic variant.
```ocaml
# let g = function `Edible name -> name | `Broccoli -> "Brassica oleracea var. italica";;
val g : [< `Broccoli | `Edible of string ] -> string = <fun>

# f `Broccoli;;
- : string = "Broccoli"

# g `Broccoli;;
- : string = "Brassica oleracea var. italica"
```

Both `f` and `g` accepts the`` `Broccoli`` tag as input because they both have code for it. They do not have the same domain because `f` also accepts `` `Fruit`` whilst `g` accepts `` `Edible`` instead. The types of the domains of `f` and `g` expresses this. The tag `` `Broccoli`` satisfies the both the constraints of the domain of `f`: ``[< `Broccoli | `Fruit of string ]`` and the contraints of the domain of `g`: ``[< `Broccoli | `Fruit of string ]``. The same way tag defined values belong to several types, tag accepting functions belong to several types too.

### Static Type Checking

Type-checking of polymorphic variants is static. No information on tag's types is available at runtime.
```ocaml
# [ `Fruit "Banana"; `Fruit true ];;
Error: This expression has type bool but an expression was expected of type
         string
```
When a tag is used insconsistantly, the type-cecker will raise an error.

### Merging Constraints

When building expression from subexpressions, the type-check assembles types from subexpressions to create the type of the whole expression. This is why the type discipline used for polymorphic variants is said to be structural, it follows the structure of the expressions.
```ocaml
# let brocco = `Broccoli;;

# let pepe = `Peperone;;

# [ brocco; pepe; brocco ];;
- : [> `Broccoli | `Peperone ] list = [`Broccoli; `Peperone; `Broccoli]
```

## Exact, Closed and Open Variants

Polymorphic variant type expressions can have three forms:
1. Exact: ``[ `Broccoli | `Gherkin | `Fruit of string ]`` : this only designates the type inhabited by the values introduced by these tags. Tags names must occur exaclty once.
1. Closed: ``[< `Broccoli | `Gherkin | `Fruit of string ]`` : this designates a set of exact types. Each exact type is inhabited by the values introduced by a subset of the tags from 1. For instance, there are 7 exact types as such:
  - ``[ `Broccoli ]``
  - ``[ `Gherkin ]``
  - ``[ `Fruit of string ]``
  - ``[ `Gherkin | `Fruit of string ]``
  - ``[ `Broccoli | `Fruit of string ]``
  - ``[ `Broccoli | `Gherkin ]``
  - ``[ `Broccoli | `Gherkin | `Fruit of string ]``
1. Open: ``[> `Broccoli | `Gherkin | `Fruit of string ]`` : this designates a set of exact types. Eact eact type is inhabited by the values introduced by supersets of the tags from 1.

Tip: To distinguish closed and open type expression, you can remember that the less-than sign `<` is oriented the same way as a capital `C` letter, as in closed.

The exact form is infered by the type-checker when naming a type defined by a set of tags:
```ocaml
# type t = [ `Broccoli | `Gherkin | `Fruit of string ]
type t = [ `Broccoli | `Fruit of string | `Gherkin ]
```

The closed form is introduced when performing pattern matching over a explicit set of tags
```ocaml
# let f = function
    | `Broccoli -> "Broccoli"
    | `Gherkin -> "Gherkin"
    | `Fruit Fruit -> Fruit;;
val upcast : [< `Broccoli | `Fruit of string | `Gherkin ] -> string = <fun>
```

Function `f` can be used with any exact type which has these three tags or less. When applied to a type with less tags, branches associated to removed tags turn safely into dead code. The type is closed because the function can't accept more than what is listed.

The open form can be introduced in two different ways.

Open polymorphic variants appear when adding a `_` to a pattern matching on tags:
```ocaml
# let g = function
    | `Broccoli -> "Broccoli"
    | `Gherkin -> "Gherkin"
    | `Fruit Fruit -> Fruit
    | _ -> "Edible plant";;
val g : [> `Broccoli | `Fruit of string | `Gherkin ] -> string = <fun>
```

Function `g` can be used with any exact type which has these three tags or more. Because of the catch all pattern, if `g` is passed a value introduced by a tag which is not part of the list, it will be accepted, and `"Edible plant"` is returned. The type is open because it can accept more than what is listed.

The type of `g` is also meant to disallow exact types with tags removed or changed in type. OCaml is a statically typed language, that means no type information is available at runtime. As a consequence pattern matching only relies on tag names. If `g` was given a type with removed tags, such as``[> `Broccoli | `Gherkin ]``, then passing`` `Fruit`` to `g` would be allowed, but since dispatch is based on names, it would execute the`` `Fruit of string`` branch and crash because no string is available. Therefore, open polymorphic variant must include all the tags from pattern matching.

Open polymorphic variants also appear when type-checking tags as values.
```ocaml
# `Gherkin
- : [> `Gherkin ] = `Gherkin

# [ `Broccoli; `Gherkin; `Broccoli ];;
- : [> `Broccoli | `Gherkin ] list = [ `Broccoli; `Gherkin; `Broccoli ]
```

Binding a tag to the open polymorphic variant type which only contains enables:
- Using it all the contexts where applicable code is available
- Avoid using it in contexts that can't deal with it
- Building sum of polymorphic variants, this is show in the second example.

This also applies to function returning polymorphic variant values.
```ocaml
# let f b = if b then `On else `Off;;
val f : bool -> [> `Off | `On ] = <fun>
```

The codomain of `f` is the open type ``[> `Off | `On ]``. This make sense when having a look at function composition.
```ocaml
# let g = function
    | `On -> 1
    | `Off -> 2
    | `Broken -> 3;;

# fun x -> x |> f |> g;;
- : bool -> int = <fun>
```

Functions `g` and `f` can be composed because the former accepts more than the latter can return. The value `` `Broken`` will never pass in the `f |> g` pipe, but it safe to write it as no unexpected value can make its way through.

The exact case correspond to simple variants. Closed and open cases are polymorphic because they do not designate a single type but families of types. An exact variant type is monomorphic, it corresponds to a single variant type, not a set of variant types.

## Example of Polymorphic Variant Type That is Both and Closed

A closed variant may also have a lower bound.
```ocaml
# let is_red = function `Clubs -> false | `Diamonds -> true | `Hearts -> true | `Spades -> false;;
val is_red : [< `Clubs | `Diamonds | `Hearts | `Spades ] -> bool = <fun>

# let h = fun u -> List.map is_red (`Hearts :: u);;
val h : [< `Clubs | `Diamonds | `Hearts | `Spades > `Hearts ] list -> bool list = <fun>
```

Function `is_red` only accepts values from any subtype of ``[< `Clubs | `Diamonds | `Hearts | `Spades ]``. However, function `h` excludes the exact types ``[ `Clubs ]``, ``[ `Diamonds ]`` and ``[ `Spades ]``. Since the list passed to `List.map` includes a `` `Hearts`` tags, types which do no include it are not allowed. The domain of `h` is closed by ``[ `Clubs | `Diamonds | `Hearts | `Spades ]`` and open by ``[ `Hearts ]``.

## Subtyping of Polymorphic Variants

Variants which are not polymorphic variant are say to be simple variants. These variants have parametric polymorphism. Together with predefined types, they are type-checked using the nominal typing discipline. In this discipline a value has a unique type.

In the structural type-checking discipline, a value may have several types. Equivalently it can be said to inhabit several types:
```ocaml
# let gherkin = `Gherkin;;
val Gherkin : [> `Gherkin ] = `Gherkin

# let (gherkin : [ `Gherkin ]) = `Gherkin;;
val Gherkin : [ `Gherkin ] = `Gherkin

# let (gherkin : [ `Gherkin | `Avocado ]) = `Gherkin;;
val Gherkin : [ `Gherkin | `Avocado ] = `Gherkin
```

1. By default, the type assigned to the `` `Gherkin`` tag is ``[> `Gherkin]``. It means: any variant type which includes that tag.
1. Using an annotation, the type is restrained to ``[ `Gherkin ]``, the single value variant only containing `` `Gherkin``
1. Using another annotation allows assigning the `` `Gherkin`` value to a type containing more tags.

This can be understood as an ordering relation between exact variants types. The type ``[ `Gherkin ]`` is smaller than the type  ``[ `Gherkin | `Avocado ]``. The types `` `[ `Gherkin ]`` and ``[ `Avocado ]`` do not compare. The type `` `[ `Gherkin ]`` is the smallest possible type for the tag`` `Gherkin``.

The order between the exact variants derives from the [partial order](https://en.wikipedia.org/wiki/Partially_ordered_set#Partial_order) on [subsets](https://en.wikipedia.org/wiki/Subset) of tags. The sets considered are the tags, with names and types. This order is said to be partial because some sets can't be compared. This order is called the _subtyping_ order.

The OCaml syntax does not allow to express the [empty](https://github.com/ocaml/ocaml/issues/10687) polymorphic variant type. If it was, it would be the least element in the subtyping order.

OCaml has a cast operator, it allows to raise the type of expression into any larger type in the subtyping order. It is writen `:>`
```ocaml
# (gherkin :> [ `Avocado | `Gherkin | `Tomato ]);;
- : [ `Avocado | `Gherkin | `Tomato ] = `Gherkin
```

It means the type of `gherkin` is raised from ``[ `Gherkin | `Tomato ]`` into ``[ `Avocado | `Gherkin | `Tomato ]``. It is admissible because ``[ `Gherkin | `Tomato ]`` is smaller than ``[ `Avocado | `Gherkin | `Tomato ]`` in the subtyping order.

## Named Polymorphic Variant Types

### Naming

Exact polymorphic variant types can be given names.
```ocaml
# type foo = [ `A | `B | `C ]
```

Names polymorphic variants are always exact.

### Type extension

Named polymorphic variants can be used to create extended types.
```ocaml
# type bar = [ foo | `D | `E ];;
```

### Dash Patterns

Named polymorphic variants can be used as patterns
```ocaml
# let f = function
    | #foo -> "foo"
    | `F -> "F";;
val f : [< `A | `B | `C | `F ] -> string = <fun>
```

This is not a dynamic type check. The `#foo` pattern is almost a macro, it is a shortcut to avoid writting all the patterns.

## Advanced: Aliased, Parametrized and Recursive Polymorphic Variants

### Inferred Type Aliases

```ocaml
# function `Tomato -> `Cilantro | plant -> plant;;
- : ([> `Cilantro | `Tomato ] as 'a) -> 'a = <fun>
```

This type means any exact variant type which is a super set of ``[> `Cilantro | `Tomato ]`` as domain, and the same type as codomain.

```ocaml
# let f = function `Fruit fruit -> fruit = "Broccoli" | `Broccoli -> true;;
val upcast : [< `Broccoli | `Fruit of string ] -> bool = <fun>

# let g = function `Fruit fruit -> fruit | `Broccoli -> true;;
val g : [< `Broccoli | `Fruit of bool ] -> bool = <fun>

 fun x -> f x && g x;;
- : [< `Broccoli | `Fruit of bool & string ] -> bool = <fun>
```

### Recursive Polymorphic Variants

The inferred type of a polymorphic variant may be recursive.
```ocaml
let rec map f = function
    | `Nil -> `Nil
    | `Cons (x, u) -> `Cons (f x, map f u);;
val map :
  ('a -> 'b) ->
  ([< `Cons of 'a * 'c | `Nil ] as 'c) -> ([> `Cons of 'b * 'd | `Nil ] as 'd) =
  <fun>
```

The aliasing mechanism is used to express type recursion.

### Conjunction 

From the language manual:
```ocaml
# let f1 = function `A x -> x = 1 | `B -> true | `C -> false
  let f2 = function `A x -> x = "a" | `B -> true ;;
val f1 : [< `A of int | `B | `C ] -> bool = <fun>
val f2 : [< `A of string | `B ] -> bool = <fun>

# let f x = f1 x && f2 x;;
val f : [< `A of string & int | `B ] -> bool = <fun>
```

FIXME: This is lame. It says no `` `A`` can't be applied to `f`. There is no way to find a value that is both a `string` and an `int`

TODO: Find a “positive” example and maybe move the manuals one in the drawbacks

## Advanced: Combining Polymorphic Variants and Simple Variants

A tag `` `A`` may be assumed to inhabit any type with additional tags, for instance `` `B`` or `` `C of string``. This summarized by the subtyping order where `` [ `A ]`` is smaller than ``` [ `A | `B ]``.

This can be checked be defining a function `upcast` the following way:
```ocaml
let upcast (x : [ `A ]) = (x :> [ `A | `B ]);;
val upcast : [ `A ] -> [ `A | `B ] = <fun>
```
This function is useless, but it illustrates a value of type ``[ `A ]`` can be casted into the type ``[ `A | `B ]``. Casting goes from subtype to supertype.

### Combining Nominal and Structural Polymorphism

A type may be polymorphic in both sense. It may have parametric polymorphism from nominal typing and variant polymorphism from structural typing.
```ocaml
# let maybe_map f = function
    | `Just x -> `Just (f x)
    | `Nothing -> `Nothing;;
val maybe_map :
  ('a -> 'b) -> [< `Just of 'a | `Nothing ] -> [> `Just of 'b | `Nothing ] =
  <fun>
```

### Predefined Simple Variants are Covariant

The subtyping order extends to simple variants. Functions `upcast_opt` `upcast_list` and `upcast_snd` are doing the same thing as `upcast` except they are taking values from simple types that contain a polymorphic variant.
```ocaml
# let upcast_opt (x : [ `A ] option) = (x :> [ `A | `B ] option);;
val upcast_opt : [ `A ] option -> [ `A | `B ] option = <fun>

# let upcast_list (x : [ `A ] list) = (x :> [ `A | `B ] list);;
val upcast_list : [ `A ] list -> [ `A | `B ] list = <fun>

let upcast_snd (x : [ `A ] * int) = (x :> [ `A | `B ] * int);;
val upcast_snd : [ `A ] * int -> [ `A | `B ] * int = <fun>
```

The product type and the types `option`, `list` are said to be _covariant_ because subtyping goes in the same direction from component type into container type.

### Function Codomains are Covariant

The function type is covariant on codomains.
```ocaml
# let upcast_dom (f : int -> [ `A ]) = (x :> int -> [ `A | `B ]);;
val f : (int -> [ `A ]) -> int -> [ `A | `B ] = <fun>
```

Adding tags to a polymorphic variant codomain of a function is harmless. Extending a function's codomain is pretending it is able to return something that never will. It is a false promise, and the precision of the type is reduced, but it is safe, no unexpected data will be returned by the function.

### Function Domains are Contravariant

The function type is _contravariant_ on codomains. Subtyping is reverted from component type into composite type (i.e. function arrow).
```ocaml
# let upcast_cod (f : [ `A | `B ] -> int) = (x :> [ `A ] -> int);;
val f : ([ `A | `B ] -> int) -> [ `A ] -> int = <fun>
```

At first, it may seem counter intuitive. However, removing tags from a polymorphic variant domain of a function is also harmless. Code in charge of the removed tags is turned into dead code. Implemented generality of the function is lost, but it is safe, no unexpected data will be passed to the function.

### Covariance and Contravariance at Work

```ocaml
# let ingredient = function 0 -> `Egg | 1 -> `Sugar | _ -> `Fish;;
val ingredient : int -> [> `Egg | `Fish | `Sugar ] = <fun>

# let chef = function `Egg -> `Omelette | `Sugar -> `Caramel | `Fish -> `Stew;;
val chef : [< `Egg | `Fish | `Sugar ] -> [> `Caramel | `Omelette | `Stew ] =
  <fun>

# let taste = function `Omelette -> "Nutritious" | `Caramel -> "Sweet" | `Stew -> "Yummy";;
val taste : [< `Caramel | `Omelette | `Stew ] -> string = <fun>

# let le_chef = function `Egg -> `Stew | `Sugar -> `Stew | `Fish -> `Stew | `Leftover -> `Stew;;
val le_chef : [< `Egg | `Fish | `Leftover | `Sugar ] -> [> `Stew ] = <fun>

# fun n -> n |> ingredient |> chef |> taste;;
- : int -> string = <fun>

# fun n -> n |> ingredient |> le_chef |> taste;;
- : int -> string = <fun>

# let upcasted_chef = (chef :> [< `Egg | `Fish | `Leftover | `Sugar ] -> [> `Stew ]);;
```

The type of function `le_chef` is a supertype of the type of the function `chef`. It is possible to upcast `chef` into `le_chef`'s type.

## Uses-Cases

### Variants Witout Declaration

Not having to explicitly declare polymorphic variant types is beneficial in several cases
- When few functions are using the type
- When many types would have to be declared (see also next use case)

When reading a pattern-matching expression using polymorphic variant tags, understanding is local. There is no need to search for the meaning of the tags somewhere else. The meaning arises from the expression itself.

### Shared Constructors

When several simple variants are using the same constructor name, shadowing takes place. Only the last entered in the environment is accessible, previously entered one are shadowed. This can be worked around usng modules.

This never happens with polymorphic variants. When a tag appears several times in an expression, it must be with the same type, that's the only restriction. This makes polymorphic variants very handy when dealing with multiple sum types and constructors with same types occuring in several variants.

### Datatype Sharing Between Modules

Using the same type in two different module can be done in several ways:
- Have dependency, either direct or shared
- Turn the modules into functors and inject the shared type as a parameter

Polymorphic variant provides an additional alternative.

> You just define the same type in both libraries, and since these are only type
abbreviations, the two definitions are compatible. The type system checks the
structural equality when you pass a value from one library to the other.

Jacques Garrigue

### Error Handling using The `result` Type

The [Error Handling](/docs/error-handling) guide details how errors can be handled in OCaml. Among various mechanisms, the `result` type, when used as a monad, provides powerful mean to handle errors. Refer to the guide and documentation on this type to learn how to use it. In this section we discuss why using polymorphic variants to carry error values can be beneficial.

Let's consider this code:
```ocaml
# let f_exn m n = List.init m Fun.id |> List.map (fun n -> n * n) |> Fun.flip n;;
    List.nth u n;;
```

The following is an attempt at translating this into `result` values, using the `Result.bind` instead of `|>`:
```ocaml
# type init_error = Negative_length;;

# let init n f = try Ok (List.init n f) with
    | Invalid_argument _ -> Error Negative_length;;

# type nth_error = Too_short of int * int | Negative_index of int;;
type nth_error = Too_short of int * int | Negative_index of int

# let nth u i = try Ok (List.nth u i) with
    | Invalid_argument _ -> Error (Negative_index i)
    | Failure _ -> Error (Too_short (List.length u, i))

# let f_res m n =
    let* u = init m Fun.id in
    let u = List.map (fun n -> n * n) u in
    let* x = nth u n in
    Ok x;;
Error: This expression has type (int, nth_error) result
       but an expression was expected of type (int, init_error) result
       Type nth_error is not compatible with type init_error
```
This does not work because of the type of `Result.bind`.
```ocaml
# Result.bind;;
- : ('a, 'e) result -> ('a -> ('b, 'e) result) -> ('b, 'e) result = <fun>
```
The `'e` type has to be same, while this code needs it to change throughout the pipe.

And an equivalent version using polymorphic variants works:
```ocaml
# let init n f = try Ok (List.init n f) with
    | Invalid_argument _ -> Error `Negative_length;;

# let nth u i = try Ok (List.nth u i) with
    | Invalid_argument _ -> Error (`Negative_index i)
    | Failure _ -> Error (`Too_short (List.length u, i));;

# let f_res m n =
    let* u = init m Fun.id in
    let u = List.map (fun n -> n * n) u in
    let* x = nth u n in
    Ok x;;
```
Using polymorphic variant, the type-checker generates a unique type for all the pipe. The constraints coming from calling `init` are merged ``

## When to Use Polymorphic Variant

TODO: rewrite this, move it somewhere else

The YAGNI (You Aren't Gonna Need It) principle can be applied to polymorphic variants. Unless the code is arguably improved by having several pattern matching over different types sharing the same tag, polymorphic variants are probably not needed.

## Drawbacks

### Hard to Read Type Expressions

By default, polymorphic variant types aren't declared with a name before being used. The compiler will generate type expression corresponding to each function dealing with polymorphic variants. Some of those types are hard to read. When several such functions are composed together, infered types can become very large and difficult to understand.
```ocaml
# let rec fold_left f y = function `Nil -> y | `Cons (x, u) -> fold_left f (f x y) u;;
val fold_left :
  ('a -> 'b -> 'b) -> 'b -> ([< `Cons of 'a * 'c | `Nil ] as 'c) -> 'b = <fun>
```

### Overconstrained Types

In some circumstances, combining sets of contraints will artificially reduce the domain of a functioon. This happens when conjuction of contraints must be taken.
```ocaml
# f;;
- : [< `Broccoli | `Fruit of string ] -> string = <fun>

# g;;
- : [< `Broccoli | `Edible of string ] -> string = <fun>

# let u = [f; g];;
u : ([< `Broccoli ] -> string) list = [<fun>; <fun>]

# f (`Fruit "Pitaya");;
- : string = "Pitaya"

# (List.hd u) (`Fruit "Pitaya");;
Error: This expression has type [> `Fruit of string ]
       but an expression was expected of type [< `Broccoli ]
       The second variant type does not allow tag(s) `Fruit
```

Function `f` accepts tags `` `Broccoli`` and `` `Fruit`` whilst `g` accepts `` `Broccoli`` and `` `Edible``. But if `f` and `g` are stored in a list, they must have the same type. That forces their domain to be restricted to a common subtype. Although `f` is able to handle the tag `` `Fruit``, type-checking no longer accepts that application when `f` is extracted from the list.

### Empty Tags

TODO: import from conjunction types

### Weaken Type-Checking and Harder Debugging

See RWO color example and `` `Gray` vs `` `Grey` issue.

### Lack of Explicit Row Variables

```ocaml
# let f = function `Bla -> `Bli | x -> x;;
val f : ([> `Bla | `Bli ] as 'a) -> 'a = <fun>
```

Because of the `x -> x` pattern the types infered as domain and codomain are the same, this is expressed by the aliasing `as 'a`. As `` `Bla`` must be part of the domain and `` `Bli`` must be part of the codomain, they both end up being part of the common type. A finer type-checker would infer more precise types. Type-checking is an approximation and a trade-off, some valid program are rejected, some types are too coarse.

### Performances

> There is one more downside: the runtime cost. A value Pair (x,y) occupies 3 words in memory, while a value `Pair (x,y) occupies 6 words.

Guillaume Melquiond

## Conclusion

Although polymorphic variant share a lot with simple variants, they are substancially different. This comes from the structural type-checking algorithm used for polymorphic variants
- Type declaration is optional
- A type is a set of constraints over values
- The relationship between value and type is satisfies rather than inhabits
- There is a subtyping relation between types

Polymorphic variant should not be considered as an improvement over simple variants. In some regards, they are more flexible and lightweight, but they also have harder to read types and slightly weaker type-checking assurances. Choosing when to prefer polymorphic variants over simple variants is a subtle decision to make. It is safe to prefer simple variants as the default and go for polymorphic variant when there is a solid case for them.

It is important to be comfortable with polymorphic variants, many projects are using them. Most often, only a fraction of their expressive strength is used. However, refactoring code using them requires being able to understand more than what's actually used. Otherwise, one may quickly end-up stalled by indecipherable type error messages.

## References

- https://blog.shaynefletcher.org/2017/03/polymorphic-variants-subtyping-and.html
- https://caml.inria.fr/pub/papers/garrigue-polymorphic_variants-ml98.pdf
- https://v2.ocaml.org/releases/5.1/htmlman/polyvariant.html
- https://dev.realworldocaml.org/variants.html#scrollNav-4
- https://discuss.ocaml.org/t/empty-polymorphic-variant-type
- https://discuss.ocaml.org/t/inferred-types-and-polymorphic-variants
- http://gallium.inria.fr/~fpottier/publis/emlti-final.pdf
- https://keleshev.com/composable-error-handling-in-ocaml