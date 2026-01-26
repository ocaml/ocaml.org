(* Tool page parser - adapted from ood-gen/lib/tool_page.ml *)

open Import

type toc = [%import: Data_intf.Tool_page.toc] [@@deriving of_yaml, show]

type contribute_link = [%import: Data_intf.Tool_page.contribute_link]
[@@deriving of_yaml, show]

type t = [%import: Data_intf.Tool_page.t] [@@deriving show]

type metadata = {
  id : string;
  title : string;
  short_title : string option;
  description : string;
  category : string;
}
[@@deriving
  of_yaml,
    stable_record ~version:t ~remove:[ id ] ~modify:[ short_title ]
      ~add:[ slug; fpath; toc; body_md; body_html ]]

let of_metadata m =
  metadata_to_t m ~slug:m.id ~modify_short_title:(function
    | None -> m.title
    | Some u -> u)

let rec toc_toc (toc : Markdown.Toc.t list) = List.map toc_f toc

and toc_f { title; href; children } =
  { title; href; children = toc_toc children }

let decode (fpath, (head, body_md)) =
  let metadata =
    metadata_of_yaml head |> Result.map_error (Utils.where fpath)
  in
  let doc = Markdown.Content.of_string body_md in
  let toc = Markdown.Toc.generate ~start_level:2 ~max_level:4 doc in
  let body_html = Markdown.Content.render ~syntax_highlighting:true doc in
  Result.map
    (of_metadata ~fpath ~toc:(toc_toc toc) ~body_md ~body_html)
    metadata

let all () =
  Utils.map_md_files decode "tool_pages/*/*.md"
  |> List.sort (fun t1 t2 -> String.compare t1.fpath t2.fpath)
