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

let redirect s req = Dream.redirect req s

let redirection_routes =
  Dream.scope
    ""
    []
    (List.map
       (fun (origin, new_) ->
         Dream.get origin (fun req ->
             Dream.redirect ~status:`Moved_Permanently req new_))
       Redirection.t)

let page_routes =
  Dream.scope
    ""
    [ Middleware.set_locale ]
    [ Dream.get Url.index Page_handler.index
    ; Dream.get Url.history Page_handler.history
    ; Dream.get Url.around_web Page_handler.around_web
    ; Dream.get Url.events Page_handler.events
    ; Dream.get (Url.events ^ "/:id") Page_handler.events_workshop
    ; Dream.get Url.media_archive Page_handler.media_archive
    ; Dream.get Url.news Page_handler.news
    ; Dream.get Url.opportunities Page_handler.opportunities
    ; Dream.get (Url.opportunities ^ "/:id") Page_handler.opportunity
    ; Dream.get Url.successes Page_handler.successes
    ; Dream.get (Url.successes ^ "/:id") Page_handler.success
    ; Dream.get Url.industrial_users Page_handler.industrial_users
    ; Dream.get Url.academic Page_handler.academic
    ; Dream.get Url.what_is_ocaml Page_handler.what_is_ocaml
    ; Dream.get Url.carbon_footprint Page_handler.carbon_footprint
    ; Dream.get Url.privacy Page_handler.privacy
    ; Dream.get Url.terms Page_handler.terms
    ; Dream.get Url.applications Page_handler.applications
    ; Dream.get Url.archive Page_handler.archive
    ; Dream.get Url.best_practices Page_handler.best_practices
    ; Dream.get Url.language Page_handler.language
    ; Dream.get Url.papers Page_handler.papers
    ; Dream.get Url.platform Page_handler.platform
    ; Dream.get Url.problems Page_handler.problems
    ; Dream.get Url.releases Page_handler.releases
    ; Dream.get (Url.releases ^ "/:id") Page_handler.release
    ; Dream.get Url.books Page_handler.books
    ; Dream.get Url.tutorials Page_handler.tutorials
    ; Dream.get (Url.tutorials ^ "/:id") Page_handler.tutorial
    ]

let package_route t =
  Dream.scope
    ""
    [ Middleware.set_locale ]
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
        "/p/:name/:version/top"
        ((Package_handler.package_toplevel t) Package_handler.Package)
    ; Dream.get
        "/u/:hash/:name/:version/top"
        ((Package_handler.package_toplevel t) Package_handler.Universe)
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

let toplevels_route =
  Dream.scope
    "/toplevels"
    [ Dream_encoding.compress ]
    [ Dream.get "/**" (Dream.static (Fpath.to_string Ocamlorg.toplevels_path)) ]

let router t =
  Dream.router
    [ page_routes
    ; package_route t
    ; graphql_route t
    ; redirection_routes
    ; toplevels_route
    ; Dream.get "/assets/**" (Dream.static ~loader "")
    ; Dream.get "/media/**" (Dream.static ~loader:media_loader "")
      (* Last one so that we don't apply the index html middleware on every
         route. *)
    ]
