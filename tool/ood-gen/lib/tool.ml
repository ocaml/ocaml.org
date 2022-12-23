type metadata = {
  name : string;
  source : string;
  license : string;
  synopsis : string;
  description : string;
  lifecycle : string;
}
[@@deriving yaml]

let path = Fpath.v "data/tools.yml"

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
      List.map
        (fun x ->
          try
            let (metadata : metadata) =
              Utils.decode_or_raise metadata_of_yaml x
            in
            let lifecycle =
              match Lifecycle.of_string metadata.lifecycle with
              | Ok x -> x
              | Error (`Msg err) -> raise (Exn.Decode_error err)
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
              : t)
          with e ->
            print_endline (Yaml.to_string x |> Result.get_ok);
            raise e)
        xs
  | _ -> raise (Exn.Decode_error "expected a list of tools")

let all () =
  let content = Data.read "tools.yml" |> Option.get in
  decode content

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
