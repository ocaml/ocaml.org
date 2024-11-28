---
packages:
- name: "ezxmlm"
  tested_version: "1.1.0"
  used_libraries:
  - ezxmlm
---

(* Define a simple record type for our data items *)
type item = {
  id: string;
  data: string;
}

(* Sample data *)
let item_list = [
    { id = "1"; data = "Name 1"};
    { id = "2"; data = "Name 2"}
  ]

(*
Each XML node is either
- a data node \`Data text, or
- an element node \`El ((("","tag"), attribute_list), node_list).
*)
let make_xml_element tag attrs children =
  `El ((("", tag), attrs), children)

let make_xml_text text =
  `Data text

(* Convert an item to its XML representation *)
let item_to_xml {id; data} =
  make_xml_element "item" [("", "id"), id] [
    make_xml_text data
  ]

(* Create XML nodes for all items and wrap them in a root <list> element. *)
let xml_doc = List.map item_to_xml item_list
  |> make_xml_element "list" []

(* Convert the XML to a string *)
let xml_string = Ezxmlm.to_string [ xml_doc ]

(* Write the XML to a file.

The resulting XML will look like:
```xml
<?xml version="1.0" encoding="utf-8"?>
<list>
  <item id="1">Name 1</item>
  <item id="2">Name 2</item>
</list>
```*)
let () =
  let
    xml_header = {xml|<?xml version="1.0" encoding="utf-8"?>|xml}
  in
  Out_channel.with_open_bin "file.xml"
  (fun oc ->
    Ezxmlm.to_channel
      oc
      (Some xml_header)
      [xml_doc])
