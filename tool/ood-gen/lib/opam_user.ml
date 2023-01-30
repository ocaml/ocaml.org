type metadata = {
  name : string;
  email : string option;
  github_username : string option;
  avatar : string option;
}
[@@deriving of_yaml, show { with_path = false }]

let all () = Utils.yaml_sequence_file metadata_of_yaml "opam-users.yml"

let template () =
  Format.asprintf
    {|
type t =
  { name : string
  ; email : string option
  ; github_username : string option
  ; avatar : string option
  }
  
let all = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
