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

module Tool = struct
  type t = {
    name : string;
    source : string;
    license : string;
    synopsis : string;
    description : string;
    lifecycle : Lifecycle.t;
  }
end

type t = { tools : Tool.t list }
