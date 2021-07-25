let loader _root path _request =
  match Asset.read path with
  | None ->
    Dream.empty `Not_Found
  | Some asset ->
    Dream.respond asset

let media_loader _root path _request =
  match Ood_media.read path with
  | None ->
    Dream.empty `Not_Found
  | Some asset ->
    Dream.respond asset

let preview =
  Dream.scope
    "/preview"
    []
    [ Dream.get "/" Preview_handler.index
    ; Dream.get "/papers" Preview_handler.papers
    ; Dream.get "/success-stories" Preview_handler.success_stories
    ; Dream.get "/industrial-users" Preview_handler.industrial_users
    ; Dream.get "/academic-excellence" Preview_handler.academic_institutions
    ; Dream.get "/consortium" Preview_handler.consortium
    ; Dream.get "/books" Preview_handler.books
    ; Dream.get "/events" Preview_handler.events
    ; Dream.get "/videos" Preview_handler.videos
    ; Dream.get "/tools" Preview_handler.tools
    ; Dream.get "/news" Preview_handler.news
    ; Dream.get "/tutorials" Preview_handler.tutorials
    ; Dream.get "/tutorials/:id" Preview_handler.tutorial
    ; Dream.get "/workshops" Preview_handler.workshops
    ; Dream.get "/workshops/:id" Preview_handler.workshop
    ; Dream.get "/media/**" (Dream.static ~loader:media_loader "")
    ]

let routes =
  [ Dream.get "/" Page_handler.index
  ; Dream.get "/packages" Package_handler.index
  ; Dream.get "/packages/search" Package_handler.search
  ; Dream.get "/p/:name" Package_handler.package
  ; Dream.get "/u/:hash/:name" Package_handler.package
  ; Dream.get
      "/p/:name/:version"
      (Package_handler.package_versioned Package_handler.Package)
  ; Dream.get
      "/u/:hash/:name/:version"
      (Package_handler.package_versioned Package_handler.Universe)
  ; Dream.get
      "/p/:name/:version/doc/**"
      (Package_handler.package_doc Package_handler.Package)
  ; Dream.get
      "/u/:hash/:name/:version/doc/**"
      (Package_handler.package_doc Package_handler.Universe)
  ; Dream.any "/graphql" (Dream.graphql Lwt.return Schema.schema)
  ; Dream.get
      "/graphiql"
      (Dream.graphiql ~default_query:Schema.default_query "/graphql")
  ; preview
  ; Dream.get "/assets/**" (Dream.static ~loader "")
  ]

let router = Dream.router routes
