open Ocamlorg.Import

type contribute_link = { url : string; description : string }
[@@deriving of_yaml, show { with_path = false }]

type metadata = {
  id : string;
  title : string;
  short_title : string option;
  description : string;
  category : string;
}
[@@deriving of_yaml]

type t = {
  title : string;
  short_title : string;
  slug : string;
  fpath : string;
  description : string;
  category : string;
  toc : Markdown.Toc.t list;
  body_md : string;
  body_html : string;
}
[@@deriving
  stable_record ~version:metadata ~add:[ id ] ~modify:[ short_title ]
    ~remove:[ slug; fpath; toc; body_md; body_html ],
    show { with_path = false }]

let of_metadata m =
  of_metadata m ~slug:m.id ~modify_short_title:(function
    | None -> m.title
    | Some u -> u)

let decode (fpath, (head, body_md)) =
  let metadata =
    metadata_of_yaml head |> Result.map_error (Utils.where fpath)
  in
  let doc = Markdown.Content.of_string body_md in
  let toc = Markdown.Toc.generate ~start_level:2 ~max_level:4 doc in
  let body_html = Markdown.Content.render ~syntax_highlighting:true doc in
  Result.map (of_metadata ~fpath ~toc ~body_md ~body_html) metadata

let all () =
  Utils.map_md_files decode "tool_pages/*/*.md"
  |> List.sort (fun t1 t2 -> String.compare t1.fpath t2.fpath)

let template () =
  let _ = all () in

  Format.asprintf
    {|
type toc =
  { title : string
  ; href : string
  ; children : toc list
  }

type contribute_link =
  { url : string
  ; description : string
  }

type t =
  { title : string
  ; short_title: string
  ; fpath : string
  ; slug : string
  ; description : string
  ; category : string
  ; body_md : string
  ; toc : toc list
  ; body_html : string
  }
  
let all = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
