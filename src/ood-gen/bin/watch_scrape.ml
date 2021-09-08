open Piaf
open Lwt_result.Syntax

type watch = {
  name : string;
  embed_path : string;
  thumbnail_path : string;
  description : string option;
  published_at : string;
  updated_at : string;
  language : string;
  category : string;
}

type t = { watch : watch list }

(* Extract published_at date, I believe `originallyPublishedAt` applies to videos
   imported from other platforms and `publishedAt` to this videos directly uploaded.
   Either way one should exist. *)
let get_publish_date json =
  match Ezjsonm.find json [ "originallyPublishedAt" ] with
  | `Null -> (
      match Ezjsonm.find json [ "publishedAt" ] with
      | `String s -> s
      | _ -> failwith "Couldn't calculate the videos published date")
  | `String s -> s
  | _ -> failwith "Couldn't calculate the videos original publish date"

let get_update_date json =
  match Ezjsonm.find_opt json [ "updatedAt" ] with
  | Some (`String s) -> s
  | _ -> failwith "Couldn't find the video's updatedAt date"

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
    updated_at = get_update_date json;
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
        ("updated_at", `String t.updated_at);
        ("language", `String t.language);
        ("category", `String t.category);
      ])

let to_yaml t = `O [ ("watch", `A (List.map watch_to_yaml t.watch)) ]

let videos_url = Uri.of_string "https://watch.ocaml.org/api/v1/videos"

(* 100 is current maximum the API can return: https://github.com/Chocobozzz/PeerTube/blob/develop/support/doc/api/openapi.yaml#L6338 *)
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
  let* response =
    Client.Oneshot.get (Uri.add_query_params videos_url query_params)
  in
  let+ body = Body.to_string response.body in
  let body = Ezjsonm.value_from_string body in
  let data = Ezjsonm.(find body [ "data" ]) in
  let total = Ezjsonm.find body [ "total" ] |> Ezjsonm.get_int in
  (total, Ezjsonm.get_list of_json data)

let get_all_videos () =
  let get_videos_or_err results =
    try
      Ok
        (List.map
           (function Ok v -> v | Error err -> failwith (Error.to_string err))
           results)
    with Failure m -> Error (`Msg m)
  in
  let* total, first = get_videos () in
  let+ rest =
    if total > max_count_per_request then
      (* Plus one for the remainder of the videos *)
      let reqs = (total / max_count_per_request) + 1 in
      (* Skip first amount as we have them *)
      let offsets = List.init reqs (fun i -> max_count_per_request * (i + 1)) in
      let* videos =
        Lwt_result.ok
        @@ Lwt_list.map_p
             (fun start ->
               let+ _total, videos = get_videos ~start () in
               videos)
             offsets
      in
      Lwt.return (get_videos_or_err videos)
    else Lwt.return (Ok [])
  in
  List.concat (first :: rest)

let run () =
  match Lwt_main.run @@ get_all_videos () with
  | Ok v -> v
  | Error err ->
      Fmt.epr "%s" (Error.to_string err);
      exit 1

let () =
  let watch =
    run () |> List.stable_sort (fun w1 w2 -> String.compare w1.name w2.name)
  in
  let videos = { watch } in
  let yaml = to_yaml videos in
  Yaml.pp Format.std_formatter yaml
