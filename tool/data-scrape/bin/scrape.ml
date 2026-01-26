(* Scraper executable *)

open Cmdliner
open Data_scrape

let planet_cmd =
  let run () = Blog_scraper.scrape () in
  Cmd.v (Cmd.info "planet") Term.(const run $ const ())

let video_cmd =
  let run () =
    Youtube_scraper.scrape "data/video-youtube.yml";
    Watch_scraper.scrape "data/video-watch.yml"
  in
  Cmd.v (Cmd.info "video") Term.(const run $ const ())

let platform_releases_cmd =
  let run () = Platform_release_scraper.scrape () in
  Cmd.v (Cmd.info "platform_releases") Term.(const run $ const ())

let cmds =
  Cmd.group (Cmd.info "data-scrape")
    [ planet_cmd; video_cmd; platform_releases_cmd ]

let () =
  Printexc.record_backtrace true;
  exit (Cmd.eval cmds)
