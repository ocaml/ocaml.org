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

let write_messages commit_file report_file entries =
  Option.iter
    (fun p -> Scrape_report.write_commit_message p entries)
    commit_file;
  Option.iter (fun p -> Scrape_report.write_report p entries) report_file

let scrape_videos () =
  Youtube_scraper.scrape "data/video-youtube.yml"
  @ Watch_scraper.scrape "data/video-watch.yml"

let planet_cmd =
  let with_videos =
    let doc =
      "Also scrape the videos, so that one commit message covers both."
    in
    Arg.(value & flag & info [ "with-videos" ] ~doc)
  in
  let run with_videos commit_file report_file =
    let entries = Blog_scraper.scrape () in
    let entries = if with_videos then entries @ scrape_videos () else entries in
    write_messages commit_file report_file entries
  in
  Cmd.v (Cmd.info "planet")
    Term.(const run $ with_videos $ commit_file_arg $ report_file_arg)

let video_cmd =
  let run commit_file report_file =
    write_messages commit_file report_file (scrape_videos ())
  in
  Cmd.v (Cmd.info "video") Term.(const run $ commit_file_arg $ report_file_arg)

let platform_releases_cmd =
  let run commit_file report_file =
    Platform_release_scraper.scrape ?commit_file ?report_file ()
  in
  Cmd.v
    (Cmd.info "platform_releases")
    Term.(const run $ commit_file_arg $ report_file_arg)

let opam_health_cmd =
  let base_url =
    let doc = "Base URL of the opam-health-check instance." in
    Arg.(
      value
      & opt string Opam_health_scraper.default_base_url
      & info [ "base-url" ] ~docv:"URL" ~doc)
  in
  let run base_url commit_file report_file =
    try Opam_health_scraper.scrape ~base_url ?commit_file ?report_file ()
    with Failure msg ->
      Printf.eprintf "[ERROR] opam-health: %s\n" msg;
      exit 1
  in
  Cmd.v
    (Cmd.info "opam_health"
       ~doc:"Scrape check.ci.ocaml.org build results into data/opam_health.yml")
    Term.(const run $ base_url $ commit_file_arg $ report_file_arg)

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

(* One-off shortening of over-long [description:] front matter in existing
   Planet posts. Not part of the daily scrape. *)
let planet_descriptions_cmd =
  let dry_run =
    let doc = "Print the new descriptions without writing any file." in
    Arg.(value & flag & info [ "dry-run" ] ~doc)
  in
  let source =
    let doc = "Restrict to the single planet source id $(docv)." in
    Arg.(value & opt (some string) None & info [ "source" ] ~docv:"ID" ~doc)
  in
  let run dry_run source =
    Description_backfill.run ~dry_run ~source_filter:source ()
  in
  Cmd.v
    (Cmd.info "planet-descriptions"
       ~doc:"Shorten over-long descriptions of existing Planet posts")
    Term.(const run $ dry_run $ source)

let cmds =
  Cmd.group (Cmd.info "data-scrape")
    [
      planet_cmd;
      video_cmd;
      platform_releases_cmd;
      opam_health_cmd;
      planet_keywords_cmd;
      planet_descriptions_cmd;
    ]

let () =
  Printexc.record_backtrace true;
  exit (Cmd.eval cmds)
