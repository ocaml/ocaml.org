open Piaf

type t = {
  name : string;
  embedPath : string;
  thumbnailPath : string;
  description : string;
  year : string;
  language : string;
  category : string;
}

(* Handling Ezjsonm.get_string Parse error *)
let get_string_from_value json =
  try Ezjsonm.get_string json
  with Ezjsonm.Parse_error (`Null, "Ezjsonm.get_string") -> ""

(* extract year from originally published date string *)
let get_year json =
  let s = Ezjsonm.get_string json in
  String.sub s 0 4

(* extract value of language and category *)
let get_language_category json =
  let label = Ezjsonm.find json [ "label" ] in
  Ezjsonm.get_string label

let of_json json =
  {
    name = Ezjsonm.find json [ "name" ] |> Ezjsonm.get_string;
    description = Ezjsonm.find json [ "description" ] |> get_string_from_value;
    embedPath = Ezjsonm.find json [ "embedPath" ] |> Ezjsonm.get_string;
    thumbnailPath = Ezjsonm.find json [ "thumbnailPath" ] |> Ezjsonm.get_string;
    year = Ezjsonm.find json [ "originallyPublishedAt" ] |> get_year;
    language = Ezjsonm.find json [ "language" ] |> get_language_category;
    category = Ezjsonm.find json [ "category" ] |> get_language_category;
  }

let to_yaml t =
  `O
    [
      ("name", `String t.name);
      ("description", `String t.description);
      ("embedPath", `String t.embedPath);
      ("thumbnailPath", `String t.thumbnailPath);
      ("year", `String t.year);
      ("language", `String t.language);
      ("category", `String t.category);
    ]

let get_sync url =
  let open Lwt_result.Syntax in
  Lwt_main.run
    ( print_endline "Sending request...";

      let* response = Client.Oneshot.get (Uri.of_string url) in

      if Status.is_successful response.status then Body.to_string response.body
      else
        let message = Status.to_string response.status in
        Lwt.return (Error (`Msg message)) )

let () =
  let data () =
    match get_sync "https://watch.ocaml.org/api/v1/videos" with
    | Ok body -> Ezjsonm.value_from_string body
    | Error error ->
        let message = Error.to_string error in
        failwith message
  in

  let v = data () in
  let videos_json = Ezjsonm.find v [ "data" ] in
  let videos = Ezjsonm.get_list of_json videos_json in
  let yaml = `A (List.map to_yaml videos) in
  Yaml.pp Format.std_formatter yaml
