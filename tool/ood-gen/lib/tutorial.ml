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
  toc : Utils.Toc.t list;
  body_md : string;
  body_html : string;
}
[@@deriving
  stable_record ~version:metadata ~add:[ id ]
    ~remove:[ slug; fpath; section; toc; body_md; body_html ],
    show { with_path = false }]

let of_metadata m = of_metadata m ~slug:m.id

let decode (fpath, (head, body_md)) =
  let metadata = metadata_of_yaml head in
  let section =
    List.nth (String.split_on_char '/' fpath) 1
    |> Section.of_string |> Result.get_ok
  in
  let omd = Utils.Toc.doc_with_ids (Omd.of_string body_md) in
  let toc = Utils.Toc.toc ~start_level:2 ~max_level:4 omd in
  let body_html = Omd.to_html (Hilite.Md.transform omd) in
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
