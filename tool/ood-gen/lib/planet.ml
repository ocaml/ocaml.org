type source = { id : string; name : string; url : string } [@@deriving yaml]
type sources = { sources : source list } [@@deriving yaml]

type metadata = {
  title : string;
  description : string option;
  url : string option;
  date : string;
  preview_image : string option;
  featured : bool option;
  authors : string list option;
}
[@@deriving yaml]

let all_sources () =
  let bind f r = Result.bind r f in
  "planet-sources.yml" |> Data.read
  |> Option.to_result ~none:(`Msg "could not decode")
  |> bind Yaml.of_string |> bind sources_of_yaml |> Result.get_ok

let pp_meta ppf v =
  Fmt.pf ppf {|---
%s---
|}
    (metadata_to_yaml v |> Yaml.to_string |> Result.get_ok)

let validate_entries entries =
  let validate_author (author : Syndic.Atom.author) =
    match author with
    | { email = Some email; _ } when email = "" -> { author with email = None }
    | _ -> author
  in
  List.map
    (fun (entry : Syndic.Atom.entry) ->
      let id = entry.id |> Uri.canonicalize in
      let authors =
        ( validate_author (fst entry.authors),
          List.map validate_author (snd entry.authors) )
      in
      { entry with id; authors })
    entries

let fetch_feed (source : River.source) =
  try Some (source, River.fetch source)
  with e ->
    print_endline
      (Printf.sprintf "failed to scrape %s: %s" source.name
         (Printexc.to_string e));
    None

let scrape_post ~source_name (post : River.post) =
  let title = River.title post in
  let slug = Utils.slugify title in
  let source_path = "data/planet/" ^ source_name in
  let output_file = source_path ^ "/" ^ slug ^ ".md" in
  if Sys.file_exists output_file then
    print_endline
      (Printf.sprintf "%s/%s already exist, not scraping again" source_name slug)
  else
    let url = River.link post in
    let date = River.date post |> Option.map Syndic.Date.to_rfc3339 in
    match (url, date) with
    | None, _ ->
        print_endline
          (Printf.sprintf "skipping %s/%s: item does not have a url" source_name
             slug)
    | _, None ->
        print_endline
          (Printf.sprintf "skipping %s/%s: item does not have a date"
             source_name slug)
    | Some url, Some date ->
        if not (Sys.file_exists source_path) then Sys.mkdir source_path 0o775;
        let oc = open_out output_file in
        let content = River.content post in
        let url = Uri.to_string url in
        let preview_image = River.seo_image post in
        let description = River.meta_description post in
        let author = River.author post in
        let metadata =
          {
            title;
            url = Some url;
            date;
            preview_image;
            description;
            featured = None;
            authors = Some [ author ];
          }
        in
        let s = Format.asprintf "%a\n%s\n" pp_meta metadata content in
        Printf.fprintf oc "%s" s;
        close_out oc

let scrape_feed ((source : River.source), (feed : River.feed)) =
  let posts = River.posts [ feed ] in
  let entries = posts |> River.create_atom_entries |> validate_entries in
  let updated = Ptime.of_float_s (Unix.gettimeofday ()) |> Option.get in
  let atom_feed =
    Syndic.Atom.feed ~id:(Uri.of_string source.url) ~title:(Text source.name)
      ~updated entries
  in
  Syndic.Atom.write atom_feed ("data/planet/" ^ source.name ^ ".xml");
  posts |> List.iter (scrape_post ~source_name:source.name)

let merge_feeds () =
  let id = Uri.of_string "https://ocaml.org/feed.xml" in
  let title : Syndic.Atom.title = Text "OCaml.org blog" in
  let updated = Ptime.of_float_s (Unix.gettimeofday ()) |> Option.get in

  let sources = all_sources () in
  let entries =
    sources.sources
    |> List.map (fun source ->
           try
             let feed =
               Syndic.Atom.read ("data/planet/" ^ source.id ^ ".xml")
             in
             feed.entries |> validate_entries
           with e ->
             print_endline
               (Printf.sprintf "failed to read data/planet/%s.xml: %s" source.id
                  (Printexc.to_string e));
             [])
    |> List.flatten
    |> List.sort Syndic.Atom.descending
  in
  Syndic.Atom.feed ~id ~title ~updated entries

let scrape () =
  let sources = all_sources () in
  sources.sources
  |> List.map (fun { id; url; name = _ } : River.source -> { name = id; url })
  |> List.filter_map fetch_feed |> List.iter scrape_feed;
  let feed = merge_feeds () in
  Syndic.Atom.write feed "asset/feed.xml"

type t = {
  title : string;
  slug : string;
  url : string option;
  description : string option;
  authors : string list option;
  date : string;
  preview_image : string option;
  featured : bool;
  body_html : string;
}
[@@deriving
  stable_record ~version:metadata ~modify:[ featured ]
    ~remove:[ slug; body_html ],
    show { with_path = false }]

let of_metadata m =
  of_metadata m ~slug:(Utils.slugify m.title)
    ~modify_featured:(Option.value ~default:false)

let decode (_, (head, body)) =
  let metadata = metadata_of_yaml head in
  let body_html =
    Omd.to_html (Hilite.Md.transform (Omd.of_string (String.trim body)))
  in
  Result.map (of_metadata ~body_html) metadata

let all () =
  Utils.map_files decode "planet/*/*.md"
  @ Utils.map_files decode "planet/*/*/*.md"
  |> List.sort (fun a b -> String.compare b.date a.date)

let template () =
  Format.asprintf
    {|
type t =
  { title : string
  ; slug : string
  ; description : string option
  ; authors : string list option
  ; url : string option
  ; date : string
  ; preview_image : string option
  ; featured : bool
  ; body_html : string
  }
  
let all = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
