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
    ~not_cached:[ "main.css"; "/main.css"; "robots.txt"; "/robots.txt" ]

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

let toplevel_loader =
  let open Lwt.Syntax in
  Static.loader
    ~read:(fun local_root path ->
      let path = Filename.concat local_root path in
      Lwt_io.(with_file ~mode:Input path) (fun channel ->
          let+ content = Lwt_io.read channel in
          Ok content))
    ~last_modified:(fun local_root path ->
      let path = Filename.concat local_root path in
      let+ stat = Lwt_unix.stat path in
      let days, ps =
        Ptime.Span.to_d_ps
        @@ Ptime.to_span
             (match Ptime.of_float_s stat.st_mtime with
             | None -> assert false
             | Some x -> x)
      in
      Ok (days, ps))

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
      Dream.get Url.platform Handler.platform;
      Dream.get Url.community Handler.community;
      Dream.get Url.success_stories Handler.success_stories;
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
      Dream.get Url.opportunities Handler.opportunities;
      Dream.get Url.carbon_footprint Handler.carbon_footprint;
      Dream.get Url.governance Handler.governance;
      Dream.get Url.papers Handler.papers;
      Dream.get Url.best_practices Handler.best_practices;
      Dream.get Url.problems Handler.problems;
      Dream.get (Url.tutorial ":id") Handler.tutorial;
    ]

let package_route t =
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

let router t =
  Dream.router
    [
      page_routes;
      package_route t;
      graphql_route t;
      redirection_routes Redirection.from_v2;
      redirection_routes Redirection.manual;
      Dream.scope ""
        [ Dream_encoding.compress ]
        [
          Dream.get "/toplevels/**"
            (Dream.static ~loader:toplevel_loader
               (Fpath.to_string Ocamlorg_package.toplevels_path));
        ];
      Dream.scope ""
        [ Dream_encoding.compress ]
        [ Dream.get "/media/**" (Dream.static ~loader:media_loader "") ];
      Dream.scope ""
        [ Dream_encoding.compress ]
        [ Dream.get "/**" (Dream.static ~loader:asset_loader "") ];
    ]
