---
id: polymorphic-variants
title: Polymorphic Variants
description: |
  Everything you always wanted to know about polymorphic variants but were afraid to ask
category: "Language"
---

# Polymorphic Variants

## Introduction

This tutorial teaches you how to use polymorphic variants. This includes starting using them, maintaining a project already using them, deciding when to use them or not, and balancing their unique benefits against their drawbacks.

Product types and data types such as `option` and `list` are variants and polymorphic. In this tutorial, they are called _simple variants_ to distinguish them from the _polymorphic variants_ presented here. Simple variants and polymorphic variants are close siblings. Their values are both introduced using labels that may carry data. Both can be recursive and have type parameters. By the way, don't trust ChatGPT if it tells you polymorphic variants are dynamically type checked; it is hallucinating. Like simple variants, polymorphic variants are type checked statically.

However, they are type checked using different algorithms, which result in a different programming experience. The relationship between value and type (written with the colon symbol `:`) is changed with polymorphic variants. Usually, values are thought of as inhabitants of the type, which is regarded as a set-like thing. Rather, polymorphic variant values should be considered as pieces of data that several functions can accept. Polymorphic variants types are a way to express compatibility relationship between those functions. The approach in this tutorial is to build sense from experience using features of polymorphic variants.

**Prerequisites**: This is intermediate level tutorial. It is required is to have completed tutorials on [Functions and Values](/docs/functions-and-values), [Basic Data Types](/docs/basic-data-types), and [Lists](/docs/lists) to begin this one.

### Origin and Context

Polymorphic variants originate from Jacques Garrigue's work on Objective Label, which was [first published in 1996](https://caml.inria.fr/pub/old_caml_site/caml-list-ar/0533.html). It became part of standard Objective Caml with [release 3.0](https://caml.inria.fr/distrib/ocaml-3.00/) in 2000, along with labelled and optional function arguments. They were introduced to give more precise types in LablTk.

