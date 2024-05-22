open Data_intf.Tool

type metadata = {
  name : string;
  source : string;
  license : string;
  synopsis : string;
  description : string;
  lifecycle : lifecycle;
}
[@@deriving
  of_yaml, stable_record ~version:t ~modify:[ description ] ~add:[ slug ]]

let of_metadata m =
  metadata_to_t m ~slug:(Utils.slugify m.name) ~modify_description:(fun v ->
      v |> Markdown.Content.of_string |> Markdown.Content.render)

let decode s = Result.map of_metadata (metadata_of_yaml s)
let all () = Utils.yaml_sequence_file decode "tools.yml"

let template () =
  Format.asprintf {|
include Data_intf.Tool
let all = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
