---
packages:
- name: "ezxmlm"
  version: "1.1.0"
libraries:
- ezxmlm
discussion: |
  - **Understanding `ezxmlm`:** The `ezxmlm` package provides high level functions that can be used to parse and generate an XML file. This package is based on `xmlm` which which works with element start/end callbacks.
  - **Alternatives:** TODO
---

(* Lets take a simple structure a pair list representing an id and an associated text *)

let item_list = [ ("1", "Text 1"); ("2", "Text 2")]

(* We will convert each item into an XML node. Each XML node must have one of the form:
- \`Data text
- \`El ((("","tag"), attribute_list), node_list)

The attribute_list must have the form [("", "name"), "value"); ...]

Then we can type:
*)

let item_nodes = item_list |> List.map (fun (id, text) ->
   `El ((("","item"), [("","id"), id]), [ `Data text ]))

(* We can enclose these items in a list element *)

let list_node = `El ((("","list"), []), item_nodes)

(* Then create and export the XML tree, in a string or in a file *)

let xml_string = Ezxmlm.to_string [list_node]

let xml_header = {xml|<?xml version="1.0" encoding="utf-8"?>|xml}
let () =
  Out_channel.with_open_bin "file.xml"
  (fun oc -> Ezxmlm.to_channel oc (Some xml_header) [list_node])
