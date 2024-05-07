open Data_intf.Success_story

type metadata = {
  title : string;
  logo : string;
  background : string;
  theme : string;
  synopsis : string;
  url : string;
}
[@@deriving of_yaml, stable_record ~version:t ~add:[ slug; body_md; body_html ]]

let of_metadata m = metadata_to_t m ~slug:(Utils.slugify m.title)

let decode (fpath, (head, body_md)) =
  let metadata =
    metadata_of_yaml head |> Result.map_error (Utils.where fpath)
  in
  let body_html =
    body_md |> Markdown.Content.of_string |> Markdown.Content.render
  in
  Result.map (of_metadata ~body_md ~body_html) metadata

let all () = Utils.map_md_files decode "success_stories/*.md"

let template () =
  Format.asprintf {|
include Data_intf.Success_story
let all = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
