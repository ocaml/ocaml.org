open Rresult
open Netlify
open Ood
module Jf = Jekyll_format

let parse_yaml p yml = Yaml.of_string yml >>= p

let parse_jekyll yaml_p txt =
  Jf.of_string txt >>= fun jekyll ->
  Jf.fields jekyll |> Jf.fields_to_yaml |> yaml_p

module Paper = struct
  type t = [%import: Ood.Papers.Paper.t] [@@deriving yaml]

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
        `List (Lst.make ~label:"Links" ~name:"links" ());
      ]
end

module Papers = struct
  type t = [%import: Ood.Papers.t] [@@deriving yaml]

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

module Event = struct
  type t = [%import: Ood.Events.Event.t] [@@deriving yaml]

  let lint = parse_yaml of_yaml

  let widget_of_t =
    Widget.
      [
        `String (String.make ~label:"Event Name" ~name:"title" ());
        `String (String.make ~label:"Short Description" ~name:"description" ());
        `String (String.make ~label:"URL" ~name:"url" ());
        `DateTime DateTime.(make ~label:"Date" ~name:"date" ~picker_utc:true ());
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
  type t = [%import: Ood.Events.t] [@@deriving yaml]

  let lint = parse_yaml of_yaml

  let path = "data/events.yml"

  let file =
    let fields =
      [
        `List
          (* XXX(patricoferris): Collapsed set to false because of https://github.com/netlify/netlify-cms/issues/4385#issuecomment-748495080
             should contribute a fix to upstream if this is still the case in latest versions *)
          (Widget.Lst.make ~label:"Events" ~name:"events" ~collapsed:false
             ~add_to_top:true ~fields:Event.widget_of_t ());
      ]
    in
    Netlify.Collection.Files.File.make ~name:"events" ~label:"OCaml Events"
      ~file:path ~fields ()
end

module Tutorial = struct
  type user = [%import: Ood.Meta.Proficiency.t] [@@deriving enumerate]

  let user_to_yaml user = `String (Meta.Proficiency.to_string user)

  let user_of_yaml = function
    | `String s -> Meta.Proficiency.of_string s
    | _ -> Error (`Msg "Expected yaml string")

  type t = [%import: (Ood.Tutorial.t[@with Ood.Meta.Proficiency.t := user])]
  [@@deriving yaml]

  let path = "data/tutorials"

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
              ~options:
                (Strings (List.map Meta.Proficiency.to_string all_of_user))
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
