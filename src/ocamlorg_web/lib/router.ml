module Url = Ocamlorg_frontend.Url

let asset_loader =
  let open Lwt.Syntax in
  let store = Asset.connect () in
  Static.loader
    ~read:(fun _root path ->
      let* store = store in
      Asset.get store (Mirage_kv.Key.v path))
    ~last_modified:(fun _root path ->
      let* store = store in
      Asset.last_modified store (Mirage_kv.Key.v path))
    ~not_cached:[ "css/main.css"; "/css/main.css"; "robots.txt"; "/robots.txt" ]

let media_loader =
  let open Lwt.Syntax in
  let store = Media.connect () in
  Static.loader
    ~read:(fun _root path ->
      let* store = store in
      Media.get store (Mirage_kv.Key.v path))
    ~last_modified:(fun _root path ->
      let* store = store in
      Media.last_modified store (Mirage_kv.Key.v path))

let page_routes =
  Dream.scope ""
    [ Dream_dashboard.analytics (); Dream_encoding.compress ]
    [
      Dream.get Url.index Handler.index;
      Dream.get Url.learn Handler.learn;
      Dream.get Url.platform Handler.platform;
      Dream.get Url.community Handler.community;
      Dream.get (Url.success_story ":id") Handler.success_story;
      Dream.get Url.industrial_users Handler.industrial_users;
      Dream.get Url.academic_users Handler.academic_users;
      Dream.get Url.about Handler.about;
      Dream.get Url.books Handler.books;
      Dream.get Url.releases Handler.releases;
      Dream.get (Url.release ":id") Handler.release;
      Dream.get (Url.workshop ":id") Handler.workshop;
      Dream.get Url.blog Handler.blog;
      Dream.get Url.news Handler.news;
      Dream.get (Url.news_post ":id") Handler.news_post;
      Dream.get Url.jobs Handler.jobs;
      Dream.get Url.carbon_footprint Handler.carbon_footprint;
      Dream.get Url.privacy_policy Handler.privacy_policy;
      Dream.get Url.governance Handler.governance;
      Dream.get Url.code_of_conduct Handler.code_of_conduct;
      Dream.get Url.papers Handler.papers;
      Dream.get Url.best_practices Handler.best_practices;
      Dream.get Url.problems Handler.problems;
      Dream.get (Url.tutorial ":id") Handler.tutorial;
      Dream.get Url.playground Handler.playground;
    ]

let package_route t =
  Dream.scope ""
    [ Dream_dashboard.analytics (); Dream_encoding.compress ]
    [
      Dream.get Url.packages (Handler.packages t);
      Dream.get Url.packages_search (Handler.packages_search t);
      Dream.get (Url.package ":name") (Handler.package t);
      Dream.get (Url.package_docs ":name") (Handler.package_docs t);
      Dream.get (Url.package ~hash:":hash" ":name") (Handler.package t);
      Dream.get
        (Url.package_with_version ":name" ":version")
        ((Handler.package_versioned t) Handler.Package);
      Dream.get
        (Url.package_with_version ~hash:":hash" ":name" ":version")
        ((Handler.package_versioned t) Handler.Universe);
      Dream.get
        (Url.package_doc ":name" ":version" ~page:"**")
        ((Handler.package_doc t) Handler.Package);
      Dream.get
        (Url.package_doc ~hash:":hash" ~page:"**" ":name" ":version")
        ((Handler.package_doc t) Handler.Universe);
    ]

let graphql_route t =
  Dream.scope ""
    [ Dream_encoding.compress ]
    [
      Dream.any "/api" (Dream.graphql Lwt.return (Graphql.schema t));
      Dream.get "/graphiql" (Dream.graphiql "/api");
    ]

let router t =
  Dream.router
    [
      Dream_dashboard.route ();
      Redirection.t;
      page_routes;
      package_route t;
      graphql_route t;
      Dream.scope ""
        [ Dream_encoding.compress ]
        [ Dream.get "/media/**" (Dream.static ~loader:media_loader "") ];
      Dream.scope ""
        [ Dream_encoding.compress ]
        [ Dream.get "/**" (Dream.static ~loader:asset_loader "") ];
    ]
