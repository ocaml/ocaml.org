let loader _root path _request =
  match Asset.read path with
  | None ->
    Dream.empty `Not_Found
  | Some asset ->
    Dream.respond asset

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
  ; Dream.get "/p/:name/:version/docs" Package_handler.package_docs_index
  ; Dream.get "/u/:hash/:name/:version/docs" Package_handler.package_docs_index
  ; Dream.get "/p/:name/:version/docs/**" Package_handler.package_docs
  ; Dream.get "/u/:hash/:name/:version/docs/**" Package_handler.package_docs
  ; Dream.get "/assets/**" (Dream.static ~loader "")
  ]

let router = Dream.router routes
