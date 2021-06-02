(* Netlify CMS configurations *)
module Widget = Widget
module Server = Server
open Widget

(* Beta Feature for Internationalisation *)
module I18n : sig
  module Toplevel : sig
    type structure = [ `Multiple_folders | `Multiple_files | `Single_file ]
    [@@deriving yaml]

    type t = {
      structure : structure;
      locales : string list;
      default_locale : string option;
    }
    [@@deriving make, yaml]
  end

  module Collection_level : sig
    type t = [ `Toplevel of Toplevel.t | `Boolean of bool ] [@@deriving yaml]
  end
end

module Collection : sig
  type format =
    | Yaml
    | Toml
    | Json
    | Yaml_frontmatter
    | Toml_frontmatter
    | Json_frontmatter

  type view_filter = { label : string; field : string; pattern : string }
  [@@deriving make, yaml]

  module Folder : sig
    type t = {
      name : string;
      label : string option;
      label_singular : string option;
      description : string option;
      folder : string;
      i18n : I18n.Collection_level.t option;
      summary : string option;
      filter : string option;
      publish : bool option;
      hide : bool option;
      create : bool option;
      identifier_field : string option;
      delete : bool option;
      extension : string option;
      format : format option;
      frontmatter_delimiter : string option;
      slug : string option;
      preview_path : string option;
      preview_path_date_field : string option;
      view_filters : view_filter list option;
      view_groups : view_filter list option;
      fields : Widget.t list;
    }
    [@@deriving make, yaml]
  end

  module Files : sig
    module File : sig
      type t = {
        label : string;
        name : string;
        file : string;
        fields : Widget.t list;
        i18n : bool option;
      }
      [@@deriving make, yaml]
    end

    type t = {
      label : string;
      name : string;
      files : File.t list;
      i18n : I18n.Collection_level.t option;
    }
    [@@deriving make, yaml]
  end

  type t = Folder of Folder.t | Files of Files.t
end

module Backend : sig
  type name = Github | Gitlab | GitGateway

  type t = {
    name : name;
    repo : string option;
    branch : string option;
    commit_messages : Yaml.value option;
    api_root : string option;
    site_domain : string option;
    base_url : string option;
    auth_endpoint : string option;
    cms_label_prefix : string option;
  }
  [@@deriving make, yaml]
end

module Media : sig
  type t = { name : string; config : Yaml.value option } [@@deriving make, yaml]
end

module Slug : sig
  type t = {
    encoding : string;
    clean_accents : bool option;
    sanitize_replacement : string option;
  }
  [@@deriving make, yaml]
end

type t = {
  backend : Backend.t;
  local_backend : bool option;
  i18n : I18n.Toplevel.t option;
  media_folder : string;
  media_library : Media.t option;
  publish_mode : string option;
  public_folder : string option;
  site_url : string option;
  display_url : string option;
  logo_url : string option;
  locale : string option;
  show_preview_links : bool option;
  slug : Slug.t option;
  collections : Collection.t list;
}
[@@deriving make, yaml]

module Pp : sig
  val pp : ?comment:bool -> unit -> t Fmt.t
end
