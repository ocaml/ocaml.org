---
packages: 
- name: ppx_yojson_conv
  tested_version: "v0.17.0"
  used_libraries:
  - ppx_yojson_conv
- name: yojson
  tested_version: 2.1.2
  used_libraries:
  - yojson
---
(* We open `Ppx_yojson_conv_lib.Yojson_conv.Primitives` to bring the functions that deserialise primitive types in scope. *)
open Ppx_yojson_conv_lib.Yojson_conv.Primitives

let json = {|
{
  "name": "ocaml",
  "url": "https://ocaml.org/"
}
|}

(* The annotation `[@@deriving yojson]` causes the PPX from `ppx_yojson_conv` to generate a function
  `language_of_yojson` that converts values from type `Yojson.Safe.t` to `language`. *)
type language = {
  name: string;
  url: string
} [@@deriving yojson]

(* First we convert the JSON string to `Yojson.Safe.t` and then we use the generated function to create the record.
   If parsing fails, an `Of_yojson_error` exception is thrown that we can handle. *)
try
  let result =
    json
    |> Yojson.Safe.from_string
    |> language_of_yojson in
  Some result
with Ppx_yojson_conv_lib.Yojson_conv.Of_yojson_error (exc, _) ->
  let _ =
    print_endline (Printexc.to_string exc) in
  None
