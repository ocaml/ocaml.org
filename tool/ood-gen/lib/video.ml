let all () = Youtube.all () @ Watch.all ()

let template () =
  Format.asprintf {ocaml|
include Data_intf.Video
let all =%a
|ocaml}
    Vid.pp_video_list (all ())

let scrape () =
  let yt_entries = Youtube.scrape "data/video-youtube.yml" in
  let watch_entries = Watch.scrape "data/video-watch.yml" in
  yt_entries @ watch_entries
