(* Page parser - adapted from ood-gen/lib/page.ml *)

open Import
open Data_intf.Page

type t = Data_intf.Page.t

type metadata = {
  title : string;
  description : string;
  meta_title : string;
  meta_description : string;
}
[@@deriving of_yaml]

let of_metadata ~slug ~body_md ~body_html
    ({ title; description; meta_title; meta_description } : metadata) : t =
  { slug; title; description; meta_title; meta_description; body_md; body_html }

let decode (fpath, (head, body)) =
  let ( let* ) = Result.bind in
  let* metadata =
    metadata_of_yaml head |> Result.map_error (Utils.where fpath)
  in
  let slug =
    Filename.basename fpath |> Filename.remove_extension
    |> String.map (function '_' -> '-' | c -> c)
  in
  let body_md = String.trim body in
  let body_html =
    Markdown.Content.(of_string body_md |> render ~syntax_highlighting:true)
  in
  Ok (of_metadata ~slug ~body_md ~body_html metadata)

let all () = Utils.map_md_files decode "pages/*.md"
