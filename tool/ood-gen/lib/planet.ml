module Source = struct
  type t = { id : string option; name : string; url : string }
  [@@deriving yaml, show { with_path = false }]

  type sources = t list [@@deriving yaml]

  let all () : t list =
    let bind f r = Result.bind r f in
    "planet-sources.yml" |> Data.read
    |> Option.to_result ~none:(`Msg "could not decode")
    |> bind Yaml.of_string |> bind sources_of_yaml |> Result.get_ok
end

type metadata = {
  title : string;
  description : string option;
  url : string option;
  date : string;
  preview_image : string option;
  featured : bool option;
  authors : string list option;
  source : Source.t option;
}
[@@deriving yaml]

type t = {
  title : string;
  slug : string;
  source : Source.t;
  url : string option;
  description : string option;
  authors : string list option;
  date : string;
  preview_image : string option;
  featured : bool;
  body_html : string;
  tags : string list;
}
[@@deriving
  stable_record ~version:metadata ~modify:[ featured; source ]
    ~remove:[ slug; body_html; tags ],
    show { with_path = false }]

let all_sources = Source.all ()

let of_metadata ~source m =
  of_metadata m ~slug:(Utils.slugify m.title)
    ~modify_source:(Option.value ~default:source)
    ~modify_featured:(Option.value ~default:false)

let decode (path, (head, body)) =
  let metadata = metadata_of_yaml head in
  let body_html =
    Omd.to_html (Hilite.Md.transform (Omd.of_string (String.trim body)))
  in
  let source =
    match Str.split (Str.regexp_string "/") path with
    | _ :: second :: _ -> (
        match
          List.find_opt (fun (s : Source.t) -> s.id = Some second) all_sources
        with
        | Some source -> source
        | None ->
            if String.get second 0 = '-' then
              {
                id = Some "ocamlorg";
                name = "OCaml.org Blog";
                url = "https://ocaml.org/blog";
              }
            else failwith ("No source found for: " ^ path))
    | _ ->
        failwith
          ("Trying to determine the source for " ^ path
         ^ " but there path is not long enough (should start with \
            data/SOURCE_NAME/...)")
  in
  let tags = [ List.nth (String.split_on_char '/' path) 1 ] in
  metadata
  |> Result.map_error (fun (`Msg m) -> `Msg ("In " ^ path ^ ": " ^ m))
  |> Result.map (of_metadata ~source ~body_html ~tags)

let all () =
  Utils.map_files decode "planet/*/*.md"
  @ Utils.map_files decode "planet/*/*/*.md"
  |> List.sort (fun a b -> String.compare b.date a.date)

let pp_meta ppf v =
  Fmt.pf ppf {|---
%s---
|}
    (metadata_to_yaml v |> Yaml.to_string |> Result.get_ok)

let template () =
  Format.asprintf
    {|
module Source = struct
  type t = { id : string option; name : string; url : string }
end

type t =
  { title : string
  ; slug : string
  ; source : Source.t
  ; description : string option
  ; authors : string list option
  ; url : string option
  ; date : string
  ; preview_image : string option
  ; featured : bool
  ; body_html : string
  ;tags : string list;
  }
  
let all = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())

module Feed = struct
  let create_ocamlorg_feed () =
    let id = Uri.of_string "https://ocaml.org/feed.xml" in
    let title : Syndic.Atom.title = Text "The OCaml Planet" in
    let now = Ptime.of_float_s (Unix.gettimeofday ()) |> Option.get in
    let cutoff_date =
      Ptime.sub_span now (Ptime.Span.v (90, 0L)) |> Option.get
    in

    let entries =
      all ()
      |> List.map (fun (post : t) ->
             let content = Syndic.Atom.Html (None, post.body_html) in
             let url = Uri.of_string post.source.url in
             let source : Syndic.Atom.source =
               Syndic.Atom.source ~authors:[] ~id:url
                 ~title:(Syndic.Atom.Text post.source.name)
                 ~links:[ Syndic.Atom.link url ]
                 ?updated:None ?categories:None ?contributors:None
                 ?generator:None ?icon:None ?logo:None ?rights:None
                 ?subtitle:None
             in
             let id =
               Uri.of_string
                 (Option.fold
                    ~none:("https://ocaml.org/blog/" ^ post.slug)
                    ~some:(fun u -> u)
                    post.url)
             in
             let authors =
               Option.fold ~none:[]
                 ~some:(fun authors ->
                   List.map (fun a -> Syndic.Atom.author a) authors)
                 post.authors
             in
             let authors =
               match authors with
               | x :: xs -> (x, xs)
               | [] -> (Syndic.Atom.author "other", [])
             in
             let updated = Syndic.Date.of_rfc3339 post.date in
             Syndic.Atom.entry ~content ~source ~id ~authors
               ~title:(Syndic.Atom.Text post.title) ~updated
               ~links:[ Syndic.Atom.link id ]
               ())
      |> List.filter (fun (entry : Syndic.Atom.entry) ->
             Ptime.is_later entry.updated ~than:cutoff_date)
      |> List.sort Syndic.Atom.descending
    in

    let updated = (List.hd entries).updated in
    Syndic.Atom.feed ~id ~title ~updated entries

  let create_feed () =
    create_ocamlorg_feed () |> Syndic.Atom.to_xml
    |> Syndic.XML.to_string ~ns_prefix:(fun s ->
           match s with "http://www.w3.org/2005/Atom" -> Some "" | _ -> None)
end

module Scraper = struct
  let fetch_feed (id, source) =
    try Some (id, River.fetch source)
    with e ->
      print_endline
        (Printf.sprintf "failed to scrape %s: %s" id (Printexc.to_string e));
      None

  let scrape_post ~source_id (post : River.post) =
    let title = River.title post in
    let slug = Utils.slugify title in
    let source_path = "data/planet/" ^ source_id in
    let output_file = source_path ^ "/" ^ slug ^ ".md" in
    if Sys.file_exists output_file then
      print_endline
        (Printf.sprintf "%s/%s already exist, not scraping again" source_id slug)
    else
      let url = River.link post in
      let date = River.date post |> Option.map Syndic.Date.to_rfc3339 in
      match (url, date) with
      | None, _ ->
          print_endline
            (Printf.sprintf "skipping %s/%s: item does not have a url" source_id
               slug)
      | _, None ->
          print_endline
            (Printf.sprintf "skipping %s/%s: item does not have a date"
               source_id slug)
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
              source = None;
            }
          in
          let s = Format.asprintf "%a\n%s\n" pp_meta metadata content in
          Printf.fprintf oc "%s" s;
          close_out oc

  let scrape_feed (id, (feed : River.feed)) =
    let posts = River.posts [ feed ] in
    posts |> List.iter (scrape_post ~source_id:id)

  let scrape () =
    let sources = Source.all () in
    sources
    |> List.map (fun ({ id; url; name } : Source.t) : (string * River.source) ->
           (Option.get id, { name; url }))
    |> List.filter_map fetch_feed |> List.iter scrape_feed
end
