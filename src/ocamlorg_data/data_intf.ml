module Academic_institution = struct
  type location = { lat : float; long : float }

  type course = {
    name : string;
    acronym : string option;
    url : string option;
    teacher : string option;
    enrollment : string option;
    year : int;
    description : string;
    last_check : Ptime.t option;
    lecture_notes : bool;
    exercises : bool;
    video_recordings : bool;
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
    featured : bool option;
    image : string option;
    alternate_logo : string option;
    body_md : string;
    body_html : string;
  }
end

module Academic_testimonial = struct
  type t = {
    testimony : string;
    authors : string;
    title : string;
    publication : string;
    year : string;
  }
end

module Blog = struct
  type source = {
    id : string;
    name : string;
    url : string;
    description : string;
    publish_all : bool;
    disabled : bool;
  }

  type post = {
    title : string;
    url : string;
    slug : string;
    source : source;
    description : string option;
    authors : string list;
    date : string;
    preview_image : string option;
  }
end

module Book = struct
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
end

module Backstage = struct
  type release = {
    title : string;
    slug : string;
    date : string;
    tags : string list;
    changelog_html : string option;
    body_html : string;
    body : string;
    authors : string list;
    contributors : string list;
    project_name : string;
    versions : string list;
    github_release_tags : string list;
  }

  type post = {
    title : string;
    slug : string;
    date : string;
    tags : string list;
    body_html : string;
    body : string;
    authors : string list;
  }

  type t = Release of release | Post of post
end

module Changelog = struct
  type release = {
    title : string;
    slug : string;
    date : string;
    tags : string list;
    changelog_html : string option;
    body_html : string;
    body : string;
    authors : string list;
    contributors : string list;
    project_name : string;
    versions : string list;
    github_release_tags : string list;
  }

  type post = {
    title : string;
    slug : string;
    date : string;
    tags : string list;
    body_html : string;
    body : string;
    authors : string list;
  }

  type t = Release of release | Post of post
end

module Code_examples = struct
  type t = { title : string; body : string }
end

module Cookbook = struct
  type category = {
    title : string;
    slug : string;
    subcategories : category list;
  }

  type task = {
    title : string;
    slug : string;
    category_path : string list;
    description : string option;
  }

  type code_block_with_explanation = { code : string; explanation : string }

  type package = {
    name : string;
    tested_version : string;
    used_libraries : string list;
  }

  type t = {
    slug : string;
    filepath : string;
    task : task;
    packages : package list;
    code_blocks : code_block_with_explanation list;
    code_plaintext : string;
    discussion_html : string;
  }
end

module Event = struct
  type event_type = Meetup | Conference | Seminar | Hackathon | Retreat
  type location = { lat : float; long : float }

  type recurring_event = {
    title : string;
    url : string;
    slug : string;
    country : string;
    city : string;
    location : location option;
    event_type : event_type;
  }

  type utc_datetime = { yyyy_mm_dd : string; utc_hh_mm : string option }

  type t = {
    title : string;
    url : string;
    slug : string;
    country : string;
    city : string;
    location : location option;
    starts : utc_datetime;
    submission_deadline : utc_datetime option;
    author_notification_date : utc_datetime option;
    ends : utc_datetime option;
    body_md : string;
    body_html : string;
    recurring_event : recurring_event option;
    event_type : event_type;
  }
end

module Exercise = struct
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
end

module Governance = struct
  type member = { name : string; github : string; role : string }
  type contact_kind = GitHub | Email | Discord | Chat | Forum
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
    members : member list;
    subteams : team list;
  }
end

module Industrial_user = struct
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
end

module Is_ocaml_yet = struct
  type external_package = { url : string; synopsis : string }
  type package = { name : string; extern : external_package option }

  type category = {
    name : string;
    status : string;
    description : string;
    packages : package list;
    slug : string;
  }

  type t = {
    id : string;
    question : string;
    answer : string;
    categories : category list;
    body_html : string;
  }
end

module Job = struct
  type t = {
    title : string;
    link : string;
    locations : string list;
    publication_date : string option;
    company : string;
    company_logo : string;
  }
end

module Testimonial = struct
  type t = {
    person : string;
    testimony : string;
    href : string;
    role : string;
    logo : string;
  }
end

module News = struct
  type t = {
    title : string;
    description : string;
    date : string;
    slug : string;
    tags : string list;
    body_html : string;
    authors : string list;
  }
end

module Opam_user = struct
  type t = {
    name : string;
    email : string option;
    github_username : string option;
    avatar : string option;
  }
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

  type t = { name : string; projects : project list }
end

module Page = struct
  type t = {
    slug : string;
    title : string;
    description : string;
    meta_title : string;
    meta_description : string;
    body_md : string;
    body_html : string;
  }
end

module Paper = struct
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
end

module Release = struct
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
end

module Resource = struct
  type t = {
    title : string;
    description : string;
    image : string;
    online_url : string;
    source_url : string option;
    featured : bool;
  }
end

module Success_story = struct
  type t = {
    title : string;
    slug : string;
    logo : string;
    card_logo : string;
    background : string;
    theme : string;
    synopsis : string;
    url : string;
    why_ocaml_reasons : string list option;
    priority : int;
    body_md : string;
    body_html : string;
  }
end

module Tool = struct
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
end

module Tool_page = struct
  type toc = { title : string; href : string; children : toc list }
  type contribute_link = { url : string; description : string }

  type t = {
    title : string;
    short_title : string;
    fpath : string;
    slug : string;
    description : string;
    category : string;
    body_md : string;
    toc : toc list;
    body_html : string;
  }
end

module Tutorial = struct
  type section = GetStarted | Language | Platform | Guides
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

  type language = English | Japanese [@@deriving show, equal, compare]

  type t = {
    title : string;
    short_title : string;
    fpath : string;
    slug : string;
    description : string;
    section : section;
    category : string;
    external_tutorial : external_tutorial option;
    body_md : string;
    toc : toc list;
    body_html : string;
    recommended_next_tutorials : recommended_next_tutorials;
    prerequisite_tutorials : prerequisite_tutorials;
    language : language;
  }
end

module Video = struct
  type t = {
    title : string;
    url : string;
    thumbnail : string;
    description : string;
    published : string;
    author_name : string;
    author_uri : string;
    source_link : string;
    source_title : string;
  }
end

module Conference = struct
  type role = [ `Co_chair | `Chair ]
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
    watch_ocamlorg_video : string option;
    youtube_video : string option;
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
end

(* Depends on Video and Blog modules to define the different kinds of entries of
   the OCaml Planet *)
module Planet = struct
  type entry = BlogPost of Blog.post | Video of Video.t
end
