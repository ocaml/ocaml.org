(* Scraper executable *)

open Cmdliner
open Data_scrape

let commit_file_arg =
  let doc = "Write commit message to $(docv)." in
  Arg.(
    value & opt (some string) None & info [ "commit-file" ] ~docv:"FILE" ~doc)

let report_file_arg =
  let doc = "Write full report to $(docv) (for PR body)." in
  Arg.(
    value & opt (some string) None & info [ "report-file" ] ~docv:"FILE" ~doc)

let planet_cmd =
  let run commit_file report_file =
    let entries = Blog_scraper.scrape () in
    Option.iter
      (fun p -> Scrape_report.write_commit_message p entries)
      commit_file;
    Option.iter (fun p -> Scrape_report.write_report p entries) report_file
  in
  Cmd.v (Cmd.info "planet") Term.(const run $ commit_file_arg $ report_file_arg)

let video_cmd =
  let run commit_file report_file =
    let entries =
      Youtube_scraper.scrape "data/video-youtube.yml"
      @ Watch_scraper.scrape "data/video-watch.yml"
    in
    Option.iter
      (fun p -> Scrape_report.append_commit_message p entries)
      commit_file;
    Option.iter (fun p -> Scrape_report.append_report p entries) report_file
  in
  Cmd.v (Cmd.info "video") Term.(const run $ commit_file_arg $ report_file_arg)

let platform_releases_cmd =
  let run () = Platform_release_scraper.scrape () in
  Cmd.v (Cmd.info "platform_releases") Term.(const run $ const ())

let cmds =
  Cmd.group (Cmd.info "data-scrape")
    [ planet_cmd; video_cmd; platform_releases_cmd ]

let () =
  Printexc.record_backtrace true;
  exit (Cmd.eval cmds)
