type proficiency =
  [ `Beginner
  | `Intermediate
  | `Advanced
  ]

type metadata =
  { title : string
  ; description : string
  ; date : string
  ; tags : string list
  ; users : string list
  }
[@@deriving yaml]

let path = Fpath.v "data/tutorials/en"

let parse content =
  let metadata, _ = Utils.extract_metadata_body content in
  metadata_of_yaml metadata

type t =
  { title : string
  ; slug : string
  ; description : string
  ; date : string
  ; tags : string list
  ; users : proficiency list
  ; toc_html : string
  ; body_md : string
  ; body_html : string
  }

let proficiency_list_of_string_list =
  List.map (fun x ->
      match Meta.Proficiency.of_string x with
      | Ok x ->
        x
      | Error (`Msg err) ->
        raise (Exn.Decode_error err))

let to_plain_text t =
  let buf = Buffer.create 1024 in
  let rec go : _ Omd.inline -> unit = function
    | Concat (_, l) ->
      List.iter go l
    | Text (_, t) | Code (_, t) ->
      Buffer.add_string buf t
    | Emph (_, i)
    | Strong (_, i)
    | Link (_, { label = i; _ })
    | Image (_, { label = i; _ }) ->
      go i
    | Hard_break _ | Soft_break _ ->
      Buffer.add_char buf ' '
    | Html _ ->
      ()
  in
  go t;
  Buffer.contents buf

let doc_with_ids doc =
  let open Omd in
  List.map
    (function
      | Heading (attr, level, inline) ->
        let attr =
          match List.assoc_opt "id" attr with
          | Some _ ->
            attr
          | None ->
            ("id", Utils.slugify (to_plain_text inline)) :: attr
        in
        Heading (attr, level, inline)
      | el ->
        el)
    doc

let all () =
  Utils.map_files
    (fun content ->
      let metadata, body = Utils.extract_metadata_body content in
      let metadata = Utils.decode_or_raise metadata_of_yaml metadata in
      let omd = doc_with_ids (Omd.of_string body) in
      { title = metadata.title
      ; slug = Utils.slugify metadata.title
      ; description = metadata.description
      ; date = metadata.date
      ; tags = metadata.tags
      ; users = proficiency_list_of_string_list metadata.users
      ; toc_html = Omd.to_html (Omd.toc ~depth:4 omd)
      ; body_md = body
      ; body_html = Omd.to_html (Hilite.Md.transform omd)
      })
    "tutorials/en/*.md"

let pp_proficiency ppf v =
  Fmt.pf
    ppf
    "%s"
    (match v with
    | `Beginner ->
      "`Beginner"
    | `Intermediate ->
      "`Intermediate"
    | `Advanced ->
      "`Advanced")

let pp ppf v =
  Fmt.pf
    ppf
    {|
  { title = %a
  ; slug = %a
  ; description = %a
  ; date = %a
  ; tags = %a
  ; users = %a
  ; body_md = %a
  ; toc_html = %a
  ; body_html = %a
  }|}
    Pp.string
    v.title
    Pp.string
    v.slug
    Pp.string
    v.description
    Pp.string
    v.date
    Pp.string_list
    v.tags
    (Pp.list pp_proficiency)
    v.users
    Pp.string
    v.body_md
    Pp.string
    v.toc_html
    Pp.string
    v.body_html

let pp_list = Pp.list pp

let template () =
  Format.asprintf
    {|
type difficulty =
  [ `Beginner
  | `Intermediate
  | `Advanced
  ]

type t =
  { title : string
  ; slug : string
  ; description : string
  ; date : string
  ; tags : string list
  ; users : difficulty list
  ; body_md : string
  ; toc_html : string
  ; body_html : string
  }
  
let all = %a
|}
    pp_list
    (all ())
