module Url = Ocamlorg_frontend.Url

let asset_loader =
  let open Lwt.Syntax in
  let store = Asset.connect () in
  Static.loader
    ~read:(fun _root path ->
      let* store in
      Asset.get store (Mirage_kv.Key.v path))
    ~last_modified:(fun _root path ->
      let* store in
      Asset.last_modified store (Mirage_kv.Key.v path))
    ~not_cached:[ "css/main.css"; "/css/main.css"; "robots.txt"; "/robots.txt" ]

let media_loader =
  let open Lwt.Syntax in
  let store = Media.connect () in
  Static.loader
    ~read:(fun _root path ->
      let* store in
      Media.get store (Mirage_kv.Key.v path))
    ~last_modified:(fun _root path ->
      let* store in
      Media.last_modified store (Mirage_kv.Key.v path))

let get_and_head pattern handler =
  [ Dream.get pattern handler; Dream.head pattern handler ]

let page_routes =
  Dream.scope ""
    [ Dream_dashboard.analytics (); Dream_encoding.compress; Middleware.head ]
    (List.flatten
       [
         get_and_head Url.index Handler.index;
         get_and_head Url.learn Handler.learn;
         get_and_head Url.platform Handler.platform;
         get_and_head Url.community Handler.community;
         get_and_head (Url.success_story ":id") Handler.success_story;
         get_and_head Url.industrial_users Handler.industrial_users;
         get_and_head Url.academic_users Handler.academic_users;
         get_and_head Url.about Handler.about;
         get_and_head Url.books Handler.books;
         get_and_head Url.releases Handler.releases;
         get_and_head (Url.release ":id") Handler.release;
         get_and_head (Url.workshop ":id") Handler.workshop;
         get_and_head Url.blog Handler.blog;
         get_and_head Url.news Handler.news;
         get_and_head (Url.news_post ":id") Handler.news_post;
         get_and_head Url.jobs Handler.jobs;
         get_and_head Url.carbon_footprint Handler.carbon_footprint;
         get_and_head Url.privacy_policy Handler.privacy_policy;
         get_and_head Url.governance Handler.governance;
         get_and_head Url.papers Handler.papers;
         get_and_head Url.best_practices Handler.best_practices;
         get_and_head Url.problems Handler.problems;
         get_and_head (Url.tutorial ":id") Handler.tutorial;
         get_and_head Url.playground Handler.playground;
       ])

let package_route t =
  Dream.scope ""
    [ Dream_dashboard.analytics (); Dream_encoding.compress; Middleware.head ]
    (List.flatten
       [
         get_and_head Url.packages (Handler.packages t);
         get_and_head Url.packages_search (Handler.packages_search t);
         get_and_head (Url.package ":name") (Handler.package t);
         get_and_head (Url.package_docs ":name") (Handler.package_docs t);
         get_and_head
           (Url.package_with_univ ":hash" ":name")
           (Handler.package t);
         get_and_head
           (Url.package_with_version ":name" ":version")
           ((Handler.package_versioned t) Handler.Package);
         get_and_head
           (Url.package_with_hash_with_version ":hash" ":name" ":version")
           ((Handler.package_versioned t) Handler.Universe);
         get_and_head
           (Url.package_doc ":name" ":version" "**")
           ((Handler.package_doc t) Handler.Package);
         get_and_head
           (Url.package_doc_with_hash ":hash" ":name" ":version" "**")
           ((Handler.package_doc t) Handler.Universe);
       ])

let graphql_route t =
  Dream.scope ""
    [ Dream_encoding.compress; Middleware.head ]
    (Dream.any "/api" (Dream.graphql Lwt.return (Graphql.schema t))
    :: get_and_head "/graphiql" (Dream.graphiql "/api"))

let router t =
  Dream.router
    [
      Dream_dashboard.route ();
      Redirection.t;
      page_routes;
      package_route t;
      graphql_route t;
      Dream.scope ""
        [ Dream_encoding.compress; Middleware.head ]
        (List.flatten
           [ get_and_head "/media/**" (Dream.static ~loader:media_loader "") ]);
      Dream.scope ""
        [ Dream_encoding.compress; Middleware.head ]
        (List.flatten
           [ get_and_head "/**" (Dream.static ~loader:asset_loader "") ]);
    ]
