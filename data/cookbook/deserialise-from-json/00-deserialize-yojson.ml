---
packages: 
- name: yojson
  tested_version: 2.1.2
  used_libraries:
  - ppx_yojson_conv
---
(* We need to open Ppx_yojson_conv_lib.Yojson_conv.Primitives in order to deserialize primitives*)
open Ppx_yojson_conv_lib.Yojson_conv.Primitives

type language = { name: string; url: string } [@@deriving yojson]

(* First we convert the json string to Yojson.Safe.t and then we use the generated function to create the record *)
(* If the parsing fails the result will be None. Otherwise it will be the deserialized record*)
let ocaml_language = { name: "ocaml"; url: "https://ocaml.org/" }

(* We convert the language to a Yojson.Safe.T and the convert that to a string, which in the end we print*)
let _ = yojson_of_language |> Yojson.Safe.to_string |> print_endline
