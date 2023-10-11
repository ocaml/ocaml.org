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
    Url.workshops;
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
    Url.exercises;
  ]

let to_url u = "\n<url><loc>https://ocaml.org" ^ u ^ "</loc></url>"

let urlables =
  let open Data in
  List.to_seq
    [
      Urlable (urls, to_url);
      Urlable (Success_story.all, fun r -> to_url @@ Url.success_story r.slug);
      Urlable (Release.all, fun r -> to_url @@ Url.release r.version);
      Urlable (Workshop.all, fun r -> to_url @@ Url.workshop r.slug);
      Urlable (News.all, fun r -> to_url @@ Url.news_post r.slug);
      Urlable (Tutorial.all, fun r -> to_url @@ Url.tutorial r.slug);
    ]

let urlset (Urlable (all, show)) = Seq.map show (List.to_seq all)

let data =
  let header =
    {|<?xml version="1.0" encoding="utf-8"?>
<urlset
  xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
  xmlns:image="http://www.google.com/schemas/sitemap-image/1.1"
  xmlns:xhtml="http://www.w3.org/1999/xhtml">|}
  in
  Lwt_seq.of_seq
    Seq.(
      concat
        (List.to_seq
           [ return header; concat_map urlset urlables; return "\n</urlset>\n" ]))
