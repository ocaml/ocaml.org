type metadata = {
  title : string;
  date : string;
  tags : string list;
  authors : string list option;
  description : string option;
  changelog : string option;
}
[@@deriving of_yaml]

type t = {
  title : string;
  date : string;
  slug : string;
  tags : string list;
  changelog_html : string option;
  body_html : string;
}
[@@deriving
  stable_record ~version:metadata
    ~add:[ authors; changelog; description ]
    ~remove:[ slug; changelog_html; body_html ],
    show { with_path = false }]

let decode (fname, (head, body)) =
  let slug = Filename.basename (Filename.remove_extension fname) in
  let metadata = metadata_of_yaml head in
  let body_html =
    Cmarkit.Doc.of_string ~strict:true (String.trim body)
    |> Cmarkit_html.of_doc ~safe:true
  in

  Result.map
    (fun metadata ->
      let changelog_html =
        match metadata.changelog with
        | None -> None
        | Some changelog ->
            Some
              (Cmarkit.Doc.of_string ~strict:true (String.trim changelog)
              |> Cmarkit_html.of_doc ~safe:true)
      in
      of_metadata ~slug ~changelog_html ~body_html metadata)
    metadata

let all () =
  Utils.map_files decode "changelog/*/*.md"
  |> List.sort (fun a b -> String.compare b.slug a.slug)

module ChangelogFeed = struct
  let create_changelog_feed () =
    let id = Uri.of_string "https://ocaml.org/changelog.xml" in
    let title : Syndic.Atom.title = Text "OCaml Changelog" in
    let now = Ptime.of_float_s (Unix.gettimeofday ()) |> Option.get in
    let cutoff_date =
      Ptime.sub_span now (Ptime.Span.v (365, 0L)) |> Option.get
    in

    let entries =
      all ()
      |> List.map (fun (log : t) ->
             let content = Syndic.Atom.Html (None, log.body_html) in
             let id =
               Uri.of_string ("https://ocaml.org/changelog/" ^ log.slug)
             in
             let authors = (Syndic.Atom.author "Ocaml.org", []) in
             let updated =
               Syndic.Date.of_rfc3339 (log.date ^ "T00:00:00-00:00")
             in
             Syndic.Atom.entry ~content ~id ~authors
               ~title:(Syndic.Atom.Text log.title) ~updated
               ~links:[ Syndic.Atom.link id ]
               ())
      |> List.filter (fun (entry : Syndic.Atom.entry) ->
             Ptime.is_later entry.updated ~than:cutoff_date)
      |> List.sort Syndic.Atom.descending
    in

    let updated = (List.hd entries).updated in
    Syndic.Atom.feed ~id ~title ~updated entries

  let create_feed () =
    create_changelog_feed () |> Syndic.Atom.to_xml
    |> Syndic.XML.to_string ~ns_prefix:(fun s ->
           match s with "http://www.w3.org/2005/Atom" -> Some "" | _ -> None)
end

let template () =
  Format.asprintf
    {|
type t =
  { title : string
  ; slug : string
  ; date : string
  ; tags : string list
  ; changelog_html : string option
  ; body_html : string
  }
  
let all = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
