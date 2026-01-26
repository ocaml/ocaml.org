(* Page parser - adapted from ood-gen/lib/page.ml *)

open Import

type t = [%import: Data_intf.Page.t] [@@deriving show]

type metadata = {
  title : string;
  description : string;
  meta_title : string;
  meta_description : string;
}
[@@deriving of_yaml, stable_record ~version:t ~add:[ slug; body_md; body_html ]]

let of_metadata m = metadata_to_t m

let decode (fpath, (head, body)) =
  let ( let* ) = Result.bind in
  let* metadata =
    metadata_of_yaml head |> Result.map_error (Utils.where fpath)
  in
  let slug =
    Filename.basename fpath |> Filename.remove_extension
    |> Str.global_replace (Str.regexp "_") "-"
  in
  let body_md = String.trim body in
  let body_html =
    Markdown.Content.(of_string body_md |> render ~syntax_highlighting:true)
  in
  Ok (of_metadata ~slug ~body_md ~body_html metadata)

let all () = Utils.map_md_files decode "pages/*.md"