The core type system of OCaml follows a [_nominal_](https://en.wikipedia.org/wiki/Nominal_type_system) discipline. Variants must be explicitly declared before being used. The typing discipline used for polymorphic variants and classes is different, as it is [_structural_](https://en.wikipedia.org/wiki/Structural_type_system).

In the nominal approach of typing, types are first defined; later, when type checking an expression, three outcomes are possible:
1. If a matching type is found, it becomes the inferred type.
1. If any type can be applied, a type variable is created.
1. If typing inconsistencies are found, an error is raised.

This is very similar to solving an equation in mathematics. Equations accept either zero, exactly one, several, or infinitely many numbers as solutions. Nominal type checking finds that either zero, exactly one, or any type can be used in an expression.

In the structural approach of typing, type definitions are optional, so they can be omitted. Type checking an expression constructs a data structure that represents the types that are compatible with it. These data structures are displayed as type expressions sharing resemblance with simple variants.

<!--
### Learning Goals

The goal of this tutorial is to make the reader acquire the following capabilities:
- Write polymorphic variant using code, from scratch, using mainstream features
- Maintain existing code that is using polymorphic variants
- Sort out polymorphic variant types and errors
  - Add type annotation needed to resolve polymorphic variant type-checking issues
  - Add or remove catch all patterns in polymorphic variant pattern matching
  - Insert or remove type casts
- Refactor between simple and polymorphic variants
- Choose to use polymorphic variant when really needed
-->

### A Note on Simple Variants and Polymorphism

The type expression `'a list` does not designate a single type; it designates a family of types, basically all the types that can be created by substituting an actual type to type variable `'a`. The type expressions `int list`, `bool option list`, or `(float -> float) list list` are real types. They're actual members of the family `'a list`. Types are intended to have inhabitants, type families don't. The identifiers `list`, `option`, and others are type operators. Just like functions, they take parameters. Although these parameters are not values, they are types. Their results aren't values but types, too. Therefore, simple variants are polymorphic, but not in the same sense as polymorphic variants.
- Simple variants have [parametric polymorphism](https://en.wikipedia.org/wiki/Parametric_polymorphism)
- Polymorphic variants have a form of [structural polymorphism](https://en.wikipedia.org/wiki/Structural_type_system)

## A First Example

### Creating Polymorphic Variant Types From Pattern Matching

Polymorphic variant visual signature are back quotes. Pattern matching on them looks just the same as with simple variants, except for back quotes (and capitals, which are no longer required).
```ocaml
# let f = function `Broccoli -> "Broccoli" | `Fruit name -> name;;
val f : [< `Broccoli | `Fruit of string ] -> string = <fun>
```

Here`` `Broccoli`` and`` `Fruit`` play a role similar to the one played by the constructors `Broccoli` and `Fruit` in a variant declared as `type t = Broccoli | Fruit of string`. Except, and most importantly, that the definition doesn't need to be written. The tokens`` `Broccoli`` and `` `Fruit`` are called _tags_ instead of constructors. A tag is defined by a name and a list of parameter types.

The expression ``[< `Broccoli | `Fruit of string ]`` play the role of a type. However, it does not represent a single type, it represents three different types.
- The type that only has`` `Broccoli`` as inhabitant, its translation into a simple variant is `type t0 = Broccoli`
- The type that only has`` `Fruit`` as inhabitant, its translation into a simple variant is `type t1 = Fruit of string`
- Type type that has both`` `Broccoli`` and`` `Fruit`` inhabitants, its translation into a simple variant is `type t2 = Broccoli | Fruit of string`

Note each of the above translations into simple variants is correct. However, entering them as-is into the environment would lead to constructor shadowing (unless type annotation is used at pattern or expression level, see section on [Shared Constructors](#Shared-Constructors)).

This also illustrates the other striking feature of polymorphic variants: values can be attached to several types. For instance, the tag `` `Broccoli`` inhabits ``[ `Broccoli ]`` and``[ `Broccoli | `Fruit of String ]``, but it also inhabits any type that contains it.

What is displayed by the type-checker, for instance ``[< `Broccoli | `Fruit of string ]``, isn't a single type. It is a type expression that designates a constrained set of types. For instance, all types defined by a group of tags that contains either`` `Broccoli`` or `` `Fruit of string`` and nothing more. This is the meaning of the `<` sign in this type expression. This a bit similar to what happens with `'a list`, which isn't a single type either, but a type expression that designates the set of `list` types of something, i.e. the set of types where `'a` has been replaced by some other type. It is also meant to indicate that the exact types are subsets of the indicated ones (this will be explained in the section on (Subtyping)[#Subtyping-of-Polymorphic-Variants]).

This is the sense of the polymorphism of polymorphic variants. Polymorphic variants types are type expressions. The structural typing algorithm used for polymorphic variants creates type expressions that designate sets of types (here the three types above), which are defined by constraints on sets of tags (the inequality symbols). The polymorphism of polymorphic variant is different.

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

Both `f` and `g` accepts the`` `Broccoli`` tag as input because they both have code for it. They do not have the same domain because `f` also accepts `` `Fruit of string`` whilst `g` also accepts `` `Edible of string``. The types of the domains of `f` and `g` expresses this. The tag `` `Broccoli`` satisfies the both the constraints of the domain of `f`: ``[< `Broccoli | `Fruit of string ]`` and the constraints of the domain of `g`: ``[< `Broccoli | `Fruit of string ]``. That type is ``[ `Broccoli ]``. The same way tag defined values belong to several types, tag accepting functions belong to several types too.

Polymorphic variants tags are meant to be use as stand-alone values, wherever it makes sense. As long as used consistently, with a single implicit type per tag, the type checker will accept any combination of them.

The same way tag defined values belong to several types, tag accepting functions belong to several types too.

### Static Type Checking

Type checking of polymorphic variants is static. No information on tag's types is available at runtime.
```ocaml
# [ `Fruit "Banana"; `Fruit true ];;
Error: This expression has type bool but an expression was expected of type
         string
```
When a tag is used inconsistently, the type checker will raise an error.

### Merging Constraints

When building expression from sub expressions, the type-check assembles types from sub expressions to create the type of the whole expression. This is why the type discipline used for polymorphic variants is said to be structural, it follows the structure of the expressions.
```ocaml
# let brocco = `Broccoli;;

# let pepe = `Peperone;;

# [ brocco; pepe; brocco ];;
- : [> `Broccoli | `Peperone ] list = [`Broccoli; `Peperone; `Broccoli]
```

## Exact, Closed and Open Variants

Polymorphic variant type expressions can have three forms:
1. Exact: ``[ `Broccoli | `Gherkin | `Fruit of string ]`` : this only designates the type inhabited by the values introduced by these tags.
1. Closed: ``[< `Broccoli | `Gherkin | `Fruit of string ]`` : this designates a set of exact types. Each exact type is inhabited by the values introduced by a subset of the tags from 1. For instance, there are 7 exact types as such:
  - ``[ `Broccoli ]``
  - ``[ `Gherkin ]``
  - ``[ `Fruit of string ]``
  - ``[ `Gherkin | `Fruit of string ]``
  - ``[ `Broccoli | `Fruit of string ]``
  - ``[ `Broccoli | `Gherkin ]``
  - ``[ `Broccoli | `Gherkin | `Fruit of string ]``
1. Open: ``[> `Broccoli | `Gherkin | `Fruit of string ]`` : this designates a set of exact types. Each exact type is inhabited by the values introduced by supersets of the tags from 1.

Tip: To distinguish closed and open type expression, you can remember that the less-than sign `<` is oriented the same way as a capital `C` letter, as in closed.

The exact form is inferred by the type-checker when naming a type defined by a set of tags:
```ocaml
# type t = [ `Broccoli | `Gherkin | `Fruit of string ]
type t = [ `Broccoli | `Fruit of string | `Gherkin ]
```

Exact variants correspond closely to simple variants.

The closed form is introduced when performing pattern matching over a explicit set of tags
```ocaml
# let f = function
    | `Broccoli -> "Broccoli"
    | `Gherkin -> "Gherkin"
    | `Fruit Fruit -> Fruit;;
val upcast : [< `Broccoli | `Fruit of string | `Gherkin ] -> string = <fun>
```

The function `f` can be used with any exact type which has these three tags or less. When applied to a type with less tags, branches associated to removed tags turn safely into dead code. The type is closed because the function can't accept more than what is listed.

The open form can be introduced in two different ways.

Open polymorphic variants appear when using a catch-all pattern, either the underscore `_` symbol or a variable:
```ocaml
# let g = function
    | `Broccoli -> "Broccoli"
    | `Gherkin -> "Gherkin"
    | `Fruit Fruit -> Fruit
    | _ -> "Edible plant";;
val g : [> `Broccoli | `Fruit of string | `Gherkin ] -> string = <fun>
```

The function `g` can be used with any exact type which has these three tags or more. Because of the catch all pattern, if `g` is passed a value introduced by a tag which is not part of the list, it will be accepted, and `"Edible plant"` is returned. The type is open because it can accept more than what is listed in its expression.

The type of `g` is also meant to disallow exact types with tags removed or changed in type. OCaml is a statically typed language, that means no type information is available at runtime. As a consequence pattern matching only relies on tag names. If `g` was given a type with removed tags, such as``[> `Broccoli | `Gherkin ]``, then passing`` `Fruit`` to `g` would be allowed, but since dispatch is based on names, it would execute the`` `Fruit of string`` branch and crash because no string is available. Therefore, open polymorphic variant must include all the tags from pattern matching.

Open polymorphic variants also appear when type checking tags as values.
```ocaml
# `Gherkin
- : [> `Gherkin ] = `Gherkin

# [ `Broccoli; `Gherkin; `Broccoli ];;
- : [> `Broccoli | `Gherkin ] list = [ `Broccoli; `Gherkin; `Broccoli ]
```

Binding a tag to the open polymorphic variant type which only contains enables:
- Using it all the contexts where applicable code is available
- Avoid using it in contexts that can't deal with it
- Building sum of polymorphic variants, this is shown in the second example.

This also applies to function returning polymorphic variant values.
```ocaml
# let f b = if b then `Up else `Down;;
val f : bool -> [> `Down | `Up ] = <fun>
```

The codomain of `f` is the open type ``[> `Down | `Up ]``. This make sense when having a look at function composition.
```ocaml
# let g = function
    | `Up -> 1
    | `Down -> 2
    | `Broken -> 3;;

# fun x -> x |> f |> g;;
- : bool -> int = <fun>
```

Functions `g` and `f` can be composed because `g` accepts more than what `f` can return. The value `` `Broken`` will never pass in the `f |> g` pipe, but it safe to write it as no unexpected value can make its way through.

Closed and open cases are polymorphic because they do not designate a single type but families of types. An exact variant type is monomorphic, it corresponds to a single variant type, not a set of variant types.

### Both Open and Closed Polymorphic Variant

A closed variant type may also have an additional constraint preventing some tags to be removed.
```ocaml
# let is_red = function `Clubs -> false | `Diamonds -> true | `Hearts -> true | `Spades -> false;;
val is_red : [< `Clubs | `Diamonds | `Hearts | `Spades ] -> bool = <fun>

# let h = fun u -> List.map is_red (`Hearts :: u);;
val h : [< `Clubs | `Diamonds | `Hearts | `Spades > `Hearts ] list -> bool list = <fun>
```

Function `is_red` only accepts values from any subtype of ``[< `Clubs | `Diamonds | `Hearts | `Spades ]``. However, function `h` excludes the exact types ``[ `Clubs ]``, ``[ `Diamonds ]`` and ``[ `Spades ]``. Since the list passed to `List.map` includes a `` `Hearts`` tags, types which do no include it are not allowed. The domain of `h` is closed by ``[ `Clubs | `Diamonds | `Hearts | `Spades ]`` and open by ``[ `Hearts ]``.

## Subtyping of Polymorphic Variants

Simple variants have a form of polymorphism called _parametric polymorphism_. Together with predefined types, they are type checked using the nominal typing discipline. In this discipline a value has a unique type.

In the structural type-checking discipline used for polymorphic variants, a value may have several types. Equivalently it can be said to inhabit several types:
```ocaml
# let gherkin = `Gherkin;;
val Gherkin : [> `Gherkin ] = `Gherkin

# let (gherkin : [ `Gherkin ]) = `Gherkin;;
val Gherkin : [ `Gherkin ] = `Gherkin

# let (gherkin : [ `Gherkin | `Avocado ]) = `Gherkin;;
val Gherkin : [ `Gherkin | `Avocado ] = `Gherkin
```

1. By default, the type assigned to the `` `Gherkin`` tag is ``[> `Gherkin]``. It means: any variant type which includes that tag.
1. Using an annotation, the type can be restrained to ``[ `Gherkin ]``, the exact variant type only containing `` `Gherkin``
1. Using another annotation allows assigning the `` `Gherkin`` value to a type containing more tags.

This entails an ordering relation between exact variants types. The type ``[ `Gherkin ]`` is smaller than the type  ``[ `Gherkin | `Avocado ]``. The types `` `[ `Gherkin ]`` and ``[ `Avocado ]`` do not compare. The type `` `[ `Gherkin ]`` is the smallest possible type for the tag`` `Gherkin``.

The order between the exact variants derives from the [partial order](https://en.wikipedia.org/wiki/Partially_ordered_set#Partial_order) on [subsets](https://en.wikipedia.org/wiki/Subset) of tags. The sets considered are the tags, with names and types. This order is said to be partial because some sets can't be compared. This order is called the _subtyping_ order.

The OCaml syntax does not allow to express the [empty](https://github.com/ocaml/ocaml/issues/10687) polymorphic variant type. If it was, it would be the least element in the subtyping order.

OCaml has a cast operator, it allows to raise the type of an expression into any larger type, with respect to the subtyping order. It is written `:>`
```ocaml
# (gherkin :> [ `Avocado | `Gherkin | `Tomato ]);;
- : [ `Avocado | `Gherkin | `Tomato ] = `Gherkin
```

It means the type of `gherkin` is raised from ``[ `Gherkin | `Tomato ]`` into ``[ `Avocado | `Gherkin | `Tomato ]``. It is admissible because ``[ `Gherkin | `Tomato ]`` is smaller than ``[ `Avocado | `Gherkin | `Tomato ]`` in the subtyping order.

When casting, it is also possible to indicate the subtype from which the value is up cast.
```ocaml
# (gherkin : [ `Gherkin | `Tomato ] :> [ `Avocado | `Gherkin | `Tomato ]);;
- : [ `Avocado | `Gherkin | `Tomato ] = `Gherkin
```

## Named Polymorphic Variant Types

### Naming

Exact polymorphic variant types can be given names.
```ocaml
# type exotic = [ `Guayaba | `Maracuya | `Papaya ];;
```

Named polymorphic variants are always exact, thus they are equivalent to simple variants. It is not possible to give names to closed or open type constraints.

### Type extension

Named polymorphic variants can be used to create extended types.
```ocaml
# type mexican = [ exotic | `Pitahaya | `Sapodilla ];;
type mexican = [ `Guayaba | `Maracuya | `Papaya | `Pitahaya | `Sapodilla ]
```

### Hash Patterns

Named polymorphic variants can be used as patterns.
```ocaml
# let f = function
    | #exotic -> "Exotic Fruit"
    | `Mango -> "Mango";;
val f : [< `Guayaba | `Mango | `Maracuya | `Papaya ] -> string = <fun>
```

This is not a dynamic type check. The `#exotic` pattern acts like a macro, it is a shortcut to avoid writing all the corresponding patterns.

## Advanced: Aliased, Parametrized and Recursive Polymorphic Variants

### Inferred Type Aliases

```ocaml
# function `Avocado -> `Cilantro | plant -> plant;;
- : ([> `Cilantro | `Avocado ] as 'a) -> 'a = <fun>
```

The meaning of the type of this function is twofold.
1. Any exact variant type which is a super set of ``[> `Cilantro | `Avocado ]`` is a domain
2. The very same type is also a codomain

The meaning of `'a` is not exactly the same a with simple variants. It is not a placeholder meant to be replaced by another type. The `as 'a` part in the type expression ``[> `Cilantro | `Avocado ] as 'a`` means ``[> `Cilantro | `Avocado ]`` is assigned the local name `'a` in the overall expression. It allows the same exact variant type will be used as both domain and codomain. This is a consequence of the `plant -> plant` clause that forces domain and codomain types to be the same.

### Parametrized Polymorphic Variants

It is possible combine polymorphic variants and parametric polymorphism. Here is a duplication of the `'a option` type, translated as polymorphic variant parametrized with a type variable.
```ocaml
# let map f = function
    | `Some x -> `Some (f x)
    | `None -> `None;;
val map : ('a -> 'b) -> [< `None | `Some of 'a ] -> [> `None | `Some of 'b ] =
  <fun>
```

This `map` function has two type parameters : `'a` and `'b`. They are used to type its `f` parameter.

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

The aliasing mechanism is used to express type recursion. In the type expression ``[< `Cons of 'a * 'c | `Nil ] as 'c``, the defined name `'c` occurs inside body of the definition ``[< `Cons of 'a * 'c | `Nil ]``. Therefore, it is a recursive type definition.

### Conjunction of constraints

FIXME: This shows impossible to satisfy constraints can appear. Could we show a conjunction of constraint that can be satisfied first? Otherwise, it needs to be moved to drawbacks.

```ocaml
# let foo = function `Night x -> x = 1 | `Day -> true | `Eclipse -> false
  let bar = function `Night x -> x | `Day -> true;;
val foo : [< `Day | `Eclipse  | `Night of int] -> bool = <fun>
val bar : [< `Day | `Night of bool | ] -> bool = <fun>

# let both x = foo x && bar x;;
val both : [< `Night of string & int | `Day ] -> bool = <fun>
```

## Advanced: Combined Subtyping of Polymorphic and Simple Variants

A tag `` `Night`` inhabits any type with additional tags, for instance ``[ `Night | `Day ]`` or ``[`Morning | `Afternoon | `Evening | `Night]``. This summarized by the subtyping order where `` [ `Night ]`` is smaller to both ``[ `Night | `Day ]`` and ``[`Morning | `Afternoon | `Evening | `Night ]``.

This can be checked be defining a function `upcast` the following way:
```ocaml
let upcast (x : [ `Night ]) = (x :> [ `Night | `Day ]);;
val upcast : [ `Night ] -> [ `Night | `Day ] = <fun>
```
This function is an identity function it returns its parameter unchanged. It illustrates a value of type ``[ `Night ]`` can be cast into the type ``[ `Night | `Day ]``. Casting goes from subtype to supertype.

### Predefined Simple Variants are Covariant

The subtyping order extends to simple variants. Functions `upcast_opt` `upcast_list` and `upcast_snd` are doing the same thing as `upcast` except they are taking parameters from simple types that contain a polymorphic variant value.
```ocaml
# let upcast_opt (x : [ `Night ] option) = (x :> [ `Night | `Day ] option);;
val upcast_opt : [ `Night ] option -> [ `Night | `Day ] option = <fun>

# let upcast_list (x : [ `Night ] list) = (x :> [ `Night | `Day ] list);;
val upcast_list : [ `Night ] list -> [ `Night | `Day ] list = <fun>

let upcast_snd (x : [ `Night ] * int) = (x :> [ `Night | `Day ] * int);;
val upcast_snd : [ `Night ] * int -> [ `Night | `Day ] * int = <fun>
```

The product type and the types `option`, `list` are said to be _covariant_ because subtyping goes in the same direction from component type into container type. Note that these types are covariant because of the way their types parameters appear in the type of their constructors. This is detailed in [Chapter 11, Section 8.1](https://v2.ocaml.org/manual/typedecl.html#ss:typedefs) of the OCaml Manual. This has nothing to do with being predefined types.

### Function Codomains are Covariant

The function type is covariant on codomains. Casting a function is allowed if the target codomain is larger. Subtyping between the codomain type and the function type are going in the same direction.
```ocaml
# let upcast_dom (f : int -> [ `Night ]) = (x :> int -> [ `Night | `Day ]);;
val f : (int -> [ `Night ]) -> int -> [ `Night | `Day ] = <fun>
```

Adding tags to a polymorphic variant codomain of a function is harmless. Extending a function's codomain is pretending it is able to return something that will never be returned. It is a false promise, and the precision of the type is reduced, but it is safe, no unexpected data will ever be returned by the function.

### Function Domains are Contravariant

The function type is _contravariant_ on domains. Casting a function is allowed if the target domain is smaller. Subtyping between the domain type and the function type are going in opposite direction.
```ocaml
# let upcast_cod (f : [ `Night | `Day ] -> int) = (x :> [ `Night ] -> int);;
val f : ([ `Night | `Day ] -> int) -> [ `Night ] -> int = <fun>
```

At first, it may seem counter intuitive. However, removing tags from a polymorphic variant domain of a function is also harmless. Code in charge of the removed tags is turned into dead paths. Implemented generality of the function is lost, but it is safe, no data will be passed that the function can't handle.

### Covariance and Contravariance at Work

```ocaml
# let ingredient = function 0 -> `Flour | _ -> `Masa;;
val ingredient : int -> [> `Masa | `Flour ] = <fun>

# let chef = function
    | `Flour -> `Bread
    | `Egg -> `Tortilla
    | `Masa -> `Tortilla;;
val chef : [< `Masa | `Flour | `Egg ] -> [> `Bread | `Tortilla ] =
  <fun>

# let taste = function `Tortilla | `Bread -> "Nutritious" | `Cake -> "Yummy";;
val taste : [< `Bread | `Tortilla | `Cake ] -> string = <fun>

# fun n -> n |> ingredient |> chef |> taste;;
- : int -> string = <fun>

# let upcasted_chef =
    (chef :> [< `Flour | `Masa ] -> [> `Bread | `Tortilla | `Cake ]);;
val upcasted_chef : [< `Flour | `Masa ] -> [> `Bread | `Tortilla | `Cake ] =
  <fun>

# fun n -> n |> ingredient |> upcasted_chef |> taste;;
- : int -> string = <fun>
```

The type of `chef` is a subtype of the type of `upcasted_chef`. The function `upcasted_chef` has a reduced domain and enlarged codomain. However, `upcasted_chef` has a domain that remains larger than the codomain of `ingredient` and, a codomain that remains smaller than the domain of `taste`. Therefore, it is safely possible to consider `chef` has an inhabitant of the type of `upcasted_chef` in the composition pipe where it is used.

It is also possible to refactor `chef` into a new function that will can be used safely at the same place.
```ocaml
# let refactored_chef = function
    | `Flour -> `Bread
    | `Masa -> (`Tortilla : [> `Bread | `Tortilla | `Cake ]);;

# fun n -> n |> ingredient |> refactored_chef |> taste;;
- : int -> string = <fun>
```

## Uses-Cases

### Variants Without Declaration

Not having to explicitly declare polymorphic variant types is beneficial in several cases.
- When few functions are using the type
- When many types would have to be declared

When reading a pattern-matching expression using a polymorphic variant tags, understanding is local. Since polymorphic variant types are anonymous or aliases, there is no need to search for the meaning of the tags somewhere else. The meaning arises from the expression itself.

### Shared Constructors

When several simple variants are using the same constructor name, shadowing takes place. To pattern match over a shadowed variant, type annotation must be added, either to the whole pattern matching expression or to some patterns.
```ocaml
# type a = A;;
type a = A
# type b = A;;
type b = A
# function A -> true;;
- : b -> bool = <fun>
# function (A : a) -> true;;
- : a -> bool = <fun>
# (function A -> true : a -> bool);;
- : a -> bool = <fun>
```

Without this previously entered one are not longer reachable. This can be worked around using modules. This is well explained Real World OCaml (FIXME: this exact section and add link).

This problem never happens with polymorphic variants. When a tag appears several times in an expression, it must be with the same type, that's the only restriction. This makes polymorphic variants very handy when dealing with multiple sum types and constructors with same types occurring in several variants.

### Data Type Sharing Between Modules

Using the same type in two different module can be done in several ways:
- Having a dependency, either direct or shared
- Turn the dependent module into a functor and inject the dependence as a parameter

Polymorphic variant provides an additional alternative. This was proposed by Jacques Garrigue his seminal paper “Programming with Polymorphic Variants” (ACM SIGPLAN Workshop on ML, October 1998):
> You [...] define the same [polymorphic variant] type in both [modules], and since these are only type abbreviations, the two definitions are compatible. The type system checks the structural equality when you pass a value from one [module] to the other.

### Error Handling Using The `result` Type

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
Using polymorphic variant, the type-checker generates a unique type for all the pipe. The constraints coming from calling `init` are merged into a single type.

## Drawbacks

### Hard to Read Type Expressions

By default, polymorphic variant types aren't declared with a name before being used. The compiler will generate type expression corresponding to each function dealing with polymorphic variants. Some of those types are hard to read. When several such functions are composed together, inferred types can become very large and difficult to understand.
```ocaml
# let rec fold_left f y = function `Nil -> y | `Cons (x, u) -> fold_left f (f x y) u;;
val fold_left :
  ('a -> 'b -> 'b) -> 'b -> ([< `Cons of 'a * 'c | `Nil ] as 'c) -> 'b = <fun>
```

### Over Constrained Types

In some circumstances, combining sets of constraints will artificially reduce the domain of a function. This happens when conjunction of constraints must be taken. Functions `f` and `g` used here are those defined in the [first section](#a-first-example).
```ocaml
# f;;
- : [< `Broccoli | `Fruit of string ] -> string = <fun>

# g;;
- : [< `Broccoli | `Edible of string ] -> string = <fun>

# let u = [f; g];;
u : ([< `Broccoli ] -> string) list = [<fun>; <fun>]

# f (`Fruit "Pitahaya");;
- : string = "Pitahaya"

# (List.hd u) (`Fruit "Pitahaya");;
Error: This expression has type [> `Fruit of string ]
       but an expression was expected of type [< `Broccoli ]
       The second variant type does not allow tag(s) `Fruit
```

Function `f` accepts tags `` `Broccoli`` and `` `Fruit`` whilst `g` accepts `` `Broccoli`` and `` `Edible``. But if `f` and `g` are stored in a list, they must have the same type. That forces their domain to be restricted to a common subtype. Although `f` is able to handle the tag `` `Fruit``, type checking no longer accepts that application when `f` is extracted from the list.

### Weaken Type-Checking and Harder Debugging

This is adapted from the section [Example: Terminal Colors Redux](https://dev.realworldocaml.org/variants.html#scrollNav-4-2) from the “Real World OCaml” book written by Yaron Minsky and Anil Madhavapeddy.

Tags are used to store color representations:
* `` `RGB`` contains a [red, green and blue](https://en.wikipedia.org/wiki/RGB_color_model) triplet
* `` `Gray`` contains a [grayscale](https://en.wikipedia.org/wiki/Grayscale) value
* `` `RGBA`` contains a [red, green, blue, alpha](https://en.wikipedia.org/wiki/RGBA_color_model) quadruplet

The polymorphic variant type `color` groups the targs `` `RGB`` and `` `Gray`` whilst the type `extended_color` has the three tags by extending `color` with `` `RGBA``. Functions are defined to convert colors into integers.
```ocaml
# type color = [ `Gray of int | `RGB of int * int * int ];;
type color = [ `Gray of int | `RGB of int * int * int ]

# type extended_color = [ color | `RGBA of int * int * int * int ];;
type extended_color =
    [ `Gray of int | `RGB of int * int * int | `RGBA of int * int * int * int ]

# let color_to_int = function
  | `RGB (r, g, b) -> 36 * r + 6 * g + b + 16
  | `Gray i -> i + 232;;
val color_to_int : [< `Gray of int | `RGB of int * int * int ] -> int = <fun>

# let extended_color_to_int = function
  | `RGBA (r, g, b, a) -> 216 * r + 36 * g + 6 * b + a + 16
  | `Grey i -> i + 2000
  | #color as color -> color_to_int color;;
val extended_color_to_int :
  [< `Gray of int
   | `Grey of int
   | `RGB of int * int * int
   | `RGBA of int * int * int * int ] ->
  int = <fun>

```

The function `color_to_int` can convert `` `RGB`` or `` `Gray`` values. The function `extended_color_to_int` is intended to convert `` `RGB``, `` `Gray`` or `` `RGBA`` values; but it is supposed to apply a different conversion formula for gray scales. However, a typo was made, it is spelled `` `Gray``. Type checking accepts this definition of `extended_color_to_int` as function accepting four tags.

### Over Approximating Type

The following function was presented in the [Inferred Type Aliases](#Inferred-Type-Aliases) section.
```ocaml
# function `Avocado -> `Cilantro | plant -> plant;;
- : ([> `Cilantro | `Avocado ] as 'a) -> 'a = <fun>
```

Because of the `plant -> plant` pattern clause the types inferred as domain and codomain are the same. As `` `Avocado`` is accepted, it must be part of the domain; and as`` `Cilantro`` is returned, it must be part of the codomain. Both end up being part of the common type. However, `` `Avocado`` should not be part of the codomain, as this function can't possibly return such a value. A finer type-checker would infer more precise types. Type-checking is an approximation and a trade-off, some valid program are rejected, some types are too coarse.

### Performances

TODO: Expand this text

> There is one more downside: the runtime cost. A value `Pair (x, y)` occupies 3 words in memory, while a value `` `Pair (x, y)`` occupies 6 words.

Guillaume Melquiond

## When to Use Polymorphic Variant

Only using polymorphic variants is over engineering, it should be avoided. Polymorphic variants aren't an extension of simple variants. From data perspective, polymorphic variants and simple variants are equivalent. They both are sum types in the algebraic data types sense, both with parametric polymorphism and recursion. Back quote isn't a difference that matters. The only meaningful difference is the type checking algorithm. Therefore, deciding when to use polymorphic variants boils down to another question:
> Do I need nominally or structurally type checked variants?

Answering this isn't significantly easier, but it helps narrowing what to consider. The key difference lies on the way pattern matching is type checked. Polymorphic variant induce functions which intrinsically accepts more data that simple variants. This is a consequence of the subtyping relation between polymorphic variant types.

In a precautionary approach (inspired by [KISS](https://en.wikipedia.org/wiki/KISS_principle) or [YAGNI](https://en.wikipedia.org/wiki/You_aren%27t_gonna_need_it) design principles), using simple variants should be the default. However, they can feel too tight. Here are a some clues indicating this:
* Many variant declaration looking alike
* Equivalent constructor duplicated in several variants
* Variant declared for a single-purpose
* Variant declaration feeling made up or artificial

Having difficulties finding names for simple variants may be smell for one of the above. When such discomfort is felt, polymorphic variants may not be the solution, but they can be considered. Keeping in mind they may ease some parts but at the expense of understandability, precision and performances. Hopefully, very soon, large language model chatbots will be able to refactor variants of some sort into the other. This will ease experimentation.

To conclude, remember a simple variant that naturally encodes some data should remain a simple variant.

## Conclusion

Although polymorphic variant share a lot with simple variants, they are substantially different. This comes from the structural type-checking algorithm used for polymorphic variants.
- Type declaration is optional
- A type is a set of constraints over values
- The relationship between value and type is satisfies rather than inhabits
- Type expression designates sets of types
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
