open Data_intf.Academic_institution

type metadata = {
  name : string;
  description : string;
  url : string;
  logo : string option;
  continent : string;
  courses : course list;
  location : location option;
}
[@@deriving of_yaml, stable_record ~version:t ~add:[ body_md; body_html; slug ]]

let of_metadata m = metadata_to_t m ~slug:(Utils.slugify m.name)

let decode (fpath, (head, body_md)) =
  let metadata =
    metadata_of_yaml head |> Result.map_error (Utils.where fpath)
  in
  let body_html = Markdown.Content.(body_md |> of_string |> render) in
  Result.map (of_metadata ~body_md ~body_html) metadata

let all () = Utils.map_md_files decode "academic_institutions/*.md"

type t_list = t list [@@deriving show]

let template () =
  Format.asprintf
    {ocaml|
include Data_intf.Academic_institution
let all = %a
|ocaml}
    pp_t_list (all ())
