---
id: polymorphic-variants
title: Polymorphic Variants
description: |
  Everything you always wanted to know about polymorphic variants, but were afraid to ask
“”
category: "Language"
---

# Polymorphic Variants

## Introduction

### Origin and Context

TODO: move historical stuff at the end

TODO: nominal _vs_ structural

Polymorphic variants origins from Jacques Garrigue work on Objective Label, which was [first published in 1996](https://caml.inria.fr/pub/old_caml_site/caml-list-ar/0533.html). It became part of stantard OCaml in [release 3.0](https://caml.inria.fr/distrib/ocaml-3.00/), in 2000, along with labelled and optional function arguments.

The core type system of OCaml follows a [_nominal_](https://en.wikipedia.org/wiki/Nominal_type_system) discipline. Types are explicitely declared. The typing discipline used for polymorphic variants and classes is different, it is [_structural_](https://en.wikipedia.org/wiki/Structural_type_system).

In the nominal approach of typing, types are first defined; later, when type-checking an expression, three outcomes are possible
1. If a matching type is found, it becomes the infered type
1. If any type can be applied, a type variable is created
1. If typing inconsistencies are found, an error is raised

This is very similar to solving an equation in mathematics. Equation on numbers accepts either zero, exactly one, several or infinitely many solutions. Nominal type checking finds that either zero, exactly one or any type can be used in an expression.

In the structural approach of typing, type definitions are optional, they can be omitted. Type checking an expression constructs a data structure that represents the types which are compatible with it. These data structures are displayed as type expressions sharing ressemblance with simple variants.

### Learning Goals

The goal of this tutorial is to make the reader acquire the following capabilities:
- “Understanding” polymorphic variant types and errors
  - Add type annotation needed to resolve polymorphic variant type-checking issues
  - Add or remove catch all patterns in poly-var pattern matching
- Refactor between simple and polymorphic variants
- Choose to use polymorphic variant when really needed

## A Note on simple Variants and Polymorphism

The type expression `'a list` does not designate a single type, it designates a family of types, all the types that can be created by substituing an actual type to type variable `'a`. The type expressions `int list`, `bool option list` or `(float -> float) list list` are actual exmaples of types which are members of the family `'a list`.

In OCaml, something is polymorphic if the type expression

TODO: link to basic dataypes tutorial

## A First Example

Polymorphic variant visual signature are backquotes. Pattern matching on them looks just the same as with simple variants, except for backquotes (and capitals, which are not longer required).
```ocaml
# let f = function `Broccoli -> "Broccoli" | `Fruit name -> name;;
f : [< `Broccoli | `Fruit of string ] -> string = <fun>
```

Here`` `Broccoli`` and`` `Fruit`` plays a role similar to the role played by the constructors `Broccoli` and `Fruit` in a variant declared as `type t = Broccoli | Fruit of string`. Except, and most importantly, that the definition doesn't need to be written. The tokens`` `Broccoli`` and `` `Fruit`` are called _tags_ instead of constructors. A tag is defined by a name and a list of parameter types.

The expression ``[< `Broccoli | `Fruit of string ]`` play the role of a type. However, it does not represent a single type, it represents three different types.
- The type which only has`` `Broccoli`` as inhabitant, its translation into a simple variant is `type t0 = Broccoli`
- The type which`` `Fruit`` inhabitants, its translation into a simple variant is `type t1 = Fruit of string`
- Type type which has both`` `Broccoli`` and`` `Fruit`` inhabitants, its translation into a simple variant is `type t2 = Broccoli | Fruit of string`

Note each of the above translations into simple variants is correct. However, entering them as-is into the environment would lead to constructor shadowing.

This also illustrates the other strinking feature of polymorphic variants: values can be attached to several types. For instance, the tag `` `Broccoli`` inhabits ``[ `Broccoli ]`` and``[ `Broccoli | `Fruit of String ]``, but it also inhabits any type defined by a set of tags that containts it.

What is displayed by the type-checker, for instance ``[< `Broccoli | `Fruit of string ]``, isn't a single type. It is a type expression that designates a contrained set of types. For instance, all types defined by a group of tags that contains either`` `Broccoli`` or `` `Fruit of string`` and nothing more. This is the meaning of the `<` sign in this type expression. This a bit similar to what happens with `'a list`, which isn't a single type either, but a type expression that desginates the set of `list` types of something, i.e. the set of types where `'a` has been replaced by some other type.

This is the sense of the polymorphism of polymorphic variants. Polymorphic variants are type expressions. The structural typing algorithm used for polymorphic variants creates type expressions that designate sets of types (here the three types above), which are defined by contraints on sets of tags (the inequality symbols). The polymorphism of polymorphic variant is different.

In the rest of this tutorial, the following terminology is used:
- “simple variants”
- polymorphic variant: type expressions displayed by the OCaml type-checker such as ``[< `Broccoli | `Fruit of string ]``
-

## Tag Sharing

Here is another function using pattern matching on a polymorphic variant.
```ocaml
# let g = function `Edible name -> name | `Broccoli -> "Broccoli";;
val g : [< `Broccoli | `Edible of string ] -> string = <fun>

# f `Broccoli;;
- : string = "Broccoli" (* FIXME: have f and g return something different for `Broccoli ? *)

# g `Broccoli;;
- : string = "Broccoli"
```

Both `f` and `g` accepts the`` `Broccoli`` tag as input, although they do not have the same domain. This is because there is type hosting`` `Broccoli`` which satisfies the both the constraints of the domain of `f`: ``[< `Broccoli | `Fruit of string ]`` and the contraints of the domain of `g`: ``[< `Broccoli | `Fruit of string ]``. That type is ``[ `Broccoli ]``. The same way tag defined values belong to several types, tag accepting functions belong to several types too.

TODO: move this into drawbacks

Sharing may also restrict polymorphic variant types.
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

```ocaml
# let u = [ `Apple; `Pear ]
```
Function `f` accepts tags `` `Broccoli`` and `` `Fruit`` whilst `g` accepts `` `Broccoli`` and `` `Edible``. But if `f` and `g` are stored in a list, they must have the same type. That forces their domain to be restricted to a common subtype.

An closed variant may also have a lower bound.
```ocaml
# let is_red = function `Clubs -> false | `Diamonds -> true | `Hearts -> true | `Spades -> false;;
val is_red : [< `Clubs | `Diamonds | `Hearts | `Spades ] -> bool = <fun>

# let h = fun u -> List.map is_red (`Hearts :: u);;
val h : [< `Clubs | `Diamonds | `Hearts | `Spades > `Hearts ] list -> bool list = <fun>
```

Function `is_red` only accepts values from any subtype of ``[< `Clubs | `Diamonds | `Hearts | `Spades ]``. However, function `h` excludes the exact types ``[ `Clubs ]``, ``[ `Diamonds ]`` and ``[ `Spades ]``. Since the list passed to `List.map` includes a `` `Hearts`` tags, types which do no include it are not allowed. The domain of `h` is closed by ``[ `Clubs | `Diamonds | `Hearts | `Spades ]`` and open by ``[ `Hearts ]``.

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
val f : [< `Broccoli | `Fruit of string | `Gherkin ] -> string = <fun>
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

The exact case correspond to simple variants. Closed and open cases are polymorphic because they do not designate a single type but families of types. An exact variant type is monomorphic, it corresponds to a single variant type, not a set of variant types.

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

## Combining Polymorphic Variants and Simple Variants

TODO 1. Easy cases: list, options and products of polymorphic variant typed values
TODO 2: Hard case: functions. Contravariance

## Funky Types

```ocaml
# function `Tomato -> `Cilantro | plant -> plant;;
- : ([> `Cilantro | `Tomato ] as 'a) -> 'a = <fun>
```

This type means any exact variant type which is a super set of ``[> `Cilantro | `Tomato ]`` as domain, and the same type as codomain.

```ocaml
# let f = function `Fruit fruit -> fruit = "Broccoli" | `Broccoli -> true;;
val f : [< `Broccoli | `Fruit of string ] -> bool = <fun>

# let g = function `Fruit fruit -> fruit | `Broccoli -> true;;
val g : [< `Broccoli | `Fruit of bool ] -> bool = <fun>

 fun x -> f x && g x;;
- : [< `Broccoli | `Fruit of bool & string ] -> bool = <fun>

```

## Uses-Cases




### Shared Constructors

### Variants Witout Declaration

### Datatype Sharing Between Modules

Accept

### Criterion to Use Polymorphic Variant

The YAGNI (You Aren't Gonna Need It) principle can be applied to polymorphic variants. Unless the code is arguably improved by having several pattern matching over different types sharing the same tag, polymorphic variants are probably not needed.


## Drawbacks

### Hard to Read Type Expressions


## References

- https://blog.shaynefletcher.org/2017/03/polymorphic-variants-subtyping-and.html

Liskov : It is always possible to cast into a supertype.

int32 -> int64
more fields -> less fields
less constructors -> more constructors

[ `A ], [ `B ] and [ `A | `B ] are the subtypes of [ `A | `B ].
It follows then that [< `A | `B ] is the set of subtypes of [ `A | `B ]

