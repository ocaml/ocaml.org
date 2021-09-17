let index _req =
  Page_layout_template.render
    ~title:"Preview"
    ~description:Config.meta_description
    (Preview_index_template.render ())
  |> Dream.html

let slugify value =
  value
  |> Str.global_replace (Str.regexp " ") "-"
  |> String.lowercase_ascii
  |> Str.global_replace (Str.regexp "[^a-z0-9\\-]") ""

let industrial_users _req =
  let industrial_users = Ood.Industrial_user.all_en in
  Page_layout_template.render
    ~title:"Industrial Users"
    ~description:"???"
    (Preview_industrial_users_template.render industrial_users)
  |> Dream.html

let academic_institutions _req =
  let institutions = Ood.Academic_institution.all in
  Page_layout_template.render
    ~title:"Academic Excellence"
    ~description:"???"
    (Preview_academic_excellence_template.render institutions)
  |> Dream.html

let consortium _req =
  let consortium =
    List.filter
      (fun x -> x.Ood.Industrial_user.consortium)
      Ood.Industrial_user.all_en
  in
  Page_layout_template.render
    ~title:"Consortium"
    ~description:"???"
    (Preview_industrial_users_template.render consortium)
  |> Dream.html

let books _req =
  let books = Ood.Book.all in
  Page_layout_template.render
    ~title:"Books"
    ~description:"???"
    (Preview_books_template.render books)
  |> Dream.html

let events _req =
  let events = Ood.Event.all in
  Page_layout_template.render
    ~title:"Events"
    ~description:"???"
    (Preview_events_template.render events)
  |> Dream.html

let videos _req =
  let videos = Ood.Video.all in
  Page_layout_template.render
    ~title:"Videos"
    ~description:"???"
    (Preview_videos_template.render videos)
  |> Dream.html

let watch _req =
  let watch = Ood.Watch.all in
  Page_layout_template.render
    ~title:"Watch"
    ~description:"???"
    (Preview_watch_template.render watch)
  |> Dream.html

let workshop req =
  let slug = Dream.param "id" req in
  match
    List.find_opt
      (fun x -> slugify x.Ood.Workshop.title = slug)
      Ood.Workshop.all
  with
  | Some workshop ->
    Page_layout_template.render
      ~title:workshop.Ood.Workshop.title
      ~description:"???"
      (Preview_workshop_template.render Ood.Workshop.all workshop)
    |> Dream.html
  | None ->
    Dream.not_found req

let workshops req =
  let (first : Ood.Workshop.t) = Ood.Workshop.all |> List.hd in
  let slug = slugify first.title in
  Dream.redirect req ("/workshops/" ^ slug)

let tools _req =
  let tools = Ood.Tool.all in
  Page_layout_template.render
    ~title:"Tools"
    ~description:"???"
    (Preview_platform_template.render tools)
  |> Dream.html

let news _req =
  let news = Ood.News.all in
  Page_layout_template.render
    ~title:"News"
    ~description:"???"
    (Preview_news_template.render news)
  |> Dream.html
