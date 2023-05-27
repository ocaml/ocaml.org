type category = {
  name : string;
  status : string;
  description : string;
  packages : string list;
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
  Result.map (of_metadata ~body_html) metadata

let all () = Utils.map_files decode "are_we_yet"

let template () =
  Format.asprintf
    {|
type category = {
  name : string;
  status : string;
  description : string;
  packages : string list;
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
