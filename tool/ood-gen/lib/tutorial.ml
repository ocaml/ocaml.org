module Section = struct
  type t = GetStarted | Language | Platform | Guides
  [@@deriving show { with_path = false }]

  let of_string = function
    | "getting-started" -> Ok GetStarted
    | "language" -> Ok Language
    | "platform" -> Ok Platform
    | "guides" -> Ok Guides
    | s -> Error (`Msg ("Unknown section: " ^ s))
end

type toc = { title : string; href : string; children : toc list }
[@@deriving show { with_path = false }]

type contribute_link = { url : string; description : string }
[@@deriving of_yaml, show { with_path = false }]

type banner = { image : string; url : string; alt : string }
[@@deriving of_yaml, show { with_path = false }]

type external_tutorial = {
  tag : string;
  contribute_link : contribute_link;
  banner : banner;
}
[@@deriving of_yaml, show { with_path = false }]

type recommended_next_tutorials = string list
[@@deriving of_yaml, show { with_path = false }]

type prerequisite_tutorials = string list
[@@deriving of_yaml, show { with_path = false }]

type metadata = {
  id : string;
  title : string;
  short_title : string;
  description : string;
  category : string;
  external_tutorial : external_tutorial option;
  recommended_next_tutorials : recommended_next_tutorials option;
  prerequisite_tutorials : prerequisite_tutorials option;
}
[@@deriving of_yaml]

type search_document = {
  title : string;
  category : string;
  section_heading : string;
  content : string;
  slug : string;
}
[@@deriving show { with_path = false }]

type t = {
  title : string;
  short_title : string;
  slug : string;
  fpath : string;
  description : string;
  section : Section.t;
  category : string;
  external_tutorial : external_tutorial option;
  toc : toc list;
  body_md : string;
  body_html : string;
  recommended_next_tutorials : recommended_next_tutorials;
  prerequisite_tutorials : prerequisite_tutorials;
}
[@@deriving
  stable_record ~version:metadata ~add:[ id ]
    ~modify:[ recommended_next_tutorials; prerequisite_tutorials ]
    ~remove:[ slug; fpath; section; toc; body_md; body_html ],
    show { with_path = false }]

let of_metadata m =
  of_metadata m ~slug:m.id
    ~modify_recommended_next_tutorials:(function None -> [] | Some u -> u)
    ~modify_prerequisite_tutorials:(function None -> [] | Some u -> u)

module Toc = struct
  let id_to_href id =
    match id with
    | None -> "#"
    | Some (`Auto id) -> "#" ^ id
    | Some (`Id id) -> "#" ^ id

  let rec create_toc ~max_level level
      (headings : Cmarkit.Block.Heading.t Cmarkit.node list) : toc list =
    match headings with
    | [] -> []
    | (h, _) :: rest when Cmarkit.Block.Heading.level h > max_level ->
        create_toc ~max_level level rest
    | (h, _) :: rest when Cmarkit.Block.Heading.level h = level ->
        let l = Cmarkit.Block.Heading.level h in
        let child_headings, remaining_headings =
          collect_children ~max_level (l + 1) rest []
        in
        let children = create_toc ~max_level (l + 1) child_headings in
        let title =
          Cmarkit.Inline.to_plain_text ~break_on_soft:false
            (Cmarkit.Block.Heading.inline h)
        in
        {
          title = String.concat "\n" (List.map (String.concat "") title);
          href = id_to_href (Cmarkit.Block.Heading.id h);
          children;
        }
        :: create_toc ~max_level level remaining_headings
    | (h, _) :: _ when Cmarkit.Block.Heading.level h > level ->
        create_toc ~max_level (level + 1) headings
    | _ :: rest -> create_toc ~max_level level rest

  and collect_children ~max_level level
      (headings : Cmarkit.Block.Heading.t Cmarkit.node list) acc =
    match headings with
    | [] -> (acc, [])
    | (h, _) :: rest when Cmarkit.Block.Heading.level h > max_level ->
        collect_children ~max_level level rest acc
    | (h, _) :: _ when Cmarkit.Block.Heading.level h < level -> (acc, headings)
    | heading :: rest ->
        collect_children level ~max_level rest (acc @ [ heading ])

  let headers (doc : Cmarkit.Doc.t) : Cmarkit.Block.Heading.t Cmarkit.node list
      =
    let rec headers_from_block (block : Cmarkit.Block.t) =
      match block with
      | Cmarkit.Block.Heading h -> [ h ]
      | Cmarkit.Block.Blocks (blocks, _) ->
          List.map headers_from_block blocks |> List.concat
      | _ -> []
    in

    Cmarkit.Doc.block doc |> headers_from_block

  let generate ?(start_level = 1) ?(max_level = 2) doc =
    if max_level <= start_level then
      invalid_arg "toc: ~max_level must be >= ~start_level";
    create_toc ~max_level start_level (headers doc)
end

module Search = struct
  let rec flatten_block (block : Cmarkit.Block.t) : Cmarkit.Block.t list =
    match block with
    | Cmarkit.Block.Blocks (blocks, _) ->
        blocks |> List.map flatten_block |> List.flatten (*flatten the blocks *)
    | x -> [ x ]

  let rec collect_blocks_until_heading (block : Cmarkit.Block.t list) acc =
    match block with
    | [] -> (acc, [])
    | Cmarkit.Block.Heading (_, _) :: _ -> (acc, block)
    | Cmarkit.Block.Blocks (blocks, _) :: _ ->
        blocks |> collect_blocks_until_heading []
    | h :: t -> collect_blocks_until_heading t (h :: acc)

  (* collects a section by its heading and content *)
  let collect_section (blocks : Cmarkit.Block.t list) :
      ( (string * Cmarkit.Block.t list) * Cmarkit.Block.t list,
        [> `Msg of string ] )
      result =
    match blocks with
    | Cmarkit.Block.Heading (h, _) :: t ->
        let collected_blocks, remaining_blocks =
          collect_blocks_until_heading t []
        in
        Ok
          ( ( Cmarkit.Block.Heading.inline h
              |> Cmarkit.Inline.to_plain_text ~break_on_soft:false
              |> List.flatten |> String.concat "\n",
              collected_blocks ),
            remaining_blocks )
    | _ :: t ->
        let collected_blocks, remaining_blocks =
          collect_blocks_until_heading t []
        in
        Ok (("", collected_blocks), remaining_blocks)
    | [] -> Error (`Msg "empty list in the document")

  let rec block_to_string (block : Cmarkit.Block.t) : string =
    match block with
    | Cmarkit.Block.Blank_line _ -> ""
    | Cmarkit.Block.Block_quote (p, _) ->
        Cmarkit.Block.Block_quote.block p |> block_to_string
    | Cmarkit.Block.Code_block _ -> ""
    | Cmarkit.Block.Heading (h, _) ->
        Cmarkit.Block.Heading.inline h
        |> Cmarkit.Inline.to_plain_text ~break_on_soft:false
        |> List.flatten |> String.concat "\n"
    | Cmarkit.Block.Html_block (block_lines, _) ->
        let rec block_lines_to_string (block_lines : Cmarkit.Block_line.t list)
            : string =
          match block_lines with
          | [] -> ""
          | h :: t ->
              Cmarkit.Block_line.to_string h ^ "\n" ^ block_lines_to_string t
        in
        block_lines_to_string block_lines
    | Cmarkit.Block.List (l, _) ->
        let items =
          Cmarkit.Block.List'.items l |> List.map (fun (item, _) -> item)
        in
        items
        |> List.map Cmarkit.Block.List_item.block
        |> List.map block_to_string |> String.concat "\n"
    | Cmarkit.Block.Link_reference_definition (l, _) ->
        Cmarkit.Link_definition.label l
        |> Option.map Cmarkit.Label.text
        |> Option.value ~default:[]
        |> List.map Cmarkit.Block_line.tight_to_string
        |> String.concat " "
    | Cmarkit.Block.Paragraph (p, _) ->
        Cmarkit.Block.Paragraph.inline p
        |> Cmarkit.Inline.to_plain_text ~break_on_soft:false
        |> List.flatten |> String.concat "\n"
    | Cmarkit.Block.Blocks (blocks, _) ->
        blocks |> List.map block_to_string |> String.concat "\n"
    | Cmarkit.Block.Thematic_break _ -> ""
    | _ -> ""

  let rec collect_all_sections (section_blocks : Cmarkit.Block.t list) =
    match collect_section section_blocks with
    | Ok (section, remaining_blocks) ->
        if remaining_blocks <> [] then
          section :: collect_all_sections remaining_blocks
        else [ section ]
    | Error (`Msg msg) -> failwith msg

  let document_from_section
      ((heading : string), (content : Cmarkit.Block.t list))
      ~(metadata : metadata) : search_document =
    let section_document =
      {
        title = metadata.title;
        category = metadata.category;
        section_heading = heading;
        content = content |> List.map block_to_string |> String.concat "\n";
        slug = metadata.id;
      }
    in
    section_document

  let decode_search_document (_fpath, (head, body_md)) :
      (search_document list, [> `Msg of string ]) result =
    match metadata_of_yaml head with
    | Ok metadata ->
        let content_blocks =
          body_md |> Cmarkit.Doc.of_string |> Cmarkit.Doc.block
        in
        let document =
          content_blocks |> flatten_block |> collect_all_sections
          |> List.map (document_from_section ~metadata)
        in
        Ok document
    | Error msg -> Error msg
end

exception Missing_Tutorial of string

let check_tutorial_references all =
  let all_slugs = List.map (fun t -> t.slug) all in
  let tut_is_missing slug = not @@ List.mem slug all_slugs in
  let missing_tut_msg t missing =
    "The following recommended next tutorial(s) in " ^ t.fpath
    ^ " were not found: [" ^ String.concat "; " missing ^ "]"
  in
  let has_missing_tuts_exn t =
    match
      List.filter tut_is_missing t.recommended_next_tutorials
      @ List.filter tut_is_missing t.prerequisite_tutorials
    with
    | [] -> ()
    | missing -> raise (Missing_Tutorial (missing_tut_msg t missing))
  in

  List.iter has_missing_tuts_exn all

let decode (fpath, (head, body_md)) =
  let metadata =
    metadata_of_yaml head |> Result.map_error (Utils.where fpath)
  in
  let section =
    List.nth (String.split_on_char '/' fpath) 1
    |> Section.of_string |> Result.get_ok
  in
  let doc = Cmarkit.Doc.of_string ~strict:true ~heading_auto_ids:true body_md in
  let toc = Toc.generate ~start_level:2 ~max_level:4 doc in
  let body_html = Hilite.Md.transform doc |> Cmarkit_html.of_doc ~safe:false in
  Result.map (of_metadata ~fpath ~section ~toc ~body_md ~body_html) metadata

let all () =
  Utils.map_files decode "tutorials/*.md"
  |> List.sort (fun t1 t2 -> String.compare t1.fpath t2.fpath)

let all_search_documents () : search_document list =
  Utils.map_files Search.decode_search_document "tutorials/*.md" |> List.flatten

let template () =
  let _ = check_tutorial_references @@ all () in

  Format.asprintf
    {|
module Section = struct
  type t = GetStarted | Language | Platform | Guides
end
type toc =
  { title : string
  ; href : string
  ; children : toc list
  }

type contribute_link =
  { url : string
  ; description : string
  }
type banner =
  { image : string
  ; url : string
  ; alt : string
  }
type external_tutorial =
  { tag : string
  ; banner : banner
  ; contribute_link : contribute_link
  }
type recommended_next_tutorials = string list
type prerequisite_tutorials = string list

type search_document =
{ title : string
  ; category : string
  ; section_heading : string
  ; content : string
  ; slug : string
}

type t =
  { title : string
  ; short_title: string
  ; fpath : string
  ; slug : string
  ; description : string
  ; section : Section.t
  ; category : string
  ; external_tutorial : external_tutorial option
  ; body_md : string
  ; toc : toc list
  ; body_html : string
  ; recommended_next_tutorials : recommended_next_tutorials
  ; prerequisite_tutorials : prerequisite_tutorials
  }
  
let all = %a
let all_search_documents =
  %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
    (Fmt.brackets (Fmt.list pp_search_document ~sep:Fmt.semi))
    (all_search_documents ())
