type location = { lat : float; long : float }
[@@deriving of_yaml, show { with_path = false }]

type metadata = {
  title : string;
  url : string;
  textual_location : string;
  location : location;
}
[@@deriving of_yaml]

type t = {
  title : string;
  slug : string;
  url : string;
  textual_location : string;
  location : location;
}
[@@deriving
  stable_record ~version:metadata ~remove:[ slug ], show { with_path = false }]

let of_metadata m = of_metadata m ~slug:(Utils.slugify m.title)
let decode s = Result.map of_metadata (metadata_of_yaml s)
let all () = Utils.yaml_sequence_file decode "meetups.yml"

let template () =
  Format.asprintf
    {|
type location = { lat : float; long : float }

type t =
  { title : string
  ; slug : string
  ; url : string
  ; textual_location : string
  ; location : location
  }

let all = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
