---
packages:
- name: "camomile"
  version: "1.0.2"
libraries:
- camomile
discussion: |
  - **Understanding `camomile`:** The `camomile` package provides functions which handles correcly UTF-8 characters.
---

(* Initialize the `camomile` library, which offer a large set of functions
   to deal with strings presented in various encoding. The `Camomile`
   module declaration is required with the version 1 of `camomile`
   and mustn't be declared with the version 2: *)
module Camomile = CamomileLibrary.Make(CamomileDefaultConfig)

(* Get the length (number of characters) of a UTF-8 string: *)
let () = assert (Camomile.UTF8.length "déjà" = 4)

(* Validate a UTF-8 string. Would raise a `CamomileLibrary__UTF8.Malformed_code`
   with a string like "\233\233" *)
let () = assert (Camomile.UTF8.validate "déjà" = ())

(* Extract the nth character from a string (the first character has a 0 index).
   The character has a `Camomile.UChar.uchar` type which can represent
   any Unicode character: *)
let () = assert (Camomile.UChar.code (Camomile.UTF8.get "déjà" 3)
                    = 224)

(* Using bytes oriented indexes. Using functions which works
   directly with the byte indexes of characters can be more efficient
   than using functions like `get` or `length` that have to parse
   the string counting characaters. `first`, `next`, `prev`, `last`
   and `look` all deals with bytes indexes. `nth` convert of position
   expressed as a character index to a byte index. *)
let () = assert (Camomile.UTF8.first "déjà" = 0)
let () = assert (Camomile.UTF8.last "déjà" = 4)
let () = assert (Camomile.UTF8.next "déjà" 1 = 3)
let () = assert (Camomile.UTF8.prev "déjà" 3 = 1)
let () = assert (Camomile.UTF8.nth "déjà" 2 = 3)
let () =
  assert (Camomile.UChar.code (Camomile.UTF8.look "déjà" 4) = 224)

(* If we want to get a substring of an UTF-8, we can use the
   `String.sub` but with indexes calculated by `Camomile.UTF8.nth`: *)
let utf8_sub str index length =
  let index' = Camomile.UTF8.nth str index in
  let length' = Camomile.UTF8.nth str (index + length) - index' in
  String.sub str index' length'
let () = assert (utf8_sub "décélération" 3 4 = "élér")

(* Functions which deal with the case of UTF-8 strings need
   to declare a module associated with the encoding (here UTF-8).
   `compare_caseless s1 s2` compare two strings considering
   lowercase characters equal to their corresponding uppercase.
   The usual convention is used: 1 if `s1` is greater,
    0 if equal and -1 if lower than `s2`. *)
module CaseMap = Camomile.CaseMap.Make(Camomile.UTF8)
assert (CaseMap.uppercase "déjà" = "DÉJÀ")
assert (CaseMap.lowercase "DÉJÀ" = "déjà")
assert (CaseMap.capitalize "élément" = "Élément")
assert (CaseMap.titlecase "le quatrième élément" = "Le Quatrième Élément"
assert (CaseMap.casefolding "DÉJÀ" = "déjà")
assert (CaseMap.compare_caseless "DÉJÀ" "déjà" = 0)
