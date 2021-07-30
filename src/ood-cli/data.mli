module Paper : sig
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

  include S.Data with type t := t
end

module Papers : sig
  type t = { papers : Paper.t list } [@@deriving yaml]

  include S.FileData with type t := t
end

module Video : sig
  type kind = [ `Conference | `Mooc | `Lecture ] [@@deriving yaml]

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

  include S.Data with type t := t
end

module Videos : sig
  type t = { videos : Video.t list } [@@deriving yaml]

  include S.FileData with type t := t
end

module Event : sig
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

  include S.Data with type t := t
end

module Events : sig
  type t = { events : Event.t list } [@@deriving yaml]

  include S.FileData with type t := t
end

module Tutorial : sig
  type user = [ `Advanced | `Beginner | `Intermediate ] [@@deriving yaml]

  type t = {
    title : string;
    description : string;
    date : string;
    tags : string list;
    users : user list;
  }
  [@@deriving yaml]

  include S.FolderData with type t := t
end

module Success_story : sig
  type t = { title : string; image : string option; url : string option }
  [@@deriving yaml]

  include S.FolderData with type t := t
end

module Book : sig
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

  include S.FolderData with type t := t
end

module Industrial_user : sig
  type t = {
    name : string;
    description : string;
    image : string option;
    site : string;
    locations : string list;
    consortium : bool;
  }
  [@@deriving yaml]

  include S.FolderData with type t := t
end

module Academic_institution : sig
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

  include S.FolderData with type t := t
end

module Workshop : sig
  type role = [ `Chair | `Co_chair ]

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

  include S.FolderData with type t := t
end
