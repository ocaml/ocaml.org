open Data_intf.Is_ocaml_yet

type category_meta = {
  name : string;
  status : string;
  description : string;
  packages : package list;
}
[@@deriving
  of_yaml,
    stable_record ~version:category ~add:[ slug ] ~modify:[ description ],
    show]

type metadata = {
  id : string;
  question : string;
  answer : string;
  categories : category_meta list;
}
[@@deriving
  of_yaml,
    stable_record ~version:t ~add:[ body_html ] ~modify:[ categories ],
    show]

let decode (fpath, (head, body_md)) =
  let metadata =
    metadata_of_yaml head |> Result.map_error (Utils.where fpath)
  in
  let body_html =
    Cmarkit.Doc.of_string ~strict:true body_md |> Cmarkit_html.of_doc ~safe:true
  in
  let modify_categories u =
    let modify_description description =
      Cmarkit.Doc.of_string ~strict:true (String.trim description)
      |> Hilite.Md.transform
      |> Cmarkit_html.of_doc ~safe:false
    in
    List.map
      (fun cat ->
        category_meta_to_category ~slug:(Utils.slugify cat.name)
          ~modify_description cat)
      u
  in
  Result.map (metadata_to_t ~body_html ~modify_categories) metadata

let all () = Utils.map_md_files decode "is_ocaml_yet/*.md"

let template () =
  Format.asprintf {|
include Data_intf.Is_ocaml_yet
let all = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
