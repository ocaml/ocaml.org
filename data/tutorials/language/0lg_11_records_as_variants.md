---
id: records-as-variants
title: Encoding Records as Variants
description: |
  A note on how to encode immutable records as variants
category: "Language"
---

# Encoding records as variants

## Introduction

This is a supplement to the section [Records](/docs/basic-datatypes#Records) from the Basic Data Types tutorial. It presents how it is possible to encode immutable records into variants. Practically, this is an almost useless encoding. Conceptually, it helps understanding the relationship between variants, products and records.

## The Encoding

Records also are variants with a single constructor carrying all the fields as a tuple. Here is how to alternatively define the `character` record as a variant.
```ocaml
# type character' = Character of string * int * string * character_class * (firmness * rectitude) * int;;
type character' =
    Character of string * int * string * character_class *
      (firmness * rectitude) * int

# let name (Character (name, _, _, _, _, _)) = name;;
val name : character' -> string = <fun>

# let level (Character (_, level, _, _, _, _)) = level;;
val level : character' -> int = <fun>

# let race (Character (_, _, race, _, _, _)) = race;;
val race : character' -> string = <fun>

# let class_type (Character (_, _, _, class_type, _, _)) = class_type;;
val class_type : character' -> character_class = <fun>

# let alignment (Character (_, _, _, _, alignment, _)) = alignment;;
val alignment : character' -> firmness * rectitude = <fun>

# let armor_class (Character (_, _, _, _, _, armor_class)) = armor_class;;
val armor_class : character -> int = <fun>
```

One function will retrieve and read the contained data per field. It provides the same functionality as the dotted notation.
```ocaml
# let ghorghor_bey' = Character ("Ghôrghôr Bey", 17, "half-ogre", Fighter, (Chaotic, R_Neutral), -8);;
val ghorghor_bey' : character =
  Character ("Ghôrghôr Bey", 17, "half-ogre", Fighter, (Chaotic, R_Neutral), -8)

# level ghorghor_bey';;
- : int = 17
```
Writing `level ghorghor_bey'` is the same as `ghorghor_bey.level`.

## Conclusion

To be true to facts, it is not possible to encode all records as variants because OCaml provides a means to define fields whose value can be updated, which isn't available while defining variant types. This will be detailed in an upcoming tutorial on imperative programming.

Records **should not** be defined using this technique. It is only demonstrated to further illustrate the expressive strength of OCaml variants.

This way, to define records **may** be applied to _Generalised Algebraic Data Types_, which is the subject of another tutorial.
