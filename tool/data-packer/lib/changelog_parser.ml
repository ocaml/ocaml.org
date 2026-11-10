(* Changelog parser - adapted from ood-gen/lib/changelog.ml *)

open Import
open Data_intf.Changelog

type release = Data_intf.Changelog.release
type post = Data_intf.Changelog.post
type t = Data_intf.Changelog.t

module Posts = struct
  type post_metadata = {
    title : string;
    tags : string list;
    authors : string list; [@default []]
  }
  [@@deriving of_yaml]

  let of_post_metadata ~slug ~body_html ~date ~excerpt
      ({ title; tags; authors } : post_metadata) : post =
    { title; slug; date; tags; body_html; excerpt; authors }

  let decode (fname, (head, body)) =
    let slug = Filename.basename (Filename.remove_extension fname) in
    let metadata =
      post_metadata_of_yaml head |> Result.map_error (Utils.where fname)
    in
    let doc = Cmarkit.Doc.of_string ~strict:true (String.trim body) in
    let body_html = Markdown.Content.render ~syntax_highlighting:true doc in
    let excerpt = Markdown.Excerpt.of_doc doc in

    Result.map
      (fun metadata ->
        let date =
          match Slug.parse_slug slug with
          | Some (date, _) -> date
          | None ->
              failwith
                "date is not present in metadata and could not be parsed from \
                 slug"
        in
        of_post_metadata ~slug ~excerpt ~body_html ~date metadata)
      metadata

  let all () =
    Utils.map_md_files decode "changelog/*/*.md"
    |> List.sort (fun (a : post) b -> String.compare b.slug a.slug)
end

let platform_tools_release_to_release
    ({
       Platform_release_parser.title;
       slug;
       date;
       tags;
       contributors;
       project_name;
       versions;
       github_release_tags;
       changelog_html;
       body_html;
       excerpt;
       authors;
       _;
     } :
      Platform_release_parser.t) : release =
  {
    title;
    slug;
    date;
    tags;
    contributors;
    project_name;
    versions;
    github_release_tags;
    changelog_html;
    body_html;
    excerpt;
    authors;
  }

let all () =
  let slug_of_t r = match r with Release r -> r.slug | Post p -> p.slug in
  let releases =
    Platform_release_parser.all ()
    |> List.filter (fun (a : Platform_release_parser.t) ->
           a.Platform_release_parser.experimental = false)
    |> List.map platform_tools_release_to_release
  in
  let posts = Posts.all () in
  List.map (fun x -> Release x) releases @ List.map (fun x -> Post x) posts
  |> List.sort (fun (a : t) b -> String.compare (slug_of_t b) (slug_of_t a))
