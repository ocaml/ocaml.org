---
packages:
- name: "camomile"
  tested_version: "2.0.0"
  used_libraries:
  - camomile
---

(* The camomile library provides functions to handle strings in various encodings.
*)
module E = CamomileLib.CharEncoding
module Utf8 = E.Make(CamomileLib.Utf8)

(* Convert a Utf8 string into a Latin1 encoding.
   Note: most terminals handle both Utf8 and Latin1 characters,
   so both strings may look identical on screen. *)
let Utf8 = "déjà"
let () = assert (String.length Utf8 = 6)
let latin1 = Utf8.encode E.latin1 Utf8
let () = assert (String.length latin1 = 4)
(* Convert the Latin1 string back to Utf8 *)
let Utf8' = Utf8.decode E.latin1 latin1
let () = assert (Utf8 = Utf8')

(* Additional encodings are available via the `of_name` function.
   Note: The Euro symbol (€) is not supported in Latin1, but is available
   in ISO_8859-16 (also known as LATIN10) *)
let latin10 =
  Utf8.encode (E.of_name "ISO_8859-16") "100 €"
