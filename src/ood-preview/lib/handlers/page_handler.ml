let index _req =
  Layout_template.render ~title:"Welcome to Dream!" Index_template.render
  |> Dream.html

let papers _req =
  let papers = Ood.Paper.all in
  Layout_template.render ~title:"Papers" (Papers_template.render papers)
  |> Dream.html

let success_stories _req =
  let success_stories = Ood.Success_story.all in
  Layout_template.render
    ~title:"Success Stories"
    (Success_stories_template.render success_stories)
  |> Dream.html

let industrial_users _req =
  let industrial_users = Ood.Industrial_user.all in
  Layout_template.render
    ~title:"Industrial Users"
    (Industrial_users_template.render industrial_users)
  |> Dream.html

let academic_institutions _req =
  let institutions = Ood.Academic_institution.all in
  Layout_template.render
    ~title:"Academic Excellence"
    (Academic_excellence_template.render institutions)
  |> Dream.html

let consortium _req =
  let consortium =
    List.filter
      (fun x -> x.Ood.Industrial_user.consortium)
      Ood.Industrial_user.all
  in
  Layout_template.render
    ~title:"Consortium"
    (Industrial_users_template.render consortium)
  |> Dream.html

let books _req =
  let books = Ood.Book.all in
  Layout_template.render ~title:"Books" (Books_template.render books)
  |> Dream.html

let events _req =
  let events = Ood.Event.all in
  Layout_template.render ~title:"Events" (Events_template.render events)
  |> Dream.html

let videos _req =
  let videos = Ood.Video.all in
  Layout_template.render ~title:"Videos" (Videos_template.render videos)
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
    Layout_template.render
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
  Dream.redirect req ("/tutorials/" ^ slug)

let workshop req =
  let slug = Dream.param "id" req in
  match
    List.find_opt
      (fun x -> slugify x.Ood.Workshop.title = slug)
      Ood.Workshop.all
  with
  | Some workshop ->
    Layout_template.render
      ~title:workshop.Ood.Workshop.title
      (Workshop_template.render Ood.Workshop.all workshop)
    |> Dream.html
  | None ->
    Dream.not_found req

let workshops req =
  let (first : Ood.Workshop.t) = Ood.Workshop.all |> List.hd in
  let slug = slugify first.title in
  Dream.redirect req ("/workshops/" ^ slug)

let tools _req =
  let tools = Ood.Tool.all in
  Layout_template.render ~title:"Tools" (Platform_template.render tools)
  |> Dream.html

let news _req =
  let news = Ood.News.all in
  Layout_template.render ~title:"News" (News_template.render news) |> Dream.html
