module Academic_institution = struct
  include Academic_institution

  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
end

module Book = struct
  include Book

  let featured = all |> List.filter (fun book -> book.featured)
  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
end

module Changelog = struct
  include Changelog

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

  let featured = all |> List.filter (fun user -> user.featured)
  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
end

module Outreachy = Outreachy
module Packages = Packages

module Paper = struct
  include Paper

  let featured = all |> List.filter (fun paper -> paper.featured)
  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
end

module Problem = struct
  include Problem

  let filter_tag ?tag =
    let f x =
      Option.fold ~none:(x.tags = []) ~some:(Fun.flip List.mem x.tags) tag
    in
    List.filter f
end

module Success_story = struct
  include Success_story

  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
end

module Tool = struct
  include Tool

  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
end

module Tutorial = struct
  include Tutorial

  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
end

module Planet = struct
  include Planet

  module Post = struct
    include Planet.Post
  end

  module LocalBlog = struct
    include Planet.LocalBlog

    let get_by_id id = List.find_opt (fun x -> String.equal x.source.id id) all
  end

  let featured_posts = List.filter (fun (x : Post.t) -> x.featured) Post.all
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
      with Exit -> true
    in
    all
    |> List.find_opt (fun { name; _ } ->
           contains pattern (String.lowercase_ascii name))
end

module Watch = struct
  include Watch

  let all = Watch.watch_list
end

module Video = struct
  include Video

  let kind_to_string = function
    | `Conference -> "conference"
    | `Mooc -> "mooc"
    | `Lecture -> "lecture"

  let kind_of_string = function
    | "conference" -> Ok `Conference
    | "mooc" -> Ok `Mooc
    | "lecture" -> Ok `Lecture
    | s -> Error (`Msg ("Unknown proficiency type: " ^ s))

  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
end

module Workshop = struct
  include Workshop

  let role_to_string = function `Chair -> "chair" | `Co_chair -> "co-chair"

  let role_of_string = function
    | "chair" -> Ok `Chair
    | "co-chair" -> Ok `Co_chair
    | _ -> Error (`Msg "Unknown role type")

  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
end

module Release = struct
  include Release

  let get_by_version version =
    List.find_opt (fun x -> String.equal version x.version) all
end

module News = struct
  include News

  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
end

module Page = struct
  include Page

  let get path =
    let slug = Filename.basename path in
    List.find (fun x -> String.equal slug x.slug) all
end

module Code_example = struct
  include Code_example

  let get title = List.find (fun x -> String.equal x.title title) all
end

module Is_ocaml_yet = struct
  include Is_ocaml_yet
end
