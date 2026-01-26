(* Video parser - adapted from ood-gen/lib/vid.ml and vid.ml *)

open Import

type t = [%import: Data_intf.Video.t] [@@deriving of_yaml, show]
type video_list = t list [@@deriving of_yaml, show]

let load_video_file file : t list =
  let ( let* ) = Result.bind in
  let result =
    let* yaml = Utils.yaml_file file in
    video_list_of_yaml yaml |> Result.map_error (Utils.where file)
  in
  result |> Result.get_ok ~error:(fun (`Msg msg) -> Exn.Decode_error msg)

let youtube_all () : t list = load_video_file "video-youtube.yml"
let watch_all () : t list = load_video_file "video-watch.yml"
let all () : t list = youtube_all () @ watch_all ()
