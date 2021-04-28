(* Netlify CMS configurations *)
module Widget = Widget
module Server = Server
open Widget

module Collection = struct
  type format =
    | Yaml
    | Toml
    | Json
    | Yaml_frontmatter
    | Toml_frontmatter
    | Json_frontmatter

  let format_to_yaml = function
    | Yaml -> `String "yaml"
    | Toml -> `String "toml"
    | Json -> `String "json"
    | Yaml_frontmatter -> `String "yaml-frontmatter"
    | Toml_frontmatter -> `String "toml-frontmatter"
    | Json_frontmatter -> `String "json-frontmatter"

  let format_of_yaml = function
    | `String "yaml" -> Ok Yaml
    | `String "yml" -> Ok Yaml
    | `String "toml" -> Ok Toml
    | `String "json" -> Ok Json
    | `String "yaml-frontmatter" -> Ok Yaml_frontmatter
    | `String "toml-frontmatter" -> Ok Toml_frontmatter
    | `String "json-frontmatter" -> Ok Json_frontmatter
    | _ -> Error (`Msg "failed to parse the format string")

  type view_filter = { label : string; field : string; pattern : string }
  [@@deriving make, yaml]

  module Folder = struct
    type t = {
      name : string;
      label : string option;
      label_singular : string option;
      description : string option;
      folder : string;
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

  module Files = struct
    module File = struct
      type t = {
        label : string;
        name : string;
        file : string;
        fields : Widget.t list;
      }
      [@@deriving make, yaml]
    end

    type t = { label : string; name : string; files : File.t list }
    [@@deriving make, yaml]
  end

  type t = Folder of Folder.t | Files of Files.t

  let to_yaml = function
    | Folder f -> Folder.to_yaml f
    | Files f -> Files.to_yaml f

  let of_yaml t =
    let open Rresult in
    match t with
    | `O assoc as collection -> (
        match List.assoc_opt "folder" assoc with
        | Some _ -> Folder.of_yaml collection >>| fun folder -> Folder folder
        | None -> (
            match List.assoc_opt "files" assoc with
            | Some _ -> Files.of_yaml collection >>| fun folder -> Files folder
            | _ -> Error (`Msg "Expect folder") ) )
    | _ -> Error (`Msg "Expect object for folder or file collection but got")
end

module Backend = struct
  type name = Github | Gitlab | GitGateway

  let name_of_yaml = function
    | `String "github" -> Ok Github
    | `String "gitlab" -> Ok Gitlab
    | `String "git-gateway" -> Ok GitGateway
    | _ -> Error (`Msg "Unknown backend type")

  let name_to_yaml = function
    | Github -> `String "github"
    | Gitlab -> `String "gitlab"
    | GitGateway -> `String "git-gateway"

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

module Media = struct
  type t = { name : string; config : Yaml.value option } [@@deriving make, yaml]
end

module Slug = struct
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

module Pp = struct
  (* Code within to_string taken from https://github.com/avsm/ocaml-yaml/blob/master/lib/yaml.ml#L65 and modified
      the main modifications are to prevent `Null from being printed *)
  let to_string ?len ?(encoding = `Utf8) ?scalar_style ?layout_style
      (v : Yaml.value) =
    let open Yaml in
    let open Rresult in
    let scalar ?anchor ?tag ?(plain_implicit = true) ?(quoted_implicit = false)
        ?(style = `Plain) value =
      { anchor; tag; plain_implicit; quoted_implicit; style; value }
    in
    let all_short =
      List.for_all (function
        | `String _ -> true
        | `Float _ -> true
        | `Bool _ -> true
        | _ -> false)
    in
    Stream.emitter ?len () >>= fun t ->
    Stream.stream_start t encoding >>= fun () ->
    Stream.document_start t >>= fun () ->
    let rec iter ?(key = false) = function
      | `Null -> Stream.scalar (scalar "") t
      | `String s ->
          if key then Stream.scalar (scalar ?style:scalar_style s) t
          else
            Stream.scalar
              (scalar ~style:`Double_quoted ~plain_implicit:true
                 ~quoted_implicit:true s)
              t
      | `Float s -> Stream.scalar (scalar (Printf.sprintf "%.16g" s)) t
      (* NOTE: Printf format on the line above taken from the jsonm library *)
      | `Bool s -> Stream.scalar (scalar (string_of_bool s)) t
      | `A l ->
          let style =
            if List.length l <= 7 && all_short l then Some `Flow
            else layout_style
          in
          Stream.sequence_start ?style t >>= fun () ->
          let rec fn = function
            | [] -> Stream.sequence_end t
            | hd :: tl -> iter hd >>= fun () -> fn tl
          in
          fn l
      | `O l -> (
          let rec fn = function
            | [] -> Stream.mapping_end t
            | (k, v) :: tl ->
                iter ~key:true (`String k) >>= fun () ->
                iter v >>= fun () -> fn tl
          in
          match List.assoc_opt "widget" l with
          | Some (`String s) when s <> Object.widget_name ->
              Stream.mapping_start ?style:(Some `Flow) t >>= fun () -> fn l
          | _ -> Stream.mapping_start ?style:layout_style t >>= fun () -> fn l )
    in
    iter v >>= fun () ->
    Stream.document_end t >>= fun () ->
    Stream.stream_end t >>= fun () ->
    let r = Stream.emitter_buf t in
    Ok (Bytes.to_string r)

  let no_nulls ppf s =
    let rec remove : Yaml.value -> Yaml.value =
     fun s ->
      match s with
      | `O a ->
          let no_null = List.filter (fun (_, v) -> v <> `Null) a in
          `O (List.map (fun (s, v) -> (s, remove v)) no_null)
      | `A a ->
          let no_null = List.filter (fun v -> v <> `Null) a in
          `A (List.map (fun v -> remove v) no_null)
      | e -> e
    in
    match to_string (remove s) with
    | Ok s -> Format.pp_print_string ppf s
    | Error (`Msg m) ->
        Format.pp_print_string ppf (Printf.sprintf "(error (%s))" m)

  let pp ppf v =
    let pp = no_nulls in
    pp ppf (to_yaml v)
end
