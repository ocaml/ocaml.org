(* Blog scraper for OCaml Planet *)

open Data_packer.Import

(* external RSS feeds that we aggregate - they will all be scraped by the
   scrape.yml workflow *)

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
      let* yaml = Data_packer.Utils.yaml_file file in
      let* sources =
        sources_of_yaml yaml |> Result.map_error (Data_packer.Utils.where file)
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
           Data_packer.Exn.Decode_error (file ^ ": " ^ msg))
end

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

  let pp_meta ppf v =
    Fmt.pf ppf {|---
%s---
|}
      (metadata_to_yaml v |> Yaml.to_string
      |> Result.get_ok ~error:(fun (`Msg m) -> Data_packer.Exn.Decode_error m))
end

let scrape_post ~source (post : River.post) =
  let title = River.title post in
  let slug = Data_packer.Utils.slugify title in
  let source_path = "data/planet/" ^ source.Data_intf.Blog.id in
  print_string
    (Printf.sprintf "\nprocessing %s/%s " source.Data_intf.Blog.id slug);
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
