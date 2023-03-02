type project = {
  title : string;
  description : string;
  mentee : string;
  blog : string option;
  source : string;
  mentors : string list;
  video : string option;
}
[@@deriving of_yaml, show { with_path = false }]

type metadata = { name : string; projects : project list }
[@@deriving of_yaml, show { with_path = false }]

type t = metadata [@@deriving of_yaml, show { with_path = false }]

let all () =
  Utils.yaml_sequence_file metadata_of_yaml "outreachy.yml"

let template () =
  Format.asprintf
    {|
type project =
  { title : string
  ; description : string
  ; mentee : string
  ; blog : string option
  ; source : string
  ; mentors : string list
  ; video : string option
  }

type t =
  { name : string
  ; projects : project list
  }

let all = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
