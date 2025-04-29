type release = [%import: Data_intf.Changelog.release] [@@deriving of_yaml, show]
type post = [%import: Data_intf.Changelog.post] [@@deriving of_yaml, show]
type t = [%import: Data_intf.Changelog.t] [@@deriving of_yaml, show]

(* The OCaml.org Changelog has two categories:

   - posts - release announcements

   POSTS =====

   These OCaml.org Changelog entries are posted automatically to various OCaml
   social media accounts.

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

   These entries are represented by the RSS feed category "releases".

   Generally, software engineers of the OCaml Platform will add these by opening
   a pull request to mirror a release announcement that likely already happened
   on discuss.ocaml.org. *)

let re_date_slug =
  let open Re in
  compile
    (seq
       [
         bos;
         seq
           [
             group (rep1 digit);
             char '-';
             group (rep1 digit);
             char '-';
             group (rep1 digit);
           ];
         char '-';
       ])

let parse_date_from_slug s =
  match Re.exec_opt re_date_slug s with
  | None -> None
  | Some g ->
      let int n = Re.Group.get g n |> int_of_string in
      let year = int 1 in
      let month = int 2 in
      let day = int 3 in
      Some (Printf.sprintf "%04d-%02d-%02d" year month day)

module Releases = struct
  type release_metadata = {
    title : string;
    tags : string list;
    authors : string list option;
    contributors : string list option;
    description : string option;
    changelog : string option;
  }
  [@@deriving
    of_yaml,
      stable_record ~version:release ~remove:[ changelog; description ]
        ~modify:[ authors; contributors ]
        ~add:[ slug; changelog_html; body_html; body; date ]]

  let of_release_metadata m =
    release_metadata_to_release m ~modify_authors:(Option.value ~default:[])
      ~modify_contributors:(Option.value ~default:[])

  let decode (fname, (head, body)) =
    let slug = Filename.basename (Filename.remove_extension fname) in
    let metadata =
      release_metadata_of_yaml head |> Result.map_error (Utils.where fname)
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
        let date =
          match parse_date_from_slug slug with
          | Some x -> x
          | None ->
              failwith
                "date is not present in metadata and could not be parsed from \
                 slug"
        in
        of_release_metadata ~slug ~changelog_html ~body ~body_html ~date
          metadata)
      metadata

  let all () =
    Utils.map_md_files decode "changelog/releases/*/*.md"
    |> List.sort (fun (a : release) b -> String.compare b.slug a.slug)
end

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
          match parse_date_from_slug slug with
          | Some x -> x
          | None ->
              failwith
                "date is not present in metadata and could not be parsed from \
                 slug"
        in
        of_post_metadata ~slug ~body ~body_html ~date metadata)
      metadata

  let all () =
    Utils.map_md_files decode "changelog/posts/*/*.md"
    |> List.sort (fun (a : post) b -> String.compare b.slug a.slug)
end

let all () =
  let releases = Releases.all () in
  let posts = Posts.all () in
  List.map (fun x -> Release x) releases @ List.map (fun x -> Post x) posts

module ChangelogFeed = struct
  let to_author name = Syndic.Atom.{ name; uri = None; email = None }

  let create_entry (entry : t) =
    match entry with
    | Release release ->
        let content = Syndic.Atom.Html (None, release.body_html) in
        let id =
          Uri.of_string ("https://ocaml.org/changelog/release/" ^ release.slug)
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
        let id = Uri.of_string ("https://ocaml.org/changelog/" ^ post.slug) in
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
    |> entries_to_feed ~id:"changelog.xml" ~title:"OCaml Changelog"
    |> feed_to_string
end

let template () =
  Format.asprintf {ocaml|
include Data_intf.Changelog
let all = %a
|ocaml}
    (Fmt.Dump.list pp) (all ())
