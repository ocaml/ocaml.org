(* Generate RSS/Atom feeds from packed data *)

open Cmdliner
open Data_packer

let load_data () =
  (* Load data directly from source files *)
  Packer.load_all ()

let backstage_cmd =
  let run () =
    let data = load_data () in
    print_endline (Feed.Backstage.create_feed data.backstage)
  in
  Cmd.v (Cmd.info "backstage") Term.(const run $ const ())

let changelog_cmd =
  let run () =
    let data = load_data () in
    print_endline (Feed.Changelog.create_feed data.changelog)
  in
  Cmd.v (Cmd.info "changelog") Term.(const run $ const ())

let events_cmd =
  let run () =
    let data = load_data () in
    print_endline (Feed.Events.create_feed data.events)
  in
  Cmd.v (Cmd.info "events") Term.(const run $ const ())

let news_cmd =
  let run () =
    let data = load_data () in
    print_endline (Feed.News.create_feed data.news)
  in
  Cmd.v (Cmd.info "news") Term.(const run $ const ())

let planet_cmd =
  let run () =
    let data = load_data () in
    print_endline (Feed.Planet.create_feed data.planet)
  in
  Cmd.v (Cmd.info "planet") Term.(const run $ const ())

let job_cmd =
  let run () =
    let data = load_data () in
    print_endline (Feed.Job.create_feed data.jobs)
  in
  Cmd.v (Cmd.info "job") Term.(const run $ const ())

let cmds =
  Cmd.group (Cmd.info "feed" ~version:"%%VERSION%%")
    [ backstage_cmd; changelog_cmd; events_cmd; news_cmd; planet_cmd; job_cmd ]

let () =
  Printexc.record_backtrace true;
  exit (Cmd.eval cmds)
