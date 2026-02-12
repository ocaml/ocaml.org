open Ocamlorg.Import

(* external RSS feeds that we aggregate - they will all be scraped by the
   scrape.yml workflow *)

type source = [%import: Data_intf.Blog.source] [@@deriving show]

module Source = struct
  type t = {
    id : string;
    name : string;
    url : string;
    publish_all : bool option;
    disabled : bool option;
  }
  [@@deriving yaml]

  type sources = t list [@@deriving yaml]

  let all () : Data_intf.Blog.source list =
    let file = "planet-sources.yml" in
    let result =
      let ( let* ) = Result.bind in
      let* yaml = Utils.yaml_file file in
      let* sources =
        sources_of_yaml yaml |> Result.map_error (Utils.where file)
      in
      Ok
        (sources
        |> List.map (fun { id; name; url; publish_all; disabled } ->
               {
                 Data_intf.Blog.id;
                 name;
                 url;
                 description = "";
                 publish_all = Option.value ~default:true publish_all;
                 disabled = Option.value ~default:false disabled;
               }))
    in
    result
    |> Result.get_ok ~error:(fun (`Msg msg) ->
           Exn.Decode_error (file ^ ": " ^ msg))
end

type post = [%import: Data_intf.Blog.post] [@@deriving show]

module Post = struct
  type source_on_external_post = { name : string; url : string }
  [@@deriving yaml]

  type metadata = {
    title : string;
    description : string option;
    url : string;
    date : string;
    preview_image : string option;
    authors : string list option;
    source : source_on_external_post option;
    ignore : bool option;
  }
  [@@deriving yaml]

  let all_sources = Source.all ()

  let of_metadata ~source m : Data_intf.Blog.post option =
    if Option.value ~default:false m.ignore then None
    else
      Some
        {
          title = m.title;
          source =
            (match source with
            | Ok s -> s
            | Error (`Msg e) -> (
                match m.source with
                | Some { name; url } ->
                    {
                      id = "";
                      name;
                      url;
                      description = "";
                      publish_all = true;
                      disabled = false;
                    }
                | None ->
                    failwith
                      (e
                     ^ " and there is no source defined in the markdown file")));
          url = m.url;
          slug = "";
          description = m.description;
          authors = Option.value ~default:[] m.authors;
          date = m.date;
          preview_image = m.preview_image;
        }

  let pp_meta ppf v =
    Fmt.pf ppf {|---
%s---
|}
      (metadata_to_yaml v |> Yaml.to_string
      |> Result.get_ok ~error:(fun (`Msg m) -> Exn.Decode_error m))

  let decode (fpath, (head, _)) =
    let metadata =
      metadata_of_yaml head |> Result.map_error (Utils.where fpath)
    in
    let source =
      match Str.split (Str.regexp_string "/") fpath with
      | _ :: second :: _ -> (
          match
            List.find_opt
              (fun (s : Data_intf.Blog.source) -> s.id = second)
              all_sources
          with
          | Some source -> Ok source
          | None -> Error (`Msg ("No source found for: " ^ fpath)))
      | _ ->
          failwith
            ("Trying to determine the source for " ^ fpath
           ^ " but the path is not long enough (should start with \
              planet/SOURCE_NAME/...)")
    in
    metadata
    |> Result.map_error (Utils.where fpath)
    |> Result.map (of_metadata ~source)

  let all () : Data_intf.Blog.post list =
    Utils.map_md_files decode "planet/*/*.md"
    |> List.filter_map (fun x -> x)
    |> List.sort (fun (a : Data_intf.Blog.post) (b : Data_intf.Blog.post) ->
           String.compare b.date a.date)
end

module Scraper = struct
  let scrape_post ~source (post : River.post) : Scrape_report.entry option =
    let title = River.title post in
    let slug = Utils.slugify title in
    let source_path = "data/planet/" ^ source.Data_intf.Blog.id in
    print_string
      (Printf.sprintf "\nprocessing %s/%s " source.Data_intf.Blog.id slug);
    let output_file = source_path ^ "/" ^ slug ^ ".md" in
    if not (Sys.file_exists output_file) then (
      let url = River.link post in
      let date = River.date post |> Option.map Syndic.Date.to_rfc3339 in
      match (url, date) with
      | None, _ ->
          print_string "skipping, item does not have a url";
          None
      | _, None ->
          print_string "skipping, item does not have a date";
          None
      | Some url, Some date ->
          if not (Sys.file_exists source_path) then Sys.mkdir source_path 0o775;
          let content = River.content post in
          if
            source.publish_all
            || String.(
                 is_sub_ignore_case "caml" content
                 || is_sub_ignore_case "caml" title)
          then (
            let url = String.trim (Uri.to_string url) in
            let preview_image = River.seo_image post in
            let description = River.meta_description post in
            let author = River.author post in
            let metadata : Post.metadata =
              {
                title;
                url;
                date;
                preview_image;
                description;
                authors = Some [ author ];
                source = None;
                ignore = None;
              }
            in
            let s = Format.asprintf "%a" Post.pp_meta metadata in
            let oc = open_out output_file in
            Printf.fprintf oc "%s" s;
            close_out oc;
            Some
              (Scrape_report.New_post
                 { source_id = source.Data_intf.Blog.id; title }))
          else (
            print_string "skipping, flagged as not caml related";
            None))
    else None

  let scrape_source (source : Data_intf.Blog.source) : Scrape_report.entry list
      =
    try
      [ River.fetch { name = source.name; url = source.url } ]
      |> River.posts
      |> List.filter_map (scrape_post ~source)
    with e ->
      let message = Printexc.to_string e in
      print_endline (Printf.sprintf "failed to scrape %s: %s" source.id message);
      [ Scrape_report.Error { source_id = source.id; message } ]

  let scrape () : Scrape_report.entry list =
    Source.all ()
    |> List.filter (fun ({ disabled; _ } : Data_intf.Blog.source) ->
           not disabled)
    |> List.concat_map scrape_source
end
