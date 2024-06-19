open Data_intf.Page

type metadata = {
  title : string;
  description : string;
  meta_title : string;
  meta_description : string;
}
[@@deriving of_yaml, stable_record ~version:t ~add:[ slug; body_md; body_html ]]

let decode (file, (head, body_md)) =
  let metadata = metadata_of_yaml head |> Result.map_error (Utils.where file) in
  let body_html =
    body_md |> Markdown.Content.of_string
    |> Markdown.Content.render ~syntax_highlighting:true
  in
  let slug =
    file |> Filename.basename |> Filename.remove_extension
    |> String.map (function '_' -> '-' | c -> c)
  in
  Result.map (metadata_to_t ~slug ~body_md ~body_html) metadata

let all () = Utils.map_md_files decode "pages/*.md"

let template () =
  Format.asprintf {|
include Data_intf.Page
let all = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
