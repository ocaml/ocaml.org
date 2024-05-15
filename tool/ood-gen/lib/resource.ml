type metadata = {
  title : string;
  description : string;
  image : string;
  online_url : string;
  source_url : string option;
  featured : bool;
}
[@@deriving of_yaml, show { with_path = false }]

type t = metadata [@@deriving of_yaml, show { with_path = false }]

let all () = Utils.yaml_sequence_file metadata_of_yaml "resources.yml"

let template () =
  let all_resources = all () in
  Format.asprintf
    {|
type t =
  { title : string
  ; description : string
  ; image : string
  ; online_url : string
  ; source_url : string option
  ; featured : bool
  }
  
let all = %a
let featured = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    all_resources
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all_resources |> List.filter (fun (r : t) -> r.featured = true))
