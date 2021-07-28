let v3_loader root path request =
  let headers, path =
    let fpath = Fpath.v path in
    if Fpath.is_dir_path fpath || not (Fpath.exists_ext fpath) then
      (* charset is used internally in dream when setting this *)
      ( [ "Content-Type", "text/html; charset=utf-8" ]
      , Filename.concat path "index.html" )
    else
      Dream.mime_lookup path, path
  in
  match Asset.read (root ^ path) with
  | None ->
    Page_handler.not_found request
  | Some asset ->
    Dream.respond ~headers asset

let loader root path request =
  match Asset.read (root ^ path) with
  | None ->
    Page_handler.not_found request
  | Some asset ->
    Dream.respond ~headers:(Dream.mime_lookup path) asset

let media_loader _root path _request =
  match Ood_media.read path with
  | None ->
    Dream.empty `Not_Found
  | Some asset ->
    Dream.respond asset

let site_route =
  Dream.scope
    ""
    [ Middleware.i18n ]
    [ Dream.get "/**" (Dream.static ~loader:v3_loader "site/") ]

let preview_routes =
  Dream.scope
    "/preview"
    []
    [ Dream.get "" Preview_handler.index
    ; Dream.get "/tutorials" Preview_handler.tutorials
    ; Dream.get "/tutorials/:id" Preview_handler.tutorial
    ; Dream.get "/media/**" (Dream.static ~loader:media_loader "")
    ]

let package_route =
  Dream.scope
    ""
    []
    [ Dream.get "/packages" Package_handler.index
    ; Dream.get "/packages/" Package_handler.index
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
    ; Dream.get
        "/p/:name/:version/top"
        (Package_handler.toplevel Package_handler.Package)
    ; Dream.get
        "/u/:hash/:name/:version/top"
        (Package_handler.toplevel Package_handler.Package)
    ]

let graphql_route =
  Dream.scope
    ""
    []
    [ Dream.any "/graphql" (Dream.graphql Lwt.return Schema.schema)
    ; Dream.get
        "/graphiql"
        (Dream.graphiql ~default_query:Schema.default_query "/graphql")
    ]

let router =
  Dream.router
    [ package_route
    ; graphql_route
    ; preview_routes
    ; Dream.get "/assets/**" (Dream.static ~loader "")
    ; Dream.get
        "/toplevels/**"
        (Dream.static (Fpath.to_string Ocamlorg.topelevels_path))
      (* Used for the previews *)
    ; Dream.get "/media/**" (Dream.static ~loader:media_loader "")
      (* Last one so that we don't apply the index html middleware on every
         route. *)
    ; site_route
    ]
