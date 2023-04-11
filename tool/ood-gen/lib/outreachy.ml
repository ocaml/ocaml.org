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

type t = { 
  name : string; 
  projects : project list;
} 
[@@deriving stable_record ~version:metadata, 
  show { with_path = false }]

let of_metadata m = of_metadata m
let decode s =
 Result.map of_metadata (metadata_of_yaml s)

let all () =
  Utils.yaml_sequence_file ~key:"rounds" decode "outreachy.yml"

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
