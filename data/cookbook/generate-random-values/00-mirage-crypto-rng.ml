---
packages:
- name: mirage-crypto-rng
  tested_version: 0.11.3
  used_libraries:
  - mirage-crypto-rng.unix
- name: cstruct
  tested_version: 6.2.0
  used_libraries:
  - cstruct
- name: randomconv
  tested_version: 0.1.3
  used_libraries:
  - randomconv
---

(* Initialize the `Mirage_crypto_rng` with the an entropy source. *)
let () =
  Mirage_crypto_rng_unix.initialize
    (module Mirage_crypto_rng.Fortuna)

(* Random bytes generation function. *)
let generator n =
  n
  |> Mirage_crypto_rng.generate
  |> Cstruct.to_string

(* Generate `int8`, `int16`, `int32` or `int64` values. *)
let int8 () = Randomconv.int8 generator
let int16 () = Randomconv.int16 generator
let int32 () = Randomconv.int32 generator
let int64 () = Randomconv.int64 generator

(* Generate a random `int` or `float` values strictly lower than `bound`. *)
let int ?bound () =
  Randomconv.int ?bound generator
let float ?bound () =
  Randomconv.float ?bound generator

(* Generate `char` values *)
let char () = () |> int8 |> Char.chr
let digit () = 48 + int ~bound:10 () |> Char.chr
let majuscule () = 65 + int ~bound:26 () |> Char.chr
let minuscule () = 97 + int ~bound:26 () |> Char.chr
let letter () =
  let n = int ~bound:52 () in
  Char.chr @@ n + if n < 26 then 65 else 71
let alphanum () =
  let n = int ~bound:62 () in
  Char.chr @@ n
  + if n < 10 then 48 else if n < 36 then 55 else 61

(* Random bytes into byte arrays or big arrays. *)
let bytes n =
  n
  |> Mirage_crypto_rng.generate
  |> Cstruct.to_bytes
let bigarray n =
  n
  |> Mirage_crypto_rng.generate
  |> Cstruct.to_bigarray

let list n gen = List.init n (fun _ -> gen ())
