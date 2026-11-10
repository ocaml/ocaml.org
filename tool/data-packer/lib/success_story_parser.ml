(* Success story parser - adapted from ood-gen/lib/success_story.ml *)

open Import

type t = [%import: Data_intf.Success_story.t] [@@deriving show]

type metadata = {
  title : string;
  logo : string;
  card_logo : string;
  background : string;
  theme : string;
  synopsis : string;
  url : string;
  why_ocaml_reasons : string list option;
  priority : int;
}
[@@deriving of_yaml]

let of_metadata ~body_md ~body_html
    ({
       title;
       logo;
       card_logo;
       background;
       theme;
       synopsis;
       url;
       why_ocaml_reasons;
       priority;
     } :
      metadata) : t =
  {
    title;
    slug = Utils.slugify title;
    logo;
    card_logo;
    background;
    theme;
    synopsis;
    url;
    why_ocaml_reasons;
    priority;
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

let all () = Utils.map_md_files decode "success_stories/*.md"
