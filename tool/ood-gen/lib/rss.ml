type source = River.source = { name : string; url : string } [@@deriving yaml]
type sources = { sources : source list } [@@deriving yaml]

type metadata = {
  title : string;
  description : string option;
  url : string;
  date : string;
  preview_image : string option;
  featured : bool option;
}
[@@deriving yaml]

let all_sources () =
  let bind f r = Result.bind r f in
  "rss-sources.yml" |> Data.read
  |> Option.to_result ~none:(`Msg "could not decode")
  |> bind Yaml.of_string |> bind sources_of_yaml |> Result.get_ok

let pp_meta ppf v =
  Fmt.pf ppf {|---
%s---
|}
    (metadata_to_yaml v |> Yaml.to_string |> Result.get_ok)

let feeds () =
  let sources = all_sources () in
  List.map River.fetch sources.sources

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

let scrape () =
  let feeds = feeds () in
  let id = Uri.of_string "https://ocaml.org/feed.xml" in
  let title : Syndic.Atom.title = Text "OCaml.org blog" in
  let updated = Ptime.of_float_s (Unix.gettimeofday ()) |> Option.get in
  let entries =
    feeds |> River.posts |> River.create_atom_entries |> validate_entries
  in
  let feed = Syndic.Atom.feed ~id ~title ~updated entries in
  Syndic.Atom.write feed "asset/feed.xml";
  feeds
  |> List.iter (fun (feed : River.feed) ->
         River.posts [ feed ]
         |> List.iter (fun (post : River.post) ->
                let title = River.title post in
                let slug = Utils.slugify title in
                let name = River.name (River.feed post) in
                let output_file = "data/rss/" ^ name ^ "/" ^ slug ^ ".md" in
                if Sys.file_exists output_file then
                  print_endline
                    (Printf.sprintf "%s/%s already exist, not scraping again"
                       name slug)
                else
                  let oc = open_out output_file in
                  let content = River.content post in
                  let url = River.link post in
                  let date =
                    River.date post |> Option.map Syndic.Date.to_rfc3339
                  in
                  match (url, date) with
                  | None, _ ->
                      print_endline
                        (Printf.sprintf
                           "skipping %s/%s: item does not have a url" name slug)
                  | _, None ->
                      print_endline
                        (Printf.sprintf
                           "skipping %s/%s: item does not have a date" name slug)
                  | Some url, Some date ->
                      let url = Uri.to_string url in
                      let preview_image = River.seo_image post in
                      let description = River.meta_description post in
                      let metadata =
                        {
                          title;
                          url;
                          date;
                          preview_image;
                          description;
                          featured = None;
                        }
                      in
                      let s =
                        Format.asprintf "%a\n%s\n" pp_meta metadata content
                      in
                      Printf.fprintf oc "%s" s;
                      close_out oc))

type t = {
  title : string;
  slug : string;
  url : string;
  description : string option;
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
  let body_html = String.trim body in
  Result.map (of_metadata ~body_html) metadata

let all () =
  Utils.map_files decode "rss/*/*.md"
  |> List.sort (fun a b -> String.compare b.date a.date)

let template () =
  Format.asprintf
    {|
type t =
  { title : string
  ; slug : string
  ; description : string option
  ; url : string
  ; date : string
  ; preview_image : string option
  ; featured : bool
  ; body_html : string
  }
  
let all = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
