module Meta : sig
  module Proficiency : sig
    type t = [ `Advanced | `Beginner | `Intermediate ]

    val to_string : t -> string

    val of_string : string -> (t, [> `Msg of string ]) result
  end

  module Archetype : sig
    type t =
      [ `Application_developer
      | `Beginner
      | `Distribution_manager
      | `End_user
      | `Library_author
      | `Teacher ]

    val to_string : t -> string

    val of_string : string -> (t, [> `Msg of string ]) result
  end
end

module Academic_institution : sig
  type location = { lat : float; long : float }

  type course = {
    name : string;
    acronym : string option;
    online_resource : string option;
  }

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

  val all : t list

  val get_by_slug : string -> t option
end

module Book : sig
  type link = { description : string; uri : string }

  type t = {
    title : string;
    slug : string;
    description : string;
    authors : string list;
    language : string;
    published : string option;
    cover : string option;
    isbn : string option;
    links : link list;
    body_md : string;
    body_html : string;
  }

  val all : t list

  val get_by_slug : string -> t option
end

module Event : sig
  type t = {
    title : string;
    slug : string;
    description : string;
    url : string;
    date : string;
    tags : string list;
    online : bool;
    textual_location : string option;
    location : string option;
  }

  val all : t list

  val get_by_slug : string -> t option
end

module Industrial_user : sig
  type t = {
    name : string;
    slug : string;
    description : string;
    image : string option;
    site : string;
    locations : string list;
    consortium : bool;
    body_md : string;
    body_html : string;
  }

  val all : t list

  val get_by_slug : string -> t option
end

module Paper : sig
  type t = {
    title : string;
    slug : string;
    publication : string;
    authors : string list;
    abstract : string;
    tags : string list;
    year : int;
    links : string list;
  }

  val all : t list

  val get_by_slug : string -> t option
end

module Success_story : sig
  type t = {
    title : string;
    slug : string;
    image : string option;
    url : string option;
    body_md : string;
    body_html : string;
  }

  val all : t list

  val get_by_slug : string -> t option
end

module Tool : sig
  type lifecycle = [ `Incubate | `Active | `Sustain | `Deprecate ]

  type t = {
    name : string;
    slug : string;
    source : string;
    license : string;
    synopsis : string;
    description : string;
    lifecycle : lifecycle;
  }

  val all : t list

  val get_by_slug : string -> t option
end

module Tutorial : sig
  type t = {
    title : string;
    slug : string;
    description : string;
    date : string;
    tags : string list;
    users : Meta.Proficiency.t list;
    body_md : string;
    toc_html : string;
    body_html : string;
  }

  val all : t list

  val get_by_slug : string -> t option
end

module Video : sig
  type kind = [ `Conference | `Mooc | `Lecture ]

  val kind_of_string : string -> (kind, [> `Msg of string ]) result

  val kind_to_string : kind -> string

  type t = {
    title : string;
    slug : string;
    description : string;
    people : string list;
    kind : kind;
    tags : string list;
    paper : string option;
    link : string;
    embed : string option;
    year : int;
  }

  val all : t list

  val get_by_slug : string -> t option
end

module Watch : sig
  type t = {
    name : string;
    embedPath : string;
    thumbnailPath : string;
    description : string;
    year : int;
    language : string;
    category : string;
  }

  val all : t list
end

module News : sig
  type t = {
    title : string;
    slug : string;
    description : string option;
    url : string;
    date : string;
    preview_image : string option;
    body_html : string;
  }

  val all : t list

  val get_by_slug : string -> t option
end

module Workshop : sig
  type role = [ `Co_chair | `Chair ]

  val role_to_string : role -> string

  val role_of_string : string -> (role, [> `Msg of string ]) result

  type important_date = { date : string; info : string }

  type committee_member = {
    name : string;
    role : role option;
    affiliation : string option;
  }

  type presentation = {
    title : string;
    authors : string list;
    link : string option;
    video : string option;
    slides : string option;
    poster : bool option;
    additional_links : string list option;
  }

  type t = {
    title : string;
    slug : string;
    location : string option;
    date : string;
    online : bool;
    important_dates : important_date list;
    presentations : presentation list;
    program_committee : committee_member list;
    organising_committee : committee_member list;
    toc_html : string;
    body_md : string;
    body_html : string;
  }

  val all : t list

  val get_by_slug : string -> t option
end
