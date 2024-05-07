---
packages: 
- name: yojson
  tested_version: 2.1.2
  used_libraries:
  - ppx_yojson_conv
---
(* We need to open Ppx_yojson_conv_lib.Yojson_conv.Primitives in order to deserialize primitives*)
open Ppx_yojson_conv_lib.Yojson_conv.Primitives

let json = {|
{
  "name": "ocaml",
  "url": "https://ocaml.org/"
}
|}

type language = { name: string; url: string } [@@deriving yojson]

(* First we convert the json string to Yojson.Safe.t and then we use the generated function to create the record *)
(* If the parsing fails the result will be None. Otherwise it will be the deserialized record*)
try
  let result = Yojson.Safe.from_string json |> language_of_yojson 
  Some result
with Ppx_yojson_conv_lib__Yojson_conv.Of_yojson_error (exception, _) ->
  let _ = Printexc.to_string exception print_endline in
  None
