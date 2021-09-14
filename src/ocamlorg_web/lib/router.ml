let v3_loader root path =
  let path =
    let fpath = Fpath.v path in
    if Fpath.is_dir_path fpath || not (Fpath.exists_ext fpath) then
      Filename.concat path "index.html"
    else
      path
  in
  Dream.from_filesystem root path

let loader root path request =
  match Asset.read (root ^ path) with
  | None ->
    Page_handler.not_found request
  | Some asset ->
    Dream.respond ~headers:(Dream.mime_lookup path) asset

let media_loader _root path request =
  match Media.read path with
  | None ->
    Page_handler.not_found request
  | Some asset ->
    Dream.respond asset

let site_route =
  Dream.scope
    ""
    [ Middleware.i18n ]
    [ Dream.get "/**" (Dream.static ~loader:v3_loader Config.site_dir) ]

let pages_routes =
  Dream.scope
    ""
    []
    [ Dream.get Url.principles_successes Page_handler.success_stories
    ; Dream.get (Url.principles_successes ^ "/:id") Page_handler.success_story
    ]

let preview_routes =
  Dream.scope
    "/preview"
    []
    [ Dream.get "" Preview_handler.index
    ; Dream.get "/tutorials" Preview_handler.tutorials
    ; Dream.get "/tutorials/:id" Preview_handler.tutorial
    ; Dream.get "/media/**" (Dream.static ~loader:media_loader "")
    ]

let package_route t =
  Dream.scope
    ""
    []
    [ Dream.get "/packages" Package_handler.index
    ; Dream.get "/packages/" Package_handler.index
    ; Dream.get "/packages/search" (Package_handler.search t)
    ; Dream.get "/p/:name" (Package_handler.package t)
    ; Dream.get "/u/:hash/:name" (Package_handler.package t)
    ; Dream.get
        "/p/:name/:version"
        ((Package_handler.package_versioned t) Package_handler.Package)
    ; Dream.get
        "/u/:hash/:name/:version"
        ((Package_handler.package_versioned t) Package_handler.Universe)
    ; Dream.get
        "/p/:name/:version/doc/**"
        ((Package_handler.package_doc t) Package_handler.Package)
    ; Dream.get
        "/u/:hash/:name/:version/doc/**"
        ((Package_handler.package_doc t) Package_handler.Universe)
    ]

let graphql_route t =
  Dream.scope
    ""
    []
    [ Dream.any "/api" (Dream.graphql Lwt.return (Graphql.schema t))
    ; Dream.get "/graphiql" (Dream.graphiql "/api")
    ]

let router t =
  Dream.router
    [ pages_routes
    ; package_route t
    ; graphql_route t
    ; preview_routes
    ; Dream.get "/assets/**" (Dream.static ~loader "")
      (* Used for the previews *)
    ; Dream.get "/media/**" (Dream.static ~loader:media_loader "")
      (* Last one so that we don't apply the index html middleware on every
         route. *)
    ; site_route
    ]
