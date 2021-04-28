open Rresult
open Netlify

let parse_yaml p yml = Yaml.of_string yml >>= p

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
