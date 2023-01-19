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

let decode s =
  let yaml = Utils.decode_or_raise Yaml.of_string s in
  match yaml with
  | `O [ ("meetups", `A xs) ] ->
      Ok
        (List.map
           (fun x -> x |> Utils.decode_or_raise metadata_of_yaml |> of_metadata)
           xs)
  | _ -> Error (`Msg "expected a list of meetups")

let all () =
  let (>>=) = Result.bind in
  let (<@>) = Import.Result.app in
  Data.read "meetups.yml"
  |> Option.to_result ~none:(`Msg "meetups.yml: file not found")
  >>= Yaml.of_string
  >>= Yaml.Util.find "meetups"
  >>= Option.to_result ~none:(`Msg "meetups.yml: key \"meetups\" not found")
  >>= (function `A x -> Ok x | _ -> Error (`Msg "meetups.yml: expecting a sequence"))
  >>= List.fold_left (fun u y -> Ok List.cons <@> metadata_of_yaml y <@> u) (Ok [])
  |> Utils.decode_or_raise Fun.id

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
