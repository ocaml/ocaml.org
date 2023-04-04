module Url = Ocamlorg.Url

type urlable = Urlable : 'a list * ('a -> string) -> urlable

let urls =
  [
    Url.index;
    Url.packages;
    Url.packages_search;
    Url.community;
    Url.industrial_users;
    Url.academic_users;
    Url.about;
    Url.books;
    Url.releases;
    Url.blog;
    Url.news;
    Url.jobs;
    Url.carbon_footprint;
    Url.privacy_policy;
    Url.governance;
    Url.code_of_conduct;
    Url.playground;
    Url.papers;
    Url.learn;
    Url.platform;
    Url.ocaml_on_windows;
    Url.getting_started;
    Url.best_practices;
    Url.problems;
  ]

let to_url u = "https://ocaml.org" ^ u

let urlables =
  let open Ood in
  List.to_seq
    [
      Urlable (urls, to_url);
      Urlable
        ( Success_story.all,
          fun r -> to_url @@ Url.success_story r.Success_story.slug );
      Urlable (Release.all, fun r -> to_url @@ Url.release r.Release.version);
      Urlable (Workshop.all, fun r -> to_url @@ Url.workshop r.Workshop.slug);
      Urlable (News.all, fun r -> to_url @@ Url.news_post r.News.slug);
      Urlable (Tutorial.all, fun r -> to_url @@ Url.tutorial r.Tutorial.slug);
    ]

let tag = Printf.sprintf {|
<url>
  <loc>%s</loc>
</url>|}

let urlset =
  Seq.concat_map
    (function
      | Urlable (all, show) -> Seq.map (fun s -> tag (show s)) (List.to_seq all))
    urlables

let ood =
  let header =
    List.to_seq
      [
        {|<?xml version="1.0" encoding="utf-8"?>
<urlset
  xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
  xmlns:image="http://www.google.com/schemas/sitemap-image/1.1"
  xmlns:xhtml="http://www.w3.org/1999/xhtml">
|};
      ]
  in
  Lwt_seq.of_seq
    (Seq.concat (List.to_seq [ header; urlset; Seq.return {|
</urlset>
|} ]))
