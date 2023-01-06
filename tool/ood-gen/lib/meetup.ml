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
  let content = Data.read "meetups.yml" |> Option.get in
  Utils.decode_or_raise decode content

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
