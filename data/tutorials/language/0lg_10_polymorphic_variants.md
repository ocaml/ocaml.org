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

Polymorphic variants origins from Jacques Garrigue work on Objective Label, which was [first published in 1996](https://caml.inria.fr/pub/old_caml_site/caml-list-ar/0533.html). It became part of stantard OCaml in [release 3.0](https://caml.inria.fr/distrib/ocaml-3.00/), in 2000, along with labelled and optional function arguments.

The core type system of OCaml follows a [_nominal_](https://en.wikipedia.org/wiki/Nominal_type_system) discipline. Types are explicitely declared. The typing discipline used for polymorphic variants, modules and classes is different, it is [_structural_](https://en.wikipedia.org/wiki/Structural_type_system).

In the nominal approach of typing, types are first defined; later, when type-checking an expression, three outcomes are possible
1. If a matching type is found, it becomes the infered type
1. If any type can be applied, a type variable is created
1. If typing inconsistencies are found, an error is raised

This is very similar to solving an equation in mathematics. Equation on numbers accepts either zero, exactly one, several or infinitely many solutions. Nominal type checking finds that either zero, exactly one or any type can be used in an expression.

In the structural approach of typing, type definitions are optional, they can be omitted. Type checking an expression constructs a data structure that represents the types which are compatible with it. These data structures are displayed as type expressions sharing ressemblance with simple variants.

### Learning Goals

The goal of this tutorial is to make the reader acquire the following capabilities:
- When possible, translate simple variants into polymorphic variants
- When possible, translate polymorphic variants into simple variants
- Choose to use polymorphic variant when really needed

## A Note on simple Variants and Polymorphism

The type expression `'a list` does not designate a single type, it designates a family of types, all the types that can be created by substituing an actual type to type variable `'a`. The type expressions `int list`, `bool option list` or `(float -> float) list list` are actual exmaples of types which are members of the family `'a list`.

In OCaml, something is polymorphic if the type expression

## Kickstart Example

Polymorphic variant visual signature are backquotes. Pattern matching on them looks just the same as with simple variants, except for backquotes (and capitals, which are not longer required).
```ocaml
# let f = function `carot -> "Carot" | `fruit name -> name ;;
f : [< `carot | `fruit of string ] -> string = <fun>
```

Here`` `carot`` and`` `fruit`` plays a role similar to the role played by the constructors `Carot` and `Fruit` in a variant declared as `type t = Carot | Fruit of string`. Except, and most importantly, that the definition doesn't need to be written. The tokens`` `carot`` and `` `fruit`` are called _tags_ instead of constructors. A tag is defined by a name and a list of parameter types.

The expression ``[< `carot | `fruit of string ]`` play the role of a type. However, it does not represent a single type, it represents three different types.
- The type which only has`` `carot`` as inhabitant, its translation into a simple variant is `type t0 = Carot`
- The type which`` `fruit`` inhabitants, its translation into a simple variant is `type t1 = Fruit of string`
- Type type which has both`` `carot`` and`` `fruit`` inhabitants, its translation into a simple variant is `type t2 = Carot | Fruit of string`

Note each of the above translations into simple variants is correct. However, entering them as-is into the environment would lead to constructor shadowing.

This also illustrates the other strinking feature of polymorphic variants: values can be attached to several types. For instance, the tag`` `carot`` inhabits``[ `carot ]`` and``[ `carot | `fruit of String ]``, but it also inhabits any type defined by a set of tags that containts it.

What is displayed by the type-checker, for instance ``[< `carot | `fruit of string ]``, isn't a single type. It is a type expression that designates a contrained set of types. For instance, all types defined by a group of tags that contains either`` `carot`` or `` `fruit of string`` and nothing more. This is the meaning of the `<` sign in this type expression. This a bit similar to what happens with `'a list`, which isn't a single type either, but a type expression that desginates the set of `list` types of something, i.e. the set of types where `'a` has been replaced by some other type.

This is the sense of the polymorphism of polymorphic variants. Polymorphic variants are type expressions. The structural typing algorithm used for polymorphic variants creates type expressions that designate sets of types (here the three types above), which are defined by contraints on sets of tags (the inequality symbols). The polymorphism of polymorphic variant is different.

In the rest of this tutorial, the following terminology is used:
- “simple variants”
- polymorphic variant: type expressions displayed by the OCaml type-checker such as ``[< `carot | `fruit of string ]``
-

## Tag Sharing

Here is another function using pattern matching on a polymorphic variant.
```ocaml
# let g = function `edible name -> name | `carot -> "Carot";;
val g : [< `carot | `edible of string ] -> string = <fun>

# f `carot;;
- : string = "Carot" (* FIXME: have f and g return something different for `carot ? *)

# g `carot;;
- : string = "Carot"
```

Both `f` and `g` accepts the`` `carot`` tag as input, although they do not have the same domain. This is because there is type hosting`` `carot`` which satisfies the both the constraints of the domain of `f`: ``[< `carot | `fruit of string ]`` and the contraints of the domain of `g`: ``[< `carot | `fruit of string ]``. That type is ``[ `carot ]``. The same way tag defined values belong to several types, tag accepting functions belong to several types too.



However,`` `fruit name`` can be seen as the inhabitant of several types.
```ocaml

# let b1 : [ `fruit name | `carot `] = `fruit name

# let bar : [ `fruit name | `carot ] = `fruit name;;
val bar : [ `fruit name | `carot ] = `fruit name
```

```ocaml
# let bar : [> `fruit name | `carot ] = `fruit name;;
val bar : [> `fruit name | `carot ] = `fruit name

# let bar : [< `fruit name | `carot ] = `fruit name;;
val bar : [< `fruit name | `carot > `fruit name ] = `fruit name
```

Again, this designates a set of types. However, the comparison symbol

- `[> ]` : “these tags or more.” Open, lower bound
- `[< ]` : “these tags or less,” Closed, upper bound


## Exact, Closed and Open Variants

Polymorphic variant type expressions can have three forms:
1. Exact: ``[ `carot | `gherkin | `fruit of string ]`` : this only designates the type inhabited by the values introduced by these tags. Tags names must occur exaclty once.
1. Closed: ``[< `carot | `gherkin | `fruit of string ]`` : this designates a set of exact types. Each exact type is inhabited by the values introduced by a subset of the tags from 1. For instance, there are 7 exact types as such:
  - ``[ `carot ]``
  - ``[ `gherkin ]``
  - ``[ `fruit of string ]``
  - ``[ `gherkin | `fruit of string ]``
  - ``[ `carot | `fruit of string ]``
  - ``[ `carot | `gherkin ]``
  - ``[ `carot | `gherkin | `fruit of string ]``
1. Open: ``[> `carot | `gherkin | `fruit of string ]`` : this designates a set of exact types. Eact eact type is inhabited by the values introduced by supersets of the tags from 1.

The exact form is infered by the type-checker when naming a type defined by a set of tags:
```ocaml
# type t = [ `carot | `gherkin | `fruit of string ]
type t = [ `carot | `fruit of string | `gherkin ]
```

The closed form is introduced when performing pattern matching over a explicit set of tags
```ocaml
# let f = function
    | `carot -> "Carot"
    | `gherkin -> "Gherkin"
    | `fruit fruit -> fruit;;
val f : [< `carot | `fruit of string | `gherkin ] -> string = <fun>
```

Function `f` can be used with any exact type which has these three tags or less. When applied to a type with less tags, branches associated to removed tags turn safely into dead code. The type is closed because the function can't accept more than what is listed.

The open form can be introduced in two different ways.

Open polymorphic variants appear when adding a `_` to a pattern matching on tags:
```ocaml
# let g = function
    | `carot -> "Carot"
    | `gherkin -> "Gherkin"
    | `fruit fruit -> fruit
    | _ -> "Edible plant";;
val g : [> `carot | `fruit of string | `gherkin ] -> string = <fun>
```

Function `g` can be used with any exact type which has these three tags or more. Because of the catch all pattern, if `g` is passed a value introduced by a tag which is not part of the list, it will be accepted, and `"Edible plant"` is returned. The type is open because it can accept more than what is listed.

The type of `g` is also meant to disallow exact types with tags removed or changed in type. OCaml is a statically typed language, that means no type information is available at runtime. As a consequence pattern matching only relies on tag names. If `g` was given a type with removed tags, such as``[> `carot | `gherkin ]``, then passing`` `fruit`` to `g` would be allowed, but since dispatch is based on names, it would execute the`` `fruit of string`` branch and crash because no string is available. Therefore, open polymorphic variant must include all the tags from pattern matching.

Open polymorphic variants also appear when type-checking tags as values.
```ocaml
# `gherkin
- : [> `gherkin ] = `gherkin

# [ `carot; `gherkin; `carot ];;
- : [> `carot | `gherkin ] list = [ `carot; `gherkin; `carot ]
```

Binding a tag to the open polymorphic variant type which only contains enables:
- Using it all the contexts where applicable code is available
- Avoid using it in contexts that can't deal with it
- Building sum of polymorphic variants, this is show in the second example.

The exact case correspond to simple variants. Closed and open cases are polymorphic because they do not designate a single type but families of types. An exact variant type is monomorphic, it corresponds to a single variant type, not a set of variant types.

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

