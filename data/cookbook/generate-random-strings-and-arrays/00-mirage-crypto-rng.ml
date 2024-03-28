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

(* To get a random `char`, convert a random `int8`: *)
let int8 () = Randomconv.int8 cstruct
let char () = Char.chr (int8 ())

(* Use `Cstruct`'s conversion methods to obtain random byte arrays, bigarrays or strings. *)
let bytes n = cstruct n |> Cstruct.to_bytes
let bigarray n = cstruct n |> Cstruct.to_bigarray
let string n = cstruct n |> Cstruct.to_string

(* You can also create alphanumeric random characters: *)
let alphanum () =
  Char.chr (48 + Randomconv.int ~bound:74 cstruct)

(* Wrap your random value generator into a sequence to generate as many random values as you want. *)
let seq gen =
  Seq.unfold (fun () -> Some (gen (), ())) ()
let list n gen =
  seq gen |> Seq.take n |> List.of_seq
