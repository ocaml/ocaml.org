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
  [@@deriving show { with_path = false }]

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
[@@deriving
  stable_record ~version:metadata ~modify:[ lifecycle; description ]
    ~remove:[ slug ],
    show { with_path = false }]

let of_metadata m =
  of_metadata m ~slug:(Utils.slugify m.name)
    ~modify_lifecycle:(Utils.decode_or_raise Lifecycle.of_string)
    ~modify_description:(fun v -> Omd.of_string v |> Omd.to_html)

let decode s =
  let yaml = Utils.decode_or_raise Yaml.of_string s in
  match yaml with
  | `O [ ("tools", `A xs) ] ->
      Ok
        (List.map
           (fun x ->
             let metadata = Utils.decode_or_raise metadata_of_yaml x in
             of_metadata metadata)
           xs)
  | _ -> Error (`Msg "expected a list of tools")

let all () =
  let content = Data.read "tools.yml" |> Option.get in
  Utils.decode_or_raise decode content

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
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
