type metadata = {
  name : string;
  source : string;
  license : string;
  synopsis : string;
  description : string;
  lifecycle : string;
}
[@@deriving of_yaml]

module Lifecycle = struct
  type t = [ `Incubate | `Active | `Sustain | `Deprecate ]

  let to_string = function
    | `Incubate -> "incubate"
    | `Active -> "active"
    | `Sustain -> "sustain"
    | `Deprecate -> "deprecate"

  let of_string = function
    | "incubate" -> Ok `Incubate
    | "active" -> Ok `Active
    | "sustain" -> Ok `Sustain
    | "deprecate" -> Ok `Deprecate
    | s -> Error (`Msg ("Unknown lifecycle type: " ^ s))
end

type t = {
  name : string;
  slug : string;
  source : string;
  license : string;
  synopsis : string;
  description : string;
  lifecycle : Lifecycle.t;
}

let decode s =
  let yaml = Utils.decode_or_raise Yaml.of_string s in
  match yaml with
  | `O [ ("tools", `A xs) ] ->
      Ok
        (List.map
           (fun x ->
             let metadata = Utils.decode_or_raise metadata_of_yaml x in
             let lifecycle =
               Utils.decode_or_raise Lifecycle.of_string metadata.lifecycle
             in
             let description =
               Omd.of_string metadata.description |> Omd.to_html
             in
             ({
                name = metadata.name;
                slug = Utils.slugify metadata.name;
                source = metadata.source;
                license = metadata.license;
                synopsis = metadata.synopsis;
                description;
                lifecycle;
              }
               : t))
           xs)
  | _ -> Error (`Msg "expected a list of tools")

let all () =
  let content = Data.read "tools.yml" |> Option.get in
  Utils.decode_or_raise decode content

let pp_lifecycle ppf v =
  Fmt.pf ppf "%s"
    (match v with
    | `Incubate -> "`Incubate"
    | `Active -> "`Active"
    | `Sustain -> "`Sustain"
    | `Deprecate -> "`Deprecate")

let pp ppf v =
  Fmt.pf ppf
    {|
  { name = %a
  ; slug = %a
  ; source = %a
  ; license = %a
  ; synopsis = %a
  ; description = %a
  ; lifecycle = %a
  }|}
    Pp.string v.name Pp.string v.slug Pp.string v.source Pp.string v.license
    Pp.string v.synopsis Pp.string v.description pp_lifecycle v.lifecycle

let pp_list = Pp.list pp

let template () =
  Format.asprintf
    {|
type lifecycle =
  [ `Incubate
  | `Active
  | `Sustain
  | `Deprecate
  ]

type t =
  { name : string
  ; slug : string
  ; source : string
  ; license : string
  ; synopsis : string
  ; description : string
  ; lifecycle : lifecycle
  }
  
let all = %a
|}
    pp_list (all ())
