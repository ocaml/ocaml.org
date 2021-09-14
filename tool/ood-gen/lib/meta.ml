(* Types shared across datasets *)

module Proficiency = struct
  type t =
    [ `Beginner
    | `Intermediate
    | `Advanced
    ]

  let to_string = function
    | `Beginner ->
      "beginner"
    | `Intermediate ->
      "intermediate"
    | `Advanced ->
      "advanced"

  let of_string = function
    | "beginner" ->
      Ok `Beginner
    | "intermediate" ->
      Ok `Intermediate
    | "advanced" ->
      Ok `Advanced
    | s ->
      Error (`Msg ("Unknown proficiency type: " ^ s))
end

module Archetype = struct
  type t =
    [ `Beginner
    | `Teacher
    | `Library_author
    | `Application_developer
    | `End_user
    | `Distribution_manager
    ]

  let to_string = function
    | `Beginner ->
      "beginner"
    | `Teacher ->
      "teacher"
    | `Library_author ->
      "library-author"
    | `Application_developer ->
      "application-developer"
    | `End_user ->
      "end-user"
    | `Distribution_manager ->
      "distribution-manager"

  let of_string = function
    | "beginner" ->
      Ok `Beginner
    | "teacher" ->
      Ok `Teacher
    | "library-author" ->
      Ok `Library_author
    | "application-developer" ->
      Ok `Application_developer
    | "end-user" ->
      Ok `End_user
    | "distribution-manager" ->
      Ok `Distribution_manager
    | s ->
      Error (`Msg ("Unknown proficiency type: " ^ s))
end
