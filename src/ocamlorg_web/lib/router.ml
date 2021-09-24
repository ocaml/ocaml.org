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

let preview_routes =
  Dream.scope
    "/preview"
    [ Middleware.set_locale; Middleware.no_trailing_slash ]
    [ Dream.get "" Preview_handler.index
    ; Dream.get "/industrial-users" Preview_handler.industrial_users
    ; Dream.get "/academic-excellence" Preview_handler.academic_institutions
    ; Dream.get "/consortium" Preview_handler.consortium
    ; Dream.get "/books" Preview_handler.books
    ; Dream.get "/events" Preview_handler.events
    ; Dream.get "/videos" Preview_handler.videos
    ; Dream.get "/watch" Preview_handler.watch
    ; Dream.get "/tools" Preview_handler.tools
    ; Dream.get "/news" Preview_handler.news
    ; Dream.get "/workshops" Preview_handler.workshops
    ; Dream.get "/workshops/:id" Preview_handler.workshop
    ; Dream.get "/media/**" (Dream.static ~loader:media_loader "")
    ]

let page_routes =
  Dream.scope
    ""
    [ Middleware.set_locale; Middleware.no_trailing_slash ]
    [ Dream.get Url.index Page_handler.index
    ; Dream.get Url.history Page_handler.history
    ; Dream.get Url.community_around_web Page_handler.community_around_web
    ; Dream.get Url.community_events Page_handler.community_events
    ; Dream.get
        (Url.community_events ^ "/:id")
        Page_handler.community_events_workshop
    ; Dream.get Url.community_media_archive Page_handler.community_media_archive
    ; Dream.get Url.community_news Page_handler.community_news
    ; Dream.get Url.community_news_archive Page_handler.community_news_archive
    ; Dream.get Url.community_opportunities Page_handler.community_opportunities
    ; Dream.get
        (Url.community_opportunities ^ "/:id")
        Page_handler.community_opportunity
    ; Dream.get Url.principles_successes Page_handler.principles_successes
    ; Dream.get
        Url.principles_industrial_users
        Page_handler.principles_industrial_users
    ; Dream.get Url.principles_academic Page_handler.principles_academic
    ; Dream.get
        Url.principles_what_is_ocaml
        Page_handler.principles_what_is_ocaml
    ; Dream.get Url.legal_carbon_footprint Page_handler.legal_carbon_footprint
    ; Dream.get Url.legal_privacy Page_handler.legal_privacy
    ; Dream.get Url.legal_terms Page_handler.legal_terms
    ; Dream.get Url.resources_applications Page_handler.resources_applications
    ; Dream.get Url.resources_archive Page_handler.resources_archive
    ; Dream.get
        Url.resources_best_practices
        Page_handler.resources_best_practices
    ; Dream.get
        Url.resources_developing_in_ocaml
        Page_handler.resources_developing_in_ocaml
    ; Dream.get Url.resources_language Page_handler.resources_language
    ; Dream.get Url.resources_papers Page_handler.resources_papers
    ; Dream.get
        Url.resources_papers_archive
        Page_handler.resources_papers_archive
    ; Dream.get Url.resources_platform Page_handler.resources_platform
    ; Dream.get Url.resources_releases Page_handler.resources_releases
    ; Dream.get Url.resources_tutorials Page_handler.resources_tutorials
    ; Dream.get
        (Url.resources_tutorials ^ "/:id")
        Page_handler.resources_tutorial
    ; Dream.get Url.resources_using_ocaml Page_handler.resources_using_ocaml
    ]

let package_route t =
  Dream.scope
    ""
    [ Middleware.set_locale; Middleware.no_trailing_slash ]
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
    [ Middleware.no_trailing_slash ]
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
    ; preview_routes
    ; redirection_routes
    ; toplevels_route
    ; Dream.get "/assets/**" (Dream.static ~loader "")
      (* Used for the previews *)
    ; Dream.get "/media/**" (Dream.static ~loader:media_loader "")
      (* Last one so that we don't apply the index html middleware on every
         route. *)
    ]
