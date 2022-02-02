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

(** The RSS library to read and write RSS 2.0 files. Reference:
    {{:http://www.rssboard.org/rss-specification} RSS 2.0 specification}. *)

(** {2 Types} *)

type category = {
  cat_name : string;
      (** A forward-slash-separated string that identifies a hierarchic location
          in the indicated taxonomy. *)
  cat_domain : Uri.t option;  (** Identifies a categorization taxonomy. *)
}

type image = {
  image_url : Uri.t;
      (** The URL of a GIF, JPEG or PNG image that represents the channel. *)
  image_title : string;
      (** Description of the image, it's used in the ALT attribute of the HTML
          <img> tag when the channel is rendered in HTML. *)
  image_link : Uri.t;
      (** The URL of the site, when the channel is rendered, the image is a link
          to the site. (Note, in practice the [image_title] and [image_link]
          should have the same value as the {!channel}'s [ch_title] and
          [ch_link].) *)
  image_height : int option;  (** Height of the image, in pixels. *)
  image_width : int option;  (** Width of the image, in pixels. *)
  image_desc : string option;
      (** Text to be included in the "title" attribute of the link formed around
          the image in the HTML rendering. *)
}

type text_input = {
  ti_title : string;
      (** The label of the Submit button in the text input area. *)
  ti_desc : string;  (** Explains the text input area. *)
  ti_name : string;  (** The name of the text object in the text input area. *)
  ti_link : Uri.t;
      (** The URL of the CGI script that processes text input requests. *)
}

type enclosure = {
  encl_url : Uri.t;  (** URL of the enclosure *)
  encl_length : int;  (** size in bytes *)
  encl_type : string;  (** MIME type *)
}

type guid =
  | Guid_permalink of Uri.t  (** A permanent URL pointing to the story. *)
  | Guid_name of string  (** A string that uniquely identifies the item. *)

type source = { src_name : string; src_url : Uri.t }

type cloud = {
  cloud_domain : string;
  cloud_port : int;
  cloud_path : string;
  cloud_register_procedure : string;
  cloud_protocol : string;
}
(** See {{:http://cyber.law.harvard.edu/rss/soapMeetsRss.html#rsscloudInterface}
    specification} *)

type 'a item_t = {
  item_title : string option;  (** Optional title *)
  item_link : Uri.t option;  (** Optional link *)
  item_desc : string option;  (** Optional description *)
  item_pubdate : Ptime.t option;  (** Date of publication *)
  item_author : string option;
      (** The email address of the author of the item. *)
  item_categories : category list;
      (** Categories for the item. See the field {!category}. *)
  item_comments : Uri.t option;  (** Url of comments about this item *)
  item_enclosure : enclosure option;
  item_guid : guid option;  (** A globally unique identifier for the item. *)
  item_source : source option;
  item_content : string option;
  item_data : 'a option;
      (** Additional data, since RSS can be extended with namespace-prefixed
          nodes.*)
}
(** An item may represent a "story". Its description is a synopsis of the story
    (or sometimes the full story), and the link points to the full story. *)

type namespace = string * string
(** A namespace is a pair (name, url). *)

type ('a, 'b) channel_t = {
  ch_title : string;
      (** Mandatory. The name of the channel, for example the title of your web
          site. *)
  ch_link : Uri.t;
      (** Mandatory. The URL to the HTML website corresponding to the channel. *)
  ch_desc : string;  (** Mandatory. A sentence describing the channel. *)
  ch_language : string option;
      (** Language of the news, e.g. "en". See the W3C
          {{:http://www.w3.org/TR/REC-html40/struct/dirlang.html#langcodes}
          language codes}. *)
  ch_copyright : string option;  (** Copyright notice. *)
  ch_managing_editor : string option;  (** Managing editor of the news. *)
  ch_webmaster : string option;  (** The address of the webmasterof the site. *)
  ch_pubdate : Ptime.t option;  (** Publication date of the channel. *)
  ch_last_build_date : Ptime.t option;
      (** When the channel content changed for the last time. *)
  ch_categories : category list;
      (** Categories for the channel. See the field {!category}. *)
  ch_generator : string option;  (** The tool used to generate this channel. *)
  ch_cloud : cloud option;
      (** Allows processes to register with a cloud to be notified of updates to
          the channel. *)
  ch_docs : Uri.t option;  (** An url to a RSS format reference. *)
  ch_ttl : int option;
      (** Time to live, in minutes. It indicates how long a channel can be
          cached before refreshing from the source. *)
  ch_image : image option;
  ch_rating : string option;  (** The PICS rating for the channel. *)
  ch_text_input : text_input option;
  ch_skip_hours : int list option;
      (** A hint for aggregators telling them which hours they can skip.*)
  ch_skip_days : int list option;
      (** A hint for aggregators telling them which days they can skip. *)
  ch_items : 'b item_t list;
  ch_data : 'a option;
      (** Additional data, since RSS can be extended with namespace-prefixed
          nodes.*)
  ch_namespaces : namespace list;
}

type item = unit item_t
type channel = (unit, unit) channel_t

(** {2 Building items and channels} *)

val item :
  ?title:string ->
  ?link:Uri.t ->
  ?desc:string ->
  ?pubdate:Ptime.t ->
  ?author:string ->
  ?cats:category list ->
  ?comments:Uri.t ->
  ?encl:enclosure ->
  ?guid:guid ->
  ?source:source ->
  ?content:string ->
  ?data:'a ->
  unit ->
  'a item_t
(** [item()] creates a new item with all fields set to [None]. Use the optional
    parameters to set fields. *)

val channel :
  title:string ->
  link:Uri.t ->
  desc:string ->
  ?language:string ->
  ?copyright:string ->
  ?managing_editor:string ->
  ?webmaster:string ->
  ?pubdate:Ptime.t ->
  ?last_build_date:Ptime.t ->
  ?cats:category list ->
  ?generator:string ->
  ?cloud:cloud ->
  ?docs:Uri.t ->
  ?ttl:int ->
  ?image:image ->
  ?rating:string ->
  ?text_input:text_input ->
  ?skip_hours:int list ->
  ?skip_days:int list ->
  ?data:'a ->
  ?namespaces:namespace list ->
  'b item_t list ->
  ('a, 'b) channel_t
(** [channel items] creates a new channel containing [items]. Other fields are
    set to [None] unless the corresponding optional parameter is used. *)

val compare_item : ?comp_data:('a -> 'a -> int) -> 'a item_t -> 'a item_t -> int
val copy_item : 'a item_t -> 'a item_t
val copy_channel : ('a, 'b) channel_t -> ('a, 'b) channel_t

(** {2 Manipulating channels} *)

val keep_n_items : int -> ('a, 'b) channel_t -> ('a, 'b) channel_t
(** [keep_n_items n ch] returns a copy of the channel, keeping only [n] items
    maximum. *)

val sort_items_by_date : 'a item_t list -> 'a item_t list
(** Sort items by date, older last. *)

val merge_channels :
  ('a, 'b) channel_t -> ('a, 'b) channel_t -> ('a, 'b) channel_t
(** [merge_channels c1 c2] merges the given channels in a new channel, sorting
    items using {!sort_items_by_date}. Channel information are copied from the
    first channel [c1]. *)

(** {2 Reading channels} *)

(** This represents XML trees. Such XML trees are given to functions provided to
    read additional data from RSS channels and items. *)
type xmltree = E of Xmlm.tag * xmltree list | D of string

val xml_of_source : Xmlm.source -> xmltree
(** Read an XML tree from a source. @raise Failure in case of error.*)

exception Error of string
(** Use this exception to indicate an error is functions given to [make_opts]
    used to read additional data from prefixed XML nodes. *)

type ('a, 'b) opts
(** Options used when reading source. *)

val make_opts :
  ?read_channel_data:(xmltree list -> 'a option) ->
  ?read_item_data:(xmltree list -> 'b option) ->
  unit ->
  ('a, 'b) opts
(** @param read_channel_data provides a way to read additional information from
    the subnodes of the channels. All these subnodes are prefixed by an expanded
    namespace. @param read_item_data is the equivalent of [read_channel_data]
    parameter but is called of each item with its prefixed subnodes. *)

val default_opts : (unit, unit) opts

val channel_t_of_file :
  ('a, 'b) opts -> string -> ('a, 'b) channel_t * string list
(** [channel_\[t_\]of_X] returns the parsed channel and a list of encountered
    errors. Note that only namespaces declared in the root not of the XML tree
    are added to [ch_namespaces] field.

    @raise Failure if the channel could not be parsed. *)

val channel_t_of_string :
  ('a, 'b) opts -> string -> ('a, 'b) channel_t * string list

val channel_t_of_channel :
  ('a, 'b) opts -> in_channel -> ('a, 'b) channel_t * string list

val channel_t_of_xmls :
  ('a, 'b) opts -> xmltree list -> ('a, 'b) channel_t * string list
(** Read a channel from XML trees. These trees correspond to nodes under the
    ["channel"] XML node of a reguler RSS document. *)

val channel_of_file : string -> channel * string list
val channel_of_string : string -> channel * string list
val channel_of_channel : in_channel -> channel * string list

(** {2 Writing channels} *)

type 'a data_printer = 'a -> xmltree list

val print_channel :
  ?channel_data_printer:'a data_printer ->
  ?item_data_printer:'b data_printer ->
  ?indent:int ->
  ?encoding:string ->
  Format.formatter ->
  ('a, 'b) channel_t ->
  unit

val print_file :
  ?channel_data_printer:'a data_printer ->
  ?item_data_printer:'b data_printer ->
  ?indent:int ->
  ?encoding:string ->
  string ->
  ('a, 'b) channel_t ->
  unit
