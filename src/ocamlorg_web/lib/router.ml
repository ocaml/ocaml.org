module Url = Ocamlorg_frontend.Url

let loader root path request =
  match Asset.read (root ^ path) with
  | None ->
      Dream.log "Could not found %s" (root ^ path);
      Handler.not_found request
  | Some asset -> Dream.respond ~headers:(Dream.mime_lookup path) asset

let media_loader _root path request =
  match Media.read path with
  | None -> Handler.not_found request
  | Some asset -> Dream.respond asset

let redirect s req = Dream.redirect req s

let redirection_routes ?(permanant = false) t =
  let status = if permanant then `Moved_Permanently else `See_Other in
  Dream.scope ""
    [ Dream_encoding.compress ]
    (List.map
       (fun (origin, new_) ->
         Dream.get origin (fun req -> Dream.redirect ~status req new_))
       t)

let page_routes =
  Dream.scope ""
    [
      Middleware.set_locale;
      Dream_encoding.compress;
      Middleware.no_trailing_slash;
    ]
    [
      Dream.get Url.index Handler.index;
      Dream.get Url.learn Handler.learn;
      Dream.get Url.community Handler.community;
      Dream.get Url.success_stories Handler.success_stories;
      Dream.get (Url.success_story ":id") Handler.success_story;
      Dream.get Url.industrial_users Handler.industrial_users;
      Dream.get Url.academic_users Handler.academic_users;
      Dream.get Url.about Handler.about;
      Dream.get Url.books Handler.books;
      Dream.get Url.releases Handler.releases;
      Dream.get (Url.release ":id") Handler.release;
      Dream.get Url.events Handler.events;
      Dream.get (Url.workshop ":id") Handler.workshop;
      Dream.get Url.blog Handler.blog;
      Dream.get Url.news Handler.news;
      Dream.get (Url.news_post ":id") Handler.news_post;
      Dream.get Url.opportunities Handler.opportunities;
      Dream.get (Url.opportunity ":id") Handler.opportunity;
      Dream.get Url.carbon_footprint Handler.carbon_footprint;
      Dream.get Url.papers Handler.papers;
      Dream.get Url.best_practices Handler.best_practices;
      Dream.get Url.problems Handler.problems;
      Dream.get (Url.tutorial ":id") Handler.tutorial;
    ; Dream.get Url.playground Handler.playground
    ]

let package_route t =
  (* TODO(tmattio): Use Url module here. *)
  Dream.scope ""
    [
      Middleware.set_locale;
      Dream_encoding.compress;
      Middleware.no_trailing_slash;
    ]
    [
      Dream.get Url.packages (Handler.packages t);
      Dream.get Url.packages_search (Handler.packages_search t);
      Dream.get (Url.package ":name") (Handler.package t);
      Dream.get (Url.package_with_univ ":hash" ":name") (Handler.package t);
      Dream.get
        (Url.package_with_version ":name" ":version")
        ((Handler.package_versioned t) Handler.Package);
      Dream.get
        (Url.package_with_hash_with_version ":hash" ":name" ":version")
        ((Handler.package_versioned t) Handler.Universe);
      Dream.get
        (Url.package_toplevel ":name" ":version")
        ((Handler.package_toplevel t) Handler.Package);
      Dream.get
        (Url.package_toplevel_with_hash ":hash" ":name" ":version")
        ((Handler.package_toplevel t) Handler.Universe);
      Dream.get
        (Url.package_doc ":name" ":version" "**")
        ((Handler.package_doc t) Handler.Package);
      Dream.get
        (Url.package_doc_with_hash ":hash" ":name" ":version" "**")
        ((Handler.package_doc t) Handler.Universe);
    ]

let graphql_route t =
  Dream.scope ""
    [ Dream_encoding.compress; Middleware.no_trailing_slash ]
    [
      Dream.any "/api" (Dream.graphql Lwt.return (Graphql.schema t));
      Dream.get "/graphiql" (Dream.graphiql "/api");
    ]

let toplevels_route =
  Dream.scope "/toplevels"
    [ Dream_encoding.compress ]
    [
      Dream.get "/**"
        (Dream.static (Fpath.to_string Ocamlorg_package.toplevels_path));
    ]

let router t =
  Dream.router
    [
      page_routes;
      package_route t;
      graphql_route t;
      redirection_routes Redirection.from_v2;
      redirection_routes Redirection.platform;
      redirection_routes Redirection.manual;
      toplevels_route;
      Dream.get "/media/**" (Dream.static ~loader:media_loader "");
      Dream.get "/**" (Dream.static ~loader "")
      (* Last one so that we don't apply the index html middleware on every
         route. *);
    ]
