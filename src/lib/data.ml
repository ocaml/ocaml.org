open Rresult
open Netlify

let parse_yaml p yml = Yaml.of_string yml >>= p

module Paper = struct
  type t = [%import: Ood.Paper.t] [@@deriving yaml]

  let lint = parse_yaml of_yaml

  let widget_of_t =
    Widget.(`String (String.make ~label:"Paper Title" ~name:"title" ()))
end

module Papers = struct
  type t = Paper.t list [@@deriving yaml]

  let lint = parse_yaml of_yaml

  let file =
    let fields = [ Paper.widget_of_t ] in
    Netlify.Collection.Files.File.make ~name:"papers" ~label:"OCaml Papers"
      ~file:"data/papers/papers.yml" ~fields ()
end
