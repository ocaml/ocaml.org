type external_package = { url : string; synopsis : string }
[@@deriving of_yaml, show { with_path = false }]

type package = { name : string; extern : external_package option }
[@@deriving of_yaml, show { with_path = false }]

type category = {
  name : string;
  status : string;
  description : string;
  packages : package list;
}
[@@deriving of_yaml, show { with_path = false }]

type metadata = {
  id : string;
  question : string;
  answer : string;
  categories : category list;
}
[@@deriving of_yaml]

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
    Cmarkit.Doc.of_string ~strict:true body_md |> Cmarkit_html.of_doc ~safe:true
  in
  let modify_categories =
    List.map (fun category ->
        {
          category with
          description =
            Cmarkit.Doc.of_string ~strict:true
              (String.trim category.description)
            |> Hilite.Md.transform
            |> Cmarkit_html.of_doc ~safe:false;
        })
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
