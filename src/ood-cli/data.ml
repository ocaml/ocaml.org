open Rresult
open Netlify
module Jf = Jekyll_format

let parse_yaml p yml = Yaml.of_string yml >>= p

let parse_jekyll yaml_p txt =
  Jf.of_string txt >>= fun jekyll ->
  Jf.fields jekyll |> Jf.fields_to_yaml |> yaml_p

module Paper = struct
  type t = {
    title : string;
    publication : string;
    authors : string list;
    abstract : string;
    tags : string list;
    year : int;
    links : string list;
  }
  [@@deriving yaml]

  let lint = parse_yaml of_yaml

  let widget_of_t =
    Widget.
      [
        `String (String.make ~label:"Paper Title" ~name:"title" ());
        `String (String.make ~label:"Publication" ~name:"publication" ());
        `List (Lst.make ~label:"Authors" ~name:"authors" ());
        `Text (Text.make ~label:"Absract or Description" ~name:"abstract" ());
        `List (Lst.make ~label:"Tags" ~name:"tags" ());
        `Number (Number.make ~label:"Year" ~name:"year" ());
        `List (Lst.make ~min:1 ~label:"Links" ~name:"links" ());
      ]
end

module Papers = struct
  type t = { papers : Paper.t list } [@@deriving yaml]

  let lint = parse_yaml of_yaml

  let path = "data/papers.yml"

  let file =
    let fields =
      [
        `List
          (Widget.Lst.make ~label:"Papers" ~name:"papers"
             ~fields:Paper.widget_of_t ());
      ]
    in
    Netlify.Collection.Files.File.make ~name:"papers" ~label:"OCaml Papers"
      ~file:path ~fields ()
end

module Video = struct
  type kind = [ `Conference | `Mooc | `Lecture ] [@@deriving yaml]

  let all_kinds = [ `Conference; `Mooc; `Lecture ]

  let kind_of_string = function
    | "conference" -> Ok `Conference
    | "mooc" -> Ok `Mooc
    | "lecture" -> Ok `Lecture
    | _ -> Error (`Msg "Unknown video kind")

  let kind_to_string = function
    | `Conference -> "conference"
    | `Mooc -> "mooc"
    | `Lecture -> "lecture"

  let kind_to_yaml user = `String (kind_to_string user)

  let kind_of_yaml = function
    | `String s -> kind_of_string s
    | _ -> Error (`Msg "Expected yaml string")

  type t = {
    title : string;
    description : string;
    people : string list;
    kind : kind;
    tags : string list;
    paper : string option;
    link : string;
    embed : string option;
    year : int;
  }
  [@@deriving yaml]

  let lint = parse_yaml of_yaml

  let widget_of_t =
    Widget.
      [
        `String
          (String.make ~required:true ~label:"Video Title" ~name:"title" ());
        `Text
          (Text.make ~required:true ~label:"Description" ~name:"description" ());
        `List (Lst.make ~default:(`A []) ~label:"People" ~name:"people" ());
        `Select
          Select.(
            make ~required:true ~label:"Video Kind" ~name:"kind"
              ~options:(Strings (List.map kind_to_string all_kinds))
              ());
        `List (Lst.make ~label:"Tags" ~name:"tags" ());
        `Relation
          (Relation.make ~required:false ~collection:"dataset" ~file:"papers"
             ~label:"Optional Link to a Paper" ~name:"paper"
             ~value_field:"papers.*.title" ~search_fields:[ "papers.*.title" ]
             ~display_fields:[ "papers.*.title" ] ());
        `Number (Number.make ~label:"Year" ~name:"year" ());
        `String (String.make ~required:true ~label:"Link" ~name:"link" ());
        `String
          (String.make ~required:false ~label:"Embeddable Link" ~name:"embed"
             ());
      ]
end

module Videos = struct
  type t = { videos : Video.t list } [@@deriving yaml]

  let lint = parse_yaml of_yaml

  let path = "data/videos.yml"

  let file =
    let fields =
      [
        `List
          (Widget.Lst.make ~label:"Videos" ~name:"videos"
             ~fields:Video.widget_of_t ());
      ]
    in
    Netlify.Collection.Files.File.make ~name:"videos" ~label:"OCaml Videos"
      ~file:path ~fields ()
end

module Event = struct
  type t = {
    title : string;
    description : string;
    url : string;
    date : string;
    tags : string list;
    online : bool;
    textual_location : string option;
    location : string option;
  }
  [@@deriving yaml]

  let lint = parse_yaml of_yaml

  let widget_of_t =
    Widget.
      [
        `String (String.make ~label:"Event Name" ~name:"title" ());
        `String (String.make ~label:"Short Description" ~name:"description" ());
        `String (String.make ~label:"URL" ~name:"url" ());
        `DateTime DateTime.(make ~label:"Date" ~name:"date" ~picker_utc:true ());
        `List (Lst.make ~label:"Tags" ~name:"tags" ());
        `Boolean (Boolean.make ~label:"Virtual only" ~name:"online" ());
        `String
          (String.make ~label:"Textual Location" ~required:false
             ~name:"textual_location" ());
        `Map
          (Map.make ~label:"Approximate Location" ~required:false
             ~name:"location"
             ~hint:
               "Just add a sensible location even if the event was virtual only"
             ());
      ]
end

module Events = struct
  type t = { events : Event.t list } [@@deriving yaml]

  let lint = parse_yaml of_yaml

  let path = "data/events.yml"

  let file =
    let fields =
      [
        `List
          (* XXX(patricoferris): Collapsed set to false because of
             https://github.com/netlify/netlify-cms/issues/4385#issuecomment-748495080
             should contribute a fix to upstream if this is still the case in
             latest versions *)
          (Widget.Lst.make ~label:"Events" ~name:"events" ~collapsed:false
             ~add_to_top:true ~fields:Event.widget_of_t ());
      ]
    in
    Netlify.Collection.Files.File.make ~name:"events" ~label:"OCaml Events"
      ~file:path ~fields ()
