type metadata = {
  title : string;
  short_description : string;
  long_description : string;
  image : string;
  online_url : string;
  source_url : string;
  license : string;
}
[@@deriving of_yaml, show { with_path = false }]

type t = metadata [@@deriving of_yaml, show { with_path = false }]

let all () = Utils.yaml_sequence_file metadata_of_yaml "resources.yml"

let template () =
  Format.asprintf
    {|
type t =
  { title : string
  ; short_description : string
  ; long_description : string
  ; image : string
  ; online_url : string
  ; source_url : string
  ; license : string
  }
  
let all = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
