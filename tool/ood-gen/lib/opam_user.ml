type metadata = {
  name : string;
  email : string option;
  github_username : string option;
  avatar : string option;
}
[@@deriving yaml]

type t = metadata

let decode s =
  let yaml = Utils.decode_or_raise Yaml.of_string s in
  match yaml with
  | `O [ ("opam-users", `A xs) ] ->
      Ok (List.map (Utils.decode_or_raise metadata_of_yaml) xs)
  | _ -> Error (`Msg "expected a list of opam-users")

let all () =
  let content = Data.read "opam-users.yml" |> Option.get in
  Utils.decode_or_raise decode content

let pp ppf v =
  Fmt.pf ppf
    {|
  { name = %a
  ; email = %a
  ; github_username = %a
  ; avatar = %a
  }|}
    Pp.string v.name (Pp.option Pp.string) v.email (Pp.option Pp.string)
    v.github_username (Pp.option Pp.string) v.avatar

let pp_list = Pp.list pp

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
    pp_list (all ())
