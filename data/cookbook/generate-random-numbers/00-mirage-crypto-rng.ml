---
packages:
- name: "mirage-crypto-rng"
  version: "0.11.2"
- name: "randomconv"
  version: "0.1.3"
libraries:
- TODO
---

(* Initialize the RNG with the default entropy source. *)
let () = Mirage_crypto_rng_unix.initialize
          (module Mirage_crypto_rng.Fortuna)

(* Generate a `Cstruct.t` with random data. *)
let cstruct n = Mirage_crypto_rng.generate n

(* Use the `Randomconv` module from the `randomconv` package to convert to various integer types. *)
let int8 () = Randomconv.int8 cstruct
let int16 () = Randomconv.int16 cstruct
let int32 () = Randomconv.int32 cstruct
let int64 () = Randomconv.int64 cstruct

(* Generate a random `int` or `float` less than or equal to `max`. *)
let int ?max () =
  Randomconv.int ?bound:max cstruct
let float ?max () =
  Randomconv.float ?bound:max cstruct

