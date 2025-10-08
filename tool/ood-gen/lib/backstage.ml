type release = [%import: Data_intf.Backstage.release] [@@deriving show]
type post = [%import: Data_intf.Backstage.post] [@@deriving show]
type t = [%import: Data_intf.Backstage.t] [@@deriving show]

(* Backstage OCaml has two categories:

   - posts - release announcements

   POSTS =====

   These entries are posted automatically to various OCaml social media
   accounts.

   The main accounts will automatically receive posts that (a) describe how the
   user-facing surface of the tools as a whole changes and (b) empower the
   reader to make better use of the OCaml Platform tools.

   These entries are represented by the RSS feed category "posts".

   Example content: - celebrating major releases or milestones - how to use new
   features - which new workflows are possible now (sometimes involving releases
   from multiple tools) - announcing that workarounds for bugs that are now
   fixed can be retired

   Generally, these will be written together with a release announcement, or
   after, and reference zero or more earlier relevant release announcements.

   RELEASE ANNOUNCEMENTS =====================

   We also collect and broadcast release announcements for all the GitHub
   repositories that directly support the OCaml Platform Tools.

   Release announcements will not go out through the main social media accounts,
   but through dedicated accounts sharing releases. From these, the main OCaml
   accounts can repost and comment on major releases to give more details or
   highlight particular milestones.

   These entries are represented by the RSS feed category "releases". *)

module Posts = struct
  type post_metadata = {
    title : string;
    tags : string list;
    authors : string list option;
  }
  [@@deriving
    of_yaml,
      stable_record ~version:post ~modify:[ authors ]
        ~add:[ slug; body_html; body; date ]]

  let of_post_metadata m =
    post_metadata_to_post m ~modify_authors:(Option.value ~default:[])

  let decode (fname, (head, body)) =
    let slug = Filename.basename (Filename.remove_extension fname) in
    let metadata =
      post_metadata_of_yaml head |> Result.map_error (Utils.where fname)
    in
    let body_html =
      Cmarkit_html.of_doc ~safe:false
        (Hilite.Md.transform
           (Cmarkit.Doc.of_string ~strict:true (String.trim body)))
    in

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
        of_post_metadata ~slug ~body ~body_html ~date metadata)
      metadata

  let all () =
    Utils.map_md_files decode "backstage/*/*.md"
    |> List.sort (fun (a : post) b -> String.compare b.slug a.slug)
end

let platform_tools_release_to_release (r : Platform_release.t) : release =
  {
    title = r.title;
    slug = r.slug;
    date = r.date;
    tags = r.tags;
    contributors = r.contributors;
    project_name = r.project_name;
    versions = r.versions;
    github_release_tags = r.github_release_tags;
    changelog_html = r.changelog_html;
    body_html = r.body_html;
    body = r.body;
    authors = r.authors;
  }

let all () =
  let slug_of_t r = match r with Release r -> r.slug | Post p -> p.slug in
  let releases =
    Platform_release.all ()
    |> List.filter (fun (a : Platform_release.t) -> a.experimental)
    |> List.map platform_tools_release_to_release
  in
  let posts = Posts.all () in
  List.map (fun x -> Release x) releases @ List.map (fun x -> Post x) posts
  |> List.sort (fun (a : t) b -> String.compare (slug_of_t b) (slug_of_t a))

module Feed = struct
  let to_author name = Syndic.Atom.{ name; uri = None; email = None }

  let create_entry (entry : t) =
    match entry with
    | Release release ->
        let content = Syndic.Atom.Html (None, release.body_html) in
        let id =
          Uri.of_string ("https://ocaml.org/backstage/" ^ release.slug)
        in
        let authors =
          (Syndic.Atom.author "OCaml.org", List.map to_author release.authors)
        in
        let updated =
          Syndic.Date.of_rfc3339 (release.date ^ "T00:00:00-00:00")
        in
        let categories =
          [
            Syndic.Atom.
              { term = "releases"; scheme = None; label = Some "Releases" };
          ]
        in
        Syndic.Atom.entry ~content ~id ~authors
          ~title:(Syndic.Atom.Text release.title) ~updated
          ~links:[ Syndic.Atom.link id ]
          ~categories ()
    | Post post ->
        let content = Syndic.Atom.Html (None, post.body_html) in
        let id = Uri.of_string ("https://ocaml.org/backstage/" ^ post.slug) in
        let authors =
          (Syndic.Atom.author "OCaml.org", List.map to_author post.authors)
        in
        let updated = Syndic.Date.of_rfc3339 (post.date ^ "T00:00:00-00:00") in
        let categories =
          [
            Syndic.Atom.{ term = "posts"; scheme = None; label = Some "Posts" };
          ]
        in
        Syndic.Atom.entry ~content ~id ~authors
          ~title:(Syndic.Atom.Text post.title) ~updated
          ~links:[ Syndic.Atom.link id ]
          ~categories ()

  let create_feed () =
    let open Rss in
    () |> all
    |> create_entries ~create_entry ~days:365
    |> entries_to_feed ~id:"backstage.xml" ~title:"Backstage OCaml"
    |> feed_to_string
end

let template () =
  Format.asprintf {ocaml|
include Data_intf.Backstage
let all = %a
|ocaml}
    (Fmt.Dump.list pp) (all ())
