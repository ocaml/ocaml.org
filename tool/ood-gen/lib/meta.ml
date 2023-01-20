(* Types shared across datasets *)

module Proficiency = struct
  type t = [ `Beginner | `Intermediate | `Advanced ]

  let to_string = function
    | `Beginner -> "beginner"
    | `Intermediate -> "intermediate"
    | `Advanced -> "advanced"

  let of_string = function
    | "beginner" -> Ok `Beginner
    | "intermediate" -> Ok `Intermediate
    | "advanced" -> Ok `Advanced
    | s -> Error (`Msg ("Unknown proficiency type: " ^ s))
end
