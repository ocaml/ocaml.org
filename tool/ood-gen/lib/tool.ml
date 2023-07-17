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
  slug : string;
  source : string;
  license : string;
  synopsis : string;
  lifecycle : Lifecycle.t;
}
[@@deriving of_yaml]

type t = {
  name : string;
  slug : string;
  source : string;
  license : string;
  synopsis : string;
  lifecycle : Lifecycle.t;
  body_md : string;
  body_html : string;
}
[@@deriving
  stable_record ~version:metadata ~remove:[ body_md; body_html ],
    show { with_path = false }]

let of_metadata m ~body_md ~body_html = of_metadata m ~body_md ~body_html

let decode (_fpath, (head, body_md)) =
  let metadata = metadata_of_yaml head in
  let omd = Utils.Toc.doc_with_ids (Omd.of_string body_md) in
  let body_html = Omd.to_html (Hilite.Md.transform omd) in
  Result.map (of_metadata ~body_md ~body_html) metadata

let all () = Utils.map_files decode "tools/*.md"

let template () =
  Format.asprintf
    {|
type lifecycle =
  [ `Incubate
  | `Active
  | `Sustain
  | `Deprecate
  ]

type version = { version : string; docs_url : string }

type t =
  { name : string
  ; slug : string
  ; source : string
  ; license : string
  ; synopsis : string
  ; lifecycle : lifecycle
  ; body_md : string
  ; body_html : string
  }
  
let all = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
