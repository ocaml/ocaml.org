open Ocamlorg.Import
open Data_intf.Video

type video_list = t list [@@deriving yaml, show]

let all () =
  let ( let* ) = Result.bind in
  let videos =
    let file = "video-watch.yml" in
    let* yaml = Utils.yaml_file file in
    yaml |> video_list_of_yaml |> Result.map_error (Utils.where file)
  in
  Result.get_ok ~error:(fun (`Msg msg) -> Exn.Decode_error msg) videos

(* Extract published_at date, I believe `originallyPublishedAt` applies to
   videos imported from other platforms and `publishedAt` to this videos
   directly uploaded. Either way one should exist. *)
let get_publish_date json =
  match Ezjsonm.find json [ "originallyPublishedAt" ] with
  | `Null -> (
      match Ezjsonm.find json [ "publishedAt" ] with
      | `String s -> s
      | _ -> failwith "Couldn't calculate the videos published date")
  | `String s -> s
  | _ -> failwith "Couldn't calculate the videos original publish date"

let get_string_or_none = function `String s -> s | _ -> ""

let of_json json =
  {
    title = Ezjsonm.find json [ "name" ] |> Ezjsonm.get_string;
    description = Ezjsonm.find json [ "description" ] |> get_string_or_none;
    url = Ezjsonm.find json [ "url" ] |> Ezjsonm.get_string;
    thumbnail =
      "https://watch.ocaml.org"
      ^ (Ezjsonm.find json [ "thumbnailPath" ] |> Ezjsonm.get_string);
    published = get_publish_date json;
    author_name = "Unknown";
    author_uri = "https://watch.ocaml.org/";
    source_link = "https://watch.ocaml.org/";
    source_title = "Watch OCaml";
  }

let watch_to_yaml t =
  `O
    [
      ("title", `String t.title);
      ("description", `String t.description);
      ("url", `String t.url);
      ("thumbnail", `String t.thumbnail);
      ("published", `String t.published);
      ("author_name", `String t.author_name);
      ("author_uri", `String t.author_uri);
      ("source_link", `String t.source_link);
      ("source_title", `String t.source_title);
    ]

let to_yaml t = `A (List.map watch_to_yaml t)
let videos_url = Uri.of_string "https://watch.ocaml.org/api/v1/videos"

(* 100 is current maximum the API can return:
   https://github.com/Chocobozzz/PeerTube/blob/develop/support/doc/api/openapi.yaml#L6338 *)
let max_count_per_request = 100

let get_videos ?start () =
  let query_params =
    match start with
    | None -> [ ("count", [ string_of_int max_count_per_request ]) ]
    | Some s ->
        [
          ("start", [ string_of_int s ]);
          ("count", [ string_of_int max_count_per_request ]);
        ]
  in
  let uri = Uri.add_query_params videos_url query_params in
  let response = Http_client.get_sync uri in
  let body = Ezjsonm.value_from_string response in
  let data = Ezjsonm.(find body [ "data" ]) in
  let total = Ezjsonm.find body [ "total" ] |> Ezjsonm.get_int in
  (total, Ezjsonm.get_list of_json data)

let get_all_videos () =
  let total, data = get_videos () in
  let rec aux acc =
    if List.length acc < total then
      let _, new_videos = get_videos ~start:(List.length acc) () in
      aux (acc @ new_videos)
    else acc
  in
  aux data

let scrape yaml_file =
  let watch =
    get_all_videos ()
    |> List.stable_sort (fun w1 w2 -> String.compare w1.title w2.title)
  in
  let yaml = to_yaml watch in
  let output =
    Yaml.pp Format.str_formatter yaml;
    Format.flush_str_formatter ()
  in
  let oc = open_out yaml_file in
  Printf.fprintf oc "%s" output;
  close_out oc
