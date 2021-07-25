type t = {
  title : string;
  description : string;
  url : string;
  date : string;
  tags : string list;
  online : bool;
  textual_location : string option;
  location : string option;
}
[@@deriving yaml]

let decode s =
  let yaml = Utils.decode_or_raise Yaml.of_string s in
  match yaml with
  | `O [ ("events", `A xs) ] -> List.map (Utils.decode_or_raise of_yaml) xs
  | _ -> raise (Exn.Decode_error "expected a list of events")

let all () =
  let content = Data.read "events.yml" |> Option.get in
  decode content

let pp ppf v =
  Fmt.pf ppf
    {|
  { title = %a
  ; slug = %a
  ; description = %a
  ; url = %a
  ; date = %a
  ; tags = %a
  ; online = %b
  ; textual_location = %a
  ; location = %a
  }|}
    Pp.string v.title Pp.string (Utils.slugify v.title) Pp.string v.description
    Pp.string v.url Pp.string v.date (Pp.list Pp.string) v.tags v.online
    (Pp.option Pp.string) v.textual_location (Pp.option Pp.string) v.location

let pp_list = Pp.list pp

let template () =
  Format.asprintf
    {|
type t =
  { title : string
  ; slug : string
  ; description : string
  ; url : string
  ; date : string
  ; tags : string list
  ; online : bool
  ; textual_location : string option
  ; location : string option
  }

let all = %a
|}
    pp_list (all ())
