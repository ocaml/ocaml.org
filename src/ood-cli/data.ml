open Rresult
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
end

module Papers = struct
  type t = { papers : Paper.t list } [@@deriving yaml]

  let lint = parse_yaml of_yaml

  let path = "data/papers.yml"
end

module Video = struct
  type kind = [ `Conference | `Mooc | `Lecture ] [@@deriving yaml]

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
end

module Videos = struct
  type t = { videos : Video.t list } [@@deriving yaml]

  let lint = parse_yaml of_yaml

  let path = "data/videos.yml"
end

module Watch = struct
  type t = {
    name : string;
    embedPath : string;
    thumbnailPath : string;
    description : string;
    year : string;
    language : string;
    category : string;
  }
  [@@deriving yaml]

  let lint = parse_yaml of_yaml

  let path = "data/watch.yml"
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
end

module Events = struct
  type t = { events : Event.t list } [@@deriving yaml]

  let lint = parse_yaml of_yaml

  let path = "data/events.yml"
end

module Tutorial = struct
  type user = [ `Advanced | `Beginner | `Intermediate ]

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

  let lint t = parse_jekyll of_yaml t
end

module Success_story = struct
  type t = { title : string; image : string option; url : string option }
  [@@deriving yaml]

  let path = "data/success_stories/en"

  let lint t = parse_jekyll of_yaml t
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

  let lint t = parse_jekyll of_yaml t
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

  let lint t = parse_jekyll of_yaml t
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

  let lint t = parse_jekyll of_yaml t
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
    poster : bool option;
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

  let lint t = parse_jekyll of_yaml t
end
