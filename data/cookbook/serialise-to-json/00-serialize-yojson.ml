---
packages: 
- name: yojson
  tested_version: 2.1.2
  used_libraries:
  - ppx_yojson_conv
---
(* We need to open Ppx_yojson_conv_lib.Yojson_conv.Primitives in order to serialize values of primitive types. *)
open Ppx_yojson_conv_lib.Yojson_conv.Primitives

type language = { name: string; url: string } [@@deriving yojson]

let ocaml_language = { name: "ocaml"; url: "https://ocaml.org/" }

(* We convert `ocaml_language` to `Yojson.Safe.t` and the convert that to a `string`, which we print. *)
let _ = yojson_of_language |> Yojson.Safe.to_string |> print_endline
