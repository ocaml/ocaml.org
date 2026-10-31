(* Platform release parser - adapted from ood-gen/lib/platform_release.ml *)

open Import

type t = {
  title : string;
  slug : string;
  date : string;
  tags : string list;
  experimental : bool;
  ignore : bool;
  changelog_html : string option;
  body_html : string;
  body : string;
  excerpt : string;
  authors : string list;
  contributors : string list;
  project_name : string;
  versions : string list;
  released_on_github_by : string option;
  github_release_tags : string list;
}
[@@deriving show]

type metadata = {
  title : string;
  tags : string list;
  authors : string list option;
  contributors : string list option;
  changelog : string option;
  versions : string list option;
  experimental : bool option;
  ignore : bool option;
  released_on_github_by : string option;
  github_release_tags : string list option;
}
[@@deriving of_yaml]

let decode (fname, (head, body)) =
  let project_name = Filename.basename (Filename.dirname fname) in
  let slug =
    Filename.basename (Filename.remove_extension fname) |> Utils.slugify
  in
  let metadata =
    metadata_of_yaml head |> Result.map_error (Utils.where fname)
  in
  let body_doc = Cmarkit.Doc.of_string ~strict:true (String.trim body) in
  let body_html = Markdown.Content.render ~syntax_highlighting:true body_doc in

  Result.map
    (fun metadata ->
      let changelog_doc =
        Option.map
          (fun changelog ->
            Cmarkit.Doc.of_string ~strict:true (String.trim changelog))
          metadata.changelog
      in
      let changelog_html =
        Option.map
          (Markdown.Content.render ~syntax_highlighting:true)
          changelog_doc
      in
      (* Some releases keep their notes in the changelog field and have an empty
         body. *)
      let excerpt =
        match (Markdown.Excerpt.of_doc body_doc, changelog_doc) with
        | "", Some doc -> Markdown.Excerpt.of_doc doc
        | excerpt, _ -> excerpt
      in
      let date, slug_version =
        match Slug.parse_slug slug with
        | Some x -> x
        | None ->
            failwith
              ("date is not present in metadata and could not be parsed from \
                slug: " ^ slug)
      in
      let versions =
        match (metadata.versions, slug_version) with
        | None, Some v -> [ v ]
        | None, None -> []
        | Some vs, _ -> vs
      in
      {
        title = metadata.title;
        slug;
        date;
        tags = metadata.tags;
        experimental = Option.value ~default:false metadata.experimental;
        ignore = Option.value ~default:false metadata.ignore;
        changelog_html;
        body_html;
        body;
        excerpt;
        authors = Option.value ~default:[] metadata.authors;
        contributors = Option.value ~default:[] metadata.contributors;
        project_name;
        versions;
        released_on_github_by = metadata.released_on_github_by;
        github_release_tags =
          Option.value ~default:[] metadata.github_release_tags;
      })
    metadata

let all_including_ignored () =
  Utils.map_md_files decode "platform_releases/*/*.md"
  |> List.sort (fun (a : t) b -> String.compare b.slug a.slug)

let all () =
  all_including_ignored () |> List.filter (fun (t : t) -> not t.ignore)
