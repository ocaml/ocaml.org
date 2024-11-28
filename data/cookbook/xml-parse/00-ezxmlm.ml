---
packages:
- name: "ezxmlm"
  tested_version: "1.1.0"
  used_libraries:
  - ezxmlm
---

(* Lets take a simple XML string. *)
let xml_string =
  {xml|<?xml version="1.0" encoding="utf-8"?>
       <root>
         <list>
           <item id="1" class="a">text 1</item>
           <item id="2" class="a">text 2</item>
           <item id="3" class="b">text 3</item>
         </list>
       </root>|xml}

(* Define a type for the items we're trying to parse. *)
type item = {
  id: string;
  data: string;
}

(*
Parse XML from string
*)
let (_dtd, xml_node) = Ezxmlm.from_string xml_string

(*
We extract all item nodes together with their attributes.

We use `Ezxmlm.member` to retrieve the nodes by tag, since they are unique.

Note: Running this iin UTOP, an exception is raised by the pretty printer;
however, the code works regardless.
*)
let attribute_node_pair_list =
  xml_node
  |> Ezxmlm.member "root"
  |> Ezxmlm.member "list"
  |> Ezxmlm.members_with_attr "item"

(* Convert item pairs to item records *)
let items =
  List.map
    (fun (attrs, node) ->
      {
        id = Ezxmlm.get_attr "id" attrs;
        data = Ezxmlm.data_to_string node
      })
    attribute_node_pair_list
