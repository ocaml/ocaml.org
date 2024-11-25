---
packages:
- name: "camomile"
  tested_version: "2.0.0"
  used_libraries:
  - camomile
---

(* Returns the number of Unicode characters in a UTF-8 string *)
let () = assert (CamomileLibrary.UTF8.length "déjà" = 4)

(* Checks if a string contains valid UTF-8 encoding.
   Raises CamomileLibrary__UTF8.Malformed_code for invalid UTF-8 *)
let () = assert (
   CamomileLibrary.UTF8.validate "déjà" = ())

(* Gets the Unicode character at a given position (0-based index).
   Returns a CamomileLibrary.UChar.uchar representing the Unicode codepoint *)
let () =
   assert CamomileLibrary.(
      UChar.code (UTF8.get "déjà" 3) = 224)

(* Byte-oriented functions for efficient string manipulation.
   These work with byte positions rather than character positions,
   avoiding the need to count UTF-8 characters from the start *)
let () = assert (CamomileLibrary.UTF8.first "déjà" = 0)
let () = assert (CamomileLibrary.UTF8.last "déjà" = 4)
let () = assert (CamomileLibrary.UTF8.next "déjà" 1 = 3)
let () = assert (CamomileLibrary.UTF8.prev "déjà" 3 = 1)
let () = assert (CamomileLibrary.UTF8.nth "déjà" 2 = 3)
let () = assert CamomileLibrary.(
   UChar.code (UTF8.look "déjà" 4) = 224)

(* UTF-8 aware substring extraction using character positions.
   Converts character positions to byte positions for String.sub *)
let utf8_sub str index length =
  let index' = CamomileLibrary.UTF8.nth str index in
  let length' =
    CamomileLibrary.UTF8.nth str (index + length)
    - index'
  in
  String.sub str index' length'
let () = assert (utf8_sub "décélération" 3 4 = "élér")

(* Unicode-aware case operations. Handles special rules for different scripts
   and provides case-insensitive string comparison *)
module CaseMap =
   CamomileLibrary.CaseMap.Make(CamomileLibrary.UTF8)
assert (CaseMap.uppercase "déjà" = "DÉJÀ")
assert (CaseMap.lowercase "DÉJÀ" = "déjà")
assert (CaseMap.capitalize "élément" = "Élément")
assert (CaseMap.titlecase "l'élément" = "L'Élément")
assert (CaseMap.casefolding "DÉJÀ" = "déjà")
assert (CaseMap.compare_caseless "DÉJÀ" "déjà" = 0)
