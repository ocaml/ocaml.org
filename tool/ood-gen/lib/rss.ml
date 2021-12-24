type source =
  { name : string
  ; url : string
  ; tag : string
  ; articles : string list
  }
[@@deriving yaml]

type sources = { sources : source list } [@@deriving yaml]

type metadata =
  { title : string
  ; description : string option
  ; url : string
  ; date : string
  ; preview_image : string option
  ; featured : bool option
  }
[@@deriving yaml]

let decode_sources s =
  let yaml = Utils.decode_or_raise Yaml.of_string s in
  Utils.decode_or_raise sources_of_yaml yaml

let all_sources () =
  let content = Data.read "rss-sources.yml" |> Option.get in
  decode_sources content

let pp_meta ppf v =
  Fmt.pf
    ppf
    {|---
%s---
|}
    (metadata_to_yaml v |> Yaml.to_string |> Result.get_ok)

let scrape () =
  let sources = all_sources () in
  List.map
    (fun (source : source) ->
      let rss_string = Http_client.get_sync source.url |> Result.get_ok in
      let channel, _ = Ocamlrss.Rss.channel_of_string rss_string in
      let items = channel.Ocamlrss.Rss.ch_items in
      let () =
        List.iter
          (fun (item : unit Ocamlrss.Rss.item_t) ->
            let guid =
              match item.Ocamlrss.Rss.item_guid with
              | Some (Guid_permalink uri) ->
                Some (Uri.to_string uri)
              | Some (Guid_name s) ->
                Some s
              | None ->
                print_endline "No guid";
                None
            in
            try
              let guid = Option.get guid in
              let title = item.Ocamlrss.Rss.item_title |> Option.get in
              let slug = Utils.slugify title in
              let desc = item.Ocamlrss.Rss.item_desc in
              let data = item.Ocamlrss.Rss.item_content in
              let content =
                match desc, data with
                | Some _, Some data ->
                  data
                | Some desc, None ->
                  desc
                | None, Some data ->
                  data
                | None, None ->
                  print_endline "No description or content:encoded";
                  raise (Invalid_argument "")
              in
              let url =
                item.Ocamlrss.Rss.item_link |> Option.get |> Uri.to_string
              in
              let date =
                item.Ocamlrss.Rss.item_pubdate |> Option.get |> Ptime.to_rfc3339
              in
              if List.mem guid source.articles then (
                let oc =
                  open_out ("data/rss/" ^ source.tag ^ "/" ^ slug ^ ".md")
                in
                let Website_meta.{ image; description; _ } =
                  Website_meta.all url
                in
                let metadata =
                  { title
                  ; url
                  ; date
                  ; preview_image = image
                  ; description
                  ; featured = None
                  }
                in
                let s = Format.asprintf "%a\n%s\n" pp_meta metadata content in
                Printf.fprintf oc "%s" s;
                close_out oc)
            with
            | Invalid_argument _ ->
              Printf.printf
                "Skipping article %s\n"
                (Option.value guid ~default:"<no guid>");
              ())
          items
      in
      ())
    sources.sources

type t =
  { title : string
  ; slug : string
  ; url : string
  ; description : string option
  ; date : string
  ; preview_image : string option
  ; featured : bool
  ; body_html : string
  }
[@@deriving yaml]

let all () =
  Utils.map_files
    (fun content ->
      let metadata, body = Utils.extract_metadata_body content in
      let metadata = Utils.decode_or_raise metadata_of_yaml metadata in
      { title = metadata.title
      ; slug = Utils.slugify metadata.title
      ; description = metadata.description
      ; url = metadata.url
      ; date = metadata.date
      ; preview_image = metadata.preview_image
      ; featured = Option.value metadata.featured ~default:false
      ; body_html = String.trim body
      })
    "rss/*/*.md"
  |> List.sort (fun a b -> String.compare a.date b.date)
  |> List.rev

let pp ppf v =
  Fmt.pf
    ppf
    {|
  { title = %a
  ; slug = %a
  ; description = %a
  ; url = %a
  ; date = %a
  ; preview_image = %a
  ; featured = %a
  ; body_html = %a
  }|}
    Pp.string
    v.title
    Pp.string
    v.slug
    (Pp.option Pp.string)
    v.description
    Pp.string
    v.url
    Pp.string
    v.date
    (Pp.option Pp.string)
    v.preview_image
    Pp.bool
    v.featured
    Pp.string
    v.body_html

let pp_list = Pp.list pp

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
    pp_list
    (all ())
