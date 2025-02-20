open Data_intf.Video

type video_list = t list [@@deriving show]

let all () = Youtube.all () @ Watch.all ()

let template () =
  Format.asprintf {ocaml|
include Data_intf.Video
let all =%a
|ocaml}
    pp_video_list (all ())

let scrape () =
  Youtube.scrape "data/video-youtube.yml";
  Watch.scrape "data/video-watch.yml"
