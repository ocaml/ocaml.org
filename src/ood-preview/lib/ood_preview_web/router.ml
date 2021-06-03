let loader _root path _request =
  match Asset.read path with
  | None ->
    Dream.empty `Not_Found
  | Some asset ->
    Dream.respond asset

let media_loader _root path _request =
  match Ood_preview.Media.read path with
  | None ->
    Dream.empty `Not_Found
  | Some asset ->
    Dream.respond asset

let routes =
  [ Dream.get "/" Page_handler.index
  ; Dream.get "/papers" Page_handler.papers
  ; Dream.get "/success-stories" Page_handler.success_stories
  ; Dream.get "/books" Page_handler.books
  ; Dream.get "/events" Page_handler.events
  ; Dream.get "/videos" Page_handler.videos
  ; Dream.get "/tutorials" Page_handler.tutorials
  ; Dream.get "/tutorials/:id" Page_handler.tutorial
  ; Dream.get "/assets/**" (Dream.static ~loader "")
  ; Dream.get "/media/**" (Dream.static ~loader:media_loader "")
  ]

let router = Dream.router routes
