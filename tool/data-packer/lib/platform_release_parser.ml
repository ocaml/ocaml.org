(* Platform release parser - adapted from ood-gen/lib/platform_release.ml *)

open Import

type t = {
  title : string;
  slug : string;
  date : string;
  tags : string list;
  experimental : bool;
  changelog_html : string option;
  body_html : string;
  body : string;
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
  let body_html =
    Cmarkit_html.of_doc ~safe:false
      (Hilite.Md.transform
         (Cmarkit.Doc.of_string ~strict:true (String.trim body)))
  in

  Result.map
    (fun metadata ->
      let changelog_html =
        match metadata.changelog with
        | None -> None
        | Some changelog ->
            Some
              (Cmarkit.Doc.of_string ~strict:true (String.trim changelog)
              |> Hilite.Md.transform
              |> Cmarkit_html.of_doc ~safe:false)
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
        changelog_html;
        body_html;
        body;
        authors = Option.value ~default:[] metadata.authors;
        contributors = Option.value ~default:[] metadata.contributors;
        project_name;
        versions;
        released_on_github_by = metadata.released_on_github_by;
        github_release_tags =
          Option.value ~default:[] metadata.github_release_tags;
      })
    metadata

let all () =
  Utils.map_md_files decode "platform_releases/*/*.md"
  |> List.sort (fun (a : t) b -> String.compare b.slug a.slug)
