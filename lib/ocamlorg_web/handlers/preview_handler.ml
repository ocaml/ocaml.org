let index _req =
  Page_layout_template.render ~title:"Welcome to Dream!" Index_template.render
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
      (Tutorial_template.render
         (fun x -> slugify x.Ood.Tutorial.title)
         Ood.Tutorial.all
         tutorial)
    |> Dream.html
  | None ->
    Dream.not_found req

let tutorials req =
  let first = Ood.Tutorial.all |> List.hd in
  let slug = slugify first.Ood.Tutorial.title in
  Dream.redirect req ("/preview/tutorials/" ^ slug)
