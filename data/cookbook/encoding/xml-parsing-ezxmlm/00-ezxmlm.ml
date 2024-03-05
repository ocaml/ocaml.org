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

(* Let's parse it: *)

let (_dtd, xml_node) = Ezxmlm.from_string xml_string

(* Or if the XML is in a file.xml *)

let (_dtd, xml_node) = In_channel.with_open_bin
                         "file.xml" Ezxmlm.from_channel

(* Fetching a member by its tag, assuming it is unique, can be done by the `member` function. (Note: an exception is raised in UTop by the pretty printer; however, these values are correct) *)

let root_node = Ezxmlm.member "root" xml_node
let list_node = Ezxmlm.member "list" root_node

(* Fetching all members by their tags returning a list of nodes can be done by the `members` function *)

let item_node_list = Ezxmlm.members "item" list_node

(* We can then fetch the enclosed text *)

let data_list = List.map Ezxmlm.data_to_string item_node_list

(* If we want to filter with the attributes, we have to deal with a list of pairs (attribute list, nodes) which are returned by `members_with_attr`. *)

let item_pair_list = Ezxmlm.members_with_attr "item" list_node
let item_pair = Ezxmlm.filter_attr "id" "2" item_pair_list

(* We can get its attribute values or use the node with other functions. *)

let class_ = Ezxmlm.get_attr "class" (fst item_pair)
let data = Ezxmlm.data_to_string (snd item_pair)

(* If we expect the attribute selection not to be unique, the `filter_attrs` should be used. *)

let item_pair_list' = Ezxmlm.filter_attrs "class" "a" item_pair_list
let data_list = List.map
                  (fun item_pair -> Ezxmlm.data_to_string (snd item_pair)) 
                  item_pair_list'

(* A whole example: an RSS parser that returns a list of pair (title, link) from an RSS string *)

let parse_rss str =
  let open Ezxmlm in
    let (_dtd,xml) = from_string str in
    xml
    |> member "rss"
    |> member "channel"
    |> members "item"
    |> List.map begin fun item ->
         let title = (item
                      |> member "title"
                      |> data_to_string)
          and link = (item
                      |> member "link"
                      |> data_to_string)
          in
          (title, link)
        end
