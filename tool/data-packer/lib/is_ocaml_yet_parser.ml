(* Is_ocaml_yet parser - adapted from ood-gen/lib/is_ocaml_yet.ml *)

open Import

type external_package = [%import: Data_intf.Is_ocaml_yet.external_package]
[@@deriving of_yaml]

type package = [%import: Data_intf.Is_ocaml_yet.package] [@@deriving of_yaml]
type category = Data_intf.Is_ocaml_yet.category
type t = Data_intf.Is_ocaml_yet.t

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

let category_of_meta ({ name; status; description; packages } : category_meta) :
    category =
  {
    name;
    status;
    description =
      Cmarkit.Doc.of_string ~strict:true (String.trim description)
      |> Markdown.Content.render ~syntax_highlighting:true;
    packages;
    slug = Utils.slugify name;
  }

let of_metadata ~body_html ({ id; question; answer; categories } : metadata) : t
    =
  {
    id;
    question;
    answer;
    categories = List.map category_of_meta categories;
    body_html;
  }

let decode (fpath, (head, body_md)) =
  let metadata =
    metadata_of_yaml head |> Result.map_error (Utils.where fpath)
  in
  let body_html =
    Cmarkit.Doc.of_string ~strict:true body_md |> Cmarkit_html.of_doc ~safe:true
  in
  Result.map (of_metadata ~body_html) metadata

let all () = Utils.map_md_files decode "is_ocaml_yet/*.md"
