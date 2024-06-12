open Data_intf.Outreachy

let modify_project (p : project) =
  {
    p with
    description =
      p.description |> Markdown.Content.of_string |> Markdown.Content.render;
  }

let modify (p : t) = { p with projects = List.map modify_project p.projects }

let all () =
  Utils.yaml_sequence_file ~key:"rounds" of_yaml "outreachy.yml"
  |> List.map modify

let template () =
  Format.asprintf {|
include Data_intf.Outreachy
let all = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
