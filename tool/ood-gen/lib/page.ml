type metadata = {
  title : string;
  description : string;
  meta_title : string;
  meta_description : string;
}
[@@deriving of_yaml]

type t = {
  slug : string;
  title : string;
  description : string;
  meta_title : string;
  meta_description : string;
  body_md : string;
  body_html : string;
}
[@@deriving
  stable_record ~version:metadata ~remove:[ slug; body_md; body_html ],
    show { with_path = false }]

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
  Result.map (of_metadata ~slug ~body_md ~body_html) metadata

let all () = Utils.map_files decode "pages/*.md"

let template () =
  Format.asprintf
    {|

type t =
  { slug : string
  ; title : string
  ; description : string
  ; meta_title : string
  ; meta_description : string
  ; body_md : string
  ; body_html : string
  }

let all = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
