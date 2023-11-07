type metadata = {
  name : string;
  embed_path : string;
  thumbnail_path : string;
  description : string option;
  published_at : string;
  language : string;
  category : string;
}
[@@deriving of_yaml, show { with_path = false }]

type t = metadata [@@deriving of_yaml, show { with_path = false }]

let all () = Utils.yaml_sequence_file metadata_of_yaml "watch.yml"

let template () =
  Format.asprintf
    {|

  type t =
  { name: string;
    embed_path : string;
    thumbnail_path : string;
    description : string option;
    published_at : string;
    language : string;
    category : string;
  }
  
let all = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
