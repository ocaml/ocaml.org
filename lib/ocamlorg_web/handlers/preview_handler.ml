let index _req =
  Page_layout_template.render ~title:"Preview" Preview_index_template.render
  |> Dream.html

let slugify value =
  value
  |> Str.global_replace (Str.regexp " ") "-"
  |> String.lowercase_ascii
  |> Str.global_replace (Str.regexp "[^a-z0-9\\-]") ""

let tutorial req =
  let slug = Dream.param "id" req in
  match
    List.find_opt
      (fun x -> slugify x.Ood.Tutorial.title = slug)
      Ood.Tutorial.all
  with
  | Some tutorial ->
    Page_layout_template.render
      ~title:tutorial.Ood.Tutorial.title
      (Preview_tutorial_template.render
         (fun x -> slugify x.Ood.Tutorial.title)
         Ood.Tutorial.all
         tutorial)
    |> Dream.html
  | None ->
    Dream.not_found req

let tutorials _req =
  Page_layout_template.render
    ~title:"Tutorials"
    Preview_tutorials_template.render
  |> Dream.html
