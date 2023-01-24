module Url = Ocamlorg_frontend.Url

type urlable = Urlable : 'a list * ('a -> string) -> urlable

let list_of_urls =
  [
    Url.index;
    Url.packages;
    Url.packages_search;
    Url.community;
    Url.industrial_users;
    Url.academic_users;
    Url.about;
    Url.manual;
    Url.api;
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
    Url.installer;
  ]

let cu url = "https://ocaml.org" ^ url

let list_of_v2_urls =
  [ Url.v2; Url.manual_with_version "5.0.0"; Url.api_with_version "5.0.0" ]

let l =
  [
    Urlable (list_of_urls, cu);
    Urlable
      ( Ood.Success_story.all,
        fun r -> cu @@ Url.success_story r.Ood.Success_story.slug );
    Urlable (Ood.Release.all, fun r -> cu @@ Url.release r.Ood.Release.version);
    Urlable (Ood.Workshop.all, fun r -> cu @@ Url.workshop r.Ood.Workshop.slug);
    Urlable (Ood.News.all, fun r -> cu @@ Url.news_post r.Ood.News.slug);
    Urlable (Ood.Tutorial.all, fun r -> cu @@ Url.tutorial r.Ood.Tutorial.slug);
    Urlable (list_of_v2_urls, Fun.id);
  ]

let list_of_complete_urls =
  List.concat_map (function Urlable (all, show) -> List.map show all) l

let sitemap_ood =
  let sitemap_list =
    [
      {|<?xml version="1.0" encoding="utf-8"?>
<urlset
      xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
      xmlns:image="http://www.google.com/schemas/sitemap-image/1.1"
      xmlns:xhtml="http://www.w3.org/1999/xhtml">
    |};
    ]
  in
  let rec sitemap_body list_of_urls sitemap_body_list =
    match list_of_urls with
    | [] -> sitemap_body_list
    | url :: t ->
        sitemap_body t
          (Printf.sprintf {|
<url>
  <loc>%s</loc>
</url>|} url
          :: sitemap_body_list)
  in
  let sitemap_list =
    {|</urlset>|} :: sitemap_body list_of_complete_urls sitemap_list
  in
  Lwt_seq.of_list (List.rev sitemap_list)
