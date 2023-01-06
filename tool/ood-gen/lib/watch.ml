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

type t = metadata [@@deriving show { with_path = false }]

let decode s =
  let yaml = Utils.decode_or_raise Yaml.of_string s in
  match yaml with
  | `O [ ("watch", `A xs) ] ->
      Ok (List.map (Utils.decode_or_raise metadata_of_yaml) xs)
  | _ -> Error (`Msg "expected a list of videos")

let all () =
  let content = Data.read "watch.yml" |> Option.get in
  Utils.decode_or_raise decode content

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
