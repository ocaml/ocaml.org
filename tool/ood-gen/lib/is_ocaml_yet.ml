type external_package = { url : string; synopsis : string }
[@@deriving of_yaml, show { with_path = false }]

type package = { name : string; extern : external_package option }
[@@deriving of_yaml, show { with_path = false }]

type category_meta = {
  name : string;
  status : string;
  description : string;
  packages : package list;
}
[@@deriving of_yaml]

type metadata = {
  id : string;
  question : string;
  answer : string;
  categories : category_meta list;
}
[@@deriving of_yaml]

type category = {
  name : string;
  status : string;
  description : string;
  packages : package list;
  slug : string;
}
[@@deriving
  stable_record ~version:category_meta ~remove:[ slug ] ~modify:[ description ],
    show { with_path = false }]

type t = {
  id : string;
  question : string;
  answer : string;
  categories : category list;
  body_html : string;
}
[@@deriving
  stable_record ~version:metadata ~remove:[ body_html ] ~modify:[ categories ],
    show { with_path = false }]

let decode (fpath, (head, body_md)) =
  let metadata =
    metadata_of_yaml head |> Result.map_error (Utils.where fpath)
  in
  let body_html =
    Markdown.Content.of_string body_md |> Markdown.Content.render
  in
  let modify_categories u =
    let modify_description description =
      String.trim description |> Markdown.Content.of_string
      |> Markdown.Content.render
    in
    List.map
      (fun cat ->
        category_of_category_meta ~slug:(Utils.slugify cat.name)
          ~modify_description cat)
      u
  in
  Result.map (of_metadata ~body_html ~modify_categories) metadata

let all () = Utils.map_files decode "is_ocaml_yet/*.md"

let template () =
  Format.asprintf
    {|
type external_package = { url : string; synopsis : string }
type package = { name: string; extern: external_package option }

type category = {
  name : string;
  status : string;
  description : string;
  packages : package list;
  slug : string;
}

type t = {
  id : string;
  question : string;
  answer : string;
  categories : category list;
  body_html : string;
}
  
let all = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
