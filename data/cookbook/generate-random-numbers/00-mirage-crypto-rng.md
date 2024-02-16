---
title: Generate random numbers (mirage-crypto-rng)
problem: "You need to find the year, month, and day values for today's date."
category: "Generate Random Values"
packages: ["mirage-crypto-rng"]
sections:
- filename: main.ml
  language: ocaml
  code_blocks:
  - explanation: ""
    code: |
      open Mirage_crypto_rng
  - explanation: |
      Initialize the RNG with the default entropy source.
    code: |
      Mirage_crypto_rng_unix.initialize ();
  - explanation: Generate a random byte array of length 8.
    code: |
      let random_bytes = Mirage_crypto_rng.generate 8 in
  - explanation: Convert the random bytes to a hex string (for display purposes).
    code: |
      let hex_string = Cstruct.to_string random_bytes 
                       |> Hex.of_string
                       |> Hex.show in
      Printf.printf "Random Bytes (Hex): %s\n" hex_string;
  - explanation: |
      Example: Converting the first 4 bytes to an int (assuming little endian).
    code: |
      let random_int =
        let open Cstruct.LE in
        get_uint32 random_bytes 0 |> Int32.to_int
      in
      Printf.printf "Random Int: %d\n" random_int

---
