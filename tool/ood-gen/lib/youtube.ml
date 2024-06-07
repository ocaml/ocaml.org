open Ocamlorg.Import
open Data_intf.Youtube

type kind = Playlist | Channel

let kind_of_string = function
  | "playlist" -> Ok Playlist
  | "channel" -> Ok Channel
  | s -> Error (`Msg ("Unknown difficulty type: " ^ s))

let kind_to_string = function Playlist -> "playlist" | Channel -> "channel"
let kind_of_yaml = Utils.of_yaml kind_of_string "Expected a string for kind"

type source_metadata = {
  name : string;
  kind : kind;
  id : string;
  only_ocaml : bool option;
}
[@@deriving of_yaml]

type source = { name : string; kind : kind; id : string; only_ocaml : bool }
[@@deriving stable_record ~version:source_metadata ~modify:[ only_ocaml ]]

let source_of_yaml x =
  x |> source_metadata_of_yaml
  |> Result.map
       (source_of_source_metadata
          ~modify_only_ocaml:(Option.value ~default:false))

type source_list = source list [@@deriving of_yaml]

let source_to_url { kind; id; _ } =
  Uri.of_string @@ "https://www.youtube.com/feeds/videos.xml?"
  ^ kind_to_string kind ^ "_id=" ^ id

let source_to_id { kind; id; _ } =
  Printf.sprintf "yt:%s:%s" (kind_to_string kind) id

type video_list = t list [@@deriving yaml, show]

type tag =
  | Entry
  | Title of string
  | Content of string
  | Thumbnail of string
  | Description of string
  | Published of string
  | Author_name of string
  | Author_uri of string

let walk_mrss xml =
  let rec loop tags () =
    let open Seq in
    let get_url = List.assoc ("", "url") in
    match (Xmlm.input xml, tags) with
    | `El_start ((_, "entry"), _), _ -> Cons (Entry, loop ("entry" :: tags))
    | `El_start ((_, "content"), attrs), "group" :: _ ->
        Cons (Content (get_url attrs), loop ("content" :: tags))
    | `El_start ((_, "thumbnail"), attrs), "group" :: _ ->
        Cons (Thumbnail (get_url attrs), loop ("thumbnail" :: tags))
    | `El_start ((_, tag), _), _ -> loop (tag :: tags) ()
    | `El_end, [ _ ] -> Nil
    | `El_end, _ -> loop (List.tl tags) ()
    | `Data data, "title" :: "group" :: _ -> Cons (Title data, loop tags)
    | `Data data, "description" :: "group" :: _ ->
        Cons (Description data, loop tags)
    | `Data data, "published" :: "entry" :: _ -> Cons (Published data, loop tags)
    | `Data data, "name" :: "author" :: "entry" :: _ ->
        Cons (Author_name data, loop tags)
    | `Data data, "uri" :: "author" :: "entry" :: _ ->
        Cons (Author_uri data, loop tags)
    | _ -> loop tags ()
  in
  loop []

let set_0 (_, x1, x2, x3, x4, x5, x6) x0 = (Some x0, x1, x2, x3, x4, x5, x6)
let set_1 (x0, _, x2, x3, x4, x5, x6) x1 = (x0, Some x1, x2, x3, x4, x5, x6)
let set_2 (x0, x1, _, x3, x4, x5, x6) x2 = (x0, x1, Some x2, x3, x4, x5, x6)
let set_3 (x0, x1, x2, _, x4, x5, x6) x3 = (x0, x1, x2, Some x3, x4, x5, x6)
let set_4 (x0, x1, x2, x3, _, x5, x6) x4 = (x0, x1, x2, x3, Some x4, x5, x6)
let set_5 (x0, x1, x2, x3, x4, _, x6) x5 = (x0, x1, x2, x3, x4, Some x5, x6)
let set_6 (x0, x1, x2, x3, x4, x5, _) x6 = (x0, x1, x2, x3, x4, x5, Some x6)

let video_opt source = function
  | ( Some title,
      Some content,
      Some thumbnail,
      Some description,
      Some published,
      Some author_name,
      Some author_uri ) ->
      Some
        {
          title;
          content;
          thumbnail;
          description;
          published;
          author_name;
          author_uri;
          source_link = source |> source_to_url |> Uri.to_string;
          source_title = source.name;
        }
  | _ -> None

let rec tags_to_video source vect = function
  | Title v :: tags -> tags_to_video source (set_0 vect v) tags
  | Content v :: tags -> tags_to_video source (set_1 vect v) tags
  | Thumbnail v :: tags -> tags_to_video source (set_2 vect v) tags
  | Description v :: tags -> tags_to_video source (set_3 vect v) tags
  | Published v :: tags -> tags_to_video source (set_4 vect v) tags
  | Author_name v :: tags -> tags_to_video source (set_5 vect v) tags
  | Author_uri v :: tags -> tags_to_video source (set_6 vect v) tags
  | [] -> video_opt source vect
  | _ -> None

let rec feed_entry source tags seq =
  match seq () with
  | Seq.Cons (Entry, seq) -> (
      match
        tags_to_video source (None, None, None, None, None, None, None) tags
      with
      | Some v -> Some (v, seq)
      | _ -> feed_entry source [] seq)
  | Cons (tag, seq) -> feed_entry source (tag :: tags) seq
  | Seq.Nil -> None

let all () =
  let ( let* ) = Result.bind in
  let videos =
    let file = "youtube.yml" in
    let* yaml = Utils.yaml_file file in
    yaml |> video_list_of_yaml |> Result.map_error (Utils.where file)
  in
  match videos with Ok videos -> videos | Error _ -> []

module VideoSet = Set.Make (struct
  type nonrec t = t

  let compare a b = compare a.content b.content
end)

let scrape () =
  let ( let* ) = Result.bind in
  let scraped = all () |> VideoSet.of_list in
  let fetched =
    let file = "youtube-sources.yml" in
    let* yaml = Utils.yaml_file file in
    let* sources =
      yaml |> source_list_of_yaml |> Result.map_error (Utils.where file)
    in
    sources |> List.to_seq
    |> Seq.concat_map (fun src ->
           src |> source_to_url |> Http_client.get_sync |> fun feed ->
           Xmlm.make_input (`String (0, feed))
           |> walk_mrss
           |> Seq.unfold (feed_entry src [])
           |> Seq.filter (fun video ->
                  (not src.only_ocaml)
                  || String.(
                       is_sub_ignore_case "ocaml" video.title
                       || is_sub_ignore_case "ocaml" video.description)))
    |> VideoSet.of_seq |> Result.ok
  in
  match fetched with
  | Ok fetched ->
      let yaml =
        VideoSet.union fetched scraped
        |> VideoSet.to_seq |> List.of_seq
        |> List.sort (fun a b -> compare b.published a.published)
        |> video_list_to_yaml
      in
      let output =
        Yaml.pp Format.str_formatter yaml;
        Format.flush_str_formatter ()
      in
      let oc = open_out "data/youtube.yml" in
      Printf.fprintf oc "%s" output;
      close_out oc
  | Error (`Msg msg) -> failwith msg

let template () =
  Format.asprintf {ocaml|
include Data_intf.Youtube
let all =%a
|ocaml}
    pp_video_list (all ())

let create_entry (v : t) =
  let url = Uri.of_string v.content in
  let source : Syndic.Atom.source =
    Syndic.Atom.source ~authors:[]
      ~id:(Uri.of_string v.source_link)
      ~title:(Syndic.Atom.Text v.source_title)
      ~links:[ Syndic.Atom.link (Uri.of_string v.source_link) ]
      ?updated:None ?categories:None ?contributors:None ?generator:None
      ?icon:None ?logo:None ?rights:None ?subtitle:None
  in
  let content = Syndic.Atom.Text v.description in
  let id = url in
  let authors =
    (Syndic.Atom.author ~uri:(Uri.of_string v.author_uri) v.author_name, [])
  in
  let updated = Syndic.Date.of_rfc3339 v.published in
  Syndic.Atom.entry ~content ~source ~id ~authors
    ~title:(Syndic.Atom.Text v.title) ~updated
    ~links:[ Syndic.Atom.link id ]
    ()

let create_feed () =
  let open Rss in
  () |> all
  |> create_feed ~id:"video.xml" ~title:"OCaml Videos" ~create_entry ~span:3653
  |> feed_to_string
