type location = { lat : float; long : float } [@@deriving yaml]

type t = {
  title : string;
  url : string;
  textual_location : string;
  location : location;
}
[@@deriving yaml]

type metadata = t

let path = Fpath.v "data/meetup.yml"

let decode s =
  let yaml = Utils.decode_or_raise Yaml.of_string s in
  match yaml with
  | `O [ ("meetups", `A xs) ] ->
      Ok (List.map (Utils.decode_or_raise of_yaml) xs)
  | _ -> Error (`Msg "expected a list of meetups")

let parse = decode

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
    Pp.string v.title Pp.string (Utils.slugify v.title) Pp.string v.url
    Pp.string v.textual_location Fmt.float v.location.lat Fmt.float
    v.location.long

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
