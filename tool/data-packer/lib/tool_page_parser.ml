(* Tool page parser - adapted from ood-gen/lib/tool_page.ml *)

open Import
open Data_intf.Tool_page

type toc = [%import: Data_intf.Tool_page.toc] [@@deriving of_yaml]

type contribute_link = [%import: Data_intf.Tool_page.contribute_link]
[@@deriving of_yaml]

type t = Data_intf.Tool_page.t

type metadata = {
  id : string;
  title : string;
  short_title : string option;
  description : string;
  category : string;
}
[@@deriving of_yaml]

let of_metadata ~fpath ~toc ~body_md ~body_html
    ({ id; title; short_title; description; category } : metadata) : t =
  {
    title;
    short_title = Option.value ~default:title short_title;
    fpath;
    slug = id;
    description;
    category;
    body_md;
    toc;
    body_html;
  }

let rec toc_toc (toc : Markdown.Toc.t list) = List.map toc_f toc

and toc_f { Markdown.Toc.title; href; children } =
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
