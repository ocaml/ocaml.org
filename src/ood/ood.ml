module Meta = struct

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
        Error (`Msg ("Unknown archetype type: " ^ s))
  end
end

module Academic_institution = Academic_institution
module Book = Book
module Event = Event
module Industrial_user = Industrial_user
module Media = Media
module Paper = Paper
module Success_story = Success_story
module Tool = Tool
module Tutorial = Tutorial
module Video = struct
  include Video

  let kind_to_string = function
  | `Conference -> 
    "conference"
  | `Mooc -> 
    "mooc"
  | `Lecture -> 
    "lecture"

  let kind_of_string = function
  | "conference" -> 
    Ok `Conference
  | "mooc" -> 
    Ok `Mooc
  | "lecture" -> 
    Ok `Lecture
  | s ->
    Error (`Msg ("Unknown proficiency type: " ^ s))
end
