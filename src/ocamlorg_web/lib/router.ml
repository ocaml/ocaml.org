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
  match Asset_site.read (root ^ path) with
  | None ->
    Handler.not_found request
  | Some asset ->
    Dream.respond ~headers asset

let loader root path request =
  match Asset.read (root ^ path) with
  | None ->
    Handler.not_found request
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
    [ Dream.get "/**" (Dream.static ~loader:v3_loader "") ]

let preview_routes =
  Dream.scope
    "/preview"
    []
    [ Dream.get "" Handler.preview
    ; Dream.get "/tutorials" Handler.preview_tutorials
    ; Dream.get "/tutorials/:id" Handler.preview_tutorial
    ; Dream.get "/media/**" (Dream.static ~loader:media_loader "")
    ]

let package_route =
  Dream.scope
    ""
    []
    [ Dream.get "/packages" Handler.packages
    ; Dream.get "/packages/" Handler.packages
    ; Dream.get "/packages/search" Handler.package_search
    ; Dream.get "/p/:name" Handler.package
    ; Dream.get "/u/:hash/:name" Handler.package
    ; Dream.get "/p/:name/:version" (Handler.package_versioned Handler.Package)
    ; Dream.get
        "/u/:hash/:name/:version"
        (Handler.package_versioned Handler.Universe)
    ; Dream.get "/p/:name/:version/doc/**" (Handler.package_doc Handler.Package)
    ; Dream.get
        "/u/:hash/:name/:version/doc/**"
        (Handler.package_doc Handler.Universe)
    ]

let router =
  Dream.router
    [ package_route
    ; preview_routes
    ; Dream.get "/assets/**" (Dream.static ~loader "")
      (* Used for the previews *)
    ; Dream.get "/media/**" (Dream.static ~loader:media_loader "")
      (* Last one so that we don't apply the index html middleware on every
         route. *)
    ; site_route
    ]
