let all () = Youtube.all () @ Watch.all ()

let template () =
  Format.asprintf {ocaml|
include Data_intf.Video
let all =%a
|ocaml}
    Vid.pp_video_list (all ())

let scrape () =
  Youtube.scrape "data/video-youtube.yml";
  Watch.scrape "data/video-watch.yml"
