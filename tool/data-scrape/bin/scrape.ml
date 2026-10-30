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

(* One-off backfill of [keywords:] front matter for existing Planet posts (issue
   #3875). Not part of the daily scrape. *)
let planet_keywords_cmd =
  let dry_run =
    let doc = "Print proposed keywords without writing any file." in
    Arg.(value & flag & info [ "dry-run" ] ~doc)
  in
  let limit =
    let doc = "Process at most $(docv) posts (for sampling)." in
    Arg.(value & opt (some int) None & info [ "limit" ] ~docv:"N" ~doc)
  in
  let source =
    let doc = "Restrict to the single planet source id $(docv)." in
    Arg.(value & opt (some string) None & info [ "source" ] ~docv:"ID" ~doc)
  in
  let all =
    let doc = "Re-process posts that already have keywords (default: skip)." in
    Arg.(value & flag & info [ "all" ] ~doc)
  in
  let cache_dir =
    let doc = "Directory for cached fetched article text." in
    Arg.(value & opt (some string) None & info [ "cache-dir" ] ~docv:"DIR" ~doc)
  in
  let report =
    let doc =
      "Write a review report to $(docv), listing unresolved, empty and thin \
       posts."
    in
    Arg.(value & opt (some string) None & info [ "report" ] ~docv:"FILE" ~doc)
  in
  let run dry_run limit source all cache_dir report =
    Blog_backfill.run ~dry_run ~limit ~source_filter:source
      ~only_missing:(not all) ~cache_dir ~report ()
  in
  Cmd.v
    (Cmd.info "planet-keywords"
       ~doc:"Backfill keywords for existing Planet posts (#3875)")
    Term.(const run $ dry_run $ limit $ source $ all $ cache_dir $ report)

let cmds =
  Cmd.group (Cmd.info "data-scrape")
    [ planet_cmd; video_cmd; platform_releases_cmd; planet_keywords_cmd ]

let () =
  Printexc.record_backtrace true;
  exit (Cmd.eval cmds)
