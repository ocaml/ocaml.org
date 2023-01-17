module Url = Ocamlorg_frontend.Url

let success_story_urls =
  let list_of_records = Ood.Success_story.all in
  List.map (fun r -> Url.success_story r.Ood.Success_story.slug) list_of_records

let release_urls =
  let list_of_records = Ood.Release.all in
  List.map (fun r -> Url.release r.Ood.Release.version) list_of_records

let workshop_urls =
  let list_of_records = Ood.Workshop.all in
  List.map (fun r -> Url.workshop r.Ood.Workshop.slug) list_of_records

let news_urls =
  let list_of_records = Ood.News.all in
  List.map (fun r -> Url.news_post r.Ood.News.slug) list_of_records

let tutorial_urls =
  let list_of_records = Ood.Tutorial.all in
  List.map (fun r -> Url.tutorial r.Ood.Tutorial.slug) list_of_records

let list_of_v2_urls =
  [ Url.v2; Url.manual_with_version "5.0.0"; Url.api_with_version "5.0.0" ]

let () =
  let cu url = "https://ocaml.org" ^ url in
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
    @ success_story_urls @ release_urls @ workshop_urls @ news_urls
    @ tutorial_urls
  in
  let list_of_complete_urls = List.map (fun url -> cu url) list_of_urls in
  let list_of_complete_urls = list_of_complete_urls @ list_of_v2_urls in
  let oc = open_out "tool/sitemap/sitemap.xml" in
  Printf.fprintf oc
    {|<?xml version="1.0" encoding="utf-8"?>
  <urlset
    xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
    xmlns:image="http://www.google.com/schemas/sitemap-image/1.1"
    xmlns:xhtml="http://www.w3.org/1999/xhtml">
  |};
  List.iter
    (fun url ->
      Printf.fprintf oc {| <url>
        <loc>%s</loc>
    </url>
    |} url)
    list_of_complete_urls;

  Printf.fprintf oc {|</urlset>
  |};
  close_out oc
