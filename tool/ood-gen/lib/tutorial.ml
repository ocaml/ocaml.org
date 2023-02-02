type metadata = {
  id : string;
  title : string;
  description : string;
  date : string;
  category : string;
}
[@@deriving of_yaml]

type t = {
  title : string;
  slug : string;
  fpath : string;
  description : string;
  date : string;
  category : string;
  toc_html : string;
  body_md : string;
  body_html : string;
}
[@@deriving
  stable_record ~version:metadata ~add:[ id ]
    ~remove:[ slug; fpath; toc_html; body_md; body_html ]]

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

let filter_heading_1 doc =
  let open Omd in
  List.filter (function Heading (_attr, 1, _inline) -> false | _ -> true) doc

let decode (fpath, (head, body_md)) =
  let metadata = metadata_of_yaml head in
  let omd = doc_with_ids (Omd.of_string body_md) in
  let toc_doc = filter_heading_1 omd in
  let toc_html = Omd.to_html (Omd.toc ~depth:4 toc_doc) in
  let body_html = Omd.to_html (Hilite.Md.transform omd) in
  Result.map (of_metadata ~fpath ~toc_html ~body_md ~body_html) metadata

let all () = Utils.map_files_with_names decode "tutorials/*.md"

let pp ppf v =
  Fmt.pf ppf
    {|
  { title = %a
  ; fpath = %a
  ; slug = %a
  ; description = %a
  ; date = %a
  ; category = %a
  ; body_md = %a
  ; toc_html = %a
  ; body_html = %a
  }|}
    Pp.string v.title Pp.string v.fpath Pp.string v.slug Pp.string v.description
    Pp.string v.date Pp.string v.category Pp.string v.body_md Pp.string
    v.toc_html Pp.string v.body_html

let pp_list = Pp.list pp

let template () =
  Format.asprintf
    {|
type t =
  { title : string
  ; fpath : string
  ; slug : string
  ; description : string
  ; date : string
  ; category : string
  ; body_md : string
  ; toc_html : string
  ; body_html : string
  }
  
let all = %a
|}
    pp_list (all ())
