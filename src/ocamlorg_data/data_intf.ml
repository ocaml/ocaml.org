module Academic_institution = struct
  type location = { lat : float; long : float } [@@deriving of_yaml, show]

  type course = {
    name : string;
    acronym : string option;
    online_resource : string option;
  }
  [@@deriving of_yaml, show]

  type t = {
    name : string;
    slug : string;
    description : string;
    url : string;
    logo : string option;
    continent : string;
    courses : course list;
    location : location option;
    body_md : string;
    body_html : string;
  }
  [@@deriving show]
end

module Book = struct
  type difficulty = Beginner | Intermediate | Advanced [@@deriving show]

  let difficulty_of_string = function
    | "beginner" -> Ok Beginner
    | "intermediate" -> Ok Intermediate
    | "advanced" -> Ok Advanced
    | s -> Error (`Msg ("Unknown difficulty type: " ^ s))

  let difficulty_of_yaml = function
    | `String s -> difficulty_of_string s
    | _ -> Error (`Msg "Expected a string for difficulty type")

  type link = { description : string; uri : string } [@@deriving of_yaml, show]

  type t = {
    title : string;
    slug : string;
    description : string;
    recommendation : string option;
    authors : string list;
    language : string list;
    published : string;
    cover : string;
    isbn : string option;
    links : link list;
    difficulty : difficulty;
    pricing : string;
    body_md : string;
    body_html : string;
  }
  [@@deriving show]
end

module Changelog = struct
  type t = {
    title : string;
    slug : string;
    date : string;
    tags : string list;
    changelog_html : string option;
    body_html : string;
    body : string;
    authors : string list;
  }
  [@@deriving of_yaml, show]
end

module Cookbook = struct
  type category = {
    title : string;
    slug : string;
    subcategories : category list;
  }
  [@@deriving show]

  type task = {
    title : string;
    slug : string;
    category_path : string list;
    description : string option;
  }
  [@@deriving show]

  type code_block_with_explanation = { code : string; explanation : string }
  [@@deriving show]

  type package = {
    name : string;
    tested_version : string;
    used_libraries : string list;
  }
  [@@deriving of_yaml, show]

  type t = {
    slug : string;
    filepath : string;
    task : task;
    packages : package list;
    code_blocks : code_block_with_explanation list;
    code_plaintext : string;
    discussion_html : string;
  }
  [@@deriving show]
end

module Outreachy = struct
  type project = {
    title : string;
    description : string;
    mentee : string;
    blog : string option;
    source : string;
    mentors : string list;
    video : string option;
  }
  [@@deriving of_yaml, show]

  type t = { name : string; projects : project list } [@@deriving of_yaml, show]
end
