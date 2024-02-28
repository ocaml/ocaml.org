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
  type difficulty = Beginner | Intermediate | Advanced
  type link = { description : string; uri : string }

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

  val all : t list
  val get_by_slug : string -> t option
end

module Changelog : sig
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

  val all : t list
  val get_by_slug : string -> t option
end

module Job : sig
  type t = {
    title : string;
    link : string;
    locations : string list;
    publication_date : string option;
    company : string;
    company_logo : string;
  }

  val all : t list
end

module Outreachy : sig
  type project = {
    title : string;
    description : string;
    mentee : string;
    blog : string option;
    source : string;
    mentors : string list;
    video : string option;
  }

  type t = { name : string; projects : project list }

  val all : t list
end

module Industrial_user : sig
  type t = {
    name : string;
    slug : string;
    description : string;
    logo : string option;
    url : string;
    locations : string list;
    consortium : bool;
    featured : bool;
    body_md : string;
    body_html : string;
  }

  val all : t list
  val featured : t list
  val get_by_slug : string -> t option
end

module Paper : sig
  type link = { description : string; uri : string }

  type t = {
    title : string;
    slug : string;
    publication : string;
    authors : string list;
    abstract : string;
    tags : string list;
    year : int;
    links : link list;
    featured : bool;
  }

  val all : t list
  val featured : t list
  val get_by_slug : string -> t option
end

module Exercise : sig
  type difficulty = Beginner | Intermediate | Advanced

  type t = {
    title : string;
    slug : string;
    difficulty : difficulty;
    tags : string list;
    description : string;
    statement : string;
    solution : string;
    tutorials : string list;
  }

  val all : t list
  val filter_tag : ?tag:string -> t list -> t list
  val get_by_slug : string -> t option
end

module Success_story : sig
  type t = {
    title : string;
    slug : string;
    logo : string;
    background : string;
    theme : string;
    synopsis : string;
    url : string;
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
  module Section : sig
    type t = GetStarted | Language | Platform | Guides
  end

  type toc = { title : string; href : string; children : toc list }
  type contribute_link = { url : string; description : string }
  type banner = { image : string; url : string; alt : string }

  type external_tutorial = {
    tag : string;
    banner : banner;
    contribute_link : contribute_link;
  }

  type recommended_next_tutorials = string list
  type prerequisite_tutorials = string list
  type search_document_section = { title : string; id : string }

  type search_document = {
    title : string;
    category : string;
    section : search_document_section option;
    content : string;
    slug : string;
  }

  type t = {
    title : string;
    short_title : string;
    fpath : string;
    slug : string;
    description : string;
    section : Section.t;
    category : string;
    external_tutorial : external_tutorial option;
    body_md : string;
    toc : toc list;
    body_html : string;
    recommended_next_tutorials : recommended_next_tutorials;
    prerequisite_tutorials : prerequisite_tutorials;
  }

  val all : t list
  val all_search_documents : search_document list
  val get_by_slug : string -> t option
  val search_documents : string -> search_document list
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
    embed_path : string;
    thumbnail_path : string;
    description : string option;
    published_at : string;
    language : string;
    category : string;
  }

  val all : t list
end

module Planet : sig
  type source = {
    id : string;
    name : string;
    url : string;
    description : string;
    disabled : bool;
  }

  module Post : sig
    type t = {
      title : string;
      url : string option;
      slug : string;
      source : source;
      description : string option;
      authors : string list;
      date : string;
      preview_image : string option;
      featured : bool;
      body_html : string;
    }

    val all : t list
  end

  module LocalBlog : sig
    type t = { source : source; posts : Post.t list; rss_feed : string }

    val get_by_id : string -> t option
  end

  val featured_posts : Post.t list
end

module Opam_user : sig
  type t = {
    name : string;
    email : string option;
    github_username : string option;
    avatar : string option;
  }

  val all : t list

  val make :
    name:string ->
    ?email:string ->
    ?github_username:string ->
    ?avatar:string ->
    unit ->
    t

  val find_by_name : string -> t option
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
    picture : string option;
  }

  type presentation = {
    title : string;
    authors : string list;
    link : string option;
    video : string option;
    slides : string option;
    poster : bool;
    additional_links : string list;
  }

  type t = {
    title : string;
    slug : string;
    location : string;
    date : string;
    important_dates : important_date list;
    presentations : presentation list;
    program_committee : committee_member list;
    organising_committee : committee_member list;
    body_md : string;
    body_html : string;
  }

  val all : t list
  val get_by_slug : string -> t option
end

module Release : sig
  type kind = [ `Compiler ]

  type t = {
    kind : kind;
    version : string;
    date : string;
    is_latest : bool;
    is_lts : bool;
    intro_md : string;
    intro_html : string;
    highlights_md : string;
    highlights_html : string;
    body_md : string;
    body_html : string;
  }

  val all : t list
  val get_by_version : string -> t option
  val latest : t
  val lts : t
end

module News : sig
  type t = {
    title : string;
    slug : string;
    description : string;
    date : string;
    tags : string list;
    body_html : string;
    authors : string list;
  }

  val all : t list
  val get_by_slug : string -> t option
end

module Page : sig
  type t = {
    slug : string;
    title : string;
    description : string;
    meta_title : string;
    meta_description : string;
    body_md : string;
    body_html : string;
  }

  val get : string -> t
end

module Code_example : sig
  type t = { title : string; body : string }

  val get : string -> t
end

module Is_ocaml_yet : sig
  type external_package = { url : string; synopsis : string }
  type package = { name : string; extern : external_package option }

  type category = {
    name : string;
    status : string;
    description : string;
    packages : package list;
  }

  type t = {
    id : string;
    question : string;
    answer : string;
    categories : category list;
    body_html : string;
  }

  val all : t list
end

module Event : sig
  type location = { lat : float; long : float }

  module RecurringEvent : sig
    type t = {
      slug : string;
      title : string;
      url : string;
      textual_location : string;
      location : location option;
    }

    val all : t list
    val get_by_slug : string -> t option
  end

  type t = {
    title : string;
    url : string;
    slug : string;
    textual_location : string;
    location : location option;
    starts : string;
    ends : string option;
    body_md : string;
    body_html : string;
    recurring_event : RecurringEvent.t option;
  }

  val all : t list
  val get_by_slug : string -> t option
end

module Governance : sig
  module Member : sig
    type t = { name : string; github : string; role : string }

    val compare : t -> t -> int
  end

  type contact_kind = GitHub | Email | Discord | Chat
  type contact = { name : string; link : string; kind : contact_kind }

  type dev_meeting = {
    date : string;
    time : string;
    link : string;
    calendar : string option;
    notes : string;
  }

  type team = {
    id : string;
    name : string;
    description : string;
    contacts : contact list;
    dev_meeting : dev_meeting option;
    members : Member.t list;
    subteams : team list;
  }

  val teams : team list
  val working_groups : team list
  val get_by_id : string -> team option
end

module Cookbook : sig
  type category = { title : string; slug : string }
  type task = { title : string; slug : string; category : category }
  type code_block_with_explanation = { code : string; explanation : string }
  type package = { name : string; version : string }

  type t = {
    slug : string;
    filepath : string;
    task : task;
    packages : package list;
    libraries : string list;
    ppxes : string list;
    code_blocks : code_block_with_explanation list;
    code_plaintext : string;
    body_html : string;
  }

  val categories : category list
  val tasks : task list
  val all : t list
  val get_tasks_by_category : category_slug:string -> task list
  val get_by_task : task_slug:string -> t list
  val get_by_slug : task_slug:string -> string -> t option
end
