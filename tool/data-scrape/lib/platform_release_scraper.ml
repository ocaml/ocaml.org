(* Platform release scraper *)

(** Generally, software engineers of the OCaml Platform will add OCaml Platform
    release notes by opening a pull request to add a release announcement to
    data/platform_releases.

    A scraper is provided to check whether platform tools release announcements
    are missing. Run it like this:
    {v
     dune exec -- tool/data-scrape/bin/scrape.exe platform_releases
    v} *)

type release_feed_entry = { github_feed_url : string; tags : string list }

let github_project_release_feeds =
  [
    ( "ocamlformat",
      {
        github_feed_url = "https://github.com/ocaml-ppx/ocamlformat";
        tags = [ "ocamlformat"; "platform" ];
      } );
    ( "dune",
      {
        github_feed_url = "https://github.com/ocaml/dune";
        tags = [ "dune"; "platform" ];
      } );
    ( "dune-release",
      {
        github_feed_url = "https://github.com/tarides/dune-release";
        tags = [ "dune-release"; "platform" ];
      } );
    ( "mdx",
      {
        github_feed_url = "https://github.com/realworldocaml/mdx";
        tags = [ "mdx"; "platform" ];
      } );
    ( "merlin",
      {
        github_feed_url = "https://github.com/ocaml/merlin";
        tags = [ "merlin"; "platform"; "editors" ];
      } );
    ( "ocaml",
      { github_feed_url = "https://github.com/ocaml/ocaml"; tags = [ "ocaml" ] }
    );
    ( "ocaml-lsp",
      {
        github_feed_url = "https://github.com/ocaml/ocaml-lsp";
        tags = [ "ocaml-lsp"; "platform"; "editors" ];
      } );
    ( "ocp-indent",
      {
        github_feed_url = "https://github.com/OCamlPro/ocp-indent";
        tags = [ "ocp-indent"; "platform" ];
      } );
    ( "odoc",
      {
        github_feed_url = "https://github.com/ocaml/odoc";
        tags = [ "odoc"; "platform" ];
      } );
    ( "opam",
      {
        github_feed_url = "https://github.com/ocaml/opam/";
        tags = [ "opam"; "platform" ];
      } );
    ( "opam-publish",
      {
        github_feed_url = "https://github.com/ocaml-opam/opam-publish";
        tags = [ "opam-publish"; "platform" ];
      } );
    ( "ppxlib",
      {
        github_feed_url = "https://github.com/ocaml-ppx/ppxlib";
        tags = [ "ppxlib"; "platform" ];
      } );
    ( "utop",
      {
        github_feed_url = "https://github.com/ocaml-community/utop";
        tags = [ "utop"; "platform" ];
      } );
    ( "omp",
      {
        github_feed_url = "https://github.com/ocaml-ppx/ocaml-migrate-parsetree";
        tags = [ "ocaml-migrate-parsetree"; "platform" ];
      } );
  ]

type metadata = {
  title : string;
  tags : string list;
  contributors : string list option;
  changelog : string option;
  versions : string list option;
  authors : string list option;
  experimental : bool option;
  ignore : bool option;
  released_on_github_by : string option;
  github_release_tags : string list option;
}
[@@deriving yaml]

let pp_meta ppf v =
  Fmt.pf ppf {|---
%s---
|}
    (metadata_to_yaml v |> Yaml.to_string |> Result.get_ok)

module SMap = Map.Make (String)
module SSet = Set.Make (String)

type github_release = { github_tag : string; post : River.post }

let github_release_tag_from_url url =
  url |> Uri.to_string |> String.split_on_char '/' |> List.rev |> List.hd

let warn fmt =
  let flush out = Printf.fprintf out "\n%!" in
  Printf.kfprintf flush stderr fmt

let fetch_github repo =
  [ River.fetch { River.name = repo; url = repo ^ "/releases.atom" } ]
  |> River.posts
  |> List.filter_map (fun post ->
         River.link post
         |> Option.map github_release_tag_from_url
         |> Option.map (fun github_tag -> { github_tag; post }))

let group_releases_by_project all =
  List.fold_left
    (fun acc (t : Data_packer.Platform_release_parser.t) ->
      let existing =
        SMap.find_opt t.project_name acc |> Option.value ~default:[]
      in
      let updated = existing @ t.github_release_tags in
      SMap.add t.project_name updated acc)
    SMap.empty all

let write_release_announcement_file project github_tag tags (post : River.post)
    =
  let yyyy_mm_dd =
    River.date post |> Option.get |> Ptime.to_rfc3339
    |> String.split_on_char 'T' |> List.hd
  in
  let title = River.title post in
  let github_release_tags =
    [ River.link post |> Option.map github_release_tag_from_url ]
  in
  let output_file =
    "data/platform_releases/" ^ project ^ "/" ^ yyyy_mm_dd ^ "-" ^ project ^ "-"
    ^ github_tag ^ "-draft.md"
  in
  let content = River.content post in
  let released_on_github_by = Some (River.author post) in
  let metadata : metadata =
    {
      title;
      tags;
      contributors = None;
      changelog = None;
      versions = None;
      authors = Some [];
      experimental = Some false;
      ignore = Some false;
      released_on_github_by;
      github_release_tags =
        (match
           List.filter_map (fun (a : string option) -> a) github_release_tags
         with
        | [] -> None
        | xs -> Some xs);
    }
  in
  let s = Format.asprintf "%a\n%s\n" pp_meta metadata content in
  let oc = open_out output_file in
  Printf.fprintf oc "%s" s;
  close_out oc

let check_if_uptodate project known_tags =
  let known_github_tags = SSet.of_list known_tags in
  let check repo tags =
    let scraped_versions = fetch_github repo in
    List.iter
      (fun { github_tag; post } ->
        if not (SSet.mem github_tag known_github_tags) then (
          warn "We don't have the release notes for %S github tag %S\n%!"
            project github_tag;
          write_release_announcement_file project github_tag tags post))
      scraped_versions
  in
  match List.assoc_opt project github_project_release_feeds with
  | Some { github_feed_url; tags } -> check github_feed_url tags
  | None ->
      warn
        "Don't know how to lookup project %S. Please update \
         'tool/data-scrape/lib/platform_release_scraper.ml'\n\
         %!"
        project

let scrape () =
  Data_packer.Platform_release_parser.all ()
  |> group_releases_by_project
  |> SMap.iter check_if_uptodate
