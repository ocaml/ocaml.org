(* Industrial user parser - adapted from ood-gen/lib/industrial_user.ml *)

open Import

type t = [%import: Data_intf.Industrial_user.t] [@@deriving show]

type metadata = {
  name : string;
  description : string;
  logo : string option;
  url : string;
  locations : string list;
  consortium : bool;
  featured : bool;
}
[@@deriving of_yaml, stable_record ~version:t ~add:[ slug; body_md; body_html ]]

let of_metadata m = metadata_to_t m ~slug:(Utils.slugify m.name)

let decode (fpath, (head, body)) =
  let ( let* ) = Result.bind in
  let* metadata = metadata_of_yaml head |> Result.map_error (Utils.where fpath) in
  let body_md = String.trim body in
  let body_html = Markdown.Content.(of_string body_md |> render) in
  Ok (of_metadata ~body_md ~body_html metadata)

let all () = Utils.map_md_files decode "industrial_users/*.md"

let featured () = all () |> List.filter (fun (u : t) -> u.featured)
