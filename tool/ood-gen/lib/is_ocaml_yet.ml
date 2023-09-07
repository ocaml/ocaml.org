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
  stable_record ~version:metadata ~remove:[ body_html ],
    show { with_path = false }]

let decode (_, (head, body_md)) =
  let metadata = metadata_of_yaml head in
  let body_html = Omd.of_string body_md |> Omd.to_html in
  Result.map
    (fun (metadata : metadata) ->
      let categories =
        List.map
          (fun category ->
            {
              category with
              description =
                Omd.to_html
                  (Hilite.Md.transform
                     (Omd.of_string (String.trim category.description)));
            })
          metadata.categories
      in
      let metadata : metadata = { metadata with categories } in
      of_metadata ~body_html metadata)
    metadata

let all () = Utils.map_files decode "is_ocaml_yet"

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
