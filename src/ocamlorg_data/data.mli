module Academic_institution : sig
  include module type of Data_intf.Academic_institution

  val all : t list
  val get_by_slug : string -> t option
end

module Book : sig
  include module type of Data_intf.Book

  val all : t list
  val get_by_slug : string -> t option
end

module Changelog : sig
  include module type of Data_intf.Changelog

  val all : t list
  val get_by_slug : string -> t option
end

module Code_example : sig
  type t = { title : string; body : string }

  val get : string -> t
end

module Cookbook : sig
  include module type of Data_intf.Cookbook

  val top_categories : category list
  val tasks : task list
  val all : t list
  val get_task_path_titles : category list -> string list -> string list
  val get_tasks_by_category : category_slug:string -> task list
  val get_by_task : task_slug:string -> t list
  val get_by_slug : task_slug:string -> string -> t option
  val full_title_of_recipe : t -> string
  val main_package_of_recipe : t -> string
end

module Event : sig
  type event_type = Meetup | Conference | Seminar | Hackathon | Retreat
  type location = { lat : float; long : float }

  module RecurringEvent : sig
    type t = {
      slug : string;
      title : string;
      url : string;
      textual_location : string;
      location : location option;
      event_type : event_type;
    }

    val all : t list
    val get_by_slug : string -> t option
  end

  type utc_datetime = { yyyy_mm_dd : string; utc_hh_mm : string option }

  type t = {
    title : string;
    url : string;
    slug : string;
    textual_location : string;
    location : location option;
    starts : utc_datetime;
    ends : utc_datetime option;
    body_md : string;
    body_html : string;
    recurring_event : RecurringEvent.t option;
    event_type : event_type;
  }

  val all : t list
  val get_by_slug : string -> t option
end

module Exercise : sig
  include module type of Data_intf.Exercise

  val all : t list
  val filter_tag : ?tag:string -> t list -> t list
  val get_by_slug : string -> t option
end

module Governance : sig
  include module type of Data_intf.Governance

  val teams : team list
  val working_groups : team list
  val get_by_id : string -> team option
end

module Industrial_user : sig
  include module type of Data_intf.Industrial_user

  val all : t list
  val featured : t list
  val get_by_slug : string -> t option
end

module Is_ocaml_yet : sig
  include module type of Data_intf.Is_ocaml_yet

  val all : t list
end

module Job : sig
  include module type of Data_intf.Job

  val all : t list
end

module News : sig
  include module type of Data_intf.News

  val all : t list
  val get_by_slug : string -> t option
end

module Opam_user : sig
  include module type of Data_intf.Opam_user

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

module Outreachy : sig
  include module type of Data_intf.Outreachy

  val all : t list
end

module Page : sig
  include module type of Data_intf.Page

  val get : string -> t
end

module Paper : sig
  include module type of Data_intf.Paper

  val all : t list
  val featured : t list
  val get_by_slug : string -> t option
end

module Planet : sig
  type source = Data_intf.Planet.source

  module Post : sig
    type t = Data_intf.Planet.Post.t

    val all : t list
  end

  module LocalBlog : sig
    type t = Data_intf.Planet.LocalBlog.t

    val all : t list
    val get_by_id : string -> t option
  end

  val local_posts : Post.t list
end

module Release : sig
  include module type of Data_intf.Release

  val all : t list
  val get_by_version : string -> t option
  val latest : t
  val lts : t
end

module Resource : sig
  include module type of Data_intf.Resource

  val all : t list
  val featured : t list
end

module Success_story : sig
  include module type of Data_intf.Success_story

  val all : t list
  val get_by_slug : string -> t option
end

module Tool : sig
  include module type of Data_intf.Tool

  val all : t list
  val get_by_slug : string -> t option
end

module Tool_page : sig
  include module type of Data_intf.Tool_page

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

module Watch : sig
  include module type of Data_intf.Watch

  val all : t list
end

module Workshop : sig
  include module type of Data_intf.Workshop

  val all : t list
  val get_by_slug : string -> t option
end
