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

type metadata = {
  id : string;
  title : string;
  description : string;
  category : string;
}
[@@deriving of_yaml]

type t = {
  title : string;
  slug : string;
  fpath : string;
  description : string;
  section : Section.t;
  category : string;
  toc : toc list;
  body_md : string;
  body_html : string;
}
[@@deriving
  stable_record ~version:metadata ~add:[ id ]
    ~remove:[ slug; fpath; section; toc; body_md; body_html ],
    show { with_path = false }]

let of_metadata m = of_metadata m ~slug:m.id

(* Copied from ocaml/omd, html.ml *)
let to_plain_text t =
  let buf = Buffer.create 1024 in
  let rec go : _ Omd.inline -> unit = function
    | Concat (_, l) -> List.iter go l
    | Text (_, t) | Code (_, t) -> Buffer.add_string buf t
    | Emph (_, i)
    | Strong (_, i)
    | Link (_, { label = i; _ })
    | Image (_, { label = i; _ }) ->
        go i
    | Hard_break _ | Soft_break _ -> Buffer.add_char buf ' '
    | Html _ -> ()
  in
  go t;
  Buffer.contents buf

let doc_with_ids doc =
  let open Omd in
  List.map
    (function
      | Heading (attr, level, inline) ->
          let id, attr = List.partition (fun (key, _) -> key = "id") attr in
          let id =
            match id with
            | [] -> Utils.slugify (to_plain_text inline)
            | (_, slug) :: _ -> slug (* Discard extra ids *)
          in
          let link : _ Omd.link =
            { label = Text (attr, ""); destination = "#" ^ id; title = None }
          in
          Heading
            ( ("id", id) :: attr,
              level,
              Concat ([], [ Link ([ ("class", "anchor") ], link); inline ]) )
      | el -> el)
    doc

(* emit a structured toc from the Omd.doc *)
let find_id attributes =
  List.find_map
    (function k, v when String.equal "id" k -> Some v | _ -> None)
    attributes

let href_of attributes =
  match find_id attributes with None -> "#" | Some id -> "#" ^ id

let rec create_toc ~max_level level
    (headings : ('attr * int * 'a Omd.inline) list) : toc list =
  match headings with
  | [] -> []
  | (_, l, _) :: rest when l > max_level -> create_toc ~max_level level rest
  | (attrs, l, title) :: rest when l = level ->
      let child_headings, remaining_headings =
        collect_children ~max_level (l + 1) rest []
      in
      let children = create_toc ~max_level (l + 1) child_headings in
      { title = to_plain_text title; href = href_of attrs; children }
      :: create_toc ~max_level level remaining_headings
  | (_, l, _) :: _ when l > level -> create_toc ~max_level (level + 1) headings
  | _ :: rest -> create_toc ~max_level level rest

and collect_children ~max_level level
    (headings : ('attr * int * 'a Omd.inline) list) acc =
  match headings with
  | [] -> (acc, [])
  | (_, l, _) :: rest when l > max_level ->
      collect_children ~max_level level rest acc
  | (_, l, _) :: _ when l < level -> (acc, headings)
  | heading :: rest -> collect_children level ~max_level rest (acc @ [ heading ])

let toc ?(start_level = 1) ?(max_level = 2) doc =
  if max_level <= start_level then
    invalid_arg "toc: ~max_level must be >= ~start_level";
  let headers = Omd.headers ~remove_links:true doc in
  create_toc ~max_level start_level headers

let decode (fpath, (head, body_md)) =
  let metadata = metadata_of_yaml head in
  let section =
    List.nth (String.split_on_char '/' fpath) 1
    |> Section.of_string |> Result.get_ok
  in
  let omd = doc_with_ids (Omd.of_string body_md) in
  let toc = toc ~start_level:2 ~max_level:4 omd in
  let body_html = Omd.to_html omd in
  Result.map (of_metadata ~fpath ~section ~toc ~body_md ~body_html) metadata

let all () =
  Utils.map_files decode "tutorials/*.md"
  |> List.sort (fun t1 t2 -> String.compare t1.fpath t2.fpath)

let template () =
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
type t =
  { title : string
  ; fpath : string
  ; slug : string
  ; description : string
  ; section : Section.t
  ; category : string
  ; body_md : string
  ; toc : toc list
  ; body_html : string
  }
  
let all = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
