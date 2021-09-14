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

open Rss_types

(** Parsing/Printing RSS documents. *)

type xmltree =
  | E of Xmlm.tag * xmltree list
  | D of string

let string_of_xml ?ns_prefix ?indent tree =
  try
    let b = Buffer.create 256 in
    let output = Xmlm.make_output ?ns_prefix ~indent ~decl:false (`Buffer b) in
    let frag = function
      | E (tag, childs) ->
        `El (tag, childs)
      | D d ->
        `Data d
    in
    Xmlm.output_doc_tree frag output (None, tree);
    Buffer.contents b
  with
  | Xmlm.Error ((line, col), error) ->
    let msg =
      Printf.sprintf
        "Line %d, column %d: %s"
        line
        col
        (Xmlm.error_message error)
    in
    failwith msg

let source_string = function
  | `String (n, s) ->
    String.sub s n (String.length s - n)
  | `Channel _ | `Fun _ ->
    ""

(* [trim] borrowed from [String] to ensure that this code also compiles with
   OCaml 3.12. *)
let is_space = function ' ' | '\012' | '\n' | '\r' | '\t' -> true | _ -> false

let trim s =
  let len = String.length s in
  let i = ref 0 in
  while !i < len && is_space (String.unsafe_get s !i) do
    incr i
  done;
  let j = ref (len - 1) in
  while !j >= !i && is_space (String.unsafe_get s !j) do
    decr j
  done;
  if !i = 0 && !j = len - 1 then
    s
  else if !j >= !i then
    String.sub s !i (!j - !i + 1)
  else
    ""

let xml_of_source source =
  try
    let input =
      Xmlm.make_input
        ~strip:false
        ~enc:(Some `UTF_8)
        (*~entity: (fun s -> Some s)*) source
    in
    let el tag childs = E (tag, childs) in
    let data d = D (trim d) in
    let _, tree = Xmlm.input_doc_tree ~el ~data input in
    tree
  with
  | Xmlm.Error ((line, col), error) ->
    let msg =
      Printf.sprintf
        "Line %d, column %d: %s\n%s"
        line
        col
        (Xmlm.error_message error)
        (source_string source)
    in
    failwith msg
  | Invalid_argument e ->
    let msg = Printf.sprintf "%s:\n%s" e (source_string source) in
    failwith msg

(** {2 Parsing} *)

type ('a, 'b) opts =
  { mutable errors : string list
  ; read_channel_data : (xmltree list -> 'a option) option
  ; read_item_data : (xmltree list -> 'b option) option
  }

let add_error opts msg = opts.errors <- msg :: opts.errors

exception Error of string

let error msg = raise (Error msg)

let find_ele name e =
  let namespace, name =
    match String.split_on_char ':' name with
    | [ namespace; name ] ->
      namespace, name
    | [ name ] ->
      "", name
    | _ ->
      raise (Invalid_argument "invalid XML tag")
  in
  match e with
  | E (((n, e), _), _)
    when name = String.lowercase_ascii e && namespace = String.lowercase_ascii n
    ->
    true
  | E ((("http://purl.org/rss/1.0/", e), _), _)
    when name = String.lowercase_ascii e ->
    true
  | E (((n, e), _), _)
    when String.equal
           n
           ("http://purl.org/rss/1.0/modules/"
           ^ String.lowercase_ascii namespace
           ^ "/")
         && name = String.lowercase_ascii e ->
    true
  | _ ->
    false

let apply_opt f = function None -> None | Some v -> Some (f v)

let get_att ?ctx ?(required = true) atts name =
  let name = String.lowercase_ascii name in
  try
    snd
      (List.find
         (function ("", s), _ -> String.lowercase_ascii s = name | _ -> false)
         atts)
  with
  | Not_found ->
    if required then (
      match ctx with
      | None ->
        raise Not_found
      | Some (opts, tag) ->
        let msg = Printf.sprintf "Attribute %S not found in tag %S" name tag in
        add_error opts msg;
        raise Not_found)
    else
      ""

let get_opt_att atts name =
  let name = String.lowercase_ascii name in
  try
    Some
      (snd
         (List.find
            (function
              | ("", s), _ -> String.lowercase_ascii s = name | _ -> false)
            atts))
  with
  | Not_found ->
    None

let get_source opts xmls =
  try
    match List.find (find_ele "source") xmls with
    | E ((_, atts), [ D s ]) ->
      Some { src_name = s; src_url = Uri.of_string (get_att atts "url") }
    | _ ->
      None
  with
  | Error msg ->
    add_error opts msg;
    None
  | _ ->
    None

let get_enclosure opts xmls =
  try
    match List.find (find_ele "enclosure") xmls with
    | E ((_, atts), _) ->
      let ctx = opts, "enclosure" in
      Some
        { encl_url = Uri.of_string (get_att ~ctx atts "url")
        ; encl_length = int_of_string (get_att ~ctx atts "length")
        ; encl_type = get_att ~ctx atts "type"
        }
    | D _ ->
      assert false
  with
  | Error msg ->
    add_error opts msg;
    None
  | _ ->
    None

let get_categories opts xmls =
  let f acc = function
    | E ((("", tag), atts), [ D s ])
      when String.lowercase_ascii tag = "category" ->
      (try
         { cat_name = s
         ; cat_domain = apply_opt Uri.of_string (get_opt_att atts "domain")
         }
         :: acc
       with
      | Error msg ->
        add_error opts msg;
        acc)
    | _ ->
      acc
  in
  List.rev (List.fold_left f [] xmls)

let get_guid opts xmls =
  try
    match List.find (find_ele "guid") xmls with
    | E ((_, atts), [ D s ]) ->
      let x =
        match get_att ~required:false atts "ispermalink" with
        | "true" ->
          Guid_permalink (Uri.of_string s)
        | _ ->
          Guid_name s
      in
      Some x
    | _ ->
      None
  with
  | Error msg ->
    add_error opts msg;
    None
  | _ ->
    None

let get_cloud opts xmls =
  try
    match List.find (find_ele "cloud") xmls with
    | E ((_, atts), _) ->
      let get = get_att ~ctx:(opts, "cloud") atts in
      let port =
        let port = get "port" in
        try int_of_string port with
        | _ ->
          error (Printf.sprintf "Invalid cloud port %S" port)
      in
      Some
        { cloud_domain = get "domain"
        ; cloud_port = port
        ; cloud_path = get "path"
        ; cloud_register_procedure = get "registerprocedure"
        ; cloud_protocol = get "protocol"
        }
    | D _ ->
      assert false
  with
  | Error msg ->
    add_error opts msg;
    None
  | _ ->
    None

let find_sub_cdata tag xmls name =
  try
    match List.find (find_ele name) xmls with
    | E ((_, _), [ D s ]) ->
      s
    | E ((_, _), []) ->
      ""
    | _ ->
      let msg =
        Printf.sprintf "Invalid contents for node %S under %S" name tag
      in
      error msg
  with
  | Not_found ->
    let msg = Printf.sprintf "No node %S in node %S" name tag in
    error msg

let get_image opts xmls =
  try
    match List.find (find_ele "image") xmls with
    | E ((_, _atts), subs) ->
      let f = find_sub_cdata "image" xmls in
      let f_opt s =
        try
          match List.find (find_ele s) subs with
          | E ((_, _), [ D s ]) ->
            Some (f s)
          | _ ->
            None
        with
        | _ ->
          None
      in
      Some
        { image_url = Uri.of_string (f "url")
        ; image_title = f "title"
        ; image_link = Uri.of_string (f "link")
        ; image_width = apply_opt int_of_string (f_opt "width")
        ; image_height = apply_opt int_of_string (f_opt "height")
        ; image_desc = f_opt "description"
        }
    | D _ ->
      assert false
  with
  | Error msg ->
    add_error opts msg;
    None
  | _ ->
    None

let get_text_input opts xmls =
  try
    match List.find (find_ele "textinput") xmls with
    | E ((_, _atts), _subs) ->
      let f = find_sub_cdata "textInput" xmls in
      Some
        { ti_title = f "title"
        ; ti_desc = f "description"
        ; ti_name = f "name"
        ; ti_link = Uri.of_string (f "link")
        }
    | D _ ->
      assert false
  with
  | Error msg ->
    add_error opts msg;
    None
  | _ ->
    None

let filter_prefixed_nodes =
  List.filter (function D _ | E ((("", _), _), _) -> false | _ -> true)

let read_ns_data f xmls =
  match f with
  | None ->
    None
  | Some f ->
    let xmls = filter_prefixed_nodes xmls in
    f xmls

let item_of_xmls opts xmls =
  let f_opt s = try Some (find_sub_cdata "item" xmls s) with _ -> None in
  let date =
    match f_opt "pubdate" with
    | None ->
      None
    | Some s ->
      (try Some (Rfc822.parse_exn s) with
      | _ ->
        add_error opts (Printf.sprintf "Invalid date %S" s);
        None)
  in
  let data =
    try read_ns_data opts.read_item_data xmls with
    | Error msg ->
      add_error opts msg;
      None
  in
  try
    let item =
      { item_title = f_opt "title"
      ; item_link = apply_opt Uri.of_string (f_opt "link")
      ; item_desc = f_opt "description"
      ; item_pubdate = date
      ; item_author = f_opt "author"
      ; item_categories = get_categories opts xmls
      ; item_comments = apply_opt Uri.of_string (f_opt "comments")
      ; item_enclosure = get_enclosure opts xmls
      ; item_guid = get_guid opts xmls
      ; item_source = get_source opts xmls
      ; item_content = f_opt "content:encoded"
      ; item_data = data
      }
    in
    Some item
  with
  | Error msg ->
    add_error opts msg;
    None

let items_of_xmls opts xmls =
  List.rev
    (List.fold_left
       (fun acc e ->
         match e with
         | D _ ->
           acc
         | E ((("", s), _), subs) when String.lowercase_ascii s = "item" ->
           (match item_of_xmls opts subs with
           | None ->
             acc
           | Some item ->
             item :: acc)
         | E _ ->
           acc)
       []
       xmls)

let get_skip_hours opts xmls =
  try
    let f_hour acc = function
      | E ((("", "hour"), _), [ D s ]) ->
        (match
           try
             let h = int_of_string s in
             if h < 0 || h > 23 then failwith "";
             Some h
           with
           | _ ->
             add_error opts (Printf.sprintf "Invalid hour %S" s);
             None
         with
        | None ->
          acc
        | Some h ->
          h :: acc)
      | _ ->
        acc
    in
    match List.find (find_ele "skiphours") xmls with
    | E ((_, _), subs) ->
      Some (List.sort compare (List.fold_left f_hour [] subs))
    | D _ ->
      assert false
  with
  | Error msg ->
    add_error opts msg;
    None
  | _ ->
    None

let int_of_day = function
  | "sunday" ->
    0
  | "monday" ->
    1
  | "tuesday" ->
    2
  | "wednesday" ->
    3
  | "thursday" ->
    4
  | "friday" ->
    5
  | "saturday" ->
    6
  | s ->
    failwith (Printf.sprintf "Invalid day %S" s)

let day_of_int = function
  | 0 ->
    "Sunday"
  | 1 ->
    "Monday"
  | 2 ->
    "Tuesday"
  | 3 ->
    "Wednesday"
  | 4 ->
    "Thursday"
  | 5 ->
    "Friday"
  | 6 ->
    "Saturday"
  | n ->
    failwith ("Invalid day " ^ string_of_int n)

let get_skip_days opts xmls =
  let f_day acc = function
    | E ((("", "day"), _), [ D day ]) ->
      (try int_of_day day :: acc with
      | Failure msg ->
        add_error opts msg;
        acc)
    | _ ->
      acc
  in
  try
    match List.find (find_ele "skipdays") xmls with
    | E ((_, _), subs) ->
      Some (List.sort compare (List.fold_left f_day [] subs))
    | D _ ->
      assert false
  with
  | Error msg ->
    add_error opts msg;
    None
  | _ ->
    None

let channel_of_xmls opts xmls =
  let f s =
    try find_sub_cdata "channel" xmls s with Error msg -> failwith msg
  in
  let f_opt s = try Some (f s) with _ -> None in
  let pubdate =
    match f_opt "pubdate" with
    | None ->
      None
    | Some s ->
      (try Some (Rfc822.parse_exn s) with
      | _ ->
        add_error opts (Printf.sprintf "Invalid date %S" s);
        None)
  in
  let builddate =
    match f_opt "lastbuilddate" with
    | None ->
      None
    | Some s ->
      (try Some (Rfc822.parse_exn s) with
      | _ ->
        add_error opts (Printf.sprintf "Invalid date %S" s);
        None)
  in
  let ttl =
    match f_opt "ttl" with
    | None ->
      None
    | Some s ->
      (try Some (int_of_string s) with
      | _ ->
        add_error opts (Printf.sprintf "Invalid ttl %S" s);
        None)
  in
  let link = try Uri.of_string (f "link") with Error msg -> failwith msg in
  let docs =
    try apply_opt Uri.of_string (f_opt "docs") with
    | Error msg ->
      add_error opts msg;
      None
  in
  let data =
    try read_ns_data opts.read_channel_data xmls with
    | Error msg ->
      add_error opts msg;
      None
  in
  { ch_title = f "title"
  ; ch_link = link
  ; ch_desc = f "description"
  ; ch_language = f_opt "language"
  ; ch_copyright = f_opt "copyright"
  ; ch_managing_editor = f_opt "managingeditor"
  ; ch_webmaster = f_opt "webmaster"
  ; ch_pubdate = pubdate
  ; ch_last_build_date = builddate
  ; ch_categories = get_categories opts xmls
  ; ch_generator = f_opt "generator"
  ; ch_cloud = get_cloud opts xmls
  ; ch_docs = docs
  ; ch_ttl = ttl
  ; ch_image = get_image opts xmls
  ; ch_rating = f_opt "rating"
  ; ch_text_input = get_text_input opts xmls
  ; ch_skip_hours = get_skip_hours opts xmls
  ; ch_skip_days = get_skip_days opts xmls
  ; ch_items = items_of_xmls opts xmls
  ; ch_data = data
  ; ch_namespaces = []
  }

let channel_of_source opts source =
  let xml = xml_of_source source in
  let opts = { opts with errors = [] } in
  match xml with
  | D _ ->
    failwith "Parse error: not an element"
  | E (((_, e), atts), subs) ->
    let channel, errors =
      match String.lowercase_ascii e with
      | "rss" ->
        (try
           let elt = List.find (find_ele "channel") subs in
           match elt with
           | E ((("", _), _atts), subs) ->
             channel_of_xmls opts subs, opts.errors
           | _ ->
             assert false
         with
        | Not_found ->
          failwith "Parse error: no channel")
      | "rdf" ->
        (try
           let elt = List.find (find_ele "channel") subs in
           match elt with
           | E ((_, _atts), subs_ch) ->
             channel_of_xmls opts (subs_ch @ subs), opts.errors
           | _ ->
             assert false
         with
        | Not_found ->
          failwith "Parse error: not channel")
      | _ ->
        failwith "Parse error: not rss"
    in
    let namespaces =
      let f ((prefix, name), value) acc =
        if prefix = Xmlm.ns_xmlns && name <> "xmlns" then
          (name, value) :: acc
        else
          acc
      in
      List.fold_right f atts []
    in
    { channel with ch_namespaces = namespaces }, errors

let make_opts ?read_channel_data ?read_item_data () =
  { errors = []; read_item_data; read_channel_data }

let default_opts = make_opts ()

let channel_of_string opts s = channel_of_source opts (`String (0, s))

let channel_of_file opts file =
  let ic = open_in file in
  try channel_of_source opts (`Channel ic) with
  | e ->
    close_in ic;
    raise e

let channel_of_channel opts ch = channel_of_source opts (`Channel ch)

let channel_of_xmls opts xmls = channel_of_xmls opts xmls, opts.errors

(** {2 Printing} *)

let opt_element opt s =
  match opt with None -> [] | Some v -> [ E ((("", s), []), [ D v ]) ]

let default_date_format = "%d %b %Y %T %z"

let xml_of_category c =
  let atts =
    match c.cat_domain with
    | None ->
      []
    | Some d ->
      [ ("", "domain"), Uri.to_string d ]
  in
  E ((("", "category"), atts), [ D c.cat_name ])

let xmls_of_categories l = List.map xml_of_category l

let xmls_of_opt_f f v_opt = match v_opt with None -> [] | Some v -> [ f v ]

let xml_of_enclosure e =
  E
    ( ( ("", "enclosure")
      , [ ("", "url"), Uri.to_string e.encl_url
        ; ("", "length"), string_of_int e.encl_length
        ; ("", "type"), e.encl_type
        ] )
    , [] )

let xmls_of_enclosure_opt = xmls_of_opt_f xml_of_enclosure

let xml_of_guid = function
  | Guid_permalink url ->
    E
      ( (("", "guid"), [ ("", "isPermaLink"), "true" ])
      , [ D (Uri.to_string url) ] )
  | Guid_name name ->
    E ((("", "guid"), []), [ D name ])

let xmls_of_guid_opt = xmls_of_opt_f xml_of_guid

let xml_of_source_field s =
  E
    ( (("", "source"), [ ("", "url"), Uri.to_string s.src_url ])
    , [ D s.src_name ] )

let xmls_of_source_opt = xmls_of_opt_f xml_of_source_field

let xml_of_image i =
  E
    ( (("", "image"), [])
    , [ E ((("", "url"), []), [ D (Uri.to_string i.image_url) ])
      ; E ((("", "title"), []), [ D i.image_title ])
      ; E ((("", "link"), []), [ D (Uri.to_string i.image_link) ])
      ]
      @ List.flatten
          [ opt_element (apply_opt string_of_int i.image_width) "width"
          ; opt_element (apply_opt string_of_int i.image_height) "height"
          ; opt_element i.image_desc "description"
          ] )

let xmls_of_image_opt = xmls_of_opt_f xml_of_image

let xml_of_cloud c =
  let atts =
    [ ("", "domain"), c.cloud_domain
    ; ("", "port"), string_of_int c.cloud_port
    ; ("", "path"), c.cloud_path
    ; ("", "registerProcedure"), c.cloud_register_procedure
    ; ("", "protocol"), c.cloud_protocol
    ]
  in
  E ((("", "cloud"), atts), [])

let xmls_of_cloud_opt = xmls_of_opt_f xml_of_cloud

let xml_of_skip_hours =
  let f h = E ((("", "hour"), []), [ D (string_of_int h) ]) in
  fun hours -> E ((("", "hours"), []), List.map f hours)

let xmls_of_skip_hours_opt = xmls_of_opt_f xml_of_skip_hours

let xml_of_skip_days =
  let f day =
    let s = day_of_int day in
    E ((("", "day"), []), [ D s ])
  in
  fun days -> E ((("", "days"), []), List.map f days)

let xmls_of_skip_days_opt = xmls_of_opt_f xml_of_skip_days

let xml_of_text_input t =
  E
    ( (("", "textInput"), [])
    , [ E ((("", "title"), []), [ D t.ti_title ])
      ; E ((("", "description"), []), [ D t.ti_desc ])
      ; E ((("", "name"), []), [ D t.ti_name ])
      ; E ((("", "link"), []), [ D (Uri.to_string t.ti_link) ])
      ] )

let xmls_of_text_input_opt = xmls_of_opt_f xml_of_text_input

let xml_of_item ?item_data_printer i =
  let data_xml =
    match i.item_data, item_data_printer with
    | None, _ | _, None ->
      []
    | Some data, Some p ->
      p data
  in
  E
    ( (("", "item"), [])
    , List.flatten
        [ opt_element i.item_title "title"
        ; opt_element (apply_opt Uri.to_string i.item_link) "link"
        ; opt_element i.item_desc "description"
        ; opt_element
            (match i.item_pubdate with
            | None ->
              None
            | Some d ->
              Some (Format.asprintf "%a" Ptime.pp d))
            "pubDate"
        ; opt_element i.item_author "author"
        ; xmls_of_categories i.item_categories
        ; opt_element (apply_opt Uri.to_string i.item_comments) "comments"
        ; xmls_of_enclosure_opt i.item_enclosure
        ; xmls_of_guid_opt i.item_guid
        ; xmls_of_source_opt i.item_source
        ; data_xml
        ] )

let xml_of_channel ?channel_data_printer ?item_data_printer ch =
  let f v s = E ((("", s), []), [ D v ]) in
  let data_xml =
    match ch.ch_data, channel_data_printer with
    | None, _ | _, None ->
      []
    | Some data, Some p ->
      p data
  in
  let xml_ch =
    E
      ( (("", "channel"), [])
      , [ f ch.ch_title "title"
        ; f (Uri.to_string ch.ch_link) "link"
        ; f ch.ch_desc "description"
        ]
        @ List.flatten
            [ opt_element ch.ch_language "language"
            ; opt_element ch.ch_copyright "copyright"
            ; opt_element ch.ch_managing_editor "managingEditor"
            ; opt_element ch.ch_webmaster "webMaster"
            ; opt_element
                (match ch.ch_pubdate with
                | None ->
                  None
                | Some d ->
                  Some (Format.asprintf "%a" Ptime.pp d))
                "pubDate"
            ; opt_element
                (match ch.ch_last_build_date with
                | None ->
                  None
                | Some d ->
                  Some (Format.asprintf "%a" Ptime.pp d))
                "lastBuildDate"
            ; xmls_of_categories ch.ch_categories
            ; opt_element ch.ch_generator "generator"
            ; xmls_of_cloud_opt ch.ch_cloud
            ; opt_element (apply_opt Uri.to_string ch.ch_docs) "docs"
            ; opt_element (apply_opt string_of_int ch.ch_ttl) "ttl"
            ; xmls_of_image_opt ch.ch_image
            ; opt_element ch.ch_rating "rating"
            ; xmls_of_text_input_opt ch.ch_text_input
            ; xmls_of_skip_hours_opt ch.ch_skip_hours
            ; xmls_of_skip_days_opt ch.ch_skip_days
            ; data_xml
            ; List.map (xml_of_item ?item_data_printer) ch.ch_items
            ] )
  in
  E ((("", "rss"), [ ("", "version"), "2.0" ]), [ xml_ch ])

module SMap = Map.Make (struct
  type t = string

  let compare = compare
end)

let print_channel
    ?channel_data_printer
    ?item_data_printer
    ?indent
    ?(encoding = "UTF-8")
    fmt
    ch
  =
  let xml = xml_of_channel ?channel_data_printer ?item_data_printer ch in
  let known_ns =
    List.fold_left
      (fun map (name, url) -> SMap.add url name map)
      SMap.empty
      ch.ch_namespaces
  in
  let ns_prefix url =
    try Some (SMap.find url known_ns) with Not_found -> None
  in
  let xml =
    match xml with
    | D _ ->
      assert false
    | E ((tag, atts), subs) ->
      let f acc (name, url) = ((Xmlm.ns_xmlns, name), url) :: acc in
      let atts = List.rev (List.fold_left f atts ch.ch_namespaces) in
      E ((tag, atts), subs)
  in
  Format.fprintf fmt "<?xml version=\"1.0\" encoding=\"%s\" ?>\n" encoding;
  Format.fprintf fmt "%s" (string_of_xml ~ns_prefix ?indent xml)
