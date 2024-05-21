(* https://news.ycombinator.com/item?id=32191947

   https://www.youtube.com/feeds/videos.xml?channel_id=UCvVVfCa7-nzSuCdMKXnNJNQ
   https://www.youtube.com/feeds/videos.xml?playlist_id=PLre5AT9JnKShBOPeuiD9b-I4XROIJhkIU *)

type kind = Playlist | Channel

let kind_of_string = function
  | "playlist" -> Ok Playlist
  | "channel" -> Ok Channel
  | s -> Error (`Msg ("Unknown difficulty type: " ^ s))

let kind_to_string = function Playlist -> "playlist" | Channel -> "channel"
let kind_of_yaml = Utils.of_yaml kind_of_string "Expected a string for kind"

type source = { name : string; kind : kind; id : string } [@@deriving of_yaml]
type source_list = source list [@@deriving of_yaml]

let source_to_url { kind; id; _ } =
  Uri.of_string @@ "https://www.youtube.com/feeds/videos.xml?"
  ^ kind_to_string kind ^ "_id=" ^ id

type t = {
  title : string;
  content : string;
  thumbnail : string;
  description : string;
}
[@@deriving yaml, show { with_path = false }]

type video_list = t list [@@deriving yaml]

let mrss = "http://search.yahoo.com/mrss/"

type tag =
  | Title of string
  | Content of string
  | Thumbnail of string
  | Description of string

let walk_mrss xml =
  let rec loop xml tag depth =
    let get_url = List.assoc ("", "url") in
    match Xmlm.input xml with
    | `El_start ((ns, "group"), _) when ns = mrss ->
        Seq.cons None (loop xml None (depth + 1))
    | `El_start ((ns, "content"), attrs) when ns = mrss ->
        Seq.cons (Some (Content (get_url attrs))) (loop xml None (depth + 1))
    | `El_start ((ns, "thumbnail"), attrs) when ns = mrss ->
        Seq.cons (Some (Thumbnail (get_url attrs))) (loop xml None (depth + 1))
    | `El_start ((ns, tag), _) when ns = mrss -> loop xml (Some tag) (depth + 1)
    | `El_start _ -> loop xml None (depth + 1)
    | `El_end -> if depth = 1 then Seq.empty else loop xml None (depth - 1)
    | `Data data when tag = Some "title" ->
        Seq.cons (Some (Title data)) (loop xml tag depth)
    | `Data data when tag = Some "description" ->
        Seq.cons (Some (Description data)) (loop xml tag depth)
    | _ -> loop xml tag depth
  in
  loop xml None 0

let rec tags_to_video = function
  | Title title :: tags, _, content, thumbnail, description ->
      tags_to_video (tags, Some title, content, thumbnail, description)
  | Content content :: tags, title, _, thumbnail, description ->
      tags_to_video (tags, title, Some content, thumbnail, description)
  | Thumbnail thumbnail :: tags, title, content, _, description ->
      tags_to_video (tags, title, content, Some thumbnail, description)
  | Description description :: tags, title, content, thumbnail, _ ->
      tags_to_video (tags, title, content, thumbnail, Some description)
  | [], Some title, Some content, Some thumbnail, Some description ->
      Some { title; content; thumbnail; description }
  | _ -> None

let rec feed_media tags seq () =
  match seq () with
  | Seq.Cons (None, seq) -> (
      let seq = feed_media [] seq in
      match tags_to_video (tags, None, None, None, None) with
      | Some v
      (* when Ocamlorg.Import.String.contains_s (String.lowercase_ascii
         v.description) "ocaml" *) ->
          Seq.Cons (v, seq)
      | _ -> seq ())
  | Seq.Cons (Some tag, seq) -> feed_media (tag :: tags) seq ()
  | Seq.Nil -> Seq.Nil

let scrape () =
  let ( let* ) = Result.bind in
  let yaml =
    let file = "youtube-sources.yml" in
    let* yaml = Utils.yaml_file file in
    let* sources =
      yaml |> source_list_of_yaml |> Result.map_error (Utils.where file)
    in
    sources |> List.to_seq
    |> Seq.map (fun src -> src |> source_to_url |> Http_client.get_sync)
    |> Seq.concat_map (fun feed ->
           Xmlm.make_input (`String (0, feed)) |> walk_mrss |> feed_media [])
    |> List.of_seq |> video_list_to_yaml |> Result.ok
  in
  match yaml with
  | Ok yaml ->
      let output =
        Yaml.pp Format.str_formatter yaml;
        Format.flush_str_formatter ()
      in
      let oc = open_out "data/youtube.yml" in
      Printf.fprintf oc "%s" output;
      close_out oc
  | Error (`Msg msg) -> failwith msg

let all () =
  let ( let* ) = Result.bind in
  let videos =
    let file = "youtube.yml" in
    let* yaml = Utils.yaml_file file in
    yaml |> video_list_of_yaml |> Result.map_error (Utils.where file)
  in
  match videos with
  | Ok videos ->
      videos
      |> List.filter (fun v ->
             Ocamlorg.Import.String.contains_s
               (String.lowercase_ascii v.description)
               "ocaml")
  | Error (`Msg msg) -> failwith msg

let template () =
  Format.asprintf
    {ocaml|
type t = {
  title : string;
  content : string;
  thumbnail : string;
  description : string;
}

let all =%a
|ocaml}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
