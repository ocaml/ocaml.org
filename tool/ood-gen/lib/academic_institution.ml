type location = { lat : float; long : float }
[@@deriving of_yaml, show { with_path = false }]

type course = {
  name : string;
  acronym : string option;
  online_resource : string option;
}
[@@deriving of_yaml, show { with_path = false }]

type metadata = {
  name : string;
  description : string;
  url : string;
  logo : string option;
  continent : string;
  courses : course list;
  location : location option;
}
[@@deriving of_yaml]

type t = {
  name : string;
  slug : string;
  description : string;
  url : string;
  logo : string option;
  continent : string;
  courses : course list;
  location : location option;
  body_md : string;
  body_html : string;
}
[@@deriving
  stable_record ~version:metadata ~remove:[ body_md; body_html; slug ],
    show { with_path = false }]

let of_metadata m = of_metadata m ~slug:(Utils.slugify m.name)

let decode (fpath, (head, body_md)) =
  let metadata =
    metadata_of_yaml head |> Result.map_error (Utils.where fpath)
  in
  let body_html =
    Markdown.Content.of_string body_md |> Markdown.Content.render
  in
  Result.map (of_metadata ~body_md ~body_html) metadata

let all () = Utils.map_files decode "academic_institutions/*.md"

let template () =
  Format.asprintf
    {|
type location = { lat : float; long : float }

type course =
  { name : string
  ; acronym : string option
  ; online_resource : string option
  }

type t =
  { name : string
  ; slug : string
  ; description : string
  ; url : string
  ; logo : string option
  ; continent : string
  ; courses : course list
  ; location : location option
  ; body_md : string
  ; body_html : string
  }

let all = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
