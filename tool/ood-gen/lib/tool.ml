module Lifecycle = struct
  type t = [ `Incubate | `Active | `Sustain | `Deprecate ]
  [@@deriving show { with_path = false }]

  let of_string = function
    | "incubate" -> Ok `Incubate
    | "active" -> Ok `Active
    | "sustain" -> Ok `Sustain
    | "deprecate" -> Ok `Deprecate
    | s -> Error (`Msg ("Unknown lifecycle type: " ^ s))

  let of_yaml = Utils.of_yaml of_string "Expected a string for lifecycle type"
end

type metadata = {
  name : string;
  source : string;
  license : string;
  synopsis : string;
  description : string;
  lifecycle : Lifecycle.t;
}
[@@deriving of_yaml]

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
  stable_record ~version:metadata ~modify:[ description ] ~remove:[ slug ],
    show { with_path = false }]

let of_metadata m =
  of_metadata m ~slug:(Utils.slugify m.name) ~modify_description:(fun v ->
      v |> Markdown.Content.of_string |> Markdown.Content.render)

let decode s = Result.map of_metadata (metadata_of_yaml s)
let all () = Utils.yaml_sequence_file decode "tools.yml"

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
