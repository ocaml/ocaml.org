---
packages:
- name: "hex"
  tested_version: "1.5.0"
  used_libraries:
  - hex
- name: "cstruct"
  tested_version: "6.2.0"
  used_libraries:
  - cstruct
discussion: |
  - **Using the Hex and Cstruct libraries to decode a hexadecimal string to an ASCII string.
  - **Using the Hex library to convert an ASCII string to a hexadecimal encoded message.
  - **Uses the Hex and Cstruct libraries.
---


(* `decode_hex_string hex_string` is the string represented by `hex_string`.
   Raises: Invalid_argument if `hex_string` is not valid hex. *)
let decode_hex_string hex_string =
  let byte_string = Hex.to_cstruct (`Hex hex_string) in
  let decoded_string = Cstruct.to_string byte_string in
  decoded_string

(* `encode_to_hex message` accepts a string `message` and returns
   the hexadecimal representation of `message`. *)
let encode_to_hex message =
  let byte_string = Cstruct.of_string message in
  let hex_string = Hex.of_cstruct byte_string in
  Hex.show hex_string

(* Example usage *)
let hex_message = "48656c6c6f2c20576f726c6421";;
Printf.printf "Hex message: %s\n" hex_message

let message = decode_hex_string hex_message;;

(* Show the decrypted message *)
Printf.printf "Decoded message: %s\n" message

(* Encrypt the message back to hexadecimal *)
let encoded_message = encode_to_hex message;;

(* Show the hexadecimal encoded message *)
Printf.printf "Encoded message: %s\n" encoded_message
