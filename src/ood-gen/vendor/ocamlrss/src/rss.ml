(******************************************************************************)
(*               OCamlrss                                                     *)
(*                                                                            *)
(*   Copyright (C) 2004-2013 Institut National de Recherche en Informatique   *)
(*   et en Automatique. All rights reserved.                                  *)
(*                                                                            *)
(*   This program is free software; you can redistribute it and/or modify     *)
(*   it under the terms of the GNU Lesser General Public License version      *)
(*   3 as published by the Free Software Foundation.                          *)
(*                                                                            *)
(*   This program is distributed in the hope that it will be useful,          *)
(*   but WITHOUT ANY WARRANTY; without even the implied warranty of           *)
(*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            *)
(*   GNU Library General Public License for more details.                     *)
(*                                                                            *)
(*   You should have received a copy of the GNU Library General Public        *)
(*   License along with this program; if not, write to the Free Software      *)
(*   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA                 *)
(*   02111-1307  USA                                                          *)
(*                                                                            *)
(*   Contact: Maxence.Guesdon@inria.fr                                        *)
(*                                                                            *)
(*                                                                            *)
(******************************************************************************)

type category = Rss_types.category = {
  cat_name : string;
  cat_domain : Uri.t option;
}

type image = Rss_types.image = {
  image_url : Uri.t;
  image_title : string;
  image_link : Uri.t;
  image_height : int option;
  image_width : int option;
  image_desc : string option;
}

type text_input = Rss_types.text_input = {
  ti_title : string;
      (** The label of the Submit button in the text input area. *)
  ti_desc : string;  (** Explains the text input area. *)
  ti_name : string;  (** The name of the text object in the text input area. *)
  ti_link : Uri.t;
      (** The URL of the CGI script that processes text input requests. *)
}

type enclosure = Rss_types.enclosure = {
  encl_url : Uri.t;  (** URL of the enclosure *)
  encl_length : int;  (** size in bytes *)
  encl_type : string;  (** MIME type *)
}

type cloud = Rss_types.cloud = {
  cloud_domain : string;
  cloud_port : int;
  cloud_path : string;
  cloud_register_procedure : string;
  cloud_protocol : string;
}
(** See {{:http://cyber.law.harvard.edu/rss/soapMeetsRss.html#rsscloudInterface} specification} *)

type guid = Rss_types.guid = Guid_permalink of Uri.t | Guid_name of string

type source = Rss_types.source = { src_name : string; src_url : Uri.t }

type 'a item_t = 'a Rss_types.item_t = {
  item_title : string option;
  item_link : Uri.t option;
  item_desc : string option;
  item_pubdate : Ptime.t option;
  item_author : string option;
  item_categories : category list;
  item_comments : Uri.t option;
  item_enclosure : enclosure option;
  item_guid : guid option;
  item_source : source option;
  item_content : string option;
  item_data : 'a option;
}

type namespace = string * string

type ('a, 'b) channel_t = ('a, 'b) Rss_types.channel_t = {
  ch_title : string;
  ch_link : Uri.t;
  ch_desc : string;
  ch_language : string option;
  ch_copyright : string option;
  ch_managing_editor : string option;
  ch_webmaster : string option;
  ch_pubdate : Ptime.t option;
  ch_last_build_date : Ptime.t option;
  ch_categories : category list;
  ch_generator : string option;
  ch_cloud : cloud option;
  ch_docs : Uri.t option;
  ch_ttl : int option;
  ch_image : image option;
  ch_rating : string option;
  ch_text_input : text_input option;
  ch_skip_hours : int list option;
  ch_skip_days : int list option;
  ch_items : 'b item_t list;
  ch_data : 'a option;
  ch_namespaces : namespace list;
}

type item = unit item_t

type channel = (unit, unit) channel_t

let item ?title ?link ?desc ?pubdate ?author ?(cats = []) ?comments ?encl ?guid
    ?source ?content ?data () =
  {
    item_title = title;
    item_link = link;
    item_desc = desc;
    item_pubdate = pubdate;
    item_author = author;
    item_categories = cats;
    item_comments = comments;
    item_enclosure = encl;
    item_guid = guid;
    item_source = source;
    item_content = content;
    item_data = data;
  }

let channel ~title ~link ~desc ?language ?copyright ?managing_editor ?webmaster
    ?pubdate ?last_build_date ?(cats = []) ?generator ?cloud ?docs ?ttl ?image
    ?rating ?text_input ?skip_hours ?skip_days ?data ?(namespaces = []) items =
  {
    ch_title = title;
    ch_link = link;
    ch_desc = desc;
    ch_language = language;
    ch_copyright = copyright;
    ch_managing_editor = managing_editor;
    ch_webmaster = webmaster;
    ch_pubdate = pubdate;
    ch_last_build_date = last_build_date;
    ch_categories = cats;
    ch_generator = generator;
    ch_cloud = cloud;
    ch_docs = docs;
    ch_ttl = ttl;
    ch_image = image;
    ch_rating = rating;
    ch_text_input = text_input;
    ch_skip_hours = skip_hours;
    ch_skip_days = skip_days;
    ch_items = items;
    ch_data = data;
    ch_namespaces = namespaces;
  }

let compare_item = Rss_types.compare_item

let copy_item i = { i with item_title = i.item_title }

let copy_channel c = { c with ch_items = List.map copy_item c.ch_items }

let sort_items_by_date l =
  List.sort
    (fun i1 i2 ->
      match (i1.item_pubdate, i2.item_pubdate) with
      | None, None -> 0
      | Some _, None -> -1
      | None, Some _ -> 1
      | Some d1, Some d2 -> Ptime.compare d2 d1)
    l

let merge_channels c1 c2 =
  let items = sort_items_by_date (c1.ch_items @ c2.ch_items) in
  let c = copy_channel c1 in
  { c with ch_items = items }

type xmltree = Rss_io.xmltree = E of Xmlm.tag * xmltree list | D of string

let xml_of_source = Rss_io.xml_of_source

exception Error = Rss_io.Error

type ('a, 'b) opts = ('a, 'b) Rss_io.opts

let make_opts = Rss_io.make_opts

let default_opts = Rss_io.default_opts

let channel_t_of_file = Rss_io.channel_of_file

let channel_t_of_string = Rss_io.channel_of_string

let channel_t_of_channel = Rss_io.channel_of_channel

let channel_t_of_xmls = Rss_io.channel_of_xmls

let channel_of_file = Rss_io.channel_of_file default_opts

let channel_of_string = Rss_io.channel_of_string default_opts

let channel_of_channel = Rss_io.channel_of_channel default_opts

type 'a data_printer = 'a -> xmltree list

let print_channel = Rss_io.print_channel

let print_file ?channel_data_printer ?item_data_printer ?indent ?encoding file
    ch =
  let oc = open_out file in
  let fmt = Format.formatter_of_out_channel oc in
  print_channel ?channel_data_printer ?item_data_printer ?indent ?encoding fmt
    ch;
  Format.pp_print_flush fmt ();
  close_out oc

let keep_n_items n channel =
  let rec iter acc m = function
    | [] -> List.rev acc
    | _ :: _ when m > n -> List.rev acc
    | i :: q -> iter (i :: acc) (m + 1) q
  in
  let c = copy_channel channel in
  { c with ch_items = iter [] 1 c.ch_items }