end

module Tutorial = struct
  type user = [ `Advanced | `Beginner | `Intermediate ]

  let all_users = [ `Advanced; `Beginner; `Intermediate ]

  let user_to_string = function
    | `Beginner -> "beginner"
    | `Intermediate -> "intermediate"
    | `Advanced -> "advanced"

  let user_of_string = function
    | "beginner" -> Ok `Beginner
    | "intermediate" -> Ok `Intermediate
    | "advanced" -> Ok `Advanced
    | s -> Error (`Msg ("Unknown proficiency type: " ^ s))

  let user_to_yaml user = `String (user_to_string user)

  let user_of_yaml = function
    | `String s -> user_of_string s
    | _ -> Error (`Msg "Expected yaml string")

  type t = {
    title : string;
    description : string;
    date : string;
    tags : string list;
    users : user list;
  }
  [@@deriving yaml]

  let path = "data/tutorials/en"

  let widget_of_t =
    Widget.
      [
        `String
          (String.make ~label:"Tutorial Title" ~name:"title"
             ~i18n:(`Boolean true) ());
        `Text
          (Text.make ~label:"Description" ~name:"description"
             ~i18n:(`Boolean true) ());
        `Select
          Select.(
            make ~label:"Target Audience" ~name:"users" ~multiple:true
              ~i18n:`Duplicate
              ~options:(Strings (List.map user_to_string all_users))
              ());
        `DateTime
          DateTime.(
            make ~label:"Date" ~name:"date" ~picker_utc:true
              ~i18n:(`Boolean true) ());
        `Markdown
          Markdown.(make ~label:"Body" ~name:"body" ~i18n:(`Boolean true) ());
      ]

  let lint t = parse_jekyll of_yaml t

  let folder =
    let fields = widget_of_t in
    Netlify.Collection.Folder.make ~name:"tutorials" ~create:true
      ~i18n:(`Boolean true) ~format:Yaml_frontmatter ~label:"OCaml Tutorials"
      ~folder:path ~fields ()
end

module Success_story = struct
  type t = { title : string; image : string option; url : string option }
  [@@deriving yaml]

  let path = "data/success_stories/en"

  let widget_of_t =
    Widget.
      [
        `String
          (String.make ~label:"Title" ~name:"title" ~i18n:(`Boolean true) ());
        `Image
          (Image.make ~label:"Image" ~name:"image" ~required:false
             ~i18n:(`Boolean false) ());
        `String
          (String.make ~label:"URL" ~name:"url" ~required:false
             ~i18n:(`Boolean false) ());
        `Markdown
          Markdown.(make ~label:"Body" ~name:"body" ~i18n:(`Boolean true) ());
      ]

  let lint t = parse_jekyll of_yaml t

  let folder =
    let fields = widget_of_t in
    Netlify.Collection.Folder.make ~name:"success_stories" ~create:true
      ~i18n:(`Boolean true) ~format:Yaml_frontmatter ~label:"Success Stories"
      ~folder:path ~fields ()
end

module Book = struct
  type link = { description : string; uri : string } [@@deriving yaml]

  type t = {
    title : string;
    description : string;
    authors : string list;
    language : string;
    published : string option;
    cover : string option;
    isbn : string option;
    links : link list option;
  }
  [@@deriving yaml]

  let path = "data/books/en"

  let widget_of_t =
    Widget.
      [
        `String
          (String.make ~required:true ~label:"Tutorial Title" ~name:"title" ());
        `Text
          (Text.make ~required:true ~label:"Description" ~name:"description" ());
        `List (Lst.make ~required:true ~label:"Authors" ~name:"authors" ());
        `String
          (String.make ~required:true ~label:"Language" ~name:"language" ());
        `DateTime
          DateTime.(
            make ~required:true ~label:"Published" ~name:"published"
              ~picker_utc:true ());
        `String
          (String.make ~required:false ~label:"Cover image" ~name:"cover" ());
        `String (String.make ~required:false ~label:"ISBN" ~name:"isbn" ());
        `List (Lst.make ~required:false ~label:"Links" ~name:"links" ());
        `Markdown Markdown.(make ~label:"Body" ~name:"body" ());
      ]

  let lint t = parse_jekyll of_yaml t

  let folder =
    let fields = widget_of_t in
    Netlify.Collection.Folder.make ~name:"books" ~create:true
      ~format:Yaml_frontmatter ~label:"OCaml Books" ~folder:path ~fields ()
end

module Industrial_user = struct
  type t = {
    name : string;
    description : string;
    image : string option;
    site : string;
    locations : string list;
    consortium : bool;
  }
  [@@deriving yaml]

  let path = "data/industrial_users/en"

  let widget_of_t =
    Widget.
      [
        `String (String.make ~required:true ~label:"Name" ~name:"name" ());
        `Text
          (Text.make ~required:true ~label:"Description" ~name:"description" ());
        `String (String.make ~required:true ~label:"Website" ~name:"site" ());
        `String (String.make ~required:false ~label:"Image" ~name:"image" ());
        `List (Lst.make ~required:true ~label:"Locations" ~name:"locations" ());
        `Markdown Markdown.(make ~label:"Body" ~name:"body" ());
      ]

  let lint t = parse_jekyll of_yaml t

  let folder =
    let fields = widget_of_t in
    Netlify.Collection.Folder.make ~name:"industrial_users" ~create:true
      ~format:Yaml_frontmatter ~label:"Industrial Users" ~folder:path ~fields ()
end

module Academic_institution = struct
  type location = { lat : float; long : float } [@@deriving yaml]

  type course = {
    name : string;
    acronym : string option;
    online_resource : string option;
  }
  [@@deriving yaml]

  type t = {
    name : string;
    description : string;
    url : string;
    logo : string option;
    continent : string;
    courses : course list;
    location : location option;
  }
  [@@deriving yaml]

  let path = "data/academic_institutions/en"

  let widget_of_t =
    Widget.
      [
        `String (String.make ~required:true ~label:"Name" ~name:"name" ());
        `Text
          (Text.make ~required:true ~label:"Description" ~name:"description" ());
        `String (String.make ~required:true ~label:"Website" ~name:"url" ());
        `String (String.make ~required:false ~label:"Logo" ~name:"logo" ());
        `String
          (String.make ~required:true ~label:"Continent" ~name:"continent" ());
        `List (Lst.make ~required:true ~label:"Course" ~name:"course" ());
        `List (Lst.make ~required:false ~label:"Location" ~name:"location" ());
        `Markdown Markdown.(make ~label:"Body" ~name:"body" ());
      ]

  let lint t = parse_jekyll of_yaml t

  let folder =
    let fields = widget_of_t in
    Netlify.Collection.Folder.make ~name:"academic_institution" ~create:true
      ~format:Yaml_frontmatter ~label:"Academic Institution" ~folder:path
      ~fields ()
end

module Workshop = struct
  type role = [ `Chair | `Co_chair ]

  let role_to_string = function `Chair -> "chair" | `Co_chair -> "co-chair"

  let role_of_string = function
    | "chair" -> Ok `Chair
    | "co-chair" -> Ok `Co_chair
    | _ -> Error (`Msg "Unknown role type")

  let role_of_yaml = function
    | `String s -> Result.bind (role_of_string s) (fun t -> Ok t)
    | _ -> Error (`Msg "Expected a string for a role type")

  let role_to_yaml t = `String (role_to_string t)

  type important_date = { date : string; info : string } [@@deriving yaml]

  type committee_member = {
    name : string;
    role : role option;
    affiliation : string option;
  }
  [@@deriving yaml]

  type presentation = {
    title : string;
    authors : string list;
    link : string option;
    video : string option;
    slides : string option;
    additional_links : string list option;
  }
  [@@deriving yaml]

  type t = {
    title : string;
    location : string option;
    date : string;
    online : bool;
    important_dates : important_date list;
    presentations : presentation list;
    program_committee : committee_member list;
    organising_committee : committee_member list;
  }
  [@@deriving yaml]

  let path = "data/workshops"

  let widget_of_t =
    Widget.
      [
        `String (String.make ~required:true ~label:"Name" ~name:"name" ());
        `Text
          (Text.make ~required:true ~label:"Description" ~name:"description" ());
        `String (String.make ~required:true ~label:"Website" ~name:"url" ());
        `String (String.make ~required:false ~label:"Logo" ~name:"logo" ());
        `String
          (String.make ~required:true ~label:"Continent" ~name:"continent" ());
        `List (Lst.make ~required:true ~label:"Course" ~name:"course" ());
        `List (Lst.make ~required:false ~label:"Location" ~name:"location" ());
        `Markdown Markdown.(make ~label:"Body" ~name:"body" ());
      ]

  let lint t = parse_jekyll of_yaml t

  let folder =
    let fields = widget_of_t in
    Netlify.Collection.Folder.make ~name:"academic_institution" ~create:true
      ~format:Yaml_frontmatter ~label:"Academic Institution" ~folder:path
      ~fields ()
end
