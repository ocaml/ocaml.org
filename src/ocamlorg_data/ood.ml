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

module Academic_institution = struct
  include Academic_institution


  let all ?(lang = `English) () =
    match lang with `English -> all_en | `French -> all_fr | _ -> all_en

  let get_by_slug ?lang slug =
    List.find_opt (fun x -> String.equal slug x.slug) (all ?lang ())
end

module Book = struct
  include Book

  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
end

module Job = struct
  include Job
end

module Meetup = struct
  include Meetup

  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
end

module Industrial_user = struct
  include Industrial_user

  let all ?(lang = `English) () =
    match lang with `English -> all_en | `French -> all_fr | _ -> all_en

  let get_by_slug ?lang slug =
    List.find_opt (fun x -> String.equal slug x.slug) (all ?lang ())
end

module Packages = Packages

module Paper = struct
  include Paper

  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
end

module Problem = struct
  include Problem

  let filter_by_tag ~tag problems =
    List.filter (fun (x : t) -> List.mem tag x.tags) problems
  
  let filter_no_tag problems =
    List.filter (fun (x : t) -> List.length x.tags = 0) problems
end

module Success_story = struct
  include Success_story

  let all ?(lang = `English) () =
    match lang with `English -> all_en | `French -> all_fr | _ -> all_en

  let get_by_slug ?lang slug =
    List.find_opt (fun x -> String.equal slug x.slug) (all ?lang ())
end

module Tool = struct
  include Tool

  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
end

module Tutorial = struct
  include Tutorial

  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
end

module Rss = struct
  include Rss

  let featured = List.filter (fun x -> x.featured) all

  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
end

module Opam_user = struct
  include Opam_user

  let make ~name ?email ?github_username ?avatar () =
    { name; email; github_username; avatar }
  
  let find_by_name s =
    let pattern = String.lowercase_ascii s in
    let contains s1 s2 =
      try
        let len = String.length s2 in
        for i = 0 to String.length s1 - len do
          if String.sub s1 i len = s2 then raise Exit
        done;
        false
      with
      | Exit ->
        true
    in
    all
    |> List.find_opt (fun { name; _ } ->
           if contains pattern (String.lowercase_ascii @@ name) then
             true
           else
             false)
  
end

module Watch = struct
  include Watch
end

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

  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
end

module Workshop = struct
  include Workshop

  let role_to_string = function `Chair -> "chair" | `Co_chair -> "co-chair"

  let role_of_string = function
    | "chair" ->
      Ok `Chair
    | "co-chair" ->
      Ok `Co_chair
    | _ ->
      Error (`Msg "Unknown role type")

  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
end


module Workflow = struct
  include Workflow
end


module Release = struct
  include Release


  let get_by_version version = List.find_opt (fun x -> String.equal version x.version) all
end


module News = struct
  include News

  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
end

module Page = struct
  include Page
end
