type metadata = {
  name : string;
  email : string option;
  github_username : string option;
  avatar : string option;
}
[@@deriving of_yaml, show { with_path = false }]

type t = metadata [@@deriving show { with_path = false }]

let decode s =
  let yaml = Utils.decode_or_raise Yaml.of_string s in
  match yaml with
  | `O [ ("opam-users", `A xs) ] ->
      Ok (List.map (Utils.decode_or_raise metadata_of_yaml) xs)
  | _ -> Error (`Msg "expected a list of opam-users")

let all () =
  let content = Data.read "opam-users.yml" |> Option.get in
  Utils.decode_or_raise decode content

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
