type watch = {
  name : string;
  embed_path : string;
  thumbnail_path : string;
  description : string option;
  published_at : string;
  language : string;
  category : string;
}

type t = { watch : watch list }

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

(* extract value of language and category *)
let get_language_category json =
  let label = Ezjsonm.find json [ "label" ] in
  Ezjsonm.get_string label

let get_string_or_none = function `String s -> Some s | _ -> None

let of_json json =
  {
    name = Ezjsonm.find json [ "name" ] |> Ezjsonm.get_string;
    description = Ezjsonm.find json [ "description" ] |> get_string_or_none;
    embed_path = Ezjsonm.find json [ "embedPath" ] |> Ezjsonm.get_string;
    thumbnail_path = Ezjsonm.find json [ "thumbnailPath" ] |> Ezjsonm.get_string;
    published_at = get_publish_date json;
    language = Ezjsonm.find json [ "language" ] |> get_language_category;
    category = Ezjsonm.find json [ "category" ] |> get_language_category;
  }

let watch_to_yaml t =
  `O
    ([ ("name", `String t.name) ]
    @ (match t.description with
      | Some s -> [ ("description", `String s) ]
      | None -> [])
    @ [
        ("embed_path", `String t.embed_path);
        ("thumbnail_path", `String t.thumbnail_path);
        ("published_at", `String t.published_at);
        ("language", `String t.language);
        ("category", `String t.category);
      ])

let to_yaml t = `O [ ("watch", `A (List.map watch_to_yaml t.watch)) ]
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
  let response = Ood_gen.Http_client.get_sync uri in
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

let () =
  let watch =
    get_all_videos ()
    |> List.stable_sort (fun w1 w2 -> String.compare w1.name w2.name)
  in
  let videos = { watch } in
  let yaml = to_yaml videos in
  Yaml.pp Format.std_formatter yaml
