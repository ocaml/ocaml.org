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

type metadata = {
  id : string;
  title : string;
  description : string;
  category : string;
  external_tutorial : external_tutorial option;
  recommended_next_tutorials : recommended_next_tutorials option;
}
[@@deriving of_yaml]

type t = {
  title : string;
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
}
[@@deriving
  stable_record ~version:metadata ~add:[ id ]
    ~modify:[ recommended_next_tutorials ]
    ~remove:[ slug; fpath; section; toc; body_md; body_html ],
    show { with_path = false }]

let of_metadata m =
  of_metadata m ~slug:m.id ~modify_recommended_next_tutorials:(function
    | None -> []
    | Some u -> u)

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
  | heading :: rest -> collect_children level ~max_level rest (acc @ [ heading ])

let headers (doc : Cmarkit.Doc.t) : Cmarkit.Block.Heading.t Cmarkit.node list =
  let rec headers_from_block (block : Cmarkit.Block.t) =
    match block with
    | Cmarkit.Block.Heading h -> [ h ]
    | Cmarkit.Block.Blocks (blocks, _) ->
        List.map headers_from_block blocks |> List.concat
    | _ -> []
  in

  Cmarkit.Doc.block doc |> headers_from_block

let toc ?(start_level = 1) ?(max_level = 2) doc =
  if max_level <= start_level then
    invalid_arg "toc: ~max_level must be >= ~start_level";
  create_toc ~max_level start_level (headers doc)

exception Missing_Tutorial of string

let check_tutorial_references all =
  let all_slugs = List.map (fun t -> t.slug) all in
  let tut_is_missing slug = not @@ List.mem slug all_slugs in
  let missing_tut_msg t missing =
    "The following recommended next tutorial(s) in " ^ t.fpath
    ^ " were not found: [" ^ String.concat "; " missing ^ "]"
  in
  let has_missing_tuts_exn t =
    match List.filter tut_is_missing t.recommended_next_tutorials with
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
  let toc = toc ~start_level:2 ~max_level:4 doc in
  let body_html = Hilite.Md.transform doc |> Cmarkit_html.of_doc ~safe:false in
  Result.map (of_metadata ~fpath ~section ~toc ~body_md ~body_html) metadata

let all () =
  Utils.map_files decode "tutorials/*.md"
  |> List.sort (fun t1 t2 -> String.compare t1.fpath t2.fpath)

let template () =
  let _ = any_recommended_next_tuts_are_missing_exn @@ all () in

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
type t =
  { title : string
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
  }
  
let all = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
