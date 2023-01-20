type location = { lat : float; long : float } [@@deriving of_yaml]

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

let of_metadata ({ title; url; textual_location; location } : metadata) =
  { title; slug = Utils.slugify title; url; textual_location; location }

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

let pp ppf v =
  Fmt.pf ppf
    {|
  { title = %a
  ; slug = %a
  ; url = %a
  ; textual_location = %a
  ; location = { lat = %a; long = %a }
  }|}
    Pp.string v.title Pp.string v.slug Pp.string v.url Pp.string
    v.textual_location Fmt.float v.location.lat Fmt.float v.location.long

let pp_list = Pp.list pp

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
    pp_list (all ())
