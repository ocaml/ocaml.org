(* Industrial user parser - adapted from ood-gen/lib/industrial_user.ml *)

open Import
open Data_intf.Industrial_user

type t = Data_intf.Industrial_user.t

type metadata = {
  name : string;
  description : string;
  logo : string option;
  url : string;
  locations : string list;
  consortium : bool;
  featured : bool;
}
[@@deriving of_yaml]

let of_metadata ~body_md ~body_html
    ({ name; description; logo; url; locations; consortium; featured } :
      metadata) : t =
  {
    name;
    slug = Utils.slugify name;
    description;
    logo;
    url;
    locations;
    consortium;
    featured;
    body_md;
    body_html;
  }

let decode (fpath, (head, body)) =
  let ( let* ) = Result.bind in
  let* metadata =
    metadata_of_yaml head |> Result.map_error (Utils.where fpath)
  in
  let body_md = String.trim body in
  let body_html = Markdown.Content.(of_string body_md |> render) in
  Ok (of_metadata ~body_md ~body_html metadata)

let all () = Utils.map_md_files decode "industrial_users/*.md"
let featured () = all () |> List.filter (fun (u : t) -> u.featured)
