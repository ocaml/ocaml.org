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

let ocaml_language = { name: "ocaml"; url: "https://ocaml.org/" }

(* We convert the language to a Yojson.Safe.T and the convert that to a string, which in the end we print*)
let _ = yojson_of_language |> Yojson.Safe.to_string |> print_endline
