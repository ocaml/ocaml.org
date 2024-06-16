open Data_intf.Industrial_user

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

let decode (fpath, (head, body_md)) =
  let metadata =
    metadata_of_yaml head |> Result.map_error (Utils.where fpath)
  in
  let body_html =
    Markdown.Content.of_string body_md |> Markdown.Content.render
  in
  Result.map (of_metadata ~body_md ~body_html) metadata

let all () = Utils.map_md_files decode "industrial_users/*.md"

let template () =
  Format.asprintf {|
include Data_intf.Industrial_user
let all = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
