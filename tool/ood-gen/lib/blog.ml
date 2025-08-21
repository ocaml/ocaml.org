open Ocamlorg.Import

(* external RSS feeds that we aggregate - they will all be scraped by the
   scrape.yml workflow *)

type source = [%import: Data_intf.Blog.source] [@@deriving show]

module Source = struct
  type t = {
    id : string;
    name : string;
    url : string;
    only_ocaml : bool option;
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
        |> List.map (fun { id; name; url; only_ocaml; disabled } ->
               {
                 Data_intf.Blog.id;
                 name;
                 url;
                 description = "";
                 only_ocaml = Option.value ~default:true only_ocaml;
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

  let of_metadata ~source ~body_html m : Data_intf.Blog.post option =
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
                      only_ocaml = false;
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
          body_html;
        }

  let pp_meta ppf v =
    Fmt.pf ppf {|---
%s---
|}
      (metadata_to_yaml v |> Yaml.to_string
      |> Result.get_ok ~error:(fun (`Msg m) -> Exn.Decode_error m))

  let decode (fpath, (head, body_md)) =
    let metadata =
      metadata_of_yaml head |> Result.map_error (Utils.where fpath)
    in
    let body_html =
      body_md |> Markdown.Content.of_string
      |> Markdown.Content.render ~syntax_highlighting:true
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
    |> Result.map (of_metadata ~source ~body_html)

  let all () : Data_intf.Blog.post list =
    Utils.map_md_files decode "planet/*/*.md"
    |> List.filter_map (fun x -> x)
    |> List.sort (fun (a : Data_intf.Blog.post) (b : Data_intf.Blog.post) ->
           String.compare b.date a.date)
end

module Scraper = struct
  let fetch_feed (id, source) =
    try Some (id, River.fetch source)
    with e ->
      print_endline
        (Printf.sprintf "failed to scrape %s: %s" id (Printexc.to_string e));
      None

  let scrape_post ~source (post : River.post) =
    let title = River.title post in
    let slug = Utils.slugify title in
    let source_path = "data/planet/" ^ source.Data_intf.Blog.id in
    print_string
      (Printf.sprintf "\nprocesing %s/%s " source.Data_intf.Blog.id slug);
    let output_file = source_path ^ "/" ^ slug ^ ".md" in
    if not (Sys.file_exists output_file) then
      let url = River.link post in
      let date = River.date post |> Option.map Syndic.Date.to_rfc3339 in
      match (url, date) with
      | None, _ -> print_string "skipping, item does not have a url"
      | _, None -> print_string "skipping, item does not have a date"
      | Some url, Some date ->
          if not (Sys.file_exists source_path) then Sys.mkdir source_path 0o775;
          let content = River.content post in
          if
            (not source.only_ocaml)
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
            let s = Format.asprintf "%a\n%s\n" Post.pp_meta metadata content in
            let oc = open_out output_file in
            Printf.fprintf oc "%s" s;
            close_out oc)
          else print_string "skipping, flagged as not caml related"

  let scrape_source source =
    try
      [ River.fetch { name = source.name; url = source.url } ]
      |> River.posts
      |> List.iter (scrape_post ~source)
    with e ->
      print_endline
        (Printf.sprintf "failed to scrape %s: %s" source.id
           (Printexc.to_string e))

  let scrape () =
    let sources = Source.all () in
    sources
    |> List.filter (fun ({ disabled; _ } : Data_intf.Blog.source) ->
           not disabled)
    |> List.iter scrape_source
end
